Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D388248D868
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 10:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789639275; cv=none; b=LoQZhVrIfBKJ3AU70sqjoqxIHjbaxujdGC1ZcQVe0LTuZUdG4qH/gtDFKbQsAzhpftDLs/I5Ss97WMKpo1XEXWF/fSMoIEraRuKhtCRyrl8wO5l//On/ckkK75JJonfIc7Bxu1baZRFk4/BAQ/25eH9cv29dPoNgqcKZhayzrrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789639275; c=relaxed/simple;
	bh=G86fEbZZ8M9TDNk+OBuP7P6MWjysS3e6TLD6IPKJWQs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=I+Q2/Ub2AolSOwVvY4BSO9AwT+4mycZbTTJ0nA2b6R0r89p1A2D8pFnq4S1oirln6MMjxLPvCXAWMxZO4x+GJ6lZHbc9ZeO9K6cP4sSpWn+1q3bD+3dprM4x6oEMpUGJBTPmZEkt5n2kOC9QQI4DT9g2vw+UFS2/VIQyG0SKbWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HRipIH6V; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HRipIH6V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789639265; x=1821175265;
  h=date:from:to:cc:subject:message-id;
  bh=G86fEbZZ8M9TDNk+OBuP7P6MWjysS3e6TLD6IPKJWQs=;
  b=HRipIH6VbqSB3QUyhKnPg/wJvvNSYh23DspL39yAmlnpxszlP4Aw5C4A
   Mei43EDb/9gLm58TNHVdyFrKwltAHIKfVmdu19xL0dcK95IdpZ7LrlpSi
   GNasf00A6EUAFDcQ1bjkqIWTmI+2S+qnLfmN1MctB1Gl4YQ6LrEbrzRHT
   g9l5h1XWqMxobDKMc5yNwIswMJCOqZvreP2JGJtQf3mt68uli1nPq/psE
   tzLdImK36PgyX5mUiL+7x2jyPUakDz/EIai6MBHvjbAAZ99T29o8Uv1c+
   JyiBbwpQob2UJ+NPW83Z6HdR2eECHxO8M04HVD0iaU0ZWZ8pH7KZU1kg1
   g==;
X-CSE-ConnectionGUID: GmuRZ278QMO6HDO/m3ayyw==
X-CSE-MsgGUID: U0N4dgUOTpK8O2/t2mshBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93872001"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93872001"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 03:01:00 -0700
X-CSE-ConnectionGUID: VyIWqTzPT62dF+DjZodYpw==
X-CSE-MsgGUID: Sfn3PMQxSEKvWxd+1ff2iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="275642088"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 17 Sep 2026 03:00:58 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x78vH-000000007Y9-32kR;
	Thu, 17 Sep 2026 10:00:55 +0000
Date: Thu, 17 Sep 2026 18:00:02 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
Message-ID: <202609171758.049ApqPm-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com

    fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-1014-20260917
    |-- fs-proc-task_mmu.c:error:call-to-undeclared-function-drop_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations
    `-- fs-proc-task_mmu.c:error:call-to-undeclared-function-reacquire_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations

elapsed time: m

configs tested: 238
configs skipped: 7

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260917    gcc-8.5.0
arc                   randconfig-1001-20260917    gcc-15.2.0
arc                  randconfig-r1300-20260917    gcc-12.5.0 sparse
arc                         vdk_hs38_defconfig    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    gcc-16.1.0
arm                        aspeed_g5_defconfig    gcc-16.1.0
arm                         clps711x_defconfig    clang-24
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                       integrator_defconfig    clang-24
arm                              pxa_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260917    gcc-8.5.0
arm                   randconfig-1001-20260917    gcc-8.5.0
arm                   randconfig-1002-20260917    clang-17
arm                   randconfig-1003-20260917    gcc-8.5.0
arm                          s5pv210_defconfig    clang-24
arm                            tegra_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260917    gcc-8.5.0
arm64                 randconfig-1001-20260917    gcc-8.5.0
arm64                 randconfig-1002-20260917    clang-24
arm64                 randconfig-1003-20260917    clang-17
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260917    gcc-9.5.0
csky                  randconfig-1001-20260917    gcc-11.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260917    clang-20
hexagon               randconfig-1001-20260917    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260917    clang-22
i386        buildonly-randconfig-1000-20260917    gcc-13
i386        buildonly-randconfig-1001-20260917    gcc-13
i386        buildonly-randconfig-1002-20260917    gcc-13
i386        buildonly-randconfig-1002-20260917    gcc-14
i386        buildonly-randconfig-1003-20260917    clang-22
i386        buildonly-randconfig-1003-20260917    gcc-13
i386        buildonly-randconfig-1004-20260917    clang-22
i386        buildonly-randconfig-1004-20260917    gcc-13
i386        buildonly-randconfig-1005-20260917    clang-22
i386        buildonly-randconfig-1005-20260917    gcc-13
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260917    clang-22
i386                  randconfig-1001-20260917    clang-22
i386                  randconfig-1002-20260917    clang-22
i386                  randconfig-1003-20260917    clang-22
i386                  randconfig-1003-20260917    gcc-14
i386                  randconfig-1004-20260917    clang-22
i386                  randconfig-1005-20260917    clang-22
i386                  randconfig-1006-20260917    clang-22
i386                  randconfig-1007-20260917    clang-22
i386                  randconfig-1007-20260917    gcc-13
i386                  randconfig-1008-20260917    clang-22
i386                  randconfig-1009-20260917    clang-22
i386                  randconfig-1010-20260917    clang-22
i386                  randconfig-1011-20260917    clang-22
i386                  randconfig-1011-20260917    gcc-14
i386                  randconfig-1012-20260917    clang-22
i386                  randconfig-1012-20260917    gcc-12
i386                  randconfig-1013-20260917    clang-22
i386                  randconfig-1300-20260917    gcc-14     sparse
i386                  randconfig-1301-20260917    gcc-14     sparse
i386                  randconfig-1302-20260917    gcc-12     sparse
i386                  randconfig-1302-20260917    gcc-14     sparse
i386                 randconfig-r1305-20260917    clang-22   sparse
i386                 randconfig-r1306-20260917    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260917    clang-24
loongarch             randconfig-1001-20260917    clang-24
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       bmips_stb_defconfig    clang-17
mips                            gcw0_defconfig    clang-24
mips                         omega2p_defconfig    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260917    gcc-11.5.0
nios2                 randconfig-1001-20260917    gcc-11.5.0
nios2                randconfig-r1307-20260917    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260917    gcc-11.5.0
parisc                randconfig-1001-20260917    gcc-9.5.0
parisc               randconfig-r1309-20260917    gcc-16.1.0 sparse
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                        ebony_defconfig    clang-24
powerpc                           g5_defconfig    clang-24
powerpc               randconfig-1000-20260917    clang-24
powerpc               randconfig-1001-20260917    clang-24
powerpc              randconfig-r1308-20260917    clang-24   sparse
powerpc64             randconfig-1000-20260917    clang-24
powerpc64             randconfig-1001-20260917    clang-22
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv              nommu_k210_sdcard_defconfig    clang-24
riscv                 randconfig-1000-20260917    gcc-16.1.0
riscv                 randconfig-1001-20260917    clang-17
riscv                randconfig-r1303-20260917    gcc-14.3.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260917    clang-17
s390                  randconfig-1001-20260917    clang-20
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260917    gcc-16.1.0
sh                    randconfig-1001-20260917    gcc-11.5.0
sh                   randconfig-r1302-20260917    gcc-11.5.0 sparse
sh                            se7750_defconfig    clang-24
sh                   sh7785lcr_32bit_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260917    clang-17
sparc                 randconfig-1000-20260917    gcc-8.5.0
sparc                 randconfig-1001-20260917    clang-17
sparc                 randconfig-1001-20260917    gcc-15.2.0
sparc                randconfig-r1301-20260917    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260917    clang-17
sparc64               randconfig-1000-20260917    clang-24
sparc64               randconfig-1001-20260917    clang-17
sparc64               randconfig-1001-20260917    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260917    clang-17
um                    randconfig-1000-20260917    gcc-14
um                    randconfig-1001-20260917    clang-17
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260917    gcc-13
x86_64      buildonly-randconfig-1000-20260917    gcc-14
x86_64      buildonly-randconfig-1001-20260917    gcc-14
x86_64      buildonly-randconfig-1002-20260917    gcc-14
x86_64      buildonly-randconfig-1003-20260917    gcc-14
x86_64      buildonly-randconfig-1004-20260917    gcc-14
x86_64      buildonly-randconfig-1005-20260917    clang-22
x86_64      buildonly-randconfig-1005-20260917    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260917    clang-22
x86_64                randconfig-1000-20260917    gcc-14
x86_64                randconfig-1001-20260917    clang-22
x86_64                randconfig-1002-20260917    clang-22
x86_64                randconfig-1002-20260917    gcc-14
x86_64                randconfig-1003-20260917    clang-22
x86_64                randconfig-1004-20260917    clang-22
x86_64                randconfig-1004-20260917    gcc-14
x86_64                randconfig-1005-20260917    clang-22
x86_64                randconfig-1005-20260917    gcc-14
x86_64                randconfig-1006-20260917    gcc-14
x86_64                randconfig-1007-20260917    gcc-14
x86_64                randconfig-1008-20260917    gcc-14
x86_64                randconfig-1009-20260917    clang-22
x86_64                randconfig-1010-20260917    clang-22
x86_64                randconfig-1011-20260917    gcc-14
x86_64                randconfig-1012-20260917    clang-22
x86_64                randconfig-1012-20260917    gcc-14
x86_64                randconfig-1013-20260917    clang-22
x86_64                randconfig-1013-20260917    gcc-14
x86_64                randconfig-1014-20260917    clang-22
x86_64                randconfig-1015-20260917    clang-22
x86_64                randconfig-1016-20260917    clang-22
x86_64                randconfig-1017-20260917    clang-22
x86_64                randconfig-1300-20260917    clang-22   sparse
x86_64                randconfig-1300-20260917    gcc-14     sparse
x86_64                randconfig-1301-20260917    gcc-14     sparse
x86_64                randconfig-1302-20260917    gcc-14     sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260917    clang-17
xtensa                randconfig-1000-20260917    gcc-8.5.0
xtensa                randconfig-1001-20260917    clang-17
xtensa                randconfig-1001-20260917    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
