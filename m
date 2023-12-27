Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343FD47776
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 20:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvJP14pE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F04C433C8;
	Wed, 27 Dec 2023 20:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703709685;
	bh=0FgABWh+zT4Pjsmb65DKy0Fc/LXs5paNM3Ylg5TeGbk=;
	h=Date:To:From:Subject:From;
	b=bvJP14pEdtIrm9UlzdOYHYThF6f6czsSG5xTtT5AdY/T5ZLWfTFejPfPYcMj+Bv0i
	 WBIs8D0bw2Pqifw5LMhjKFfzJ4TnWmC2Cu3gqjsqxmHUlAkvnCGZvecsrzL3acs9uF
	 5XBzT/MhdlT89CchqANbhDKRDGdEAqFNk0s0MYOg=
Date: Wed, 27 Dec 2023 12:41:24 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,lkp@intel.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-remove-config_transparent_hugepage.patch added to mm-unstable branch
Message-Id: <20231227204124.F0F04C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: remove CONFIG_TRANSPARENT_HUGEPAGE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-remove-config_transparent_hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-remove-config_transparent_hugepage.patch

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

mm-mglru-add-config_arch_has_hw_pte_young.patch
mm-mglru-add-config_lru_gen_walks_mmu.patch
mm-mglru-remove-config_memcg.patch
mm-mglru-add-dummy-pmd_dirty.patch
mm-mglru-remove-config_transparent_hugepage.patch

