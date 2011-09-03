From: akpm@linux-foundation.org
Subject: + oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch added to -mm tree
Date: Fri, 02 Sep 2011 17:23:21 -0700
Message-ID: <201109030023.p830NLRs019103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab1ICAX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 20:23:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, yinghan@google.com


The patch titled
     oom: fix race while temporarily setting current's oom_score_adj
has been added to the -mm tree.  Its filename is
     oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch

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
Subject: oom: fix race while temporarily setting current's oom_score_adj
From: David Rientjes <rientjes@google.com>

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
@@ -38,6 +38,25 @@ int sysctl_oom_kill_allocating_task;
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
@@ -1637,7 +1637,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 
 	oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 	err = try_to_unuse(type, false, 0); /* force all pages to be unused */
-	test_set_oom_score_adj(oom_score_adj);
+	compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX, oom_score_adj);
 
 	if (err) {
 		/*
_

Patches currently in -mm which might be from rientjes@google.com are

numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch
oom-remove-oom_disable_count.patch
oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch

