Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A8EC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CE7761279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhKEUoC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233659AbhKEUn5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3F516126A;
        Fri,  5 Nov 2021 20:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144877;
        bh=bF0s3PiCRC3VcsPIZ/ETjwjY/SOtP8deMZuBhk2qp44=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bOyjedehA1edoOql9tGF0gXPbopigpAoWamzd34jhgP3/OWvULYoG4cgkeT4lmwwX
         qF6D5KuZP5KDvwNQn9rhrPDSnJsod2LeNvA8vstvrXRyD47IP+EMTI5tyJIvomI7ZS
         ssDCqOkRGkCsXY9RU52wS1Lw2Ew5P4j5Cy+xEBYE=
Date:   Fri, 05 Nov 2021 13:41:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 127/262] mm/hugetlb: drop __unmap_hugepage_range
 definition from hugetlb.h
Message-ID: <20211105204117.MUFO1Wxn5%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
