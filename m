Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF221F5439
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352786; cv=none; b=Hg1mAZ6GiDH7qK8awSiuKE42Dhfuh3fbii/UqozztVA2yFuN+b6PlHMEacyo7Br5dwhE/cCRGZ6aTnKI5DLdD9BKkD+6zN44F8ptM5nYXBUSMjscjCqvNKxBHzrIraR39BzouMY3yP4k4E9nfHqF2n2oAjilrewfP7TsL0mspjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352786; c=relaxed/simple;
	bh=DxC9kAdB6nMKBkawQ/PkbZHWT8YnepZW9YzbmA331YM=;
	h=Date:To:From:Subject:Message-Id; b=uEqLuhCgDolP0ElHLIwjvPnHK0VZ568Hm1k0w9vIa9A/aN1Lc/umi59UauEjA9Ss97m4AM9MenmCRDnSiNKV1F7vmKHqM/KCioQHksSVOp+J6uuLRUjm245LDuTUZULhPsnKN/UI9VAvKBysm/hukzjl1RtGAW35RQYoXbYMtmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KB/GpSSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KB/GpSSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10C9C4CECD;
	Wed,  4 Dec 2024 22:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352786;
	bh=DxC9kAdB6nMKBkawQ/PkbZHWT8YnepZW9YzbmA331YM=;
	h=Date:To:From:Subject:From;
	b=KB/GpSSDWzKMXEtR/NCo7sD2tvNGIe2/+qcobQE2RNEzP/UAcx3ymd0pnqORCSm6J
	 7g6qO5Ac0bYbqbYCSf26d0Gc+Oi+iKXYEYkPBNeOeIXqN4LsP4YLOmYxabJdDZy95Z
	 w93drQjAq2iUN/fih6EpGSqdXFm4qjl36djRycL4=
Date: Wed, 04 Dec 2024 14:53:05 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-do_zap_pte_range.patch added to mm-unstable branch
Message-Id: <20241204225305.E10C9C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce do_zap_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-do_zap_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-do_zap_pte_range.patch

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
Subject: mm: introduce do_zap_pte_range()
Date: Wed, 4 Dec 2024 19:09:44 +0800

This commit introduces do_zap_pte_range() to actually zap the PTEs, which
will help improve code readability and facilitate secondary checking of
the processed PTEs in the future.

No functional change.

Link: https://lkml.kernel.org/r/c3fd16807f83bb7d7a376cc6de023a9f5ead17da.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
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

 mm/memory.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

--- a/mm/memory.c~mm-introduce-do_zap_pte_range
+++ a/mm/memory.c
@@ -1657,6 +1657,27 @@ static inline int zap_nonpresent_ptes(st
 	return nr;
 }
 
+static inline int do_zap_pte_range(struct mmu_gather *tlb,
+				   struct vm_area_struct *vma, pte_t *pte,
+				   unsigned long addr, unsigned long end,
+				   struct zap_details *details, int *rss,
+				   bool *force_flush, bool *force_break)
+{
+	pte_t ptent = ptep_get(pte);
+	int max_nr = (end - addr) / PAGE_SIZE;
+
+	if (pte_none(ptent))
+		return 1;
+
+	if (pte_present(ptent))
+		return zap_present_ptes(tlb, vma, pte, ptent, max_nr,
+					addr, details, rss, force_flush,
+					force_break);
+
+	return zap_nonpresent_ptes(tlb, vma, pte, ptent, max_nr, addr,
+					 details, rss);
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1679,28 +1700,14 @@ static unsigned long zap_pte_range(struc
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	do {
-		pte_t ptent = ptep_get(pte);
-		int max_nr;
-
-		nr = 1;
-		if (pte_none(ptent))
-			continue;
-
 		if (need_resched())
 			break;
 
-		max_nr = (end - addr) / PAGE_SIZE;
-		if (pte_present(ptent)) {
-			nr = zap_present_ptes(tlb, vma, pte, ptent, max_nr,
-					      addr, details, rss, &force_flush,
-					      &force_break);
-			if (unlikely(force_break)) {
-				addr += nr * PAGE_SIZE;
-				break;
-			}
-		} else {
-			nr = zap_nonpresent_ptes(tlb, vma, pte, ptent, max_nr,
-						 addr, details, rss);
+		nr = do_zap_pte_range(tlb, vma, pte, addr, end, details, rss,
+				      &force_flush, &force_break);
+		if (unlikely(force_break)) {
+			addr += nr * PAGE_SIZE;
+			break;
 		}
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
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

