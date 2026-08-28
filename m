Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93569442386
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 11:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787917888; cv=none; b=JpMNfZLcAj6oaCSEt/bNhF9tWN6z0x1PezF+kGS6Vc1ScnH/y3ARlq5FrufxQHbTnQOBTajWK0HKJL6xuniL1eOcV0J9RO9phiDUSMBWiXMBnjy79jkHHAw0+iBYDWKq4MSE06qR78NwgHFpQqEZo7pEFRgWpKEwzIjAXqd1qh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787917888; c=relaxed/simple;
	bh=XNx9+dFujD5edMjpBTYsyZXqqE4kmavHmMsu+iY+Eo4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=pTZFpfxtPsRPpxbvy3NYA6ZrLO82i3owaavK8tvq5FljDeWh72Y32IclWg2GqgGUkeLNCBy7f67hv+dpb5ptBvTnxQUEV6wk2PHivVJKbW70fpTw4FWJxguE26dPjukdet5GPYbdsqYP7JLfc1FvRQ7DvqczA4p4M0fZ05plACc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GUZYOu0+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GUZYOu0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787917876; x=1819453876;
  h=date:from:to:cc:subject:message-id;
  bh=XNx9+dFujD5edMjpBTYsyZXqqE4kmavHmMsu+iY+Eo4=;
  b=GUZYOu0+ETE3VycnZV8/WKqadh7JYV3P0fdCjWBYvomHBVk73Xmao39O
   8r3nOktUtgT19VTbNKCRzwFn2yLKDIUBYeHMHMvehNWKQjI2xi1GiA4q3
   iESvHLFG/7Uttqg3suU5SaR1eK2x/jWJnO/GwvuqPHO+YEvCPK85FECan
   JMLWt2S7YqSvsUvctocvigrPaxxdD4NVcccUUhGXSYPcME06mLR6Asgqm
   bK8DZJS0nhCHgj72TGxTXirAg4R4cQVdUfWYrlVtclKLt/KG/KpC3IjCn
   vr4w0hk6lfEsVXgb7L6ZYnUIN2dd952m0/ySZVB9hPimqm6X+yPT1D0j+
   Q==;
X-CSE-ConnectionGUID: DxTl6QDTRMWHa5kmj9F9lQ==
X-CSE-MsgGUID: hiJHvMg9RwOx1/JL9T/8TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88630413"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="88630413"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 04:51:12 -0700
X-CSE-ConnectionGUID: HibPXRyPTWqzJ4Znle0WoQ==
X-CSE-MsgGUID: BaLLlXDsSO2O+s1WNHRuug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291625018"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 28 Aug 2026 04:51:10 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzv6x-00000000B0r-2LB8;
	Fri, 28 Aug 2026 11:51:07 +0000
Date: Fri, 28 Aug 2026 19:50:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 dde94c26af59f5020adafafa08ece21ccd32590b
Message-ID: <202608281932.pzdpjrt8-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: dde94c26af59f5020adafafa08ece21ccd32590b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1439m

configs tested: 407
configs skipped: 22

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-14
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-14
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                        nsim_700_defconfig    gcc-16.1.0
arc                     nsimosci_hs_defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260827    gcc-11.5.0
arc                   randconfig-001-20260828    clang-17
arc                   randconfig-001-20260828    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260827    gcc-13.4.0
arc                   randconfig-002-20260828    clang-17
arc                   randconfig-002-20260828    gcc-16.1.0
arc                        vdk_hs38_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-14
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                       aspeed_g5_defconfig    gcc-16.1.0
arm                         at91_dt_defconfig    gcc-16.1.0
arm                         axm55xx_defconfig    gcc-16.1.0
arm                          collie_defconfig    gcc-16.1.0
arm                                 defconfig    clang-14
arm                                 defconfig    gcc-16.1.0
arm                          ixp4xx_defconfig    gcc-16.1.0
arm                            mmp2_defconfig    gcc-16.1.0
arm                       multi_v4t_defconfig    gcc-16.1.0
arm                        mvebu_v5_defconfig    gcc-16.1.0
arm                        neponset_defconfig    gcc-16.1.0
arm                             pxa_defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260827    clang-14
arm                   randconfig-001-20260828    clang-17
arm                   randconfig-001-20260828    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260827    gcc-15.2.0
arm                   randconfig-002-20260828    clang-17
arm                   randconfig-002-20260828    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260827    gcc-8.5.0
arm                   randconfig-003-20260828    clang-17
arm                   randconfig-003-20260828    gcc-16.1.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260827    gcc-8.5.0
arm                   randconfig-004-20260828    clang-17
arm                   randconfig-004-20260828    gcc-16.1.0
arm                       spear13xx_defconfig    gcc-16.1.0
arm                       versatile_defconfig    gcc-16.1.0
arm                         vf610m4_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-14
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    clang-24
arm64                 randconfig-001-20260827    gcc-8.5.0
arm64                 randconfig-001-20260828    clang-14
arm64                 randconfig-001-20260828    clang-24
arm64                          randconfig-002    clang-24
arm64                 randconfig-002-20260827    gcc-9.5.0
arm64                 randconfig-002-20260828    clang-14
arm64                 randconfig-002-20260828    clang-24
arm64                          randconfig-003    clang-24
arm64                 randconfig-003-20260828    clang-14
arm64                 randconfig-003-20260828    clang-24
arm64                          randconfig-004    clang-24
arm64                 randconfig-004-20260827    gcc-8.5.0
arm64                 randconfig-004-20260828    clang-14
arm64                 randconfig-004-20260828    clang-24
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    clang-24
csky                  randconfig-001-20260827    gcc-9.5.0
csky                  randconfig-001-20260828    clang-14
csky                  randconfig-001-20260828    clang-24
csky                           randconfig-002    clang-24
csky                  randconfig-002-20260827    gcc-15.2.0
csky                  randconfig-002-20260828    clang-14
csky                  randconfig-002-20260828    clang-24
hexagon                          allmodconfig    clang-14
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-14
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-14
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260827    clang-14
hexagon               randconfig-001-20260828    clang-18
hexagon                        randconfig-002    clang-14
hexagon               randconfig-002-20260827    clang-14
hexagon               randconfig-002-20260828    clang-18
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260827    clang-22
i386        buildonly-randconfig-001-20260828    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260827    clang-22
i386        buildonly-randconfig-002-20260828    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260827    clang-22
i386        buildonly-randconfig-003-20260828    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260827    clang-22
i386        buildonly-randconfig-004-20260828    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260827    clang-22
i386        buildonly-randconfig-005-20260828    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260827    clang-22
i386        buildonly-randconfig-006-20260828    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260828    gcc-14
i386                  randconfig-002-20260828    gcc-14
i386                  randconfig-003-20260828    gcc-14
i386                  randconfig-004-20260828    gcc-14
i386                  randconfig-005-20260828    gcc-14
i386                  randconfig-006-20260828    gcc-14
i386                  randconfig-007-20260828    gcc-14
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260827    clang-22
i386                  randconfig-011-20260828    gcc-14
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260827    clang-22
i386                  randconfig-012-20260828    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260827    gcc-14
i386                  randconfig-013-20260828    gcc-14
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260827    gcc-13
i386                  randconfig-014-20260828    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260827    gcc-14
i386                  randconfig-015-20260828    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260827    clang-22
i386                  randconfig-016-20260828    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260827    clang-22
i386                  randconfig-017-20260828    gcc-14
loongarch                        allmodconfig    clang-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-14
loongarch                           defconfig    clang-24
loongarch                loongson32_defconfig    gcc-16.1.0
loongarch                      randconfig-001    clang-14
loongarch             randconfig-001-20260827    clang-22
loongarch             randconfig-001-20260828    clang-18
loongarch                      randconfig-002    gcc-16.1.0
loongarch             randconfig-002-20260827    gcc-16.1.0
loongarch             randconfig-002-20260828    clang-18
m68k                             alldefconfig    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-14
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-14
m68k                                defconfig    clang-24
m68k                       m5329evb_defconfig    gcc-16.1.0
m68k                          multi_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-14
microblaze                          defconfig    clang-24
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                     decstation_defconfig    gcc-16.1.0
mips                     loongson2k_defconfig    gcc-16.1.0
mips                   sb1250_swarm_defconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-14
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-14
nios2                               defconfig    clang-24
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260827    gcc-11.5.0
nios2                 randconfig-001-20260828    clang-18
nios2                          randconfig-002    gcc-8.5.0
nios2                 randconfig-002-20260827    gcc-11.5.0
nios2                 randconfig-002-20260828    clang-18
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-14
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-14
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260827    gcc-14.3.0
parisc                randconfig-001-20260828    gcc-9.5.0
parisc                randconfig-002-20260827    gcc-16.1.0
parisc                randconfig-002-20260828    gcc-9.5.0
parisc64                            defconfig    clang-14
parisc64                            defconfig    clang-24
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-14
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                  iss476-smp_defconfig    gcc-16.1.0
powerpc                   lite5200b_defconfig    gcc-16.1.0
powerpc               randconfig-001-20260827    gcc-13.4.0
powerpc               randconfig-001-20260828    gcc-9.5.0
powerpc               randconfig-002-20260827    clang-17
powerpc               randconfig-002-20260828    gcc-9.5.0
powerpc                        warp_defconfig    gcc-16.1.0
powerpc                         wii_defconfig    gcc-16.1.0
powerpc64             randconfig-001-20260827    gcc-15.2.0
powerpc64             randconfig-001-20260828    gcc-9.5.0
powerpc64             randconfig-002-20260827    gcc-13.4.0
powerpc64             randconfig-002-20260828    gcc-9.5.0
riscv                            allmodconfig    clang-14
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-14
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-14
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-14
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260827    gcc-8.5.0
riscv                 randconfig-001-20260828    clang-17
riscv                 randconfig-002-20260827    clang-14
riscv                 randconfig-002-20260828    clang-17
s390                             allmodconfig    clang-14
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-14
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260827    gcc-10.5.0
s390                  randconfig-001-20260828    clang-17
s390                  randconfig-002-20260827    clang-14
s390                  randconfig-002-20260828    clang-17
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-14
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260827    gcc-13.4.0
sh                    randconfig-001-20260828    clang-17
sh                    randconfig-002-20260827    gcc-11.5.0
sh                    randconfig-002-20260828    clang-17
sh                           se7724_defconfig    gcc-16.1.0
sh                        sh7757lcr_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-14
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260827    gcc-12.5.0
sparc                 randconfig-001-20260828    gcc-9.5.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260827    gcc-8.5.0
sparc                 randconfig-002-20260828    gcc-9.5.0
sparc                       sparc64_defconfig    gcc-16.1.0
sparc64                          alldefconfig    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-14
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260827    clang-20
sparc64               randconfig-001-20260828    gcc-9.5.0
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260827    gcc-8.5.0
sparc64               randconfig-002-20260828    gcc-9.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-14
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-14
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-14
um                    randconfig-001-20260827    clang-14
um                    randconfig-001-20260828    gcc-9.5.0
um                             randconfig-002    clang-14
um                    randconfig-002-20260827    clang-17
um                    randconfig-002-20260828    gcc-9.5.0
um                           x86_64_defconfig    clang-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-14
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260827    gcc-14
x86_64      buildonly-randconfig-001-20260828    gcc-14
x86_64               buildonly-randconfig-002    clang-22
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260827    clang-22
x86_64      buildonly-randconfig-002-20260828    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260827    clang-22
x86_64      buildonly-randconfig-003-20260828    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260827    clang-22
x86_64      buildonly-randconfig-004-20260828    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260827    clang-22
x86_64      buildonly-randconfig-005-20260828    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260827    gcc-14
x86_64      buildonly-randconfig-006-20260828    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260827    clang-22
x86_64                randconfig-001-20260828    gcc-14
x86_64                randconfig-002-20260827    gcc-14
x86_64                randconfig-002-20260828    gcc-14
x86_64                randconfig-003-20260827    gcc-14
x86_64                randconfig-003-20260828    gcc-14
x86_64                randconfig-004-20260827    gcc-14
x86_64                randconfig-004-20260828    gcc-14
x86_64                randconfig-005-20260827    clang-22
x86_64                randconfig-005-20260828    gcc-14
x86_64                randconfig-006-20260827    clang-22
x86_64                randconfig-006-20260828    gcc-14
x86_64                randconfig-011-20260827    gcc-14
x86_64                randconfig-011-20260828    clang-22
x86_64                randconfig-012-20260827    clang-22
x86_64                randconfig-012-20260828    clang-22
x86_64                randconfig-013-20260827    gcc-14
x86_64                randconfig-013-20260828    clang-22
x86_64                randconfig-014-20260827    clang-22
x86_64                randconfig-014-20260828    clang-22
x86_64                randconfig-015-20260827    clang-22
x86_64                randconfig-015-20260828    clang-22
x86_64                randconfig-016-20260827    gcc-12
x86_64                randconfig-016-20260828    clang-22
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260827    gcc-14
x86_64                randconfig-071-20260828    clang-22
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260827    gcc-14
x86_64                randconfig-072-20260828    clang-22
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260827    clang-22
x86_64                randconfig-073-20260828    clang-22
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260827    clang-22
x86_64                randconfig-074-20260828    clang-22
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260827    gcc-14
x86_64                randconfig-075-20260828    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260827    gcc-14
x86_64                randconfig-076-20260828    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-14
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                  audio_kc705_defconfig    gcc-16.1.0
xtensa                  cadence_csp_defconfig    gcc-16.1.0
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                  nommu_kc705_defconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260827    gcc-16.1.0
xtensa                randconfig-001-20260828    gcc-9.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260827    gcc-10.5.0
xtensa                randconfig-002-20260828    gcc-9.5.0
xtensa                    smp_lx200_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
