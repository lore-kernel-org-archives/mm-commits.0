From: akpm@linux-foundation.org
Subject: - vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:03 -0700
Message-ID: <200809031611.m83GB3mV023744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbYICQLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hifumi.hisashi@oss.ntt.co.jp, chris.mason@oracle.com, cmm@us.ibm.com, jack@suse.cz, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     VFS: fix dio write returning EIO when try_to_release_page fails
has been removed from the -mm tree.  Its filename was
     vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VFS: fix dio write returning EIO when try_to_release_page fails
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

Dio write returns EIO when try_to_release_page fails because bh is
still referenced.

The patch

    commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
    Author: Mingming Cao <cmm@us.ibm.com>
    Date:   Fri Jul 25 01:46:22 2008 -0700

        jbd: fix race between free buffer and commit transaction

was merged into 2.6.27-rc1, but I noticed that this patch is not enough
to fix the race.

I did fsstress test heavily to 2.6.27-rc1, and found that dio write still
sometimes got EIO through this test.

The patch above fixed race between freeing buffer(dio) and committing
transaction(jbd) but I discovered that there is another race, freeing
buffer(dio) and ext3/4_ordered_writepage.

: background_writeout()
     ->write_cache_pages()
       ->ext3_ordered_writepage()
     	   walk_page_buffers() -> take a bh ref
 	   block_write_full_page() -> unlock_page
		: <- end_page_writeback
                : <- race! (dio write->try_to_release_page fails)
      	   walk_page_buffers() ->release a bh ref

ext3_ordered_writepage holds bh ref and does unlock_page remaining
taking a bh ref, so this causes the race and failure of
try_to_release_page.

To fix this race, I used the approach of falling back to buffered
writes if try_to_release_page() fails on a page.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   11 +++++++++--
 mm/truncate.c |    4 ++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails mm/filemap.c
--- a/mm/filemap.c~vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails
+++ a/mm/filemap.c
@@ -2129,13 +2129,20 @@ generic_file_direct_write(struct kiocb *
 	 * After a write we want buffered reads to be sure to go to disk to get
 	 * the new data.  We invalidate clean cached page from the region we're
 	 * about to write.  We do this *before* the write so that we can return
-	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
+	 * without clobbering -EIOCBQUEUED from ->direct_IO().
 	 */
 	if (mapping->nrpages) {
 		written = invalidate_inode_pages2_range(mapping,
 					pos >> PAGE_CACHE_SHIFT, end);
-		if (written)
+		/*
+		 * If a page can not be invalidated, return 0 to fall back
+		 * to buffered write.
+		 */
+		if (written) {
+			if (written == -EBUSY)
+				return 0;
 			goto out;
+		}
 	}
 
 	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
diff -puN mm/truncate.c~vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails mm/truncate.c
--- a/mm/truncate.c~vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails
+++ a/mm/truncate.c
@@ -380,7 +380,7 @@ static int do_launder_page(struct addres
  * Any pages which are found to be mapped into pagetables are unmapped prior to
  * invalidation.
  *
- * Returns -EIO if any pages could not be invalidated.
+ * Returns -EBUSY if any pages could not be invalidated.
  */
 int invalidate_inode_pages2_range(struct address_space *mapping,
 				  pgoff_t start, pgoff_t end)
@@ -440,7 +440,7 @@ int invalidate_inode_pages2_range(struct
 			ret2 = do_launder_page(mapping, page);
 			if (ret2 == 0) {
 				if (!invalidate_complete_page2(mapping, page))
-					ret2 = -EIO;
+					ret2 = -EBUSY;
 			}
 			if (ret2 < 0)
 				ret = ret2;
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

origin.patch
vmscan-set-try_to_release_pages-gfp_mask-to-0.patch

