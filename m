Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D137231832
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783517471; cv=none; b=KQda7BbQRhfoP55pYioPa4FoaYHeareeU2aalUaIMlvAI76cP+WrPwAbd7XNKRpDJ6LeEcHQDabyQ7p9ugbxHo3IuqeIDzapR/7Arizyh0NZY5Oghm7A5MtWSvgn8pZaBH8F6qaez9bVyta6VT8XH//yTCgqfADEA2E+XGjWJ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783517471; c=relaxed/simple;
	bh=S9GwKFM0OhOTKmUwIau5gYp0Qb0n8ErXwvwgML0c4sU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=GR1LjKLiigZfYHQfX72oDrznd+WogGShSJBhJKSVabU2/JPejoecKcujhVlBCecI0NSOpZr2lm7ib+Otd0BTqB/ablYEkpuRT9dhs+2aYSHf4WfEQdcR0FX+34ffDMfqw8Y+RyqwQ9Ytn3jpFAKPasl2bCdCDazTQqv7Y8KwiVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aG1EXExf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aG1EXExf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783517469; x=1815053469;
  h=date:from:to:cc:subject:message-id;
  bh=S9GwKFM0OhOTKmUwIau5gYp0Qb0n8ErXwvwgML0c4sU=;
  b=aG1EXExf+tDNFLy14qM/nKEnXb1xN0h7FIhIKzANcLk1vaf40nFb5SKo
   wcdPdayANjpprB5Zh34wQ0PLYt2D1wXFwG2WPa6dlOI/U/MakAQqIWu1Y
   O4ZPDslqtBVHtCSWP7vAFhmyhiESkq7kg1kF/CL8AMXRIdS/z4d2WLNFz
   Wzs7K0rUXZGbOeIXmP10tmvmKVqdLLl/k0EjLl4TnW1vwDDR3cmVyMrqu
   zI4CkB/uy/z0nWdQzgeo1A8wrGN4GXw5ecMow5JIf0M8PGQzzkoPsiyFQ
   FwT3cQvTq5iEJJnvm6rToKuj7w097TlNjGz7PSqXZskbvpqSoVRfrJHxl
   Q==;
X-CSE-ConnectionGUID: 77GGednWQWK5Gkw2MdUDRg==
X-CSE-MsgGUID: mW83pBgnSqeL/OMf0o/aqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="87861153"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="87861153"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 06:31:09 -0700
X-CSE-ConnectionGUID: 5hD/MdjUSUmbnih1b5dWnQ==
X-CSE-MsgGUID: VnrgdbivQbGr+I6tr3LtZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="253802024"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 08 Jul 2026 06:31:07 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whSMi-00000000GQV-0gVH;
	Wed, 08 Jul 2026 13:31:04 +0000
Date: Wed, 08 Jul 2026 21:30:04 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 302dfbff3e73be2ba5723237c6303244ec27cebb
Message-ID: <202607082153.gEvkpee7-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 302dfbff3e73be2ba5723237c6303244ec27cebb  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 735m

configs tested: 333
configs skipped: 12

The following configs have been built successfully.
More configs may be tested in the coming days.

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
arc                   randconfig-001-20260708    gcc-13.4.0
arc                   randconfig-001-20260708    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260708    gcc-13.4.0
arc                   randconfig-002-20260708    gcc-15.2.0
arc                   randconfig-002-20260708    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                         lpc32xx_defconfig    clang-17
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260708    gcc-11.5.0
arm                   randconfig-001-20260708    gcc-13.4.0
arm                   randconfig-001-20260708    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260708    gcc-10.5.0
arm                   randconfig-002-20260708    gcc-13.4.0
arm                   randconfig-002-20260708    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260708    gcc-13.4.0
arm                   randconfig-003-20260708    gcc-16.1.0
arm                   randconfig-003-20260708    gcc-8.5.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260708    gcc-13.4.0
arm                   randconfig-004-20260708    gcc-16.1.0
arm                   randconfig-004-20260708    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-9.5.0
arm64                 randconfig-001-20260708    clang-23
arm64                 randconfig-001-20260708    gcc-9.5.0
arm64                          randconfig-002    gcc-9.5.0
arm64                 randconfig-002-20260708    clang-23
arm64                 randconfig-002-20260708    gcc-9.5.0
arm64                          randconfig-003    gcc-9.5.0
arm64                 randconfig-003-20260708    gcc-9.5.0
arm64                          randconfig-004    gcc-9.5.0
arm64                 randconfig-004-20260708    gcc-15.2.0
arm64                 randconfig-004-20260708    gcc-9.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-9.5.0
csky                  randconfig-001-20260708    gcc-11.5.0
csky                  randconfig-001-20260708    gcc-9.5.0
csky                           randconfig-002    gcc-9.5.0
csky                  randconfig-002-20260708    gcc-9.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260708    clang-23
hexagon               randconfig-001-20260708    gcc-11.5.0
hexagon               randconfig-001-20260708    gcc-13.4.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260708    clang-21
hexagon               randconfig-002-20260708    gcc-11.5.0
hexagon               randconfig-002-20260708    gcc-13.4.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-22
i386        buildonly-randconfig-001-20260708    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260708    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260708    clang-22
i386        buildonly-randconfig-003-20260708    gcc-14
i386                 buildonly-randconfig-004    clang-22
i386        buildonly-randconfig-004-20260708    clang-22
i386        buildonly-randconfig-004-20260708    gcc-12
i386                 buildonly-randconfig-005    clang-22
i386        buildonly-randconfig-005-20260708    clang-22
i386        buildonly-randconfig-005-20260708    gcc-14
i386                 buildonly-randconfig-006    clang-22
i386        buildonly-randconfig-006-20260708    clang-22
i386        buildonly-randconfig-006-20260708    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260708    clang-22
i386                  randconfig-001-20260708    gcc-14
i386                  randconfig-002-20260708    clang-22
i386                  randconfig-002-20260708    gcc-14
i386                  randconfig-003-20260708    clang-22
i386                  randconfig-004-20260708    clang-22
i386                  randconfig-004-20260708    gcc-14
i386                  randconfig-005-20260708    clang-22
i386                  randconfig-006-20260708    clang-22
i386                  randconfig-007-20260708    clang-22
i386                  randconfig-007-20260708    gcc-12
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260708    gcc-14
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260708    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260708    clang-22
i386                  randconfig-013-20260708    gcc-14
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260708    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260708    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260708    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260708    gcc-13
i386                  randconfig-017-20260708    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260708    gcc-11.5.0
loongarch             randconfig-001-20260708    gcc-13.4.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260708    clang-23
loongarch             randconfig-002-20260708    gcc-11.5.0
loongarch             randconfig-002-20260708    gcc-13.4.0
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
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260708    gcc-11.5.0
nios2                 randconfig-001-20260708    gcc-13.4.0
nios2                 randconfig-001-20260708    gcc-9.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260708    gcc-11.5.0
nios2                 randconfig-002-20260708    gcc-13.4.0
nios2                 randconfig-002-20260708    gcc-8.5.0
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
parisc                         randconfig-001    clang-22
parisc                randconfig-001-20260708    clang-22
parisc                randconfig-001-20260708    gcc-12.5.0
parisc                         randconfig-002    clang-22
parisc                randconfig-002-20260708    clang-22
parisc                randconfig-002-20260708    gcc-10.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      bamboo_defconfig    clang-21
powerpc                        randconfig-001    clang-22
powerpc               randconfig-001-20260708    clang-22
powerpc               randconfig-001-20260708    gcc-11.5.0
powerpc                        randconfig-002    clang-22
powerpc               randconfig-002-20260708    clang-22
powerpc               randconfig-002-20260708    gcc-13.4.0
powerpc64                      randconfig-001    clang-22
powerpc64             randconfig-001-20260708    clang-22
powerpc64             randconfig-001-20260708    clang-23
powerpc64                      randconfig-002    clang-22
powerpc64             randconfig-002-20260708    clang-22
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-23
riscv                 randconfig-001-20260708    clang-23
riscv                 randconfig-001-20260708    gcc-8.5.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260708    clang-23
riscv                 randconfig-002-20260708    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-23
s390                  randconfig-001-20260708    clang-20
s390                  randconfig-001-20260708    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260708    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-23
sh                    randconfig-001-20260708    clang-23
sh                    randconfig-001-20260708    gcc-16.1.0
sh                             randconfig-002    clang-23
sh                    randconfig-002-20260708    clang-23
sh                    randconfig-002-20260708    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260708    gcc-16.1.0
sparc                 randconfig-001-20260708    gcc-8.5.0
sparc                 randconfig-002-20260708    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260708    clang-22
sparc64               randconfig-001-20260708    gcc-8.5.0
sparc64               randconfig-002-20260708    clang-20
sparc64               randconfig-002-20260708    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260708    gcc-14
um                    randconfig-001-20260708    gcc-8.5.0
um                    randconfig-002-20260708    clang-23
um                    randconfig-002-20260708    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260708    clang-22
x86_64      buildonly-randconfig-001-20260708    gcc-12
x86_64               buildonly-randconfig-002    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-14
x86_64               buildonly-randconfig-003    gcc-12
x86_64      buildonly-randconfig-003-20260708    gcc-12
x86_64               buildonly-randconfig-004    gcc-12
x86_64      buildonly-randconfig-004-20260708    clang-22
x86_64      buildonly-randconfig-004-20260708    gcc-12
x86_64               buildonly-randconfig-005    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-14
x86_64               buildonly-randconfig-006    gcc-12
x86_64      buildonly-randconfig-006-20260708    clang-22
x86_64      buildonly-randconfig-006-20260708    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260708    gcc-14
x86_64                randconfig-002-20260708    clang-22
x86_64                randconfig-002-20260708    gcc-14
x86_64                randconfig-003-20260708    clang-22
x86_64                randconfig-003-20260708    gcc-14
x86_64                randconfig-004-20260708    clang-22
x86_64                randconfig-004-20260708    gcc-14
x86_64                randconfig-005-20260708    clang-22
x86_64                randconfig-005-20260708    gcc-14
x86_64                randconfig-006-20260708    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260708    clang-22
x86_64                randconfig-011-20260708    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260708    clang-22
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260708    clang-22
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260708    clang-22
x86_64                randconfig-014-20260708    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260708    clang-22
x86_64                randconfig-015-20260708    gcc-14
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260708    clang-22
x86_64                randconfig-071-20260708    clang-22
x86_64                randconfig-072-20260708    clang-22
x86_64                randconfig-073-20260708    clang-22
x86_64                randconfig-074-20260708    clang-22
x86_64                randconfig-074-20260708    gcc-14
x86_64                randconfig-075-20260708    clang-22
x86_64                randconfig-076-20260708    clang-22
x86_64                randconfig-076-20260708    gcc-14
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
xtensa                randconfig-001-20260708    gcc-8.5.0
xtensa                randconfig-002-20260708    gcc-16.1.0
xtensa                randconfig-002-20260708    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
