Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD0735280
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xz6uHlny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4560C433C9;
	Fri,  5 Jan 2024 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478717;
	bh=8Xkym+7SIKIZtHT/EWvWsT/5jOnH+En0WEi76E2xzMc=;
	h=Date:To:From:Subject:From;
	b=xz6uHlnyQjxVNiq2YsnXGsR4T3Dwnk0ZDFWUXhLFwkD/kX64tYyRKI/impCR3unAf
	 wDGUBSb5esHQQP100mZwnDDqOq1sj2yjuvLNwBvmtGw4pC/kURMf9Q0kJdrsAHQ4cy
	 YBUR3i1aHkmDdFkGZN4rU0CaDHWgcqnKYoSc01Xw=
Date: Fri, 05 Jan 2024 10:18:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,lkp@intel.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-remove-config_transparent_hugepage.patch removed from -mm tree
Message-Id: <20240105181837.D4560C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: remove CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-mglru-remove-config_transparent_hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: mm/mglru: remove CONFIG_TRANSPARENT_HUGEPAGE
Date: Wed, 27 Dec 2023 14:12:05 +0000

Improve code readability by removing CONFIG_TRANSPARENT_HUGEPAGE,
since the compiler should be able to automatically optimize out the
code that promotes THPs during page table walks.

No functional changes.

Link: https://lkml.kernel.org/r/20231227141205.2200125-6-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Co-developed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Tested-by: Donet Tom <donettom@linux.vnet.ibm.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/vmscan.c~mm-mglru-remove-config_transparent_hugepage
+++ a/mm/vmscan.c
@@ -3273,7 +3273,6 @@ static unsigned long get_pte_pfn(pte_t p
 	return pfn;
 }
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned long addr)
 {
 	unsigned long pfn = pmd_pfn(pmd);
@@ -3291,7 +3290,6 @@ static unsigned long get_pmd_pfn(pmd_t p
 
 	return pfn;
 }
-#endif
 
 static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 				   struct pglist_data *pgdat, bool can_swap)
@@ -3394,7 +3392,6 @@ restart:
 	return suitable_to_scan(total, young);
 }
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
@@ -3472,12 +3469,6 @@ next:
 done:
 	*first = -1;
 }
-#else
-static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
-				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
-{
-}
-#endif
 
 static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
@@ -3513,7 +3504,6 @@ restart:
 			continue;
 		}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		if (pmd_trans_huge(val)) {
 			unsigned long pfn = pmd_pfn(val);
 			struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
@@ -3532,7 +3522,7 @@ restart:
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 			continue;
 		}
-#endif
+
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
 		if (should_clear_pmd_young()) {
_

Patches currently in -mm which might be from kinseyho@google.com are


