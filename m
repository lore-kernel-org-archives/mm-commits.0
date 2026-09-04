Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893523B42C7
	for <mm-commits@vger.kernel.org>; Fri,  4 Sep 2026 04:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788496138; cv=none; b=FDl2D6amW8xIGl5oxMe8fp6jgNWULcN68AELcF6ChnJtpUeOg8I/08L3eCYMwNaLM+wuvHlfLdqBVvyNGWJ+CW+iQHLBcCWdvlEaTANEtSiaMHC0STGRrpIbugAfndsAkDbpxWWJKTiJgyQCml0PHxf9LppI3L9OpUEp0jFw9M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788496138; c=relaxed/simple;
	bh=w76Wgyu5ch/AXeo3ZtSdR7LhvuJGWr8xt9NF6O2p8sI=;
	h=Date:From:To:Cc:Subject:Message-ID; b=CrVe1OkqzithnQDy84BXXWpcn2uuVYzkvKlxzhNDgBLswtEnmrL3RpeUqoiShRDdRxIITiwNq9t6CUMDTAFXK/9J2FDprAaoCq0BwQ8z5X+UIPxyfNHx+3M0T+/6mUgN1toTEEmOqMgewgr46WwQ+9sZpM36o9S53PiSKbFkrHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jBQoozmp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jBQoozmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788496135; x=1820032135;
  h=date:from:to:cc:subject:message-id;
  bh=w76Wgyu5ch/AXeo3ZtSdR7LhvuJGWr8xt9NF6O2p8sI=;
  b=jBQoozmpgeW74r1cBFP4gy+1I4gGTxzI+BpRQejSnQVGPjRJhFd0uXlj
   ORMXVLnMpOvIRqHRkFNk7rhsgbRF4ehNkNk8Hp4kBakPjn2xIHvr8j8cj
   ga+6rdkrWnIeFSy5PP+wqDtwoeKF8Pp2H2rbtPxe3ttrRr/Inr4X5AIur
   dV7KlqPQCARAOZd/k90Pam6qOdeY1GmmYsUaQE0b1Im8ArQSu2SdwvnOl
   mHt48UEfT/00maWqcc46D5pIj12G1rCMIUKzS9JbffbPXYCyjh8HDQhSX
   Y4uzhaVuVpB1FTNNsOL/SkH9hCzN800QNwNNlT3/TvxQvwP7pQCZiD3G5
   Q==;
X-CSE-ConnectionGUID: 1RS8dAL9Sx2TR3KycFEsBA==
X-CSE-MsgGUID: eljQ8QJiTca0BitjUY4sJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88135122"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88135122"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 21:28:55 -0700
X-CSE-ConnectionGUID: qfwbpt30StaTEgwgfq3FHw==
X-CSE-MsgGUID: 9yl3htK0QHu5TBqWybBfIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="269389491"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 03 Sep 2026 21:28:53 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2LXm-000000005kO-2NR1;
	Fri, 04 Sep 2026 04:28:50 +0000
Date: Fri, 04 Sep 2026 12:28:37 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 302/317] mm/memory.c:2271:17: error: too
 many arguments to function 'hugetlb_zap_begin'
Message-ID: <202609041234.yRUbaeuB-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   2aeb49124a2b3d0c9aa8c0a2124c8cae21ab4e0b
commit: f1fc44daf6183604b96243805877ee0b1626daaf [302/317] mm/hugetlb: don't lock private resv_map during final unmap
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260904/202609041234.yRUbaeuB-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260904/202609041234.yRUbaeuB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609041234.yRUbaeuB-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function 'unmap_vmas':
>> mm/memory.c:2271:17: error: too many arguments to function 'hugetlb_zap_begin'
    2271 |                 hugetlb_zap_begin(vma, &start, &end, &details);
         |                 ^~~~~~~~~~~~~~~~~
   In file included from mm/memory.c:48:
   include/linux/hugetlb.h:322:20: note: declared here
     322 | static inline void hugetlb_zap_begin(
         |                    ^~~~~~~~~~~~~~~~~


vim +/hugetlb_zap_begin +2271 mm/memory.c

  2238	
  2239	/**
  2240	 * unmap_vmas - unmap a range of memory covered by a list of vma's
  2241	 * @tlb: address of the caller's struct mmu_gather
  2242	 * @unmap: The unmap_desc
  2243	 *
  2244	 * Unmap all pages in the vma list.
  2245	 *
  2246	 * Only addresses between `start' and `end' will be unmapped.
  2247	 *
  2248	 * The VMA list must be sorted in ascending virtual address order.
  2249	 *
  2250	 * unmap_vmas() assumes that the caller will flush the whole unmapped address
  2251	 * range after unmap_vmas() returns.  So the only responsibility here is to
  2252	 * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
  2253	 * drops the lock and schedules.
  2254	 */
  2255	void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
  2256	{
  2257		struct vm_area_struct *vma;
  2258		struct mmu_notifier_range range;
  2259		struct zap_details details = {
  2260			.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
  2261		};
  2262	
  2263		vma = unmap->first;
  2264		mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
  2265					unmap->vma_start, unmap->vma_end);
  2266		mmu_notifier_invalidate_range_start(&range);
  2267		do {
  2268			unsigned long start = max(vma->vm_start, unmap->vma_start);
  2269			unsigned long end = min(vma->vm_end, unmap->vma_end);
  2270	
> 2271			hugetlb_zap_begin(vma, &start, &end, &details);
  2272			__zap_vma_range(tlb, vma, start, end, &details);
  2273			hugetlb_zap_end(vma, &details);
  2274			vma = mas_find(unmap->mas, unmap->tree_end - 1);
  2275		} while (vma);
  2276		mmu_notifier_invalidate_range_end(&range);
  2277	}
  2278	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
