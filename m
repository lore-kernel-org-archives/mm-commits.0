From: akpm@linux-foundation.org
Subject: + writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch added to -mm tree
Date: Wed, 15 Sep 2010 12:09:32 -0700
Message-ID: <201009151909.o8FJ9WRA010158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755126Ab0IOTJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 15:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mrubin@google.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update
has been added to the -mm tree.  Its filename is
     writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch

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
Subject: writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update
From: Michael Rubin <mrubin@google.com>

Signed-off-by: Michael Rubin <mrubin@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 mm/page-writeback.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update include/linux/mmzone.h
--- a/include/linux/mmzone.h~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update
+++ a/include/linux/mmzone.h
@@ -104,8 +104,8 @@ enum zone_stat_item {
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
-	NR_FILE_DIRTIED,	/* accumulated dirty pages */
-	NR_WRITTEN,		/* accumulated written pages */
+	NR_DIRTIED,		/* page dirtyings since bootup */
+	NR_WRITTEN,		/* page writings since bootup */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
diff -puN mm/page-writeback.c~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update
+++ a/mm/page-writeback.c
@@ -1122,7 +1122,7 @@ void account_page_dirtied(struct page *p
 {
 	if (mapping_cap_account_dirty(mapping)) {
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
-		__inc_zone_page_state(page, NR_FILE_DIRTIED);
+		__inc_zone_page_state(page, NR_DIRTIED);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 		task_dirty_inc(current);
 		task_io_account_write(PAGE_CACHE_SIZE);
_

Patches currently in -mm which might be from mrubin@google.com are

vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
mm-export-account_page_dirty.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-fix.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch

