Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9182C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A8561108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhKKCre (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCrd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7963160F46;
        Thu, 11 Nov 2021 02:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598685;
        bh=CvwDymM+0AfDgRlPdTxWYHjnF1O6pAxmt5q8dJcKe0M=;
        h=Date:From:To:Subject:From;
        b=jp8W4EjCniZiS7QLbrlKgXjdXJm1wdGLwnlaNbAEFNT0wuCHjaCbVvsYpOYBRPPbQ
         K7E6SqPUDMK0KXa5NFcvuRnfOWx8zbnUKdCX6+zka7Ze/PSis50L4q8qrEaVfOflT/
         qVsmoZmTcbgOWpVcimP3wIxYzFt41pDNaoLaRr7c=
Date:   Wed, 10 Nov 2021 18:44:45 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, jhubbard@nvidia.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        songmuchun@bytedance.com
Subject:  [merged]
 mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch
 removed from -mm tree
Message-ID: <20211111024445.MizgLFrkF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: drop __unmap_hugepage_range definition from hugetlb.h
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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


