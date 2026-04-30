Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9532D175A95
	for <mm-commits@vger.kernel.org>; Thu, 30 Apr 2026 00:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777510221; cv=none; b=ifrFP9faZw8N61VblZa2dTofBTuJxF/Vv6xJuaRsA4F+sFd5kzsMlhWKLyPq9I158Ce3fPnVa2KWQBZR7XgbBTCM4/dv5ppMxlHHhPvDsmMlMy1iL68dvkDBja/IVUnoAfocVoC+NodjdRWv8MM++MZYNO4ciRMjW8k3FIJ3ppc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777510221; c=relaxed/simple;
	bh=aXMoOusuOALMbE7e+GfRyfXXPBz0mQyjAv7jzLYb5Aw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=rSAHLcMM6vxFTtl0hsJyxPFHZ+n27sXKLn8Z7dgBVDuOoulrr1KRKtp5/2144bYNlAutqGedyhA7ITK+vdNj87fTAkvfHM8mI4xoGWRvEe++vfdm0pMjm1bJ3gm88v/w62zL62xN3H7NY4fiBF1mxLsb3g3NqWKuMJ25SyMnVNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=crtf+Kvd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="crtf+Kvd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777510220; x=1809046220;
  h=date:from:to:cc:subject:message-id;
  bh=aXMoOusuOALMbE7e+GfRyfXXPBz0mQyjAv7jzLYb5Aw=;
  b=crtf+Kvd0UdpCmdnqYG0OKiY3mF5zCZGU8I0JZBvrE9iD3RLeLgamWwi
   ZkxjhJZvYJO+RFFJ194e3HYRsHU+yS6DhZ3aKxttO5cMZHAyOMRkM7jYI
   YStTDDRJEbv/W7AqFT6VdroLt3kGARViz8r5C1z7h0B2X5XpJRPc4oRtf
   ULVprM34wHXDefLFblQRGe8BaF7dWkeQs9PO5Olzq7VP63OqB3S8Ku3X8
   sPIr7d7XqY2DPV8OQ7RJSD8pMPaCQ1QK+w16NioiuPZoTASvujTDcu8qS
   FRduIWLqqpWgukdOzSTU1vXravNRCG6ipUEuaaIK1wXz87RLlvzSAtEuG
   g==;
X-CSE-ConnectionGUID: eoTmxXkWReuGIAw3MJ4F0A==
X-CSE-MsgGUID: fdfX0HRzRi2poq+s4UJRtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78163728"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="78163728"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 17:50:20 -0700
X-CSE-ConnectionGUID: Ymoo+HEGRp6RIjwsZKlkNQ==
X-CSE-MsgGUID: O3ibbaMHTua6OklscrygaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="233379037"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 29 Apr 2026 17:50:17 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIFba-00000000Bje-12LN;
	Thu, 30 Apr 2026 00:50:14 +0000
Date: Thu, 30 Apr 2026 08:49:15 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 117/130] arch/riscv/mm/init.c:116:22:
 warning: implicit conversion from 'unsigned long long' to 'u32' (aka
 'unsigned int') changes value from 1099511627776 to 0
Message-ID: <202604300817.QeXlZapz-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20260430/202604300817.QeXlZapz-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300817.QeXlZapz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300817.QeXlZapz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/riscv/mm/init.c:27:
   In file included from arch/riscv/include/asm/fixmap.h:64:
   include/asm-generic/fixmap.h:93:26: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
           __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
                                   ^
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
   #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
                               ^
   include/asm-generic/fixmap.h:99:33: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
           __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
                                          ^
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
   #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
                               ^
>> arch/riscv/mm/init.c:116:22: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
                      (((t) - (b)) >> LOG2_SZ_1T));
                                      ^~~~~~~~~~
   include/linux/printk.h:574:36: note: expanded from macro 'pr_notice'
           printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
                                             ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                                   ^~~~~~~~~~~
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
   #define __AC(X,Y)       (X##Y)
                            ^~~~
   <scratch space>:6:1: note: expanded from here
   0x10000000000ULL
   ^~~~~~~~~~~~~~~~
   include/linux/log2.h:162:14: note: expanded from macro 'ilog2'
           __ilog2_u32(n) :                \
           ~~~~~~~~~~~ ^
   arch/riscv/mm/init.c:126:43: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
           if (IS_ENABLED(CONFIG_64BIT) && (diff >> LOG2_SZ_1T) >= 10)
                                                    ^~~~~~~~~~
   arch/riscv/mm/init.c:92:27: note: expanded from macro 'LOG2_SZ_1T'
   #define LOG2_SZ_1T  ilog2(SZ_1T)
                       ~~~~~~^~~~~~
   include/linux/sizes.h:63:18: note: expanded from macro 'SZ_1T'
   #define SZ_1T                           _AC(0x10000000000, ULL)
                                           ^~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
   #define _AC(X,Y)        __AC(X,Y)
                           ^~~~~~~~~
   include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
   #define __AC(X,Y)       (X##Y)
                            ^~~~
   <scratch space>:11:1: note: expanded from here
   0x10000000000ULL
   ^~~~~~~~~~~~~~~~
   include/linux/log2.h:162:14: note: expanded from macro 'ilog2'
           __ilog2_u32(n) :                \
           ~~~~~~~~~~~ ^
   arch/riscv/mm/init.c:245:49: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 17179869184 to 0 [-Wconstant-conversion]
                   vmemmap_start_pfn = round_down(phys_ram_base, VMEMMAP_ADDR_ALIGN) >> PAGE_SHIFT;
                                                                 ^~~~~~~~~~~~~~~~~~
   arch/riscv/mm/init.c:67:9: note: expanded from macro 'VMEMMAP_ADDR_ALIGN'
                                       MAX_FOLIO_VMEMMAP_ALIGN)
                                       ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mmzone.h:108:3: note: expanded from macro 'MAX_FOLIO_VMEMMAP_ALIGN'
            MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
            ^~~~~~~~~~~~~~~~~~
   include/linux/mmzone.h:97:36: note: expanded from macro 'MAX_FOLIO_NR_PAGES'
   #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
                                           ^~~~~~~~~~~~~~~
   note: (skipping 8 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/minmax.h:92:28: note: expanded from macro '__careful_cmp_once'
           auto ux = (x); auto uy = (y);                   \
                                     ^
   include/linux/math.h:35:50: note: expanded from macro 'round_down'
   #define round_down(x, y) ((x) & ~__round_mask(x, y))
                                                    ^
   include/linux/math.h:15:46: note: expanded from macro '__round_mask'
   #define __round_mask(x, y) ((__typeof__(x))((y)-1))
                                                ^
   3 warnings and 2 errors generated.


vim +116 arch/riscv/mm/init.c

26b8f69edda85a Alexandre Ghiti 2021-12-06  111  
26b8f69edda85a Alexandre Ghiti 2021-12-06  112  #ifdef CONFIG_64BIT
26b8f69edda85a Alexandre Ghiti 2021-12-06  113  static inline void print_mlt(char *name, unsigned long b, unsigned long t)
26b8f69edda85a Alexandre Ghiti 2021-12-06  114  {
26b8f69edda85a Alexandre Ghiti 2021-12-06  115  	pr_notice("%12s : 0x%08lx - 0x%08lx   (%4ld TB)\n", name, b, t,
26b8f69edda85a Alexandre Ghiti 2021-12-06 @116  		   (((t) - (b)) >> LOG2_SZ_1T));
26b8f69edda85a Alexandre Ghiti 2021-12-06  117  }
26b8f69edda85a Alexandre Ghiti 2021-12-06  118  #else
26b8f69edda85a Alexandre Ghiti 2021-12-06  119  #define print_mlt(n, b, t) do {} while (0)
26b8f69edda85a Alexandre Ghiti 2021-12-06  120  #endif
26b8f69edda85a Alexandre Ghiti 2021-12-06  121  

:::::: The code at line 116 was first introduced by commit
:::::: 26b8f69edda85a7942fa580360690c2d5c74f765 riscv: Improve virtual kernel memory layout dump

:::::: TO: Alexandre Ghiti <alexandre.ghiti@canonical.com>
:::::: CC: Palmer Dabbelt <palmer@rivosinc.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
