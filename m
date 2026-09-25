Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714363FC5D3
	for <mm-commits@vger.kernel.org>; Fri, 25 Sep 2026 05:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313450; cv=none; b=rN/MitFZktJc4JS/DLI/5r3DDhdqoKuttrKd7qAGnVBmHmUuKJ89M1SVSfCFxw5BhucN+CYM6pAnr/j5cWkmmoLutg9h8K5o9TmqEbGD8ch7EU7BZ61syL4dNnN3SZv/hezDY2xNn3Xh1/IG3bY1hqmbpvDOc7UCwO3plQaNpYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313450; c=relaxed/simple;
	bh=ocA+jeQduq65zYrZGNwYD6fpXCUtDLMtxZzXY/BT0Tw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=bchHNDBF6Mbd6XK39UN/TaPIUJUaqnLckV4JjmS4Cbj1O1zF0FN1jDVNZgvwxW4xhox18ZKI/L3zHvriKAF0dVSFtKO0R3g5AanZuGmYGrvk4zeP6k8kQx1bHKRUau2oL03xINpt0UAZ3f+WzMvsqM1QUPSdq5/uai845ylD3bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQRqOxu7; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQRqOxu7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790313445; x=1821849445;
  h=date:from:to:cc:subject:message-id;
  bh=ocA+jeQduq65zYrZGNwYD6fpXCUtDLMtxZzXY/BT0Tw=;
  b=eQRqOxu7d24jIDDnY+6EjDLpdsvhrfGiqT6f/uXN+0evpemBahoN/gll
   NpLbMNOfyy0X9Cz3ztUswmVZZZcYsQKoqcJ4BSFL5saxwsJ+zdk4vrmd9
   CK6SzaLBJSVwydEtl6NeVgQmcaKesojfWB6OxQSJ0lQSp9faBOylHGBgi
   xueoP7j2Fy5uJ4WB0xnJXSP7p2I7FkaNSnQOEYP89b0+1KPnWa/fpyuEa
   u/o+D5njupShFYpYnzm7YHOLqs/FtRz2zQHqtI+uTGCHB5kwwQxp2uWJb
   +vAJnOMiGgQ2wQjU20tawCfEqRxJ36mkbSNO+QnLdDj0xa8hv6V6Nd45J
   A==;
X-CSE-ConnectionGUID: 6NsCZETNSNyAJmwVNM3UCQ==
X-CSE-MsgGUID: aFXkZgyjRTuM+J9VO6NJzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="116622766"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="116622766"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 22:17:23 -0700
X-CSE-ConnectionGUID: sNUbAHFBQIOkXZ1j60qxtQ==
X-CSE-MsgGUID: I7ZaDrJaTWSYqH2WCxwPKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273788923"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 24 Sep 2026 22:17:22 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9yJC-00000000K3K-2zmE;
	Fri, 25 Sep 2026 05:17:18 +0000
Date: Fri, 25 Sep 2026 13:16:48 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 f19407ca08644f728cfe9762bf1d1f6985826c47
Message-ID: <202609251344.89ogZm4T-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: f19407ca08644f728cfe9762bf1d1f6985826c47  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com

    fs/proc/task_mmu.c:3450:17: error: implicit declaration of function 'drop_rcu' [-Wimplicit-function-declaration]
    fs/proc/task_mmu.c:3452:17: error: implicit declaration of function 'reacquire_rcu' [-Wimplicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-1002-20260925
    |-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-drop_rcu
    `-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-reacquire_rcu

elapsed time: 772m

configs tested: 263
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260925    clang-24
arc                   randconfig-1000-20260925    gcc-13.4.0
arc                   randconfig-1001-20260925    clang-24
arc                   randconfig-1001-20260925    gcc-11.5.0
arc                  randconfig-r1301-20260925    gcc-11.5.0 sparse
arc                            tb10x_defconfig    gcc-16.1.0
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    gcc-16.1.0
arm                        omap2plus_defconfig    gcc-16.1.0
arm                           pxa910_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260925    clang-24
arm                   randconfig-1000-20260925    gcc-15.2.0
arm                   randconfig-1001-20260925    clang-24
arm                   randconfig-1002-20260925    clang-24
arm                   randconfig-1002-20260925    gcc-11.5.0
arm                   randconfig-1003-20260925    clang-17
arm                   randconfig-1003-20260925    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260925    clang-21
arm64                 randconfig-1000-20260925    clang-24
arm64                 randconfig-1001-20260925    clang-24
arm64                 randconfig-1001-20260925    gcc-16.1.0
arm64                 randconfig-1002-20260925    clang-24
arm64                 randconfig-1003-20260925    clang-24
arm64                 randconfig-1003-20260925    gcc-16.1.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260925    clang-24
csky                  randconfig-1000-20260925    gcc-9.5.0
csky                  randconfig-1001-20260925    clang-24
csky                  randconfig-1001-20260925    gcc-15.2.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260925    clang-24
hexagon               randconfig-1000-20260925    gcc-9.5.0
hexagon               randconfig-1001-20260925    clang-17
hexagon               randconfig-1001-20260925    gcc-9.5.0
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260925    clang-22
i386        buildonly-randconfig-1001-20260925    clang-22
i386        buildonly-randconfig-1002-20260925    clang-22
i386        buildonly-randconfig-1002-20260925    gcc-13
i386        buildonly-randconfig-1003-20260925    clang-22
i386        buildonly-randconfig-1004-20260925    clang-22
i386        buildonly-randconfig-1004-20260925    gcc-14
i386        buildonly-randconfig-1005-20260925    clang-22
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260925    clang-22
i386                  randconfig-1001-20260925    clang-22
i386                  randconfig-1002-20260925    clang-22
i386                  randconfig-1003-20260925    clang-22
i386                  randconfig-1003-20260925    gcc-14
i386                  randconfig-1004-20260925    clang-22
i386                  randconfig-1004-20260925    gcc-14
i386                  randconfig-1005-20260925    clang-22
i386                  randconfig-1006-20260925    clang-22
i386                  randconfig-1006-20260925    gcc-14
i386                  randconfig-1007-20260925    clang-22
i386                  randconfig-1008-20260925    gcc-14
i386                  randconfig-1009-20260925    clang-22
i386                  randconfig-1010-20260925    clang-22
i386                  randconfig-1011-20260925    gcc-12
i386                  randconfig-1012-20260925    clang-22
i386                  randconfig-1013-20260925    clang-22
i386                  randconfig-1300-20260925    clang-22   sparse
i386                  randconfig-1301-20260925    clang-22   sparse
i386                  randconfig-1301-20260925    gcc-14     sparse
i386                  randconfig-1302-20260925    clang-22   sparse
i386                 randconfig-r1309-20260925    gcc-14     sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260925    clang-24
loongarch             randconfig-1000-20260925    gcc-9.5.0
loongarch             randconfig-1001-20260925    clang-24
loongarch             randconfig-1001-20260925    gcc-9.5.0
loongarch            randconfig-r1303-20260925    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r1304-20260925    gcc-11.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                        bmips_be_defconfig    gcc-16.1.0
mips                 randconfig-r1304-20260925    gcc-12.5.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260925    gcc-9.5.0
nios2                 randconfig-1001-20260925    gcc-11.5.0
nios2                 randconfig-1001-20260925    gcc-9.5.0
nios2                randconfig-r1302-20260925    gcc-11.5.0 sparse
nios2                randconfig-r1306-20260925    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1302-20260925    gcc-12.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260925    clang-24
parisc                randconfig-1000-20260925    gcc-11.5.0
parisc                randconfig-1001-20260925    clang-24
parisc                randconfig-1001-20260925    gcc-8.5.0
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                         fsp2_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260925    clang-24
powerpc               randconfig-1001-20260925    clang-24
powerpc               randconfig-1001-20260925    gcc-10.5.0
powerpc              randconfig-r1308-20260925    clang-24   sparse
powerpc                     socrates_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260925    clang-24
powerpc64             randconfig-1001-20260925    clang-24
powerpc64             randconfig-1001-20260925    gcc-12.5.0
powerpc64            randconfig-r1303-20260925    gcc-11.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260925    clang-24
riscv                 randconfig-1001-20260925    clang-24
riscv                randconfig-r1307-20260925    clang-22   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260925    clang-24
s390                  randconfig-1001-20260925    clang-24
s390                  randconfig-1001-20260925    gcc-10.5.0
s390                 randconfig-r1305-20260925    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260925    clang-24
sh                    randconfig-1000-20260925    gcc-16.1.0
sh                    randconfig-1001-20260925    clang-24
sh                    randconfig-1001-20260925    gcc-15.2.0
sh                   randconfig-r1300-20260925    gcc-16.1.0 sparse
sh                           rsk7269_defconfig    gcc-16.1.0
sh                    rts7751r2dplus_defconfig    gcc-16.1.0
sh                            sh2007_defconfig    gcc-16.1.0
sh                         sh7763rdp_defconfig    gcc-16.1.0
sh                           urquell_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260925    gcc-12
sparc                 randconfig-1000-20260925    gcc-16.1.0
sparc                 randconfig-1001-20260925    gcc-11.5.0
sparc                 randconfig-1001-20260925    gcc-12
sparc                randconfig-r1300-20260925    gcc-11.5.0 sparse
sparc                randconfig-r1305-20260925    gcc-11.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260925    gcc-12
sparc64               randconfig-1000-20260925    gcc-16.1.0
sparc64               randconfig-1001-20260925    gcc-12
sparc64               randconfig-1001-20260925    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260925    gcc-12
um                    randconfig-1001-20260925    gcc-12
um                    randconfig-1001-20260925    gcc-14
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260925    clang-22
x86_64      buildonly-randconfig-1001-20260925    clang-22
x86_64      buildonly-randconfig-1002-20260925    clang-22
x86_64      buildonly-randconfig-1003-20260925    clang-22
x86_64      buildonly-randconfig-1003-20260925    gcc-14
x86_64      buildonly-randconfig-1004-20260925    clang-22
x86_64      buildonly-randconfig-1005-20260925    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260925    clang-22
x86_64                randconfig-1000-20260925    gcc-14
x86_64                randconfig-1001-20260925    gcc-14
x86_64                randconfig-1002-20260925    gcc-14
x86_64                randconfig-1003-20260925    gcc-14
x86_64                randconfig-1004-20260925    clang-22
x86_64                randconfig-1004-20260925    gcc-14
x86_64                randconfig-1005-20260925    gcc-14
x86_64                randconfig-1006-20260925    gcc-14
x86_64                randconfig-1007-20260925    clang-22
x86_64                randconfig-1008-20260925    clang-22
x86_64                randconfig-1009-20260925    clang-22
x86_64                randconfig-1010-20260925    gcc-14
x86_64                randconfig-1011-20260925    clang-22
x86_64                randconfig-1012-20260925    clang-22
x86_64                randconfig-1013-20260925    gcc-14
x86_64                randconfig-1014-20260925    clang-22
x86_64                randconfig-1015-20260925    clang-22
x86_64                randconfig-1016-20260925    gcc-14
x86_64                randconfig-1017-20260925    clang-22
x86_64                randconfig-1300-20260925    clang-22   sparse
x86_64                randconfig-1300-20260925    gcc-14     sparse
x86_64                randconfig-1301-20260925    clang-22   sparse
x86_64                randconfig-1301-20260925    gcc-14     sparse
x86_64                randconfig-1302-20260925    clang-22   sparse
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                   audio_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20260925    gcc-12
xtensa                randconfig-1000-20260925    gcc-15.2.0
xtensa                randconfig-1001-20260925    gcc-12
xtensa                randconfig-1001-20260925    gcc-13.4.0
xtensa               randconfig-r1301-20260925    gcc-14.3.0 sparse
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
