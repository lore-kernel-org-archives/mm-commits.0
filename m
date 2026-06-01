Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D279D282F14
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 17:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780334526; cv=none; b=shDvXvEGklmTWLywiaIzyLkNRkQUs2sPxoYvocSxPTfLJebA7rQ9gZg+5swRsK4KMhtpOMv6a3otz9qu1K4w8zpMv2/T6/aZ8ypUF3zCGlgyQc6TSv+SpAjH/Y7XEw/a3K7lER3dxdJOg/zIbH4WGdi8dpYyr00QorbpirUpMQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780334526; c=relaxed/simple;
	bh=OTjlpBz81MlpSWZfoZDrW+Dlk+VhKUNJytbFslvPAKk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=EZfprivzgpqwyQvA6xgDKq9emWe7cRaNUJUuq1d/OYR4FxPhcFo5jUTXHRgSFZcywq3GkrpDxeWbNKVTJnP0XAgBqm57iYn7pUHCz2T7pNWhO6TVzdC3mJ3ZOvLzkXisIpDt+O2UMk+DenCSQpVRQOST3Ur/eXfLmmGtb2oaHDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qipy5XYK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qipy5XYK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780334525; x=1811870525;
  h=date:from:to:cc:subject:message-id;
  bh=OTjlpBz81MlpSWZfoZDrW+Dlk+VhKUNJytbFslvPAKk=;
  b=Qipy5XYKy0/31f8HUzJKMFRAAWx9lMUu4TlRhg0dDWuFpyMMaPjMDUxU
   pFFC42GR70kHTYhyLNxkkQ+MT3IGmJke0PyPIKDaSIIF3IvrkfhMidAFD
   o8cWZMMs5BP+vgwd/dzBXDuoU4UjTt/poZ0rlHtDn5En0OfAOjSOdRE4Q
   eYzy0an3WycsYpV7ZH4+SpqdPphWtgA6XcZIAerqeKvsYrsG08aH+8/HS
   HCSed0ooNiHnk99LcUmv+Z0U67/Rd3I4A87B+73bw5Es7HOHDJ2vf2/Rs
   ELwwWTUNnPVBM/wGesADsLN5lK8cIM24KisyNdNlNz1RYqEro/DD67FeE
   Q==;
X-CSE-ConnectionGUID: YFGjpbbNQjOXSpjPmvOxFQ==
X-CSE-MsgGUID: 3mv+zpNwT9eNOGmKHA6SVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="98519084"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="98519084"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 10:22:04 -0700
X-CSE-ConnectionGUID: /3Cer83XRkikvwUWdeuNLA==
X-CSE-MsgGUID: 2OTYNnAKSEKzafgd5Iflew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="243463809"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 01 Jun 2026 10:22:03 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wU6Kt-00000000Ara-3lPo;
	Mon, 01 Jun 2026 17:21:59 +0000
Date: Tue, 02 Jun 2026 01:21:33 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 415489ef1cdfe586b4992662bee65286d50232e6
Message-ID: <202606020122.Di20NyDP-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 415489ef1cdfe586b4992662bee65286d50232e6  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 727m

configs tested: 322
configs skipped: 13

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
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260601    clang-23
arc                   randconfig-001-20260601    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260601    clang-23
arc                   randconfig-002-20260601    gcc-14.3.0
arc                   randconfig-002-20260601    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                           h3600_defconfig    gcc-15.2.0
arm                       imx_v4_v5_defconfig    clang-23
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260601    clang-23
arm                   randconfig-001-20260601    gcc-15.2.0
arm                   randconfig-001-20260601    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260601    clang-23
arm                   randconfig-002-20260601    gcc-11.5.0
arm                   randconfig-002-20260601    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260601    clang-23
arm                   randconfig-003-20260601    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260601    clang-23
arm                   randconfig-004-20260601    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    gcc-8.5.0
arm64                 randconfig-001-20260601    gcc-14.3.0
arm64                 randconfig-001-20260601    gcc-8.5.0
arm64                          randconfig-002    gcc-14.3.0
arm64                 randconfig-002-20260601    gcc-8.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260601    gcc-15.2.0
arm64                 randconfig-003-20260601    gcc-8.5.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260601    gcc-14.3.0
arm64                 randconfig-004-20260601    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260601    gcc-14.3.0
csky                  randconfig-001-20260601    gcc-8.5.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260601    gcc-16.1.0
csky                  randconfig-002-20260601    gcc-8.5.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    clang-17
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260601    clang-18
hexagon               randconfig-001-20260601    gcc-11.5.0
hexagon               randconfig-001-20260601    gcc-8.5.0
hexagon                        randconfig-002    clang-23
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260601    clang-23
hexagon               randconfig-002-20260601    gcc-11.5.0
hexagon               randconfig-002-20260601    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-12
i386        buildonly-randconfig-001-20260601    gcc-12
i386        buildonly-randconfig-001-20260601    gcc-14
i386                 buildonly-randconfig-002    gcc-12
i386        buildonly-randconfig-002-20260601    clang-20
i386        buildonly-randconfig-002-20260601    gcc-12
i386                 buildonly-randconfig-003    gcc-12
i386        buildonly-randconfig-003-20260601    gcc-12
i386        buildonly-randconfig-003-20260601    gcc-14
i386                 buildonly-randconfig-004    gcc-12
i386        buildonly-randconfig-004-20260601    clang-20
i386        buildonly-randconfig-004-20260601    gcc-12
i386                 buildonly-randconfig-005    gcc-12
i386        buildonly-randconfig-005-20260601    gcc-12
i386        buildonly-randconfig-005-20260601    gcc-14
i386                 buildonly-randconfig-006    gcc-12
i386        buildonly-randconfig-006-20260601    gcc-12
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260601    gcc-14
i386                  randconfig-002-20260601    clang-20
i386                  randconfig-002-20260601    gcc-14
i386                  randconfig-003-20260601    gcc-14
i386                  randconfig-004-20260601    gcc-14
i386                  randconfig-005-20260601    gcc-14
i386                  randconfig-006-20260601    gcc-14
i386                  randconfig-007-20260601    gcc-14
i386                  randconfig-011-20260601    clang-20
i386                  randconfig-012-20260601    clang-20
i386                  randconfig-013-20260601    gcc-14
i386                  randconfig-014-20260601    clang-20
i386                  randconfig-015-20260601    clang-20
i386                  randconfig-016-20260601    clang-20
i386                  randconfig-017-20260601    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    clang-18
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260601    clang-23
loongarch             randconfig-001-20260601    gcc-11.5.0
loongarch             randconfig-001-20260601    gcc-8.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch                      randconfig-002    gcc-13.4.0
loongarch             randconfig-002-20260601    clang-18
loongarch             randconfig-002-20260601    gcc-11.5.0
loongarch             randconfig-002-20260601    gcc-8.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
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
mips                           gcw0_defconfig    clang-23
mips                           rs90_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260601    gcc-11.5.0
nios2                 randconfig-001-20260601    gcc-8.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260601    gcc-11.5.0
nios2                 randconfig-002-20260601    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260601    gcc-10.5.0
parisc                randconfig-002-20260601    gcc-10.5.0
parisc                randconfig-002-20260601    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260601    gcc-10.5.0
powerpc               randconfig-001-20260601    gcc-14.3.0
powerpc               randconfig-002-20260601    clang-23
powerpc               randconfig-002-20260601    gcc-10.5.0
powerpc                     tqm8560_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260601    gcc-10.5.0
powerpc64             randconfig-001-20260601    gcc-12.5.0
powerpc64             randconfig-002-20260601    gcc-10.5.0
powerpc64             randconfig-002-20260601    gcc-13.4.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260601    clang-23
riscv                 randconfig-001-20260601    gcc-10.5.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260601    clang-23
riscv                 randconfig-002-20260601    gcc-10.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260601    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260601    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-16.1.0
sh                    randconfig-001-20260601    clang-23
sh                    randconfig-001-20260601    gcc-16.1.0
sh                             randconfig-002    gcc-14.3.0
sh                    randconfig-002-20260601    clang-23
sh                    randconfig-002-20260601    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                          randconfig-001    gcc-8.5.0
sparc                 randconfig-001-20260601    gcc-15.2.0
sparc                 randconfig-001-20260601    gcc-8.5.0
sparc                          randconfig-002    gcc-8.5.0
sparc                 randconfig-002-20260601    gcc-15.2.0
sparc                 randconfig-002-20260601    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-8.5.0
sparc64               randconfig-001-20260601    clang-20
sparc64               randconfig-001-20260601    gcc-15.2.0
sparc64               randconfig-001-20260601    gcc-8.5.0
sparc64                        randconfig-002    gcc-8.5.0
sparc64               randconfig-002-20260601    clang-23
sparc64               randconfig-002-20260601    gcc-15.2.0
sparc64               randconfig-002-20260601    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-8.5.0
um                    randconfig-001-20260601    gcc-14
um                    randconfig-001-20260601    gcc-15.2.0
um                    randconfig-001-20260601    gcc-8.5.0
um                             randconfig-002    gcc-8.5.0
um                    randconfig-002-20260601    gcc-14
um                    randconfig-002-20260601    gcc-15.2.0
um                    randconfig-002-20260601    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64               buildonly-randconfig-001    clang-20
x86_64      buildonly-randconfig-001-20260601    clang-20
x86_64               buildonly-randconfig-002    clang-20
x86_64      buildonly-randconfig-002-20260601    clang-20
x86_64               buildonly-randconfig-003    clang-20
x86_64      buildonly-randconfig-003-20260601    clang-20
x86_64               buildonly-randconfig-004    clang-20
x86_64      buildonly-randconfig-004-20260601    clang-20
x86_64      buildonly-randconfig-004-20260601    gcc-12
x86_64               buildonly-randconfig-005    clang-20
x86_64      buildonly-randconfig-005-20260601    clang-20
x86_64               buildonly-randconfig-006    clang-20
x86_64      buildonly-randconfig-006-20260601    clang-20
x86_64      buildonly-randconfig-006-20260601    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260601    clang-20
x86_64                randconfig-001-20260601    gcc-14
x86_64                randconfig-002-20260601    clang-20
x86_64                randconfig-002-20260601    gcc-14
x86_64                randconfig-003-20260601    clang-20
x86_64                randconfig-004-20260601    clang-20
x86_64                randconfig-005-20260601    clang-20
x86_64                randconfig-006-20260601    clang-20
x86_64                randconfig-011-20260601    clang-20
x86_64                randconfig-012-20260601    clang-20
x86_64                randconfig-012-20260601    gcc-14
x86_64                randconfig-013-20260601    clang-20
x86_64                randconfig-014-20260601    clang-20
x86_64                randconfig-014-20260601    gcc-14
x86_64                randconfig-015-20260601    clang-20
x86_64                randconfig-015-20260601    gcc-14
x86_64                randconfig-016-20260601    clang-20
x86_64                randconfig-016-20260601    gcc-14
x86_64                randconfig-071-20260601    clang-20
x86_64                randconfig-071-20260601    gcc-14
x86_64                randconfig-072-20260601    gcc-14
x86_64                randconfig-073-20260601    clang-20
x86_64                randconfig-073-20260601    gcc-14
x86_64                randconfig-074-20260601    gcc-14
x86_64                randconfig-075-20260601    gcc-14
x86_64                randconfig-076-20260601    gcc-12
x86_64                randconfig-076-20260601    gcc-14
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
xtensa                           allyesconfig    gcc-15.2.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260601    gcc-15.2.0
xtensa                randconfig-001-20260601    gcc-8.5.0
xtensa                         randconfig-002    gcc-8.5.0
xtensa                randconfig-002-20260601    gcc-15.2.0
xtensa                randconfig-002-20260601    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
