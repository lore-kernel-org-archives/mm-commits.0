From: akpm@linux-foundation.org
Subject: + writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:52 -0700
Message-ID: <201009132248.o8DMmqRN025729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141Ab0IMWtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mrubin@google.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     writeback: add nr_dirtied and nr_written to /proc/vmstat
has been added to the -mm tree.  Its filename is
     writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch

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
Subject: writeback: add nr_dirtied and nr_written to /proc/vmstat
From: Michael Rubin <mrubin@google.com>

To help developers and applications gain visibility into writeback
behaviour adding two entries to vm_stat_items and /proc/vmstat.  This will
allow us to track the "written" and "dirtied" counts.

   # grep nr_dirtied /proc/vmstat
   nr_dirtied 3747
   # grep nr_written /proc/vmstat
   nr_written 3618

Signed-off-by: Michael Rubin <mrubin@google.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/page-writeback.c    |    2 ++
 mm/vmstat.c            |    3 +++
 3 files changed, 7 insertions(+)

diff -puN include/linux/mmzone.h~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat include/linux/mmzone.h
--- a/include/linux/mmzone.h~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat
+++ a/include/linux/mmzone.h
@@ -104,6 +104,8 @@ enum zone_stat_item {
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
+	NR_FILE_DIRTIED,	/* accumulated dirty pages */
+	NR_WRITTEN,		/* accumulated written pages */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
diff -puN mm/page-writeback.c~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat
+++ a/mm/page-writeback.c
@@ -1122,6 +1122,7 @@ void account_page_dirtied(struct page *p
 {
 	if (mapping_cap_account_dirty(mapping)) {
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
+		__inc_zone_page_state(page, NR_FILE_DIRTIED);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 		task_dirty_inc(current);
 		task_io_account_write(PAGE_CACHE_SIZE);
@@ -1137,6 +1138,7 @@ EXPORT_SYMBOL(account_page_dirtied);
 void account_page_writeback(struct page *page)
 {
 	inc_zone_page_state(page, NR_WRITEBACK);
+	inc_zone_page_state(page, NR_WRITTEN);
 }
 EXPORT_SYMBOL(account_page_writeback);
 
diff -puN mm/vmstat.c~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat mm/vmstat.c
--- a/mm/vmstat.c~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat
+++ a/mm/vmstat.c
@@ -745,6 +745,9 @@ static const char * const vmstat_text[] 
 	"nr_isolated_anon",
 	"nr_isolated_file",
 	"nr_shmem",
+	"nr_dirtied",
+	"nr_written",
+
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
_

Patches currently in -mm which might be from mrubin@google.com are

vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
mm-export-account_page_dirty.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-fix.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch

