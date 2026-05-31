Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A44D26ED3A
	for <mm-commits@vger.kernel.org>; Sun, 31 May 2026 11:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780228533; cv=none; b=HXvk34SDfwnsSR3oubzHPboS6DuW+1kAzFsfzAam6Iz+BEiGz71dvC0EwSkdNNnowv5olj5hYKvTpNoks0cmRnmOP02vo695B2RvxgojlX7ebO6cd475PxihFkU2Rr+MEO1yT0aGstvvJoLzbRGmhSjxtgUsb1ecjjNfxZG3SYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780228533; c=relaxed/simple;
	bh=6v8dWPnZOhlhn3UyURXaq5cVpG4f8vSgBe18p6fd4zY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=XSnhk5L/tnQhcvpIHn9Cc5Y/3UztLCYKBhpIWG4A4KzU+1oitX+8mBw87WdtREJIlKtfELb9y3NkN7ZufYdSi5/kLx/1RY+i0p2T1+RMgXtZHXroB5QdWC9BP/L46WPfWQsantr981+pFfkpx4YlElv2zIMQzfq7O2nyas+9o0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=clM/SotC; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="clM/SotC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780228531; x=1811764531;
  h=date:from:to:cc:subject:message-id;
  bh=6v8dWPnZOhlhn3UyURXaq5cVpG4f8vSgBe18p6fd4zY=;
  b=clM/SotCe4o9V77ci0+2zvNiaP5jnP607fP07STs1KtB420ex5HICLnq
   gmwOepm8l1wtUMikFGfCRQZDihAXcd58TnHugthR0Lk6WoMnEHHADnepP
   0ZF7MHzLLhATX+OphvvQx4/CuilwzvuZ57LmJIH/ruAZTFJTsWipTZcx5
   gC3qUj9UmGhY7O6T4PU5eEx0xI2zZYmB/pvA43d3sji00Cqbx5ERj/h8Y
   m9yjZIrClyjsaC+dxNqyEuMf8ZsbmbN+HlW9o4GjfnuFuLfk7Nnk3J8z5
   KmyvBVLmkTpp7dDgME9hRC91g48SbDWsBEusNoKGQ6Imzm86qOjCMs5GA
   A==;
X-CSE-ConnectionGUID: N3dBGMKASuCUoqAkC0sIfw==
X-CSE-MsgGUID: HUPp5xTsRE+OBitbAidF3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11802"; a="84867928"
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="84867928"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 04:55:30 -0700
X-CSE-ConnectionGUID: s2VLralSSbac7LyGd7y0/g==
X-CSE-MsgGUID: XB90MvAyRF+qaAJGCkF5Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="273595575"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 31 May 2026 04:55:28 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wTelJ-000000009Nq-0IQu;
	Sun, 31 May 2026 11:55:25 +0000
Date: Sun, 31 May 2026 19:54:45 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 d97bc98dadda29f23540b8490592962ebcf545ff
Message-ID: <202605311938.VM5jlJpi-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: d97bc98dadda29f23540b8490592962ebcf545ff  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 730m

configs tested: 292
configs skipped: 20

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260531    gcc-11.5.0
arc                   randconfig-001-20260531    gcc-8.5.0
arc                   randconfig-002-20260531    gcc-11.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                          collie_defconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260531    clang-20
arm                   randconfig-001-20260531    gcc-11.5.0
arm                   randconfig-002-20260531    clang-23
arm                   randconfig-002-20260531    gcc-11.5.0
arm                   randconfig-003-20260531    gcc-10.5.0
arm                   randconfig-003-20260531    gcc-11.5.0
arm                   randconfig-004-20260531    gcc-11.5.0
arm                   randconfig-004-20260531    gcc-12.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    gcc-8.5.0
arm64                 randconfig-001-20260531    clang-23
arm64                 randconfig-001-20260531    gcc-10.5.0
arm64                          randconfig-002    gcc-14.3.0
arm64                 randconfig-002-20260531    clang-23
arm64                 randconfig-002-20260531    gcc-12.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260531    clang-23
arm64                 randconfig-003-20260531    gcc-13.4.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260531    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260531    clang-23
csky                  randconfig-001-20260531    gcc-13.4.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260531    clang-23
csky                  randconfig-002-20260531    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260531    clang-23
hexagon               randconfig-002-20260531    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260531    clang-20
i386        buildonly-randconfig-002-20260531    clang-20
i386        buildonly-randconfig-003-20260531    clang-20
i386        buildonly-randconfig-003-20260531    gcc-14
i386        buildonly-randconfig-004-20260531    clang-20
i386        buildonly-randconfig-005-20260531    clang-20
i386        buildonly-randconfig-005-20260531    gcc-14
i386        buildonly-randconfig-006-20260531    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260531    clang-20
i386                  randconfig-001-20260531    gcc-13
i386                  randconfig-002-20260531    clang-20
i386                  randconfig-002-20260531    gcc-13
i386                  randconfig-003-20260531    clang-20
i386                  randconfig-003-20260531    gcc-13
i386                  randconfig-004-20260531    gcc-13
i386                  randconfig-005-20260531    clang-20
i386                  randconfig-005-20260531    gcc-13
i386                  randconfig-006-20260531    gcc-13
i386                  randconfig-006-20260531    gcc-14
i386                  randconfig-007-20260531    clang-20
i386                  randconfig-007-20260531    gcc-13
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260531    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260531    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260531    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260531    clang-20
i386                  randconfig-014-20260531    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260531    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260531    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260531    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260531    clang-23
loongarch             randconfig-001-20260531    gcc-15.2.0
loongarch             randconfig-002-20260531    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                       alldefconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           jazz_defconfig    clang-17
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.2.0
nios2                 randconfig-001-20260531    clang-23
nios2                 randconfig-001-20260531    gcc-11.5.0
nios2                 randconfig-002-20260531    clang-23
nios2                 randconfig-002-20260531    gcc-11.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
openrisc                    or1ksim_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    clang-23
parisc                randconfig-001-20260531    clang-23
parisc                randconfig-001-20260531    gcc-8.5.0
parisc                         randconfig-002    clang-23
parisc                randconfig-002-20260531    clang-23
parisc                randconfig-002-20260531    gcc-12.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        randconfig-001    clang-23
powerpc               randconfig-001-20260531    clang-17
powerpc               randconfig-001-20260531    clang-23
powerpc                        randconfig-002    clang-23
powerpc               randconfig-002-20260531    clang-23
powerpc                     redwood_defconfig    clang-23
powerpc                     tqm8548_defconfig    clang-23
powerpc64                      randconfig-001    clang-23
powerpc64             randconfig-001-20260531    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260531    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                    nommu_k210_defconfig    clang-23
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260531    clang-23
riscv                 randconfig-001-20260531    gcc-8.5.0
riscv                          randconfig-002    gcc-8.5.0
riscv                 randconfig-002-20260531    clang-18
riscv                 randconfig-002-20260531    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-8.5.0
s390                  randconfig-001-20260531    gcc-8.5.0
s390                           randconfig-002    gcc-8.5.0
s390                  randconfig-002-20260531    clang-23
s390                  randconfig-002-20260531    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          r7785rp_defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-8.5.0
sh                    randconfig-001-20260531    gcc-15.2.0
sh                    randconfig-001-20260531    gcc-8.5.0
sh                             randconfig-002    gcc-8.5.0
sh                    randconfig-002-20260531    gcc-14.3.0
sh                    randconfig-002-20260531    gcc-8.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260531    gcc-15.2.0
sparc                 randconfig-001-20260531    gcc-8.5.0
sparc                 randconfig-002-20260531    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260531    gcc-8.5.0
sparc64               randconfig-002-20260531    gcc-10.5.0
sparc64               randconfig-002-20260531    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260531    clang-19
um                    randconfig-001-20260531    gcc-8.5.0
um                    randconfig-002-20260531    gcc-14
um                    randconfig-002-20260531    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260531    clang-20
x86_64      buildonly-randconfig-001-20260531    gcc-13
x86_64      buildonly-randconfig-002-20260531    clang-20
x86_64      buildonly-randconfig-003-20260531    clang-20
x86_64      buildonly-randconfig-004-20260531    clang-20
x86_64      buildonly-randconfig-005-20260531    clang-20
x86_64      buildonly-randconfig-006-20260531    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260531    clang-20
x86_64                randconfig-001-20260531    gcc-14
x86_64                randconfig-002-20260531    gcc-14
x86_64                randconfig-003-20260531    gcc-14
x86_64                randconfig-004-20260531    gcc-14
x86_64                randconfig-005-20260531    clang-20
x86_64                randconfig-005-20260531    gcc-14
x86_64                randconfig-006-20260531    gcc-14
x86_64                randconfig-011-20260531    clang-20
x86_64                randconfig-011-20260531    gcc-14
x86_64                randconfig-012-20260531    clang-20
x86_64                randconfig-012-20260531    gcc-14
x86_64                randconfig-013-20260531    gcc-14
x86_64                randconfig-014-20260531    clang-20
x86_64                randconfig-014-20260531    gcc-14
x86_64                randconfig-015-20260531    clang-20
x86_64                randconfig-015-20260531    gcc-14
x86_64                randconfig-016-20260531    clang-20
x86_64                randconfig-016-20260531    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260531    clang-20
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260531    clang-20
x86_64                randconfig-072-20260531    gcc-14
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260531    clang-20
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260531    clang-20
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260531    clang-20
x86_64                randconfig-075-20260531    gcc-14
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260531    clang-20
x86_64                randconfig-076-20260531    gcc-13
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260531    gcc-8.5.0
xtensa                randconfig-002-20260531    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
