From: akpm@linux-foundation.org
Subject: - memrlimit-improve-error-handling.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:19:57 -0700
Message-ID: <200810210019.m9L0Jvkk019781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbYJUAUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com


The patch titled
     memrlimit: improve error handling
has been removed from the -mm tree.  Its filename was
     memrlimit-improve-error-handling.patch

This patch was dropped because it was folded into memrlimit-add-memrlimit-controller-accounting-and-control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: improve error handling
From: Balbir Singh <balbir@linux.vnet.ibm.com>

memrlimit cgroup does not handle error cases after may_expand_vm().  This
BUG was reported by Kamezawa, with the test case below to reproduce it

[root@iridium kamezawa]# cat /opt/cgroup/test/memrlimit.usage_in_bytes
71921664
[root@iridium kamezawa]# ulimit -s 3
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ulimit -s unlimited
[root@iridium kamezawa]# cat /opt/cgroup/test/memrlimit.usage_in_bytes
72368128
[root@iridium kamezawa]#

This patch adds better handling support to fix the reported problem.

Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c   |   36 +++++++++++++++++++++++++-----------
 mm/mremap.c |    6 ++++++
 2 files changed, 31 insertions(+), 11 deletions(-)

diff -puN mm/mmap.c~memrlimit-improve-error-handling mm/mmap.c
--- a/mm/mmap.c~memrlimit-improve-error-handling
+++ a/mm/mmap.c
@@ -1129,7 +1129,7 @@ munmap_back:
 			 */
 			charged = len >> PAGE_SHIFT;
 			if (security_vm_enough_memory(charged))
-				return -ENOMEM;
+				goto undo_charge;
 			vm_flags |= VM_ACCOUNT;
 		}
 	}
@@ -1251,6 +1251,8 @@ free_vma:
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
+undo_charge:
+	memrlimit_cgroup_uncharge_as(mm, len >> PAGE_SHIFT);
 	return error;
 }
 
@@ -1546,14 +1548,15 @@ static int acct_stack_growth(struct vm_a
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
@@ -1562,21 +1565,23 @@ static int acct_stack_growth(struct vm_a
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
@@ -1584,6 +1589,11 @@ static int acct_stack_growth(struct vm_a
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
@@ -1986,6 +1996,7 @@ unsigned long do_brk(unsigned long addr,
 	struct rb_node ** rb_link, * rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
+	int ret = -ENOMEM;
 
 	len = PAGE_ALIGN(len);
 	if (!len)
@@ -2039,13 +2050,13 @@ unsigned long do_brk(unsigned long addr,
 
 	/* Check against address space limits *after* clearing old maps... */
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
-		return -ENOMEM;
+		return ret;
 
 	if (mm->map_count > sysctl_max_map_count)
-		return -ENOMEM;
+		goto undo_charge;
 
 	if (security_vm_enough_memory(len >> PAGE_SHIFT))
-		return -ENOMEM;
+		goto undo_charge;
 
 	/* Can we just expand an old private anonymous mapping? */
 	vma = vma_merge(mm, prev, addr, addr + len, flags,
@@ -2059,7 +2070,7 @@ unsigned long do_brk(unsigned long addr,
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma) {
 		vm_unacct_memory(len >> PAGE_SHIFT);
-		return -ENOMEM;
+		goto undo_charge;
 	}
 
 	vma->vm_mm = mm;
@@ -2076,6 +2087,9 @@ out:
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
 	return addr;
+undo_charge:
+	memrlimit_cgroup_uncharge_as(mm, len >> PAGE_SHIFT);
+	return ret;
 }
 
 EXPORT_SYMBOL(do_brk);
diff -puN mm/mremap.c~memrlimit-improve-error-handling mm/mremap.c
--- a/mm/mremap.c~memrlimit-improve-error-handling
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
+	if (vm_expanded)
+		memrlimit_cgroup_uncharge_as(mm,
+				(new_len - old_len) >> PAGE_SHIFT);
 	return ret;
 }
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

