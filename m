Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795842736;
	b=tSII7qWueSGN5yghTTFF6UbebhRMQuVShA6JTkQbzSkp5CFioCO5LK6ZckcaolTEcalX
	 TOs7x1Rf8HHGgzNHiVRuZL5FT9ilPYlO5jn5AEakAU8TTTlJDy32Yh1iOvHr11N1aTxtT
	 HMMSc/TuvbVro3ApIdWLYQG9sX1ZTdUCYYcfG476W7emIsQhKlF6gT2X20h5ZPfYxb+EY
	 bUFAQmCR3HptRZk+++Cp7oWPJAcgoXFChA2HRzvCzBJEnkMfuJCfum66IQrcs8exEBX0d
	 Cx8bsLrlBEoHxfGnvPDWH/87WoByuPCUpkJr/IHkzVCIatwCQytasdbX5PPDXweAfIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795842736;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=mQhZ0Rpe582oGSmJzrc5wrx+1NfOeiMeUFY1k2TTu3A=;
	b=BfsD/5t3Bi44vdyG9ACF4hyTydHGI07ZjfdZTgiLBh8jscUGmQ0IQ5RmI9Yo/i/pSYTR
	 i6roRvu6G1d+Pa4AAQHjHuEXX8YUeISWM6ylnAGhcdASjVhtqzYS+/qMqFcDZi+PSRzeA
	 gypSJ2f5p4Q8av1unHK9AwnrMSWQ9ReY/yoXkl8bn4YhcoXosVRONLoCkm1PgdlznLQfl
	 /GTDLEA5tlUiJF/SFtrgDgPDYghaREcJqEPG/PiyfOWnAs25XAz4TD+Og/MFbt3do4cI+
	 TuKqYvZtf/bBH7oUxX8YkYMAtcFg5LL2kktJUWCCh69qcrIaMpXIqgf1xlvn4fsHCEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hSmk+J9v;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C0D606A31C
	for <mm-commits@vger.kernel.org>; Sat, 28 Nov 2026 05:12:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79C0D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hSmk+J9v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795842736; x=1827378736;
  h=date:from:to:cc:subject:message-id;
  bh=gaeNwrCQmmeZLD+UpBMSQ5wrQen0hGARmnXlogyI7zQ=;
  b=hSmk+J9v0YmR4YDtqH/D1J1ZVqktrvITYSTPLEsU/2mkPzBzElmDZAKx
   +bQ8MrasUfxzVKl/SYsuvgmf88oo9X7ec6USWRqNEE8gHSYL/Lp5fGdbK
   sD+qJjJZxt/qTeMWT/SrrZIrVp75q1qSZxvXBbSN18sIcjsN6iD7TRuPA
   7kmrhMzk2cVTn2RJUvFtqVIYrNtx0aZdxmUzCkMkkL4JtrZ0qHM25c2TP
   ieswBeNxnPCB5OsQMy5eIYAVrdGqITy0ZzXYtsu3ZBYml7ZYoQsW0srta
   2x5XAvBpxdKRqA8Dzhz9HQYLCpA0601EOW3SEkwVtyfN0KOOntrDIJPVA
   w==;
X-CSE-ConnectionGUID: i0bYPncQQVyjaTdAJ8OvTQ==
X-CSE-MsgGUID: oDBSxZphS3+ZMsEdM6H8Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11979"; a="4649422"
X-IronPort-AV: E=Sophos;i="6.27,238,1787036400"; 
   d="scan'208";a="4649422"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 21:12:16 -0800
X-CSE-ConnectionGUID: amhjKOqXTbasDejXf8oNIA==
X-CSE-MsgGUID: 84lOGwEKSGmWGnsT2fvvqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,238,1787036400"; 
   d="scan'208";a="12546650"
Received: from igk-lkp-server01.igk.intel.com (HELO 146cf1e082f1) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 27 Nov 2026 21:12:14 -0800
Received: from kbuild by 146cf1e082f1 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xXAjL-000000000WA-2hQS;
	Sat, 28 Nov 2026 05:12:11 +0000
Date: Sat, 28 Nov 2026 06:11:18 +0100
From: kernel test robot <lkp@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 303/428] mm/huge_memory.c:2546:67:
 error: too few arguments to function call, expected 4, have 3
Message-ID: <20261128060622.OMTGOfau-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   ac6a52aad42728ef45e6972c403072fba5c524f4
commit: 5a7c0c5e349b6b13c1689fedd1a82073b4679418 [303/428] mm/hugetlb: delay anon folio rmap removal until after the TLB flush
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261128060622.OMTGOfau-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/huge_memory.c:2546:67: error: too few arguments to function call, expected 4, have 3
    2546 |         else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
         |                  ~~~~~~~~~~~~~~~~~~~~~~                                  ^
   include/asm-generic/tlb.h:248:6: note: '__tlb_remove_page_size' declared here
     248 | bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
         |      ^                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     249 |                 int page_size, bool delay_rmap);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +2546 mm/huge_memory.c

953c66c2b22a304 Aneesh Kumar K.V         2016-12-12  2503  
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2504) static void zap_huge_pmd_folio(struct mmu_gather *tlb, struct vm_area_struct *vma,
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2505) 		pmd_t pmdval, struct folio *folio, bool is_present, bool *force_flush)
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2506) {
63a940541358d09 Chris Mason              2026-10-31  2507  	const bool is_device_private = pmd_is_device_private_entry(pmdval);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2508) 	struct mm_struct *mm = tlb->mm;
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2509) 	bool delay_rmap = false;
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2510) 
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2511) 	if (folio_test_anon(folio)) {
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2512) 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2513) 	} else {
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2514) 		add_mm_counter(mm, mm_counter_file(folio),
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2515) 			       -HPAGE_PMD_NR);
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2516) 
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2517) 		if (is_present && pmd_dirty(pmdval)) {
fe6cf984939d8e1 Usama Arif               2026-08-19  2518  			folio_mark_dirty(folio);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2519) 			/*
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2520) 			 * Remove rmap after the TLB flush if stale TLB entries
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2521) 			 * could still be used to write to a mapping that
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2522) 			 * supports writeback.
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2523) 			 */
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2524) 			if (!tlb->fullmm && vma->vm_file &&
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2525) 			    mapping_can_writeback(vma->vm_file->f_mapping))
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2526) 				delay_rmap = tlb_can_delay_rmap();
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2527) 		}
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2528) 		if (is_present && pmd_young(pmdval) &&
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2529) 		    likely(vma_has_recency(vma)))
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2530) 			folio_mark_accessed(folio);
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2531) 	}
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2532) 
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2533) 	if (!is_present && !is_device_private)
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2534) 		return;
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2535) 
e6a07d29b0a60f3 Chris Mason              2026-10-31  2536  	/*
e6a07d29b0a60f3 Chris Mason              2026-10-31  2537  	 * Present and device private folios are rmappable. Remove the
e6a07d29b0a60f3 Chris Mason              2026-10-31  2538  	 * rmap after transferring young+dirty to the folio.
e6a07d29b0a60f3 Chris Mason              2026-10-31  2539  	 */
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2540) 	if (!delay_rmap)
e6a07d29b0a60f3 Chris Mason              2026-10-31  2541  		folio_remove_rmap_pmd(folio, &folio->page, vma);
e6a07d29b0a60f3 Chris Mason              2026-10-31  2542  
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2543) 	/* Device private folios are pinned and don't need a TLB flush. */
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2544) 	if (is_device_private)
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2545) 		folio_put(folio);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16 @2546) 	else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2547) 		*force_flush = true;
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2548) 
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2549) 	if (delay_rmap) {
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2550) 		tlb_flush_mmu_tlbonly(tlb);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2551) 		folio_remove_rmap_pmd(folio, &folio->page, vma);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2552) 	}
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2553) }
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2554) 

:::::: The code at line 2546 was first introduced by commit
:::::: c818150bf00b0b42ff02bffc6a2c36d4f0ff7a52 mm/huge_memory: flush dirty file PMDs before removing rmap

:::::: TO: David Hildenbrand (Arm) <david@kernel.org>
:::::: CC: David Hildenbrand (Arm) <david@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
