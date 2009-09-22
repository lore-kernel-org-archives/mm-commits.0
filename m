From: akpm@linux-foundation.org
Subject: [merged] ksm-keep-quiet-while-list-empty.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:54 -0700
Message-ID: <200909222039.n8MKdssu004390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbZIVUmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: keep quiet while list empty
has been removed from the -mm tree.  Its filename was
     ksm-keep-quiet-while-list-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1280,21 +1280,27 @@ static void ksm_do_scan(unsigned int sca
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
@@ -1339,10 +1345,16 @@ int ksm_madvise(struct vm_area_struct *v
 
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
@@ -1354,6 +1366,10 @@ int __ksm_enter(struct mm_struct *mm)
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

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

