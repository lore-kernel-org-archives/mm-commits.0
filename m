From: akpm@linux-foundation.org
Subject: [merged]
 fs-use-mapping_set_error-instead-of-opencoded-set_bit.patch removed from
 -mm tree
Date: Wed, 12 Oct 2016 12:26:39 -0700
Message-ID: <57fe8e6f.r7v+erek88a1qxnE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33973 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755921AbcJLT1k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: use mapping_set_error instead of opencoded set_bit
has been removed from the -mm tree.  Its filename was
     fs-use-mapping_set_error-instead-of-opencoded-set_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs: use mapping_set_error instead of opencoded set_bit

The mapping_set_error() helper sets the correct AS_ flag for the mapping
so there is no reason to open code it.  Use the helper directly.

[akpm@linux-foundation.org: be honest about conversion from -ENXIO to -EIO]
Link: http://lkml.kernel.org/r/20160912111608.2588-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/vvp_page.c |    5 +----
 fs/afs/write.c                                 |    5 ++---
 fs/buffer.c                                    |    4 ++--
 fs/exofs/inode.c                               |    2 +-
 fs/ext4/page-io.c                              |    2 +-
 fs/f2fs/data.c                                 |    2 +-
 fs/jbd2/commit.c                               |    3 +--
 7 files changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/vvp_page.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit drivers/staging/lustre/lustre/llite/vvp_page.c
--- a/drivers/staging/lustre/lustre/llite/vvp_page.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit
+++ a/drivers/staging/lustre/lustre/llite/vvp_page.c
@@ -241,10 +241,7 @@ static void vvp_vmpage_error(struct inod
 		obj->vob_discard_page_warned = 0;
 	} else {
 		SetPageError(vmpage);
-		if (ioret == -ENOSPC)
-			set_bit(AS_ENOSPC, &inode->i_mapping->flags);
-		else
-			set_bit(AS_EIO, &inode->i_mapping->flags);
+		mapping_set_error(inode->i_mapping, ioret);
 
 		if ((ioret == -ESHUTDOWN || ioret == -EINTR) &&
 		    obj->vob_discard_page_warned == 0) {
diff -puN fs/afs/write.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit fs/afs/write.c
--- a/fs/afs/write.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit
+++ a/fs/afs/write.c
@@ -398,8 +398,7 @@ no_more:
 		switch (ret) {
 		case -EDQUOT:
 		case -ENOSPC:
-			set_bit(AS_ENOSPC,
-				&wb->vnode->vfs_inode.i_mapping->flags);
+			mapping_set_error(wb->vnode->vfs_inode.i_mapping, -ENOSPC);
 			break;
 		case -EROFS:
 		case -EIO:
@@ -409,7 +408,7 @@ no_more:
 		case -ENOMEDIUM:
 		case -ENXIO:
 			afs_kill_pages(wb->vnode, true, first, last);
-			set_bit(AS_EIO, &wb->vnode->vfs_inode.i_mapping->flags);
+			mapping_set_error(wb->vnode->vfs_inode.i_mapping, -EIO);
 			break;
 		case -EACCES:
 		case -EPERM:
diff -puN fs/buffer.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit fs/buffer.c
--- a/fs/buffer.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit
+++ a/fs/buffer.c
@@ -351,7 +351,7 @@ void end_buffer_async_write(struct buffe
 		set_buffer_uptodate(bh);
 	} else {
 		buffer_io_error(bh, ", lost async page write");
-		set_bit(AS_EIO, &page->mapping->flags);
+		mapping_set_error(page->mapping, -EIO);
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
 		SetPageError(page);
@@ -3249,7 +3249,7 @@ drop_buffers(struct page *page, struct b
 	bh = head;
 	do {
 		if (buffer_write_io_error(bh) && page->mapping)
-			set_bit(AS_EIO, &page->mapping->flags);
+			mapping_set_error(page->mapping, -EIO);
 		if (buffer_busy(bh))
 			goto failed;
 		bh = bh->b_this_page;
diff -puN fs/exofs/inode.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit fs/exofs/inode.c
--- a/fs/exofs/inode.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit
+++ a/fs/exofs/inode.c
@@ -778,7 +778,7 @@ try_again:
 fail:
 	EXOFS_DBGMSG("Error: writepage_strip(0x%lx, 0x%lx)=>%d\n",
 		     inode->i_ino, page->index, ret);
-	set_bit(AS_EIO, &page->mapping->flags);
+	mapping_set_error(page->mapping, -EIO);
 	unlock_page(page);
 	return ret;
 }
diff -puN fs/ext4/page-io.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit fs/ext4/page-io.c
--- a/fs/ext4/page-io.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit
+++ a/fs/ext4/page-io.c
@@ -88,7 +88,7 @@ static void ext4_finish_bio(struct bio *
 
 		if (bio->bi_error) {
 			SetPageError(page);
-			set_bit(AS_EIO, &page->mapping->flags);
+			mapping_set_error(page->mapping, -EIO);
 		}
 		bh = head = page_buffers(page);
 		/*
diff -puN fs/f2fs/data.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit fs/f2fs/data.c
--- a/fs/f2fs/data.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit
+++ a/fs/f2fs/data.c
@@ -75,7 +75,7 @@ static void f2fs_write_end_io(struct bio
 		fscrypt_pullback_bio_page(&page, true);
 
 		if (unlikely(bio->bi_error)) {
-			set_bit(AS_EIO, &page->mapping->flags);
+			mapping_set_error(page->mapping, -EIO);
 			f2fs_stop_checkpoint(sbi, true);
 		}
 		end_page_writeback(page);
diff -puN fs/jbd2/commit.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit
+++ a/fs/jbd2/commit.c
@@ -269,8 +269,7 @@ static int journal_finish_inode_data_buf
 			 * filemap_fdatawait_range(), set it again so
 			 * that user process can get -EIO from fsync().
 			 */
-			set_bit(AS_EIO,
-				&jinode->i_vfs_inode->i_mapping->flags);
+			mapping_set_error(jinode->i_vfs_inode->i_mapping, -EIO);
 
 			if (!ret)
 				ret = err;
_

Patches currently in -mm which might be from mhocko@suse.com are


