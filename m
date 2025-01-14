Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0315123C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837005; cv=none; b=ipNvXk3ADoeSHP4mwG6yfxHAxg4rPYTj/OLnyXb5Fhgk/htjUYXfBe6DE3kicv1GV2A21xuobG+lPWN/snA5QP/HlZFdsdIF8M2ilfznrzGvFVM1H2jjlnRbDhtxvk5A6/FvKxNbaDzVYHO5DaELXQ0KsG2Ki4CMW/46BNG4QsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837005; c=relaxed/simple;
	bh=5YKbIpbAm+bO1MXn5CCuaH0nmXFSDy7m/tFYty1sVXs=;
	h=Date:To:From:Subject:Message-Id; b=i0ROAvDlIA9cnXxKfuD9Aen/yqY+lSZyBN26/OjZVRePc31PuiH8/RckEaEJTZ1Skjt9swDrR/wWc0Fzz9CeLCikr7b67Qs/cm6ub57rpM+iNWjEnCXQ4SnGHGl7pySef/J/XEz96fCLa2nGI9URJjOVIitJzQSGv0AOIR1LZWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aoiSm0rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aoiSm0rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E84C4CEDD;
	Tue, 14 Jan 2025 06:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837004;
	bh=5YKbIpbAm+bO1MXn5CCuaH0nmXFSDy7m/tFYty1sVXs=;
	h=Date:To:From:Subject:From;
	b=aoiSm0rNxuxLwkEkS6YpB5j05ovuB2nIOM8f+5QnCOvlaY4xeCuAALsGyvYaegFhP
	 7gCiOKeMbCMKkpR8sNdpCynzeCydeEEXt1XfGv7Vjcyx68r5WiLFIPjZbNXP8Xv8gs
	 gr7Ha/UJRKnJ8wSTxD0ctF/uW4ClQ+FerPLbWTSM=
Date: Mon, 13 Jan 2025 22:43:24 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch removed from -mm tree
Message-Id: <20250114064324.C7E84C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: do_zap_pte_range: return any_skipped information to the caller
has been removed from the -mm tree.  Its filename was
     mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: do_zap_pte_range: return any_skipped information to the caller
Date: Wed, 4 Dec 2024 19:09:47 +0800

Let the caller of do_zap_pte_range() know whether we skip zap ptes or
reinstall uffd-wp ptes through any_skipped parameter, so that subsequent
commits can use this information in zap_pte_range() to detect whether the
PTE page can be reclaimed.

Link: https://lkml.kernel.org/r/59f33ec9f74e9f058ed319b0bfadd76b0f7adf9b.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-do_zap_pte_range-return-any_skipped-information-to-the-caller
+++ a/mm/memory.c
@@ -1501,7 +1501,7 @@ static __always_inline void zap_present_
 		struct vm_area_struct *vma, struct folio *folio,
 		struct page *page, pte_t *pte, pte_t ptent, unsigned int nr,
 		unsigned long addr, struct zap_details *details, int *rss,
-		bool *force_flush, bool *force_break)
+		bool *force_flush, bool *force_break, bool *any_skipped)
 {
 	struct mm_struct *mm = tlb->mm;
 	bool delay_rmap = false;
@@ -1527,8 +1527,8 @@ static __always_inline void zap_present_
 	arch_check_zapped_pte(vma, ptent);
 	tlb_remove_tlb_entries(tlb, pte, nr, addr);
 	if (unlikely(userfaultfd_pte_wp(vma, ptent)))
-		zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details,
-					      ptent);
+		*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte,
+							     nr, details, ptent);
 
 	if (!delay_rmap) {
 		folio_remove_rmap_ptes(folio, page, nr, vma);
@@ -1552,7 +1552,7 @@ static inline int zap_present_ptes(struc
 		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
 		unsigned int max_nr, unsigned long addr,
 		struct zap_details *details, int *rss, bool *force_flush,
-		bool *force_break)
+		bool *force_break, bool *any_skipped)
 {
 	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	struct mm_struct *mm = tlb->mm;
@@ -1567,15 +1567,17 @@ static inline int zap_present_ptes(struc
 		arch_check_zapped_pte(vma, ptent);
 		tlb_remove_tlb_entry(tlb, pte, addr);
 		if (userfaultfd_pte_wp(vma, ptent))
-			zap_install_uffd_wp_if_needed(vma, addr, pte, 1,
-						      details, ptent);
+			*any_skipped = zap_install_uffd_wp_if_needed(vma, addr,
+						pte, 1, details, ptent);
 		ksm_might_unmap_zero_page(mm, ptent);
 		return 1;
 	}
 
 	folio = page_folio(page);
-	if (unlikely(!should_zap_folio(details, folio)))
+	if (unlikely(!should_zap_folio(details, folio))) {
+		*any_skipped = true;
 		return 1;
+	}
 
 	/*
 	 * Make sure that the common "small folio" case is as fast as possible
@@ -1587,22 +1589,23 @@ static inline int zap_present_ptes(struc
 
 		zap_present_folio_ptes(tlb, vma, folio, page, pte, ptent, nr,
 				       addr, details, rss, force_flush,
-				       force_break);
+				       force_break, any_skipped);
 		return nr;
 	}
 	zap_present_folio_ptes(tlb, vma, folio, page, pte, ptent, 1, addr,
-			       details, rss, force_flush, force_break);
+			       details, rss, force_flush, force_break, any_skipped);
 	return 1;
 }
 
 static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
 		unsigned int max_nr, unsigned long addr,
-		struct zap_details *details, int *rss)
+		struct zap_details *details, int *rss, bool *any_skipped)
 {
 	swp_entry_t entry;
 	int nr = 1;
 
+	*any_skipped = true;
 	entry = pte_to_swp_entry(ptent);
 	if (is_device_private_entry(entry) ||
 		is_device_exclusive_entry(entry)) {
@@ -1660,7 +1663,7 @@ static inline int zap_nonpresent_ptes(st
 		WARN_ON_ONCE(1);
 	}
 	clear_not_present_full_ptes(vma->vm_mm, addr, pte, nr, tlb->fullmm);
-	zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
+	*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
 
 	return nr;
 }
@@ -1669,7 +1672,8 @@ static inline int do_zap_pte_range(struc
 				   struct vm_area_struct *vma, pte_t *pte,
 				   unsigned long addr, unsigned long end,
 				   struct zap_details *details, int *rss,
-				   bool *force_flush, bool *force_break)
+				   bool *force_flush, bool *force_break,
+				   bool *any_skipped)
 {
 	pte_t ptent = ptep_get(pte);
 	int max_nr = (end - addr) / PAGE_SIZE;
@@ -1691,10 +1695,11 @@ static inline int do_zap_pte_range(struc
 
 	if (pte_present(ptent))
 		nr += zap_present_ptes(tlb, vma, pte, ptent, max_nr, addr,
-				       details, rss, force_flush, force_break);
+				       details, rss, force_flush, force_break,
+				       any_skipped);
 	else
 		nr += zap_nonpresent_ptes(tlb, vma, pte, ptent, max_nr, addr,
-					  details, rss);
+					  details, rss, any_skipped);
 
 	return nr;
 }
@@ -1705,6 +1710,7 @@ static unsigned long zap_pte_range(struc
 				struct zap_details *details)
 {
 	bool force_flush = false, force_break = false;
+	bool any_skipped = false;
 	struct mm_struct *mm = tlb->mm;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
@@ -1725,7 +1731,7 @@ static unsigned long zap_pte_range(struc
 			break;
 
 		nr = do_zap_pte_range(tlb, vma, pte, addr, end, details, rss,
-				      &force_flush, &force_break);
+				      &force_flush, &force_break, &any_skipped);
 		if (unlikely(force_break)) {
 			addr += nr * PAGE_SIZE;
 			break;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


