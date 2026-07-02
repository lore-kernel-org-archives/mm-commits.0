Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A29381E88
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783006339; cv=none; b=SXM3BzTpwBm/AqeHA9PT4aPPXXtHaei1fH4xRx2TLVuUjiQjwvg5jLM9Ban8sNQ+8RlA+xIOevL9k+ceggbH6jFSDPO5+/6xiBuM3MdeKs9IfWidS1Vhxxm6i3cT3P2xb7VGOjH17vLtd5L0yxF0xuv2Gq/pJOA2Ed7qr3pUhBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783006339; c=relaxed/simple;
	bh=FzMKNRTeO+O41k+fVNRFgURIjMdoyCzap3BQpGqIkVI=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nDsumYmBieEXLhYYjgpUmzlunkD8FmdFuLrWYcqYGySMhO/I6pFTHNEvF9aP/0zIBv63KVLNJLUcQJjXjXa0VcivnOj5XcNst/29TuHwxX1pe+QWG9pA7sOzfhwlls8klqDKyWwvpoagFQkwKGc5V3nLyslFh6Z4q6/KaL83QAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FUUvub7A; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FUUvub7A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783006337; x=1814542337;
  h=date:from:to:cc:subject:message-id;
  bh=FzMKNRTeO+O41k+fVNRFgURIjMdoyCzap3BQpGqIkVI=;
  b=FUUvub7A92H0csbFoNhExGG468C73VKTl4oHNPCnWrb5PvQffTaXccOl
   iwkB1G4Cp+ko7G4wy+R/j6SqdfBGPv/xqcchMOf6JQd7/xLF57ARQ+T2G
   KcABVQJDJShuGgiHf5BrkOejeCQjdndEU05fUNq814QEAL2xXzO3aSBNc
   dCWWDqClj+4MZPPvrbERx6zAmNgHIorB4RZi2r3BkScVk6ca6XLwSBtBN
   xsEIhU/XJz17n1MUKaWmY3MZIUfcUT+1+r+DL9X0mXonDL36BWQr8ErOx
   va9mNNtRAlw0SiVKh0A3V3iekiD37A2jQAnPUtrjS3xqim3A7vhTgGXS8
   w==;
X-CSE-ConnectionGUID: fXK37VvKSV69a6jutrt5Ug==
X-CSE-MsgGUID: 16wVU19YQS2f8yyHArslyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="95268745"
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="95268745"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 08:32:16 -0700
X-CSE-ConnectionGUID: j1SAfSh2RQCW/JqBt9iGlQ==
X-CSE-MsgGUID: P4OqRXb+SEeisYI6AVYBBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="248912358"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2026 08:32:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfJOd-00000000Auh-0luO;
	Thu, 02 Jul 2026 15:32:11 +0000
Date: Thu, 02 Jul 2026 23:31:59 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 f4b4fac1867633ac17c35842f03933f6a7a4425f
Message-ID: <202607022346.lOHuTDpa-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: f4b4fac1867633ac17c35842f03933f6a7a4425f  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com

    mm/vmpressure.c:254 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
`-- microblaze-randconfig-r071-20260702
    `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

elapsed time: 744m

configs tested: 316
configs skipped: 12

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260702    gcc-8.5.0
arc                   randconfig-002-20260702    gcc-13.4.0
arc                   randconfig-002-20260702    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260702    clang-17
arm                   randconfig-001-20260702    gcc-8.5.0
arm                   randconfig-002-20260702    gcc-15.2.0
arm                   randconfig-002-20260702    gcc-8.5.0
arm                   randconfig-003-20260702    gcc-10.5.0
arm                   randconfig-003-20260702    gcc-8.5.0
arm                   randconfig-004-20260702    gcc-8.5.0
arm                        spear6xx_defconfig    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260702    clang-22
arm64                 randconfig-001-20260702    gcc-15.2.0
arm64                 randconfig-002-20260702    gcc-15.2.0
arm64                 randconfig-002-20260702    gcc-8.5.0
arm64                 randconfig-003-20260702    gcc-15.2.0
arm64                 randconfig-004-20260702    clang-17
arm64                 randconfig-004-20260702    gcc-15.2.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260702    gcc-15.2.0
csky                  randconfig-001-20260702    gcc-9.5.0
csky                  randconfig-002-20260702    gcc-15.2.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260702    clang-19
hexagon               randconfig-001-20260702    clang-23
hexagon               randconfig-001-20260702    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260702    clang-20
hexagon               randconfig-002-20260702    clang-23
hexagon               randconfig-002-20260702    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-22
i386        buildonly-randconfig-001-20260702    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260702    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260702    clang-22
i386                 buildonly-randconfig-004    clang-22
i386        buildonly-randconfig-004-20260702    clang-22
i386                 buildonly-randconfig-005    clang-22
i386        buildonly-randconfig-005-20260702    clang-22
i386                 buildonly-randconfig-006    clang-22
i386        buildonly-randconfig-006-20260702    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260702    clang-22
i386                  randconfig-001-20260702    gcc-14
i386                  randconfig-002-20260702    clang-22
i386                  randconfig-002-20260702    gcc-14
i386                  randconfig-003-20260702    gcc-14
i386                  randconfig-004-20260702    clang-22
i386                  randconfig-004-20260702    gcc-14
i386                  randconfig-005-20260702    gcc-14
i386                  randconfig-006-20260702    gcc-14
i386                  randconfig-007-20260702    gcc-14
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260702    clang-22
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260702    clang-22
i386                  randconfig-012-20260702    gcc-13
i386                           randconfig-013    clang-22
i386                  randconfig-013-20260702    clang-22
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260702    clang-22
i386                           randconfig-015    clang-22
i386                  randconfig-015-20260702    clang-22
i386                           randconfig-016    clang-22
i386                  randconfig-016-20260702    clang-22
i386                  randconfig-016-20260702    gcc-14
i386                           randconfig-017    clang-22
i386                  randconfig-017-20260702    clang-22
i386                  randconfig-017-20260702    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260702    clang-23
loongarch             randconfig-001-20260702    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260702    clang-23
loongarch             randconfig-002-20260702    gcc-11.5.0
loongarch             randconfig-002-20260702    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                       m5329evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                           ci20_defconfig    clang-23
mips                        omega2p_defconfig    clang-17
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260702    clang-23
nios2                 randconfig-001-20260702    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260702    clang-23
nios2                 randconfig-002-20260702    gcc-11.5.0
nios2                 randconfig-002-20260702    gcc-8.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    clang-17
parisc                randconfig-001-20260702    clang-17
parisc                randconfig-001-20260702    gcc-10.5.0
parisc                         randconfig-002    clang-17
parisc                randconfig-002-20260702    clang-17
parisc                randconfig-002-20260702    gcc-12.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-17
powerpc               randconfig-001-20260702    clang-17
powerpc                        randconfig-002    clang-17
powerpc               randconfig-002-20260702    clang-17
powerpc               randconfig-002-20260702    gcc-8.5.0
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260702    clang-17
powerpc64             randconfig-001-20260702    gcc-15.2.0
powerpc64                      randconfig-002    clang-17
powerpc64             randconfig-002-20260702    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-12.5.0
riscv                 randconfig-001-20260702    gcc-12.5.0
riscv                 randconfig-001-20260702    gcc-15.2.0
riscv                          randconfig-002    gcc-12.5.0
riscv                 randconfig-002-20260702    clang-23
riscv                 randconfig-002-20260702    gcc-12.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-12.5.0
s390                  randconfig-001-20260702    clang-23
s390                  randconfig-001-20260702    gcc-12.5.0
s390                           randconfig-002    gcc-12.5.0
s390                  randconfig-002-20260702    gcc-12.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-12.5.0
sh                    randconfig-001-20260702    gcc-12.5.0
sh                    randconfig-001-20260702    gcc-16.1.0
sh                             randconfig-002    gcc-12.5.0
sh                    randconfig-002-20260702    gcc-12.5.0
sh                    randconfig-002-20260702    gcc-15.2.0
sh                           se7619_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260702    gcc-16.1.0
sparc                          randconfig-002    gcc-16.1.0
sparc                 randconfig-002-20260702    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-16.1.0
sparc64               randconfig-001-20260702    clang-23
sparc64               randconfig-001-20260702    gcc-16.1.0
sparc64                        randconfig-002    gcc-16.1.0
sparc64               randconfig-002-20260702    gcc-10.5.0
sparc64               randconfig-002-20260702    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-16.1.0
um                    randconfig-001-20260702    gcc-14
um                    randconfig-001-20260702    gcc-16.1.0
um                             randconfig-002    gcc-16.1.0
um                    randconfig-002-20260702    gcc-14
um                    randconfig-002-20260702    gcc-16.1.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260702    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260702    clang-22
x86_64      buildonly-randconfig-002-20260702    gcc-14
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260702    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260702    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260702    clang-22
x86_64      buildonly-randconfig-005-20260702    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260702    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260702    clang-22
x86_64                randconfig-002-20260702    clang-22
x86_64                randconfig-002-20260702    gcc-14
x86_64                randconfig-003-20260702    clang-22
x86_64                randconfig-004-20260702    clang-22
x86_64                randconfig-004-20260702    gcc-14
x86_64                randconfig-005-20260702    clang-22
x86_64                randconfig-006-20260702    clang-22
x86_64                randconfig-006-20260702    gcc-14
x86_64                randconfig-011-20260702    clang-22
x86_64                randconfig-011-20260702    gcc-14
x86_64                randconfig-012-20260702    clang-22
x86_64                randconfig-012-20260702    gcc-14
x86_64                randconfig-013-20260702    clang-22
x86_64                randconfig-014-20260702    clang-22
x86_64                randconfig-014-20260702    gcc-12
x86_64                randconfig-015-20260702    clang-22
x86_64                randconfig-015-20260702    gcc-14
x86_64                randconfig-016-20260702    clang-22
x86_64                         randconfig-071    clang-22
x86_64                randconfig-071-20260702    clang-22
x86_64                randconfig-071-20260702    gcc-14
x86_64                         randconfig-072    clang-22
x86_64                randconfig-072-20260702    clang-22
x86_64                randconfig-072-20260702    gcc-14
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260702    clang-22
x86_64                         randconfig-074    clang-22
x86_64                randconfig-074-20260702    clang-22
x86_64                randconfig-074-20260702    gcc-12
x86_64                         randconfig-075    clang-22
x86_64                randconfig-075-20260702    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260702    clang-22
x86_64                randconfig-076-20260702    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-16.1.0
xtensa                randconfig-001-20260702    gcc-16.1.0
xtensa                         randconfig-002    gcc-16.1.0
xtensa                randconfig-002-20260702    gcc-14.3.0
xtensa                randconfig-002-20260702    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
