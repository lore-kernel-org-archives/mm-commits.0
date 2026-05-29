Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93D5377547
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780074526; cv=none; b=eGK6X+UCkaF72bsrK1kxk1aX01+lDeC9IAzq+DfXREG1NhQKNGPwVQrJyiazHj1+qCsKQ2pL+dEzy1O4IxNvISI3xS6YskhYPNIFzPHC5u8El/epBgNyYZJiKY+I2e28GDnJXzDgvJ3XEZFs/fDgsfKaJ9ImhM1+3sAYtRkeZJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780074526; c=relaxed/simple;
	bh=e15abX/HCDFcaZz/26H+fB/fbx3jOrrYo410IprMlns=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nc4b/IBj39bsM3MjKpXLLN5SMJHFGEEnHuzi91S9N1okg2L/cJa/24uXigiATDsukML86N1KX9/sL9m8tadqJKZJ5j9hj6UeEIOpSoB7fyqbkZ39gqEY4oO1ZZXP/C50cCKefJ6ohEK7tNnkXVM2gx1IkalrHrEPQ5v8ZqAt0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QuTC53Ma; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QuTC53Ma"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780074525; x=1811610525;
  h=date:from:to:cc:subject:message-id;
  bh=e15abX/HCDFcaZz/26H+fB/fbx3jOrrYo410IprMlns=;
  b=QuTC53Majn1nzThqrjDGSRIgShnGmwPA1XBJeM/4vE7IdL/9NZOmOfoj
   f6Af2ofUjSiJI1jjDm3xhL8hVq/toiH6mDP33XzlqgQLpqY5pIB7wCLns
   a0vga/5aKFencnsmXWtmwYEs72qhOcV8o8xqTLqmLtcmCuvZfUzTsED5c
   Om1PcyM+DFgVXKNrbUIeog+x0SdkZZFo9Z+Uh2UT6RBNsDDyoYMKLXTmJ
   Z1YA/sutfKNZnRV0VcOPZ1X/ZEEgonqcxFMKzS84iLoYNZb4EKUMmnE4s
   NDtQhc+K2v7BfvlgmBHo43g39Hcf3PYP/PVertIKP2XYkdl/PhoEMkoWS
   A==;
X-CSE-ConnectionGUID: ckTL7XWsQHqf/cI1v0UuCQ==
X-CSE-MsgGUID: OSsfZHDXReiEawCitLIcYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="91241190"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="91241190"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 10:08:44 -0700
X-CSE-ConnectionGUID: sWwF+xQbQ0qatFPzNdZxtA==
X-CSE-MsgGUID: ddGiUpuxSo+m63Q+PTWjYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="238517721"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 May 2026 10:08:41 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wT0hK-000000007Wg-2tw3;
	Fri, 29 May 2026 17:08:38 +0000
Date: Sat, 30 May 2026 01:08:21 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 a4316353f0e3e9dff78d8a7582915117ec01e359
Message-ID: <202605300111.92PXFPgm-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: a4316353f0e3e9dff78d8a7582915117ec01e359  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 736m

configs tested: 269
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260529    clang-23
arc                   randconfig-001-20260529    gcc-14.3.0
arc                   randconfig-002-20260529    clang-23
arc                   randconfig-002-20260529    gcc-10.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                         lpc32xx_defconfig    clang-17
arm                   randconfig-001-20260529    clang-23
arm                   randconfig-001-20260529    gcc-14.3.0
arm                   randconfig-002-20260529    clang-23
arm                   randconfig-002-20260529    gcc-8.5.0
arm                   randconfig-003-20260529    clang-23
arm                   randconfig-003-20260529    gcc-13.4.0
arm                   randconfig-004-20260529    clang-23
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260529    gcc-8.5.0
arm64                 randconfig-002-20260529    clang-23
arm64                 randconfig-003-20260529    clang-23
arm64                 randconfig-004-20260529    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260529    gcc-15.2.0
csky                  randconfig-002-20260529    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260529    clang-23
hexagon               randconfig-001-20260529    gcc-8.5.0
hexagon               randconfig-002-20260529    clang-23
hexagon               randconfig-002-20260529    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260529    gcc-12
i386        buildonly-randconfig-002-20260529    clang-20
i386        buildonly-randconfig-002-20260529    gcc-12
i386        buildonly-randconfig-003-20260529    gcc-12
i386        buildonly-randconfig-004-20260529    gcc-12
i386        buildonly-randconfig-004-20260529    gcc-14
i386        buildonly-randconfig-005-20260529    gcc-12
i386        buildonly-randconfig-005-20260529    gcc-14
i386        buildonly-randconfig-006-20260529    gcc-12
i386        buildonly-randconfig-006-20260529    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260529    gcc-14
i386                  randconfig-002-20260529    gcc-12
i386                  randconfig-002-20260529    gcc-14
i386                  randconfig-003-20260529    clang-20
i386                  randconfig-003-20260529    gcc-14
i386                  randconfig-004-20260529    clang-20
i386                  randconfig-004-20260529    gcc-14
i386                  randconfig-005-20260529    gcc-14
i386                  randconfig-006-20260529    clang-20
i386                  randconfig-006-20260529    gcc-14
i386                  randconfig-007-20260529    gcc-12
i386                  randconfig-007-20260529    gcc-14
i386                           randconfig-011    clang-20
i386                  randconfig-011-20260529    clang-20
i386                  randconfig-011-20260529    gcc-14
i386                           randconfig-012    clang-20
i386                  randconfig-012-20260529    clang-20
i386                  randconfig-012-20260529    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260529    clang-20
i386                  randconfig-013-20260529    gcc-14
i386                           randconfig-014    clang-20
i386                  randconfig-014-20260529    clang-20
i386                  randconfig-014-20260529    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260529    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260529    clang-20
i386                  randconfig-016-20260529    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260529    gcc-13
i386                  randconfig-017-20260529    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260529    gcc-15.2.0
loongarch             randconfig-001-20260529    gcc-8.5.0
loongarch             randconfig-002-20260529    gcc-15.2.0
loongarch             randconfig-002-20260529    gcc-8.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260529    gcc-8.5.0
nios2                 randconfig-002-20260529    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    clang-19
parisc                         randconfig-001    gcc-13.4.0
parisc                randconfig-001-20260529    clang-19
parisc                randconfig-001-20260529    gcc-8.5.0
parisc                         randconfig-002    clang-19
parisc                         randconfig-002    gcc-8.5.0
parisc                randconfig-002-20260529    clang-19
parisc                randconfig-002-20260529    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                 canyonlands_defconfig    clang-23
powerpc                        randconfig-001    clang-19
powerpc                        randconfig-001    gcc-13.4.0
powerpc               randconfig-001-20260529    clang-19
powerpc               randconfig-001-20260529    gcc-12.5.0
powerpc                        randconfig-002    clang-19
powerpc                        randconfig-002    gcc-10.5.0
powerpc               randconfig-002-20260529    clang-19
powerpc64                      randconfig-001    clang-17
powerpc64                      randconfig-001    clang-19
powerpc64             randconfig-001-20260529    clang-19
powerpc64             randconfig-001-20260529    gcc-15.2.0
powerpc64                      randconfig-002    clang-19
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260529    clang-19
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260529    gcc-8.5.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260529    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260529    gcc-8.5.0
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260529    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-15.2.0
sh                    randconfig-001-20260529    gcc-15.2.0
sh                             randconfig-002    gcc-14.3.0
sh                    randconfig-002-20260529    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260529    gcc-11.5.0
sparc                 randconfig-001-20260529    gcc-8.5.0
sparc                 randconfig-002-20260529    gcc-11.5.0
sparc                 randconfig-002-20260529    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260529    gcc-11.5.0
sparc64               randconfig-002-20260529    gcc-11.5.0
sparc64               randconfig-002-20260529    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260529    gcc-11.5.0
um                    randconfig-001-20260529    gcc-14
um                    randconfig-002-20260529    gcc-11.5.0
um                    randconfig-002-20260529    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260529    gcc-14
x86_64      buildonly-randconfig-002-20260529    gcc-14
x86_64      buildonly-randconfig-003-20260529    gcc-14
x86_64      buildonly-randconfig-004-20260529    clang-20
x86_64      buildonly-randconfig-004-20260529    gcc-14
x86_64      buildonly-randconfig-005-20260529    clang-20
x86_64      buildonly-randconfig-005-20260529    gcc-14
x86_64      buildonly-randconfig-006-20260529    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260529    clang-20
x86_64                randconfig-001-20260529    gcc-14
x86_64                randconfig-002-20260529    clang-20
x86_64                randconfig-003-20260529    clang-20
x86_64                randconfig-003-20260529    gcc-14
x86_64                randconfig-004-20260529    clang-20
x86_64                randconfig-005-20260529    clang-20
x86_64                randconfig-006-20260529    clang-20
x86_64                randconfig-011-20260529    gcc-14
x86_64                randconfig-012-20260529    gcc-14
x86_64                randconfig-013-20260529    clang-20
x86_64                randconfig-014-20260529    clang-20
x86_64                randconfig-015-20260529    gcc-14
x86_64                randconfig-016-20260529    clang-20
x86_64                         randconfig-071    clang-20
x86_64                randconfig-071-20260529    clang-20
x86_64                randconfig-071-20260529    gcc-14
x86_64                         randconfig-072    clang-20
x86_64                randconfig-072-20260529    clang-20
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260529    clang-20
x86_64                         randconfig-074    clang-20
x86_64                randconfig-074-20260529    clang-20
x86_64                randconfig-074-20260529    gcc-14
x86_64                         randconfig-075    clang-20
x86_64                randconfig-075-20260529    clang-20
x86_64                randconfig-075-20260529    gcc-14
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260529    clang-20
x86_64                randconfig-076-20260529    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260529    gcc-11.5.0
xtensa                randconfig-002-20260529    gcc-11.5.0
xtensa                randconfig-002-20260529    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
