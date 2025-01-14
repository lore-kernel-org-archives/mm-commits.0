Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959F823A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836997; cv=none; b=nNIadFoydQbhMfDIZVueBSK8t+jHdNktBfGIooJQchs/zd4MB6x0X8xE2w6Ac/ixtLvx414cCK4fsGD3E/6slCTBgaYezjYIOhbPeVL8im17QhCul/Rl58xF0NGB7Yw88R2RcTkY7+5DT17ulXSfvgce6kYvKt7hNyYA9Bgx4C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836997; c=relaxed/simple;
	bh=rJ2BjAAO2GHcMQIaW+Ib5Li0DZ8CJyWQpmh467VrFtI=;
	h=Date:To:From:Subject:Message-Id; b=UmnHv/7lvDMW+kkIHVWnvMWHcNcaoQ55aw0FSjg+Gh5EJKdsDd3J15y7zfyxxkeAzYK2251TTvWZvDlqOu/8vg9MzTn8QgjCREdu34oSc4THGjAlAoqTKjZyJ3FFslhkc7L1V9JPIicbTA5Jm11+s5VKXZkKTuaPd6w3G2QEPtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nWqNCx8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nWqNCx8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68242C4CEDD;
	Tue, 14 Jan 2025 06:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836997;
	bh=rJ2BjAAO2GHcMQIaW+Ib5Li0DZ8CJyWQpmh467VrFtI=;
	h=Date:To:From:Subject:From;
	b=nWqNCx8gjdG3gdJrd0i+2LZyWNatA4Mo5VQ4wOuG4DORgtBghrG2l7sJHUVtTOMaY
	 8+lZYHNgPg7rGAzLzWc/cOJqVmaeAEZ+TqBNs6peqKtv/cBdQeBGqqzHNsZ4Lm8v08
	 10S4gUu0e2tx763vVpq/miEM5ARz7Uvg4NjaiJ5Q=
Date: Mon, 13 Jan 2025 22:43:16 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch removed from -mm tree
Message-Id: <20250114064317.68242C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: userfaultfd: recheck dst_pmd entry in move_pages_pte()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: userfaultfd: recheck dst_pmd entry in move_pages_pte()
Date: Wed, 4 Dec 2024 19:09:42 +0800

In move_pages_pte(), since dst_pte needs to be none, the subsequent
pte_same() check cannot prevent the dst_pte page from being freed
concurrently, so we also need to abtain dst_pmdval and recheck pmd_same().
Otherwise, once we support empty PTE page reclaimation for anonymous
pages, it may result in moving the src_pte page into the dts_pte page that
is about to be freed by RCU.

[zhengqi.arch@bytedance.com: remove WARN_ON_ONCE()s]
  Link: https://lkml.kernel.org/r/20241210084156.89877-1-zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/8108c262757fc492626f3a2ffc44b775f2710e16.1733305182.git.zhengqi.arch@bytedance.com
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

 mm/userfaultfd.c |   55 ++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte
+++ a/mm/userfaultfd.c
@@ -1020,6 +1020,14 @@ void double_pt_unlock(spinlock_t *ptl1,
 		__release(ptl2);
 }
 
+static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
+				       pte_t orig_dst_pte, pte_t orig_src_pte,
+				       pmd_t *dst_pmd, pmd_t dst_pmdval)
+{
+	return pte_same(ptep_get(src_pte), orig_src_pte) &&
+	       pte_same(ptep_get(dst_pte), orig_dst_pte) &&
+	       pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
+}
 
 static int move_present_pte(struct mm_struct *mm,
 			    struct vm_area_struct *dst_vma,
@@ -1027,6 +1035,7 @@ static int move_present_pte(struct mm_st
 			    unsigned long dst_addr, unsigned long src_addr,
 			    pte_t *dst_pte, pte_t *src_pte,
 			    pte_t orig_dst_pte, pte_t orig_src_pte,
+			    pmd_t *dst_pmd, pmd_t dst_pmdval,
 			    spinlock_t *dst_ptl, spinlock_t *src_ptl,
 			    struct folio *src_folio)
 {
@@ -1034,8 +1043,8 @@ static int move_present_pte(struct mm_st
 
 	double_pt_lock(dst_ptl, src_ptl);
 
-	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
-	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
+	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
+				 dst_pmd, dst_pmdval)) {
 		err = -EAGAIN;
 		goto out;
 	}
@@ -1071,6 +1080,7 @@ static int move_swap_pte(struct mm_struc
 			 unsigned long dst_addr, unsigned long src_addr,
 			 pte_t *dst_pte, pte_t *src_pte,
 			 pte_t orig_dst_pte, pte_t orig_src_pte,
+			 pmd_t *dst_pmd, pmd_t dst_pmdval,
 			 spinlock_t *dst_ptl, spinlock_t *src_ptl)
 {
 	if (!pte_swp_exclusive(orig_src_pte))
@@ -1078,8 +1088,8 @@ static int move_swap_pte(struct mm_struc
 
 	double_pt_lock(dst_ptl, src_ptl);
 
-	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
-	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
+	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
+				 dst_pmd, dst_pmdval)) {
 		double_pt_unlock(dst_ptl, src_ptl);
 		return -EAGAIN;
 	}
@@ -1097,13 +1107,14 @@ static int move_zeropage_pte(struct mm_s
 			     unsigned long dst_addr, unsigned long src_addr,
 			     pte_t *dst_pte, pte_t *src_pte,
 			     pte_t orig_dst_pte, pte_t orig_src_pte,
+			     pmd_t *dst_pmd, pmd_t dst_pmdval,
 			     spinlock_t *dst_ptl, spinlock_t *src_ptl)
 {
 	pte_t zero_pte;
 
 	double_pt_lock(dst_ptl, src_ptl);
-	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
-	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
+	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
+				 dst_pmd, dst_pmdval)) {
 		double_pt_unlock(dst_ptl, src_ptl);
 		return -EAGAIN;
 	}
@@ -1136,6 +1147,7 @@ static int move_pages_pte(struct mm_stru
 	pte_t *src_pte = NULL;
 	pte_t *dst_pte = NULL;
 	pmd_t dummy_pmdval;
+	pmd_t dst_pmdval;
 	struct folio *src_folio = NULL;
 	struct anon_vma *src_anon_vma = NULL;
 	struct mmu_notifier_range range;
@@ -1148,11 +1160,11 @@ static int move_pages_pte(struct mm_stru
 retry:
 	/*
 	 * Use the maywrite version to indicate that dst_pte will be modified,
-	 * but since we will use pte_same() to detect the change of the pte
-	 * entry, there is no need to get pmdval, so just pass a dummy variable
-	 * to it.
+	 * since dst_pte needs to be none, the subsequent pte_same() check
+	 * cannot prevent the dst_pte page from being freed concurrently, so we
+	 * also need to abtain dst_pmdval and recheck pmd_same() later.
 	 */
-	dst_pte = pte_offset_map_rw_nolock(mm, dst_pmd, dst_addr, &dummy_pmdval,
+	dst_pte = pte_offset_map_rw_nolock(mm, dst_pmd, dst_addr, &dst_pmdval,
 					   &dst_ptl);
 
 	/* Retry if a huge pmd materialized from under us */
@@ -1161,7 +1173,11 @@ retry:
 		goto out;
 	}
 
-	/* same as dst_pte */
+	/*
+	 * Unlike dst_pte, the subsequent pte_same() check can ensure the
+	 * stability of the src_pte page, so there is no need to get pmdval,
+	 * just pass a dummy variable to it.
+	 */
 	src_pte = pte_offset_map_rw_nolock(mm, src_pmd, src_addr, &dummy_pmdval,
 					   &src_ptl);
 
@@ -1177,8 +1193,8 @@ retry:
 	}
 
 	/* Sanity checks before the operation */
-	if (WARN_ON_ONCE(pmd_none(*dst_pmd)) ||	WARN_ON_ONCE(pmd_none(*src_pmd)) ||
-	    WARN_ON_ONCE(pmd_trans_huge(*dst_pmd)) || WARN_ON_ONCE(pmd_trans_huge(*src_pmd))) {
+	if (pmd_none(*dst_pmd) || pmd_none(*src_pmd) ||
+	    pmd_trans_huge(*dst_pmd) || pmd_trans_huge(*src_pmd)) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1213,7 +1229,7 @@ retry:
 			err = move_zeropage_pte(mm, dst_vma, src_vma,
 					       dst_addr, src_addr, dst_pte, src_pte,
 					       orig_dst_pte, orig_src_pte,
-					       dst_ptl, src_ptl);
+					       dst_pmd, dst_pmdval, dst_ptl, src_ptl);
 			goto out;
 		}
 
@@ -1303,8 +1319,8 @@ retry:
 
 		err = move_present_pte(mm,  dst_vma, src_vma,
 				       dst_addr, src_addr, dst_pte, src_pte,
-				       orig_dst_pte, orig_src_pte,
-				       dst_ptl, src_ptl, src_folio);
+				       orig_dst_pte, orig_src_pte, dst_pmd,
+				       dst_pmdval, dst_ptl, src_ptl, src_folio);
 	} else {
 		entry = pte_to_swp_entry(orig_src_pte);
 		if (non_swap_entry(entry)) {
@@ -1319,10 +1335,9 @@ retry:
 			goto out;
 		}
 
-		err = move_swap_pte(mm, dst_addr, src_addr,
-				    dst_pte, src_pte,
-				    orig_dst_pte, orig_src_pte,
-				    dst_ptl, src_ptl);
+		err = move_swap_pte(mm, dst_addr, src_addr, dst_pte, src_pte,
+				    orig_dst_pte, orig_src_pte, dst_pmd,
+				    dst_pmdval, dst_ptl, src_ptl);
 	}
 
 out:
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


