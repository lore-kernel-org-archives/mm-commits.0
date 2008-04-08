From: akpm@linux-foundation.org
Subject: + mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:26:43 -0700
Message-ID: <200804080326.m383QhsA006010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbYDHD1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:27:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mempolicy: write lock mmap_sem while changing task mempolicy
has been added to the -mm tree.  Its filename is
     mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch

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
Subject: mempolicy: write lock mmap_sem while changing task mempolicy
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

A read of /proc/<pid>/numa_maps holds the target task's mmap_sem for read
while examining each vma's mempolicy.  A vma's mempolicy can fall back to the
task's policy.  However, the task could be changing it's task policy and free
the one that the show_numa_maps() is examining.

To prevent this, grab the mmap_sem for write when updating task mempolicy. 
Pointed out to me by Christoph Lameter and extracted and reworked from
Christoph's alternative mempol reference counting patch.

This is analogous to the way that do_mbind() and do_get_mempolicy() prevent
races between task's sharing an mm_struct [a.k.a.  threads] setting and
querying a mempolicy for a particular address.

Note: this is necessary, but not sufficient, to allow us to stop taking an
extra reference on "other task's mempolicy" in get_vma_policy.  Subsequent
patches will complete this update, allowing us to simplify the tests for
whether we need to unref a mempolicy at various points in the code.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/mempolicy.c~mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy
+++ a/mm/mempolicy.c
@@ -591,16 +591,29 @@ static long do_set_mempolicy(unsigned sh
 			     nodemask_t *nodes)
 {
 	struct mempolicy *new;
+	struct mm_struct *mm = current->mm;
 
 	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
+
+	/*
+	 * prevent changing our mempolicy while show_numa_maps()
+	 * is using it.
+	 * Note:  do_set_mempolicy() can be called at init time
+	 * with no 'mm'.
+	 */
+	if (mm)
+		down_write(&mm->mmap_sem);
 	mpol_put(current->mempolicy);
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
 	if (new && new->policy == MPOL_INTERLEAVE &&
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
+	if (mm)
+		up_write(&mm->mmap_sem);
+
 	return 0;
 }
 
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

