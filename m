Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE48283142
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 18:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782844245; cv=none; b=m/4KO6oKRhS0jvsqcsdhpcfsB2a8szEziYl9GfXI0pmb78MR9xj3PiKEhSBf7XB//d0qe6eJO6ij+ApdBq2VOD+WKnkpswbE9vISu5JZaspF1Y1y2P5DcxG51RbTooAZ+ep45QeyqfH008+9gOQAYkwcPCbWBX7OIHdfSlabAek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782844245; c=relaxed/simple;
	bh=NX7S8Br6+AJyw7Jeox3iPoLm79TW6KhFQ6bnXuRg1es=;
	h=Date:From:To:Cc:Subject:Message-ID; b=HEife4lwmy6b2JuMF/kyf4IB4kGoCa1jm+UjR8lBvSCgbpisfKalAkJcPxHPXpPEpykw5GYBfVLkcDdD6QXM/MaAeiCVw6XRc2H1q4BzreAoDpF3iXmzlRQfn54IhNR8VfM0zU5DTWV14HtweGlSMJE4fEO0plR2HHItjGYDsZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nc1P9SSD; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nc1P9SSD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782844244; x=1814380244;
  h=date:from:to:cc:subject:message-id;
  bh=NX7S8Br6+AJyw7Jeox3iPoLm79TW6KhFQ6bnXuRg1es=;
  b=nc1P9SSDoOr6pMPu1pAdQjMI6dWJ9GwP8o54NIbspYfK+c8rEMKkWoXT
   aquw0jWLPhIe1piPzitPZvV6uK3mYSNjsfPpgJl1BN6LDiBMwGOqLqR84
   BHyPc5TELaswdePy064QKKSGlYOyttxfrgUGXocR/j+f7TgbGUL5Z4jYS
   YXnxUkx0Dn6sdf1IFCUZ43R7XZ/YSxWOwDuVgiqtkF9sj4jrT3aNhoC++
   NmVTSvdHeU2xu9xuqj+pazm5kkiz3PHp5vjV6ERl4vw9IEURTIT+ek0In
   UoGvbzbMXipDzvr4iRukgDB2fsds73vEngPReSlhH2Y1TOrgpCUq4NKWt
   Q==;
X-CSE-ConnectionGUID: XkzJWWwgSeynxxV8GMyWUw==
X-CSE-MsgGUID: zCh5HUIRTdCoTr+qdfd+IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83438351"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83438351"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 11:30:43 -0700
X-CSE-ConnectionGUID: 0Th9mMKwTGCMs9d2skpgXg==
X-CSE-MsgGUID: t0T8Iy7/STqIzGcRaY+Qvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="276635443"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 30 Jun 2026 11:30:41 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wedEE-000000008Zr-1FYb;
	Tue, 30 Jun 2026 18:30:38 +0000
Date: Wed, 01 Jul 2026 02:30:11 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 15654b0268cd65b4e673510c0377774e61b86397
Message-ID: <202607010249.92RC46mZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 15654b0268cd65b4e673510c0377774e61b86397  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com

    mm/vmalloc.c:3590:16: warning: unused variable 'start' [-Wunused-variable]
    mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
    mm/zsmalloc.c:1480:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-r121-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-r072-20260630
|   |-- mm-vmalloc.c:warning:unused-variable-start
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-buildonly-randconfig-001
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-randconfig-051-20260630
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-randconfig-141
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- loongarch-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-randconfig-r063-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-defconfig
|   |-- mm-vmalloc.c:warning:unused-variable-start
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- openrisc-randconfig-r134-20260630
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- sh-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sh-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-r053-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-r071-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
`-- sparc64-randconfig-r111-20260630
    `-- mm-vmalloc.c:warning:unused-variable-start

elapsed time: 776m

configs tested: 319
configs skipped: 17

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
arc                   randconfig-001-20260630    clang-23
arc                   randconfig-001-20260630    gcc-12.5.0
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-002-20260630    clang-23
arc                   randconfig-002-20260630    gcc-10.5.0
arc                   randconfig-002-20260701    gcc-12.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260630    clang-23
arm                   randconfig-001-20260701    gcc-12.5.0
arm                   randconfig-002-20260630    clang-23
arm                   randconfig-002-20260701    gcc-12.5.0
arm                   randconfig-003-20260630    clang-23
arm                   randconfig-003-20260630    gcc-8.5.0
arm                   randconfig-003-20260701    gcc-12.5.0
arm                   randconfig-004-20260630    clang-23
arm                   randconfig-004-20260630    gcc-8.5.0
arm                   randconfig-004-20260701    gcc-12.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260630    clang-17
arm64                 randconfig-001-20260630    clang-23
arm64                 randconfig-002-20260630    clang-23
arm64                 randconfig-003-20260630    clang-23
arm64                 randconfig-004-20260630    clang-23
arm64                 randconfig-004-20260630    gcc-10.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260630    clang-23
csky                  randconfig-001-20260630    gcc-14.3.0
csky                  randconfig-002-20260630    clang-23
csky                  randconfig-002-20260630    gcc-16.1.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260630    clang-18
hexagon               randconfig-002-20260630    clang-18
hexagon               randconfig-002-20260630    clang-23
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                 buildonly-randconfig-001    clang-22
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260630    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260630    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260630    clang-22
i386        buildonly-randconfig-003-20260630    gcc-13
i386                 buildonly-randconfig-004    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260630    clang-22
i386                 buildonly-randconfig-005    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260630    clang-22
i386                 buildonly-randconfig-006    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260630    clang-22
i386        buildonly-randconfig-006-20260630    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260630    clang-22
i386                  randconfig-002-20260630    clang-22
i386                  randconfig-003-20260630    clang-22
i386                  randconfig-003-20260630    gcc-14
i386                  randconfig-004-20260630    clang-22
i386                  randconfig-005-20260630    clang-22
i386                  randconfig-006-20260630    clang-22
i386                  randconfig-007-20260630    clang-22
i386                           randconfig-011    gcc-12
i386                  randconfig-011-20260630    gcc-12
i386                  randconfig-011-20260630    gcc-14
i386                           randconfig-012    gcc-12
i386                  randconfig-012-20260630    clang-22
i386                  randconfig-012-20260630    gcc-12
i386                           randconfig-013    gcc-12
i386                  randconfig-013-20260630    gcc-12
i386                           randconfig-014    gcc-12
i386                  randconfig-014-20260630    clang-22
i386                  randconfig-014-20260630    gcc-12
i386                           randconfig-015    gcc-12
i386                  randconfig-015-20260630    gcc-12
i386                  randconfig-015-20260630    gcc-14
i386                           randconfig-016    gcc-12
i386                  randconfig-016-20260630    gcc-12
i386                           randconfig-017    gcc-12
i386                  randconfig-017-20260630    clang-22
i386                  randconfig-017-20260630    gcc-12
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260630    clang-18
loongarch             randconfig-001-20260630    clang-23
loongarch             randconfig-002-20260630    clang-18
m68k                             alldefconfig    gcc-16.1.0
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
mips                      malta_kvm_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260630    clang-18
nios2                 randconfig-001-20260630    gcc-11.5.0
nios2                 randconfig-002-20260630    clang-18
nios2                 randconfig-002-20260630    gcc-11.5.0
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
parisc                randconfig-001-20260630    clang-22
parisc                randconfig-001-20260630    gcc-13.4.0
parisc                randconfig-002-20260630    clang-22
parisc                randconfig-002-20260630    gcc-15.2.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260630    clang-17
powerpc               randconfig-001-20260630    clang-22
powerpc               randconfig-002-20260630    clang-22
powerpc64             randconfig-001-20260630    clang-22
powerpc64             randconfig-001-20260630    clang-23
powerpc64             randconfig-002-20260630    clang-22
powerpc64             randconfig-002-20260630    gcc-14.3.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-9.5.0
riscv                 randconfig-001-20260630    clang-23
riscv                 randconfig-001-20260630    gcc-9.5.0
riscv                          randconfig-002    gcc-9.5.0
riscv                 randconfig-002-20260630    clang-23
riscv                 randconfig-002-20260630    gcc-9.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-9.5.0
s390                  randconfig-001-20260630    gcc-9.5.0
s390                           randconfig-002    gcc-9.5.0
s390                  randconfig-002-20260630    clang-23
s390                  randconfig-002-20260630    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-9.5.0
sh                    randconfig-001-20260630    gcc-16.1.0
sh                    randconfig-001-20260630    gcc-9.5.0
sh                             randconfig-002    gcc-9.5.0
sh                    randconfig-002-20260630    gcc-16.1.0
sh                    randconfig-002-20260630    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    clang-17
sparc                 randconfig-001-20260630    clang-17
sparc                 randconfig-001-20260630    gcc-8.5.0
sparc                          randconfig-002    clang-17
sparc                 randconfig-002-20260630    clang-17
sparc                 randconfig-002-20260630    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    clang-17
sparc64               randconfig-001-20260630    clang-17
sparc64               randconfig-001-20260630    gcc-11.5.0
sparc64                        randconfig-002    clang-17
sparc64               randconfig-002-20260630    clang-17
sparc64               randconfig-002-20260630    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-17
um                    randconfig-001-20260630    clang-17
um                             randconfig-002    clang-17
um                    randconfig-002-20260630    clang-17
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260630    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260630    clang-22
x86_64      buildonly-randconfig-002-20260630    gcc-14
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260630    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260630    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260630    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260630    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260630    clang-22
x86_64                randconfig-001-20260630    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260630    clang-22
x86_64                randconfig-002-20260630    gcc-14
x86_64                         randconfig-003    gcc-14
x86_64                randconfig-003-20260630    clang-22
x86_64                randconfig-003-20260630    gcc-14
x86_64                         randconfig-004    gcc-14
x86_64                randconfig-004-20260630    clang-22
x86_64                randconfig-004-20260630    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260630    clang-22
x86_64                randconfig-005-20260630    gcc-14
x86_64                         randconfig-006    gcc-14
x86_64                randconfig-006-20260630    gcc-14
x86_64                randconfig-011-20260630    clang-22
x86_64                randconfig-011-20260630    gcc-14
x86_64                randconfig-012-20260630    gcc-14
x86_64                randconfig-013-20260630    gcc-14
x86_64                randconfig-014-20260630    clang-22
x86_64                randconfig-014-20260630    gcc-14
x86_64                randconfig-015-20260630    clang-22
x86_64                randconfig-015-20260630    gcc-14
x86_64                randconfig-016-20260630    gcc-14
x86_64                         randconfig-071    gcc-13
x86_64                randconfig-071-20260630    clang-22
x86_64                randconfig-071-20260630    gcc-13
x86_64                randconfig-071-20260630    gcc-14
x86_64                         randconfig-072    gcc-13
x86_64                randconfig-072-20260630    clang-22
x86_64                randconfig-072-20260630    gcc-13
x86_64                randconfig-072-20260630    gcc-14
x86_64                         randconfig-073    gcc-13
x86_64                randconfig-073-20260630    clang-22
x86_64                randconfig-073-20260630    gcc-13
x86_64                         randconfig-074    gcc-13
x86_64                randconfig-074-20260630    clang-22
x86_64                randconfig-074-20260630    gcc-13
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260630    clang-22
x86_64                randconfig-075-20260630    gcc-13
x86_64                randconfig-075-20260630    gcc-14
x86_64                         randconfig-076    gcc-13
x86_64                randconfig-076-20260630    clang-22
x86_64                randconfig-076-20260630    gcc-13
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
xtensa                         randconfig-001    clang-17
xtensa                randconfig-001-20260630    clang-17
xtensa                randconfig-001-20260630    gcc-15.2.0
xtensa                         randconfig-002    clang-17
xtensa                randconfig-002-20260630    clang-17
xtensa                randconfig-002-20260630    gcc-13.4.0
xtensa                    smp_lx200_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
