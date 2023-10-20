Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35986CDB474
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjJTR04 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377706AbjJTR0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:26:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB8DD72
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 10:26:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC6FC433C8;
        Fri, 20 Oct 2023 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822804;
        bh=s9s1Ozmn3daGeGpUMO2VWWWzPNqsWew/KBXYxLLA0Xs=;
        h=Date:To:From:Subject:From;
        b=lfrMUmr6TF3CUsSQZgLYf1dkwoSVT+WEMVC99x7g48/FTbZ+rUJzq1PJNZ9X6/3TT
         DzLXpDkcE4CS2i/uoFy0t34WrFDh5qMjxFr37s4PrRPWsxWdqEV2KlsLhiSQbvuPvu
         8fQfcuozWiO5cSf8r6fNxGhPCgV0gD7q2I2/VHuI=
Date:   Fri, 20 Oct 2023 10:26:43 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com, tj@kernel.org,
        surenb@google.com, sidhartha.kumar@oracle.com, shy828301@gmail.com,
        nphamcs@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch added to mm-unstable branch
Message-Id: <20231020172644.3AC6FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: remove confusing MPOL_MF_LAZY dead code
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch

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
Subject: mempolicy: remove confusing MPOL_MF_LAZY dead code
Date: Tue, 3 Oct 2023 02:24:18 -0700 (PDT)

v3.8 commit b24f53a0bea3 ("mm: mempolicy: Add MPOL_MF_LAZY") introduced
MPOL_MF_LAZY, and included it in the MPOL_MF_VALID flags; but a720094ded8
("mm: mempolicy: Hide MPOL_NOOP and MPOL_MF_LAZY from userspace for now")
immediately removed it from MPOL_MF_VALID flags, pending further review. 
"This will need to be revisited", but it has not been reinstated.

The present state is confusing: there is dead code in mm/mempolicy.c to
handle MPOL_MF_LAZY cases which can never occur.  Remove that: it can be
resurrected later if necessary.  But keep the definition of MPOL_MF_LAZY,
which must remain in the UAPI, even though it always fails with EINVAL.

https://lore.kernel.org/linux-mm/1553041659-46787-1-git-send-email-yang.shi@linux.alibaba.com/
links to a previous request to remove MPOL_MF_LAZY.

Link: https://lkml.kernel.org/r/80c9665c-1c3f-17ba-21a3-f6115cebf7d@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    2 +-
 mm/mempolicy.c                 |   18 ------------------
 2 files changed, 1 insertion(+), 19 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mempolicy-remove-confusing-mpol_mf_lazy-dead-code
+++ a/include/uapi/linux/mempolicy.h
@@ -48,7 +48,7 @@ enum {
 #define MPOL_MF_MOVE	 (1<<1)	/* Move pages owned by this process to conform
 				   to policy */
 #define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to policy */
-#define MPOL_MF_LAZY	 (1<<3)	/* Modifies '_MOVE:  lazy migrate on fault */
+#define MPOL_MF_LAZY	 (1<<3)	/* UNSUPPORTED FLAG: Lazy migrate on fault */
 #define MPOL_MF_INTERNAL (1<<4)	/* Internal flags start here */
 
 #define MPOL_MF_VALID	(MPOL_MF_STRICT   | 	\
--- a/mm/mempolicy.c~mempolicy-remove-confusing-mpol_mf_lazy-dead-code
+++ a/mm/mempolicy.c
@@ -636,12 +636,6 @@ unsigned long change_prot_numa(struct vm
 
 	return nr_updated;
 }
-#else
-static unsigned long change_prot_numa(struct vm_area_struct *vma,
-			unsigned long addr, unsigned long end)
-{
-	return 0;
-}
 #endif /* CONFIG_NUMA_BALANCING */
 
 static int queue_pages_test_walk(unsigned long start, unsigned long end,
@@ -680,14 +674,6 @@ static int queue_pages_test_walk(unsigne
 	if (endvma > end)
 		endvma = end;
 
-	if (flags & MPOL_MF_LAZY) {
-		/* Similar to task_numa_work, skip inaccessible VMAs */
-		if (!is_vm_hugetlb_page(vma) && vma_is_accessible(vma) &&
-			!(vma->vm_flags & VM_MIXEDMAP))
-			change_prot_numa(vma, start, endvma);
-		return 1;
-	}
-
 	/*
 	 * Check page nodes, and queue pages to move, in the current vma.
 	 * But if no moving, and no strict checking, the scan can be skipped.
@@ -1254,9 +1240,6 @@ static long do_mbind(unsigned long start
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
-	if (flags & MPOL_MF_LAZY)
-		new->flags |= MPOL_F_MOF;
-
 	/*
 	 * If we are using the default policy then operation
 	 * on discontinuous address spaces is okay after all
@@ -1301,7 +1284,6 @@ static long do_mbind(unsigned long start
 
 	if (!err) {
 		if (!list_empty(&pagelist)) {
-			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
 			nr_failed |= migrate_pages(&pagelist, new_folio, NULL,
 				start, MIGRATE_SYNC, MR_MEMPOLICY_MBIND, NULL);
 		}
_

Patches currently in -mm which might be from hughd@google.com are

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

