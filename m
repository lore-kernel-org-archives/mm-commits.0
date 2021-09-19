Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105DCC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6CAB61183
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhISXHR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhISXHQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0F0D61107;
        Sun, 19 Sep 2021 23:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632092751;
        bh=mtlqk3LBDoLeZh96J005urvjhvZazcVNJejgdR/5Pfs=;
        h=Date:From:To:Subject:From;
        b=RdRxWOMChQDYmi3Fzx83Ex17SROR72i162A4i2UUshk4CsjC3Ny+NqIL7n9252cb3
         fpJRDxwYcDQJq8vF04Il3aHyfA6WPa1/8GW1Fka+IZZaZRTATD8uq85+ndZ3pSZyjV
         GL+ZqKjdNixWl7M3wilTT/0ZP4BUS/iKdV/JGM0E=
Date:   Sun, 19 Sep 2021 16:05:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, jhubbard@nvidia.com, peterx@redhat.com
Subject:  +
 mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch added
 to -mm tree
Message-ID: <20210919230550.-SUWb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: drop __unmap_hugepage_range definition from hugetlb.h
has been added to the -mm tree.  Its filename is
     mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: drop __unmap_hugepage_range definition from hugetlb.h

Remove __unmap_hugepage_range() from the header file, because it is only
used in hugetlb.c.

Link: https://lkml.kernel.org/r/20210917165108.9341-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ----------
 mm/hugetlb.c            |    6 +++---
 2 files changed, 3 insertions(+), 13 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh
+++ a/include/linux/hugetlb.h
@@ -143,9 +143,6 @@ void __unmap_hugepage_range_final(struct
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
 			  struct page *ref_page);
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-				unsigned long start, unsigned long end,
-				struct page *ref_page);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(char *buf, int len, int nid);
 void hugetlb_show_meminfo(void);
@@ -382,13 +379,6 @@ static inline void __unmap_hugepage_rang
 			struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, struct page *ref_page)
 {
-	BUG();
-}
-
-static inline void __unmap_hugepage_range(struct mmu_gather *tlb,
-			struct vm_area_struct *vma, unsigned long start,
-			unsigned long end, struct page *ref_page)
-{
 	BUG();
 }
 
--- a/mm/hugetlb.c~mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh
+++ a/mm/hugetlb.c
@@ -4426,9 +4426,9 @@ again:
 	return ret;
 }
 
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			    unsigned long start, unsigned long end,
-			    struct page *ref_page)
+static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
+				   struct page *ref_page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-smaps-fix-shmem-pte-hole-swap-calculation.patch
mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch
mm-smaps-simplify-shmem-handling-of-pte-holes.patch
mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch
mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch

