Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F06431E58
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782934457; cv=none; b=fGxuiwadbszOZORQSGliz6rJJHUoKW4Hb3mrj8mmAikXMde/2UEM/lz9oHSfEFz1SfFdcIQn0CUNI5WTwQY99e8hZw1EGypcvXy8ETBQj/fMhGSCOMz9DshCKdAtLfHj6dU5IPWR4XUVVM81PfTfPqFIxJD4O+fPwNcoEuZVxAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782934457; c=relaxed/simple;
	bh=xbqDp0XN+gMQ5BKfMQX92sRSi+F1YXzvvdCrWtXduEc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=teICH7bbfBw7C/1/BDEfYZovwYCaICA7p6PccUPAjCIYArbfgemoAMjkxCTld9Hnt3Q4aGZ4v7SkPtdfOTvbxaIrtHiNSEeOApBeEs8/gJjJx1Qp6PuSq6DHOsT8OsDbGvDLOr91raxWX3TFh8fjTsmJyU1r16Qg3ODdmnPsoFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gy7Xnau9; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gy7Xnau9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782934455; x=1814470455;
  h=date:from:to:cc:subject:message-id;
  bh=xbqDp0XN+gMQ5BKfMQX92sRSi+F1YXzvvdCrWtXduEc=;
  b=gy7Xnau9UXFULw1VqH9HNcjUYRJ6b+Dl2QNM2ieJ7YFyignfu5ZmpDG+
   vCq4cw62fjvr5RW5rYLBU6G2FtKf9xZUX/YQGovf9HvBLHgGY8CfJ8gMt
   659otdfoq3ISI1bernr+gYq8x32nESF/+EmVYFdn6rbDAcQucoP1htJcL
   cCfbi5Q1zqVk42RC5Iq+2pNaPtcsKcpfNzW66CeQR0C14ns9SkE4DaeE7
   kGZk01lAiuGGv0IPo8mc9RhV+Q6InB8EBEDeMsOKw0tHzpdfXh98Wal6n
   T9kUyLNSHqK6xPDwTXqQ3PL5iZLSRAwEvNL0iYpoe0KShiwupkFNzWspK
   g==;
X-CSE-ConnectionGUID: unXfzGarQnqZ3Yw6xLRamA==
X-CSE-MsgGUID: oCpLaK/LRMObJ3PkKAOJJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="83766040"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="83766040"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 12:34:14 -0700
X-CSE-ConnectionGUID: oaX4V9tfTH62j7ztRSAwfQ==
X-CSE-MsgGUID: V4gLh8ukTAmUmM1MXE5VMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="256237997"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 01 Jul 2026 12:34:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wf0hG-000000009ZP-0F41;
	Wed, 01 Jul 2026 19:34:10 +0000
Date: Thu, 02 Jul 2026 03:33:13 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 f5ea2fbe68e0c9192c0c82ece4645beeace63345
Message-ID: <202607020359.FMDmPwjF-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: f5ea2fbe68e0c9192c0c82ece4645beeace63345  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com

    mm/zsmalloc.c:1480:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-002-20260701
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- arc-randconfig-r123-20260701
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-randconfig-003-20260701
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- m68k-defconfig
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- powerpc-randconfig-001
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
`-- um-randconfig-001-20260701
    `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used

elapsed time: 779m

configs tested: 322
configs skipped: 16

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
arc                         haps_hs_defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-001-20260701    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260701    gcc-12.5.0
arc                   randconfig-002-20260701    gcc-16.1.0
arc                   randconfig-002-20260701    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260701    gcc-10.5.0
arm                   randconfig-001-20260701    gcc-12.5.0
arm                   randconfig-001-20260701    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260701    clang-17
arm                   randconfig-002-20260701    gcc-12.5.0
arm                   randconfig-002-20260701    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260701    gcc-10.5.0
arm                   randconfig-003-20260701    gcc-12.5.0
arm                   randconfig-003-20260701    gcc-16.1.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260701    clang-23
arm                   randconfig-004-20260701    gcc-12.5.0
arm                   randconfig-004-20260701    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260701    gcc-12.5.0
arm64                 randconfig-001-20260701    gcc-16.1.0
arm64                 randconfig-002-20260701    clang-17
arm64                 randconfig-002-20260701    gcc-12.5.0
arm64                 randconfig-003-20260701    gcc-12.5.0
arm64                 randconfig-004-20260701    clang-17
arm64                 randconfig-004-20260701    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260701    gcc-10.5.0
csky                  randconfig-001-20260701    gcc-12.5.0
csky                  randconfig-002-20260701    gcc-12.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260701    clang-23
hexagon               randconfig-001-20260701    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260701    clang-17
hexagon               randconfig-002-20260701    clang-23
hexagon               randconfig-002-20260701    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260701    clang-22
i386        buildonly-randconfig-002-20260701    clang-22
i386        buildonly-randconfig-003-20260701    clang-22
i386        buildonly-randconfig-003-20260701    gcc-14
i386        buildonly-randconfig-004-20260701    clang-22
i386        buildonly-randconfig-004-20260701    gcc-13
i386        buildonly-randconfig-005-20260701    clang-22
i386        buildonly-randconfig-006-20260701    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260701    clang-22
i386                           randconfig-002    clang-22
i386                  randconfig-002-20260701    clang-22
i386                           randconfig-003    clang-22
i386                  randconfig-003-20260701    clang-22
i386                  randconfig-003-20260701    gcc-14
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260701    clang-22
i386                           randconfig-005    clang-22
i386                  randconfig-005-20260701    clang-22
i386                           randconfig-006    clang-22
i386                  randconfig-006-20260701    clang-22
i386                           randconfig-007    clang-22
i386                  randconfig-007-20260701    clang-22
i386                  randconfig-011-20260701    gcc-14
i386                  randconfig-012-20260701    gcc-12
i386                  randconfig-012-20260701    gcc-14
i386                  randconfig-013-20260701    clang-22
i386                  randconfig-013-20260701    gcc-14
i386                  randconfig-014-20260701    gcc-14
i386                  randconfig-015-20260701    clang-22
i386                  randconfig-015-20260701    gcc-14
i386                  randconfig-016-20260701    clang-22
i386                  randconfig-016-20260701    gcc-14
i386                  randconfig-017-20260701    clang-22
i386                  randconfig-017-20260701    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260701    clang-23
loongarch             randconfig-001-20260701    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260701    clang-19
loongarch             randconfig-002-20260701    clang-23
loongarch             randconfig-002-20260701    gcc-11.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                         3c120_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260701    clang-23
nios2                 randconfig-001-20260701    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260701    clang-23
nios2                 randconfig-002-20260701    gcc-11.5.0
nios2                 randconfig-002-20260701    gcc-8.5.0
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
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260701    clang-17
parisc                randconfig-001-20260701    gcc-13.4.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260701    clang-17
parisc                randconfig-002-20260701    gcc-15.2.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260701    clang-17
powerpc               randconfig-001-20260701    gcc-8.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260701    clang-17
powerpc               randconfig-002-20260701    clang-23
powerpc                     redwood_defconfig    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260701    clang-17
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260701    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-13.4.0
riscv                 randconfig-001-20260701    clang-17
riscv                 randconfig-001-20260701    clang-23
riscv                          randconfig-002    clang-17
riscv                 randconfig-002-20260701    clang-23
riscv                 randconfig-002-20260701    gcc-14.3.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-15.2.0
s390                  randconfig-001-20260701    clang-23
s390                           randconfig-002    clang-18
s390                  randconfig-002-20260701    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-14.3.0
sh                    randconfig-001-20260701    clang-23
sh                    randconfig-001-20260701    gcc-10.5.0
sh                             randconfig-002    gcc-9.5.0
sh                    randconfig-002-20260701    clang-23
sh                    randconfig-002-20260701    gcc-16.1.0
sh                           se7750_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260701    gcc-13.4.0
sparc                 randconfig-001-20260701    gcc-8.5.0
sparc                 randconfig-002-20260701    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260701    gcc-13.4.0
sparc64               randconfig-001-20260701    gcc-8.5.0
sparc64               randconfig-002-20260701    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260701    gcc-13.4.0
um                    randconfig-001-20260701    gcc-14
um                    randconfig-002-20260701    clang-23
um                    randconfig-002-20260701    gcc-13.4.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260701    clang-22
x86_64      buildonly-randconfig-001-20260701    gcc-14
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260701    clang-22
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260701    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260701    clang-22
x86_64      buildonly-randconfig-004-20260701    gcc-14
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260701    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260701    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260701    clang-22
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260701    clang-22
x86_64                randconfig-002-20260701    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260701    clang-22
x86_64                randconfig-003-20260701    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260701    clang-22
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260701    clang-22
x86_64                randconfig-005-20260701    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260701    clang-22
x86_64                randconfig-006-20260701    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260701    clang-22
x86_64                randconfig-011-20260701    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260701    clang-22
x86_64                randconfig-012-20260701    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260701    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260701    clang-22
x86_64                randconfig-014-20260701    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260701    clang-22
x86_64                randconfig-015-20260701    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260701    clang-22
x86_64                randconfig-016-20260701    gcc-14
x86_64                randconfig-071-20260701    clang-22
x86_64                randconfig-071-20260701    gcc-14
x86_64                randconfig-072-20260701    gcc-13
x86_64                randconfig-072-20260701    gcc-14
x86_64                randconfig-073-20260701    clang-22
x86_64                randconfig-073-20260701    gcc-14
x86_64                randconfig-074-20260701    clang-22
x86_64                randconfig-074-20260701    gcc-14
x86_64                randconfig-075-20260701    gcc-14
x86_64                randconfig-076-20260701    clang-22
x86_64                randconfig-076-20260701    gcc-14
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
xtensa                randconfig-001-20260701    gcc-13.4.0
xtensa                randconfig-001-20260701    gcc-8.5.0
xtensa                randconfig-002-20260701    gcc-13.4.0
xtensa                randconfig-002-20260701    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
