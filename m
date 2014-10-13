From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:20:17 -0700
Message-ID: <543c17e1.zQmhU+aZR/sboK/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaJMSUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: unexport get_vma_policy() and remove its "task" arg
has been removed from the -mm tree.  Its filename was
     mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: unexport get_vma_policy() and remove its "task" arg

- get_vma_policy(task) is not safe if task != current, remove this
  argument.

- get_vma_policy() no longer has callers outside of mempolicy.c,
  make it static.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 --
 mm/mempolicy.c            |   19 ++++++++-----------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg
+++ a/include/linux/mempolicy.h
@@ -137,8 +137,6 @@ struct mempolicy *mpol_shared_policy_loo
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 		unsigned long addr);
-struct mempolicy *get_vma_policy(struct task_struct *tsk,
-		struct vm_area_struct *vma, unsigned long addr);
 bool vma_policy_mof(struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
diff -puN mm/mempolicy.c~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg
+++ a/mm/mempolicy.c
@@ -1616,27 +1616,24 @@ struct mempolicy *__get_vma_policy(struc
 }
 
 /*
- * get_vma_policy(@task, @vma, @addr)
- * @task: task for fallback if vma policy == default
+ * get_vma_policy(@vma, @addr)
  * @vma: virtual memory area whose policy is sought
  * @addr: address in @vma for shared policy lookup
  *
  * Returns effective policy for a VMA at specified address.
- * Falls back to @task or system default policy, as necessary.
- * Current or other task's task mempolicy and non-shared vma policies must be
- * protected by task_lock(task) by the caller.
+ * Falls back to current->mempolicy or system default policy, as necessary.
  * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
  * count--added by the get_policy() vm_op, as appropriate--to protect against
  * freeing by another task.  It is the caller's responsibility to free the
  * extra reference for shared policies.
  */
-struct mempolicy *get_vma_policy(struct task_struct *task,
-		struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
+						unsigned long addr)
 {
 	struct mempolicy *pol = __get_vma_policy(vma, addr);
 
 	if (!pol)
-		pol = get_task_policy(task);
+		pol = get_task_policy(current);
 
 	return pol;
 }
@@ -1864,7 +1861,7 @@ struct zonelist *huge_zonelist(struct vm
 {
 	struct zonelist *zl;
 
-	*mpol = get_vma_policy(current, vma, addr);
+	*mpol = get_vma_policy(vma, addr);
 	*nodemask = NULL;	/* assume !MPOL_BIND */
 
 	if (unlikely((*mpol)->mode == MPOL_INTERLEAVE)) {
@@ -2019,7 +2016,7 @@ alloc_pages_vma(gfp_t gfp, int order, st
 	unsigned int cpuset_mems_cookie;
 
 retry_cpuset:
-	pol = get_vma_policy(current, vma, addr);
+	pol = get_vma_policy(vma, addr);
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
@@ -2285,7 +2282,7 @@ int mpol_misplaced(struct page *page, st
 
 	BUG_ON(!vma);
 
-	pol = get_vma_policy(current, vma, addr);
+	pol = get_vma_policy(vma, addr);
 	if (!(pol->flags & MPOL_F_MOF))
 		goto out;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

