Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB33AD506
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 22:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777502410; cv=none; b=bOZsZyNqiPSKI5b+nj8RJJXaVZcyoVvbh2pj7kSo1G/XKgg87MsXBzLgjAZfso8hbsPBZbbvtfmYwJ8QXvsq45//3wSK78Tw5yJZJU9BAjeA7ub+OsLJvGeTWQ6G3545XXmv6pqyS5WifqfnQAF8KrH6aar5IlfEZpgZj3sN+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777502410; c=relaxed/simple;
	bh=0he1QITSyDMsAyQOTd+y2mjHFsc1of6tuhtd6nynGcs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=UI1mMQDR52BTLPKWU1S46xBxPeVFlfiOzPqMxx9FqScGt/fKh/XBuNyzprS2HzDQsQtSZzbojHc/iJOBfNRFNW6DBvEhFQ+b9KTv/3GTwpi9m+tN8L9qe9OAhmKaI7tzOVLLSCvtv5j0gG8pL56Wy3IRFr3wvSbkcJFdvgkGT+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fZFFjEak; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fZFFjEak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777502408; x=1809038408;
  h=date:from:to:cc:subject:message-id;
  bh=0he1QITSyDMsAyQOTd+y2mjHFsc1of6tuhtd6nynGcs=;
  b=fZFFjEak7gxyf0JUTn+TfcCT8BYTsxPMY5qk7hF3HRHaMoegIeKYZhVp
   xkQLxeFL+JFf5r6cggkCNbrfPt+dsRRIs+XjYpbHj/AquGSR513bak79q
   fKdtFHDBT7RAc2nC3PThkI4TT7MsTGgf5Z1t+8oPBuip4GoloDGjeSFbf
   Dzxa5ReknimnBjBiKxotMvRml6lN5v135mtEsY5JxEYLxgxxzdbyAda/o
   LYkmJmEGqT+NFKS+w56HL1n9yBoguc/BfinYxgF3/Ts92bJ9niZwCGviu
   HP2juHJRg3lcu2k2hMMvS2ylYxfqN188S071+oPT11b6UpPJaPUMiuDhg
   Q==;
X-CSE-ConnectionGUID: dt7zoXKcSbC8ETZ/LHLUrw==
X-CSE-MsgGUID: AQPkbBt6TaONRLbY1+NE2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89135880"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="89135880"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 15:40:06 -0700
X-CSE-ConnectionGUID: EnRuKCwVRBeIQXh63w/rNg==
X-CSE-MsgGUID: eX+9jctdRDegJvZY+osyCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="234670681"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2026 15:40:03 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIDZY-00000000BbQ-3Xu8;
	Wed, 29 Apr 2026 22:40:00 +0000
Date: Thu, 30 Apr 2026 06:39:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 117/130] include/asm-generic/fixmap.h:77:2:
 error: call to undeclared function '__set_fixmap'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202604300638.A3yVzhM3-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: mips-xway_defconfig (https://download.01.org/0day-ci/archive/20260430/202604300638.A3yVzhM3-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300638.A3yVzhM3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300638.A3yVzhM3-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/mips/kernel/asm-offsets.c:17:
   In file included from include/linux/mm.h:31:
   In file included from include/linux/pgtable.h:6:
   In file included from arch/mips/include/asm/pgtable.h:14:
   In file included from arch/mips/include/asm/pgtable-32.h:17:
   In file included from arch/mips/include/asm/fixmap.h:70:
>> include/asm-generic/fixmap.h:77:2: error: call to undeclared function '__set_fixmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      77 |         __set_fixmap(idx, phys, flags);
         |         ^
>> include/asm-generic/fixmap.h:84:40: error: use of undeclared identifier 'PAGE_KERNEL'
      84 |         return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
         |                                               ^~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:48:28: note: expanded from macro 'FIXMAP_PAGE_NORMAL'
      48 | #define FIXMAP_PAGE_NORMAL PAGE_KERNEL
         |                            ^~~~~~~~~~~
   include/asm-generic/fixmap.h:93:2: error: call to undeclared function '__set_fixmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      93 |         __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
         |         ^
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
   In file included from arch/mips/kernel/asm-offsets.c:26:
   In file included from include/linux/kvm_host.h:5:
   In file included from include/linux/entry-virt.h:7:
   In file included from include/linux/syscalls.h:95:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:6:
   In file included from include/linux/ring_buffer.h:7:
   include/linux/poll.h:134:27: warning: division by zero is undefined [-Wdivision-by-zero]
     134 |                 M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
         |                                         ^~~~~~~~~
   include/linux/poll.h:132:32: note: expanded from macro 'M'
     132 | #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:118:51: note: expanded from macro '__MAP'
     118 |         (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
         |                                                          ^ ~~~~~~~~~
   include/linux/poll.h:134:39: warning: division by zero is undefined [-Wdivision-by-zero]
     134 |                 M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
         |                                                     ^~~~~~~~~
   include/linux/poll.h:132:32: note: expanded from macro 'M'
     132 | #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:118:51: note: expanded from macro '__MAP'
     118 |         (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
         |                                                          ^ ~~~~~~~~~
   2 warnings and 5 errors generated.
   make[3]: *** [scripts/Makefile.build:184: arch/mips/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1371: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/__set_fixmap +77 include/asm-generic/fixmap.h

    72	
    73	/* Return a pointer with offset calculated */
    74	static inline unsigned long
    75	__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
    76	{
  > 77		__set_fixmap(idx, phys, flags);
    78		return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
    79	}
    80	
    81	static inline unsigned long
    82	set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys)
    83	{
  > 84		return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
    85	}
    86	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
