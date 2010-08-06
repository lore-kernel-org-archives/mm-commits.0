From: akpm@linux-foundation.org
Subject: + mm-fix-writeback_in_progress.patch added to -mm tree
Date: Thu, 05 Aug 2010 17:27:37 -0700
Message-ID: <201008060027.o760Rbhq014966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934222Ab0HFA2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 20:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, fengguang.wu@intel.com, hch@lst.de, jaxboe@fusionio.com


The patch titled
     mm: fix writeback_in_progress()
has been added to the -mm tree.  Its filename is
     mm-fix-writeback_in_progress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix writeback_in_progress()
From: Jan Kara <jack@suse.cz>

Commit 83ba7b071f3 ("writeback: simplify the write back thread queue")
broke writeback_in_progress() as in that commit we started to remove work
items from the list at the moment we start working on them and not at the
moment they are finished.  Thus if the flusher thread was doing some work
but there was no other work queued, writeback_in_progress() returned
false.  This could in particular cause unnecessary queueing of background
writeback from balance_dirty_pages() or writeout work from
writeback_sb_if_idle().

This patch fixes the problem by introducing a bit in the bdi state which
indicates that the flusher thread is processing some work and uses this
bit for writeback_in_progress() test.

NOTE: Both callsites of writeback_in_progress() (namely,
writeback_inodes_sb_if_idle() and balance_dirty_pages()) would actually
need a different information than what writeback_in_progress() provides. 
They would need to know whether *the kind of writeback they are going to
submit* is already queued.  But this information isn't that simple to
provide so let's fix writeback_in_progress() for the time being.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |    4 +++-
 include/linux/backing-dev.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~mm-fix-writeback_in_progress fs/fs-writeback.c
--- a/fs/fs-writeback.c~mm-fix-writeback_in_progress
+++ a/fs/fs-writeback.c
@@ -67,7 +67,7 @@ int nr_pdflush_threads;
  */
 int writeback_in_progress(struct backing_dev_info *bdi)
 {
-	return !list_empty(&bdi->work_list);
+	return test_bit(BDI_writeback_running, &bdi->state);
 }
 
 static void bdi_queue_work(struct backing_dev_info *bdi,
@@ -742,6 +742,7 @@ long wb_do_writeback(struct bdi_writebac
 	struct wb_writeback_work *work;
 	long wrote = 0;
 
+	set_bit(BDI_writeback_running, &wb->bdi->state);
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		/*
 		 * Override sync mode, in case we must wait for completion
@@ -768,6 +769,7 @@ long wb_do_writeback(struct bdi_writebac
 	 * Check for periodic writeback, kupdated() style
 	 */
 	wrote += wb_check_old_data_flush(wb);
+	clear_bit(BDI_writeback_running, &wb->bdi->state);
 
 	return wrote;
 }
diff -puN include/linux/backing-dev.h~mm-fix-writeback_in_progress include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-fix-writeback_in_progress
+++ a/include/linux/backing-dev.h
@@ -31,6 +31,7 @@ enum bdi_state {
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_registered,		/* bdi_register() was done */
+	BDI_writeback_running,	/* Writeback is in progress */
 	BDI_unused,		/* Available bits start here */
 };
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged.patch
mm-implement-writeback-livelock-avoidance-using-page-tagging.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
mm-fix-writeback_in_progress.patch
mm-avoid-resetting-wb_start-after-each-writeback-round.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch
reiser4.patch

