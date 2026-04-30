Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE593BC675
	for <mm-commits@vger.kernel.org>; Thu, 30 Apr 2026 08:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777537277; cv=none; b=Z4soDkFalV1hmyAShIkeo8tIiihEHUOR/8n2ni+0M5GiFtxXGV1HmBghyJL9krz/WGoISPqA/8c1kHIrjvxLACbjDqk4F/UdUD5Ss4pwuMm+oDDOJHS02Ytx6h38YzXAlkowLbHtNTvPzm0EtqneXl/5In4qDDQvGwdy53Kfs5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777537277; c=relaxed/simple;
	bh=e5YUUbVsBnriYW0nJhxqMMyuRi96qeqhwn8a1WW04IU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Z0mzkYnVQiCMwXFcgtRGZWHg0eRTTd0IPXkF4zlSOsMB1UU0rPNtqwmwqZvRwHJiqOQE9d9ZnG5RRtvrK2oTfE0HddE87Ev4qX4oTFsNFnmEfSfrMId8BbqESEawgyOD+3SJGWhvoIztuGWaB29mUf0numKWdOtnP3n2fjJNmLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DgcT0jk3; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DgcT0jk3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777537272; x=1809073272;
  h=date:from:to:cc:subject:message-id;
  bh=e5YUUbVsBnriYW0nJhxqMMyuRi96qeqhwn8a1WW04IU=;
  b=DgcT0jk3hllYfJxFbYvrHB2vQovXt8o8PucoZKGAwm1KiPviO/D5WRyy
   YzLm4fYiak63PiqBCjL4bgsJbf1r1Qifz4Rit4sOC41CvKG1JyS1+8moT
   ha4mi27YvpgwwnrnpjlC86C07o9K1k1WYuqbC58s88IA1ZNojKzIvcAXt
   JWbENZx+umZrJLu+R2w8f0TFhxUOgXBBOlfwnY/Q6F2bPOJQ+tW/4niM+
   YCaWTsBosvP5b1a6/MH1YHNSnue148bcnwYLtXMlbFcPE6VCONGoU2e0C
   xmR4ScI3uGOg8O+H4ZJM32pOeNfB4d4ZriDfWbbKpA1zuAiQYxEr1Lx69
   w==;
X-CSE-ConnectionGUID: cFRBmTXYSua5UihwlITvCA==
X-CSE-MsgGUID: sraSTpZdT0iOObbyV9WfXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="82344537"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="82344537"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 01:21:05 -0700
X-CSE-ConnectionGUID: 0Yd04r3DRlyvCCWDh1Ezlw==
X-CSE-MsgGUID: xXRWri4BT6W3n6hqr4uiUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="272629444"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 30 Apr 2026 01:21:04 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIMdo-00000000C9c-4AjQ;
	Thu, 30 Apr 2026 08:21:01 +0000
Date: Thu, 30 Apr 2026 16:20:57 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 0587fb0c820d86e5b77a975680d79b5176d09abb
Message-ID: <202604301642.qko6fr77-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0587fb0c820d86e5b77a975680d79b5176d09abb  selftests/mm: add writable-file collapse tests for khugepaged

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202604300401.oBmk76Q3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202604300638.A3yVzhM3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202604300817.QeXlZapz-lkp@intel.com

    arch/riscv/mm/init.c:113:22: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
    arch/riscv/mm/init.c:116:22: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
    arch/sh/include/asm/fixmap.h:82:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
    include/asm-generic/fixmap.h:107:26: error: use of undeclared identifier 'PAGE_KERNEL_IO'
    include/asm-generic/fixmap.h:48:28: error: 'PAGE_KERNEL' undeclared (first use in this function)
    include/asm-generic/fixmap.h:57:24: error: 'PAGE_KERNEL_IO' undeclared (first use in this function)
    include/asm-generic/fixmap.h:77:2: error: call to undeclared function '__set_fixmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    include/asm-generic/fixmap.h:77:2: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Werror=implicit-function-declaration]
    include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Werror=implicit-function-declaration]
    include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
    include/asm-generic/fixmap.h:84:40: error: use of undeclared identifier 'PAGE_KERNEL'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- csky-allmodconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r051-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r113-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-allmodconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-allyesconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-randconfig-r052-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-randconfig-r123-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-xway_defconfig
|   |-- include-asm-generic-fixmap.h:error:call-to-undeclared-function-__set_fixmap-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_IO
|-- riscv-allmodconfig
|   `-- arch-riscv-mm-init.c:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|-- riscv-allyesconfig
|   `-- arch-riscv-mm-init.c:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|-- sh-allmodconfig
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- xtensa-allyesconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- xtensa-randconfig-r051-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- xtensa-randconfig-r112-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
`-- xtensa-randconfig-r122-20260430
    `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap

elapsed time: 796m

configs tested: 160
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260430    gcc-8.5.0
arc                   randconfig-002-20260430    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260430    clang-16
arm                   randconfig-002-20260430    gcc-8.5.0
arm                   randconfig-003-20260430    gcc-12.5.0
arm                   randconfig-004-20260430    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260430    gcc-8.5.0
arm64                 randconfig-002-20260430    clang-23
arm64                 randconfig-003-20260430    clang-23
arm64                 randconfig-004-20260430    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260430    gcc-15.2.0
csky                  randconfig-002-20260430    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260430    clang-23
hexagon               randconfig-002-20260430    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260430    gcc-14
i386        buildonly-randconfig-002-20260430    clang-20
i386        buildonly-randconfig-003-20260430    clang-20
i386        buildonly-randconfig-004-20260430    gcc-14
i386        buildonly-randconfig-005-20260430    gcc-14
i386        buildonly-randconfig-006-20260430    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20260430    clang-20
i386                  randconfig-002-20260430    gcc-14
i386                  randconfig-003-20260430    clang-20
i386                  randconfig-004-20260430    clang-20
i386                  randconfig-005-20260430    clang-20
i386                  randconfig-006-20260430    clang-20
i386                  randconfig-007-20260430    gcc-13
i386                  randconfig-011-20260430    clang-20
i386                  randconfig-012-20260430    gcc-14
i386                  randconfig-013-20260430    clang-20
i386                  randconfig-014-20260430    gcc-14
i386                  randconfig-015-20260430    gcc-14
i386                  randconfig-016-20260430    gcc-14
i386                  randconfig-017-20260430    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260430    gcc-14.3.0
loongarch             randconfig-002-20260430    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260430    gcc-11.5.0
nios2                 randconfig-002-20260430    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260430    gcc-12.5.0
parisc                randconfig-002-20260430    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260430    gcc-10.5.0
powerpc               randconfig-002-20260430    clang-23
powerpc64             randconfig-001-20260430    gcc-13.4.0
powerpc64             randconfig-002-20260430    clang-20
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260430    clang-23
riscv                 randconfig-002-20260430    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260430    clang-23
s390                  randconfig-002-20260430    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260430    gcc-12.5.0
sh                    randconfig-002-20260430    gcc-10.5.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260430    gcc-12.5.0
sparc                 randconfig-002-20260430    gcc-11.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260430    clang-23
sparc64               randconfig-002-20260430    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260430    clang-23
um                    randconfig-002-20260430    clang-23
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260430    clang-20
x86_64      buildonly-randconfig-002-20260430    clang-20
x86_64      buildonly-randconfig-003-20260430    clang-20
x86_64      buildonly-randconfig-004-20260430    clang-20
x86_64      buildonly-randconfig-005-20260430    gcc-14
x86_64      buildonly-randconfig-006-20260430    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260430    gcc-14
x86_64                randconfig-002-20260430    gcc-12
x86_64                randconfig-003-20260430    gcc-14
x86_64                randconfig-004-20260430    clang-20
x86_64                randconfig-005-20260430    clang-20
x86_64                randconfig-006-20260430    clang-20
x86_64                randconfig-011-20260430    clang-20
x86_64                randconfig-012-20260430    clang-20
x86_64                randconfig-013-20260430    clang-20
x86_64                randconfig-014-20260430    gcc-13
x86_64                randconfig-015-20260430    clang-20
x86_64                randconfig-016-20260430    clang-20
x86_64                randconfig-071-20260430    clang-20
x86_64                randconfig-072-20260430    gcc-13
x86_64                randconfig-073-20260430    clang-20
x86_64                randconfig-074-20260430    clang-20
x86_64                randconfig-075-20260430    gcc-14
x86_64                randconfig-076-20260430    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260430    gcc-12.5.0
xtensa                randconfig-002-20260430    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
