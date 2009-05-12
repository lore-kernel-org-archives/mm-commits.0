From: akpm@linux-foundation.org
Subject: + mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch added to -mm tree
Date: Tue, 12 May 2009 10:54:59 -0700
Message-ID: <200905121754.n4CHsxtX013405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbZELR7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 13:59:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, fengguang.wu@gmail.com, mel@csn.ul.ie, pavel@ucw.cz, rientjes@google.com


The patch titled
     mm, PM/Freezer: Disable OOM killer when tasks are frozen
has been added to the -mm tree.  Its filename is
     mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch

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

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Machek <pavel@ucw.cz>
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
@@ -240,4 +240,16 @@ void drain_zone_pages(struct zone *zone,
 void drain_all_pages(void);
 void drain_local_pages(void *dummy);
 
+extern bool oom_killer_disabled;
+
+static inline void disable_oom_killer(void)
+{
+	oom_killer_disabled = true;
+}
+
+static inline void enable_oom_killer(void)
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
+	disable_oom_killer();
  Exit:
 	BUG_ON(in_atomic());
 	printk("\n");
+
 	return error;
 }
 
@@ -145,6 +148,8 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
+	enable_oom_killer();
+
 	printk("Restarting tasks ... ");
 	thaw_tasks(true);
 	thaw_tasks(false);
diff -puN mm/page_alloc.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen
+++ a/mm/page_alloc.c
@@ -180,6 +180,8 @@ static void set_pageblock_migratetype(st
 					PB_migrate, PB_migrate_end);
 }
 
+bool oom_killer_disabled __read_mostly;
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -1770,6 +1772,8 @@ rebalance:
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

linux-next.patch
devpts-correctly-set-default-options.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch
shrink_slab-handle-bad-shrinkers.patch

