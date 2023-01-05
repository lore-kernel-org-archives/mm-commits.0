Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E58C54E76
	for <mm-commits@archiver.kernel.org>; Thu,  5 Jan 2023 01:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjAEBrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Jan 2023 20:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjAEBqy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2023 20:46:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7BD2F786
        for <mm-commits@vger.kernel.org>; Wed,  4 Jan 2023 17:46:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AD7C618BB
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 01:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C908C433F0;
        Thu,  5 Jan 2023 01:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672883212;
        bh=oacNmnBnhNdb6kxTgCIOvvet4EFRozABT4VV+ArIKu4=;
        h=Date:To:From:Subject:From;
        b=AsGE52LAwpGASg6oCzz624jb3qoVHH/VOIqxQsaywMSrmH05nxW0h/MPF3TbOlz17
         lbvmHmNCFIQ0Gz7dbxovxF52SW7alL0HAo+LmiVEFblSZ49RA1LzGyY4ZWCBu2CYNV
         9QOvXghLB4PEweJ4AbtWcH7EOcbciNnYoSgTbjfQ=
Date:   Wed, 04 Jan 2023 17:46:51 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        peterx@redhat.com, mike.kravetz@oracle.com,
        axelrasmussen@google.com, jthoughton@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-unshare-some-pmds-when-splitting-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20230105014652.7C908C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: unshare some PMDs when splitting VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-unshare-some-pmds-when-splitting-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-unshare-some-pmds-when-splitting-vmas.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: James Houghton <jthoughton@google.com>
Subject: hugetlb: unshare some PMDs when splitting VMAs
Date: Wed, 4 Jan 2023 23:19:10 +0000

PMD sharing can only be done in PUD_SIZE-aligned pieces of VMAs; however,
it is possible that HugeTLB VMAs are split without unsharing the PMDs
first.

Without this fix, it is possible to hit the uffd-wp-related WARN_ON_ONCE
in hugetlb_change_protection [1].  The key there is that
hugetlb_unshare_all_pmds will not attempt to unshare PMDs in
non-PUD_SIZE-aligned sections of the VMA.

It might seem ideal to unshare in hugetlb_vm_op_open, but we need to
unshare in both the new and old VMAs, so unsharing in hugetlb_vm_op_split
seems natural.

[1]: https://lore.kernel.org/linux-mm/CADrL8HVeOkj0QH5VZZbRzybNE8CG-tEGFshnA+bG9nMgcWtBSg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230104231910.1464197-1-jthoughton@google.com
Fixes: 6dfeaff93be1 ("hugetlb/userfaultfd: unshare all pmds for hugetlbfs when register wp")
Signed-off-by: James Houghton <jthoughton@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb-unshare-some-pmds-when-splitting-vmas
+++ a/mm/hugetlb.c
@@ -94,6 +94,8 @@ static int hugetlb_acct_memory(struct hs
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -4834,6 +4836,25 @@ static int hugetlb_vm_op_split(struct vm
 {
 	if (addr & ~(huge_page_mask(hstate_vma(vma))))
 		return -EINVAL;
+
+	/*
+	 * PMD sharing is only possible for PUD_SIZE-aligned address ranges
+	 * in HugeTLB VMAs. If we will lose PUD_SIZE alignment due to this
+	 * split, unshare PMDs in the PUD_SIZE interval surrounding addr now.
+	 */
+	if (addr & ~PUD_MASK) {
+		/*
+		 * hugetlb_vm_op_split is called right before we attempt to
+		 * split the VMA. We will need to unshare PMDs in the old and
+		 * new VMAs, so let's unshare before we split.
+		 */
+		unsigned long floor = addr & PUD_MASK;
+		unsigned long ceil = floor + PUD_SIZE;
+
+		if (floor >= vma->vm_start && ceil <= vma->vm_end)
+			hugetlb_unshare_pmds(vma, floor, ceil);
+	}
+
 	return 0;
 }
 
@@ -7322,26 +7343,21 @@ void move_hugetlb_state(struct folio *ol
 	}
 }
 
-/*
- * This function will unconditionally remove all the shared pmd pgtable entries
- * within the specific vma for a hugetlbfs memory range.
- */
-void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+				   unsigned long start,
+				   unsigned long end)
 {
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
-	unsigned long address, start, end;
+	unsigned long address;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
 
-	start = ALIGN(vma->vm_start, PUD_SIZE);
-	end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
-
 	if (start >= end)
 		return;
 
@@ -7373,6 +7389,16 @@ void hugetlb_unshare_all_pmds(struct vm_
 	mmu_notifier_invalidate_range_end(&range);
 }
 
+/*
+ * This function will unconditionally remove all the shared pmd pgtable entries
+ * within the specific vma for a hugetlbfs memory range.
+ */
+void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
+{
+	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
+			ALIGN_DOWN(vma->vm_end, PUD_SIZE));
+}
+
 #ifdef CONFIG_CMA
 static bool cma_reserve_called __initdata;
 
_

Patches currently in -mm which might be from jthoughton@google.com are

hugetlb-unshare-some-pmds-when-splitting-vmas.patch

