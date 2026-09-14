Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A3349C4C9
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789409440; cv=none; b=bHBOy7viFqekoHlwmoGaB0qc5Nw2Hy9HL78jCjv2duXv7qwZEUtqKXCnvHRfpatm9R3C+M6MR8QTsTP88ZX+4GzwtiGwz4Lqxxlrd4xQkQcwTEHH9xa4AXehRawNuANoTMJbM9cADRqC5ZGMq2a1PGQ93EqGy2JueDSbrvxSWIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789409440; c=relaxed/simple;
	bh=MiwZ84eooslCy29ZODfQcIPQQBjyRjsLXggEacsmzkE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Hxr67w14dBDUxRSaQm8Fr8Dqt7IOb18wQth8epKx83pxnXXcy3eYyXJLjjUjxkrFMMQgLhbaX8t0kXQsW9vvGrZb3Pd1wfD/mf9geEyoSzGCSSsO8r/WitJkRfiRzr0j6Ug9LWQ+9h6Fi4+Xl304euUe4JQ4yU86nJYTzhaHFaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bRXdnzRp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bRXdnzRp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789409434; x=1820945434;
  h=date:from:to:cc:subject:message-id;
  bh=MiwZ84eooslCy29ZODfQcIPQQBjyRjsLXggEacsmzkE=;
  b=bRXdnzRpgTwIpqGEcsKW4JXYdBfn1lWYbFYO8o7+VLBKR9pnZkWwjDOe
   63KDrcnP67Sx1UUH8f9kS8XsefLNAjxUhkz5ql4O+hqk+kzMTjeEoD1qg
   2JiqssRYzNr9yq6Wz6rQrChXWRPMY8hYFMizzjIubN+qhbw8fZRlLIHy3
   noK4PQPWfLBjWKO0og2DTwY+gxz/iVqiiQJ/mv3DD7CCPpqBYJqG8OHyG
   RdKAr6rwo9gluElIyEGMg1pHDye7340ZfSTDtrODGkp2AbOi+AtWaBbbJ
   YtqiIB3PmCA0NPF0O7jT7O0m+UHodVWu2kq6jL6u8pSzgTZXudq+RJNDt
   g==;
X-CSE-ConnectionGUID: yeUOf4fERPWjNonxqGdaIg==
X-CSE-MsgGUID: T45qrj8tRpCNSiH23GYaaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="107138683"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="107138683"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 11:10:30 -0700
X-CSE-ConnectionGUID: wEJv1fMfT2u17HiTdtVafA==
X-CSE-MsgGUID: GRU8T2+6TFSFQsqFjP0lag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="274652774"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 14 Sep 2026 11:10:27 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6B8K-000000003Ip-3gZM;
	Mon, 14 Sep 2026 18:10:24 +0000
Date: Tue, 15 Sep 2026 02:10:03 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 383fc05d4650b021f3c17e36a145106dcc61a294
Message-ID: <202609150259.5zswfxI5-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 383fc05d4650b021f3c17e36a145106dcc61a294  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com

    fs/proc/task_mmu.c:187:13: warning: 'drop_rcu' defined but not used [-Wunused-function]
    fs/proc/task_mmu.c:195:13: warning: 'reacquire_rcu' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r131-20260913
|   |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
|   `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used
|-- csky-randconfig-002-20260913
|   |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
|   `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used
|-- i386-randconfig-016-20260913
|   |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
|   `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used
`-- openrisc-randconfig-r111-20260913
    |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
    `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used

elapsed time: 2626m

configs tested: 365
configs skipped: 11

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                randconfig-r121-20260914    gcc-12.5.0 sparse
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                 nsimosci_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-001-20260913    gcc-8.5.0
arc                   randconfig-001-20260914    gcc-13.4.0
arc                   randconfig-002-20260913    gcc-16.1.0
arc                   randconfig-002-20260914    gcc-13.4.0
arc                        vdk_hs38_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                                 defconfig    gcc-16.1.0
arm                           omap1_defconfig    gcc-16.1.0
arm                   randconfig-001-20260913    gcc-8.5.0
arm                   randconfig-001-20260914    gcc-13.4.0
arm                   randconfig-002-20260913    clang-17
arm                   randconfig-002-20260914    gcc-13.4.0
arm                   randconfig-003-20260913    clang-17
arm                   randconfig-003-20260914    gcc-13.4.0
arm                   randconfig-004-20260913    gcc-10.5.0
arm                   randconfig-004-20260914    gcc-13.4.0
arm                       spear13xx_defconfig    gcc-16.1.0
arm                    vt8500_v6_v7_defconfig    gcc-14
arm64                            allmodconfig    clang-24
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260913    gcc-8.5.0
arm64                 randconfig-001-20260914    gcc-9.5.0
arm64                 randconfig-002-20260913    gcc-8.5.0
arm64                 randconfig-002-20260914    gcc-9.5.0
arm64                 randconfig-003-20260913    gcc-10.5.0
arm64                 randconfig-003-20260914    gcc-9.5.0
arm64                 randconfig-004-20260913    gcc-16.1.0
arm64                 randconfig-004-20260914    gcc-9.5.0
arm64                randconfig-r132-20260914    gcc-14 sparse
csky                             allmodconfig    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260913    gcc-16.1.0
csky                  randconfig-001-20260914    gcc-9.5.0
csky                  randconfig-002-20260913    gcc-16.1.0
csky                  randconfig-002-20260914    gcc-9.5.0
csky                 randconfig-r122-20260914    gcc-12.5.0 sparse
csky                 randconfig-r131-20260914    gcc-13.4.0 sparse
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-24
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260913    clang-17
hexagon               randconfig-001-20260914    gcc-13.4.0
hexagon               randconfig-002-20260913    clang-24
hexagon               randconfig-002-20260914    gcc-13.4.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260913    gcc-14
i386        buildonly-randconfig-001-20260914    gcc-14
i386        buildonly-randconfig-002-20260913    clang-22
i386        buildonly-randconfig-002-20260914    gcc-14
i386        buildonly-randconfig-003-20260913    gcc-14
i386        buildonly-randconfig-003-20260914    gcc-14
i386        buildonly-randconfig-004-20260913    gcc-14
i386        buildonly-randconfig-004-20260914    gcc-14
i386        buildonly-randconfig-005-20260913    clang-22
i386        buildonly-randconfig-005-20260914    gcc-14
i386        buildonly-randconfig-006-20260913    gcc-14
i386        buildonly-randconfig-006-20260914    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260913    clang-22
i386                  randconfig-001-20260914    clang-22
i386                  randconfig-002-20260913    gcc-14
i386                  randconfig-002-20260914    clang-22
i386                  randconfig-003-20260913    gcc-13
i386                  randconfig-003-20260914    clang-22
i386                  randconfig-004-20260913    clang-22
i386                  randconfig-004-20260914    clang-22
i386                  randconfig-005-20260913    gcc-14
i386                  randconfig-005-20260914    clang-22
i386                  randconfig-006-20260913    gcc-14
i386                  randconfig-006-20260914    clang-22
i386                  randconfig-007-20260913    clang-22
i386                  randconfig-007-20260914    clang-22
i386                  randconfig-011-20260913    clang-22
i386                  randconfig-011-20260914    clang-22
i386                  randconfig-012-20260913    clang-22
i386                  randconfig-012-20260914    clang-22
i386                  randconfig-013-20260913    gcc-14
i386                  randconfig-013-20260914    clang-22
i386                  randconfig-014-20260913    gcc-14
i386                  randconfig-014-20260914    clang-22
i386                  randconfig-015-20260913    gcc-12
i386                  randconfig-015-20260914    clang-22
i386                  randconfig-016-20260913    gcc-14
i386                  randconfig-016-20260914    clang-22
i386                  randconfig-017-20260913    clang-22
i386                  randconfig-017-20260914    clang-22
i386                  randconfig-061-20260914    gcc-12 sparse
i386                  randconfig-061-20260914    gcc-14 sparse
i386                  randconfig-062-20260914    gcc-14 sparse
i386                  randconfig-063-20260914    gcc-14 sparse
i386                 randconfig-r132-20260914    gcc-13.4.0 sparse
i386                 randconfig-r134-20260914    gcc-14 sparse
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260913    clang-24
loongarch             randconfig-001-20260914    gcc-13.4.0
loongarch             randconfig-002-20260913    gcc-16.1.0
loongarch             randconfig-002-20260914    gcc-13.4.0
m68k                             allmodconfig    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-24
m68k                                defconfig    gcc-16.1.0
m68k                       m5275evb_defconfig    gcc-16.1.0
m68k                        mvme16x_defconfig    gcc-14
m68k                 randconfig-r111-20260914    gcc-12.5.0 sparse
m68k                 randconfig-r113-20260914    gcc-12.5.0 sparse
microblaze                        allnoconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze                          defconfig    gcc-16.1.0
microblaze           randconfig-r123-20260914    gcc-12.5.0 sparse
mips                             allmodconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm47xx_defconfig    clang-24
mips                           ci20_defconfig    clang-24
mips                  decstation_64_defconfig    gcc-16.1.0
mips                 decstation_r4k_defconfig    gcc-16.1.0
mips                           ip32_defconfig    gcc-14
mips                      maltasmvp_defconfig    gcc-16.1.0
mips                 randconfig-r134-20260914    gcc-13.4.0 sparse
nios2                            allmodconfig    gcc-11.5.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-24
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260913    gcc-10.5.0
nios2                 randconfig-001-20260914    gcc-13.4.0
nios2                 randconfig-002-20260913    gcc-11.5.0
nios2                 randconfig-002-20260914    gcc-13.4.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
openrisc             randconfig-r112-20260914    gcc-12.5.0 sparse
parisc                           allmodconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260913    gcc-8.5.0
parisc                randconfig-001-20260914    gcc-8.5.0
parisc                randconfig-001-20260915    gcc-8.5.0
parisc                randconfig-002-20260913    gcc-9.5.0
parisc                randconfig-002-20260914    gcc-8.5.0
parisc                randconfig-002-20260915    gcc-8.5.0
parisc               randconfig-r133-20260914    gcc-13.4.0 sparse
parisc64                            defconfig    clang-24
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      arches_defconfig    gcc-16.1.0
powerpc                          g5_defconfig    gcc-16.1.0
powerpc                    ge_imp3a_defconfig    gcc-14
powerpc                         ps3_defconfig    gcc-16.1.0
powerpc               randconfig-001-20260913    clang-24
powerpc               randconfig-001-20260914    gcc-8.5.0
powerpc               randconfig-001-20260915    gcc-8.5.0
powerpc               randconfig-002-20260913    clang-24
powerpc               randconfig-002-20260914    gcc-8.5.0
powerpc               randconfig-002-20260915    gcc-8.5.0
powerpc64             randconfig-001-20260913    gcc-8.5.0
powerpc64             randconfig-001-20260914    gcc-8.5.0
powerpc64             randconfig-001-20260915    gcc-8.5.0
powerpc64             randconfig-002-20260913    clang-17
powerpc64             randconfig-002-20260914    gcc-8.5.0
powerpc64             randconfig-002-20260915    gcc-8.5.0
riscv                            alldefconfig    gcc-16.1.0
riscv                            allmodconfig    clang-24
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260913    gcc-14.3.0
riscv                 randconfig-001-20260914    gcc-13.4.0
riscv                 randconfig-002-20260913    gcc-12.5.0
riscv                 randconfig-002-20260914    gcc-13.4.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260913    clang-20
s390                  randconfig-001-20260914    gcc-13.4.0
s390                  randconfig-002-20260913    clang-24
s390                  randconfig-002-20260914    gcc-13.4.0
sh                               allmodconfig    gcc-16.1.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                 kfr2r09-romimage_defconfig    gcc-16.1.0
sh                    randconfig-001-20260913    gcc-16.1.0
sh                    randconfig-001-20260914    gcc-13.4.0
sh                    randconfig-002-20260913    gcc-14.3.0
sh                    randconfig-002-20260914    gcc-13.4.0
sh                           se7705_defconfig    gcc-14
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260913    gcc-8.5.0
sparc                 randconfig-001-20260914    gcc-16.1.0
sparc                 randconfig-002-20260913    gcc-15.2.0
sparc                 randconfig-002-20260914    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260913    clang-21
sparc64               randconfig-001-20260914    gcc-16.1.0
sparc64               randconfig-002-20260913    clang-20
sparc64               randconfig-002-20260914    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260913    clang-24
um                    randconfig-001-20260914    gcc-16.1.0
um                    randconfig-002-20260913    clang-24
um                    randconfig-002-20260914    gcc-16.1.0
um                   randconfig-r133-20260914    gcc-14 sparse
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           alldefconfig    gcc-16.1.0
x86_64                           allmodconfig    clang-22
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260913    gcc-14
x86_64      buildonly-randconfig-001-20260914    gcc-14
x86_64      buildonly-randconfig-002-20260913    gcc-14
x86_64      buildonly-randconfig-002-20260914    gcc-14
x86_64      buildonly-randconfig-003-20260913    gcc-14
x86_64      buildonly-randconfig-003-20260914    gcc-14
x86_64      buildonly-randconfig-004-20260913    clang-22
x86_64      buildonly-randconfig-004-20260914    gcc-14
x86_64      buildonly-randconfig-005-20260913    clang-22
x86_64      buildonly-randconfig-005-20260914    gcc-14
x86_64      buildonly-randconfig-006-20260913    gcc-14
x86_64      buildonly-randconfig-006-20260914    gcc-14
x86_64                              defconfig    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260913    clang-22
x86_64                randconfig-001-20260914    gcc-14
x86_64                randconfig-002-20260913    gcc-14
x86_64                randconfig-002-20260914    gcc-14
x86_64                randconfig-003-20260913    gcc-14
x86_64                randconfig-004-20260913    gcc-14
x86_64                randconfig-004-20260914    gcc-14
x86_64                randconfig-005-20260913    gcc-14
x86_64                randconfig-006-20260913    clang-22
x86_64                randconfig-011-20260913    gcc-14
x86_64                randconfig-011-20260914    clang-22
x86_64                randconfig-012-20260913    gcc-14
x86_64                randconfig-012-20260914    clang-22
x86_64                randconfig-013-20260913    clang-22
x86_64                randconfig-013-20260914    clang-22
x86_64                randconfig-014-20260913    clang-22
x86_64                randconfig-014-20260914    clang-22
x86_64                randconfig-015-20260913    clang-22
x86_64                randconfig-015-20260914    clang-22
x86_64                randconfig-016-20260913    clang-22
x86_64                randconfig-016-20260914    clang-22
x86_64                randconfig-071-20260913    clang-22
x86_64                randconfig-072-20260913    clang-22
x86_64                randconfig-073-20260913    gcc-14
x86_64                randconfig-074-20260913    gcc-14
x86_64                randconfig-075-20260913    clang-22
x86_64                randconfig-076-20260913    gcc-13
x86_64                randconfig-121-20260914    clang-22 sparse
x86_64                randconfig-121-20260914    gcc-14 sparse
x86_64                randconfig-122-20260914    gcc-14 sparse
x86_64                randconfig-123-20260914    gcc-14 sparse
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260913    gcc-13.4.0
xtensa                randconfig-001-20260914    gcc-16.1.0
xtensa                randconfig-002-20260913    gcc-15.2.0
xtensa                randconfig-002-20260914    gcc-16.1.0
xtensa               randconfig-r131-20260914    gcc-14 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
