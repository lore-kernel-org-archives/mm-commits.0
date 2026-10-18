Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C2938E11A
	for <mm-commits@vger.kernel.org>; Sun, 18 Oct 2026 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792352066; cv=none; b=cqal3jA8v7EERutDQG84oDozvIo/lHSY7wiesZ5+ZUXBtczHl37ekjtV7DL/5mB+4N8PzS/9qi/8p9fBFp676hs0hxGwZCH78bmWFUqT7qA0cGBM582FFK03DIk/Y3qNCFIKkGN7BY+H9tw6zECXvCFuZh3SzF8mph5f9EtGY6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792352066; c=relaxed/simple;
	bh=1pkyxdegs9CRpvDC3ugPAJJR/iE9sS/Vk2qPFfN5USg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=a81JubAWHVRYyvWzHQOxA27V3Uk03ebwhbESoeqP3HBNUOqc4OB7hgKE0fLXQZVJG4Ykzyket3jQeOATjyPIytcjCl2Ysj/H7p4COTDI3+zgFYSBK0eeP+Vux5GqYL0OClbqbRe6Lq54A/syRnYPsyr++6xIGTHu2/TstG0zv2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jb16LWdC; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jb16LWdC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792352064; x=1823888064;
  h=date:from:to:cc:subject:message-id;
  bh=1pkyxdegs9CRpvDC3ugPAJJR/iE9sS/Vk2qPFfN5USg=;
  b=Jb16LWdC1JsspXYpeXpTZ4E1ZV/ehj9s3FU6UUz+QjXPTjQLJMBLesYr
   BjKIO+4eUNi1b6+C+Sf+oVvApiGiKDfe+G2/Y7llPfx0BNL0Ww5qbQlqI
   XnvpQhbUEPGkFwbed3SsUSE6+UI2T1mRfe2Y5t129E9Z/VNdwt5swF9CD
   0tHT5ykRNS8LqLPCF67ERYMkWDNd5mle7rAWRasBHTd29BElJVlWVCeA7
   5W0pZ8jk4YYza2HPhcfjuHRL+uYZsPJMvCu0gjFY9BgjpTS4qyYngxfkY
   FCmK8OkBhuSxWEzEUy3t0TlDN+yaYH5iE0jNrJfKu7EIsgN77TEw+cVeI
   g==;
X-CSE-ConnectionGUID: xJQmOgxbQZmtvtT86GyV2Q==
X-CSE-MsgGUID: MH0bxdocQw+odNLHM/Am6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="927422"
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="927422"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 12:34:24 -0700
X-CSE-ConnectionGUID: qPW+b/EFSrmq3ebZSOo9ww==
X-CSE-MsgGUID: OVA4mWqIQ36e6zE6hjWz+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="2255135"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 18 Oct 2026 12:34:22 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIWeB-00000000KkQ-1ned;
	Sun, 18 Oct 2026 19:34:19 +0000
Date: Mon, 19 Oct 2026 03:33:39 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc
Message-ID: <202610190335.lcT6OnpY-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc  riscv: mm: exclude invalid THP PMDs from page table check

elapsed time: 829m

configs tested: 221
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             alldefconfig    gcc-16.1.0
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2311-20261018    gcc-11.5.0 sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261018    gcc-11.5.0
arc                   randconfig-1001-20261018    gcc-8.5.0
arc                   randconfig-2000-20261018    gcc-8.5.0
arc                   randconfig-2001-20261018    gcc-10.5.0
arc                  randconfig-r2106-20261018    gcc-15.2.0 cocci
arc                  randconfig-r2304-20261018    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           ep93xx_defconfig    clang-24
arm                   randconfig-1000-20261018    gcc-8.5.0
arm                   randconfig-1001-20261018    clang-19
arm                   randconfig-1002-20261018    gcc-8.5.0
arm                   randconfig-1003-20261018    gcc-11.5.0
arm                   randconfig-2000-20261018    clang-24
arm                   randconfig-2001-20261018    clang-17
arm                  randconfig-r2105-20261018    gcc-8.5.0  cocci
arm                  randconfig-r2110-20261018    clang-17   cocci
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261018    gcc-8.5.0
arm64                 randconfig-1001-20261018    gcc-14.3.0
arm64                 randconfig-1002-20261018    gcc-12.5.0
arm64                 randconfig-1003-20261018    clang-19
arm64                 randconfig-2000-20261018    gcc-11.5.0
arm64                 randconfig-2001-20261018    gcc-13.4.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261018    gcc-15.2.0
csky                  randconfig-1001-20261018    gcc-13.4.0
csky                  randconfig-2000-20261018    gcc-12.5.0
csky                  randconfig-2001-20261018    gcc-14.3.0
csky                 randconfig-r2309-20261018    gcc-16.1.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261018    clang-24
hexagon               randconfig-1001-20261018    clang-21
hexagon               randconfig-2000-20261018    clang-24
hexagon               randconfig-2001-20261018    clang-24
hexagon              randconfig-r2100-20261018    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261018    clang-22
i386        buildonly-randconfig-1001-20261018    clang-22
i386        buildonly-randconfig-1002-20261018    clang-22
i386        buildonly-randconfig-1003-20261018    clang-22
i386        buildonly-randconfig-1004-20261018    gcc-14
i386        buildonly-randconfig-1005-20261018    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261018    gcc-14
i386                  randconfig-1001-20261018    gcc-14
i386                  randconfig-1002-20261018    clang-22
i386                  randconfig-1003-20261018    clang-22
i386                  randconfig-1004-20261018    clang-22
i386                  randconfig-1005-20261018    gcc-14
i386                  randconfig-1006-20261018    gcc-14
i386                  randconfig-1007-20261018    clang-22
i386                  randconfig-1008-20261018    clang-22
i386                  randconfig-1009-20261018    clang-22
i386                  randconfig-1010-20261018    gcc-14
i386                  randconfig-1011-20261018    gcc-14
i386                  randconfig-1012-20261018    gcc-14
i386                  randconfig-1013-20261018    clang-22
i386                  randconfig-2000-20261018    clang-22
i386                  randconfig-2001-20261018    gcc-14
i386                  randconfig-2200-20261018    gcc-14     smatch
i386                  randconfig-2300-20261018    gcc-14     sparse
i386                  randconfig-2302-20261018    clang-22   sparse
i386                 randconfig-r2308-20261018    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261018    clang-24
loongarch             randconfig-1001-20261018    clang-18
loongarch             randconfig-2000-20261018    clang-24
loongarch             randconfig-2001-20261018    clang-24
loongarch            randconfig-r2303-20261018    gcc-13.4.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2101-20261018    gcc-10.5.0 cocci
m68k                 randconfig-r2111-20261018    gcc-8.5.0  cocci
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2103-20261018    gcc-8.5.0  cocci
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2200-20261018    clang-24   smatch
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261018    gcc-11.5.0
nios2                 randconfig-1001-20261018    gcc-11.5.0
nios2                 randconfig-2000-20261018    gcc-11.5.0
nios2                 randconfig-2001-20261018    gcc-10.5.0
nios2                randconfig-r2300-20261018    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2104-20261018    gcc-16.1.0 cocci
openrisc             randconfig-r2305-20261018    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261018    gcc-13.4.0
parisc                randconfig-1001-20261018    gcc-11.5.0
parisc                randconfig-2000-20261018    gcc-14.3.0
parisc                randconfig-2001-20261018    gcc-12.5.0
parisc64                             defconfig    gcc-16.1.0
powerpc                      akebono_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       cm5200_defconfig    clang-24
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc                       pasemi_defconfig    clang-24
powerpc               randconfig-1000-20261018    clang-24
powerpc               randconfig-1001-20261018    clang-24
powerpc               randconfig-2000-20261018    gcc-9.5.0
powerpc               randconfig-2001-20261018    gcc-8.5.0
powerpc              randconfig-r2202-20261018    clang-20   smatch
powerpc64             randconfig-1000-20261018    gcc-16.1.0
powerpc64             randconfig-1001-20261018    clang-24
powerpc64             randconfig-2001-20261018    gcc-10.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261019    gcc-11.5.0
riscv                 randconfig-1001-20261019    gcc-9.5.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261019    gcc-8.5.0
s390                  randconfig-1001-20261019    gcc-9.5.0
s390                 randconfig-r2108-20261018    gcc-8.5.0  cocci
s390                 randconfig-r2302-20261018    gcc-15.2.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261019    gcc-10.5.0
sh                    randconfig-1001-20261019    gcc-16.2.0
sh                    randconfig-2000-20261018    gcc-12.5.0
sh                    randconfig-2001-20261018    gcc-10.5.0
sh                            se7750_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261018    gcc-8.5.0
sparc                 randconfig-1001-20261018    gcc-13.4.0
sparc                 randconfig-2001-20261018    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261018    gcc-10.5.0
sparc64               randconfig-1001-20261018    clang-24
sparc64               randconfig-2001-20261018    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261018    clang-19
um                    randconfig-1001-20261018    gcc-14
um                    randconfig-2000-20261018    gcc-14
um                    randconfig-2001-20261018    clang-18
um                   randconfig-r2310-20261018    clang-22   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261018    gcc-14
x86_64      buildonly-randconfig-1001-20261018    clang-22
x86_64      buildonly-randconfig-1002-20261018    clang-22
x86_64      buildonly-randconfig-1003-20261018    clang-22
x86_64      buildonly-randconfig-1004-20261018    gcc-14
x86_64      buildonly-randconfig-1005-20261018    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261018    clang-22
x86_64                randconfig-1001-20261018    gcc-14
x86_64                randconfig-1002-20261018    gcc-13
x86_64                randconfig-1003-20261018    gcc-14
x86_64                randconfig-1004-20261018    clang-22
x86_64                randconfig-1005-20261018    gcc-14
x86_64                randconfig-1006-20261018    clang-22
x86_64                randconfig-1007-20261018    clang-22
x86_64                randconfig-1008-20261018    gcc-14
x86_64                randconfig-1009-20261018    gcc-14
x86_64                randconfig-1010-20261018    gcc-14
x86_64                randconfig-1011-20261018    gcc-14
x86_64                randconfig-1012-20261018    clang-22
x86_64                randconfig-1013-20261018    gcc-14
x86_64                randconfig-1014-20261018    gcc-14
x86_64                randconfig-1015-20261018    gcc-14
x86_64                randconfig-1016-20261018    clang-22
x86_64                randconfig-1017-20261018    gcc-14
x86_64                randconfig-2200-20261018    gcc-14     smatch
x86_64                randconfig-2300-20261018    gcc-14     sparse
x86_64                randconfig-2301-20261018    gcc-14     sparse
x86_64                randconfig-2302-20261018    gcc-14     sparse
x86_64               randconfig-r2301-20261018    clang-22   sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261018    gcc-8.5.0
xtensa                randconfig-1001-20261018    gcc-15.2.0
xtensa               randconfig-r2102-20261018    gcc-8.5.0  cocci
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
