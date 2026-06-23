Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011AF28B4E2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jun 2026 11:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213340; cv=none; b=giIYo6MyPbqEnUTDZODbJJLdnIq6QG+pfivzmE3BzXlWRdP+xkVPRGflUF11gjrkPoQfIaPCdB2AKx9ABeeLgojghgjbi0PGyZ1kIF0b2Yr88zRqE/+8HnsbQzKtsHbBJeg/qxdAwB+lL7cdYKn+k9LTmQbUvNo4IUAssbWwFnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213340; c=relaxed/simple;
	bh=KcNq6s9nGMaY0etdzTWCo/MpQoTAMzGDSY7HSbCPM5o=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Av8HFJq4vUXWujrzo7dF+pMImNWoQ6LQhR5TKIVAYmbEmEiwJ6TpAPaYpiOXDTrBEtK13dsyOTapd38OPkFzhUUz83506YDV1q9OhxijMzFpaWErR+Iwiy9BpFPDDApvESkfxL5FpD/r/Bv/YLiEW1xUHafIsKlrh0Ry3BYNSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AF0LI7X1; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AF0LI7X1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782213339; x=1813749339;
  h=date:from:to:cc:subject:message-id;
  bh=KcNq6s9nGMaY0etdzTWCo/MpQoTAMzGDSY7HSbCPM5o=;
  b=AF0LI7X1Hmkot7bbPf0aK53QAiAI6pRM63FoGyS2GbCygPOd9yv3CBwz
   /eaUd/fDqKffyqDP4s2Ym2py176OdxLjUTav54q9sNJOfWfbwzUBxemPS
   0XnjgsZNhJGmOsluHHSy2CVDEF45S9zXP8yIgpXtmUeqloLb2UZ5f2HiL
   ihb0w8UHgWi8YIWBlMR/ocHTA3XpIt51keagwFdZjdfVOYoWs3EYOsqb4
   hNjdZVzZAKSbBhg6hzdpdN+98YClHXtbba40GGm9zWkwy45GZfYDyCLgc
   QGCd1Sz/ao0hXxsU1DTPSlmlxnJRIstMHjkputux8lwjkr5JfoRWWCG1v
   g==;
X-CSE-ConnectionGUID: NyJWaZeHTT6b+dxFjgfJDA==
X-CSE-MsgGUID: FdtPH/gRRluAYWDITBE01Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="82822570"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="82822570"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 04:15:38 -0700
X-CSE-ConnectionGUID: ftyivKRmSWyp+Td5ZW0/DA==
X-CSE-MsgGUID: GF79X0GWTcyVTiGInOG51A==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 23 Jun 2026 04:15:36 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wbz6M-000000002Th-0utB;
	Tue, 23 Jun 2026 11:15:34 +0000
Date: Tue, 23 Jun 2026 19:15:30 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 189ce3c81f8188fb737d59a8a8784f074e830238
Message-ID: <202606231918.8lBNPlJx-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 189ce3c81f8188fb737d59a8a8784f074e830238  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 771m

configs tested: 306
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
arc                   randconfig-001-20260623    clang-23
arc                   randconfig-001-20260623    gcc-10.5.0
arc                   randconfig-002-20260623    clang-23
arc                   randconfig-002-20260623    gcc-16.1.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260623    clang-23
arm                   randconfig-002-20260623    clang-23
arm                   randconfig-002-20260623    gcc-10.5.0
arm                   randconfig-003-20260623    clang-23
arm                   randconfig-004-20260623    clang-23
arm                   randconfig-004-20260623    gcc-14.3.0
arm                           spitz_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    clang-23
arm64                 randconfig-001-20260623    clang-23
arm64                 randconfig-001-20260623    gcc-14.3.0
arm64                          randconfig-002    clang-23
arm64                 randconfig-002-20260623    clang-23
arm64                 randconfig-002-20260623    gcc-14.3.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260623    clang-23
arm64                 randconfig-003-20260623    gcc-14.3.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260623    clang-23
arm64                 randconfig-004-20260623    gcc-14.3.0
arm64                 randconfig-004-20260623    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    clang-23
csky                  randconfig-001-20260623    clang-23
csky                  randconfig-001-20260623    gcc-14.3.0
csky                  randconfig-001-20260623    gcc-16.1.0
csky                           randconfig-002    clang-23
csky                  randconfig-002-20260623    clang-23
csky                  randconfig-002-20260623    gcc-14.3.0
csky                  randconfig-002-20260623    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260623    clang-23
hexagon               randconfig-001-20260623    gcc-11.5.0
hexagon               randconfig-001-20260623    gcc-8.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260623    clang-18
hexagon               randconfig-002-20260623    gcc-11.5.0
hexagon               randconfig-002-20260623    gcc-8.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260623    clang-22
i386        buildonly-randconfig-001-20260623    gcc-14
i386        buildonly-randconfig-002-20260623    gcc-14
i386        buildonly-randconfig-003-20260623    gcc-14
i386        buildonly-randconfig-004-20260623    gcc-14
i386        buildonly-randconfig-005-20260623    gcc-14
i386        buildonly-randconfig-006-20260623    clang-22
i386        buildonly-randconfig-006-20260623    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260623    clang-22
i386                  randconfig-001-20260623    gcc-14
i386                  randconfig-002-20260623    clang-22
i386                  randconfig-003-20260623    clang-22
i386                  randconfig-003-20260623    gcc-14
i386                  randconfig-004-20260623    clang-22
i386                  randconfig-004-20260623    gcc-14
i386                  randconfig-005-20260623    clang-22
i386                  randconfig-006-20260623    clang-22
i386                  randconfig-007-20260623    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260623    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260623    clang-22
i386                  randconfig-012-20260623    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260623    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260623    clang-22
i386                  randconfig-014-20260623    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260623    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260623    clang-22
i386                  randconfig-016-20260623    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260623    clang-22
i386                  randconfig-017-20260623    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260623    gcc-11.5.0
loongarch             randconfig-001-20260623    gcc-14.3.0
loongarch             randconfig-001-20260623    gcc-8.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260623    gcc-11.5.0
loongarch             randconfig-002-20260623    gcc-16.1.0
loongarch             randconfig-002-20260623    gcc-8.5.0
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
nios2                            alldefconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260623    gcc-11.5.0
nios2                 randconfig-001-20260623    gcc-8.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260623    gcc-11.5.0
nios2                 randconfig-002-20260623    gcc-8.5.0
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
parisc                         randconfig-001    gcc-11.5.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260623    gcc-11.5.0
parisc                         randconfig-002    gcc-11.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260623    gcc-11.5.0
parisc                randconfig-002-20260623    gcc-8.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      ppc44x_defconfig    clang-17
powerpc                        randconfig-001    gcc-10.5.0
powerpc                        randconfig-001    gcc-11.5.0
powerpc               randconfig-001-20260623    clang-23
powerpc               randconfig-001-20260623    gcc-11.5.0
powerpc                        randconfig-002    gcc-11.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260623    clang-23
powerpc               randconfig-002-20260623    gcc-11.5.0
powerpc64                      randconfig-001    clang-16
powerpc64                      randconfig-001    gcc-11.5.0
powerpc64             randconfig-001-20260623    clang-23
powerpc64             randconfig-001-20260623    gcc-11.5.0
powerpc64                      randconfig-002    clang-23
powerpc64                      randconfig-002    gcc-11.5.0
powerpc64             randconfig-002-20260623    gcc-11.5.0
powerpc64             randconfig-002-20260623    gcc-12.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260623    clang-23
riscv                 randconfig-001-20260623    gcc-8.5.0
riscv                 randconfig-002-20260623    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260623    gcc-15.2.0
s390                  randconfig-001-20260623    gcc-8.5.0
s390                  randconfig-002-20260623    clang-19
s390                  randconfig-002-20260623    gcc-8.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260623    gcc-16.1.0
sh                    randconfig-001-20260623    gcc-8.5.0
sh                    randconfig-002-20260623    gcc-16.1.0
sh                    randconfig-002-20260623    gcc-8.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260623    gcc-8.5.0
sparc                 randconfig-002-20260623    gcc-11.5.0
sparc                 randconfig-002-20260623    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260623    gcc-8.5.0
sparc64               randconfig-002-20260623    clang-21
sparc64               randconfig-002-20260623    gcc-8.5.0
um                               allmodconfig    clang-17
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260623    clang-23
um                    randconfig-001-20260623    gcc-8.5.0
um                    randconfig-002-20260623    gcc-14
um                    randconfig-002-20260623    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260623    clang-22
x86_64      buildonly-randconfig-001-20260623    gcc-14
x86_64      buildonly-randconfig-002-20260623    clang-22
x86_64      buildonly-randconfig-002-20260623    gcc-14
x86_64      buildonly-randconfig-003-20260623    clang-22
x86_64      buildonly-randconfig-004-20260623    clang-22
x86_64      buildonly-randconfig-005-20260623    clang-22
x86_64      buildonly-randconfig-006-20260623    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260623    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260623    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                         randconfig-003    gcc-14
x86_64                randconfig-003-20260623    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                         randconfig-004    gcc-14
x86_64                randconfig-004-20260623    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260623    clang-22
x86_64                randconfig-005-20260623    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                         randconfig-006    gcc-14
x86_64                randconfig-006-20260623    clang-22
x86_64                randconfig-006-20260623    gcc-14
x86_64                randconfig-011-20260623    clang-22
x86_64                randconfig-011-20260623    gcc-14
x86_64                randconfig-012-20260623    gcc-14
x86_64                randconfig-013-20260623    clang-22
x86_64                randconfig-013-20260623    gcc-14
x86_64                randconfig-014-20260623    clang-22
x86_64                randconfig-014-20260623    gcc-14
x86_64                randconfig-015-20260623    gcc-14
x86_64                randconfig-016-20260623    clang-22
x86_64                randconfig-016-20260623    gcc-14
x86_64                randconfig-071-20260623    gcc-14
x86_64                randconfig-072-20260623    gcc-14
x86_64                randconfig-073-20260623    gcc-14
x86_64                randconfig-074-20260623    gcc-14
x86_64                randconfig-075-20260623    gcc-14
x86_64                randconfig-076-20260623    clang-22
x86_64                randconfig-076-20260623    gcc-14
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
xtensa                randconfig-001-20260623    gcc-8.5.0
xtensa                randconfig-002-20260623    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
