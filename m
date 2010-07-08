From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:08:59 -0700
Message-ID: <201007081908.o68J8xm6022253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756682Ab0GHTJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:09:50 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o68J8xFi024441
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 8 Jul 2010 12:09:01 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |   26 --------------------------
 include/linux/backing-dev.h |    4 ----
 mm/backing-dev.c            |   20 ++++++++------------
 3 files changed, 8 insertions(+), 42 deletions(-)

diff -puN fs/fs-writeback.c~linux-next-git-rejects fs/fs-writeback.c
--- a/fs/fs-writeback.c~linux-next-git-rejects
+++ a/fs/fs-writeback.c
@@ -39,13 +39,6 @@ struct wb_writeback_work {
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
-<<<<<<< HEAD
-
-	struct list_head list;		/* pending work list */
-	struct completion *done;	/* set if the caller waits */
-};
-
-=======
 
 	struct list_head list;		/* pending work list */
 	struct completion *done;	/* set if the caller waits */
@@ -66,7 +59,6 @@ struct wb_writeback_work {
  */
 int nr_pdflush_threads;
 
->>>>>>> FETCH_HEAD
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
@@ -82,11 +74,8 @@ int writeback_in_progress(struct backing
 static void bdi_queue_work(struct backing_dev_info *bdi,
 		struct wb_writeback_work *work)
 {
-<<<<<<< HEAD
-=======
 	trace_writeback_queue(bdi, work);
 
->>>>>>> FETCH_HEAD
 	spin_lock(&bdi->wb_lock);
 	list_add_tail(&work->list, &bdi->work_list);
 	spin_unlock(&bdi->wb_lock);
@@ -118,15 +107,10 @@ __bdi_start_writeback(struct backing_dev
 	 */
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work) {
-<<<<<<< HEAD
-		if (bdi->wb.task)
-			wake_up_process(bdi->wb.task);
-=======
 		if (bdi->wb.task) {
 			trace_writeback_nowork(bdi);
 			wake_up_process(bdi->wb.task);
 		}
->>>>>>> FETCH_HEAD
 		return;
 	}
 
@@ -672,20 +656,14 @@ static long wb_writeback(struct bdi_writ
 		wbc.more_io = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
-<<<<<<< HEAD
-=======
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
->>>>>>> FETCH_HEAD
 		if (work->sb)
 			__writeback_inodes_sb(work->sb, wb, &wbc);
 		else
 			writeback_inodes_wb(wb, &wbc);
-<<<<<<< HEAD
-=======
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
->>>>>>> FETCH_HEAD
 		work->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
@@ -791,11 +769,7 @@ long wb_do_writeback(struct bdi_writebac
 		 */
 		if (force_wait)
 			work->sync_mode = WB_SYNC_ALL;
-<<<<<<< HEAD
-=======
-
 		trace_writeback_exec(bdi, work);
->>>>>>> FETCH_HEAD
 
 		wrote += wb_writeback(wb, work);
 
diff -puN include/linux/backing-dev.h~linux-next-git-rejects include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~linux-next-git-rejects
+++ a/include/linux/backing-dev.h
@@ -78,12 +78,8 @@ struct backing_dev_info {
 	unsigned int max_ratio, max_prop_frac;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
-<<<<<<< HEAD
 	spinlock_t wb_lock;	  /* protects update side of wb_list */
 	struct list_head wb_list; /* the flusher threads hanging off this bdi */
-=======
-	spinlock_t wb_lock;	  /* protects work_list */
->>>>>>> FETCH_HEAD
 
 	struct list_head work_list;
 
diff -puN mm/backing-dev.c~linux-next-git-rejects mm/backing-dev.c
--- a/mm/backing-dev.c~linux-next-git-rejects
+++ a/mm/backing-dev.c
@@ -96,23 +96,19 @@ static int bdi_debug_stats_show(struct s
 		   "b_io:             %8lu\n"
 		   "b_more_io:        %8lu\n"
 		   "bdi_list:         %8u\n"
-<<<<<<< HEAD
 		   "state:            %8lx\n"
 		   "wb_list:          %8u\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh),
-		   K(background_thresh), nr_wb, nr_dirty, nr_io, nr_more_io,
-		   !list_empty(&bdi->bdi_list), bdi->state,
+		   K(bdi_thresh),
+		   K(dirty_thresh),
+		   K(background_thresh),
+		   nr_dirty,
+		   nr_io,
+		   nr_more_io,
+		   !list_empty(&bdi->bdi_list),
+		   bdi->state,
 		   !list_empty(&bdi->wb_list));
-=======
-		   "state:            %8lx\n",
-		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
-		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh),
-		   K(background_thresh), nr_dirty, nr_io, nr_more_io,
-		   !list_empty(&bdi->bdi_list), bdi->state);
->>>>>>> FETCH_HEAD
 #undef K
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
acpi-fix-bogus-preemption-logic-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

