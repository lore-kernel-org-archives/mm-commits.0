Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4A0372662
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666804; cv=none; b=mVct06e95BhZ/iO7qaB3Xsa2K5TwK+AkEM7dupG6nYFvJo2Dibi0IxMkwnZksEmbAToD/KdBX9CzaZCxNWWSF3mmkevgF3Euzs59yHOb0vFT0p1EGqMs8ve5ri7dP+Uf6DifkiXN3Zj+TNUbmaVDlNG79LllqpUNgkWbfXUJpZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666804; c=relaxed/simple;
	bh=P2rmUV31idzLIclPV+jHFjLk5/uGmFmi5f4bePKbfoQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=JVEp2Mn9ybk0XB7du8ISxIQEogJifgLtOYWY4msoJPgmD5y0/Sf7MIFUnS9Hd2tW7Ht5+ktuIPtYgNtEbBPQj6VafrjzMaCG+HR3tNmY8Tc7v75O7pOIbD+3PVdsMnzrQYccNyJhEcJ+E+KuvCQTunBsNGrNQoHjvE1/sHP11rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nUOREegF; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nUOREegF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791666803; x=1823202803;
  h=date:from:to:cc:subject:message-id;
  bh=P2rmUV31idzLIclPV+jHFjLk5/uGmFmi5f4bePKbfoQ=;
  b=nUOREegF2IJdLNa9LSfhK3fCfi5J6pYjhK1w5Nvzq+dp0+nQv2/jq3Xt
   PnHmM8keiiHTIhU+ufIL3erVQmoxSOpldqnRF8R51j8uRJDFcUR5FX0uU
   hVqXK43UYyMN/r1EDpXhtzPmUP7cWEzqgQ1efCa7cWrF7uGjgQUt+TtHn
   aXIuB4CP7xd8SodJXN55de1bbT6khN724NyDzVrZcXEHgr9Qw2ieeEk5Z
   dEzJjTbTT2Qjo5NiriqnJ0xZ8QIklzo9Px/zI9ud/jQf9mjsF/eklFuPb
   6VukzV5h5Qbb/LX0sT0UbnX4ZhHmgTauU1w8dhuFZeNFJKzswueIk0gXc
   A==;
X-CSE-ConnectionGUID: UJg/L354SZucGDUm9TCw1g==
X-CSE-MsgGUID: Mks762erQ62c3QCALtwdOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="435245"
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="435245"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2026 14:13:22 -0700
X-CSE-ConnectionGUID: FVvwz/7tRNWlpmSyM5nB7w==
X-CSE-MsgGUID: DX32KBMoT2+mOC2hGUV2cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="576658"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 10 Oct 2026 14:13:20 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFeNZ-00000000A5U-1I0r;
	Sat, 10 Oct 2026 21:13:17 +0000
Date: Sun, 11 Oct 2026 05:12:36 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
Message-ID: <202610110532.qAJHziS6-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4  sh: drop include/asm/sparsemem.h

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-2100-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- loongarch-randconfig-r2102-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- powerpc-randconfig-r2202-20261009
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- sh-randconfig-r2106-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2100-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-allnoconfig
|-- x86_64-randconfig-2100-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- xtensa-randconfig-r2101-20261009
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 988m

configs tested: 336
configs skipped: 16

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2100-20261009    clang-18   cocci
alpha                randconfig-r2103-20261009    gcc-10.5.0 cocci
alpha                randconfig-r2104-20261009    gcc-9.5.0  cocci
alpha                randconfig-r2300-20261009    gcc-8.5.0  sparse
alpha                randconfig-r2305-20261009    gcc-8.5.0  sparse
alpha                randconfig-r2308-20261009    gcc-14     sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261010    gcc-15.2.0
arc                   randconfig-1001-20261010    gcc-13.4.0
arc                  randconfig-r2106-20261009    gcc-15.2.0 cocci
arc                  randconfig-r2107-20261009    gcc-9.5.0  cocci
arc                  randconfig-r2201-20261009    gcc-16.1.0 smatch
arc                  randconfig-r2202-20261009    gcc-8.5.0  smatch
arc                  randconfig-r2300-20261009    gcc-16.1.0 sparse
arc                  randconfig-r2302-20261009    gcc-11.5.0 sparse
arc                  randconfig-r2302-20261009    gcc-8.5.0  sparse
arc                  randconfig-r2302-20261009    gcc-9.5.0  sparse
arc                  randconfig-r2303-20261009    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           ep93xx_defconfig    clang-24
arm                            omap1_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261010    clang-24
arm                   randconfig-1001-20261010    gcc-15.2.0
arm                   randconfig-1002-20261010    gcc-8.5.0
arm                   randconfig-1003-20261010    gcc-8.5.0
arm                  randconfig-r2105-20261009    gcc-9.5.0  cocci
arm                  randconfig-r2106-20261009    clang-17   cocci
arm                  randconfig-r2107-20261009    gcc-15.2.0 cocci
arm                  randconfig-r2200-20261009    clang-24   smatch
arm                  randconfig-r2301-20261009    gcc-16.1.0 sparse
arm                  randconfig-r2302-20261009    gcc-10.5.0 sparse
arm                  randconfig-r2305-20261009    gcc-11.5.0 sparse
arm                  randconfig-r2306-20261009    clang-24   sparse
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261010    gcc-8.5.0
arm64                 randconfig-1001-20261010    gcc-10.5.0
arm64                 randconfig-1002-20261010    clang-20
arm64                 randconfig-1003-20261010    clang-24
arm64                randconfig-r2104-20261009    gcc-9.5.0  cocci
arm64                randconfig-r2105-20261009    clang-24   cocci
arm64                randconfig-r2107-20261009    gcc-9.5.0  cocci
arm64                randconfig-r2202-20261009    gcc-10.5.0 smatch
arm64                randconfig-r2303-20261009    gcc-10.5.0 sparse
arm64                randconfig-r2305-20261009    gcc-10.5.0 sparse
arm64                randconfig-r2307-20261009    gcc-11.5.0 sparse
arm64                randconfig-r2309-20261009    gcc-11.5.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261010    gcc-16.1.0
csky                  randconfig-1001-20261010    gcc-13.4.0
csky                 randconfig-r2306-20261009    gcc-11.5.0 sparse
csky                 randconfig-r2307-20261009    clang-24   sparse
csky                 randconfig-r2308-20261009    clang-17   sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261010    clang-24
hexagon               randconfig-1001-20261010    clang-17
hexagon              randconfig-r2103-20261009    clang-19   cocci
hexagon              randconfig-r2304-20261009    gcc-11.5.0 sparse
hexagon              randconfig-r2308-20261009    clang-24   sparse
hexagon              randconfig-r2309-20261009    gcc-14     sparse
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261010    gcc-13
i386        buildonly-randconfig-1001-20261010    clang-22
i386        buildonly-randconfig-1002-20261010    gcc-14
i386        buildonly-randconfig-1003-20261010    gcc-14
i386        buildonly-randconfig-1004-20261010    clang-22
i386        buildonly-randconfig-1005-20261010    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1007-20261010    gcc-14
i386                  randconfig-1008-20261010    gcc-14
i386                  randconfig-1009-20261010    gcc-14
i386                  randconfig-1010-20261010    gcc-14
i386                  randconfig-1011-20261010    clang-22
i386                  randconfig-1012-20261010    clang-22
i386                  randconfig-1013-20261010    clang-22
i386                  randconfig-2100-20261009    clang-22   cocci
i386                  randconfig-2101-20261009    clang-22   cocci
i386                  randconfig-2101-20261009    gcc-14     cocci
i386                  randconfig-2102-20261009    clang-22   cocci
i386                  randconfig-2102-20261009    gcc-14     cocci
i386                  randconfig-2103-20261009    clang-22   cocci
i386                  randconfig-2200-20261009    gcc-14     smatch
i386                  randconfig-2300-20261009    clang-22   sparse
i386                  randconfig-2301-20261009    clang-22   sparse
i386                  randconfig-2301-20261009    gcc-14     sparse
i386                  randconfig-2302-20261009    clang-22   sparse
i386                  randconfig-2302-20261009    gcc-14     sparse
i386                 randconfig-r2201-20261009    gcc-14     smatch
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261010    clang-24
loongarch             randconfig-1001-20261010    clang-18
loongarch            randconfig-r2102-20261009    clang-24   cocci
loongarch            randconfig-r2103-20261009    gcc-16.1.0 cocci
loongarch            randconfig-r2200-20261009    gcc-16.1.0 smatch
loongarch            randconfig-r2202-20261009    clang-18   smatch
loongarch            randconfig-r2303-20261009    gcc-11.5.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2100-20261009    gcc-16.1.0 cocci
m68k                 randconfig-r2100-20261009    gcc-8.5.0  cocci
m68k                 randconfig-r2304-20261009    gcc-8.5.0  sparse
m68k                 randconfig-r2307-20261009    gcc-9.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2301-20261009    gcc-16.1.0 sparse
microblaze           randconfig-r2306-20261009    gcc-10.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                          db1xxx_defconfig    clang-24
mips                             gpr_defconfig    clang-24
mips                 randconfig-r2102-20261009    clang-19   cocci
mips                 randconfig-r2102-20261009    gcc-16.1.0 cocci
mips                 randconfig-r2106-20261009    gcc-9.5.0  cocci
mips                 randconfig-r2304-20261009    gcc-16.1.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261010    gcc-11.5.0
nios2                 randconfig-1001-20261010    gcc-11.5.0
nios2                randconfig-r2101-20261009    gcc-8.5.0  cocci
nios2                randconfig-r2102-20261009    gcc-8.5.0  cocci
nios2                randconfig-r2300-20261009    gcc-10.5.0 sparse
nios2                randconfig-r2304-20261009    gcc-8.5.0  sparse
nios2                randconfig-r2306-20261009    gcc-9.5.0  sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2105-20261009    gcc-9.5.0  cocci
openrisc             randconfig-r2107-20261009    clang-17   cocci
openrisc             randconfig-r2107-20261009    clang-24   cocci
openrisc             randconfig-r2107-20261009    gcc-13.4.0 cocci
openrisc             randconfig-r2300-20261009    gcc-13.4.0 sparse
openrisc             randconfig-r2300-20261009    gcc-8.5.0  sparse
openrisc             randconfig-r2305-20261009    gcc-16.1.0 sparse
openrisc             randconfig-r2306-20261009    gcc-14     sparse
openrisc             randconfig-r2308-20261009    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261010    gcc-9.5.0
parisc                randconfig-1001-20261010    gcc-8.5.0
parisc               randconfig-r2101-20261009    clang-18   cocci
parisc               randconfig-r2103-20261009    gcc-8.5.0  cocci
parisc               randconfig-r2302-20261009    gcc-8.5.0  sparse
parisc               randconfig-r2305-20261009    gcc-8.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                  canyonlands_defconfig    clang-22
powerpc                       chrp32_defconfig    clang-24
powerpc               randconfig-1000-20261010    gcc-8.5.0
powerpc               randconfig-1001-20261010    clang-24
powerpc              randconfig-r2100-20261009    clang-19   cocci
powerpc              randconfig-r2103-20261009    clang-18   cocci
powerpc              randconfig-r2104-20261009    gcc-15.2.0 cocci
powerpc              randconfig-r2200-20261009    clang-17   smatch
powerpc              randconfig-r2202-20261009    clang-24   smatch
powerpc              randconfig-r2301-20261009    gcc-8.5.0  sparse
powerpc              randconfig-r2308-20261009    clang-24   sparse
powerpc64             randconfig-1000-20261010    clang-24
powerpc64             randconfig-1001-20261010    clang-24
powerpc64            randconfig-r2100-20261009    gcc-8.5.0  cocci
powerpc64            randconfig-r2101-20261009    gcc-16.1.0 cocci
powerpc64            randconfig-r2101-20261009    gcc-8.5.0  cocci
powerpc64            randconfig-r2200-20261009    clang-24   smatch
powerpc64            randconfig-r2301-20261009    gcc-8.5.0  sparse
powerpc64            randconfig-r2304-20261009    gcc-10.5.0 sparse
powerpc64            randconfig-r2309-20261009    gcc-9.5.0  sparse
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261010    clang-19
riscv                 randconfig-1001-20261010    clang-24
riscv                 randconfig-2000-20261009    gcc-13.4.0
riscv                 randconfig-2000-20261009    gcc-16.1.0
riscv                 randconfig-2001-20261009    gcc-15.2.0
riscv                 randconfig-2001-20261009    gcc-16.1.0
riscv                randconfig-r2102-20261009    gcc-8.5.0  cocci
riscv                randconfig-r2106-20261009    clang-24   cocci
riscv                randconfig-r2306-20261009    clang-17   sparse
riscv                randconfig-r2307-20261009    clang-17   sparse
riscv                randconfig-r2308-20261009    gcc-9.5.0  sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261010    clang-24
s390                  randconfig-1001-20261010    clang-24
s390                  randconfig-2000-20261009    clang-21
s390                  randconfig-2000-20261009    gcc-16.1.0
s390                  randconfig-2001-20261009    gcc-15.2.0
s390                  randconfig-2001-20261009    gcc-16.1.0
s390                 randconfig-r2104-20261009    clang-24   cocci
s390                 randconfig-r2105-20261009    gcc-15.2.0 cocci
s390                 randconfig-r2202-20261009    clang-18   smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261010    gcc-11.5.0
sh                    randconfig-1001-20261010    gcc-13.4.0
sh                    randconfig-2000-20261009    gcc-16.1.0
sh                    randconfig-2001-20261009    gcc-16.1.0
sh                   randconfig-r2106-20261009    gcc-12.5.0 cocci
sh                   randconfig-r2301-20261009    gcc-10.5.0 sparse
sh                   randconfig-r2303-20261009    gcc-12.5.0 sparse
sh                   randconfig-r2309-20261009    gcc-12.5.0 sparse
sh                            se7705_defconfig    gcc-16.1.0
sh                            se7780_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261010    gcc-8.5.0
sparc                 randconfig-1001-20261010    gcc-8.5.0
sparc                 randconfig-2000-20261009    clang-17
sparc                 randconfig-2000-20261009    gcc-8.5.0
sparc                 randconfig-2001-20261009    clang-17
sparc                 randconfig-2001-20261009    gcc-14.3.0
sparc                randconfig-r2100-20261009    gcc-8.5.0  cocci
sparc                randconfig-r2200-20261009    gcc-16.1.0 smatch
sparc                randconfig-r2201-20261009    gcc-11.5.0 smatch
sparc                randconfig-r2302-20261009    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261010    clang-24
sparc64               randconfig-1001-20261010    gcc-16.1.0
sparc64               randconfig-2000-20261009    clang-17
sparc64               randconfig-2000-20261009    gcc-9.5.0
sparc64               randconfig-2001-20261009    clang-17
sparc64               randconfig-2001-20261009    clang-24
sparc64              randconfig-r2101-20261009    clang-19   cocci
sparc64              randconfig-r2102-20261009    clang-18   cocci
sparc64              randconfig-r2103-20261009    gcc-8.5.0  cocci
sparc64              randconfig-r2104-20261009    clang-17   cocci
sparc64              randconfig-r2106-20261009    gcc-9.5.0  cocci
sparc64              randconfig-r2201-20261009    clang-24   smatch
sparc64              randconfig-r2305-20261009    gcc-8.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261010    gcc-14
um                    randconfig-1001-20261010    gcc-14
um                    randconfig-2000-20261009    clang-17
um                    randconfig-2000-20261009    clang-21
um                    randconfig-2001-20261009    clang-17
um                   randconfig-r2105-20261009    clang-17   cocci
um                   randconfig-r2200-20261009    gcc-14     smatch
um                   randconfig-r2201-20261009    clang-24   smatch
um                   randconfig-r2303-20261009    gcc-16.1.0 sparse
um                   randconfig-r2304-20261009    gcc-8.5.0  sparse
um                   randconfig-r2309-20261009    clang-24   sparse
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261010    gcc-14
x86_64      buildonly-randconfig-1001-20261010    gcc-13
x86_64      buildonly-randconfig-1002-20261010    clang-22
x86_64      buildonly-randconfig-1003-20261010    clang-22
x86_64      buildonly-randconfig-1004-20261010    gcc-13
x86_64      buildonly-randconfig-1005-20261010    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261010    gcc-14
x86_64                randconfig-1001-20261010    gcc-14
x86_64                randconfig-1002-20261010    clang-22
x86_64                randconfig-1003-20261010    clang-22
x86_64                randconfig-1004-20261010    gcc-14
x86_64                randconfig-1005-20261010    gcc-13
x86_64                randconfig-1006-20261010    clang-22
x86_64                randconfig-1007-20261010    clang-22
x86_64                randconfig-1008-20261010    clang-22
x86_64                randconfig-1009-20261010    clang-22
x86_64                randconfig-1010-20261010    clang-22
x86_64                randconfig-1011-20261010    gcc-14
x86_64                randconfig-1012-20261010    gcc-14
x86_64                randconfig-1013-20261010    gcc-14
x86_64                randconfig-1014-20261010    gcc-14
x86_64                randconfig-1015-20261010    gcc-14
x86_64                randconfig-1016-20261010    gcc-14
x86_64                randconfig-1017-20261010    clang-22
x86_64                randconfig-2100-20261009    clang-22   cocci
x86_64                randconfig-2101-20261009    clang-22   cocci
x86_64                randconfig-2102-20261009    clang-22   cocci
x86_64                randconfig-2103-20261009    clang-22   cocci
x86_64                randconfig-2103-20261009    gcc-13     cocci
x86_64                randconfig-2200-20261009    gcc-14     smatch
x86_64                randconfig-2300-20261009    clang-22   sparse
x86_64                randconfig-2300-20261009    gcc-14     sparse
x86_64                randconfig-2301-20261009    clang-22   sparse
x86_64                randconfig-2302-20261009    clang-22   sparse
x86_64               randconfig-r2104-20261009    clang-22   cocci
x86_64               randconfig-r2105-20261009    gcc-14     cocci
x86_64               randconfig-r2300-20261009    gcc-11.5.0 sparse
x86_64               randconfig-r2301-20261009    gcc-11.5.0 sparse
x86_64               randconfig-r2303-20261009    gcc-8.5.0  sparse
x86_64               randconfig-r2307-20261009    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261010    gcc-9.5.0
xtensa                randconfig-1001-20261010    gcc-15.2.0
xtensa                randconfig-2000-20261009    clang-17
xtensa                randconfig-2000-20261009    gcc-10.5.0
xtensa                randconfig-2001-20261009    clang-17
xtensa                randconfig-2001-20261009    gcc-8.5.0
xtensa               randconfig-r2101-20261009    gcc-8.5.0  cocci
xtensa               randconfig-r2309-20261009    clang-17   sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
