Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8623F18DB35
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782756176; cv=none; b=dGEEWBcp8qPkrfiPhY2DPxczYBoef3pwWeVE20Se6ySJF6uAVO/sKN5U1HiqB0uJ7QopNxg34oWltS/TCPOUNjSVLy9CsbD+ANjxoLeuVLefTrxi+hZzhoAtnmN4qBgULhisr0VgzealAl/o+zH9zKZ7hDvKUao6xdhMkVnrpO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782756176; c=relaxed/simple;
	bh=5l0nY1p02y8SjK80OikSGKD2/7vY3Cgyi6uQzJ4GQjc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=jVpYibNhGeTVefMRNHG7Uam1Tw7fjXvIueKbsnvc8e8yGn+jMEG/ScZU8EP6OEkJ62U0Ugp4JF7dcAx/SwU3bBGTTVdFe1yRgIULafULs24uiih9111kYFfXsK/AW0Tlo/heR7ylhSMeTD/cyUZdNOtRBs64PN9rBMOb0Jxcst8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hPwugMmZ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hPwugMmZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782756175; x=1814292175;
  h=date:from:to:cc:subject:message-id;
  bh=5l0nY1p02y8SjK80OikSGKD2/7vY3Cgyi6uQzJ4GQjc=;
  b=hPwugMmZzFXdBmKhicieYK/SxFIKy4D2NDe0vopKHi8QbhsJfbbp/Jr5
   5Jy96oKnYqt79U01rQO5o3tXtnF0+eh56ngKhl3ZuU3hEG+vADnXQmnPN
   XdF97keBsM8EnGNdCOjvMG+a97fSkbF2VHova5tWkXNcm5pfbV18wI9je
   4VxHYkIuLo6YKJBsKyxx0MBbHDbrX3plODQPzfupmiw3NLp+Q+4f+icrZ
   y+kkxlUjfla7Pj9ibmEYrlTllFYkME4DbRRwqf6NovZd98rDsi1V2pc+o
   EuzSyMxZuK+r/dmJcPBvvFtxgqtXdHjIx+YdwrGQ16oPVlMoJplpCEfsY
   Q==;
X-CSE-ConnectionGUID: +4+5NV7aQAe/I/3nV1YiHg==
X-CSE-MsgGUID: F9YkV63uSOmAEXtVxmluAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="87369458"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="87369458"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 11:02:54 -0700
X-CSE-ConnectionGUID: 6ibuSj+LQZit8Chm+YK6gg==
X-CSE-MsgGUID: 70StOdW5QlinwIlmKt+TzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="276293076"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 29 Jun 2026 11:02:51 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1weGIt-000000007dd-0tjL;
	Mon, 29 Jun 2026 18:02:18 +0000
Date: Tue, 30 Jun 2026 02:01:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 88cefc306c43b58d9bb65c9e96e284306710d961
Message-ID: <202606300228.Vk2LZPOa-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 88cefc306c43b58d9bb65c9e96e284306710d961  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com

    mm/vmalloc.c:3590:16: warning: unused variable 'start' [-Wunused-variable]
    mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
    mm/zsmalloc.c:800:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-001-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-001-20260629
|   |-- mm-vmalloc.c:warning:unused-variable-start
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- csky-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-r054-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-r131-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-randconfig-002
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sh-randconfig-r062-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-001-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-r072-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-001-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-r054-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-r063-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-r073-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
`-- sparc64-randconfig-r113-20260629
    `-- mm-vmalloc.c:warning:unused-variable-start

elapsed time: 729m

configs tested: 271
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260629    clang-17
arc                   randconfig-001-20260630    clang-23
arc                   randconfig-002-20260629    clang-17
arc                   randconfig-002-20260630    clang-23
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260629    clang-17
arm                   randconfig-001-20260630    clang-23
arm                   randconfig-002-20260629    clang-17
arm                   randconfig-002-20260630    clang-23
arm                   randconfig-003-20260629    clang-17
arm                   randconfig-003-20260630    clang-23
arm                   randconfig-004-20260629    clang-17
arm                   randconfig-004-20260630    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260629    gcc-16.1.0
arm64                 randconfig-001-20260630    clang-23
arm64                 randconfig-002-20260629    gcc-16.1.0
arm64                 randconfig-002-20260630    clang-23
arm64                 randconfig-003-20260629    gcc-16.1.0
arm64                 randconfig-003-20260630    clang-23
arm64                 randconfig-004-20260629    gcc-16.1.0
arm64                 randconfig-004-20260630    clang-23
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260629    gcc-16.1.0
csky                  randconfig-001-20260630    clang-23
csky                  randconfig-002-20260629    gcc-16.1.0
csky                  randconfig-002-20260630    clang-23
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260629    gcc-11.5.0
hexagon               randconfig-001-20260630    clang-18
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260629    gcc-11.5.0
hexagon               randconfig-002-20260630    clang-18
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260629    clang-22
i386        buildonly-randconfig-001-20260629    gcc-14
i386        buildonly-randconfig-001-20260630    clang-22
i386        buildonly-randconfig-002-20260629    gcc-13
i386        buildonly-randconfig-002-20260629    gcc-14
i386        buildonly-randconfig-002-20260630    clang-22
i386        buildonly-randconfig-003-20260629    gcc-14
i386        buildonly-randconfig-003-20260630    clang-22
i386        buildonly-randconfig-004-20260629    clang-22
i386        buildonly-randconfig-004-20260629    gcc-14
i386        buildonly-randconfig-004-20260630    clang-22
i386        buildonly-randconfig-005-20260629    gcc-14
i386        buildonly-randconfig-005-20260630    clang-22
i386        buildonly-randconfig-006-20260629    clang-22
i386        buildonly-randconfig-006-20260629    gcc-14
i386        buildonly-randconfig-006-20260630    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260629    clang-22
i386                  randconfig-001-20260630    clang-22
i386                  randconfig-002-20260629    clang-22
i386                  randconfig-002-20260630    clang-22
i386                  randconfig-003-20260629    clang-22
i386                  randconfig-003-20260630    clang-22
i386                  randconfig-004-20260629    clang-22
i386                  randconfig-004-20260630    clang-22
i386                  randconfig-005-20260629    clang-22
i386                  randconfig-005-20260630    clang-22
i386                  randconfig-006-20260629    clang-22
i386                  randconfig-006-20260630    clang-22
i386                  randconfig-007-20260629    clang-22
i386                  randconfig-007-20260630    clang-22
i386                  randconfig-011-20260629    gcc-14
i386                  randconfig-012-20260629    gcc-14
i386                  randconfig-013-20260629    gcc-14
i386                  randconfig-014-20260629    gcc-14
i386                  randconfig-015-20260629    clang-22
i386                  randconfig-015-20260629    gcc-14
i386                  randconfig-016-20260629    clang-22
i386                  randconfig-016-20260629    gcc-14
i386                  randconfig-017-20260629    clang-22
i386                  randconfig-017-20260629    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260629    gcc-11.5.0
loongarch             randconfig-001-20260629    gcc-12.5.0
loongarch             randconfig-001-20260630    clang-18
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260629    gcc-11.5.0
loongarch             randconfig-002-20260630    clang-18
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                                defconfig    clang-23
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm47xx_defconfig    clang-23
mips                       lemote2f_defconfig    gcc-16.1.0
mips                          malta_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260629    gcc-11.5.0
nios2                 randconfig-001-20260630    clang-18
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260629    gcc-11.5.0
nios2                 randconfig-002-20260630    clang-18
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-9.5.0
parisc                randconfig-001-20260629    gcc-9.5.0
parisc                         randconfig-002    gcc-9.5.0
parisc                randconfig-002-20260629    gcc-9.5.0
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-9.5.0
powerpc               randconfig-001-20260629    gcc-9.5.0
powerpc                        randconfig-002    gcc-9.5.0
powerpc               randconfig-002-20260629    gcc-9.5.0
powerpc                         wii_defconfig    gcc-16.1.0
powerpc64                      randconfig-001    gcc-9.5.0
powerpc64             randconfig-001-20260629    gcc-9.5.0
powerpc64                      randconfig-002    gcc-9.5.0
powerpc64             randconfig-002-20260629    gcc-9.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-17
riscv                 randconfig-001-20260629    clang-17
riscv                 randconfig-001-20260630    gcc-9.5.0
riscv                          randconfig-002    clang-17
riscv                 randconfig-002-20260629    clang-17
riscv                 randconfig-002-20260630    gcc-9.5.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-17
s390                  randconfig-001-20260629    clang-17
s390                  randconfig-001-20260630    gcc-9.5.0
s390                           randconfig-002    clang-17
s390                  randconfig-002-20260629    clang-17
s390                  randconfig-002-20260630    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-17
sh                    randconfig-001-20260629    clang-17
sh                    randconfig-001-20260629    gcc-10.5.0
sh                    randconfig-001-20260630    gcc-9.5.0
sh                             randconfig-002    clang-17
sh                    randconfig-002-20260629    clang-17
sh                    randconfig-002-20260630    gcc-9.5.0
sh                   sh7770_generic_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260629    gcc-15.2.0
sparc                 randconfig-002-20260629    gcc-15.2.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260629    gcc-15.2.0
sparc64               randconfig-002-20260629    gcc-15.2.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260629    gcc-15.2.0
um                    randconfig-002-20260629    gcc-15.2.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260629    clang-22
x86_64      buildonly-randconfig-002-20260629    clang-22
x86_64      buildonly-randconfig-002-20260629    gcc-14
x86_64      buildonly-randconfig-003-20260629    clang-22
x86_64      buildonly-randconfig-003-20260629    gcc-14
x86_64      buildonly-randconfig-004-20260629    clang-22
x86_64      buildonly-randconfig-005-20260629    clang-22
x86_64      buildonly-randconfig-006-20260629    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260629    gcc-14
x86_64                randconfig-002-20260629    clang-22
x86_64                randconfig-002-20260629    gcc-14
x86_64                randconfig-003-20260629    gcc-14
x86_64                randconfig-004-20260629    gcc-14
x86_64                randconfig-005-20260629    clang-22
x86_64                randconfig-005-20260629    gcc-14
x86_64                randconfig-006-20260629    gcc-14
x86_64                randconfig-011-20260629    gcc-13
x86_64                randconfig-011-20260630    gcc-14
x86_64                randconfig-012-20260629    gcc-13
x86_64                randconfig-012-20260630    gcc-14
x86_64                randconfig-013-20260629    gcc-13
x86_64                randconfig-013-20260630    gcc-14
x86_64                randconfig-014-20260629    gcc-13
x86_64                randconfig-014-20260630    gcc-14
x86_64                randconfig-015-20260629    gcc-13
x86_64                randconfig-015-20260630    gcc-14
x86_64                randconfig-016-20260629    gcc-13
x86_64                randconfig-016-20260630    gcc-14
x86_64                randconfig-071-20260629    clang-22
x86_64                randconfig-072-20260629    clang-22
x86_64                randconfig-073-20260629    clang-22
x86_64                randconfig-074-20260629    clang-22
x86_64                randconfig-075-20260629    clang-22
x86_64                randconfig-076-20260629    clang-22
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
xtensa                randconfig-001-20260629    gcc-15.2.0
xtensa                randconfig-002-20260629    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
