Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB70C1F541C
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352783; cv=none; b=PbSxsi0e7ADJOFLH1Xxr6ImOXQ5FsZM1FGUClREfKIBZbrYTtKQ/GrjyHbHV4jm0HFKdSYBqo7s6DFK385LXfGhrUrhDoM77zxddZjmiUNRIY4wLV1m7TCo3Q0xNGmRjys2phq+n+DQ6eRQUGnQLDZpMmz1yiqEbvFRVrCiuQ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352783; c=relaxed/simple;
	bh=nhF4HeAOfi5yAqmUT72X7gaE3Bhqh2Q7gBbWv9Zqhvc=;
	h=Date:To:From:Subject:Message-Id; b=cmrtV2rAwS2EHqxswIUrW9CeSrGW4GORTFVtt32T2HokT6XKCn2s0j8Q5nbqWIRbIMoRm0dLDMLIYke3UynjD7Eae6n57coRE+jpPtgreY3++PNRUHipSt/YlN6KkJKnrqZwdy9J5eqDl+MyNNN+CnR83BMLFk8k96dX7gTX/bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PUeU8Tv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PUeU8Tv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3086BC4CECD;
	Wed,  4 Dec 2024 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352783;
	bh=nhF4HeAOfi5yAqmUT72X7gaE3Bhqh2Q7gBbWv9Zqhvc=;
	h=Date:To:From:Subject:From;
	b=PUeU8Tv4D2phOivaNXbpNCMwqlzWUcwAyPm/2S9nlZQVzOdhqbWgRMdWjzH6jPhVT
	 rSn0DQ94ecxaOjgDIXfyxyuD+pEu+ps5b272ZqqLJagueTOODEt60OcaTHeD8qf4dN
	 6nZfAvmCwrjpFoqALaowT4dfVHemAELhLs4cP5jI=
Date: Wed, 04 Dec 2024 14:53:02 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch added to mm-unstable branch
Message-Id: <20241204225303.3086BC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: userfaultfd: recheck dst_pmd entry in move_pages_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: userfaultfd: recheck dst_pmd entry in move_pages_pte()
Date: Wed, 4 Dec 2024 19:09:42 +0800

In move_pages_pte(), since dst_pte needs to be none, the subsequent
pte_same() check cannot prevent the dst_pte page from being freed
concurrently, so we also need to abtain dst_pmdval and recheck pmd_same().
Otherwise, once we support empty PTE page reclaimation for anonymous
pages, it may result in moving the src_pte page into the dts_pte page that
is about to be freed by RCU.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   51 +++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 18 deletions(-)

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

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

