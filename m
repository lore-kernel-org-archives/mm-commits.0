Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B634E7AD77
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjJCRCb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbjJCRCY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:02:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F33EEA
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:02:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD70C433C8;
        Tue,  3 Oct 2023 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696352540;
        bh=y0Sgiw1BXZO+Tld4wK+ikwQU5SQlIFtDxAztgVKX4+k=;
        h=Date:To:From:Subject:From;
        b=gE/uw14E4/161uoewqmLJBvF707VCDwaHV1yeyl+bypqBtjoc8/u1GFfoNHCUF4bq
         EU/5oKWKw0T/iDFz4dksRGKDx1GcCCJCb+JsPhu7DmEaCwBy7I+r3CbcsDHm1z8Yzx
         NH6a/NKbaHm9kn2JYKcRDQ9s+Jt3E+Z28iwM8qm4=
Date:   Tue, 03 Oct 2023 10:02:20 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, tj@kernel.org, surenb@google.com,
        sidhartha.kumar@oracle.com, shy828301@gmail.com,
        mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-trivia-delete-those-ancient-pr_debugs.patch added to mm-unstable branch
Message-Id: <20231003170220.BCD70C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy trivia: delete those ancient pr_debug()s
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-trivia-delete-those-ancient-pr_debugs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-trivia-delete-those-ancient-pr_debugs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mempolicy trivia: delete those ancient pr_debug()s
Date: Tue, 3 Oct 2023 02:19:00 -0700 (PDT)

Delete those ancient pr_debug()s - PDprintk()s in Andi Kleen's original
submission of core NUMA API, and useful when debugging shared mempolicy
lifetime back then, but not used recently.

Link: https://lkml.kernel.org/r/f25135-ffb2-40d8-9577-720772b333@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/mm/mempolicy.c~mempolicy-trivia-delete-those-ancient-pr_debugs
+++ a/mm/mempolicy.c
@@ -264,9 +264,6 @@ static struct mempolicy *mpol_new(unsign
 {
 	struct mempolicy *policy;
 
-	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
-		 mode, flags, nodes ? nodes_addr(*nodes)[0] : NUMA_NO_NODE);
-
 	if (mode == MPOL_DEFAULT) {
 		if (nodes && !nodes_empty(*nodes))
 			return ERR_PTR(-EINVAL);
@@ -768,11 +765,6 @@ static int vma_replace_policy(struct vm_
 
 	vma_assert_write_locked(vma);
 
-	pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
-		 vma->vm_start, vma->vm_end, vma->vm_pgoff,
-		 vma->vm_ops, vma->vm_file,
-		 vma->vm_ops ? vma->vm_ops->set_policy : NULL);
-
 	new = mpol_dup(pol);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
@@ -1293,10 +1285,6 @@ static long do_mbind(unsigned long start
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
-		 start, start + len, mode, mode_flags,
-		 nmask ? nodes_addr(*nmask)[0] : NUMA_NO_NODE);
-
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 		lru_cache_disable();
 	{
@@ -2516,8 +2504,6 @@ static void sp_insert(struct shared_poli
 	}
 	rb_link_node(&new->nd, parent, p);
 	rb_insert_color(&new->nd, &sp->root);
-	pr_debug("inserting %lx-%lx: %d\n", new->start, new->end,
-		 new->policy ? new->policy->mode : 0);
 }
 
 /* Find shared policy intersecting idx */
@@ -2656,7 +2642,6 @@ void mpol_put_task_policy(struct task_st
 
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
-	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
 	rb_erase(&n->nd, &sp->root);
 	sp_free(n);
 }
@@ -2813,12 +2798,6 @@ int mpol_set_shared_policy(struct shared
 	struct sp_node *new = NULL;
 	unsigned long sz = vma_pages(vma);
 
-	pr_debug("set_shared_policy %lx sz %lu %d %d %lx\n",
-		 vma->vm_pgoff,
-		 sz, npol ? npol->mode : -1,
-		 npol ? npol->flags : -1,
-		 npol ? nodes_addr(npol->nodes)[0] : NUMA_NO_NODE);
-
 	if (npol) {
 		new = sp_alloc(vma->vm_pgoff, vma->vm_pgoff + sz, npol);
 		if (!new)
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch
shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch
shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch
shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch
shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch
shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch
shmem-_add_to_page_cache-before-shmem_inode_acct_blocks.patch
shmempercpu_counter-add-_limited_addfbc-limit-amount.patch
hugetlbfs-drop-shared-numa-mempolicy-pretence.patch
kernfs-drop-shared-numa-mempolicy-hooks.patch
mempolicy-fix-migrate_pages2-syscall-return-nr_failed.patch
mempolicy-trivia-delete-those-ancient-pr_debugs.patch
mempolicy-trivia-slightly-more-consistent-naming.patch
mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch
mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch
mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch
mm-add-page_rmappable_folio-wrapper.patch
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch

