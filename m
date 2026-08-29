Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C7A12CDA5
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 04:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787977573; cv=none; b=cwihs02mSKJ0ooHASHZGwlLLEaWNVMF2mJTK5Glyg8UbR1GzGhcPSbMHe5QsnMDDx0JrpfUWGivOXRc4/DM0YLVaZecNbZJCvG4V42RpmMIpo/JvigtKxopOsK7ogtBEdxls9q9Za6iGEwJDDbkrptuOjCZ41xkv0sYKlExIurw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787977573; c=relaxed/simple;
	bh=osy4uTCsiN3URvtsQXKWIiu+SdzwYiN2rStibqB6GxM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=qCOCBhx+Y/tajmgdihqQl//aiqlbYNX1NI/lkZP9ar2XRs20d2l+r4oWk8HtJ/xvKiIMPk38jGTE2kKey0pEadTP2VkVBY1J/IzvAGlEw1ixjEm0y2fHDRfIgpqfUyddjluF1DI0G88frd0CWAxBQV/jlskJdnyUXlUsShTPOBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/0uBMLQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/0uBMLQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787977570; x=1819513570;
  h=date:from:to:cc:subject:message-id;
  bh=osy4uTCsiN3URvtsQXKWIiu+SdzwYiN2rStibqB6GxM=;
  b=g/0uBMLQtjXo8NxPXkx9JcVF8GlsKVLV8hqFQHCbY54lRfrIH/lD2QNa
   r/iV+2V+fPYYB8Aj61kWFpPK1BlP3usKi3O6nqW3FCUNhI3Gop7JLgXql
   XjndHYooYb4ojIBCrY/L/N8SNQVCQThujYXsxpFU+JQ1s8utqTjMGQyLE
   A84RqEdcTBM+JokOdGp0Ipx8dd6xdGXewVllLmrLEH2l+g/KPQQ7y/5m2
   IjQAHjUhmZXPlLfRy+MvtLXRqZK5T8D8I20ALqFKj7sgyhzDiJ7UeAVDs
   YJv56tiF2rUBmYdFGUWA2qC4Jj2GESsMzsWuXLKQuyIqv6xm60B/WLmBD
   w==;
X-CSE-ConnectionGUID: z6/BE0giR0CtXChDP2nK6g==
X-CSE-MsgGUID: TiMWRfaTQ7W/rjD/yO7yTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="105857054"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="105857054"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 21:26:10 -0700
X-CSE-ConnectionGUID: cwlDOAQxSvKgwpckCjNCiQ==
X-CSE-MsgGUID: ljDTGcmITyydJ652Ewl4cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="293140226"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 28 Aug 2026 21:26:07 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0Adp-00000000CNA-2Jbe;
	Sat, 29 Aug 2026 04:26:05 +0000
Date: Sat, 29 Aug 2026 12:25:51 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
Message-ID: <202608291234.wlX3byr7-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 830m

configs tested: 163
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                     nsimosci_hs_defconfig    gcc-16.1.0
arc                   randconfig-001-20260829    clang-18
arc                   randconfig-001-20260829    gcc-8.5.0
arc                   randconfig-002-20260829    clang-18
arc                   randconfig-002-20260829    gcc-11.5.0
arc                        vdk_hs38_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                         at91_dt_defconfig    clang-17
arm                                 defconfig    clang-24
arm                             pxa_defconfig    gcc-16.1.0
arm                   randconfig-001-20260829    clang-18
arm                   randconfig-002-20260829    clang-18
arm                   randconfig-003-20260829    clang-18
arm                   randconfig-003-20260829    gcc-8.5.0
arm                   randconfig-004-20260829    clang-18
arm                   randconfig-004-20260829    gcc-8.5.0
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
hexagon                          allmodconfig    clang-24
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-24
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-002-20260828    gcc-14
i386        buildonly-randconfig-003-20260828    clang-22
i386        buildonly-randconfig-004-20260828    clang-22
i386        buildonly-randconfig-005-20260828    clang-22
i386                                defconfig    clang-22
i386                  randconfig-011-20260828    clang-22
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
m68k                       m5329evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                   sb1250_swarm_defconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260828    gcc-9.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260828    gcc-8.5.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260828    gcc-10.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260828    gcc-12.5.0
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260828    gcc-8.5.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260828    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260828    gcc-11.5.0
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260828    gcc-9.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-24
um                    randconfig-001-20260828    clang-24
um                             randconfig-002    clang-24
um                    randconfig-002-20260828    gcc-14
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260828    clang-22
x86_64      buildonly-randconfig-002-20260828    gcc-14
x86_64      buildonly-randconfig-005-20260828    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-003-20260828    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
