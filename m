From: akpm@linux-foundation.org
Subject: + fs-affs-filec-remove-unnecessary-function-parameters.patch
 added to -mm tree
Date: Fri, 18 Apr 2014 13:19:43 -0700
Message-ID: <535188df.FrPQF5lh19QcR4xy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRUTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 16:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-affs-filec-remove-unnecessary-function-parameters.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 13:19:43 -0700


The patch titled
     Subject: fs/affs/file.c: remove unnecessary function parameters
has been added to the -mm tree.  Its filename is
     fs-affs-filec-remove-unnecessary-function-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-remove-unnecessary-function-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-remove-unnecessary-function-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: remove unnecessary function parameters

- affs_do_readpage_ofs is always called with from = 0 ie reading from
  page->index

- File parameter is never used

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-remove-unnecessary-function-parameters fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-remove-unnecessary-function-parameters
+++ a/fs/affs/file.c
@@ -498,34 +498,36 @@ affs_getemptyblk_ino(struct inode *inode
 }
 
 static int
-affs_do_readpage_ofs(struct file *file, struct page *page, unsigned from, unsigned to)
+affs_do_readpage_ofs(struct page *page, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh;
 	char *data;
+	unsigned pos = 0;
 	u32 bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("AFFS: read_page(%u, %ld, %d, %d)\n", (u32)inode->i_ino, page->index, from, to);
-	BUG_ON(from > to || to > PAGE_CACHE_SIZE);
+	pr_debug("AFFS: read_page(%u, %ld, 0, %d)\n", (u32)inode->i_ino,
+		 page->index, to);
+	BUG_ON(to > PAGE_CACHE_SIZE);
 	kmap(page);
 	data = page_address(page);
 	bsize = AFFS_SB(sb)->s_data_blksize;
-	tmp = (page->index << PAGE_CACHE_SHIFT) + from;
+	tmp = page->index << PAGE_CACHE_SHIFT;
 	bidx = tmp / bsize;
 	boff = tmp % bsize;
 
-	while (from < to) {
+	while (pos < to) {
 		bh = affs_bread_ino(inode, bidx, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
-		tmp = min(bsize - boff, to - from);
-		BUG_ON(from + tmp > to || tmp > bsize);
-		memcpy(data + from, AFFS_DATA(bh) + boff, tmp);
+		tmp = min(bsize - boff, to - pos);
+		BUG_ON(pos + tmp > to || tmp > bsize);
+		memcpy(data + pos, AFFS_DATA(bh) + boff, tmp);
 		affs_brelse(bh);
 		bidx++;
-		from += tmp;
+		pos += tmp;
 		boff = 0;
 	}
 	flush_dcache_page(page);
@@ -615,7 +617,7 @@ affs_readpage_ofs(struct file *file, str
 		memset(page_address(page) + to, 0, PAGE_CACHE_SIZE - to);
 	}
 
-	err = affs_do_readpage_ofs(file, page, 0, to);
+	err = affs_do_readpage_ofs(page, to);
 	if (!err)
 		SetPageUptodate(page);
 	unlock_page(page);
@@ -651,7 +653,7 @@ static int affs_write_begin_ofs(struct f
 		return 0;
 
 	/* XXX: inefficient but safe in the face of short writes */
-	err = affs_do_readpage_ofs(file, page, 0, PAGE_CACHE_SIZE);
+	err = affs_do_readpage_ofs(page, PAGE_CACHE_SIZE);
 	if (err) {
 		unlock_page(page);
 		page_cache_release(page);
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

