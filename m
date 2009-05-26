From: akpm@linux-foundation.org
Subject: [merged] pm-suspend-do-not-shrink-memory-before-suspend.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:55 -0700
Message-ID: <200905261935.n4QJZtpP006624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758043AbZEZTgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, fengguang.wu@intel.com, nigel@tuxonice.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     pm/suspend: do not shrink memory before suspend
has been removed from the -mm tree.  Its filename was
     pm-suspend-do-not-shrink-memory-before-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm/suspend: do not shrink memory before suspend
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the shrinking of memory from the suspend-to-RAM code, where it is
not really necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@tuxonice.net>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |   20 +-------------------
 mm/vmscan.c         |    4 ++--
 2 files changed, 3 insertions(+), 21 deletions(-)

diff -puN kernel/power/main.c~pm-suspend-do-not-shrink-memory-before-suspend kernel/power/main.c
--- a/kernel/power/main.c~pm-suspend-do-not-shrink-memory-before-suspend
+++ a/kernel/power/main.c
@@ -188,9 +188,6 @@ static void suspend_test_finish(const ch
 
 #endif
 
-/* This is just an arbitrary number */
-#define FREE_PAGE_NUMBER (100)
-
 static struct platform_suspend_ops *suspend_ops;
 
 /**
@@ -226,7 +223,6 @@ int suspend_valid_only_mem(suspend_state
 static int suspend_prepare(void)
 {
 	int error;
-	unsigned int free_pages;
 
 	if (!suspend_ops || !suspend_ops->enter)
 		return -EPERM;
@@ -241,24 +237,10 @@ static int suspend_prepare(void)
 	if (error)
 		goto Finish;
 
-	if (suspend_freeze_processes()) {
-		error = -EAGAIN;
-		goto Thaw;
-	}
-
-	free_pages = global_page_state(NR_FREE_PAGES);
-	if (free_pages < FREE_PAGE_NUMBER) {
-		pr_debug("PM: free some memory\n");
-		shrink_all_memory(FREE_PAGE_NUMBER - free_pages);
-		if (nr_free_pages() < FREE_PAGE_NUMBER) {
-			error = -ENOMEM;
-			printk(KERN_ERR "PM: No enough memory\n");
-		}
-	}
+	error = suspend_freeze_processes();
 	if (!error)
 		return 0;
 
- Thaw:
 	suspend_thaw_processes();
 	usermodehelper_enable();
  Finish:
diff -puN mm/vmscan.c~pm-suspend-do-not-shrink-memory-before-suspend mm/vmscan.c
--- a/mm/vmscan.c~pm-suspend-do-not-shrink-memory-before-suspend
+++ a/mm/vmscan.c
@@ -2105,7 +2105,7 @@ unsigned long global_lru_pages(void)
 		+ global_page_state(NR_INACTIVE_FILE);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_HIBERNATION
 /*
  * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
  * from LRU lists system-wide, for given pass and priority.
@@ -2245,7 +2245,7 @@ out:
 
 	return sc.nr_reclaimed;
 }
-#endif
+#endif /* CONFIG_HIBERNATION */
 
 /* It's optimal to keep kswapds on the same CPUs as their memory, but
    not required for correctness.  So if the last cpu in a node goes
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
pm-hibernate-rework-shrinking-of-memory.patch
pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2.patch
pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard.patch
shrink_slab-handle-bad-shrinkers.patch

