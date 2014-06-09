From: akpm@linux-foundation.org
Subject: [merged]
 fs-affs-filec-remove-unnecessary-function-parameters.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:36:07 -0700
Message-ID: <53960ca7.UGlZ4ZT131nhTcD/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] fs-affs-filec-remove-unnecessary-function-parameters.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:36:07 -0700


The patch titled
     Subject: fs/affs/file.c: remove unnecessary function parameters
has been removed from the -mm tree.  Its filename was
     fs-affs-filec-remove-unnecessary-function-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

