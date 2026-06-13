Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF29B67E
	for <mm-commits@vger.kernel.org>; Sat, 13 Jun 2026 19:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781378476; cv=none; b=k8Vgkfo6aytWRChEtyW8lWxspPluPxW3WOtWafENMkavM1V6AzsSod9X9jHGvp+mdXqidNG56RYQVr7wpGoMK2D9WFXerj/juQvO1WV+5plXpX18oL/yFsO28xBA8fsv6bPunyn8N50YzbTvGgvDJ2Nqi9qWSwQXxju9ieTAA90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781378476; c=relaxed/simple;
	bh=UdZZGW5QbTirbTSCuLF6x6DYYuTXZcD/mEQS9t1eeeQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Tndw32UV1Su7sy8lbq22AbrnCWQbQ3rgNM/9hz9hW2pd0Ml11YxXdORXA6fqvyh3Oy7yv4+mOEU8xfLVbbUlK6cNFZWoOFg5ClEzZPgpzuSq5Qj9vteNBExsyHdw8Ju+GVh1pp3MieI4CNJSmNOOGUZ5sFbruBucBRthl4/tfSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iC+HKt3U; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iC+HKt3U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781378474; x=1812914474;
  h=date:from:to:cc:subject:message-id;
  bh=UdZZGW5QbTirbTSCuLF6x6DYYuTXZcD/mEQS9t1eeeQ=;
  b=iC+HKt3UjU2G5aBNWC5h0VbTf7XA5ZyKAPuxtp0tbM1WSpyuvh61Arl9
   IreW1Jkplk9Egw84Evj6Ws6Z5lhOMdob6iPc4we76jEdIQRe999HLeq0D
   Yp4e5oofaAJmSUzveYCEwzjwFnk3vGMgzaRfA2Eob/bQjC7vB0ctgwC55
   boO8Wriy3e3sTe9IXC6u+BqrGxSyFypd0haXkbgeW9fQGmkLB6TRE2aFC
   GBWh6G9upHYo2Vt6kBTV/ouUoivTYJKDfTVJUpmhlzu/Byh9xwja/GL0O
   jfHDiLyUmu3WlHqlU458JYLUnzCuxDzuzwknTvAL9DzfGKHa6PugFmfdu
   A==;
X-CSE-ConnectionGUID: TqnmBSPaQX+fYVsRKNXjGA==
X-CSE-MsgGUID: qWN0hA1sRyyOsZji7rmB2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11816"; a="82183823"
X-IronPort-AV: E=Sophos;i="6.24,203,1774335600"; 
   d="scan'208";a="82183823"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2026 12:21:14 -0700
X-CSE-ConnectionGUID: CAOmgBrJQPSomtQem7ho1Q==
X-CSE-MsgGUID: sl2CzatoQMSnv90QwmAIIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,203,1774335600"; 
   d="scan'208";a="240750457"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 13 Jun 2026 12:21:12 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wYTun-00000000QD8-2AOP;
	Sat, 13 Jun 2026 19:21:09 +0000
Date: Sun, 14 Jun 2026 03:20:42 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9d335aed8840f6bf83ba93309ae5e185de829c21
Message-ID: <202606140331.1bGmcbPy-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9d335aed8840f6bf83ba93309ae5e185de829c21  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 910m

configs tested: 284
configs skipped: 5

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
arc                   randconfig-001-20260613    gcc-12.5.0
arc                   randconfig-001-20260614    gcc-11.5.0
arc                   randconfig-002-20260613    gcc-14.3.0
arc                   randconfig-002-20260614    gcc-11.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260613    gcc-8.5.0
arm                   randconfig-001-20260614    gcc-11.5.0
arm                   randconfig-002-20260613    clang-17
arm                   randconfig-002-20260614    gcc-11.5.0
arm                   randconfig-003-20260613    clang-23
arm                   randconfig-003-20260614    gcc-11.5.0
arm                   randconfig-004-20260613    clang-23
arm                   randconfig-004-20260614    gcc-11.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260613    gcc-16.1.0
arm64                 randconfig-002-20260613    clang-16
arm64                 randconfig-002-20260613    gcc-16.1.0
arm64                 randconfig-003-20260613    clang-23
arm64                 randconfig-003-20260613    gcc-16.1.0
arm64                 randconfig-004-20260613    clang-19
arm64                 randconfig-004-20260613    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260613    gcc-16.1.0
csky                  randconfig-002-20260613    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260613    clang-23
hexagon               randconfig-001-20260614    clang-16
hexagon               randconfig-002-20260613    clang-23
hexagon               randconfig-002-20260614    clang-16
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260613    gcc-14
i386        buildonly-randconfig-001-20260614    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260613    gcc-14
i386        buildonly-randconfig-002-20260614    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260613    clang-22
i386        buildonly-randconfig-003-20260613    gcc-14
i386        buildonly-randconfig-003-20260614    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260613    gcc-13
i386        buildonly-randconfig-004-20260613    gcc-14
i386        buildonly-randconfig-004-20260614    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260613    clang-22
i386        buildonly-randconfig-005-20260613    gcc-14
i386        buildonly-randconfig-005-20260614    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260613    gcc-14
i386        buildonly-randconfig-006-20260614    gcc-14
i386                                defconfig    clang-22
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260613    clang-22
i386                  randconfig-001-20260613    gcc-14
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260613    clang-22
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260613    clang-22
i386                  randconfig-003-20260613    gcc-14
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260613    clang-22
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260613    clang-22
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260613    clang-22
i386                  randconfig-006-20260613    gcc-14
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260613    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260613    clang-22
i386                  randconfig-011-20260613    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260613    clang-22
i386                  randconfig-012-20260613    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260613    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260613    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260613    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260613    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260613    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260613    clang-18
loongarch             randconfig-001-20260614    clang-16
loongarch             randconfig-002-20260613    clang-23
loongarch             randconfig-002-20260614    clang-16
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                        m5407c3_defconfig    gcc-16.1.0
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
nios2                 randconfig-001-20260613    gcc-11.5.0
nios2                 randconfig-001-20260614    clang-16
nios2                 randconfig-002-20260613    gcc-10.5.0
nios2                 randconfig-002-20260614    clang-16
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-23
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-15.2.0
parisc                randconfig-001-20260613    gcc-15.2.0
parisc                randconfig-001-20260613    gcc-9.5.0
parisc                         randconfig-002    gcc-15.2.0
parisc                randconfig-002-20260613    gcc-15.2.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                  mpc885_ads_defconfig    clang-23
powerpc                        randconfig-001    gcc-15.2.0
powerpc               randconfig-001-20260613    gcc-14.3.0
powerpc               randconfig-001-20260613    gcc-15.2.0
powerpc                        randconfig-002    gcc-15.2.0
powerpc               randconfig-002-20260613    gcc-15.2.0
powerpc               randconfig-002-20260613    gcc-8.5.0
powerpc64                      randconfig-001    gcc-15.2.0
powerpc64             randconfig-001-20260613    clang-23
powerpc64             randconfig-001-20260613    gcc-15.2.0
powerpc64                      randconfig-002    gcc-15.2.0
powerpc64             randconfig-002-20260613    clang-16
powerpc64             randconfig-002-20260613    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260613    gcc-10.5.0
riscv                 randconfig-001-20260613    gcc-8.5.0
riscv                 randconfig-001-20260614    gcc-9.5.0
riscv                 randconfig-002-20260613    clang-23
riscv                 randconfig-002-20260613    gcc-10.5.0
riscv                 randconfig-002-20260614    gcc-9.5.0
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260613    clang-23
s390                  randconfig-001-20260613    gcc-10.5.0
s390                  randconfig-001-20260614    gcc-9.5.0
s390                  randconfig-002-20260613    clang-16
s390                  randconfig-002-20260613    gcc-10.5.0
s390                  randconfig-002-20260614    gcc-9.5.0
s390                       zfcpdump_defconfig    clang-22
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-23
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260613    gcc-10.5.0
sh                    randconfig-001-20260614    gcc-9.5.0
sh                    randconfig-002-20260613    gcc-10.5.0
sh                    randconfig-002-20260613    gcc-16.1.0
sh                    randconfig-002-20260614    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260613    gcc-11.5.0
sparc                 randconfig-001-20260613    gcc-13.4.0
sparc                 randconfig-002-20260613    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260613    gcc-11.5.0
sparc64               randconfig-001-20260613    gcc-13.4.0
sparc64               randconfig-002-20260613    clang-23
sparc64               randconfig-002-20260613    gcc-13.4.0
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260613    gcc-13.4.0
um                    randconfig-001-20260613    gcc-14
um                    randconfig-002-20260613    gcc-13.4.0
um                    randconfig-002-20260613    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260613    clang-22
x86_64      buildonly-randconfig-002-20260613    clang-22
x86_64      buildonly-randconfig-003-20260613    clang-22
x86_64      buildonly-randconfig-004-20260613    clang-22
x86_64      buildonly-randconfig-005-20260613    clang-22
x86_64      buildonly-randconfig-005-20260613    gcc-14
x86_64      buildonly-randconfig-006-20260613    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260613    gcc-14
x86_64                randconfig-002-20260613    gcc-12
x86_64                randconfig-003-20260613    gcc-14
x86_64                randconfig-004-20260613    clang-22
x86_64                randconfig-005-20260613    clang-22
x86_64                randconfig-006-20260613    clang-22
x86_64                randconfig-011-20260613    clang-22
x86_64                randconfig-011-20260613    gcc-13
x86_64                randconfig-012-20260613    clang-22
x86_64                randconfig-013-20260613    clang-22
x86_64                randconfig-014-20260613    clang-22
x86_64                randconfig-015-20260613    clang-22
x86_64                randconfig-016-20260613    clang-22
x86_64                randconfig-016-20260613    gcc-14
x86_64                randconfig-071-20260613    clang-22
x86_64                randconfig-072-20260613    clang-22
x86_64                randconfig-073-20260613    clang-22
x86_64                randconfig-074-20260613    gcc-13
x86_64                randconfig-075-20260613    gcc-14
x86_64                randconfig-076-20260613    gcc-14
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
xtensa                randconfig-001-20260613    gcc-11.5.0
xtensa                randconfig-001-20260613    gcc-13.4.0
xtensa                randconfig-002-20260613    gcc-13.4.0
xtensa                randconfig-002-20260613    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
