From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:09 -0700
Message-ID: <543c17d9.7reKGEotGZWdBVuU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbaJMSUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: remove the "task" arg of vma_policy_mof() and simplify it
has been removed from the -mm tree.  Its filename was
     mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: remove the "task" arg of vma_policy_mof() and simplify it

1. vma_policy_mof(task) is simply not safe unless task == current,
   it can race with do_exit()->mpol_put(). Remove this arg and update
   its single caller.

2. vma can not be NULL, remove this check and simplify the code.

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

 include/linux/mempolicy.h |    2 +-
 kernel/sched/fair.c       |    2 +-
 mm/mempolicy.c            |   25 +++++++++++--------------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it
+++ a/include/linux/mempolicy.h
@@ -136,7 +136,7 @@ struct mempolicy *mpol_shared_policy_loo
 
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
-bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma);
+bool vma_policy_mof(struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
diff -puN kernel/sched/fair.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it kernel/sched/fair.c
--- a/kernel/sched/fair.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it
+++ a/kernel/sched/fair.c
@@ -1946,7 +1946,7 @@ void task_numa_work(struct callback_head
 		vma = mm->mmap;
 	}
 	for (; vma; vma = vma->vm_next) {
-		if (!vma_migratable(vma) || !vma_policy_mof(p, vma))
+		if (!vma_migratable(vma) || !vma_policy_mof(vma))
 			continue;
 
 		/*
diff -puN mm/mempolicy.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it
+++ a/mm/mempolicy.c
@@ -1646,27 +1646,24 @@ struct mempolicy *get_vma_policy(struct
 	return pol;
 }
 
-bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
+bool vma_policy_mof(struct vm_area_struct *vma)
 {
-	struct mempolicy *pol = NULL;
+	struct mempolicy *pol;
 
-	if (vma) {
-		if (vma->vm_ops && vma->vm_ops->get_policy) {
-			bool ret = false;
+	if (vma->vm_ops && vma->vm_ops->get_policy) {
+		bool ret = false;
 
-			pol = vma->vm_ops->get_policy(vma, vma->vm_start);
-			if (pol && (pol->flags & MPOL_F_MOF))
-				ret = true;
-			mpol_cond_put(pol);
+		pol = vma->vm_ops->get_policy(vma, vma->vm_start);
+		if (pol && (pol->flags & MPOL_F_MOF))
+			ret = true;
+		mpol_cond_put(pol);
 
-			return ret;
-		}
