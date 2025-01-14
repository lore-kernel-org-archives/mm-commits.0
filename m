Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4C823C6F6
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837001; cv=none; b=OnZ6kKMGzHaOx2go42XmC5yhF8sj6+UwHiA8Bgt0nOamwmFj3OLIMvoSRQwqwjtV0ikCuu11IJxE9B1DY70tKDuztzujtkZVS0DIx8Ax5/sc7dJ2j1P77pgR8ZzAvgiRhWt3+QV9H/agPGlJJwLOncpef+dLdzqE5uFbanFFDm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837001; c=relaxed/simple;
	bh=d2gXyveDNTD28YRUWlCxJ+Jp7p8zS5yQZXIYwKmhbSE=;
	h=Date:To:From:Subject:Message-Id; b=FVzQB4tWJh8vRuKeGdpHNt1zg1cgypOluiOqB1JLGt2iOhudOrEMg2iaV4JHvfp+1+rMFpSDg4J9roq9NiGTIfINw0W3SX3v21Ch4gRI4fJDR6bHvZ7DSqdkkcJw+DzXZWjVw55rDJY5i2uEPckMVbQWo8XThHixV8e2FfSyN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQIvKJ7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQIvKJ7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1297CC4CEDD;
	Tue, 14 Jan 2025 06:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837001;
	bh=d2gXyveDNTD28YRUWlCxJ+Jp7p8zS5yQZXIYwKmhbSE=;
	h=Date:To:From:Subject:From;
	b=eQIvKJ7DGwqZGPoBaL/ZqjfBvEgRnSFACU43KFPB0Zlhgu8gv84V2L6XPDJqP8ewn
	 HC0HMexhyoQQgrTek41fpK4YgCFnaoEVr9V7B2pfe8HXoLhb52AbsMNNJHQ2yC0l7P
	 w96/SYCUMSliB0bTr0qNPkAGU81b03xhEmp4m9oE=
Date: Mon, 13 Jan 2025 22:43:20 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-do_zap_pte_range.patch removed from -mm tree
Message-Id: <20250114064321.1297CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce do_zap_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-introduce-do_zap_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Dan Carpenter <dan.carpenter@linaro.org>
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


