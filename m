From: akpm@linux-foundation.org
Subject: - memrlimit-add-memrlimit-controller-accounting-and-control.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:21:39 -0700
Message-ID: <200810210021.m9L0LdT5020155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829AbYJUAWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, righi.andrea@gmail.com, skumar@linux.vnet.ibm


The patch titled
     memrlimit: add memrlimit controller accounting and control
has been removed from the -mm tree.  Its filename was
     memrlimit-add-memrlimit-controller-accounting-and-control.patch

This patch was dropped because of lack of enthusiasm

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: add memrlimit controller accounting and control
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch adds support for accounting and control of virtual address space
limits. The accounting is done via the rlimit_cgroup_(un)charge_as functions.
The core of the accounting takes place during fork time in copy_process(),
may_expand_vm(), remove_vma_list() and exit_mmap().

[akpm@linux-foundation.org: coding-style fixes]
[righi.andrea@gmail.com: memrlimit: fix task_lock() recursive locking]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c        |    1 
 include/linux/memrlimitcgroup.h |   21 +++++
 kernel/cgroup.c                 |    3 
 kernel/fork.c                   |   15 +++-
 mm/memrlimitcgroup.c            |  107 ++++++++++++++++++++++++++++++
 mm/mmap.c                       |   62 +++++++++++++----
 mm/mremap.c                     |    6 +
 7 files changed, 200 insertions(+), 15 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~memrlimit-add-memrlimit-controller-accounting-and-control arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/memrlimitcgroup.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff -puN include/linux/memrlimitcgroup.h~memrlimit-add-memrlimit-controller-accounting-and-control include/linux/memrlimitcgroup.h
--- a/include/linux/memrlimitcgroup.h~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/include/linux/memrlimitcgroup.h
@@ -16,4 +16,25 @@
 #ifndef LINUX_MEMRLIMITCGROUP_H
 #define LINUX_MEMRLIMITCGROUP_H
 
+#ifdef CONFIG_CGROUP_MEMRLIMIT_CTLR
+
+int memrlimit_cgroup_charge_as(struct mm_struct *mm, unsigned long nr_pages);
+void memrlimit_cgroup_uncharge_as(struct mm_struct *mm, unsigned long nr_pages);
+
+#else /* !CONFIG_CGROUP_RLIMIT_CTLR */
+
+static inline int
+memrlimit_cgroup_charge_as(struct mm_struct *mm, unsigned long nr_pages)
+{
+	return 0;
+}
+
+static inline void
+memrlimit_cgroup_uncharge_as(struct mm_struct *mm, unsigned long nr_pages)
+{
+}
+
+#endif /* CONFIG_CGROUP_RLIMIT_CTLR */
+
+
 #endif /* LINUX_MEMRLIMITCGROUP_H */
diff -puN kernel/fork.c~memrlimit-add-memrlimit-controller-accounting-and-control kernel/fork.c
--- a/kernel/fork.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/kernel/fork.c
@@ -51,6 +51,7 @@
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
+#include <linux/memrlimitcgroup.h>
 #include <linux/freezer.h>
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
@@ -263,7 +264,7 @@ static int dup_mmap(struct mm_struct *mm
 	struct vm_area_struct *mpnt, *tmp, **pprev;
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
-	unsigned long charge;
+	unsigned long charge, uncharged = 0;
 	struct mempolicy *pol;
 
 	down_write(&oldmm->mmap_sem);
@@ -285,6 +286,16 @@ static int dup_mmap(struct mm_struct *mm
 	rb_parent = NULL;
 	pprev = &mm->mmap;
 
+	/*
+	 * Called after mm->mmap is set to NULL, so that the routines
+	 * following this function understand that fork failed (read
+	 * mmput).
+	 */
+	if (memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm)) {
+		retval = -ENOMEM;
+		goto out;
+	}
+
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
 		struct file *file;
 
@@ -293,6 +304,8 @@ static int dup_mmap(struct mm_struct *mm
 			mm->total_vm -= pages;
 			vm_stat_account(mm, mpnt->vm_flags, mpnt->vm_file,
 								-pages);
+			memrlimit_cgroup_uncharge_as(mm, pages);
+			uncharged += pages;
 			continue;
 		}
 		charge = 0;
diff -puN mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/mm/memrlimitcgroup.c
@@ -45,6 +45,44 @@ static struct memrlimit_cgroup *memrlimi
 				struct memrlimit_cgroup, css);
 }
 
+static struct memrlimit_cgroup *
+memrlimit_cgroup_from_task(struct task_struct *p)
+{
+	return container_of(task_subsys_state(p, memrlimit_cgroup_subsys_id),
+				struct memrlimit_cgroup, css);
+}
+
+/*
+ * Charge the cgroup for address space usage - mmap(), malloc() (through
+ * brk(), sbrk()), stack expansion, mremap(), etc - called with
+ * mmap_sem held.
+ */
+int memrlimit_cgroup_charge_as(struct mm_struct *mm, unsigned long nr_pages)
+{
+	struct memrlimit_cgroup *memrcg;
+
+	memrcg = memrlimit_cgroup_from_task(mm->owner);
+	return res_counter_charge(&memrcg->as_res, (nr_pages << PAGE_SHIFT));
+}
+
+/*
+ * Uncharge the cgroup, as the address space of one of the tasks is
+ * decreasing - called with mmap_sem held.
+ */
+void memrlimit_cgroup_uncharge_as(struct mm_struct *mm, unsigned long nr_pages)
+{
+	struct memrlimit_cgroup *memrcg;
+
+	/*
+	 * Uncharge happened as a part of the mm_owner_changed callback
+	 */
+	if (!mm->owner)
+		return;
+
+	memrcg = memrlimit_cgroup_from_task(mm->owner);
+	res_counter_uncharge(&memrcg->as_res, (nr_pages << PAGE_SHIFT));
+}
+
 static struct cgroup_subsys_state *
 memrlimit_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
@@ -121,11 +159,80 @@ static int memrlimit_cgroup_populate(str
 				ARRAY_SIZE(memrlimit_cgroup_files));
 }
 
+static void memrlimit_cgroup_move_task(struct cgroup_subsys *ss,
+					struct cgroup *cgrp,
+					struct cgroup *old_cgrp,
+					struct task_struct *p)
+{
+	struct mm_struct *mm;
+	struct memrlimit_cgroup *memrcg, *old_memrcg;
+
+	mm = get_task_mm(p);
+	if (mm == NULL)
+		return;
+
+	/*
+	 * Hold mmap_sem, so that total_vm does not change underneath us
+	 */
+	down_read(&mm->mmap_sem);
+
+	rcu_read_lock();
+	if (p != rcu_dereference(mm->owner))
+		goto out;
+
+	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
+	old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
+
+	if (memrcg == old_memrcg)
+		goto out;
+
+	if (res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
+		goto out;
+	res_counter_uncharge(&old_memrcg->as_res, (mm->total_vm << PAGE_SHIFT));
+out:
+	rcu_read_unlock();
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+}
+
+/*
+ * This callback is called with mmap_sem and task_lock held
+ */
+static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
+						struct cgroup *old_cgrp,
+						struct cgroup *cgrp,
+						struct task_struct *p)
+{
+	struct memrlimit_cgroup *memrcg, *old_memrcg;
+	struct mm_struct *mm = p->mm;
+
+	BUG_ON(!mm || (p->flags & PF_KTHREAD));
+
+	/*
+	 * If we don't have a new cgroup, we just uncharge from the old one.
+	 * It means that the task is going away
+	 */
+	if (cgrp) {
+		memrcg = memrlimit_cgroup_from_cgrp(cgrp);
+		if (res_counter_charge(&memrcg->as_res,
+				mm->total_vm << PAGE_SHIFT))
+			return;
+	}
+
+	if (old_cgrp) {
+		old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
+		res_counter_uncharge(&old_memrcg->as_res,
+				mm->total_vm << PAGE_SHIFT);
+	}
+}
+
 struct cgroup_subsys memrlimit_cgroup_subsys = {
 	.name = "memrlimit",
 	.subsys_id = memrlimit_cgroup_subsys_id,
 	.create = memrlimit_cgroup_create,
 	.destroy = memrlimit_cgroup_destroy,
 	.populate = memrlimit_cgroup_populate,
+	.attach = memrlimit_cgroup_move_task,
+	.mm_owner_changed = memrlimit_cgroup_mm_owner_changed,
 	.early_init = 0,
 };
diff -puN mm/mmap.c~memrlimit-add-memrlimit-controller-accounting-and-control mm/mmap.c
--- a/mm/mmap.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/mm/mmap.c
@@ -23,6 +23,7 @@
 #include <linux/hugetlb.h>
 #include <linux/profile.h>
 #include <linux/module.h>
+#include <linux/memrlimitcgroup.h>
 #include <linux/mount.h>
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
@@ -1128,7 +1129,7 @@ munmap_back:
 			 */
 			charged = len >> PAGE_SHIFT;
 			if (security_vm_enough_memory(charged))
-				return -ENOMEM;
+				goto undo_charge;
 			vm_flags |= VM_ACCOUNT;
 		}
 	}
@@ -1250,6 +1251,8 @@ free_vma:
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
+undo_charge:
+	memrlimit_cgroup_uncharge_as(mm, len >> PAGE_SHIFT);
 	return error;
 }
 
@@ -1545,14 +1548,15 @@ static int acct_stack_growth(struct vm_a
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
 	unsigned long new_start;
+	int ret = -ENOMEM;
 
 	/* address space limit tests */
 	if (!may_expand_vm(mm, grow))
-		return -ENOMEM;
+		goto out;
 
 	/* Stack limit test */
 	if (size > rlim[RLIMIT_STACK].rlim_cur)
-		return -ENOMEM;
+		goto undo_charge;
 
 	/* mlock limit tests */
 	if (vma->vm_flags & VM_LOCKED) {
@@ -1561,21 +1565,23 @@ static int acct_stack_growth(struct vm_a
 		locked = mm->locked_vm + grow;
 		limit = rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
 		if (locked > limit && !capable(CAP_IPC_LOCK))
-			return -ENOMEM;
+			goto undo_charge;
 	}
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
 	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
 			vma->vm_end - size;
-	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
-		return -EFAULT;
+	if (is_hugepage_only_range(vma->vm_mm, new_start, size)) {
+		ret = -EFAULT;
+		goto undo_charge;
+	}
 
 	/*
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
 	if (security_vm_enough_memory(grow))
-		return -ENOMEM;
+		goto undo_charge;
 
 	/* Ok, everything looks good - let it rip */
 	mm->total_vm += grow;
@@ -1583,6 +1589,11 @@ static int acct_stack_growth(struct vm_a
 		mm->locked_vm += grow;
 	vm_stat_account(mm, vma->vm_flags, vma->vm_file, grow);
 	return 0;
+undo_charge:
+	/* Undo memrlimit charge */
+	memrlimit_cgroup_uncharge_as(mm, grow);
+out:
+	return ret;
 }
 
 #if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
@@ -1756,6 +1767,7 @@ static void remove_vma_list(struct mm_st
 		long nrpages = vma_pages(vma);
 
 		mm->total_vm -= nrpages;
+		memrlimit_cgroup_uncharge_as(mm, nrpages);
 		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
 		vma = remove_vma(vma);
 	} while (vma);
@@ -2035,15 +2047,16 @@ unsigned long do_brk(unsigned long addr,
 		goto munmap_back;
 	}
 
+	error = -ENOMEM;
 	/* Check against address space limits *after* clearing old maps... */
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
-		return -ENOMEM;
+		return error;
 
 	if (mm->map_count > sysctl_max_map_count)
-		return -ENOMEM;
+		goto undo_charge;
 
 	if (security_vm_enough_memory(len >> PAGE_SHIFT))
-		return -ENOMEM;
+		goto undo_charge;
 
 	/* Can we just expand an old private anonymous mapping? */
 	vma = vma_merge(mm, prev, addr, addr + len, flags,
@@ -2057,7 +2070,7 @@ unsigned long do_brk(unsigned long addr,
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma) {
 		vm_unacct_memory(len >> PAGE_SHIFT);
-		return -ENOMEM;
+		goto undo_charge;
 	}
 
 	vma->vm_mm = mm;
@@ -2074,6 +2087,9 @@ out:
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
 	return addr;
+undo_charge:
+	memrlimit_cgroup_uncharge_as(mm, len >> PAGE_SHIFT);
+	return error;
 }
 
 EXPORT_SYMBOL(do_brk);
@@ -2099,6 +2115,15 @@ void exit_mmap(struct mm_struct *mm)
 		}
 	}
 	vma = mm->mmap;
+
+	/*
+	 * In the case that dup_mm() failed, mm->mmap is NULL and
+	 * we never really setup the mm. We don't have much to do,
+	 * we might as well return early
+	 */
+	if (!vma)
+		return;
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
@@ -2106,6 +2131,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
+	memrlimit_cgroup_uncharge_as(mm, mm->total_vm);
 	free_pgtables(tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
 
@@ -2128,6 +2154,9 @@ int insert_vm_struct(struct mm_struct * 
 	struct vm_area_struct * __vma, * prev;
 	struct rb_node ** rb_link, * rb_parent;
 
+	if (memrlimit_cgroup_charge_as(mm, vma_pages(vma)))
+		return -ENOMEM;
+
 	/*
 	 * The vm_pgoff of a purely anonymous vma should be irrelevant
 	 * until its first write fault, when page's anon_vma and index
@@ -2146,12 +2175,15 @@ int insert_vm_struct(struct mm_struct * 
 	}
 	__vma = find_vma_prepare(mm,vma->vm_start,&prev,&rb_link,&rb_parent);
 	if (__vma && __vma->vm_start < vma->vm_end)
-		return -ENOMEM;
+		goto err;
 	if ((vma->vm_flags & VM_ACCOUNT) &&
 	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
-		return -ENOMEM;
+		goto err;
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
+err:
+	memrlimit_cgroup_uncharge_as(mm, vma_pages(vma));
+	return -ENOMEM;
 }
 
 /*
@@ -2224,6 +2256,10 @@ int may_expand_vm(struct mm_struct *mm, 
 
 	if (cur + npages > lim)
 		return 0;
+
+	if (memrlimit_cgroup_charge_as(mm, npages))
+		return 0;
+
 	return 1;
 }
 
diff -puN kernel/cgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control kernel/cgroup.c
--- a/kernel/cgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/kernel/cgroup.c
@@ -2792,7 +2792,8 @@ void cgroup_fork_callbacks(struct task_s
  * invoke this routine, since it assigns the mm->owner the first time
  * and does not change it.
  *
- * The callbacks are invoked with mmap_sem held in read mode.
+ * The callbacks are invoked with task_lock held and mmap_sem held in read
+ * mode.
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
diff -puN mm/mremap.c~memrlimit-add-memrlimit-controller-accounting-and-control mm/mremap.c
--- a/mm/mremap.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/mm/mremap.c
@@ -13,6 +13,7 @@
 #include <linux/shm.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
+#include <linux/memrlimitcgroup.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
 #include <linux/highmem.h>
@@ -267,6 +268,7 @@ unsigned long do_mremap(unsigned long ad
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
+	int vm_expanded = 0;
 
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
 		goto out;
@@ -360,6 +362,7 @@ unsigned long do_mremap(unsigned long ad
 		goto out;
 	}
 
+	vm_expanded = 1;
 	if (vma->vm_flags & VM_ACCOUNT) {
 		charged = (new_len - old_len) >> PAGE_SHIFT;
 		if (security_vm_enough_memory(charged))
@@ -424,6 +427,9 @@ out:
 	if (ret & ~PAGE_MASK)
 		vm_unacct_memory(charged);
 out_nc:
+	if ((ret & ~PAGE_MASK) && vm_expanded)
+		memrlimit_cgroup_uncharge_as(mm,
+				(new_len - old_len) >> PAGE_SHIFT);
 	return ret;
 }
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

