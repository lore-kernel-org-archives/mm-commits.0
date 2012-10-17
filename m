From: akpm@linux-foundation.org
Subject: + mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:53:29 -0700
Message-ID: <20121017225329.BB3C01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40356 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2JQWxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:53:31 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so141769qae.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:53:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, davej@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@gmail.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm, mempolicy: avoid taking mutex inside spinlock when reading numa_maps
has been added to the -mm tree.  Its filename is
     mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: avoid taking mutex inside spinlock when reading numa_maps

As a result of commit 32f8516a8c73 ("mm, mempolicy: fix printing stack
contents in numa_maps"), the mutex protecting a shared policy can be
inadvertently taken while holding task_lock(task).

Recently, commit b22d127a39dd ("mempolicy: fix a race in
shared_policy_replace()") switched the spinlock within a shared policy to
a mutex so sp_alloc() could block.  Thus, a refcount must be grabbed on
all mempolicies returned by get_vma_policy() so it isn't freed while being
passed to mpol_to_str() when reading /proc/pid/numa_maps.

This patch only takes task_lock() while dereferencing task->mempolicy in
get_vma_policy() if it's non-NULL in the lockess check to increment its
refcount.  This ensures it will remain in memory until dropped by
__mpol_put() after mpol_to_str() is called.

Refcounts of shared policies are grabbed by the ->get_policy() function of
the vma, all others will be grabbed directly in get_vma_policy().  Now
that this is done, all callers now unconditionally drop the refcount.

Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Dave Jones <davej@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c        |    4 -
 include/linux/mempolicy.h |   12 -----
 mm/hugetlb.c              |    4 -
 mm/mempolicy.c            |   79 +++++++++++++++---------------------
 4 files changed, 39 insertions(+), 60 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps
+++ a/fs/proc/task_mmu.c
@@ -1178,11 +1178,9 @@ static int show_numa_map(struct seq_file
 	walk.private = md;
 	walk.mm = mm;
 
-	task_lock(task);
 	pol = get_vma_policy(task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol, 0);
-	mpol_cond_put(pol);
-	task_unlock(task);
+	__mpol_put(pol);
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
diff -puN include/linux/mempolicy.h~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps
+++ a/include/linux/mempolicy.h
@@ -73,13 +73,7 @@ static inline void mpol_put(struct mempo
  */
 static inline int mpol_needs_cond_ref(struct mempolicy *pol)
 {
-	return (pol && (pol->flags & MPOL_F_SHARED));
-}
-
-static inline void mpol_cond_put(struct mempolicy *pol)
-{
-	if (mpol_needs_cond_ref(pol))
-		__mpol_put(pol);
+	return pol->flags & MPOL_F_SHARED;
 }
 
 extern struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
@@ -211,10 +205,6 @@ static inline void mpol_put(struct mempo
 {
 }
 
-static inline void mpol_cond_put(struct mempolicy *pol)
-{
-}
-
 static inline struct mempolicy *mpol_cond_copy(struct mempolicy *to,
 						struct mempolicy *from)
 {
diff -puN mm/hugetlb.c~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps mm/hugetlb.c
--- a/mm/hugetlb.c~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps
+++ a/mm/hugetlb.c
@@ -568,13 +568,13 @@ retry_cpuset:
 		}
 	}
 
-	mpol_cond_put(mpol);
+	__mpol_put(mpol);
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
 	return page;
 
 err:
-	mpol_cond_put(mpol);
+	__mpol_put(mpol);
 	return NULL;
 }
 
diff -puN mm/mempolicy.c~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps
+++ a/mm/mempolicy.c
@@ -906,7 +906,8 @@ static long do_get_mempolicy(int *policy
 	}
 
  out:
-	mpol_cond_put(pol);
+	if (mpol_needs_cond_ref(pol))
+		__mpol_put(pol);
 	if (vma)
 		up_read(&current->mm->mmap_sem);
 	return err;
@@ -1527,48 +1528,54 @@ asmlinkage long compat_sys_mbind(compat_
 }
 
 #endif
-
-/*
- * get_vma_policy(@task, @vma, @addr)
- * @task - task for fallback if vma policy == default
- * @vma   - virtual memory area whose policy is sought
- * @addr  - address in @vma for shared policy lookup
+/**
+ * get_vma_policy() - return effective policy for a vma at specified address
+ * @task: task for fallback if vma policy == default_policy
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup
  *
- * Returns effective policy for a VMA at specified address.
  * Falls back to @task or system default policy, as necessary.
- * Current or other task's task mempolicy and non-shared vma policies must be
- * protected by task_lock(task) by the caller.
- * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
- * count--added by the get_policy() vm_op, as appropriate--to protect against
- * freeing by another task.  It is the caller's responsibility to free the
- * extra reference for shared policies.
+ * Increments the reference count of the returned mempolicy, it is the caller's
+ * responsibility to decrement with __mpol_put().
+ * Requires vma->vm_mm->mmap_sem to be held for vma policies and takes
+ * task_lock(task) for task policy fallback.
  */
 struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
 
+	/*
+	 * Grab a reference before task has the potential to exit and free its
+	 * mempolicy.
+	 */
+	if (pol) {
+		task_lock(task);
+		pol = task->mempolicy;
+		mpol_get(pol);
+		task_unlock(task);
+	}
+
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
 			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
 									addr);
-			if (vpol)
+			if (vpol) {
+				mpol_put(pol);
 				pol = vpol;
+				if (!mpol_needs_cond_ref(pol))
+					mpol_get(pol);
+			}
 		} else if (vma->vm_policy) {
+			mpol_put(pol);
 			pol = vma->vm_policy;
-
-			/*
-			 * shmem_alloc_page() passes MPOL_F_SHARED policy with
-			 * a pseudo vma whose vma->vm_ops=NULL. Take a reference
-			 * count on these policies which will be dropped by
-			 * mpol_cond_put() later
-			 */
-			if (mpol_needs_cond_ref(pol))
-				mpol_get(pol);
+			mpol_get(pol);
 		}
 	}
-	if (!pol)
+	if (!pol) {
 		pol = &default_policy;
+		mpol_get(pol);
+	}
 	return pol;
 }
 
@@ -1919,30 +1926,14 @@ retry_cpuset:
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
-		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
-			goto retry_cpuset;
-
-		return page;
+		goto out;
 	}
 	zl = policy_zonelist(gfp, pol, node);
-	if (unlikely(mpol_needs_cond_ref(pol))) {
-		/*
-		 * slow path: ref counted shared policy
-		 */
-		struct page *page =  __alloc_pages_nodemask(gfp, order,
-						zl, policy_nodemask(gfp, pol));
-		__mpol_put(pol);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
-			goto retry_cpuset;
-		return page;
-	}
-	/*
-	 * fast path:  default or task policy
-	 */
 	page = __alloc_pages_nodemask(gfp, order, zl,
 				      policy_nodemask(gfp, pol));
+out:
+	__mpol_put(pol);
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
 	return page;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch

