Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0946528373
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783708457; cv=none; b=VR4L4cOT9M2pAUQi1nzXrCPQOyjSKPkwkcCpRgWiDsMGqXJ1YLeCoLNcCMkxrfDB+C+m4KslXI51qBHxKT7HGJmJSAwwHbzSXlFNIVnNd3VedRwGBAl91qIOM93BxZwfKMIJQHwwxaoUskaSTo5aG850HQJ5641hI1b3SUhqt4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783708457; c=relaxed/simple;
	bh=ZcIjVUKfGR42ZJkIibRURQlrMGo5jsp/NGFaiuKysCM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=amsd3BshqS1+PpS6NRKcPheDzuENTUW6VLwQgZ8HoEH2sefkfhhzVFJNKlcptwe+YmmfBQEnwc7otzdle1gHuWK+ZpS2ezzqCqTQ1urY1AnXQsfAXvVDo8usDsGRbytQt/FGpmFGHdonp1GnXEdYzuZXt7rzGHE2VCXYAvpnshw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HMBuyIvw; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HMBuyIvw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783708455; x=1815244455;
  h=date:from:to:cc:subject:message-id;
  bh=ZcIjVUKfGR42ZJkIibRURQlrMGo5jsp/NGFaiuKysCM=;
  b=HMBuyIvw+ZirqKEG0oFoSKigxuGtb2+kCs+BExd9VSB+53mAoYbsEhFX
   YiYIv4p8CyClHp6Wskwv1s1NiNh1ueu7mS6ZUuNwAKacewtLM1yjSjRMe
   YPxQYcpHdXQ2Qntw8dMNqZhtTz6T0RdcwlR/6LG4rixoaid7jKp15qGh0
   4Q5hvJMtAOo/pXFH5O5MRJCRY46Z5Wyc4kvGF51NUFq3nnRuvswl8I99m
   G0qR4NalIetsolKvRa3oedCxTfPUk0oaVpAe/NZ6vrdmyW+KPlvKmL4oG
   UAwHXaPPDq5FGwq3W7bP6Wj4vSOcEiw1QIxDOqVFPDMV5NcqCKjxD1KSX
   g==;
X-CSE-ConnectionGUID: qA5Jb3m8QfmtMEFdq5Wb7A==
X-CSE-MsgGUID: XtAJbRJ2T4eD1WE/uGYilQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71932737"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71932737"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 11:34:14 -0700
X-CSE-ConnectionGUID: TPCtsg/PSiqk0+YKAV80cA==
X-CSE-MsgGUID: U5/+YWenT/+AAoriCRNxeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259281299"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 10 Jul 2026 11:34:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wiG37-00000000JG5-3nAE;
	Fri, 10 Jul 2026 18:34:09 +0000
Date: Sat, 11 Jul 2026 02:33:52 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 1e692e85500fd3a971da0241f044f4572b2be8b6
Message-ID: <202607110232.GeLHzsfO-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1e692e85500fd3a971da0241f044f4572b2be8b6  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com

    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
`-- microblaze-randconfig-r071-20260710
    `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

elapsed time: 749m

configs tested: 244
configs skipped: 12

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
arc                            randconfig-001    clang-23
arc                   randconfig-001-20260710    clang-23
arc                   randconfig-001-20260710    gcc-12.5.0
arc                            randconfig-002    clang-23
arc                   randconfig-002-20260710    clang-23
arc                   randconfig-002-20260710    gcc-10.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                            randconfig-001    clang-23
arm                   randconfig-001-20260710    clang-23
arm                   randconfig-001-20260710    gcc-8.5.0
arm                            randconfig-002    clang-23
arm                   randconfig-002-20260710    clang-23
arm                   randconfig-002-20260710    gcc-16.1.0
arm                            randconfig-003    clang-23
arm                   randconfig-003-20260710    clang-23
arm                            randconfig-004    clang-23
arm                   randconfig-004-20260710    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260710    gcc-10.5.0
arm64                 randconfig-001-20260710    gcc-8.5.0
arm64                 randconfig-002-20260710    gcc-10.5.0
arm64                 randconfig-002-20260710    gcc-8.5.0
arm64                 randconfig-003-20260710    gcc-10.5.0
arm64                 randconfig-003-20260710    gcc-16.1.0
arm64                 randconfig-004-20260710    gcc-10.5.0
arm64                 randconfig-004-20260710    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260710    gcc-10.5.0
csky                  randconfig-002-20260710    gcc-10.5.0
csky                  randconfig-002-20260710    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260710    clang-23
hexagon               randconfig-001-20260710    gcc-12.5.0
hexagon               randconfig-002-20260710    clang-20
hexagon               randconfig-002-20260710    gcc-12.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260710    clang-22
i386        buildonly-randconfig-002-20260710    clang-22
i386        buildonly-randconfig-002-20260710    gcc-14
i386        buildonly-randconfig-003-20260710    clang-22
i386        buildonly-randconfig-003-20260710    gcc-14
i386        buildonly-randconfig-004-20260710    clang-22
i386        buildonly-randconfig-005-20260710    clang-22
i386        buildonly-randconfig-006-20260710    clang-22
i386                                defconfig    clang-22
i386                  randconfig-001-20260710    gcc-14
i386                  randconfig-002-20260710    clang-22
i386                  randconfig-003-20260710    gcc-14
i386                  randconfig-004-20260710    clang-22
i386                  randconfig-005-20260710    gcc-14
i386                  randconfig-006-20260710    clang-22
i386                  randconfig-007-20260710    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260710    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260710    clang-22
i386                  randconfig-012-20260710    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260710    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260710    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260710    clang-22
i386                  randconfig-015-20260710    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260710    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260710    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260710    gcc-12.5.0
loongarch             randconfig-002-20260710    clang-18
loongarch             randconfig-002-20260710    gcc-12.5.0
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
nios2                 randconfig-001-20260710    gcc-12.5.0
nios2                 randconfig-001-20260710    gcc-8.5.0
nios2                 randconfig-002-20260710    gcc-12.5.0
nios2                 randconfig-002-20260710    gcc-8.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260710    gcc-9.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260710    gcc-11.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                       eiger_defconfig    clang-23
powerpc                 mpc836x_rdk_defconfig    clang-23
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260710    gcc-14.3.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260710    clang-17
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260710    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260710    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260710    clang-17
riscv                 randconfig-002-20260710    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260710    gcc-9.5.0
s390                  randconfig-002-20260710    gcc-8.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260710    gcc-16.1.0
sh                    randconfig-002-20260710    gcc-12.5.0
sh                   sh7724_generic_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260710    gcc-15.2.0
sparc                 randconfig-002-20260710    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260710    gcc-15.2.0
sparc64               randconfig-002-20260710    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260710    gcc-14
um                    randconfig-002-20260710    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260710    clang-22
x86_64      buildonly-randconfig-001-20260710    gcc-14
x86_64      buildonly-randconfig-002-20260710    clang-22
x86_64      buildonly-randconfig-003-20260710    clang-22
x86_64      buildonly-randconfig-004-20260710    clang-22
x86_64      buildonly-randconfig-005-20260710    clang-22
x86_64      buildonly-randconfig-006-20260710    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260710    clang-22
x86_64                randconfig-002-20260710    gcc-14
x86_64                randconfig-003-20260710    gcc-14
x86_64                randconfig-004-20260710    clang-22
x86_64                randconfig-005-20260710    gcc-14
x86_64                randconfig-006-20260710    clang-22
x86_64                randconfig-011-20260710    clang-22
x86_64                randconfig-011-20260710    gcc-14
x86_64                randconfig-012-20260710    clang-22
x86_64                randconfig-012-20260710    gcc-14
x86_64                randconfig-013-20260710    clang-22
x86_64                randconfig-014-20260710    clang-22
x86_64                randconfig-015-20260710    clang-22
x86_64                randconfig-015-20260710    gcc-14
x86_64                randconfig-016-20260710    clang-22
x86_64                randconfig-071-20260710    clang-22
x86_64                randconfig-071-20260710    gcc-14
x86_64                randconfig-072-20260710    gcc-14
x86_64                randconfig-073-20260710    gcc-14
x86_64                randconfig-074-20260710    clang-22
x86_64                randconfig-074-20260710    gcc-14
x86_64                randconfig-075-20260710    clang-22
x86_64                randconfig-075-20260710    gcc-14
x86_64                randconfig-076-20260710    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-002-20260710    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
