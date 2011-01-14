From: akpm@linux-foundation.org
Subject: [merged] thp-freeze-khugepaged-and-ksmd.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:21 -0800
Message-ID: <201101142251.p0EMpBZ9005481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: freeze khugepaged and ksmd
has been removed from the -mm tree.  Its filename was
     thp-freeze-khugepaged-and-ksmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: freeze khugepaged and ksmd
From: Andrea Arcangeli <aarcange@redhat.com>

It's unclear why schedule friendly kernel threads can't be taken away by
the CPU through the scheduler itself.  It's safer to stop them as they can
trigger memory allocation, if kswapd also freezes itself to avoid
generating I/O they have too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++++++--
 mm/ksm.c         |    8 ++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-freeze-khugepaged-and-ksmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-freeze-khugepaged-and-ksmd
+++ a/mm/huge_memory.c
@@ -15,6 +15,7 @@
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
+#include <linux/freezer.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -2085,6 +2086,9 @@ static void khugepaged_do_scan(struct pa
 			break;
 #endif
 
+		if (unlikely(kthread_should_stop() || freezing(current)))
+			break;
+
 		spin_lock(&khugepaged_mm_lock);
 		if (!khugepaged_scan.mm_slot)
 			pass_through_head++;
@@ -2147,6 +2151,9 @@ static void khugepaged_loop(void)
 		if (hpage)
 			put_page(hpage);
 #endif
+		try_to_freeze();
+		if (unlikely(kthread_should_stop()))
+			break;
 		if (khugepaged_has_work()) {
 			DEFINE_WAIT(wait);
 			if (!khugepaged_scan_sleep_millisecs)
@@ -2157,8 +2164,8 @@ static void khugepaged_loop(void)
 					khugepaged_scan_sleep_millisecs));
 			remove_wait_queue(&khugepaged_wait, &wait);
 		} else if (khugepaged_enabled())
-			wait_event_interruptible(khugepaged_wait,
-						 khugepaged_wait_event());
+			wait_event_freezable(khugepaged_wait,
+					     khugepaged_wait_event());
 	}
 }
 
@@ -2166,6 +2173,7 @@ static int khugepaged(void *none)
 {
 	struct mm_slot *mm_slot;
 
+	set_freezable();
 	set_user_nice(current, 19);
 
 	/* serialize with start_khugepaged() */
@@ -2180,6 +2188,8 @@ static int khugepaged(void *none)
 		mutex_lock(&khugepaged_mutex);
 		if (!khugepaged_enabled())
 			break;
+		if (unlikely(kthread_should_stop()))
+			break;
 	}
 
 	spin_lock(&khugepaged_mm_lock);
diff -puN mm/ksm.c~thp-freeze-khugepaged-and-ksmd mm/ksm.c
--- a/mm/ksm.c~thp-freeze-khugepaged-and-ksmd
+++ a/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/swap.h>
 #include <linux/ksm.h>
 #include <linux/hash.h>
+#include <linux/freezer.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -1365,7 +1366,7 @@ static void ksm_do_scan(unsigned int sca
 	struct rmap_item *rmap_item;
 	struct page *uninitialized_var(page);
 
-	while (scan_npages--) {
+	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
@@ -1383,6 +1384,7 @@ static int ksmd_should_run(void)
 
 static int ksm_scan_thread(void *nothing)
 {
+	set_freezable();
 	set_user_nice(current, 5);
 
 	while (!kthread_should_stop()) {
@@ -1391,11 +1393,13 @@ static int ksm_scan_thread(void *nothing
 			ksm_do_scan(ksm_thread_pages_to_scan);
 		mutex_unlock(&ksm_thread_mutex);
 
+		try_to_freeze();
+
 		if (ksmd_should_run()) {
 			schedule_timeout_interruptible(
 				msecs_to_jiffies(ksm_thread_sleep_millisecs));
 		} else {
-			wait_event_interruptible(ksm_thread_wait,
+			wait_event_freezable(ksm_thread_wait,
 				ksmd_should_run() || kthread_should_stop());
 		}
 	}
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

