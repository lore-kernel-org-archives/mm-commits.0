From: akpm@linux-foundation.org
Subject: [merged] mempolicy-sanitize-the-usage-of-get_task_policy.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:07 -0700
Message-ID: <543c17d7.9ghTh5pJUY8z7vKc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaJMSUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: sanitize the usage of get_task_policy()
has been removed from the -mm tree.  Its filename was
     mempolicy-sanitize-the-usage-of-get_task_policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: sanitize the usage of get_task_policy()

Cleanup + preparation. Every user of get_task_policy() calls it
unconditionally, even if it is not going to use the result.

get_task_policy() is cheap but still this does not look clean, plus
the code looks simpler if get_task_policy() is called only when this
is really needed.

Note: I hope this is correct, but it is not clear why vma_policy_mof()
doesn't fall back to get_task_policy() if ->get_policy() returns NULL.

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

 mm/mempolicy.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-sanitize-the-usage-of-get_task_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-sanitize-the-usage-of-get_task_policy
+++ a/mm/mempolicy.c
@@ -1621,14 +1621,11 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulo
 struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct mempolicy *pol = get_task_policy(task);
+	struct mempolicy *pol = NULL;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
-			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
-									addr);
-			if (vpol)
-				pol = vpol;
+			pol = vma->vm_ops->get_policy(vma, addr);
 		} else if (vma->vm_policy) {
 			pol = vma->vm_policy;
 
@@ -1643,12 +1640,15 @@ struct mempolicy *get_vma_policy(struct
 		}
 	}
 
+	if (!pol)
+		pol = get_task_policy(task);
+
 	return pol;
 }
 
 bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 {
-	struct mempolicy *pol = get_task_policy(task);
+	struct mempolicy *pol = NULL;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -1660,11 +1660,14 @@ bool vma_policy_mof(struct task_struct *
 			mpol_cond_put(pol);
 
 			return ret;
-		} else if (vma->vm_policy) {
-			pol = vma->vm_policy;
 		}
+
+		pol = vma->vm_policy;
 	}
 
+	if (!pol)
+		pol = get_task_policy(task);
+
 	return pol->flags & MPOL_F_MOF;
 }
 
@@ -2068,12 +2071,12 @@ retry_cpuset:
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
-	struct mempolicy *pol = get_task_policy(current);
+	struct mempolicy *pol = &default_policy;
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
-	if (in_interrupt() || (gfp & __GFP_THISNODE))
-		pol = &default_policy;
+	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
+		pol = get_task_policy(current);
 
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

