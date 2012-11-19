From: akpm@linux-foundation.org
Subject: [obsolete] uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race.patch removed from -mm tree
Date: Mon, 19 Nov 2012 15:06:19 -0800
Message-ID: <20121119230619.8CE88100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47215 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2KSXGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 18:06:21 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so617990vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 15:06:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ananth@in.ibm.com, anton@redhat.com, mingo@elte.hu, peterz@infradead.org, srikar@linux.vnet.ibm.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: uprobes: use percpu_rw_semaphore to fix register/unregister vs dup_mmap() race
has been removed from the -mm tree.  Its filename was
     uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: uprobes: use percpu_rw_semaphore to fix register/unregister vs dup_mmap() race

This was always racy, but 268720903f87 ("uprobes: Rework
register_for_each_vma() to make it O(n)") should be blamed anyway, it made
everything worse and I didn't notice.

register/unregister call build_map_info() and then do install/remove
breakpoint for every mm which mmaps inode/offset.  This can obviously race
with fork()->dup_mmap() in between and we can miss the child.

uprobe_register() could be easily fixed but unregister is much worse, the
new mm inherits "int3" from parent and there is no way to detect this if
uprobe goes away.

So this patch simply adds percpu_down_read/up_read around dup_mmap(), and
percpu_down_write/up_write into register_for_each_vma().

This adds 2 new hooks into dup_mmap() but we can kill uprobe_dup_mmap()
and fold it into uprobe_end_dup_mmap().

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uprobes.h |    8 ++++++++
 kernel/events/uprobes.c |   26 +++++++++++++++++++++++---
 kernel/fork.c           |    2 ++
 3 files changed, 33 insertions(+), 3 deletions(-)

diff -puN include/linux/uprobes.h~uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race include/linux/uprobes.h
--- a/include/linux/uprobes.h~uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race
+++ a/include/linux/uprobes.h
@@ -97,6 +97,8 @@ extern int uprobe_register(struct inode 
 extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_mmap(struct vm_area_struct *vma);
 extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end);
+extern void uprobe_start_dup_mmap(void);
+extern void uprobe_end_dup_mmap(void);
 extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
 extern void uprobe_free_utask(struct task_struct *t);
 extern void uprobe_copy_process(struct task_struct *t);
@@ -129,6 +131,12 @@ static inline void
 uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 }
+static inline void uprobe_start_dup_mmap(void)
+{
+}
+static inline void uprobe_end_dup_mmap(void)
+{
+}
 static inline void
 uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
diff -puN kernel/events/uprobes.c~uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race
+++ a/kernel/events/uprobes.c
@@ -33,6 +33,7 @@
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
 #include "../../mm/internal.h"	/* munlock_vma_page */
+#include <linux/percpu-rwsem.h>
 
 #include <linux/uprobes.h>
 
@@ -71,6 +72,8 @@ static struct mutex uprobes_mutex[UPROBE
 static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
 #define uprobes_mmap_hash(v)	(&uprobes_mmap_mutex[((unsigned long)(v)) % UPROBES_HASH_SZ])
 
+static struct percpu_rw_semaphore dup_mmap_sem;
+
 /*
  * uprobe_events allows us to skip the uprobe_mmap if there are no uprobe
  * events active at this time.  Probably a fine grained per inode count is
@@ -766,10 +769,13 @@ static int register_for_each_vma(struct 
 	struct map_info *info;
 	int err = 0;
 
+	percpu_down_write(&dup_mmap_sem);
 	info = build_map_info(uprobe->inode->i_mapping,
 					uprobe->offset, is_register);
-	if (IS_ERR(info))
-		return PTR_ERR(info);
+	if (IS_ERR(info)) {
+		err = PTR_ERR(info);
+		goto out;
+	}
 
 	while (info) {
 		struct mm_struct *mm = info->mm;
@@ -799,7 +805,8 @@ static int register_for_each_vma(struct 
 		mmput(mm);
 		info = free_map_info(info);
 	}
-
+ out:
+	percpu_up_write(&dup_mmap_sem);
 	return err;
 }
 
@@ -1131,6 +1138,16 @@ void uprobe_clear_state(struct mm_struct
 	kfree(area);
 }
 
+void uprobe_start_dup_mmap(void)
+{
+	percpu_down_read(&dup_mmap_sem);
+}
+
+void uprobe_end_dup_mmap(void)
+{
+	percpu_up_read(&dup_mmap_sem);
+}
+
 void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
 	newmm->uprobes_state.xol_area = NULL;
@@ -1604,6 +1621,9 @@ static int __init init_uprobes(void)
 		mutex_init(&uprobes_mmap_mutex[i]);
 	}
 
+	if (percpu_init_rwsem(&dup_mmap_sem))
+		return -ENOMEM;
+
 	return register_die_notifier(&uprobe_exception_nb);
 }
 module_init(init_uprobes);
diff -puN kernel/fork.c~uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race kernel/fork.c
--- a/kernel/fork.c~uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race
+++ a/kernel/fork.c
@@ -352,6 +352,7 @@ static int dup_mmap(struct mm_struct *mm
 	unsigned long charge;
 	struct mempolicy *pol;
 
+	uprobe_start_dup_mmap();
 	down_write(&oldmm->mmap_sem);
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
@@ -469,6 +470,7 @@ out:
 	up_write(&mm->mmap_sem);
 	flush_tlb_mm(oldmm);
 	up_write(&oldmm->mmap_sem);
+	uprobe_end_dup_mmap();
 	return retval;
 fail_nomem_anon_vma_fork:
 	mpol_put(pol);
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch
percpu_rw_semaphore-kill-writer_mutex-add-write_ctr.patch
percpu_rw_semaphore-add-the-lockdep-annotations.patch
percpu_rw_semaphore-introduce-config_percpu_rwsem.patch
ptrace-introduce-ptrace_o_exitkill.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

