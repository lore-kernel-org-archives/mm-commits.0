From: akpm@linux-foundation.org
Subject: + ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:26:12 -0700
Message-ID: <200809171926.m8HJQCGu026649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbYIQT1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:27:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, eugeneteo@kernel.sg, tytso@mit.edu


The patch titled
     ext2: avoid printk floods in the face of directory corruption
has been added to the -mm tree.  Its filename is
     ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: avoid printk floods in the face of directory corruption
From: Eric Sandeen <sandeen@redhat.com>

Note: some people thinks this represents a security bug, since it might
make the system go away while it is printing a large number of console
messages, especially if a serial console is involved.  Hence, it has been
assigned CVE-2008-3528, but it requires that the attacker either has
physical access to your machine to insert a USB disk with a corrupted
filesystem image (at which point why not just hit the power button), or is
otherwise able to convince the system administrator to mount an arbitrary
filesystem image (at which point why not just include a setuid shell or
world-writable hard disk device file or some such).  Me, I think they're
just being silly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |   60 ++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff -puN fs/ext2/dir.c~ext2-avoid-printk-floods-in-the-face-of-directory-corruption fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-avoid-printk-floods-in-the-face-of-directory-corruption
+++ a/fs/ext2/dir.c
@@ -103,7 +103,7 @@ static int ext2_commit_chunk(struct page
 	return err;
 }
 
-static void ext2_check_page(struct page *page)
+static void ext2_check_page(struct page *page, int quiet)
 {
 	struct inode *dir = page->mapping->host;
 	struct super_block *sb = dir->i_sb;
@@ -146,10 +146,10 @@ out:
 	/* Too bad, we had an error */
 
 Ebadsize:
-	ext2_error(sb, "ext2_check_page",
-		"size of directory #%lu is not a multiple of chunk size",
-		dir->i_ino
-	);
+	if (!quiet)
+		ext2_error(sb, __func__,
+			"size of directory #%lu is not a multiple "
+			"of chunk size", dir->i_ino);
 	goto fail;
 Eshort:
 	error = "rec_len is smaller than minimal";
@@ -166,32 +166,36 @@ Espan:
 Einumber:
 	error = "inode out of bounds";
 bad_entry:
-	ext2_error (sb, "ext2_check_page", "bad entry in directory #%lu: %s - "
-		"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
-		dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
-		(unsigned long) le32_to_cpu(p->inode),
-		rec_len, p->name_len);
+	if (!quiet)
+		ext2_error(sb, __func__, "bad entry in directory #%lu: : %s - "
+			"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
+			dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
+			(unsigned long) le32_to_cpu(p->inode),
+			rec_len, p->name_len);
 	goto fail;
 Eend:
-	p = (ext2_dirent *)(kaddr + offs);
-	ext2_error (sb, "ext2_check_page",
-		"entry in directory #%lu spans the page boundary"
-		"offset=%lu, inode=%lu",
-		dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
-		(unsigned long) le32_to_cpu(p->inode));
+	if (!quiet) {
+		p = (ext2_dirent *)(kaddr + offs);
+		ext2_error (sb, "ext2_check_page",
+			"entry in directory #%lu spans the page boundary"
+			"offset=%lu, inode=%lu",
+			dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
+			(unsigned long) le32_to_cpu(p->inode));
+	}
 fail:
 	SetPageChecked(page);
 	SetPageError(page);
 }
 
-static struct page * ext2_get_page(struct inode *dir, unsigned long n)
+static struct page * ext2_get_page(struct inode *dir, unsigned long n,
+				   int quiet)
 {
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page = read_mapping_page(mapping, n, NULL);
 	if (!IS_ERR(page)) {
 		kmap(page);
 		if (!PageChecked(page))
-			ext2_check_page(page);
+			ext2_check_page(page, quiet);
 		if (PageError(page))
 			goto fail;
 	}
@@ -292,7 +296,7 @@ ext2_readdir (struct file * filp, void *
 	for ( ; n < npages; n++, offset = 0) {
 		char *kaddr, *limit;
 		ext2_dirent *de;
-		struct page *page = ext2_get_page(inode, n);
+		struct page *page = ext2_get_page(inode, n, 0);
 
 		if (IS_ERR(page)) {
 			ext2_error(sb, __func__,
@@ -361,6 +365,7 @@ struct ext2_dir_entry_2 *ext2_find_entry
 	struct page *page = NULL;
 	struct ext2_inode_info *ei = EXT2_I(dir);
 	ext2_dirent * de;
+	int dir_has_error = 0;
 
 	if (npages == 0)
 		goto out;
@@ -374,7 +379,7 @@ struct ext2_dir_entry_2 *ext2_find_entry
 	n = start;
 	do {
 		char *kaddr;
-		page = ext2_get_page(dir, n);
+		page = ext2_get_page(dir, n, dir_has_error);
 		if (!IS_ERR(page)) {
 			kaddr = page_address(page);
 			de = (ext2_dirent *) kaddr;
@@ -391,7 +396,9 @@ struct ext2_dir_entry_2 *ext2_find_entry
 				de = ext2_next_entry(de);
 			}
 			ext2_put_page(page);
-		}
+		} else
+			dir_has_error = 1;
+
 		if (++n >= npages)
 			n = 0;
 		/* next page is past the blocks we've got */
@@ -414,7 +421,7 @@ found:
 
 struct ext2_dir_entry_2 * ext2_dotdot (struct inode *dir, struct page **p)
 {
-	struct page *page = ext2_get_page(dir, 0);
+	struct page *page = ext2_get_page(dir, 0, 0);
 	ext2_dirent *de = NULL;
 
 	if (!IS_ERR(page)) {
@@ -487,7 +494,7 @@ int ext2_add_link (struct dentry *dentry
 	for (n = 0; n <= npages; n++) {
 		char *dir_end;
 
-		page = ext2_get_page(dir, n);
+		page = ext2_get_page(dir, n, 0);
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto out;
@@ -655,14 +662,17 @@ int ext2_empty_dir (struct inode * inode
 {
 	struct page *page = NULL;
 	unsigned long i, npages = dir_pages(inode);
+	int dir_has_error = 0;
 
 	for (i = 0; i < npages; i++) {
 		char *kaddr;
 		ext2_dirent * de;
-		page = ext2_get_page(inode, i);
+		page = ext2_get_page(inode, i, dir_has_error);
 
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			dir_has_error = 1;
 			continue;
+		}
 
 		kaddr = page_address(page);
 		de = (ext2_dirent *)kaddr;
_

Patches currently in -mm which might be from sandeen@redhat.com are

linux-next.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
ext3-avoid-printk-floods-in-the-face-of-directory-corruption.patch

