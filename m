Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793464069;
	b=N/LW7IKUdhiY5xTlOpZ7RMszHrqXrYKBUN9TlYln74BojBM0K3LuHUJverY8EKMPR+ff
	 YUQX1mHt/GpclqgPQBAWw094dSxEbJ4Z2zdqpei3GcFOZWbJa/iTJGYDEHp3x2UKWir31
	 hfuTO+TGM6KXwzYaW0ALPcv7Wx93rAPWrgXHQbd2jh4r9akQljnIp1KN1Rg6FiE1Jxc6E
	 oVJGou2kWUL7G5eZVaZzV/L0Ukrq2twWSEKVMLaxOR81iyV/xN1HG2WY7xlhhsfuLUGM3
	 VPm2BdjLX8fv8XDyaWPetLPDLH11E3FXLXhkXOw+gg04LUO1lvZB/YmPAk6Cn8KHDAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793464069;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=UVVdTSFlwxyqD/9fw01xgyqC8L1ZKUkJ/4Vb6MjowdE=;
	b=zxkjXe0V3jCPFiusuOD7zsX24nKL1/LExLnDQ9fkPr1JdnzpUNH52ZuYDVuqM6IA1yG8
	 jgJRT3mSwZ0JDKCBmgdtvHJGpEGaqGWm4RaxtJV5QkbtQ+rVvXNhnxvSSOs8tUc/2ZJuI
	 5KXHcEimzzVVG18CT5EQrlc2OSXqG66cUbxNu80dliK9b/aFnuPSiAHW0B7jzc3n50y1H
	 Lb+5Ny2CMJQ62n8G9qSqaA7SEfnI9F8aKbByXxRpvZx/q7MtTh3/kGBPe8uRb4V2kwd+g
	 9+34oIFk3GLGE/Ct5gwjnhL+Au1EfBBGiwmRt0in6Y1mW1VWGKTHsbIsfKGrGOpAWdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XroL3Nxk;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51685606A31A
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 16:27:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51685606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XroL3Nxk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793464068; x=1825000068;
  h=date:from:to:cc:subject:message-id;
  bh=1JMBdD6kmsJXQXLrXcqnjEnGPYiEwTJuslCd16FCcGY=;
  b=XroL3Nxk5fD4S8FqTgnzW4nvrL45AeNn7ZaVlPMB7b7V4TeHJD3BDnD2
   K7deK09ryA5x/UUHvnxoBFBsylfOEy9fTmd5nqLoTRqLHU5RZsT9zaPlj
   2Toq6dDkqqoKkVqLEA44R2uac7s3nrDzVWSpAzQoM4quPfB+3jhdYoYGL
   ++wxMsQjCWzSTPysmz9KjwYu+VpWDUXE56eKeqDG8RGK6TTga2EN1Gr3o
   vVdE9OX3U6CV70O7BcgChx5VqSdvxQ0P2ULWgmLinri0sq90pqwArVsnk
   BOhJ+9262uHlS1D/Ff2nkJSalkaNzzPCyBVQrfUFOOr3YJnMhkMzSofZq
   w==;
X-CSE-ConnectionGUID: hBQjKI/JQJOZsmXEnJfCHQ==
X-CSE-MsgGUID: hBtWxw6YQZmvrztjkGL0zQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11952"; a="2232490"
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="2232490"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2026 09:27:47 -0700
X-CSE-ConnectionGUID: UB1lXirFR+e/lvukiJcyYQ==
X-CSE-MsgGUID: vcMsiHUZTi2qCpCKgHjBTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="6027981"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 31 Oct 2026 09:27:45 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNBvh-00000000cyi-3zh3;
	Sat, 31 Oct 2026 16:27:41 +0000
Date: Sun, 01 Nov 2026 00:27:24 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 243e8cdab64129d6207c398f8cf5fbb1962ff7e1
Message-ID: <202611010020.uHV1BRFO-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 243e8cdab64129d6207c398f8cf5fbb1962ff7e1  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 966m

configs tested: 166
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261031    gcc-9.5.0
arc                   randconfig-1001-20261031    gcc-8.5.0
arc                     vdk_hs38_smp_defconfig    gcc-16.2.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                          mv78xx0_defconfig    clang-24
arm                   randconfig-1000-20261031    clang-17
arm                   randconfig-1001-20261031    gcc-13.5.0
arm                   randconfig-1002-20261031    clang-21
arm                   randconfig-1003-20261031    gcc-13.5.0
arm                           sp7021_defconfig    gcc-16.2.0
arm                          wpcm450_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261031    gcc-8.5.0
arm64                 randconfig-1001-20261031    clang-24
arm64                 randconfig-1002-20261031    gcc-10.5.0
arm64                 randconfig-1003-20261031    gcc-12.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261031    gcc-13.5.0
csky                  randconfig-1001-20261031    gcc-16.2.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261031    clang-24
hexagon               randconfig-1001-20261031    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261031    clang-22
i386        buildonly-randconfig-1001-20261031    clang-22
i386        buildonly-randconfig-1002-20261031    clang-22
i386        buildonly-randconfig-1003-20261031    clang-22
i386        buildonly-randconfig-1004-20261031    gcc-14
i386        buildonly-randconfig-1005-20261031    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261031    gcc-13
i386                  randconfig-1001-20261031    gcc-14
i386                  randconfig-1002-20261031    clang-22
i386                  randconfig-1003-20261031    gcc-14
i386                  randconfig-1004-20261031    clang-22
i386                  randconfig-1005-20261031    clang-22
i386                  randconfig-1006-20261031    clang-22
i386                  randconfig-1007-20261031    clang-22
i386                  randconfig-1008-20261031    clang-22
i386                  randconfig-1009-20261031    clang-22
i386                  randconfig-1010-20261031    gcc-14
i386                  randconfig-1011-20261031    gcc-12
i386                  randconfig-1012-20261031    gcc-14
i386                  randconfig-1013-20261031    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261031    clang-24
loongarch             randconfig-1001-20261031    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261031    gcc-11.5.0
nios2                 randconfig-1001-20261031    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261031    gcc-15.3.0
parisc                randconfig-1001-20261031    gcc-13.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261031    gcc-12.5.0
powerpc               randconfig-1001-20261031    clang-24
powerpc                      skiroot_defconfig    clang-24
powerpc64             randconfig-1000-20261031    clang-24
powerpc64             randconfig-1001-20261031    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261031    gcc-8.5.0
riscv                 randconfig-1001-20261031    gcc-8.5.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261031    gcc-12.5.0
s390                  randconfig-1001-20261031    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                             hp6xx_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261031    gcc-9.5.0
sh                    randconfig-1001-20261031    gcc-16.2.0
sh                            se7619_defconfig    gcc-16.2.0
sh                    secureedge5410_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261031    gcc-8.5.0
sparc                 randconfig-1001-20261031    gcc-15.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261031    gcc-12.5.0
sparc64               randconfig-1001-20261031    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261031    gcc-12
um                    randconfig-1001-20261031    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261031    gcc-14
x86_64      buildonly-randconfig-1001-20261031    gcc-14
x86_64      buildonly-randconfig-1002-20261031    gcc-14
x86_64      buildonly-randconfig-1003-20261031    clang-22
x86_64      buildonly-randconfig-1004-20261031    gcc-14
x86_64      buildonly-randconfig-1005-20261031    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261031    gcc-14
x86_64                randconfig-1001-20261031    gcc-14
x86_64                randconfig-1002-20261031    clang-22
x86_64                randconfig-1003-20261031    gcc-14
x86_64                randconfig-1004-20261031    clang-22
x86_64                randconfig-1005-20261031    clang-22
x86_64                randconfig-1006-20261031    gcc-14
x86_64                randconfig-1007-20261031    clang-22
x86_64                randconfig-1008-20261031    clang-22
x86_64                randconfig-1009-20261031    clang-22
x86_64                randconfig-1010-20261031    gcc-14
x86_64                randconfig-1011-20261031    clang-22
x86_64                randconfig-1012-20261031    gcc-12
x86_64                randconfig-1013-20261031    gcc-14
x86_64                randconfig-1014-20261031    gcc-14
x86_64                randconfig-1015-20261031    clang-22
x86_64                randconfig-1016-20261031    gcc-14
x86_64                randconfig-1017-20261031    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261031    gcc-11.5.0
xtensa                randconfig-1001-20261031    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
