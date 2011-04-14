From: akpm@linux-foundation.org
Subject: + oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch added to -mm tree
Date: Thu, 14 Apr 2011 12:29:35 -0700
Message-ID: <201104141929.p3EJTZWn001791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933974Ab1DNTaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hughd@google.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     oom: replace PF_OOM_ORIGIN with toggling oom_score_adj
has been added to the -mm tree.  Its filename is
     oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch

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
Subject: oom: replace PF_OOM_ORIGIN with toggling oom_score_adj
From: David Rientjes <rientjes@google.com>

There's a kernel-wide shortage of per-process flags, so it's always
helpful to trim one when possible without incurring a significant penalty.
 It's even more important when you're planning on adding a per- process
flag yourself, which I plan to do shortly for transparent hugepages.

PF_OOM_ORIGIN is used by ksm and swapoff to prefer current since it has a
tendency to allocate large amounts of memory and should be preferred for
killing over other tasks.  We'd rather immediately kill the task making
the errant syscall rather than penalizing an innocent task.

This patch removes PF_OOM_ORIGIN since its behavior is equivalent to
setting the process's oom_score_adj to OOM_SCORE_ADJ_MAX.

The process's old oom_score_adj is stored and then set to
OOM_SCORE_ADJ_MAX during the time it used to have PF_OOM_ORIGIN.  The old
value is then reinstated when the process should no longer be considered a
high priority for oom killing.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h   |    2 ++
 include/linux/sched.h |    1 -
 mm/ksm.c              |    7 +++++--
 mm/oom_kill.c         |   28 +++++++++++++++++++---------
 mm/swapfile.c         |    6 ++++--
 5 files changed, 30 insertions(+), 14 deletions(-)

diff -puN include/linux/oom.h~oom-replace-pf_oom_origin-with-toggling-oom_score_adj include/linux/oom.h
--- a/include/linux/oom.h~oom-replace-pf_oom_origin-with-toggling-oom_score_adj
+++ a/include/linux/oom.h
@@ -40,6 +40,8 @@ enum oom_constraint {
 	CONSTRAINT_MEMCG,
 };
 
+extern int test_set_oom_score_adj(int new_val);
+
 extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 			const nodemask_t *nodemask, unsigned long totalpages);
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
diff -puN include/linux/sched.h~oom-replace-pf_oom_origin-with-toggling-oom_score_adj include/linux/sched.h
--- a/include/linux/sched.h~oom-replace-pf_oom_origin-with-toggling-oom_score_adj
+++ a/include/linux/sched.h
@@ -1735,7 +1735,6 @@ extern void thread_group_times(struct ta
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
 #define PF_KSWAPD	0x00040000	/* I am kswapd */
-#define PF_OOM_ORIGIN	0x00080000	/* Allocating much memory to others */
 #define PF_LESS_THROTTLE 0x00100000	/* Throttle me less: I clean memory */
 #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
diff -puN mm/ksm.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj mm/ksm.c
--- a/mm/ksm.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj
+++ a/mm/ksm.c
@@ -35,6 +35,7 @@
 #include <linux/ksm.h>
 #include <linux/hash.h>
 #include <linux/freezer.h>
+#include <linux/oom.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -1894,9 +1895,11 @@ static ssize_t run_store(struct kobject 
 	if (ksm_run != flags) {
 		ksm_run = flags;
 		if (flags & KSM_RUN_UNMERGE) {
-			current->flags |= PF_OOM_ORIGIN;
+			int oom_score_adj;
+
+			oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 			err = unmerge_and_remove_all_rmap_items();
-			current->flags &= ~PF_OOM_ORIGIN;
+			test_set_oom_score_adj(oom_score_adj);
 			if (err) {
 				ksm_run = KSM_RUN_STOP;
 				count = err;
diff -puN mm/oom_kill.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj mm/oom_kill.c
--- a/mm/oom_kill.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj
+++ a/mm/oom_kill.c
@@ -38,6 +38,25 @@ int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
+int test_set_oom_score_adj(int new_val)
+{
+	struct sighand_struct *sighand = current->sighand;
+	int old_val;
+
+	spin_lock(&sighand->siglock);
+	old_val = current->signal->oom_score_adj;
+	if (new_val != old_val) {
+		if (new_val == OOM_SCORE_ADJ_MIN)
+			atomic_inc(&current->mm->oom_disable_count);
+		else if (old_val == OOM_SCORE_ADJ_MIN)
+			atomic_dec(&current->mm->oom_disable_count);
+		current->signal->oom_score_adj = new_val;
+	}
+	spin_unlock(&sighand->siglock);
+
+	return old_val;
+}
+
 #ifdef CONFIG_NUMA
 /**
  * has_intersects_mems_allowed() - check task eligiblity for kill
@@ -155,15 +174,6 @@ unsigned int oom_badness(struct task_str
 	}
 
 	/*
-	 * When the PF_OOM_ORIGIN bit is set, it indicates the task should have
-	 * priority for oom killing.
-	 */
-	if (p->flags & PF_OOM_ORIGIN) {
-		task_unlock(p);
-		return 1000;
-	}
-
-	/*
 	 * The memory controller may have a limit of 0 bytes, so avoid a divide
 	 * by zero, if necessary.
 	 */
diff -puN mm/swapfile.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj mm/swapfile.c
--- a/mm/swapfile.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj
+++ a/mm/swapfile.c
@@ -31,6 +31,7 @@
 #include <linux/syscalls.h>
 #include <linux/memcontrol.h>
 #include <linux/poll.h>
+#include <linux/oom.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -1555,6 +1556,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct address_space *mapping;
 	struct inode *inode;
 	char *pathname;
+	int oom_score_adj;
 	int i, type, prev;
 	int err;
 
@@ -1613,9 +1615,9 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->flags &= ~SWP_WRITEOK;
 	spin_unlock(&swap_lock);
 
-	current->flags |= PF_OOM_ORIGIN;
+	oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 	err = try_to_unuse(type);
-	current->flags &= ~PF_OOM_ORIGIN;
+	test_set_oom_score_adj(oom_score_adj);
 
 	if (err) {
 		/*
_

Patches currently in -mm which might be from rientjes@google.com are

mm-optimize-pfn-calculation-in-online_page.patch
linux-next.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-thp-use-conventional-format-for-boolean-attributes.patch
arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-increase-reclaim_distance-to-30.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch

