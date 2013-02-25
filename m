From: akpm@linux-foundation.org
Subject: [merged] ksm-stop-hotremove-lockdep-warning.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:14 -0800
Message-ID: <20130225205414.BDEDF31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:57245 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab3BYUyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:16 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so363231qah.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: stop hotremove lockdep warning
has been removed from the -mm tree.  Its filename was
     ksm-stop-hotremove-lockdep-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: stop hotremove lockdep warning

Complaints are rare, but lockdep still does not understand the way
ksm_memory_callback(MEM_GOING_OFFLINE) takes ksm_thread_mutex, and holds
it until the ksm_memory_callback(MEM_OFFLINE): that appears to be a
problem because notifier callbacks are made under down_read of
blocking_notifier_head->rwsem (so first the mutex is taken while holding
the rwsem, then later the rwsem is taken while still holding the mutex);
but is not in fact a problem because mem_hotplug_mutex is held throughout
the dance.

There was an attempt to fix this with mutex_lock_nested(); but if that
happened to fool lockdep two years ago, apparently it does so no longer.

I had hoped to eradicate this issue in extending KSM page migration not to
need the ksm_thread_mutex.  But then realized that although the page
migration itself is safe, we do still need to lock out ksmd and other
users of get_ksm_page() while offlining memory - at some point between
MEM_GOING_OFFLINE and MEM_OFFLINE, the struct pages themselves may vanish,
and get_ksm_page()'s accesses to them become a violation.

So, give up on holding ksm_thread_mutex itself from MEM_GOING_OFFLINE to
MEM_OFFLINE, and add a KSM_RUN_OFFLINE flag, and wait_while_offlining()
checks, to achieve the same lockout without being caught by lockdep.  This
is less elegant for KSM, but it's more important to keep lockdep useful to
other users - and I apologize for how long it took to fix.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   55 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff -puN mm/ksm.c~ksm-stop-hotremove-lockdep-warning mm/ksm.c
--- a/mm/ksm.c~ksm-stop-hotremove-lockdep-warning
+++ a/mm/ksm.c
@@ -226,7 +226,9 @@ static unsigned int ksm_merge_across_nod
 #define KSM_RUN_STOP	0
 #define KSM_RUN_MERGE	1
 #define KSM_RUN_UNMERGE	2
-static unsigned int ksm_run = KSM_RUN_STOP;
+#define KSM_RUN_OFFLINE	4
+static unsigned long ksm_run = KSM_RUN_STOP;
+static void wait_while_offlining(void);
 
 static DECLARE_WAIT_QUEUE_HEAD(ksm_thread_wait);
 static DEFINE_MUTEX(ksm_thread_mutex);
@@ -1700,6 +1702,7 @@ static int ksm_scan_thread(void *nothing
 
 	while (!kthread_should_stop()) {
 		mutex_lock(&ksm_thread_mutex);
+		wait_while_offlining();
 		if (ksmd_should_run())
 			ksm_do_scan(ksm_thread_pages_to_scan);
 		mutex_unlock(&ksm_thread_mutex);
@@ -2056,6 +2059,22 @@ void ksm_migrate_page(struct page *newpa
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+static int just_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
+static void wait_while_offlining(void)
+{
+	while (ksm_run & KSM_RUN_OFFLINE) {
+		mutex_unlock(&ksm_thread_mutex);
+		wait_on_bit(&ksm_run, ilog2(KSM_RUN_OFFLINE),
+				just_wait, TASK_UNINTERRUPTIBLE);
+		mutex_lock(&ksm_thread_mutex);
+	}
+}
+
 static void ksm_check_stable_tree(unsigned long start_pfn,
 				  unsigned long end_pfn)
 {
@@ -2098,15 +2117,15 @@ static int ksm_memory_callback(struct no
 	switch (action) {
 	case MEM_GOING_OFFLINE:
 		/*
-		 * Keep it very simple for now: just lock out ksmd and
-		 * MADV_UNMERGEABLE while any memory is going offline.
-		 * mutex_lock_nested() is necessary because lockdep was alarmed
-		 * that here we take ksm_thread_mutex inside notifier chain
-		 * mutex, and later take notifier chain mutex inside
-		 * ksm_thread_mutex to unlock it.   But that's safe because both
-		 * are inside mem_hotplug_mutex.
+		 * Prevent ksm_do_scan(), unmerge_and_remove_all_rmap_items()
+		 * and remove_all_stable_nodes() while memory is going offline:
+		 * it is unsafe for them to touch the stable tree at this time.
+		 * But unmerge_ksm_pages(), rmap lookups and other entry points
+		 * which do not need the ksm_thread_mutex are all safe.
 		 */
-		mutex_lock_nested(&ksm_thread_mutex, SINGLE_DEPTH_NESTING);
+		mutex_lock(&ksm_thread_mutex);
+		ksm_run |= KSM_RUN_OFFLINE;
+		mutex_unlock(&ksm_thread_mutex);
 		break;
 
 	case MEM_OFFLINE:
@@ -2122,11 +2141,20 @@ static int ksm_memory_callback(struct no
 		/* fallthrough */
 
 	case MEM_CANCEL_OFFLINE:
+		mutex_lock(&ksm_thread_mutex);
+		ksm_run &= ~KSM_RUN_OFFLINE;
 		mutex_unlock(&ksm_thread_mutex);
+
+		smp_mb();	/* wake_up_bit advises this */
+		wake_up_bit(&ksm_run, ilog2(KSM_RUN_OFFLINE));
 		break;
 	}
 	return NOTIFY_OK;
 }
+#else
+static void wait_while_offlining(void)
+{
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_SYSFS
@@ -2189,7 +2217,7 @@ KSM_ATTR(pages_to_scan);
 static ssize_t run_show(struct kobject *kobj, struct kobj_attribute *attr,
 			char *buf)
 {
-	return sprintf(buf, "%u\n", ksm_run);
+	return sprintf(buf, "%lu\n", ksm_run);
 }
 
 static ssize_t run_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -2212,6 +2240,7 @@ static ssize_t run_store(struct kobject 
 	 */
 
 	mutex_lock(&ksm_thread_mutex);
+	wait_while_offlining();
 	if (ksm_run != flags) {
 		ksm_run = flags;
 		if (flags & KSM_RUN_UNMERGE) {
@@ -2254,6 +2283,7 @@ static ssize_t merge_across_nodes_store(
 		return -EINVAL;
 
 	mutex_lock(&ksm_thread_mutex);
+	wait_while_offlining();
 	if (ksm_merge_across_nodes != knob) {
 		if (ksm_pages_shared || remove_all_stable_nodes())
 			err = -EBUSY;
@@ -2366,10 +2396,7 @@ static int __init ksm_init(void)
 #endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-	/*
-	 * Choose a high priority since the callback takes ksm_thread_mutex:
-	 * later callbacks could only be taking locks which nest within that.
-	 */
+	/* There is no significance to this priority 100 */
 	hotplug_memory_notifier(ksm_memory_callback, 100);
 #endif
 	return 0;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

