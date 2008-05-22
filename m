From: akpm@linux-foundation.org
Subject: + memrlimit-add-memrlimit-controller-accounting-and-control.patch added to -mm tree
Date: Wed, 21 May 2008 21:29:24 -0700
Message-ID: <200805220429.m4M4TOpe017028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbYEVEaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 00:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit: add memrlimit controller accounting and control
has been added to the -mm tree.  Its filename is
     memrlimit-add-memrlimit-controller-accounting-and-control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: add memrlimit controller accounting and control
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch adds support for accounting and control of virtual address space
limits. The accounting is done via the rlimit_cgroup_(un)charge_as functions.
The core of the accounting takes place during fork time in copy_process(),
may_expand_vm(), remove_vma_list() and exit_mmap().

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c        |   18 ++++-
 include/linux/memrlimitcgroup.h |   21 ++++++
 kernel/fork.c                   |    8 ++
 mm/memrlimitcgroup.c            |   92 ++++++++++++++++++++++++++++++
 mm/mmap.c                       |   17 ++++-
 5 files changed, 149 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~memrlimit-add-memrlimit-controller-accounting-and-control arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/arch/x86/kernel/ptrace.c
@@ -20,6 +20,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/memrlimitcgroup.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -782,21 +783,25 @@ static int ptrace_bts_realloc(struct tas
 
 	current->mm->total_vm  -= old_size;
 	current->mm->locked_vm -= old_size;
+	memrlimit_cgroup_uncharge_as(mm, old_size);
 
 	if (size == 0)
 		goto out;
 
+	if (memrlimit_cgroup_charge_as(current->mm, size))
+		goto out;
+
 	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
 	vm = current->mm->total_vm  + size;
 	if (rlim < vm) {
 		ret = -ENOMEM;
 
 		if (!reduce_size)
-			goto out;
+			goto out_uncharge;
 
 		size = rlim - current->mm->total_vm;
 		if (size <= 0)
-			goto out;
+			goto out_uncharge;
 	}
 
 	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
@@ -805,21 +810,24 @@ static int ptrace_bts_realloc(struct tas
 		ret = -ENOMEM;
 
 		if (!reduce_size)
-			goto out;
+			goto out_uncharge;
 
 		size = rlim - current->mm->locked_vm;
 		if (size <= 0)
-			goto out;
+			goto out_uncharge;
 	}
 
 	ret = ds_allocate((void **)&child->thread.ds_area_msr,
 			  size << PAGE_SHIFT);
 	if (ret < 0)
-		goto out;
+		goto out_uncharge;
 
 	current->mm->total_vm  += size;
 	current->mm->locked_vm += size;
 
+out_uncharge:
+	if (ret < 0)
+		memrlimit_cgroup_uncharge_as(mm, size);
 out:
 	if (child->thread.ds_area_msr)
 		set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
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
@@ -47,6 +47,7 @@
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
+#include <linux/memrlimitcgroup.h>
 #include <linux/freezer.h>
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
@@ -272,6 +273,7 @@ static int dup_mmap(struct mm_struct *mm
 			mm->total_vm -= pages;
 			vm_stat_account(mm, mpnt->vm_flags, mpnt->vm_file,
 								-pages);
+			memrlimit_cgroup_uncharge_as(mm, pages);
 			continue;
 		}
 		charge = 0;
@@ -601,6 +603,12 @@ static int copy_mm(unsigned long clone_f
 		atomic_inc(&oldmm->mm_users);
 		mm = oldmm;
 		goto good_mm;
+	} else {
+		down_write(&oldmm->mmap_sem);
+		retval = memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm);
+		up_write(&oldmm->mmap_sem);
+		if (retval)
+			goto fail_nomem;
 	}
 
 	retval = -ENOMEM;
diff -puN mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control
+++ a/mm/memrlimitcgroup.c
@@ -45,6 +45,38 @@ static struct memrlimit_cgroup *memrlimi
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
+	memrcg = memrlimit_cgroup_from_task(mm->owner);
+	res_counter_uncharge(&memrcg->as_res, (nr_pages << PAGE_SHIFT));
+}
+
 static struct cgroup_subsys_state *
 memrlimit_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
@@ -134,11 +166,71 @@ static int memrlimit_cgroup_populate(str
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
+ * This callback is called with mmap_sem held
+ */
+static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
+						struct cgroup *cgrp,
+						struct cgroup *old_cgrp,
+						struct task_struct *p)
+{
+	struct memrlimit_cgroup *memrcg, *old_memrcg;
+	struct mm_struct *mm = get_task_mm(p);
+
+	BUG_ON(!mm);
+	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
+	old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
+
+	if (res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
+		goto out;
+	res_counter_uncharge(&old_memrcg->as_res, (mm->total_vm << PAGE_SHIFT));
+out:
+	mmput(mm);
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
@@ -26,6 +26,7 @@
 #include <linux/mount.h>
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
+#include <linux/memrlimitcgroup.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1732,6 +1733,7 @@ static void remove_vma_list(struct mm_st
 		long nrpages = vma_pages(vma);
 
 		mm->total_vm -= nrpages;
+		memrlimit_cgroup_uncharge_as(mm, nrpages);
 		if (vma->vm_flags & VM_LOCKED)
 			mm->locked_vm -= nrpages;
 		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
@@ -1758,6 +1760,7 @@ static void unmap_region(struct mm_struc
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
+	memrlimit_cgroup_uncharge_as(mm, mm->total_vm);
 	free_pgtables(tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
 	tlb_finish_mmu(tlb, start, end);
@@ -2080,6 +2083,9 @@ int insert_vm_struct(struct mm_struct * 
 	struct vm_area_struct * __vma, * prev;
 	struct rb_node ** rb_link, * rb_parent;
 
+	if (memrlimit_cgroup_charge_as(mm, vma_pages(vma)))
+		return -ENOMEM;
+
 	/*
 	 * The vm_pgoff of a purely anonymous vma should be irrelevant
 	 * until its first write fault, when page's anon_vma and index
@@ -2098,12 +2104,15 @@ int insert_vm_struct(struct mm_struct * 
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
@@ -2176,6 +2185,10 @@ int may_expand_vm(struct mm_struct *mm, 
 
 	if (cur + npages > lim)
 		return 0;
+
+	if (memrlimit_cgroup_charge_as(mm, npages))
+		return 0;
+
 	return 1;
 }
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch

