Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C1F283FCE
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 04:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789532819; cv=none; b=f/mCJBkw7l7w3rRSsJttOQaEpJWcO0duDjGWyVCPApmsqYPnRuwxBY29m1ImTuQv+XQWVk9bB23ZTsjgGoAwdsWGC3ff1OOfzmDONldBL6ZwTYQXmM6GIT4UnMmScVKWnBkDrr6GsciUSzgr/aoIdkVW/MQkYGamyV6cp+iEU9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789532819; c=relaxed/simple;
	bh=H1F7OYseeUqDrYPk0vo1Gp/5wZAda03MTZ9fwO7JlAo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=me3eSJLr3WqcC+DVScuM6Q4iZYXFEpWpgc7RBlvtG5QO+PoJo5sG4chW2v1IEw083ZhsCEfZY0KLk0vWAmZLYORwM0o+XIlXSUT9S/+3lZFCtT/A9b4cdms+3G0ek58WRHxiqj/wCxrBoBEXVWC9d/wK+YyQHyX3nRI3+oMkCzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lVobnHU/; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lVobnHU/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789532817; x=1821068817;
  h=date:from:to:cc:subject:message-id;
  bh=H1F7OYseeUqDrYPk0vo1Gp/5wZAda03MTZ9fwO7JlAo=;
  b=lVobnHU/oVAqtQrUo1oCAfa5eJEB2dT+Mwqv9OYwNvAOnATT0iwnmhxY
   2bbUtpkXIl0pD1kytN26ICNVYUT1gvTiiQX1DJ2ShFrC+aHESInBcjWoH
   5xg5uPbagq6dRcB/Zo25AO2egwx2R7Gnx71c+TabDkEZCms5mqGvKgzbA
   x3IuQadX/V6xmArIkwNa2wfObz/qm7attxuW5qDmRp4OG2dzL4o1lzjtZ
   NOPwxz6ujd3o9O1RfJu9Yj0cgSzwg99fHULEEObg4LF2YF3DgC0LaNl3f
   elHmF6tSMaT32Aj0UAcxkHHxPZYCohwhb4X4GtJJLqoce7MYRMZWoerIl
   g==;
X-CSE-ConnectionGUID: MUolJC1VTJibKz6x0z+p5Q==
X-CSE-MsgGUID: ynt489JxSpuqtLzMyigB3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="101249882"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="101249882"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 21:26:56 -0700
X-CSE-ConnectionGUID: LNCGauBNR9S+hS7GeXMMCg==
X-CSE-MsgGUID: YJhXFVtgQnWYZE0MRk8gLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="269532247"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 15 Sep 2026 21:26:54 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6hER-000000005VN-3MrG;
	Wed, 16 Sep 2026 04:26:51 +0000
Date: Wed, 16 Sep 2026 12:26:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 b08a65b93426d86e3f354d655d6225397b591877
Message-ID: <202609161219.C8Ab4FMv-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: b08a65b93426d86e3f354d655d6225397b591877  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com

    fs/proc/task_mmu.c:3448:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
    fs/proc/task_mmu.c:3450:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
`-- riscv-randconfig-002-20260915
    |-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-drop_rcu
    `-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-reacquire_rcu

elapsed time: 1007m

configs tested: 164
configs skipped: 8

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260915    gcc-8.5.0
arc                   randconfig-002-20260915    gcc-10.5.0
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                   randconfig-001-20260915    clang-24
arm                   randconfig-002-20260915    clang-24
arm                   randconfig-003-20260915    gcc-10.5.0
arm                   randconfig-004-20260915    clang-24
arm                  randconfig-r113-20260915    gcc-15.2.0 sparse
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260916    gcc-8.5.0
arm64                 randconfig-002-20260916    clang-24
arm64                 randconfig-003-20260916    gcc-8.5.0
arm64                 randconfig-004-20260916    gcc-9.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260916    gcc-9.5.0
csky                  randconfig-002-20260916    gcc-16.1.0
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                             defconfig    clang-24
hexagon               randconfig-001-20260915    clang-17
hexagon               randconfig-002-20260915    clang-24
i386                             alldefconfig    gcc-14
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20260915    clang-22
i386        buildonly-randconfig-002-20260915    clang-22
i386        buildonly-randconfig-003-20260915    gcc-13
i386        buildonly-randconfig-004-20260915    gcc-14
i386        buildonly-randconfig-005-20260915    clang-22
i386        buildonly-randconfig-006-20260915    clang-22
i386                                defconfig    clang-22
i386                  randconfig-002-20260915    gcc-14
i386                  randconfig-003-20260915    gcc-14
i386                  randconfig-004-20260915    clang-22
i386                  randconfig-005-20260915    clang-22
i386                  randconfig-006-20260915    gcc-13
i386                  randconfig-007-20260915    clang-22
i386                  randconfig-061-20260915    clang-22 sparse
i386                  randconfig-062-20260915    gcc-14 sparse
i386                  randconfig-063-20260915    clang-22 sparse
i386                 randconfig-r134-20260915    gcc-14 sparse
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260915    clang-24
loongarch             randconfig-002-20260915    clang-21
loongarch            randconfig-r132-20260915    clang-24 sparse
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
m68k                       m5235evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
microblaze           randconfig-r122-20260915    gcc-8.5.0 sparse
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                           gcw0_defconfig    clang-24
mips                      maltasmvp_defconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260915    gcc-8.5.0
nios2                 randconfig-002-20260915    gcc-8.5.0
nios2                randconfig-r133-20260915    gcc-8.5.0 sparse
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260915    gcc-13.4.0
parisc                randconfig-002-20260915    gcc-15.2.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc                       eiger_defconfig    clang-24
powerpc               randconfig-001-20260915    gcc-10.5.0
powerpc               randconfig-002-20260915    clang-24
powerpc64             randconfig-001-20260915    gcc-8.5.0
powerpc64             randconfig-002-20260915    clang-24
powerpc64            randconfig-r121-20260915    clang-24 sparse
powerpc64            randconfig-r131-20260915    clang-24 sparse
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                 randconfig-002-20260915    gcc-8.5.0
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260915    gcc-9.5.0
s390                  randconfig-002-20260915    clang-17
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260915    gcc-10.5.0
sh                    randconfig-002-20260915    gcc-16.1.0
sh                           se7712_defconfig    gcc-16.1.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260915    gcc-8.5.0
sparc                 randconfig-002-20260915    gcc-13.4.0
sparc                randconfig-r111-20260915    gcc-8.5.0 sparse
sparc                       sparc32_defconfig    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64               randconfig-001-20260915    gcc-15.2.0
sparc64               randconfig-002-20260915    gcc-9.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260915    clang-24
um                    randconfig-002-20260915    clang-24
um                   randconfig-r112-20260915    gcc-12 sparse
um                           x86_64_defconfig    clang-24
x86_64                            allnoconfig    clang-22
x86_64      buildonly-randconfig-001-20260915    clang-22
x86_64      buildonly-randconfig-002-20260915    clang-22
x86_64      buildonly-randconfig-003-20260915    gcc-14
x86_64      buildonly-randconfig-004-20260915    clang-22
x86_64      buildonly-randconfig-005-20260915    gcc-14
x86_64      buildonly-randconfig-006-20260915    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-011-20260915    gcc-14
x86_64                randconfig-012-20260915    clang-22
x86_64                randconfig-013-20260915    clang-22
x86_64                randconfig-014-20260915    clang-22
x86_64                randconfig-015-20260915    gcc-14
x86_64                randconfig-016-20260915    clang-22
x86_64                randconfig-071-20260915    clang-22
x86_64                randconfig-072-20260915    clang-22
x86_64                randconfig-073-20260915    clang-22
x86_64                randconfig-074-20260915    gcc-13
x86_64                randconfig-075-20260915    clang-22
x86_64                randconfig-076-20260915    gcc-14
x86_64                randconfig-121-20260915    clang-22 sparse
x86_64                randconfig-122-20260915    clang-22 sparse
x86_64                randconfig-123-20260915    gcc-14 sparse
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                  audio_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260915    gcc-15.2.0
xtensa                randconfig-002-20260915    gcc-8.5.0
xtensa               randconfig-r123-20260915    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
