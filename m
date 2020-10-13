Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0746CC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7B6A22203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630643;
	bh=z5byU08jS4C+rxbi3Whm7i2m9URTrlvZhJrVTmOtHnY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BTEdUOGMf1UDjW7dDwbeFsERzwrJiNK/aD/KbWWGbxwnU5+0rR3MlPXs9RHLw677Q
	 Yf1WLj0qFTs1BUDIpa6W1xU8FJouuwUp4VQyGhmW+VyOfn6XWw/Il/ngoVA0NIRras
	 x5moLEzXmMsrMKGZJR2ODleW7EGCOXZG3S+pUndg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgJMXKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:10:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E1521D40;
        Tue, 13 Oct 2020 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630642;
        bh=z5byU08jS4C+rxbi3Whm7i2m9URTrlvZhJrVTmOtHnY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wC0wbiUNQcXJzsYhDXbr6Okfp2FYaaEiIkKs87QyQ1Kj8FNXJULsmcbG+8rpOTdHk
         8kfkj+eYtwkfp0t+lu+TH24v+i2PDjLfqSlT9Il07iXv0/0CPoEj2OegfyVklSkC0P
         k/UVCLXPYNwHdkagn/7Lm5ICC5CtfgkjNX4ABHA8=
Date:   Tue, 13 Oct 2020 16:10:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jgg@ziepe.ca, kirill@shutemov.name, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [folded-merged]
 mm-remove-src-dst-mm-parameter-in-copy_page_range-v2.patch removed from -mm
 tree
Message-ID: <20201013231041.Z81ck4Ba1%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-src-dst-mm-parameter-in-copy_page_range-v2
has been removed from the -mm tree.  Its filename was
     mm-remove-src-dst-mm-parameter-in-copy_page_range-v2.patch

This patch was dropped because it was folded into mm-remove-src-dst-mm-parameter-in-copy_page_range.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-remove-src-dst-mm-parameter-in-copy_page_range-v2

further reorder some parameters and line format, per Jason

Link: https://lkml.kernel.org/r/20201002192647.7161-1-peterx@redhat.com
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 
 kernel/fork.c      |    2 
 mm/memory.c        |  140 ++++++++++++++++++++++---------------------
 3 files changed, 76 insertions(+), 69 deletions(-)

--- a/include/linux/mm.h~mm-remove-src-dst-mm-parameter-in-copy_page_range-v2
+++ a/include/linux/mm.h
@@ -1645,7 +1645,8 @@ struct mmu_notifier_range;
 
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
-int copy_page_range(struct vm_area_struct *vma, struct vm_area_struct *new);
+int
+copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 		   struct mmu_notifier_range *range,
 		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
--- a/kernel/fork.c~mm-remove-src-dst-mm-parameter-in-copy_page_range-v2
+++ a/kernel/fork.c
@@ -589,7 +589,7 @@ static __latent_entropy int dup_mmap(str
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
-			retval = copy_page_range(mpnt, tmp);
+			retval = copy_page_range(tmp, mpnt);
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
--- a/mm/memory.c~mm-remove-src-dst-mm-parameter-in-copy_page_range-v2
+++ a/mm/memory.c
@@ -794,15 +794,15 @@ copy_nonpresent_pte(struct mm_struct *ds
  * lock.
  */
 static inline int
-copy_present_page(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pte_t *dst_pte, pte_t *src_pte,
-		struct vm_area_struct *vma, struct vm_area_struct *new,
-		unsigned long addr, int *rss, struct page **prealloc,
-		pte_t pte, struct page *page)
+copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
+		  struct page **prealloc, pte_t pte, struct page *page)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct page *new_page;
 
-	if (!is_cow_mapping(vma->vm_flags))
+	if (!is_cow_mapping(src_vma->vm_flags))
 		return 1;
 
 	/*
@@ -865,15 +865,15 @@ copy_present_page(struct mm_struct *dst_
 	 * over and copy the page & arm it.
 	 */
 	*prealloc = NULL;
-	copy_user_highpage(new_page, page, addr, vma);
+	copy_user_highpage(new_page, page, addr, src_vma);
 	__SetPageUptodate(new_page);
-	page_add_new_anon_rmap(new_page, new, addr, false);
-	lru_cache_add_inactive_or_unevictable(new_page, new);
+	page_add_new_anon_rmap(new_page, dst_vma, addr, false);
+	lru_cache_add_inactive_or_unevictable(new_page, dst_vma);
 	rss[mm_counter(new_page)]++;
 
 	/* All done, just insert the new page copy in the child */
-	pte = mk_pte(new_page, new->vm_page_prot);
-	pte = maybe_mkwrite(pte_mkdirty(pte), new);
+	pte = mk_pte(new_page, dst_vma->vm_page_prot);
+	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -883,24 +883,22 @@ copy_present_page(struct mm_struct *dst_
  * is required to copy this pte.
  */
 static inline int
-copy_present_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *vma,
-		struct vm_area_struct *new,
-		unsigned long addr, int *rss, struct page **prealloc)
+copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
+		 struct page **prealloc)
 {
-	unsigned long vm_flags = vma->vm_flags;
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
+	unsigned long vm_flags = src_vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
 
-	page = vm_normal_page(vma, addr, pte);
+	page = vm_normal_page(src_vma, addr, pte);
 	if (page) {
 		int retval;
 
-		retval = copy_present_page(dst_mm, src_mm,
-			dst_pte, src_pte,
-			vma, new,
-			addr, rss, prealloc,
-			pte, page);
+		retval = copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
+					   addr, rss, prealloc, pte, page);
 		if (retval <= 0)
 			return retval;
 
@@ -957,12 +955,13 @@ page_copy_prealloc(struct mm_struct *src
 	return new_page;
 }
 
-static int copy_pte_range(pmd_t *dst_pmd, pmd_t *src_pmd,
-		   struct vm_area_struct *vma, struct vm_area_struct *new,
-		   unsigned long addr, unsigned long end)
+static int
+copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+	       pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
+	       unsigned long end)
 {
-	struct mm_struct *dst_mm = new->vm_mm;
-	struct mm_struct *src_mm = vma->vm_mm;
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	pte_t *orig_src_pte, *orig_dst_pte;
 	pte_t *src_pte, *dst_pte;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -1005,15 +1004,15 @@ again:
 		if (unlikely(!pte_present(*src_pte))) {
 			entry.val = copy_nonpresent_pte(dst_mm, src_mm,
 							dst_pte, src_pte,
-							vma, addr, rss);
+							src_vma, addr, rss);
 			if (entry.val)
 				break;
 			progress += 8;
 			continue;
 		}
 		/* copy_present_pte() will clear `*prealloc' if consumed */
-		ret = copy_present_pte(dst_mm, src_mm, dst_pte, src_pte,
-				       vma, new, addr, rss, &prealloc);
+		ret = copy_present_pte(dst_vma, src_vma, dst_pte, src_pte,
+				       addr, rss, &prealloc);
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
@@ -1048,7 +1047,7 @@ again:
 		entry.val = 0;
 	} else if (ret) {
 		WARN_ON_ONCE(ret != -EAGAIN);
-		prealloc = page_copy_prealloc(src_mm, vma, addr);
+		prealloc = page_copy_prealloc(src_mm, src_vma, addr);
 		if (!prealloc)
 			return -ENOMEM;
 		/* We've captured and resolved the error. Reset, try again. */
@@ -1062,12 +1061,13 @@ out:
 	return ret;
 }
 
-static inline int copy_pmd_range(pud_t *dst_pud, pud_t *src_pud,
-		struct vm_area_struct *vma, struct vm_area_struct *new,
-		unsigned long addr, unsigned long end)
+static inline int
+copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+	       pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
+	       unsigned long end)
 {
-	struct mm_struct *dst_mm = new->vm_mm;
-	struct mm_struct *src_mm = vma->vm_mm;
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	pmd_t *src_pmd, *dst_pmd;
 	unsigned long next;
 
@@ -1080,9 +1080,9 @@ static inline int copy_pmd_range(pud_t *
 		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)
 			|| pmd_devmap(*src_pmd)) {
 			int err;
-			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, vma);
+			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
 			err = copy_huge_pmd(dst_mm, src_mm,
-					    dst_pmd, src_pmd, addr, vma);
+					    dst_pmd, src_pmd, addr, src_vma);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)
@@ -1091,18 +1091,20 @@ static inline int copy_pmd_range(pud_t *
 		}
 		if (pmd_none_or_clear_bad(src_pmd))
 			continue;
-		if (copy_pte_range(dst_pmd, src_pmd, vma, new, addr, next))
+		if (copy_pte_range(dst_vma, src_vma, dst_pmd, src_pmd,
+				   addr, next))
 			return -ENOMEM;
 	} while (dst_pmd++, src_pmd++, addr = next, addr != end);
 	return 0;
 }
 
-static inline int copy_pud_range(p4d_t *dst_p4d, p4d_t *src_p4d,
-		struct vm_area_struct *vma, struct vm_area_struct *new,
-		unsigned long addr, unsigned long end)
+static inline int
+copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+	       p4d_t *dst_p4d, p4d_t *src_p4d, unsigned long addr,
+	       unsigned long end)
 {
-	struct mm_struct *dst_mm = new->vm_mm;
-	struct mm_struct *src_mm = vma->vm_mm;
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
@@ -1115,9 +1117,9 @@ static inline int copy_pud_range(p4d_t *
 		if (pud_trans_huge(*src_pud) || pud_devmap(*src_pud)) {
 			int err;
 
-			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, vma);
+			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
 			err = copy_huge_pud(dst_mm, src_mm,
-					    dst_pud, src_pud, addr, vma);
+					    dst_pud, src_pud, addr, src_vma);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)
@@ -1126,17 +1128,19 @@ static inline int copy_pud_range(p4d_t *
 		}
 		if (pud_none_or_clear_bad(src_pud))
 			continue;
-		if (copy_pmd_range(dst_pud, src_pud, vma, new, addr, next))
+		if (copy_pmd_range(dst_vma, src_vma, dst_pud, src_pud,
+				   addr, next))
 			return -ENOMEM;
 	} while (dst_pud++, src_pud++, addr = next, addr != end);
 	return 0;
 }
 
-static inline int copy_p4d_range(pgd_t *dst_pgd, pgd_t *src_pgd,
-		struct vm_area_struct *vma, struct vm_area_struct *new,
-		unsigned long addr, unsigned long end)
+static inline int
+copy_p4d_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+	       pgd_t *dst_pgd, pgd_t *src_pgd, unsigned long addr,
+	       unsigned long end)
 {
-	struct mm_struct *dst_mm = new->vm_mm;
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	p4d_t *src_p4d, *dst_p4d;
 	unsigned long next;
 
@@ -1148,20 +1152,22 @@ static inline int copy_p4d_range(pgd_t *
 		next = p4d_addr_end(addr, end);
 		if (p4d_none_or_clear_bad(src_p4d))
 			continue;
-		if (copy_pud_range(dst_p4d, src_p4d, vma, new, addr, next))
+		if (copy_pud_range(dst_vma, src_vma, dst_p4d, src_p4d,
+				   addr, next))
 			return -ENOMEM;
 	} while (dst_p4d++, src_p4d++, addr = next, addr != end);
 	return 0;
 }
 
-int copy_page_range(struct vm_area_struct *vma, struct vm_area_struct *new)
+int
+copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	pgd_t *src_pgd, *dst_pgd;
 	unsigned long next;
-	unsigned long addr = vma->vm_start;
-	unsigned long end = vma->vm_end;
-	struct mm_struct *dst_mm = new->vm_mm;
-	struct mm_struct *src_mm = vma->vm_mm;
+	unsigned long addr = src_vma->vm_start;
+	unsigned long end = src_vma->vm_end;
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct mmu_notifier_range range;
 	bool is_cow;
 	int ret;
@@ -1172,19 +1178,19 @@ int copy_page_range(struct vm_area_struc
 	 * readonly mappings. The tradeoff is that copy_page_range is more
 	 * efficient than faulting.
 	 */
-	if (!(vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP)) &&
-			!vma->anon_vma)
+	if (!(src_vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP)) &&
+	    !src_vma->anon_vma)
 		return 0;
 
-	if (is_vm_hugetlb_page(vma))
-		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
+	if (is_vm_hugetlb_page(src_vma))
+		return copy_hugetlb_page_range(dst_mm, src_mm, src_vma);
 
-	if (unlikely(vma->vm_flags & VM_PFNMAP)) {
+	if (unlikely(src_vma->vm_flags & VM_PFNMAP)) {
 		/*
 		 * We do not free on error cases below as remove_vma
 		 * gets called on error from higher level routine
 		 */
-		ret = track_pfn_copy(vma);
+		ret = track_pfn_copy(src_vma);
 		if (ret)
 			return ret;
 	}
@@ -1195,11 +1201,11 @@ int copy_page_range(struct vm_area_struc
 	 * parent mm. And a permission downgrade will only happen if
 	 * is_cow_mapping() returns true.
 	 */
-	is_cow = is_cow_mapping(vma->vm_flags);
+	is_cow = is_cow_mapping(src_vma->vm_flags);
 
 	if (is_cow) {
 		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
-					0, vma, src_mm, addr, end);
+					0, src_vma, src_mm, addr, end);
 		mmu_notifier_invalidate_range_start(&range);
 	}
 
@@ -1210,8 +1216,8 @@ int copy_page_range(struct vm_area_struc
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(src_pgd))
 			continue;
-		if (unlikely(copy_p4d_range(dst_pgd, src_pgd,
-					    vma, new, addr, next))) {
+		if (unlikely(copy_p4d_range(dst_vma, src_vma, dst_pgd, src_pgd,
+					    addr, next))) {
 			ret = -ENOMEM;
 			break;
 		}
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-remove-src-dst-mm-parameter-in-copy_page_range.patch
mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch

