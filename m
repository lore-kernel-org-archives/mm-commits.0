Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AEB37A839
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790440412; cv=none; b=soY0aE0SVTzF17ZiN0dKqq9FezFSmjY1j67CzvjRoSz5I61ftGG/ThFt3HzdDcdNn1bQophUtSmnuTDCQi3wm6j89k6iyNC7kIei/wAA7IY8WDmyDhcY9DT0iH/L01MXXNGFMCyak+tEvbYKBo+jpx0Z1S5PnDt6EZ7VE4BKgvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790440412; c=relaxed/simple;
	bh=Xc4mqmXyIdGRF00RAE0TbL9TU95xsagceJS/KQl6m7w=;
	h=Date:From:To:Cc:Subject:Message-ID; b=QzHhXFBmEU4XSMWMCC7JBnd3ek57PhojUIzkDk92nLPrbuvPylTWV8eqRvC3keX3qm3dCGaNKVLCvmD+pSxzU28JBHLuykBHpiPqhEnkApoj67p1EswP8RtGZeq0CN/yV5Bn3oV+bI/4alynWkfN941u7RRblvIgPKk963sVLCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dllt/aGT; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dllt/aGT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790440408; x=1821976408;
  h=date:from:to:cc:subject:message-id;
  bh=Xc4mqmXyIdGRF00RAE0TbL9TU95xsagceJS/KQl6m7w=;
  b=dllt/aGTITQWfIesNdBCt5k82C/8fSaWQyzNA1MvWZ9WpHHKb6x7MXHa
   0NJiRpLlEj/uS8UynGDpfPleO3ND3gntl45wqysug6wN/9NH7q9/DxKhG
   be5n9tND1fU9QrBMmUQWEjS1VCtxAbzzIgvAkJGkUEtzT4PpUD4nXuJkd
   /fSrFHr+IyfwGigNklqQiYcoAG9YTK9klZUog19qdzuY2ooNzJhFUERXr
   wj183EAniBcOlxTV7g2Bjr+4BAUIEhDNPhh6a+8ejSw1gFga58aRKnLQY
   Il+k0BjM1W5AWAYEek/+B4bMvSMFVR7IiZF1sU9ulYnUYnS0iQM9u2r+7
   Q==;
X-CSE-ConnectionGUID: KGaj/1YRS0aefjWLiJdrRw==
X-CSE-MsgGUID: Jsgu7o2aTQu/6RHoyhpJbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="101725533"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="101725533"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 09:33:25 -0700
X-CSE-ConnectionGUID: P0AEcz5PT6ifZ56d6jHhWg==
X-CSE-MsgGUID: EcmS14TASEy6+k7KPaQxJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="273852166"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 26 Sep 2026 09:33:22 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAVKy-00000000LzN-09W0;
	Sat, 26 Sep 2026 16:33:20 +0000
Date: Sun, 27 Sep 2026 00:32:54 +0800
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
Message-ID: <202609270030.Y0QVBPmK-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   b4fc90c82982d98959af08b4320420bcfc01303b
commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com/

All errors (new ones prefixed by >>):

>> aarch64-linux-ld: Unexpected GOT/PLT entries detected!
>> aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: arch/arm64/mm/mmu.o: in function `__set_ptes_anysz.isra.40.constprop.47':
>> mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: arch/arm64/mm/hugetlbpage.o: in function `__set_ptes_anysz.isra.32':
>> hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: kernel/bpf/arena.o: in function `apply_range_set_cb':
>> arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/gup.o: in function `follow_page_pte':
>> gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/memory.o: in function `__set_ptes.isra.207':
>> memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/mprotect.o:mprotect.c:(.text+0x1080): more undefined references to `__check_safe_pte_update' follow

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
