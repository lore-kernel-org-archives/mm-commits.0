From: akpm@linux-foundation.org
Subject: - mempolicy-fixup-fallback-for-default-shmem-policy.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:09 -0700
Message-ID: <200804282153.m3SLr9WA017841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935033AbYD1Vx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: fixup Fallback for Default Shmem Policy
has been removed from the -mm tree.  Its filename was
     mempolicy-fixup-fallback-for-default-shmem-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: fixup Fallback for Default Shmem Policy
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

get_vma_policy() is not handling fallback to task policy correctly when the
get_policy() vm_op returns NULL.  The NULL overwrites the 'pol' variable that
was holding the fallback task mempolicy.  So, it was falling back directly to
system default policy.

Fix get_vma_policy() to use only non-NULL policy returned from the vma
get_policy op.

shm_get_policy() was falling back to current task's mempolicy if the "backing
file system" [tmpfs vs hugetlbfs] does not support the get_policy vm_op and
the vma policy is null.  This is incorrect for show_numa_maps() which is
likely querying the numa_maps of some task other than current.  Remove this
fallback.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c      |    3 +--
 mm/mempolicy.c |    7 +++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN ipc/shm.c~mempolicy-fixup-fallback-for-default-shmem-policy ipc/shm.c
--- a/ipc/shm.c~mempolicy-fixup-fallback-for-default-shmem-policy
+++ a/ipc/shm.c
@@ -274,8 +274,7 @@ static struct mempolicy *shm_get_policy(
 	else if (vma->vm_policy) {
 		pol = vma->vm_policy;
 		mpol_get(pol);	/* get_vma_policy() expects this */
-	} else
-		pol = current->mempolicy;
+	}
 	return pol;
 }
 #endif
diff -puN mm/mempolicy.c~mempolicy-fixup-fallback-for-default-shmem-policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fixup-fallback-for-default-shmem-policy
+++ a/mm/mempolicy.c
@@ -1262,7 +1262,7 @@ asmlinkage long compat_sys_mbind(compat_
  * @task != current].  It is the caller's responsibility to
  * free the reference in these cases.
  */
-static struct mempolicy * get_vma_policy(struct task_struct *task,
+static struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
@@ -1270,7 +1270,10 @@ static struct mempolicy * get_vma_policy
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
-			pol = vma->vm_ops->get_policy(vma, addr);
+			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
+									addr);
+			if (vpol)
+				pol = vpol;
 			shared_pol = 1;	/* if pol non-NULL, add ref below */
 		} else if (vma->vm_policy &&
 				vma->vm_policy->policy != MPOL_DEFAULT)
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

