From: akpm@linux-foundation.org
Subject: + ksm-keep-quiet-while-list-empty.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:01:08 -0700
Message-ID: <200908042201.n74M19bd013486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207AbZHDWOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: keep quiet while list empty
has been added to the -mm tree.  Its filename is
     ksm-keep-quiet-while-list-empty.patch

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
Subject: ksm: keep quiet while list empty
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

ksm_scan_thread already sleeps in wait_event_interruptible until setting
ksm_run activates it; but if there's nothing on its list to look at, i.e.
nobody has yet said madvise MADV_MERGEABLE, it's a shame to be clocking
up system time and full_scans: ksmd_should_run added to check that too.

And move the mutex_lock out around it: the new counts showed that when
ksm_run is stopped, a little work often got done afterwards, because it
had been read before taking the mutex.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN mm/ksm.c~ksm-keep-quiet-while-list-empty mm/ksm.c
--- a/mm/ksm.c~ksm-keep-quiet-while-list-empty
+++ a/mm/ksm.c
@@ -1287,21 +1287,27 @@ static void ksm_do_scan(unsigned int sca
 	}
 }
 
+static int ksmd_should_run(void)
+{
+	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_list);
+}
+
 static int ksm_scan_thread(void *nothing)
 {
 	set_user_nice(current, 5);
 
 	while (!kthread_should_stop()) {
-		if (ksm_run & KSM_RUN_MERGE) {
-			mutex_lock(&ksm_thread_mutex);
+		mutex_lock(&ksm_thread_mutex);
+		if (ksmd_should_run())
 			ksm_do_scan(ksm_thread_pages_to_scan);
-			mutex_unlock(&ksm_thread_mutex);
+		mutex_unlock(&ksm_thread_mutex);
+
+		if (ksmd_should_run()) {
 			schedule_timeout_interruptible(
 				msecs_to_jiffies(ksm_thread_sleep_millisecs));
 		} else {
 			wait_event_interruptible(ksm_thread_wait,
-					(ksm_run & KSM_RUN_MERGE) ||
-					kthread_should_stop());
+				ksmd_should_run() || kthread_should_stop());
 		}
 	}
 	return 0;
@@ -1346,10 +1352,16 @@ int ksm_madvise(struct vm_area_struct *v
 
 int __ksm_enter(struct mm_struct *mm)
 {
-	struct mm_slot *mm_slot = alloc_mm_slot();
+	struct mm_slot *mm_slot;
+	int needs_wakeup;
+
+	mm_slot = alloc_mm_slot();
 	if (!mm_slot)
 		return -ENOMEM;
 
+	/* Check ksm_run too?  Would need tighter locking */
+	needs_wakeup = list_empty(&ksm_mm_head.mm_list);
+
 	spin_lock(&ksm_mmlist_lock);
 	insert_to_mm_slots_hash(mm, mm_slot);
 	/*
@@ -1361,6 +1373,10 @@ int __ksm_enter(struct mm_struct *mm)
 	spin_unlock(&ksm_mmlist_lock);
 
 	set_bit(MMF_VM_MERGEABLE, &mm->flags);
+
+	if (needs_wakeup)
+		wake_up_interruptible(&ksm_thread_wait);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

acpi-fix-null-bug-for-hid-uid-string.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

