From: akpm@linux-foundation.org
Subject: - readahead-laptop-mode.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:16 -0700
Message-ID: <200705080815.l488FGUA019041@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934645AbXEHIP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: laptop mode
has been removed from the -mm tree.  Its filename was
     readahead-laptop-mode.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: laptop mode
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

When the laptop drive is spinned down, defer look-ahead to spin up time.

The implementation employs a poll based method, for performance is not a
concern in this code path. The poll interval is 64KB, which should be small
enough for movies/musics. The user space application is responsible for
proper caching to hide the spin-up-and-read delay.

For crazy laptop users who prefer aggressive read-ahead, here is the way:

# echo 1000 > /proc/sys/vm/readahead_ratio
# blockdev --setra 524280 /dev/hda      # this is the max possible value

Notes:
- It is still an untested feature.
- It is safer to use blockdev+fadvise to increase ra-max for a single file,
  which needs patching your movie player.
- Be sure to restore them to sane values in normal operations!

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    6 ++++++
 mm/page-writeback.c       |    2 +-
 mm/readahead.c            |   32 +++++++++++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 2 deletions(-)

diff -puN include/linux/writeback.h~readahead-laptop-mode include/linux/writeback.h
--- a/include/linux/writeback.h~readahead-laptop-mode
+++ a/include/linux/writeback.h
@@ -86,6 +86,12 @@ void laptop_io_completion(void);
 void laptop_sync_completion(void);
 void throttle_vm_writeout(gfp_t gfp_mask);
 
+extern struct timer_list laptop_mode_wb_timer;
+static inline int laptop_spinned_down(void)
+{
+	return !timer_pending(&laptop_mode_wb_timer);
+}
+
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
 extern int vm_dirty_ratio;
diff -puN mm/page-writeback.c~readahead-laptop-mode mm/page-writeback.c
--- a/mm/page-writeback.c~readahead-laptop-mode
+++ a/mm/page-writeback.c
@@ -413,7 +413,7 @@ static void wb_timer_fn(unsigned long un
 static void laptop_timer_fn(unsigned long unused);
 
 static DEFINE_TIMER(wb_timer, wb_timer_fn, 0, 0);
-static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
+DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
 
 /*
  * Periodic writeback of "old" data.
diff -puN mm/readahead.c~readahead-laptop-mode mm/readahead.c
--- a/mm/readahead.c~readahead-laptop-mode
+++ a/mm/readahead.c
@@ -17,6 +17,7 @@
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
+#include <linux/writeback.h>
 
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
@@ -41,7 +42,7 @@ EXPORT_SYMBOL(default_unplug_io_fn);
 #define INITIAL_RA_PAGES  DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)
 
 /* In laptop mode, poll delayed look-ahead on every ## pages read. */
-#define LAPTOP_POLL_INTERVAL 16
+#define LAPTOP_POLL_INTERVAL	DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)
 
 /* Set look-ahead size to 1/# of the thrashing-threshold. */
 #define LOOKAHEAD_RATIO 8
@@ -790,6 +791,26 @@ out:
 }
 
 /*
+ * Set a new look-ahead mark at @next.
+ */
+static void defer_lookahead(struct address_space *mapping,
+				struct file_ra_state *ra,
+				pgoff_t offset, pgoff_t next)
+{
+	struct page *page;
+
+	page = find_get_page(mapping, next);
+	if (!page)
+		return;
+
+	SetPageReadahead(page);
+	page_cache_release(page);
+
+	if (ra->lookahead_index == offset)
+	    ra->lookahead_index = next;
+}
+
+/*
  * Update `backing_dev_info.ra_thrash_bytes' to be a _biased_ average of
  * read-ahead sizes. Which makes it an a-bit-risky(*) estimation of the
  * _minimal_ read-ahead thrashing threshold on the device.
@@ -1619,6 +1640,15 @@ page_cache_readahead_adaptive(struct add
 			ra_account(ra, RA_EVENT_IO_CONGESTION, req_size);
 			return 0;
 		}
+
+		/*
+		 * Defer read-ahead to save energy.
+		 */
+		if (unlikely(laptop_mode && laptop_spinned_down())) {
+			defer_lookahead(mapping, ra, offset,
+						offset + LAPTOP_POLL_INTERVAL);
+			return 0;
+		}
 	}
 
 	if (page)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
