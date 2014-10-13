From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:20:11 -0700
Message-ID: <543c17db.A8CUvhB4cvATKHT0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaJMSUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: introduce __get_vma_policy(), export get_task_policy()
has been removed from the -mm tree.  Its filename was
     mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: introduce __get_vma_policy(), export get_task_policy()

Extract the code which looks for vma's policy from get_vma_policy()
into the new helper, __get_vma_policy(). Export get_task_policy().

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

 include/linux/mempolicy.h |    3 ++
 mm/mempolicy.c            |   44 +++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-introduce-__get_vma_policy-export-get_task_policy include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-introduce-__get_vma_policy-export-get_task_policy
+++ a/include/linux/mempolicy.h
@@ -134,6 +134,9 @@ void mpol_free_shared_policy(struct shar
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    unsigned long idx);
 
+struct mempolicy *get_task_policy(struct task_struct *p);
+struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
+		unsigned long addr);
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
 bool vma_policy_mof(struct vm_area_struct *vma);
diff -puN mm/mempolicy.c~mempolicy-introduce-__get_vma_policy-export-get_task_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-introduce-__get_vma_policy-export-get_task_policy
+++ a/mm/mempolicy.c
@@ -123,7 +123,7 @@ static struct mempolicy default_policy =
 
 static struct mempolicy preferred_node_policy[MAX_NUMNODES];
 
-static struct mempolicy *get_task_policy(struct task_struct *p)
+struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
 	int node;
@@ -1603,23 +1603,8 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulo
 
 #endif
 
-/*
- * get_vma_policy(@task, @vma, @addr)
- * @task: task for fallback if vma policy == default
- * @vma: virtual memory area whose policy is sought
- * @addr: address in @vma for shared policy lookup
- *
- * Returns effective policy for a VMA at specified address.
- * Falls back to @task or system default policy, as necessary.
- * Current or other task's task mempolicy and non-shared vma policies must be
- * protected by task_lock(task) by the caller.
- * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
- * count--added by the get_policy() vm_op, as appropriate--to protect against
- * freeing by another task.  It is the caller's responsibility to free the
- * extra reference for shared policies.
- */
-struct mempolicy *get_vma_policy(struct task_struct *task,
-		struct vm_area_struct *vma, unsigned long addr)
+struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
+						unsigned long addr)
 {
 	struct mempolicy *pol = NULL;
 
@@ -1640,6 +1625,29 @@ struct mempolicy *get_vma_policy(struct
 		}
 	}
 
+	return pol;
+}
+
+/*
+ * get_vma_policy(@task, @vma, @addr)
+ * @task: task for fallback if vma policy == default
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup
+ *
+ * Returns effective policy for a VMA at specified address.
+ * Falls back to @task or system default policy, as necessary.
+ * Current or other task's task mempolicy and non-shared vma policies must be
+ * protected by task_lock(task) by the caller.
+ * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
+ * count--added by the get_policy() vm_op, as appropriate--to protect against
+ * freeing by another task.  It is the caller's responsibility to free the
+ * extra reference for shared policies.
+ */
+struct mempolicy *get_vma_policy(struct task_struct *task,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mempolicy *pol = __get_vma_policy(vma, addr);
+
 	if (!pol)
 		pol = get_task_policy(task);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

