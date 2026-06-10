Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409EF165F1A
	for <mm-commits@vger.kernel.org>; Wed, 10 Jun 2026 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781109575; cv=none; b=nQ0lVEoWhodNwIrJw+UTss4j0ASpHnnCG9c7G9J+MZ5tBERtyuHeB/zBY6hgcc3Buo62rWfKnFq01cBfliFP4VZuQPf0Xg+k6eQ4E3QkXiAOQpQTY34CXd+5Yj+f7Op54tumKxCOUQ4TvT0+Q/S/8DHr8JQb6J3Q/azlPBORRo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781109575; c=relaxed/simple;
	bh=9Q7IvpLrTuof1t/GoDAB3Jy5qM/57hj2dw1VxI/aaYk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ewAvDcNVDHfm8RyYpyV/Nb3uY4uyMPI0jC7Xm314nWgNbnjOTUarLWz4SdMdS5LWpdfwtHWWzH+WJOsaIrvJD6sVOwZObRcKfIMdAyvf5DD8U+lLV0iQdjxzwLyTUyMVWKYz6fM5KgCFRH6m1QSO3k3HKPvRvbARPBFXJ4lcYYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3o0m6pL; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3o0m6pL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781109573; x=1812645573;
  h=date:from:to:cc:subject:message-id;
  bh=9Q7IvpLrTuof1t/GoDAB3Jy5qM/57hj2dw1VxI/aaYk=;
  b=H3o0m6pLqORUKiwQ1PC3Ac3PwZCyH8VR3yoGFUVGRkngvGMUBemihoYS
   ZVAZ2Zj+ZcGYqJF3ilXIun7sT+d/tFr/rSN1FS2Yedx2HEV+voD9yJABm
   WtGxLPiDeSoDEuN4eFukKsX2YJ3JU7NMbhmDFSs0LYAN3WWzN9RiLNp9h
   Yav5KlItZQBQW9AESM9s8851w+ORtUr/WJyBaoLWA/ie7m0Wdnbt4G7ni
   CHvjhRR+XgPkUsDUcA3Rj0dU560O+pDJtsaqK+kLJnFwLlajoLpTK/UsA
   ygkA7wj4cNAJmFjZipYOHAXWjW23qP9C8qpX5xHr8eWAA0eSB2GGGS7DJ
   Q==;
X-CSE-ConnectionGUID: I3iWD2zPTkKyXMYMF9wMSg==
X-CSE-MsgGUID: cVM8FzeNRB6Ne9F+BHWC5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="107346946"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="107346946"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:39:32 -0700
X-CSE-ConnectionGUID: AwVAy2ZOScKWDZgH+YGaXg==
X-CSE-MsgGUID: Py6fpl4zQIS8Z+60EdBurQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="243272855"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 10 Jun 2026 09:39:31 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wXLxg-00000000LfG-2KfK;
	Wed, 10 Jun 2026 16:39:28 +0000
Date: Thu, 11 Jun 2026 00:38:40 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 ce70d5abbf4f9930a07eddb06f40a0ea3494e33a
Message-ID: <202606110032.LMQksLnm-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: ce70d5abbf4f9930a07eddb06f40a0ea3494e33a  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 855m

configs tested: 265
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
arc                   randconfig-001-20260610    gcc-8.5.0
arc                   randconfig-002-20260610    gcc-8.5.0
arc                   randconfig-002-20260610    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260610    clang-23
arm                   randconfig-001-20260610    gcc-8.5.0
arm                   randconfig-002-20260610    clang-20
arm                   randconfig-002-20260610    gcc-8.5.0
arm                   randconfig-003-20260610    clang-23
arm                   randconfig-003-20260610    gcc-8.5.0
arm                   randconfig-004-20260610    clang-23
arm                   randconfig-004-20260610    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260610    gcc-11.5.0
arm64                 randconfig-002-20260610    gcc-11.5.0
arm64                 randconfig-002-20260610    gcc-9.5.0
arm64                 randconfig-003-20260610    gcc-11.5.0
arm64                 randconfig-003-20260610    gcc-8.5.0
arm64                 randconfig-004-20260610    clang-23
arm64                 randconfig-004-20260610    gcc-11.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260610    gcc-11.5.0
csky                  randconfig-001-20260610    gcc-9.5.0
csky                  randconfig-002-20260610    gcc-11.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260610    clang-22
hexagon               randconfig-001-20260610    clang-23
hexagon               randconfig-002-20260610    clang-22
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260610    gcc-14
i386        buildonly-randconfig-002-20260610    gcc-14
i386        buildonly-randconfig-003-20260610    gcc-14
i386        buildonly-randconfig-004-20260610    gcc-14
i386        buildonly-randconfig-005-20260610    gcc-14
i386        buildonly-randconfig-006-20260610    clang-22
i386        buildonly-randconfig-006-20260610    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260610    gcc-14
i386                  randconfig-002-20260610    gcc-14
i386                  randconfig-003-20260610    clang-22
i386                  randconfig-004-20260610    gcc-14
i386                  randconfig-005-20260610    clang-22
i386                  randconfig-006-20260610    gcc-14
i386                  randconfig-007-20260610    gcc-14
i386                  randconfig-011-20260610    clang-22
i386                  randconfig-012-20260610    clang-22
i386                  randconfig-013-20260610    clang-22
i386                  randconfig-014-20260610    clang-22
i386                  randconfig-015-20260610    clang-22
i386                  randconfig-016-20260610    clang-22
i386                  randconfig-017-20260610    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260610    clang-22
loongarch             randconfig-001-20260610    gcc-16.1.0
loongarch             randconfig-002-20260610    clang-22
loongarch             randconfig-002-20260610    gcc-16.1.0
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
mips                       lemote2f_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260610    clang-22
nios2                 randconfig-001-20260610    gcc-11.5.0
nios2                 randconfig-002-20260610    clang-22
nios2                 randconfig-002-20260610    gcc-11.5.0
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
parisc                randconfig-001-20260610    gcc-8.5.0
parisc                randconfig-002-20260610    gcc-8.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260610    gcc-8.5.0
powerpc               randconfig-001-20260610    gcc-9.5.0
powerpc               randconfig-002-20260610    clang-23
powerpc               randconfig-002-20260610    gcc-8.5.0
powerpc64             randconfig-001-20260610    clang-23
powerpc64             randconfig-001-20260610    gcc-8.5.0
powerpc64             randconfig-002-20260610    gcc-10.5.0
powerpc64             randconfig-002-20260610    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-16.1.0
riscv                 randconfig-001-20260610    gcc-15.2.0
riscv                 randconfig-001-20260610    gcc-16.1.0
riscv                          randconfig-002    gcc-16.1.0
riscv                 randconfig-002-20260610    gcc-16.1.0
riscv                 randconfig-002-20260610    gcc-8.5.0
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-16.1.0
s390                  randconfig-001-20260610    clang-23
s390                  randconfig-001-20260610    gcc-16.1.0
s390                           randconfig-002    gcc-16.1.0
s390                  randconfig-002-20260610    clang-23
s390                  randconfig-002-20260610    gcc-16.1.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-23
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-16.1.0
sh                    randconfig-001-20260610    gcc-16.1.0
sh                             randconfig-002    gcc-16.1.0
sh                    randconfig-002-20260610    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-14.3.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260610    gcc-14.3.0
sparc                 randconfig-001-20260610    gcc-8.5.0
sparc                          randconfig-002    gcc-11.5.0
sparc                          randconfig-002    gcc-14.3.0
sparc                 randconfig-002-20260610    gcc-14.3.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64                        randconfig-001    gcc-14.3.0
sparc64               randconfig-001-20260610    gcc-12.5.0
sparc64               randconfig-001-20260610    gcc-14.3.0
sparc64                        randconfig-002    clang-20
sparc64                        randconfig-002    gcc-14.3.0
sparc64               randconfig-002-20260610    clang-23
sparc64               randconfig-002-20260610    gcc-14.3.0
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-23
um                             randconfig-001    gcc-14.3.0
um                    randconfig-001-20260610    clang-23
um                    randconfig-001-20260610    gcc-14.3.0
um                             randconfig-002    clang-23
um                             randconfig-002    gcc-14.3.0
um                    randconfig-002-20260610    clang-18
um                    randconfig-002-20260610    gcc-14.3.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260610    clang-22
x86_64      buildonly-randconfig-001-20260610    gcc-14
x86_64      buildonly-randconfig-002-20260610    gcc-14
x86_64      buildonly-randconfig-003-20260610    clang-22
x86_64      buildonly-randconfig-003-20260610    gcc-14
x86_64      buildonly-randconfig-004-20260610    clang-22
x86_64      buildonly-randconfig-004-20260610    gcc-14
x86_64      buildonly-randconfig-005-20260610    gcc-14
x86_64      buildonly-randconfig-006-20260610    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260610    clang-22
x86_64                randconfig-001-20260610    gcc-13
x86_64                randconfig-002-20260610    clang-22
x86_64                randconfig-002-20260610    gcc-13
x86_64                randconfig-003-20260610    gcc-13
x86_64                randconfig-004-20260610    clang-22
x86_64                randconfig-004-20260610    gcc-13
x86_64                randconfig-005-20260610    clang-22
x86_64                randconfig-005-20260610    gcc-13
x86_64                randconfig-006-20260610    gcc-13
x86_64                randconfig-011-20260610    gcc-12
x86_64                randconfig-011-20260610    gcc-14
x86_64                randconfig-012-20260610    gcc-12
x86_64                randconfig-012-20260610    gcc-14
x86_64                randconfig-013-20260610    gcc-14
x86_64                randconfig-014-20260610    gcc-12
x86_64                randconfig-014-20260610    gcc-14
x86_64                randconfig-015-20260610    gcc-14
x86_64                randconfig-016-20260610    gcc-14
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
xtensa                         randconfig-001    gcc-14.3.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260610    gcc-14.3.0
xtensa                randconfig-001-20260610    gcc-8.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                         randconfig-002    gcc-14.3.0
xtensa                randconfig-002-20260610    gcc-14.3.0
xtensa                randconfig-002-20260610    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
