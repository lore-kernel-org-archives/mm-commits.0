From: akpm@linux-foundation.org
Subject: + memrlimit-improve-error-handling.patch added to -mm tree
Date: Wed, 25 Jun 2008 16:34:27 -0700
Message-ID: <200806252334.m5PNYR6l032413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbYFYXfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 19:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit: improve error handling
has been added to the -mm tree.  Its filename is
     memrlimit-improve-error-handling.patch

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
@@ -1124,7 +1124,7 @@ munmap_back:
 			 */
 			charged = len >> PAGE_SHIFT;
 			if (security_vm_enough_memory(charged))
-				return -ENOMEM;
+				goto undo_charge;
 			vm_flags |= VM_ACCOUNT;
 		}
 	}
@@ -1240,6 +1240,8 @@ free_vma:
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
+undo_charge:
+	memrlimit_cgroup_uncharge_as(mm, len >> PAGE_SHIFT);
 	return error;
 }
 
@@ -1535,14 +1537,15 @@ static int acct_stack_growth(struct vm_a
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
@@ -1551,21 +1554,23 @@ static int acct_stack_growth(struct vm_a
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
@@ -1573,6 +1578,11 @@ static int acct_stack_growth(struct vm_a
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
@@ -1959,6 +1969,7 @@ unsigned long do_brk(unsigned long addr,
 	struct rb_node ** rb_link, * rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
+	int ret = -ENOMEM;
 
 	len = PAGE_ALIGN(len);
 	if (!len)
@@ -2012,13 +2023,13 @@ unsigned long do_brk(unsigned long addr,
 
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
 	if (vma_merge(mm, prev, addr, addr + len, flags,
@@ -2031,7 +2042,7 @@ unsigned long do_brk(unsigned long addr,
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma) {
 		vm_unacct_memory(len >> PAGE_SHIFT);
-		return -ENOMEM;
+		goto undo_charge;
 	}
 
 	vma->vm_mm = mm;
@@ -2048,6 +2059,9 @@ out:
 		make_pages_present(addr, addr + len);
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
@@ -18,6 +18,7 @@
 #include <linux/highmem.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/memrlimitcgroup.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -254,6 +255,7 @@ unsigned long do_mremap(unsigned long ad
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
+	int vm_expanded = 0;
 
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
 		goto out;
@@ -347,6 +349,7 @@ unsigned long do_mremap(unsigned long ad
 		goto out;
 	}
 
+	vm_expanded = 1;
 	if (vma->vm_flags & VM_ACCOUNT) {
 		charged = (new_len - old_len) >> PAGE_SHIFT;
 		if (security_vm_enough_memory(charged))
@@ -409,6 +412,9 @@ out:
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

cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix.patch
memrlimit-improve-error-handling.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
distinct-tgid-tid-i-o-statistics.patch
per-task-delay-accounting-add-memory-reclaim-delay.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
memrlimit-fix-usage-of-tmp-as-a-parameter-name.patch

