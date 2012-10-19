From: akpm@linux-foundation.org
Subject: + mm-mempolicy-hold-task-mempolicy-refcount-while-reading-numa_maps.patch added to -mm tree
Date: Fri, 19 Oct 2012 11:47:20 -0700
Message-ID: <20121019184722.67BDB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46615 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2JSSrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Oct 2012 14:47:24 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so61389qae.1
        for <mm-commits@vger.kernel.org>; Fri, 19 Oct 2012 11:47:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, davej@redhat.com, hughd@google.com, khlebnikov@openvz.org, kosaki.motohiro@gmail.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com


The patch titled
     Subject: mm, mempolicy: hold task->mempolicy refcount while reading numa_maps
has been added to the -mm tree.  Its filename is
     mm-mempolicy-hold-task-mempolicy-refcount-while-reading-numa_maps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: mm, mempolicy: hold task->mempolicy refcount while reading numa_maps

/proc/<pid>/numa_maps scans vma and shows mempolicy under mmap_sem.  It
sometimes accesses task->mempolicy which can be freed without mmap_sem and
numa_maps can show some garbage while scanning.

This patch tries to take reference count of task->mempolicy at reading
numa_maps before calling get_vma_policy().  By this, task->mempolicy will
not be freed until numa_maps reaches its end.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    4 +++
 fs/proc/task_mmu.c |   49 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 3 deletions(-)

diff -puN fs/proc/internal.h~mm-mempolicy-hold-task-mempolicy-refcount-while-reading-numa_maps fs/proc/internal.h
--- a/fs/proc/internal.h~mm-mempolicy-hold-task-mempolicy-refcount-while-reading-numa_maps
+++ a/fs/proc/internal.h
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
 struct  ctl_table_header;
+struct  mempolicy;
 
 extern struct proc_dir_entry proc_root;
 #ifdef CONFIG_PROC_SYSCTL
@@ -74,6 +75,9 @@ struct proc_maps_private {
 #ifdef CONFIG_MMU
 	struct vm_area_struct *tail_vma;
 #endif
+#ifdef CONFIG_NUMA
+	struct mempolicy *task_mempolicy;
+#endif
 };
 
 void proc_init_inodecache(void);
diff -puN fs/proc/task_mmu.c~mm-mempolicy-hold-task-mempolicy-refcount-while-reading-numa_maps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-mempolicy-hold-task-mempolicy-refcount-while-reading-numa_maps
+++ a/fs/proc/task_mmu.c
@@ -89,11 +89,55 @@ static void pad_len_spaces(struct seq_fi
 		len = 1;
 	seq_printf(m, "%*c", len, ' ');
 }
+#ifdef CONFIG_NUMA
+/*
+ * These functions are for numa_maps but called in generic **maps seq_file
+ * ->start(), ->stop() ops.
+ *
+ * numa_maps scans all vmas under mmap_sem and checks their mempolicy.
+ * Each mempolicy object is controlled by reference counting. The problem here
+ * is how to avoid accessing dead mempolicy object.
+ *
+ * Because we're holding mmap_sem while reading seq_file, it's safe to access
+ * each vma's mempolicy, no vma objects will never drop refs to mempolicy.
+ *
+ * A task's mempolicy (task->mempolicy) has different behavior. task->mempolicy
+ * is set and replaced under mmap_sem but unrefed and cleared under task_lock().
+ * So, without task_lock(), we cannot trust get_vma_policy() because we cannot
+ * gurantee the task never exits under us. But taking task_lock() around
+ * get_vma_plicy() causes lock order problem.
+ *
+ * To access task->mempolicy without lock, we hold a reference count of an
+ * object pointed by task->mempolicy and remember it. This will guarantee
+ * that task->mempolicy points to an alive object or NULL in numa_maps accesses.
+ */
+static void hold_task_mempolicy(struct proc_maps_private *priv)
+{
+	struct task_struct *task = priv->task;
+
+	task_lock(task);
+	priv->task_mempolicy = task->mempolicy;
+	mpol_get(priv->task_mempolicy);
+	task_unlock(task);
+}
+static void release_task_mempolicy(struct proc_maps_private *priv)
+{
+	mpol_put(priv->task_mempolicy);
+}
+#else
+static void hold_task_mempolicy(struct proc_maps_private *priv)
+{
+}
+static void release_task_mempolicy(struct proc_maps_private *priv)
+{
+}
+#endif
 
 static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 {
 	if (vma && vma != priv->tail_vma) {
 		struct mm_struct *mm = vma->vm_mm;
+		release_task_mempolicy(priv);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
@@ -132,7 +176,7 @@ static void *m_start(struct seq_file *m,
 
 	tail_vma = get_gate_vma(priv->task->mm);
 	priv->tail_vma = tail_vma;
-
+	hold_task_mempolicy(priv);
 	/* Start with last addr hint */
 	vma = find_vma(mm, last_addr);
 	if (last_addr && vma) {
@@ -159,6 +203,7 @@ out:
 	if (vma)
 		return vma;
 
+	release_task_mempolicy(priv);
 	/* End of vmas has been reached */
 	m->version = (tail_vma != NULL)? 0: -1UL;
 	up_read(&mm->mmap_sem);
@@ -1178,11 +1223,9 @@ static int show_numa_map(struct seq_file
 	walk.private = md;
 	walk.mm = mm;
 
-	task_lock(task);
 	pol = get_vma_policy(task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol, 0);
 	mpol_cond_put(pol);
-	task_unlock(task);
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-mempolicy-hold-task-mempolicy-refcount-while-reading-numa_maps.patch
mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-memblock-reduce-overhead-in-binary-search.patch
proc-dont-show-nonexistent-capabilities.patch

