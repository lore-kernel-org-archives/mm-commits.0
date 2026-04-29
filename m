Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10AC26ED5D
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 21:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777496455; cv=none; b=A7XEnqyQr5f1m/poKossUI3ECuqTdjAfPTnvGW1my1lJxbsoP5RYuShzJel6TkOBmOmWTLDHTcqxvOgdk51aCZaTyEOFRDKtdGm08gmNxD9zbi9DU4bdJjaRC324GIqU3pEs1Ija+YXL1hC7cU4lNl0kn2T6MMti3B29J4FKaBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777496455; c=relaxed/simple;
	bh=Tw1tjOKi0uEKgc0t9U8SNyE74PngO/1q9Aghuv15gOk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=pUshP06ufEFbDY6gxai3N40bX2ku+VuXlT/t/rj2BpaP72V+MCbTKR8yCKz//eLavtJVWdVmpPghCn9p/cR1nvwkL+UOAJZEtqZ+6RzEcCMsuaQwXsi6GG/Qe88M9/rXtHFTsxrWGCn8QtOgAFA9263ONPaIcmJmNamjohRxdqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S/TO397I; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S/TO397I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777496454; x=1809032454;
  h=date:from:to:cc:subject:message-id;
  bh=Tw1tjOKi0uEKgc0t9U8SNyE74PngO/1q9Aghuv15gOk=;
  b=S/TO397IJCvyYnvQg7aw7Haj0xlpDroBCvAXHwF9ayF4oqYjy3szD5lg
   ipE/b2FgkaPNckG15JdDAi1ZWliqqBSmIwxpBQIi+GAo2QugwOc5wUR+O
   7+0oiQf96c5jFrtAQP2bEdMdlUz+ugZjpjUZou2ANuUyKiUiho9jOkLVR
   D5ZQ9Nu9RYqwYzGFP+epe3iqPTiNG5Zcr3iEaIbYGlkZE/+dvAu6wzWd4
   QxoV3XhOrvnT5lVLY8vRst3ivg0o6QnLUNda/lJO3cZDE759ZT7PsbjXg
   qYwNb78k3VMulp4qFgw9oC7iBCBQwaWW4jqEuVUuhTsl4VJcpekQorENP
   Q==;
X-CSE-ConnectionGUID: 81mWKXYqROmegobFlN+phQ==
X-CSE-MsgGUID: bR3IOm0xTtu6Ka+zEKsjLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="82301075"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="82301075"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 14:00:54 -0700
X-CSE-ConnectionGUID: uAz0o5e+Tq26Lt4eyR9i/w==
X-CSE-MsgGUID: +PQz5pgZTtaRbUJK04fh9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="229779638"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 Apr 2026 14:00:52 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIC1Z-00000000BXU-0BDb;
	Wed, 29 Apr 2026 21:00:49 +0000
Date: Thu, 30 Apr 2026 05:00:15 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 122/169] include/asm-generic/fixmap.h:77:9:
 error: implicit declaration of function '__set_fixmap'; did you mean
 'set_fixmap'?
Message-ID: <202604300401.oBmk76Q3-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 4fee62a8f7a8a78b1e36d2b5a7a2030b18cccd56 [122/169] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: csky-allmodconfig (https://download.01.org/0day-ci/archive/20260430/202604300401.oBmk76Q3-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300401.oBmk76Q3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300401.oBmk76Q3-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/csky/include/asm/fixmap.h:27,
                    from arch/csky/include/asm/pgtable.h:6,
                    from include/linux/pgtable.h:6,
                    from arch/csky/include/asm/io.h:6,
                    from include/linux/io.h:12,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/csky/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from include/linux/kernel_stat.h:8,
                    from arch/csky/kernel/asm-offsets.c:6:
   include/asm-generic/fixmap.h: In function '__set_fixmap_offset':
>> include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
      77 |         __set_fixmap(idx, phys, flags);
         |         ^~~~~~~~~~~~
         |         set_fixmap
   include/asm-generic/fixmap.h: In function 'set_fixmap_offset':
   include/asm-generic/fixmap.h:48:28: error: 'PAGE_KERNEL' undeclared (first use in this function); did you mean 'SI_KERNEL'?
      48 | #define FIXMAP_PAGE_NORMAL PAGE_KERNEL
         |                            ^~~~~~~~~~~
   include/asm-generic/fixmap.h:84:47: note: in expansion of macro 'FIXMAP_PAGE_NORMAL'
      84 |         return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
         |                                               ^~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:48:28: note: each undeclared identifier is reported only once for each function it appears in
      48 | #define FIXMAP_PAGE_NORMAL PAGE_KERNEL
         |                            ^~~~~~~~~~~
   include/asm-generic/fixmap.h:84:47: note: in expansion of macro 'FIXMAP_PAGE_NORMAL'
      84 |         return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
         |                                               ^~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h: In function 'set_fixmap_nocache':
   include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:93:33: note: in expansion of macro 'FIXMAP_PAGE_NOCACHE'
      93 |         __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                 ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h: In function 'set_fixmap_offset_nocache':
   include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:99:40: note: in expansion of macro 'FIXMAP_PAGE_NOCACHE'
      99 |         __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                        ^~~~~~~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:184: arch/csky/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1373: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +77 include/asm-generic/fixmap.h

    72	
    73	/* Return a pointer with offset calculated */
    74	static inline unsigned long
    75	__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
    76	{
  > 77		__set_fixmap(idx, phys, flags);
    78		return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
    79	}
    80	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
