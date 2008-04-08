From: akpm@linux-foundation.org
Subject: + mempolicy-fixup-fallback-for-default-shmem-policy.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:26:45 -0700
Message-ID: <200804080326.m383QjYj006013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYDHD1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:27:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mempolicy: fixup Fallback for Default Shmem Policy
has been added to the -mm tree.  Its filename is
     mempolicy-fixup-fallback-for-default-shmem-policy.patch

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

mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mempolicy-rename-mpol_free-to-mpol_put.patch
mempolicy-rename-mpol_copy-to-mpol_dup.patch
mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
mempolicy-fixup-fallback-for-default-shmem-policy.patch
mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
mempolicy-mark-shared-policies-for-unref.patch
mempolicy-document-setget_policy-vm_ops-apis.patch
mempolicy-rework-mempolicy-reference-counting.patch
mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
mempolicy-rework-shmem-mpol-parsing-and-display.patch
mempolicy-support-mpol=local-tmpfs-mount-option.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch

