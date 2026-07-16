Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCF03AEB35
	for <mm-commits@vger.kernel.org>; Thu, 16 Jul 2026 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237752; cv=none; b=sLscV5knM5DIMSla6PD+eOGq4gpGojLiEBGCqiUz3HAuEz4Pa58HaNUU0RLsJTtMqLGKIEr2or01dGRyRVjzb4T1VQJHwuEQEXjlMLEOyzd9fm/Fxt10wQjrGX6RaUpvpREQ7u9bNJM4M7N6jGCDCiyEdGu28mKo0u0i4N9OJYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237752; c=relaxed/simple;
	bh=a6yFI7aDgAffL/bIbOD7svnq1zNIaV7l335CCnMyWZE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=hzX37LYqlVGCCFV3r+kUOMymyNRC6sdx7/l2jX+0sm0oBBwFKGVeK2E9KIHRC4DJwuktpkBz+VOM6cDmgAc2/kBRP6c0VbjLnfOD5DvxAMdrfKXShV0aGnD1ZuWww3X4F6sxdME0piu5v9nE1PROzDrmhxxHz5xG6f9LjCGjrYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=brGSyxkl; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="brGSyxkl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784237751; x=1815773751;
  h=date:from:to:cc:subject:message-id;
  bh=a6yFI7aDgAffL/bIbOD7svnq1zNIaV7l335CCnMyWZE=;
  b=brGSyxklg8FDyjNgcFkLF9IB9PQEJb98IcxihImt+K/MTkRkTN00ABdS
   mhYlQUL3PT8COVCvzAyq31bo7LrLMB2paKvgz72/ltqfBjC+udtWFTTbg
   wed3apYXubDbV/kUoou8GcaBTDhvTS7DoJcPXzl/sdNSR2/gwbeO8/H9f
   EgxTmY/egI6c9vX7tfzTND8ZaovzXp4nW+IKfJMWTuq07BMGyQuNbrS/n
   qAvugbe8EDuNHf+u1MBdTS8SprUizjYL6QiDHzAroLhhDz09zIQwYFiFC
   dpxKFIc1ic8OkChSeHUomCCzVB1OOF5agFSp78tSPcsT31+K4BiKNrtBb
   g==;
X-CSE-ConnectionGUID: BwFxZ7WiTYCYkb94reyD6Q==
X-CSE-MsgGUID: K0Q68bF4T5eb21m73yFM6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="85002919"
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="85002919"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 14:35:50 -0700
X-CSE-ConnectionGUID: OWAnvAM3RXiUbF3VLwutpA==
X-CSE-MsgGUID: aZrc3psrRtC+vxqqMbw+Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="252614856"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 16 Jul 2026 14:35:48 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wkTk1-00000000QGS-2fzV;
	Thu, 16 Jul 2026 21:35:41 +0000
Date: Fri, 17 Jul 2026 05:19:51 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 4f032f512d9fc5a9ae438e6efd9d8e94fbaaa36c
Message-ID: <202607170529.cevcUTLV-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 4f032f512d9fc5a9ae438e6efd9d8e94fbaaa36c  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:672 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 653)

Warning ids grouped by kconfigs:

recent_errors
`-- i386-randconfig-141-20260716
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 1292m

configs tested: 191
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260716    gcc-14.3.0
arc                   randconfig-002-20260716    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                   randconfig-001-20260716    gcc-8.5.0
arm                   randconfig-002-20260716    clang-17
arm                   randconfig-003-20260716    gcc-12.5.0
arm                   randconfig-004-20260716    clang-24
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260716    clang-24
arm64                 randconfig-002-20260716    clang-22
arm64                 randconfig-003-20260716    clang-24
arm64                 randconfig-004-20260716    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260716    gcc-12.5.0
csky                  randconfig-002-20260716    gcc-14.3.0
hexagon                           allnoconfig    clang-24
hexagon                             defconfig    clang-24
hexagon               randconfig-001-20260716    clang-24
hexagon               randconfig-002-20260716    clang-24
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260716    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260716    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260716    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260716    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260716    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260716    clang-22
i386                                defconfig    clang-22
i386                  randconfig-001-20260716    clang-22
i386                  randconfig-002-20260716    clang-22
i386                  randconfig-003-20260716    gcc-14
i386                  randconfig-004-20260716    gcc-14
i386                  randconfig-005-20260716    clang-22
i386                  randconfig-006-20260716    clang-22
i386                  randconfig-007-20260716    clang-22
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260716    clang-22
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260716    gcc-12
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260716    clang-22
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260716    gcc-12
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260716    clang-22
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260716    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260716    clang-22
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260716    clang-20
loongarch             randconfig-002-20260716    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260716    gcc-8.5.0
nios2                 randconfig-002-20260716    gcc-8.5.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260716    gcc-15.2.0
parisc                randconfig-002-20260716    gcc-8.5.0
parisc64                            defconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc                    mvme5100_defconfig    gcc-16.1.0
powerpc               randconfig-001-20260716    clang-21
powerpc               randconfig-002-20260716    clang-19
powerpc64             randconfig-001-20260716    clang-22
powerpc64             randconfig-002-20260716    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                 randconfig-001-20260716    gcc-14.3.0
riscv                 randconfig-002-20260716    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260716    clang-24
s390                  randconfig-002-20260716    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260716    gcc-16.1.0
sh                    randconfig-002-20260716    gcc-16.1.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260716    gcc-13.4.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260716    gcc-11.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260716    clang-24
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260716    clang-24
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-24
um                    randconfig-001-20260716    clang-24
um                             randconfig-002    clang-24
um                    randconfig-002-20260716    gcc-14
um                           x86_64_defconfig    clang-24
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260716    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260716    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260716    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260716    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260716    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260716    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260716    gcc-12
x86_64                randconfig-002-20260716    gcc-14
x86_64                randconfig-003-20260716    clang-22
x86_64                randconfig-004-20260716    clang-22
x86_64                randconfig-005-20260716    clang-22
x86_64                randconfig-006-20260716    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260716    clang-22
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260716    clang-22
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260716    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260716    clang-22
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260716    clang-22
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260716    gcc-14
x86_64                randconfig-071-20260716    clang-22
x86_64                randconfig-072-20260716    clang-22
x86_64                randconfig-073-20260716    clang-22
x86_64                randconfig-074-20260716    gcc-14
x86_64                randconfig-075-20260716    clang-22
x86_64                randconfig-076-20260716    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260716    gcc-9.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260716    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
