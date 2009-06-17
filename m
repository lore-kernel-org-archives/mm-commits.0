From: akpm@linux-foundation.org
Subject: [merged] mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:23 -0700
Message-ID: <200906171835.n5HIZNuX001431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760528AbZFQShF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, fengguang.wu@gmail.com, mel@csn.ul.ie, pavel@ucw.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm, PM/Freezer: Disable OOM killer when tasks are frozen
has been removed from the -mm tree.  Its filename was
     mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm, PM/Freezer: Disable OOM killer when tasks are frozen
From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, the following scenario appears to be possible in theory:

* Tasks are frozen for hibernation or suspend.
* Free pages are almost exhausted.
* Certain piece of code in the suspend code path attempts to allocate
  some memory using GFP_KERNEL and allocation order less than or
  equal to PAGE_ALLOC_COSTLY_ORDER.
* __alloc_pages_internal() cannot find a free page so it invokes the
  OOM killer.
* The OOM killer attempts to kill a task, but the task is frozen, so
  it doesn't die immediately.
* __alloc_pages_internal() jumps to 'restart', unsuccessfully tries
  to find a free page and invokes the OOM killer.
* No progress can be made.

Although it is now hard to trigger during hibernation due to the memory
shrinking carried out by the hibernation code, it is theoretically
possible to trigger during suspend after the memory shrinking has been
removed from that code path.  Moreover, since memory allocations are
going to be used for the hibernation memory shrinking, it will be even
more likely to happen during hibernation.

To prevent it from happening, introduce the oom_killer_disabled switch
that will cause __alloc_pages_internal() to fail in the situations in
which the OOM killer would have been called and make the freezer set
this switch after tasks have been successfully frozen.

[akpm@linux-foundation.org: be nicer to the namespace]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |   12 ++++++++++++
 kernel/power/process.c |    5 +++++
 mm/page_alloc.c        |    4 ++++
 3 files changed, 21 insertions(+)

diff -puN include/linux/gfp.h~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen include/linux/gfp.h
--- a/include/linux/gfp.h~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen
+++ a/include/linux/gfp.h
@@ -243,4 +243,16 @@ void drain_zone_pages(struct zone *zone,
 void drain_all_pages(void);
 void drain_local_pages(void *dummy);
 
+extern bool oom_killer_disabled;
+
+static inline void oom_killer_disable(void)
+{
+	oom_killer_disabled = true;
+}
+
+static inline void oom_killer_enable(void)
+{
+	oom_killer_disabled = false;
+}
+
 #endif /* __LINUX_GFP_H */
diff -puN kernel/power/process.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen kernel/power/process.c
--- a/kernel/power/process.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen
+++ a/kernel/power/process.c
@@ -117,9 +117,12 @@ int freeze_processes(void)
 	if (error)
 		goto Exit;
 	printk("done.");
+
+	oom_killer_disable();
  Exit:
 	BUG_ON(in_atomic());
 	printk("\n");
+
 	return error;
 }
 
@@ -145,6 +148,8 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
+	oom_killer_enable();
+
 	printk("Restarting tasks ... ");
 	thaw_tasks(true);
 	thaw_tasks(false);
diff -puN mm/page_alloc.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen
+++ a/mm/page_alloc.c
@@ -178,6 +178,8 @@ static void set_pageblock_migratetype(st
 					PB_migrate, PB_migrate_end);
 }
 
+bool oom_killer_disabled __read_mostly;
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -1769,6 +1771,8 @@ rebalance:
 	 */
 	if (!did_some_progress) {
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+			if (oom_killer_disabled)
+				goto nopage;
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
net-e100-fix-suspend-of-devices-that-cannot-be-power-managed.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
shrink_slab-handle-bad-shrinkers.patch

