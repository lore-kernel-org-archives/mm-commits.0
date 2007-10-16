From: akpm@linux-foundation.org
Subject: - hostfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:11 -0700
Message-ID: <200710162033.l9GKXB95014765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966382AbXJPVrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     hostfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     hostfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hostfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

This also gets rid of a lot of useless read_file stuff. And also
optimises the full page write case by marking a !uptodate page uptodate.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   70 +++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 42 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~hostfs-convert-to-new-aops fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~hostfs-convert-to-new-aops
+++ a/fs/hostfs/hostfs_kern.c
@@ -466,56 +466,42 @@ int hostfs_readpage(struct file *file, s
 	return err;
 }
 
-int hostfs_prepare_write(struct file *file, struct page *page,
-			 unsigned int from, unsigned int to)
+int hostfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	char *buffer;
-	long long start, tmp;
-	int err;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 
-	start = (long long) page->index << PAGE_CACHE_SHIFT;
-	buffer = kmap(page);
-	if(from != 0){
-		tmp = start;
-		err = read_file(FILE_HOSTFS_I(file)->fd, &tmp, buffer,
-				from);
-		if(err < 0) goto out;
-	}
-	if(to != PAGE_CACHE_SIZE){
-		start += to;
-		err = read_file(FILE_HOSTFS_I(file)->fd, &start, buffer + to,
-				PAGE_CACHE_SIZE - to);
-		if(err < 0) goto out;
-	}
-	err = 0;
- out:
-	kunmap(page);
-	return err;
+	*pagep = __grab_cache_page(mapping, index);
+	if (!*pagep)
+		return -ENOMEM;
+	return 0;
 }
 
-int hostfs_commit_write(struct file *file, struct page *page, unsigned from,
-		 unsigned to)
+int hostfs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	char *buffer;
-	long long start;
-	int err = 0;
+	void *buffer;
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	int err;
 
-	start = (((long long) page->index) << PAGE_CACHE_SHIFT) + from;
 	buffer = kmap(page);
-	err = write_file(FILE_HOSTFS_I(file)->fd, &start, buffer + from,
-			 to - from);
-	if(err > 0) err = 0;
-
-	/* Actually, if !err, write_file has added to-from to start, so, despite
-	 * the appearance, we are comparing i_size against the _last_ written
-	 * location, as we should. */
+	err = write_file(FILE_HOSTFS_I(file)->fd, &pos, buffer + from, copied);
+	kunmap(page);
 
-	if(!err && (start > inode->i_size))
-		inode->i_size = start;
+	if (!PageUptodate(page) && err == PAGE_CACHE_SIZE)
+		SetPageUptodate(page);
+
+	/* If err > 0, write_file has added err to pos, so we are comparing
+	 * i_size against the last byte written.
+	 */
+	if (err > 0 && (pos > inode->i_size))
+		inode->i_size = pos;
+	unlock_page(page);
+	page_cache_release(page);
 
-	kunmap(page);
 	return err;
 }
 
@@ -523,8 +509,8 @@ static const struct address_space_operat
 	.writepage 	= hostfs_writepage,
 	.readpage	= hostfs_readpage,
 	.set_page_dirty = __set_page_dirty_nobuffers,
-	.prepare_write	= hostfs_prepare_write,
-	.commit_write	= hostfs_commit_write
+	.write_begin	= hostfs_write_begin,
+	.write_end	= hostfs_write_end,
 };
 
 static int init_inode(struct inode *inode, struct dentry *dentry)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
