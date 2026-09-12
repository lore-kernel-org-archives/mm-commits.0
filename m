Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F55A4BEE54
	for <mm-commits@vger.kernel.org>; Sat, 12 Sep 2026 02:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789179583; cv=none; b=LH6dDLFIuB56GUWCYmH5y/NvdkipZmh2IZvSPexfCE11BmZRs3/99hyjy3pl/548EG+l/GcB/T9RkEj+07YJDje6zbu2Qf7rl626ZpZmxDXV0R+JRHEnM6LOMHYvBax+p1B2qnG7dGa/w7evm8LTzSBs4e9EFpcs6vArzZLYXGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789179583; c=relaxed/simple;
	bh=LiJken9/pwZZa51p+cltrvgUrPEgP3WHempRNDm1zMM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Zq6DOvbRePVbiM2o4/K27c7tJW81tP2jK4UxhAMkaFtGUDRImeEix1+oo3HkHPj8ZEj2oD6EwZ/ynaF/mIZHun9lqkrU8JbAvPyp8lujULT0t4C0h8BMb4CXs0eNKJmX6+6GQSlVCkN0/kQrRvvOxTCMVRT15gXO7mOykF8Fs0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iokjZbiH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iokjZbiH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789179582; x=1820715582;
  h=date:from:to:cc:subject:message-id;
  bh=LiJken9/pwZZa51p+cltrvgUrPEgP3WHempRNDm1zMM=;
  b=iokjZbiH2ox4bAnJ50vXi8y2o1r+yU0ass4k3sZ6G9iLBgLnmOxggsOt
   AMXq6NFomtxSt9+Bws+a3qNeeOPg71YeD3ODeAB4ML3c9W52crlScV6rt
   wn9HmHiAIESHGnETWwS+vuzo0ow14te3GWmipYf14hKII8zLKffKK4AK3
   Ksax+c9NbXdPosPVzuI96t+UDzoCCX/Gqghsf/+hiY8YkBCoqShhIK/Dd
   DFgxp6wRvL4lyWF1eB3d54MhgrDa4dq+3PtmtrKL/W1gFfQ/5fZkugGNe
   hVvZTpPdxCXUIPNCEnqiBRkDo+fTY+5xZfPd1s3XUmBj7rxmtEEgjcd9W
   g==;
X-CSE-ConnectionGUID: eXMl+zaLS/SLU6frqaWz5Q==
X-CSE-MsgGUID: ln+7xrv7SGGKXixHAWvoVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="89669560"
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="89669560"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 19:19:42 -0700
X-CSE-ConnectionGUID: jTCI2VWbSDyEukFfNzrKNQ==
X-CSE-MsgGUID: QQ3ZQvTXSu+LPDSSqOPVMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="267793787"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 11 Sep 2026 19:19:39 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x5DL1-000000002Xb-31uN;
	Sat, 12 Sep 2026 02:19:32 +0000
Date: Sat, 12 Sep 2026 10:18:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9958290885035431e2494159f555e332c3c14906
Message-ID: <202609121040.A6J2UgCw-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9958290885035431e2494159f555e332c3c14906  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1340m

configs tested: 329
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
arc                          axs101_defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260911    gcc-12.5.0
arc                   randconfig-001-20260912    clang-17
arc                   randconfig-002-20260911    gcc-8.5.0
arc                   randconfig-002-20260912    clang-17
arc                    vdk_hs38_smp_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260911    clang-24
arm                   randconfig-001-20260912    clang-17
arm                   randconfig-002-20260911    gcc-12.5.0
arm                   randconfig-002-20260912    clang-17
arm                   randconfig-003-20260911    gcc-10.5.0
arm                   randconfig-003-20260912    clang-17
arm                   randconfig-004-20260911    clang-24
arm                   randconfig-004-20260912    clang-17
arm                        vexpress_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260911    clang-24
arm64                 randconfig-001-20260911    gcc-16.1.0
arm64                 randconfig-001-20260912    gcc-15.2.0
arm64                 randconfig-002-20260911    clang-24
arm64                 randconfig-002-20260911    gcc-16.1.0
arm64                 randconfig-002-20260912    gcc-15.2.0
arm64                 randconfig-003-20260911    clang-24
arm64                 randconfig-003-20260911    gcc-16.1.0
arm64                 randconfig-003-20260912    gcc-15.2.0
arm64                 randconfig-004-20260911    clang-24
arm64                 randconfig-004-20260911    gcc-16.1.0
arm64                 randconfig-004-20260912    gcc-15.2.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260911    gcc-16.1.0
csky                  randconfig-001-20260912    gcc-15.2.0
csky                  randconfig-002-20260911    gcc-16.1.0
csky                  randconfig-002-20260912    gcc-15.2.0
hexagon                          allmodconfig    clang-24
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-24
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260911    clang-17
hexagon               randconfig-001-20260912    clang-24
hexagon               randconfig-002-20260911    clang-20
hexagon               randconfig-002-20260912    clang-24
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260911    clang-22
i386        buildonly-randconfig-001-20260912    gcc-14
i386        buildonly-randconfig-002-20260911    gcc-14
i386        buildonly-randconfig-002-20260912    gcc-14
i386        buildonly-randconfig-003-20260911    gcc-14
i386        buildonly-randconfig-003-20260912    gcc-14
i386        buildonly-randconfig-004-20260911    clang-22
i386        buildonly-randconfig-004-20260912    gcc-14
i386        buildonly-randconfig-005-20260911    clang-22
i386        buildonly-randconfig-005-20260912    gcc-14
i386        buildonly-randconfig-006-20260911    gcc-14
i386        buildonly-randconfig-006-20260912    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260911    gcc-13
i386                  randconfig-001-20260912    gcc-14
i386                  randconfig-002-20260911    clang-22
i386                  randconfig-002-20260912    gcc-14
i386                  randconfig-003-20260911    gcc-14
i386                  randconfig-003-20260912    gcc-14
i386                  randconfig-004-20260911    clang-22
i386                  randconfig-004-20260912    gcc-14
i386                  randconfig-005-20260911    clang-22
i386                  randconfig-005-20260912    gcc-14
i386                  randconfig-006-20260911    clang-22
i386                  randconfig-006-20260912    gcc-14
i386                  randconfig-007-20260911    clang-22
i386                  randconfig-007-20260912    gcc-14
i386                  randconfig-011-20260911    clang-22
i386                  randconfig-011-20260911    gcc-14
i386                  randconfig-011-20260912    gcc-14
i386                  randconfig-012-20260911    clang-22
i386                  randconfig-012-20260911    gcc-14
i386                  randconfig-012-20260912    gcc-14
i386                  randconfig-013-20260911    clang-22
i386                  randconfig-013-20260912    gcc-14
i386                  randconfig-014-20260911    clang-22
i386                  randconfig-014-20260911    gcc-14
i386                  randconfig-014-20260912    gcc-14
i386                  randconfig-015-20260911    clang-22
i386                  randconfig-015-20260911    gcc-14
i386                  randconfig-015-20260912    gcc-14
i386                  randconfig-016-20260911    clang-22
i386                  randconfig-016-20260911    gcc-14
i386                  randconfig-016-20260912    gcc-14
i386                  randconfig-017-20260911    clang-22
i386                  randconfig-017-20260911    gcc-14
i386                  randconfig-017-20260912    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260911    gcc-12.5.0
loongarch             randconfig-001-20260912    clang-24
loongarch             randconfig-002-20260911    clang-22
loongarch             randconfig-002-20260912    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-24
m68k                                defconfig    gcc-16.1.0
m68k                       m5235evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze                          defconfig    gcc-16.1.0
microblaze                      mmu_defconfig    clang-24
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                     decstation_defconfig    clang-24
mips                     decstation_defconfig    gcc-16.1.0
mips                          eyeq6_defconfig    clang-24
mips                      fuloong2e_defconfig    gcc-16.1.0
mips                           gcw0_defconfig    clang-24
mips                           jazz_defconfig    clang-24
mips                           mtx1_defconfig    clang-19
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-24
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260911    gcc-11.5.0
nios2                 randconfig-001-20260912    clang-24
nios2                 randconfig-002-20260911    gcc-11.5.0
nios2                 randconfig-002-20260912    clang-24
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260911    gcc-13.4.0
parisc                randconfig-001-20260912    clang-24
parisc                randconfig-002-20260911    gcc-11.5.0
parisc                randconfig-002-20260912    clang-24
parisc64                         alldefconfig    gcc-16.1.0
parisc64                            defconfig    clang-24
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                    amigaone_defconfig    gcc-16.1.0
powerpc                       ebony_defconfig    clang-24
powerpc                        icon_defconfig    clang-24
powerpc                   lite5200b_defconfig    gcc-16.1.0
powerpc                     mpc5200_defconfig    clang-24
powerpc                     rainier_defconfig    clang-24
powerpc               randconfig-001-20260911    clang-21
powerpc               randconfig-001-20260912    clang-24
powerpc               randconfig-002-20260911    clang-24
powerpc               randconfig-002-20260912    clang-24
powerpc                  storcenter_defconfig    gcc-16.1.0
powerpc                      tqm8xx_defconfig    clang-20
powerpc64             randconfig-001-20260911    gcc-8.5.0
powerpc64             randconfig-001-20260912    clang-24
powerpc64             randconfig-002-20260911    clang-24
powerpc64             randconfig-002-20260912    clang-24
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260911    clang-24
riscv                 randconfig-001-20260912    gcc-11.5.0
riscv                 randconfig-002-20260911    clang-24
riscv                 randconfig-002-20260912    gcc-11.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260911    gcc-13.4.0
s390                  randconfig-001-20260912    gcc-11.5.0
s390                  randconfig-002-20260911    gcc-15.2.0
s390                  randconfig-002-20260912    gcc-11.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260911    gcc-14.3.0
sh                    randconfig-001-20260912    gcc-11.5.0
sh                    randconfig-002-20260911    gcc-16.1.0
sh                    randconfig-002-20260912    gcc-11.5.0
sh                           se7206_defconfig    gcc-16.1.0
sh                           se7705_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260911    gcc-13.4.0
sparc                 randconfig-001-20260911    gcc-8.5.0
sparc                 randconfig-001-20260912    gcc-14.3.0
sparc                 randconfig-002-20260911    gcc-13.4.0
sparc                 randconfig-002-20260912    gcc-14.3.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260911    clang-21
sparc64               randconfig-001-20260911    gcc-13.4.0
sparc64               randconfig-001-20260912    gcc-14.3.0
sparc64               randconfig-002-20260911    gcc-13.4.0
sparc64               randconfig-002-20260911    gcc-9.5.0
sparc64               randconfig-002-20260912    gcc-14.3.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260911    gcc-13.4.0
um                    randconfig-001-20260911    gcc-14
um                    randconfig-001-20260912    gcc-14.3.0
um                    randconfig-002-20260911    clang-24
um                    randconfig-002-20260911    gcc-13.4.0
um                    randconfig-002-20260912    gcc-14.3.0
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260911    clang-22
x86_64      buildonly-randconfig-001-20260911    gcc-14
x86_64      buildonly-randconfig-001-20260912    gcc-14
x86_64      buildonly-randconfig-002-20260911    gcc-14
x86_64      buildonly-randconfig-002-20260912    gcc-14
x86_64      buildonly-randconfig-003-20260911    clang-22
x86_64      buildonly-randconfig-003-20260911    gcc-14
x86_64      buildonly-randconfig-003-20260912    gcc-14
x86_64      buildonly-randconfig-004-20260911    gcc-14
x86_64      buildonly-randconfig-004-20260912    gcc-14
x86_64      buildonly-randconfig-005-20260911    clang-22
x86_64      buildonly-randconfig-005-20260911    gcc-14
x86_64      buildonly-randconfig-005-20260912    gcc-14
x86_64      buildonly-randconfig-006-20260911    gcc-14
x86_64      buildonly-randconfig-006-20260912    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260911    clang-22
x86_64                randconfig-002-20260911    clang-22
x86_64                randconfig-002-20260911    gcc-12
x86_64                randconfig-003-20260911    clang-22
x86_64                randconfig-004-20260911    clang-22
x86_64                randconfig-005-20260911    clang-22
x86_64                randconfig-005-20260911    gcc-14
x86_64                randconfig-006-20260911    clang-22
x86_64                randconfig-006-20260911    gcc-14
x86_64                randconfig-011-20260911    gcc-14
x86_64                randconfig-012-20260911    gcc-14
x86_64                randconfig-013-20260911    clang-22
x86_64                randconfig-013-20260911    gcc-14
x86_64                randconfig-014-20260911    clang-22
x86_64                randconfig-014-20260911    gcc-14
x86_64                randconfig-015-20260911    clang-22
x86_64                randconfig-015-20260911    gcc-14
x86_64                randconfig-016-20260911    clang-22
x86_64                randconfig-016-20260911    gcc-14
x86_64                randconfig-071-20260911    clang-22
x86_64                randconfig-071-20260912    gcc-14
x86_64                randconfig-072-20260911    gcc-14
x86_64                randconfig-072-20260912    gcc-14
x86_64                randconfig-073-20260911    gcc-14
x86_64                randconfig-073-20260912    gcc-14
x86_64                randconfig-074-20260911    clang-22
x86_64                randconfig-074-20260912    gcc-14
x86_64                randconfig-075-20260911    clang-22
x86_64                randconfig-075-20260912    gcc-14
x86_64                randconfig-076-20260911    clang-22
x86_64                randconfig-076-20260912    gcc-14
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
xtensa                randconfig-001-20260911    gcc-13.4.0
xtensa                randconfig-001-20260911    gcc-8.5.0
xtensa                randconfig-001-20260912    gcc-14.3.0
xtensa                randconfig-002-20260911    gcc-13.4.0
xtensa                randconfig-002-20260911    gcc-9.5.0
xtensa                randconfig-002-20260912    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
