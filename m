Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7394E2F2A
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893930; cv=none; b=tas7qG+xAIL+rzQpAE+3JiJQPN2RoPBRy8fxxpupCvcrDl9CgUNWocVIVaGFf0/Qh/9DnV5KiNpb+CyH1X35T+KCKofTyvCVnPb3EupmrR+Wxg4/aV3fUikEHMTcl70+zhR02EhbQ3dXQUFRsq9T1ZOsTshFGsoB2Dj0C7MMAIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893930; c=relaxed/simple;
	bh=R5qQrym39cHyGlBkeTRcjgJWXjS1CQRn4cl0zb0rtCQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=k2rIeJoOVq1ljr/DLDydBx2FTW0bG/s19x2k3SkjUkki2x+C7Tr96y1KjloW3ZRfSIZzLNLIlML8eKLZtA2Wxx+Ers5tlJ994uEu+qdZd8MPXa74dEg8nVY/pevi904dtvZV5FjNpS9Ib/yvmIVarbc7/aOr1eAr1GBPJpCs9CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQplsqLz; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQplsqLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791893929; x=1823429929;
  h=date:from:to:cc:subject:message-id;
  bh=R5qQrym39cHyGlBkeTRcjgJWXjS1CQRn4cl0zb0rtCQ=;
  b=BQplsqLzcrqg8LEbCb3e0BnjacrcLKKoeDyKPPsk1r2f2w1nvUBrt7Z9
   a8hF6ABahBgC1ST/lvLRnfo+VT1v0KGNTa/XgID5tr4MFwC0SNPSw6zdx
   eZBpcBQRipBV49okfNWV6xn3P2dreIUZwHHb7/+QgMVBEVaVBf9LIIByW
   YK5ahw5x4FMDxyfg+Nyy1XwDad2DmLiXGJonpYK71/0S70mswQxlN3VKL
   m8FEdJw/iutsuxdlTmrNsXpjUkKRwCxg08uEnDuEBKmMPNUjWiowFeZkJ
   aHcr9cX5sKhw2BnQaAoLomNbEafFdp3a6+mrxxt/CjrcMZRfjcXhjl0T/
   A==;
X-CSE-ConnectionGUID: DySL0YcPQ6i0v2slHfygVg==
X-CSE-MsgGUID: jVDf8OLiSwGrklzYnn1v3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="620206"
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="620206"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 05:18:49 -0700
X-CSE-ConnectionGUID: 8ahP6q1lQJ+ch0B98VnhsA==
X-CSE-MsgGUID: n7a/zTXrTZCeK5M1hrexaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="1262157"
Received: from igk-lkp-server01.igk.intel.com (HELO d0de6c2a75a7) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 13 Oct 2026 05:18:47 -0700
Received: from kbuild by d0de6c2a75a7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGbSu-00000000AUx-20is;
	Tue, 13 Oct 2026 12:18:44 +0000
Date: Tue, 13 Oct 2026 14:18:21 +0200
From: kernel test robot <lkp@intel.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 183/193] arch/riscv/mm/init.c:1544:2:
 error: implicit declaration of function 'free_pgtable_page'; did you mean
 'pmd_pgtable_page'?
Message-ID: <202610131439.F2KDdzRA-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   7186f1bd21b9094cc063c10f8492fd135522d3cb
commit: cf6402c085736133c835e1f815f79e7e1faf97a0 [183/193] riscv/mm: fix missing destructor for hotplug PUD tables
config: riscv-randconfig-r2109-20261013 (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610131439.F2KDdzRA-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/riscv/mm/init.c: In function 'free_pud_table':
>> arch/riscv/mm/init.c:1544:2: error: implicit declaration of function 'free_pgtable_page'; did you mean 'pmd_pgtable_page'? [-Werror=implicit-function-declaration]
    1544 |  free_pgtable_page(page);
         |  ^~~~~~~~~~~~~~~~~
         |  pmd_pgtable_page
   cc1: some warnings being treated as errors


vim +1544 arch/riscv/mm/init.c

  1531	
  1532	static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
  1533	{
  1534		struct page *page = p4d_page(*p4d);
  1535		pud_t *pud;
  1536		int i;
  1537	
  1538		for (i = 0; i < PTRS_PER_PUD; i++) {
  1539			pud = pud_start + i;
  1540			if (!pud_none(*pud))
  1541				return;
  1542		}
  1543	
> 1544		free_pgtable_page(page);
  1545		p4d_clear(p4d);
  1546	}
  1547	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
