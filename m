From: akpm@linux-foundation.org
Subject: - writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:44:50 -0700
Message-ID: <200710162244.l9GMioqI021660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbXJPWpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, akpm@linux-foundation.org, dgc@sgi.com, kenchen@google.com, mm-commits@vger.kernel.org


The patch titled
     writeback-remove-pages_skipped-accounting-in-__block_write_full_page fix
has been removed from the -mm tree.  Its filename was
     writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch

This patch was dropped because it was folded into writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch

------------------------------------------------------
Subject: writeback-remove-pages_skipped-accounting-in-__block_write_full_page fix
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

On Wed, Oct 03, 2007 at 07:55:18AM +1000, David Chinner wrote:
> >
> > do not quite agree with each other. The page writeback should be skipped for
> > 'locked buffer', but here it is 'clean buffer'!
>
> Ok, so that means we need an equivalent fix in xfs_start_page_writeback()
> as it will skip pages with clean buffers just like this. Something like
> this (untested)?

Sure OK - as long as it is 'no write because of clean buffer'.
The only user of pages_skipped is obviously using that semantics.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_aops.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -415,10 +415,9 @@ xfs_start_page_writeback(
 		clear_page_dirty_for_io(page);
 	set_page_writeback(page);
 	unlock_page(page);
-	if (!buffers) {
+	/* If no buffers on the page are to be written, finish it here */
+	if (!buffers)
 		end_page_writeback(page);
-		wbc->pages_skipped++;	/* We didn't write this page */
-	}
 }
 
 static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
convert-ill-defined-log2-to-ilog2.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
