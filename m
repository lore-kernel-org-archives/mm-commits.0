From: akpm@linux-foundation.org
Subject: [merged] oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:23 -0700
Message-ID: <201111012108.pA1L8Nl7015946@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KAVIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: fix race while temporarily setting current's oom_score_adj
has been removed from the -mm tree.  Its filename was
     oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: oom: fix race while temporarily setting current's oom_score_adj

test_set_oom_score_adj() was introduced in 72788c385604 ("oom: replace
PF_OOM_ORIGIN with toggling oom_score_adj") to temporarily elevate
current's oom_score_adj for ksm and swapoff without requiring an
additional per-process flag.

Using that function to both set oom_score_adj to OOM_SCORE_ADJ_MAX and
then reinstate the previous value is racy since it's possible that
userspace can set the value to something else itself before the old value
is reinstated.  That results in userspace setting current's oom_score_adj
to a different value and then the kernel immediately setting it back to
its previous value without notification.

To fix this, a new compare_swap_oom_score_adj() function is introduced
with the same semantics as the compare and swap CAS instruction, or
CMPXCHG on x86.  It is used to reinstate the previous value of
oom_score_adj if and only if the present value is the same as the old
value.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    1 +
 mm/ksm.c            |    3 ++-
 mm/oom_kill.c       |   19 +++++++++++++++++++
 mm/swapfile.c       |    2 +-
 4 files changed, 23 insertions(+), 2 deletions(-)

diff -puN include/linux/oom.h~oom-fix-race-while-temporarily-setting-currents-oom_score_adj include/linux/oom.h
--- a/include/linux/oom.h~oom-fix-race-while-temporarily-setting-currents-oom_score_adj
+++ a/include/linux/oom.h
@@ -40,6 +40,7 @@ enum oom_constraint {
 	CONSTRAINT_MEMCG,
 };
 
+extern void compare_swap_oom_score_adj(int old_val, int new_val);
 extern int test_set_oom_score_adj(int new_val);
 
 extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
diff -puN mm/ksm.c~oom-fix-race-while-temporarily-setting-currents-oom_score_adj mm/ksm.c
--- a/mm/ksm.c~oom-fix-race-while-temporarily-setting-currents-oom_score_adj
+++ a/mm/ksm.c
@@ -1905,7 +1905,8 @@ static ssize_t run_store(struct kobject 
 
 			oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 			err = unmerge_and_remove_all_rmap_items();
-			test_set_oom_score_adj(oom_score_adj);
+			compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX,
+								oom_score_adj);
 			if (err) {
 				ksm_run = KSM_RUN_STOP;
 				count = err;
diff -puN mm/oom_kill.c~oom-fix-race-while-temporarily-setting-currents-oom_score_adj mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-race-while-temporarily-setting-currents-oom_score_adj
+++ a/mm/oom_kill.c
@@ -39,6 +39,25 @@ int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
+/*
+ * compare_swap_oom_score_adj() - compare and swap current's oom_score_adj
+ * @old_val: old oom_score_adj for compare
+ * @new_val: new oom_score_adj for swap
+ *
+ * Sets the oom_score_adj value for current to @new_val iff its present value is
+ * @old_val.  Usually used to reinstate a previous value to prevent racing with
+ * userspacing tuning the value in the interim.
+ */
+void compare_swap_oom_score_adj(int old_val, int new_val)
+{
+	struct sighand_struct *sighand = current->sighand;
+
+	spin_lock_irq(&sighand->siglock);
+	if (current->signal->oom_score_adj == old_val)
+		current->signal->oom_score_adj = new_val;
+	spin_unlock_irq(&sighand->siglock);
+}
+
 /**
  * test_set_oom_score_adj() - set current's oom_score_adj and return old value
  * @new_val: new oom_score_adj value
diff -puN mm/swapfile.c~oom-fix-race-while-temporarily-setting-currents-oom_score_adj mm/swapfile.c
--- a/mm/swapfile.c~oom-fix-race-while-temporarily-setting-currents-oom_score_adj
+++ a/mm/swapfile.c
@@ -1617,7 +1617,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 
 	oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 	err = try_to_unuse(type);
-	test_set_oom_score_adj(oom_score_adj);
+	compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX, oom_score_adj);
 
 	if (err) {
 		/*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch

