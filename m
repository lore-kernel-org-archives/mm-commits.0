Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833F12CDBE
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782723684; cv=none; b=Nsy3tGMDQlSYwR0mbnu8f+0ccBMOHz93JB49hD7GzvUpAIFJHJIAdxmGQtWdxKBkxRBB8SUdZbnXARHf3QqmBwRvpbnMeSaAZleW6mcB65v1IAr0T6roZZT6ZHjrKO7LJlhq2pjJqQXm61hMoDr1i1E+tcx1LWajbSOb81+4Q+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782723684; c=relaxed/simple;
	bh=KbmCoknG2orb/kPH/fe4sjn//vOjVoCFNLotR7tHsdw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=BWwruPt0BtNlZqNVISF/sSubSdswP7OlPfPVKWZ6ngnkGX3hRlNqaaxnUYBbINu1P7QDyjd/LGBUyS1Zf8NoDVWnCJCnNywtkReO9Qx/qV3fA8ghvm7GyzGsT0oia3t6XXwB1AxabyIDUfLEePJ5AmD8D6KAJHWLiPH7k48+U5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YtqoRnZ/; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YtqoRnZ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782723681; x=1814259681;
  h=date:from:to:cc:subject:message-id;
  bh=KbmCoknG2orb/kPH/fe4sjn//vOjVoCFNLotR7tHsdw=;
  b=YtqoRnZ/B2Z8AJeMzxC0IT9WmTb2pNcoKQnfDT13SIBJCyO71P4eHG3M
   JB7lCmhx6/xtiek5ZKrsNmlnRRefjszIilnYhsekAUavXzyQyHfm5hyy4
   0KFLzzdb+wBC9OTJjHjuhDerPDbvV9C2lBlBwqeF2LEJDnDfXSjMzz6b6
   4MeBHMS5Cy060RxYzUIb6eVysC/jrzQ1+REO/zAmnuwA8fkAbGixx+D2f
   IdKsVGk1ro8FNf5NsG/kD0SmPUw12Z1+IVSYg7r7n1W895a9gOT6CVBA1
   rZbaOUQg5eHoBaP9mbQCltbEdwPiLL6h9+c2SAD2hG/ONO9o27e0hb0FZ
   g==;
X-CSE-ConnectionGUID: TY5mw+GPTh+BGANdQSIlJA==
X-CSE-MsgGUID: khLpdfNLScS1SPParz1cPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11831"; a="100947232"
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="100947232"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 02:01:21 -0700
X-CSE-ConnectionGUID: Y4U4qRQeT7eCJD9RDEdEZA==
X-CSE-MsgGUID: h1txXwLdTdaMp4WtOw0Ylw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="247448708"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 29 Jun 2026 02:01:17 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1we7q9-000000007CD-0bBm;
	Mon, 29 Jun 2026 09:00:00 +0000
Date: Mon, 29 Jun 2026 16:58:34 +0800
From: kernel test robot <lkp@intel.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Dev Jain <dev.jain@arm.com>,
 Wen Jiang <jiangwen6@xiaomi.com>
Subject: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning:
 unused variable 'start'
Message-ID: <202606291606.9h8aGniQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   88cefc306c43b58d9bb65c9e96e284306710d961
commit: 80c453511b6ee1af0e4db83c3db0020215c4eaf0 [59/142] mm/vmalloc: map contiguous pages in batches for vmap() if possible
config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/vmalloc.c: In function 'vmap_batched':
>> mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
    3590 |         unsigned long start = addr, map_addr = addr;
         |                       ^~~~~


vim +/start +3590 mm/vmalloc.c

  3584	
  3585	static int vmap_batched(unsigned long addr, unsigned long end,
  3586			pgprot_t prot, struct page **pages)
  3587	{
  3588		unsigned int count = (end - addr) >> PAGE_SHIFT;
  3589		unsigned int prev_shift = 0, idx = 0;
> 3590		unsigned long start = addr, map_addr = addr;
  3591		int err;
  3592	
  3593		err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
  3594							PAGE_SHIFT, GFP_KERNEL);
  3595		if (err)
  3596			goto out;
  3597	
  3598		for (unsigned int i = 0; i < count; ) {
  3599			unsigned int shift = PAGE_SHIFT +
  3600				get_vmap_batch_order(pages, prot, count - i, i);
  3601	
  3602			if (!i)
  3603				prev_shift = shift;
  3604	
  3605			if (shift != prev_shift) {
  3606				err = vmap_pages_range_noflush_walk(map_addr, addr,
  3607						prot, pages + idx, prev_shift);
  3608				if (err)
  3609					goto out;
  3610				prev_shift = shift;
  3611				map_addr = addr;
  3612				idx = i;
  3613			}
  3614	
  3615			/*
  3616			 * Once small pages are encountered, the remaining pages
  3617			 * are likely small as well.
  3618			 */
  3619			if (shift == PAGE_SHIFT)
  3620				break;
  3621	
  3622			addr += 1UL << shift;
  3623			i += 1U << (shift - PAGE_SHIFT);
  3624		}
  3625	
  3626		/* Remaining */
  3627		if (map_addr < end)
  3628			err = vmap_pages_range_noflush_walk(map_addr, end,
  3629					prot, pages + idx, prev_shift);
  3630	
  3631	out:
  3632		flush_cache_vmap(start, end);
  3633		return err;
  3634	}
  3635	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
