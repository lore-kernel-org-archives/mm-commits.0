Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57BD3B0AC4
	for <mm-commits@vger.kernel.org>; Thu, 30 Apr 2026 13:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777554450; cv=none; b=kLEqtZCxYlpT0miqpxlL6WJ9SGkazlN26Sx5KuvIR/9bLUR1Yzmm3O/uRsVNvXf0fKWpq0i4tNXDbYeyjUfj4YQ0JlAjkq1+WRPvPQrzk4WZsVdKCy+SqoZ39O7nCFNlNxQlbTsGoGH2aHs0sqJn4U4nwYCALvOSRlY9VKoQD/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777554450; c=relaxed/simple;
	bh=Z2cAcabUhgwviq787moawJMLwhFnq7gWY/8G4VRV1+0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=reVL0x66E54KV0kOekxU/BPwuk38iQXjPAiCrwSAr6ymFif6VRSOGFngI48x4dueIK12KrEvbRjePI/7dPANHtfQTi5Jfbf7k7Np3dCFfZjA0/8GCYyvXfvRbe+WbmmU9Lhl0OSbtBoj9347ScASRlE4gdYDq9wmJF1uTxsyNyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iiBOlgpR; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iiBOlgpR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777554449; x=1809090449;
  h=date:from:to:cc:subject:message-id;
  bh=Z2cAcabUhgwviq787moawJMLwhFnq7gWY/8G4VRV1+0=;
  b=iiBOlgpRvAb3wWTYduDGECHaiCVUhyyDnfwgJcDNtT+iByq+jBftwvrr
   V4wQBU6qfgubnJviTCgoEbt3TgmLSg6i1h3w0IyHbZtM5U8pfl6/FdkUF
   DYB82L9oKJOaoJgIhDLHZTHFuYBF3G1S3dYj6+3pGCT/FVjProagoxKpv
   lpj6QGRGtOjyaB5uufw6GhCAbs91zKywsADfyMupi5S04IDtSvtbJWnJv
   agEtKzIX/Ep2CrbBr2J+WnNAudzgYbRZFow1waG8BpIaI6bQSfOiGD2lm
   kxJ0pwf7NtP8VU0EGi+n0pnBphLQLB7kjt2fTcJ9m9pzU8eqLTRLLhAxD
   Q==;
X-CSE-ConnectionGUID: fcJJKuc9R92gtZm0mW5cRQ==
X-CSE-MsgGUID: sERgUVuOQgOhVpOUv2u/lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89963172"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="89963172"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 06:07:29 -0700
X-CSE-ConnectionGUID: mwJh41SQSU2C12Fvxh6Oxw==
X-CSE-MsgGUID: ne9qaGMaTM2y5y6JEpc5hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="264947044"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 30 Apr 2026 06:07:26 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIR6x-00000000CPM-2ZIz;
	Thu, 30 Apr 2026 13:07:23 +0000
Date: Thu, 30 Apr 2026 21:07:13 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 115/182] mm/internal.h:847:26: warning:
 implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int')
 changes value from 17179869184 to 0
Message-ID: <202604302039.yKocJk8m-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 78c22ab4ad70900027ae72e857274535c798ccfb [115/182] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20260430/202604302039.yKocJk8m-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604302039.yKocJk8m-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604302039.yKocJk8m-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/early_ioremap.c:18:
   In file included from arch/riscv/include/asm/fixmap.h:64:
   include/asm-generic/fixmap.h:93:26: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
      93 |         __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                 ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:99:33: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
      99 |         __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                        ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   In file included from mm/early_ioremap.c:20:
>> mm/internal.h:847:26: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 17179869184 to 0 [-Wconstant-conversion]
     847 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   include/linux/mmzone.h:85:33: note: expanded from macro 'MAX_FOLIO_ORDER'
      85 | #define MAX_FOLIO_ORDER         (ilog2(SZ_16G) - PAGE_SHIFT)
         |                                  ~~~~~~^~~~~~~
   include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~~~~~~
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/log2.h:162:14: note: expanded from macro 'ilog2'
     162 |         __ilog2_u32(n) :                \
         |         ~~~~~~~~~~~ ^
   include/linux/mmdebug.h:123:50: note: expanded from macro 'VM_WARN_ON_ONCE'
     123 | #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
         |                                                  ^~~~
   include/asm-generic/bug.h:120:25: note: expanded from macro 'WARN_ON_ONCE'
     120 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   1 warning and 2 errors generated.


vim +847 mm/internal.h

904d58578fce53 Kefeng Wang             2023-05-16  831  
3c605096d31582 Joonsoo Kim             2014-11-13  832  extern int __isolate_free_page(struct page *page, unsigned int order);
624f58d8f46396 Alexander Duyck         2020-04-06  833  extern void __putback_isolated_page(struct page *page, unsigned int order,
624f58d8f46396 Alexander Duyck         2020-04-06  834  				    int mt);
58e3e5265484a1 Shengming Hu            2025-12-29  835  extern void memblock_free_pages(unsigned long pfn, unsigned int order);
13c526540b3169 David Hildenbrand       2024-06-07  836  extern void __free_pages_core(struct page *page, unsigned int order,
13c526540b3169 David Hildenbrand       2024-06-07  837  		enum meminit_context context);
9420f89db2dd61 Mike Rapoport (IBM      2023-03-21  838) 
1e3be4856f49d5 Tarun Sahu              2023-06-12  839  /*
1e3be4856f49d5 Tarun Sahu              2023-06-12  840   * This will have no effect, other than possibly generating a warning, if the
1e3be4856f49d5 Tarun Sahu              2023-06-12  841   * caller passes in a non-large folio.
1e3be4856f49d5 Tarun Sahu              2023-06-12  842   */
1e3be4856f49d5 Tarun Sahu              2023-06-12  843  static inline void folio_set_order(struct folio *folio, unsigned int order)
1e3be4856f49d5 Tarun Sahu              2023-06-12  844  {
1e3be4856f49d5 Tarun Sahu              2023-06-12  845  	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
1e3be4856f49d5 Tarun Sahu              2023-06-12  846  		return;
99132d24d76511 David Hildenbrand       2025-09-01 @847  	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
1e3be4856f49d5 Tarun Sahu              2023-06-12  848  
ebc1baf5c9b46c Matthew Wilcox (Oracle  2023-08-16  849) 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
4996fc547f5b49 David Hildenbrand       2025-03-03  850  #ifdef NR_PAGES_IN_LARGE_FOLIO
4996fc547f5b49 David Hildenbrand       2025-03-03  851  	folio->_nr_pages = 1U << order;
1e3be4856f49d5 Tarun Sahu              2023-06-12  852  #endif
1e3be4856f49d5 Tarun Sahu              2023-06-12  853  }
1e3be4856f49d5 Tarun Sahu              2023-06-12  854  

:::::: The code at line 847 was first introduced by commit
:::::: 99132d24d76511f0f6ded2e25448765b632794aa mm: sanity-check maximum folio size in folio_set_order()

:::::: TO: David Hildenbrand <david@redhat.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
