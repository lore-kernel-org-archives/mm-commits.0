Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6312AE68
	for <mm-commits@vger.kernel.org>; Tue,  6 Oct 2026 02:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791252758; cv=none; b=O04AZyjT4yp1CyTCFKQaoVkE/ipqRHSF5zxptLmHklAx6z7zf1t+Gpw3wX+OFP55QYMppceuIzSGnsVAtZsnsdjbYIHbV0sZEExKSkKuDdTSQCFddNZyiRtnsIa8NqxS2c9fLyRGjimVvy1KJxxc+3clRcdIt0VtCXXQdJZrkFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791252758; c=relaxed/simple;
	bh=L4L+95Hno67rlsWF9kSO3Qq0XDxe09ncDEhAsw/DzL0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=d0uAkW2uaMAtBRc7QKVK3u5P41oyuQlfNf/d+0+d4XC246x0Z2XsJCGp26vwK6oVhiNYMigl3kvEWtrT69ZT9BBdsBRGwtN7Ln1sGI6WQGy94UZu+7WPG+5ulTVxInMetHL0Ku6At0avOcL2kkY50UUjvY3vCvU/hHeGx8EjOQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eUDOMEOp; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eUDOMEOp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791252755; x=1822788755;
  h=date:from:to:cc:subject:message-id;
  bh=L4L+95Hno67rlsWF9kSO3Qq0XDxe09ncDEhAsw/DzL0=;
  b=eUDOMEOpKBEgSp+Rm6r8lsAT/1M9oCMKr7xFh9epy7DISQpNZbtYjKVk
   RYiDYLNNrINJ5RbgJ3taVMvIHqxJ4r/JwODYOCzzvEGPZ6Atcmvrmtpg4
   yy+HRCwSx8rkQSlQ9r5By4tpsMVJtrLzJNlOxgEvax/IoIjZinwW7e0QL
   NY2B8umC+sDXas7St9UW4xWJfq1bRa5A3mqH3m3yriYALXnXufhrbsR8e
   GWX0ejnIEMSRmCbfJwNdXfNrCQ4VIjjcafUs8OzXIdE9075Fgnx4XVVOw
   c5alpN+k4THbsOJdcnjotpJOwAgUbtHsOmtneA5TyVKe8zcE5u4xHx/qm
   g==;
X-CSE-ConnectionGUID: Ms/NVt4lRqq89dnQCbN5kA==
X-CSE-MsgGUID: uUvlRlz8SzKxmcT2szkNFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="102604943"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="102604943"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 19:12:35 -0700
X-CSE-ConnectionGUID: UPtqcd5fT5KIkuoO4N039A==
X-CSE-MsgGUID: Ix7G+qiIQg+bKck7O2dRjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="280246658"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 05 Oct 2026 19:12:33 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDufO-0000000013g-3pRC;
	Tue, 06 Oct 2026 02:12:30 +0000
Date: Tue, 06 Oct 2026 10:12:09 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 0aaec43576cd41474a8e90c919631c0c9fc88417
Message-ID: <202610061005.1lWFUAXm-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0aaec43576cd41474a8e90c919631c0c9fc88417  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2106-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2100-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20261005
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- m68k-randconfig-r2107-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2100-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2102-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2200-20261005
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
`-- x86_64-randconfig-r2201-20261005
    `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid

elapsed time: 1081m

configs tested: 334
configs skipped: 5

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2106-20261005    gcc-16.1.0 cocci
alpha                randconfig-r2201-20261005    gcc-15.2.0 smatch
alpha                randconfig-r2302-20261005    clang-24   sparse
alpha                randconfig-r2303-20261005    clang-24   sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                      haps_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-1000-20261005    gcc-15.2.0
arc                   randconfig-1000-20261005    gcc-8.5.0
arc                   randconfig-1001-20261005    gcc-8.5.0
arc                   randconfig-1001-20261005    gcc-9.5.0
arc                  randconfig-r2306-20261005    gcc-9.5.0  sparse
arc                  randconfig-r2309-20261005    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    gcc-16.1.0
arm                         multi_v7_defconfig    gcc-16.1.0
arm                          mv78xx0_defconfig    clang-24
arm                   randconfig-1000-20261005    gcc-8.5.0
arm                   randconfig-1001-20261005    gcc-11.5.0
arm                   randconfig-1001-20261005    gcc-8.5.0
arm                   randconfig-1002-20261005    gcc-10.5.0
arm                   randconfig-1002-20261005    gcc-8.5.0
arm                   randconfig-1003-20261005    clang-17
arm                   randconfig-1003-20261005    gcc-8.5.0
arm                          socfpga_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261005    gcc-8.5.0
arm64                 randconfig-1001-20261005    clang-21
arm64                 randconfig-1002-20261005    gcc-8.5.0
arm64                 randconfig-1003-20261005    clang-19
arm64                randconfig-r2103-20261005    gcc-14     cocci
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261005    gcc-16.1.0
csky                  randconfig-1001-20261005    gcc-16.1.0
csky                 randconfig-r2103-20261005    gcc-15.2.0 cocci
csky                 randconfig-r2105-20261005    gcc-15.2.0 cocci
csky                 randconfig-r2105-20261005    gcc-8.5.0  cocci
csky                 randconfig-r2301-20261005    gcc-9.5.0  sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261005    clang-22
hexagon               randconfig-1000-20261005    gcc-16.1.0
hexagon               randconfig-1001-20261005    clang-24
hexagon               randconfig-1001-20261005    gcc-16.1.0
hexagon              randconfig-r2101-20261005    clang-22   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261005    clang-22
i386        buildonly-randconfig-1001-20261005    clang-22
i386        buildonly-randconfig-1002-20261005    gcc-13
i386        buildonly-randconfig-1003-20261005    gcc-14
i386        buildonly-randconfig-1004-20261005    clang-22
i386        buildonly-randconfig-1005-20261005    gcc-13
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261005    clang-22
i386                  randconfig-1000-20261005    gcc-13
i386                  randconfig-1001-20261005    clang-22
i386                  randconfig-1002-20261005    clang-22
i386                  randconfig-1003-20261005    clang-22
i386                  randconfig-1003-20261005    gcc-14
i386                  randconfig-1004-20261005    clang-22
i386                  randconfig-1005-20261005    clang-22
i386                  randconfig-1006-20261005    clang-22
i386                  randconfig-1007-20261005    clang-22
i386                  randconfig-1008-20261005    gcc-14
i386                  randconfig-1009-20261005    clang-22
i386                  randconfig-1010-20261005    gcc-12
i386                  randconfig-1011-20261005    clang-22
i386                  randconfig-1012-20261005    gcc-14
i386                  randconfig-1013-20261005    gcc-14
i386                  randconfig-2100-20261005    gcc-14     cocci
i386                  randconfig-2101-20261005    gcc-14     cocci
i386                  randconfig-2102-20261005    clang-22   cocci
i386                  randconfig-2102-20261005    gcc-14     cocci
i386                  randconfig-2103-20261005    clang-22   cocci
i386                  randconfig-2103-20261005    gcc-14     cocci
i386                  randconfig-2200-20261005    gcc-14     smatch
i386                  randconfig-2300-20261005    clang-22   sparse
i386                  randconfig-2300-20261005    gcc-14     sparse
i386                  randconfig-2301-20261005    clang-22   sparse
i386                  randconfig-2301-20261005    gcc-13     sparse
i386                  randconfig-2302-20261005    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261005    clang-18
loongarch             randconfig-1000-20261005    gcc-16.1.0
loongarch             randconfig-1001-20261005    gcc-16.1.0
loongarch            randconfig-r2100-20261005    clang-22   cocci
loongarch            randconfig-r2202-20261005    gcc-16.1.0 smatch
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
m68k                         m5407c3_defconfig    gcc-16.1.0
m68k                 randconfig-r2104-20261005    gcc-8.5.0  cocci
m68k                 randconfig-r2107-20261005    gcc-14.3.0 cocci
m68k                 randconfig-r2303-20261005    gcc-12.5.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2101-20261005    gcc-14     cocci
microblaze           randconfig-r2202-20261005    gcc-9.5.0  smatch
microblaze           randconfig-r2307-20261005    gcc-9.5.0  sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq6_defconfig    clang-24
mips                            ip22_defconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
mips                 randconfig-r2107-20261005    gcc-8.5.0  cocci
mips                 randconfig-r2302-20261005    clang-17   sparse
mips                 randconfig-r2306-20261005    gcc-13.4.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261005    gcc-16.1.0
nios2                 randconfig-1000-20261005    gcc-8.5.0
nios2                 randconfig-1001-20261005    gcc-16.1.0
nios2                 randconfig-1001-20261005    gcc-9.5.0
nios2                randconfig-r2304-20261005    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                    de0_nano_defconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2107-20261005    gcc-14.3.0 cocci
openrisc             randconfig-r2300-20261005    gcc-9.5.0  sparse
openrisc             randconfig-r2307-20261005    gcc-15.2.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                 generic-64bit_defconfig    gcc-16.1.0
parisc                randconfig-1000-20261005    gcc-8.5.0
parisc                randconfig-1001-20261005    gcc-15.2.0
parisc               randconfig-r2104-20261005    gcc-14.3.0 cocci
parisc               randconfig-r2200-20261005    gcc-16.1.0 smatch
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20261005    gcc-14.3.0
powerpc               randconfig-1001-20261005    clang-24
powerpc                      stx_gp3_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261005    clang-17
powerpc64             randconfig-1001-20261005    clang-19
powerpc64            randconfig-r2202-20261005    gcc-12.5.0 smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261005    gcc-8.5.0
riscv                 randconfig-1001-20261005    gcc-16.1.0
riscv                 randconfig-2000-20261005    gcc-13.4.0
riscv                 randconfig-2000-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-8.5.0
riscv                randconfig-r2200-20261005    gcc-10.5.0 smatch
riscv                randconfig-r2305-20261005    clang-24   sparse
riscv                randconfig-r2308-20261005    gcc-9.5.0  sparse
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261005    clang-17
s390                  randconfig-1001-20261005    gcc-16.1.0
s390                  randconfig-2000-20261005    gcc-13.4.0
s390                  randconfig-2000-20261005    gcc-16.1.0
s390                  randconfig-2001-20261005    clang-24
s390                  randconfig-2001-20261005    gcc-16.1.0
s390                 randconfig-r2102-20261005    gcc-8.5.0  cocci
s390                 randconfig-r2300-20261005    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261005    gcc-16.1.0
sh                    randconfig-1001-20261005    gcc-16.1.0
sh                    randconfig-2000-20261005    gcc-12.5.0
sh                    randconfig-2000-20261005    gcc-16.1.0
sh                    randconfig-2001-20261005    gcc-16.1.0
sh                   randconfig-r2100-20261005    gcc-12.5.0 cocci
sh                   randconfig-r2105-20261005    gcc-14.3.0 cocci
sh                   randconfig-r2301-20261005    clang-24   sparse
sh                   randconfig-r2304-20261005    clang-24   sparse
sh                             shmin_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261005    gcc-15.2.0
sparc                 randconfig-1001-20261005    gcc-13.4.0
sparc                 randconfig-2000-20261005    clang-17
sparc                 randconfig-2000-20261005    gcc-8.5.0
sparc                 randconfig-2001-20261005    clang-17
sparc                 randconfig-2001-20261005    gcc-16.1.0
sparc                randconfig-r2309-20261005    gcc-9.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261005    gcc-14.3.0
sparc64               randconfig-1001-20261005    gcc-12.5.0
sparc64               randconfig-2000-20261005    clang-17
sparc64               randconfig-2000-20261005    gcc-8.5.0
sparc64               randconfig-2001-20261005    clang-17
sparc64               randconfig-2001-20261005    gcc-15.2.0
sparc64              randconfig-r2103-20261005    clang-22   cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-16.1.0
um                    randconfig-1000-20261005    clang-24
um                    randconfig-1001-20261005    gcc-14
um                    randconfig-2000-20261005    clang-17
um                    randconfig-2000-20261005    clang-24
um                    randconfig-2001-20261005    clang-17
um                   randconfig-r2102-20261005    gcc-14     cocci
um                   randconfig-r2106-20261005    gcc-14.3.0 cocci
um                   randconfig-r2201-20261005    gcc-14     smatch
um                   randconfig-r2305-20261005    clang-24   sparse
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261005    gcc-13
x86_64      buildonly-randconfig-1001-20261005    clang-22
x86_64      buildonly-randconfig-1001-20261005    gcc-13
x86_64      buildonly-randconfig-1002-20261005    clang-22
x86_64      buildonly-randconfig-1002-20261005    gcc-13
x86_64      buildonly-randconfig-1003-20261005    clang-22
x86_64      buildonly-randconfig-1003-20261005    gcc-13
x86_64      buildonly-randconfig-1004-20261005    clang-22
x86_64      buildonly-randconfig-1004-20261005    gcc-13
x86_64      buildonly-randconfig-1005-20261005    gcc-13
x86_64      buildonly-randconfig-1005-20261005    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261005    gcc-14
x86_64                randconfig-1001-20261005    gcc-14
x86_64                randconfig-1002-20261005    gcc-14
x86_64                randconfig-1003-20261005    clang-22
x86_64                randconfig-1003-20261005    gcc-14
x86_64                randconfig-1004-20261005    clang-22
x86_64                randconfig-1004-20261005    gcc-14
x86_64                randconfig-1005-20261005    gcc-14
x86_64                randconfig-1006-20261005    gcc-14
x86_64                randconfig-1007-20261005    clang-22
x86_64                randconfig-1008-20261005    clang-22
x86_64                randconfig-1009-20261005    gcc-13
x86_64                randconfig-1010-20261005    gcc-14
x86_64                randconfig-1011-20261005    gcc-14
x86_64                randconfig-1012-20261005    gcc-12
x86_64                randconfig-1013-20261005    gcc-14
x86_64                randconfig-1014-20261005    gcc-12
x86_64                randconfig-1015-20261005    clang-22
x86_64                randconfig-1016-20261005    gcc-14
x86_64                randconfig-1017-20261005    gcc-14
x86_64                randconfig-2100-20261005    clang-22   cocci
x86_64                randconfig-2101-20261005    clang-22   cocci
x86_64                randconfig-2101-20261005    gcc-14     cocci
x86_64                randconfig-2102-20261005    clang-22   cocci
x86_64                randconfig-2102-20261005    gcc-14     cocci
x86_64                randconfig-2103-20261005    clang-22   cocci
x86_64                randconfig-2200-20261005    clang-22   smatch
x86_64                randconfig-2300-20261005    clang-22   sparse
x86_64                randconfig-2301-20261005    clang-22   sparse
x86_64                randconfig-2301-20261005    gcc-14     sparse
x86_64                randconfig-2302-20261005    clang-22   sparse
x86_64               randconfig-r2100-20261005    gcc-14     cocci
x86_64               randconfig-r2101-20261005    clang-22   cocci
x86_64               randconfig-r2102-20261005    clang-22   cocci
x86_64               randconfig-r2201-20261005    gcc-14     smatch
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                            alldefconfig    gcc-16.1.0
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                 generic_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20261005    gcc-13.4.0
xtensa                randconfig-1001-20261005    gcc-8.5.0
xtensa                randconfig-2000-20261005    clang-17
xtensa                randconfig-2000-20261005    gcc-8.5.0
xtensa                randconfig-2001-20261005    clang-17
xtensa                randconfig-2001-20261005    gcc-12.5.0
xtensa               randconfig-r2104-20261005    gcc-15.2.0 cocci
xtensa               randconfig-r2106-20261005    gcc-8.5.0  cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
