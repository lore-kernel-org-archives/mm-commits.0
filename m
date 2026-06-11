Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE1C40680F
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781191798; cv=none; b=FiNabhYhMeRw0V6wrsbLRhP4udnaQmhhAXvXwyPmTVVjTrFkwhOv+GxdIK4mgkYklqXUcOWPt5GGo1BjuAPmMfpuH2FUFMnQSr7ERK5Q+Rf6mBBeUiRrDvi/vZG6IorYfv/aZxC0ypDSjnOWZ4QncBRICDfhyr5rhAjHv7RJGB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781191798; c=relaxed/simple;
	bh=r/lgubdyb8HYf/OqAGkJEfFBVHt/7MAg62LHlvRX9mw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=tEZuZEMN9dnrOAlXvZeWfQT+N9Sw9x5IEkSpgTyM0y8YHxRFPjWsu9uDvbeSSh2ZqWacNZSZRkB6mbSu8wD1XGPrpV0fwD1smw5GSW2F29txjXxOWJkmKC9OIsJmpndfOEXc81btUlGbp2WidoUjxQJRCEknk6/QyEaswKbNF9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j9rx4r08; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j9rx4r08"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781191795; x=1812727795;
  h=date:from:to:cc:subject:message-id;
  bh=r/lgubdyb8HYf/OqAGkJEfFBVHt/7MAg62LHlvRX9mw=;
  b=j9rx4r08GZ73nP8bLDxy4EdAokCDPDfroRZTognyf3S/e6c3S7yQyqU6
   P+x1rMwULjTgQNThYfSk6b/lvahlGzwvNb/PZAtI0aYAC0D+fQix2Yp7d
   fcSUKLwPdfxfpWjXR5kax/0Dtrps+f6XopBVAd5ovzeSqMlD3dpSJPi5e
   OmO0LvF27ZssXvwp85q/NrW2xABsWaKILU6rlXlWtxbn4j1wNIvHW0cHT
   8W1IIdmg/AzDeQtQjgmdttMcDtgXMyi8RgeezDjdeS4tezHPCzvYToD8+
   mkkDg1YxO9HaYoE3xyJO7lqKxFHO7aVcQtRq0Dd5TW36jFC7zOwLG/ec3
   g==;
X-CSE-ConnectionGUID: E/YRHTfbRBW7MxKLFAsKUw==
X-CSE-MsgGUID: TLF8Nt5AQqOZ2nO0g23CJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81143536"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="81143536"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 08:29:55 -0700
X-CSE-ConnectionGUID: pW1YX8IdRHSJ+v6A4KpMsQ==
X-CSE-MsgGUID: 5VmkSIZcR4CWJwTi31Hjjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="248388871"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 11 Jun 2026 08:29:53 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wXhLq-00000000NLC-44AW;
	Thu, 11 Jun 2026 15:29:50 +0000
Date: Thu, 11 Jun 2026 23:28:53 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 801c5efa788952095586d076fed1ea4902facff8
Message-ID: <202606112343.XCw5UUJt-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 801c5efa788952095586d076fed1ea4902facff8  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 822m

configs tested: 245
configs skipped: 16

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                        nsim_700_defconfig    gcc-16.1.0
arc                   randconfig-001-20260611    gcc-14.3.0
arc                   randconfig-002-20260611    gcc-14.3.0
arc                   randconfig-002-20260611    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                          pxa910_defconfig    gcc-16.1.0
arm                   randconfig-001-20260611    clang-16
arm                   randconfig-001-20260611    gcc-14.3.0
arm                   randconfig-002-20260611    gcc-10.5.0
arm                   randconfig-002-20260611    gcc-14.3.0
arm                   randconfig-003-20260611    gcc-12.5.0
arm                   randconfig-003-20260611    gcc-14.3.0
arm                   randconfig-004-20260611    clang-17
arm                   randconfig-004-20260611    gcc-14.3.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-002-20260611    clang-23
arm64                 randconfig-003-20260611    gcc-10.5.0
arm64                 randconfig-004-20260611    clang-22
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260611    gcc-16.1.0
csky                  randconfig-002-20260611    gcc-14.3.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260611    clang-16
hexagon               randconfig-001-20260611    clang-23
hexagon               randconfig-002-20260611    clang-16
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260611    clang-22
i386        buildonly-randconfig-002-20260611    clang-22
i386        buildonly-randconfig-003-20260611    clang-22
i386        buildonly-randconfig-004-20260611    clang-22
i386        buildonly-randconfig-005-20260611    clang-22
i386        buildonly-randconfig-005-20260611    gcc-14
i386        buildonly-randconfig-006-20260611    clang-22
i386        buildonly-randconfig-006-20260611    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260611    clang-22
i386                  randconfig-001-20260611    gcc-14
i386                  randconfig-002-20260611    gcc-14
i386                  randconfig-003-20260611    gcc-13
i386                  randconfig-003-20260611    gcc-14
i386                  randconfig-004-20260611    clang-22
i386                  randconfig-004-20260611    gcc-14
i386                  randconfig-005-20260611    gcc-14
i386                  randconfig-006-20260611    clang-22
i386                  randconfig-006-20260611    gcc-14
i386                  randconfig-007-20260611    gcc-14
i386                  randconfig-011-20260611    gcc-14
i386                  randconfig-012-20260611    gcc-14
i386                  randconfig-013-20260611    gcc-14
i386                  randconfig-014-20260611    gcc-12
i386                  randconfig-015-20260611    clang-22
i386                  randconfig-016-20260611    gcc-14
i386                  randconfig-017-20260611    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260611    clang-16
loongarch             randconfig-001-20260611    clang-18
loongarch             randconfig-002-20260611    clang-16
loongarch             randconfig-002-20260611    clang-18
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
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
nios2                 randconfig-001-20260611    clang-16
nios2                 randconfig-001-20260611    gcc-11.5.0
nios2                 randconfig-002-20260611    clang-16
nios2                 randconfig-002-20260611    gcc-11.5.0
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
parisc                randconfig-001-20260611    gcc-8.5.0
parisc                randconfig-002-20260611    gcc-13.4.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-002-20260611    gcc-8.5.0
powerpc                     taishan_defconfig    clang-21
powerpc64             randconfig-001-20260611    gcc-8.5.0
powerpc64             randconfig-002-20260611    gcc-12.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260611    gcc-12.5.0
riscv                 randconfig-001-20260611    gcc-8.5.0
riscv                 randconfig-002-20260611    clang-23
riscv                 randconfig-002-20260611    gcc-12.5.0
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260611    gcc-11.5.0
s390                  randconfig-001-20260611    gcc-12.5.0
s390                  randconfig-002-20260611    clang-23
s390                  randconfig-002-20260611    gcc-12.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-23
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260611    gcc-12.5.0
sh                    randconfig-002-20260611    gcc-10.5.0
sh                    randconfig-002-20260611    gcc-12.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260611    gcc-15.2.0
sparc                 randconfig-001-20260611    gcc-16.1.0
sparc                 randconfig-002-20260611    gcc-15.2.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260611    clang-23
sparc64               randconfig-001-20260611    gcc-15.2.0
sparc64               randconfig-002-20260611    gcc-11.5.0
sparc64               randconfig-002-20260611    gcc-15.2.0
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260611    clang-23
um                    randconfig-001-20260611    gcc-15.2.0
um                    randconfig-002-20260611    clang-23
um                    randconfig-002-20260611    gcc-15.2.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260611    gcc-14
x86_64      buildonly-randconfig-002-20260611    clang-22
x86_64      buildonly-randconfig-002-20260611    gcc-14
x86_64      buildonly-randconfig-003-20260611    clang-22
x86_64      buildonly-randconfig-003-20260611    gcc-14
x86_64      buildonly-randconfig-004-20260611    gcc-14
x86_64      buildonly-randconfig-005-20260611    clang-22
x86_64      buildonly-randconfig-005-20260611    gcc-14
x86_64      buildonly-randconfig-006-20260611    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260611    clang-22
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260611    clang-22
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260611    gcc-12
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260611    clang-22
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260611    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260611    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260611    clang-22
x86_64                randconfig-011-20260611    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260611    gcc-14
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260611    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260611    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260611    gcc-14
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260611    clang-22
x86_64                randconfig-016-20260611    gcc-14
x86_64                randconfig-071-20260611    clang-22
x86_64                randconfig-072-20260611    clang-22
x86_64                randconfig-073-20260611    clang-22
x86_64                randconfig-073-20260611    gcc-14
x86_64                randconfig-074-20260611    clang-22
x86_64                randconfig-075-20260611    clang-22
x86_64                randconfig-076-20260611    clang-22
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
xtensa                randconfig-001-20260611    gcc-15.2.0
xtensa                randconfig-001-20260611    gcc-8.5.0
xtensa                randconfig-002-20260611    gcc-15.2.0
xtensa                randconfig-002-20260611    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
