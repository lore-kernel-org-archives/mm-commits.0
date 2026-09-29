Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E0354AE3
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790706067; cv=none; b=W+dJE8OBqlapeK/H6Ga2+j0+c9td+rqjdlfdIZYPQ/NA3GbSEv7m+lxyu/w5yUvJHh+12SkwGCbgd6bGo4uTRlzSC/tBPcnh/ukdg4hpFvezHdNQw3MNf5z3Blk9Ea6iSoBiLSZXvlmTIhjBy2aB8wcIhJqmW996GZcT4KAeXQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790706067; c=relaxed/simple;
	bh=5Zhe6pSCykayvbP3WxtEWQGiqMdJ6/ZBjKyH03H2vJs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=b9iuUFMUAn0CYfm7tSbP14ily1SUZ6mzJCuvCjTE0+aWtvMY/8T+2agVQzmsorm3NQ89So6xvLf4ND2FTsOXPTqnADE6R/2zX/N9WrKS1AV9G6iGTaiUAzRQPUJ0pVrIup2Sxkb1BcKEGlgXLmv5ECwhOTfjTIUbKMTx0G85E38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kFi2h+Jj; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kFi2h+Jj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790706067; x=1822242067;
  h=date:from:to:cc:subject:message-id;
  bh=5Zhe6pSCykayvbP3WxtEWQGiqMdJ6/ZBjKyH03H2vJs=;
  b=kFi2h+JjRc43GDU+PMq4fg9TjM23t9CEREN8/mxWgPt2XQsD+4Cebe/u
   /U8ONGwe4ZehSplhyjYaInq3CjTn0h6CwhoZJ2CT89S9wCewWoO1KTA+R
   JNCYhqRdraNWE7+IJ4BbaGrAniGgUV3SY5Bl08V3iASDYlLuMh4xxaaj5
   8Yk2qx4EbtTDxtbj8yZJ1YghUcb8JxXqAnbo6EWBB6yYInOTUkv1YovC6
   BeOFDbaHuEE5i+pbVW4uwju2CLuGqG+InplGT+vhdP6XfmlpDR34Jxlzr
   8gPc47tJ1FWr7FkHk7RnrXCv1FhGJ1PE8FpnoHgA0Vg8PaTgwuzjFZujR
   w==;
X-CSE-ConnectionGUID: gwt1HfVuQYeicnjVEuoIhQ==
X-CSE-MsgGUID: CZePLu6rTFi0EwYfYbmiww==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90653440"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="90653440"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 11:21:06 -0700
X-CSE-ConnectionGUID: L+kQrC2yQPusIgmQqrS7pQ==
X-CSE-MsgGUID: CTTgUhqrSL2N2j3EAGeF2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="313386737"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 29 Sep 2026 11:21:04 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBcRp-00000000Pf3-2dBD;
	Tue, 29 Sep 2026 18:21:01 +0000
Date: Wed, 30 Sep 2026 02:20:46 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 2ddb90ee544ae97215afc4698dc223293997cc43
Message-ID: <202609300242.tMg440iL-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2ddb90ee544ae97215afc4698dc223293997cc43  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2100-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- hexagon-randconfig-r2105-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2102-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20260929
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- m68k-randconfig-r2102-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2103-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- x86_64-randconfig-2200-20260929
    `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid

elapsed time: 963m

configs tested: 268
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2100-20260929    gcc-10.5.0 cocci
alpha                randconfig-r2107-20260929    gcc-15.2.0 cocci
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                      nsimosci_hs_defconfig    gcc-16.1.0
arc                   randconfig-1000-20260929    gcc-13.4.0
arc                   randconfig-1001-20260929    gcc-8.5.0
arc                  randconfig-r2103-20260929    clang-22   cocci
arc                  randconfig-r2202-20260929    gcc-16.1.0 smatch
arc                  randconfig-r2309-20260929    clang-24   sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           gemini_defconfig    clang-24
arm                   randconfig-1000-20260929    gcc-11.5.0
arm                   randconfig-1001-20260929    clang-17
arm                   randconfig-1002-20260929    clang-24
arm                   randconfig-1003-20260929    gcc-10.5.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260929    clang-24
arm64                 randconfig-1001-20260929    clang-24
arm64                 randconfig-1002-20260929    clang-24
arm64                 randconfig-1003-20260929    clang-22
arm64                randconfig-r2308-20260929    clang-17   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260929    gcc-16.1.0
csky                  randconfig-1001-20260929    gcc-15.2.0
csky                 randconfig-r2105-20260929    gcc-16.1.0 cocci
csky                 randconfig-r2107-20260929    gcc-16.1.0 cocci
csky                 randconfig-r2309-20260929    gcc-11.5.0 sparse
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260929    clang-24
hexagon               randconfig-1001-20260929    clang-17
hexagon              randconfig-r2105-20260929    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20260929    clang-22
i386        buildonly-randconfig-1001-20260929    gcc-14
i386        buildonly-randconfig-1002-20260929    gcc-14
i386        buildonly-randconfig-1003-20260929    clang-22
i386        buildonly-randconfig-1004-20260929    clang-22
i386        buildonly-randconfig-1005-20260929    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260929    clang-22
i386                  randconfig-1001-20260929    clang-22
i386                  randconfig-1002-20260929    gcc-13
i386                  randconfig-1003-20260929    gcc-14
i386                  randconfig-1004-20260929    gcc-14
i386                  randconfig-1005-20260929    clang-22
i386                  randconfig-1006-20260929    clang-22
i386                  randconfig-1007-20260929    gcc-14
i386                  randconfig-1008-20260929    gcc-14
i386                  randconfig-1009-20260929    gcc-14
i386                  randconfig-1010-20260929    gcc-14
i386                  randconfig-1011-20260929    gcc-14
i386                  randconfig-1012-20260929    gcc-14
i386                  randconfig-1013-20260929    gcc-14
i386                  randconfig-2100-20260929    clang-22   cocci
i386                  randconfig-2100-20260929    gcc-13     cocci
i386                  randconfig-2101-20260929    clang-22   cocci
i386                  randconfig-2102-20260929    clang-22   cocci
i386                  randconfig-2103-20260929    clang-22   cocci
i386                  randconfig-2200-20260929    gcc-14     smatch
i386                  randconfig-2300-20260929    clang-22   sparse
i386                  randconfig-2301-20260929    gcc-14     sparse
i386                 randconfig-r2106-20260929    gcc-16.1.0 cocci
i386                 randconfig-r2305-20260929    gcc-14     sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260929    clang-24
loongarch             randconfig-1001-20260929    clang-24
loongarch            randconfig-r2101-20260929    gcc-16.1.0 cocci
loongarch            randconfig-r2102-20260929    clang-24   cocci
loongarch            randconfig-r2107-20260929    clang-22   cocci
loongarch            randconfig-r2201-20260929    clang-24   smatch
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2102-20260929    gcc-8.5.0  cocci
m68k                 randconfig-r2104-20260929    clang-22   cocci
m68k                 randconfig-r2105-20260929    clang-22   cocci
m68k                 randconfig-r2304-20260929    gcc-16.1.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2303-20260929    gcc-14.3.0 sparse
microblaze           randconfig-r2306-20260929    clang-24   sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2100-20260929    clang-22   cocci
mips                 randconfig-r2103-20260929    clang-24   cocci
mips                 randconfig-r2106-20260929    gcc-13.4.0 cocci
mips                 randconfig-r2107-20260929    gcc-11.5.0 cocci
mips                 randconfig-r2200-20260929    gcc-12.5.0 smatch
mips                 randconfig-r2301-20260929    gcc-9.5.0  sparse
mips                         vocore2_defconfig    clang-20
nios2                          10m50_defconfig    gcc-11.5.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260929    gcc-8.5.0
nios2                 randconfig-1001-20260929    gcc-8.5.0
nios2                randconfig-r2200-20260929    gcc-11.5.0 smatch
nios2                randconfig-r2306-20260929    gcc-11.5.0 sparse
nios2                randconfig-r2307-20260929    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260929    gcc-15.2.0
parisc                randconfig-1001-20260929    gcc-13.4.0
parisc               randconfig-r2200-20260929    gcc-14.3.0 smatch
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                     ge_imp3a_defconfig    gcc-16.1.0
powerpc                        ppc64_defconfig    clang-17
powerpc               randconfig-1000-20260929    clang-17
powerpc               randconfig-1001-20260929    gcc-14.3.0
powerpc              randconfig-r2104-20260929    gcc-16.1.0 cocci
powerpc              randconfig-r2202-20260929    clang-24   smatch
powerpc              randconfig-r2300-20260929    clang-24   sparse
powerpc64             randconfig-1000-20260929    gcc-8.5.0
powerpc64             randconfig-1001-20260929    gcc-12.5.0
powerpc64            randconfig-r2104-20260929    gcc-15.2.0 cocci
powerpc64            randconfig-r2106-20260929    gcc-15.2.0 cocci
powerpc64            randconfig-r2307-20260929    clang-24   sparse
powerpc64            randconfig-r2309-20260929    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260929    clang-17
riscv                 randconfig-1001-20260929    clang-24
riscv                 randconfig-2000-20260929    gcc-11.5.0
riscv                 randconfig-2001-20260929    gcc-11.5.0
riscv                 randconfig-2001-20260929    gcc-9.5.0
riscv                randconfig-r2100-20260929    clang-24   cocci
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260929    clang-17
s390                  randconfig-1001-20260929    gcc-10.5.0
s390                  randconfig-2000-20260929    clang-24
s390                  randconfig-2000-20260929    gcc-11.5.0
s390                  randconfig-2001-20260929    gcc-11.5.0
s390                  randconfig-2001-20260929    gcc-8.5.0
s390                 randconfig-r2103-20260929    gcc-9.5.0  cocci
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260929    gcc-9.5.0
sh                    randconfig-1001-20260929    gcc-16.1.0
sh                    randconfig-2000-20260929    gcc-11.5.0
sh                    randconfig-2000-20260929    gcc-14.3.0
sh                    randconfig-2001-20260929    gcc-11.5.0
sh                    randconfig-2001-20260929    gcc-16.1.0
sh                   randconfig-r2302-20260929    gcc-16.1.0 sparse
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260929    gcc-8.5.0
sparc                 randconfig-1001-20260929    gcc-15.2.0
sparc                 randconfig-2000-20260929    gcc-12.5.0
sparc                 randconfig-2000-20260929    gcc-14.3.0
sparc                 randconfig-2001-20260929    gcc-12.5.0
sparc                randconfig-r2306-20260929    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260929    clang-20
sparc64               randconfig-1001-20260929    clang-24
sparc64               randconfig-2000-20260929    gcc-12.5.0
sparc64               randconfig-2000-20260929    gcc-8.5.0
sparc64               randconfig-2001-20260929    clang-24
sparc64               randconfig-2001-20260929    gcc-12.5.0
sparc64              randconfig-r2104-20260929    clang-24   cocci
sparc64              randconfig-r2307-20260929    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260929    gcc-14
um                    randconfig-1001-20260929    gcc-14
um                    randconfig-2000-20260929    clang-17
um                    randconfig-2000-20260929    gcc-12.5.0
um                    randconfig-2001-20260929    gcc-12.5.0
um                    randconfig-2001-20260929    gcc-14
um                   randconfig-r2201-20260929    gcc-14     smatch
um                   randconfig-r2202-20260929    clang-24   smatch
um                   randconfig-r2308-20260929    clang-24   sparse
um                            x86_64_defconfig    clang-24
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260929    clang-22
x86_64      buildonly-randconfig-1001-20260929    clang-22
x86_64      buildonly-randconfig-1002-20260929    gcc-14
x86_64      buildonly-randconfig-1003-20260929    gcc-14
x86_64      buildonly-randconfig-1004-20260929    clang-22
x86_64      buildonly-randconfig-1005-20260929    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260929    gcc-13
x86_64                randconfig-1001-20260929    clang-22
x86_64                randconfig-1002-20260929    gcc-14
x86_64                randconfig-1003-20260929    clang-22
x86_64                randconfig-1004-20260929    clang-22
x86_64                randconfig-1005-20260929    clang-22
x86_64                randconfig-1006-20260929    clang-22
x86_64                randconfig-1007-20260929    gcc-13
x86_64                randconfig-1008-20260929    clang-22
x86_64                randconfig-1009-20260929    gcc-13
x86_64                randconfig-1010-20260929    gcc-14
x86_64                randconfig-1011-20260929    gcc-14
x86_64                randconfig-1012-20260929    gcc-14
x86_64                randconfig-1013-20260929    gcc-14
x86_64                randconfig-1014-20260929    clang-22
x86_64                randconfig-1015-20260929    gcc-14
x86_64                randconfig-1016-20260929    gcc-14
x86_64                randconfig-1017-20260929    clang-22
x86_64                randconfig-2100-20260929    clang-22   cocci
x86_64                randconfig-2101-20260929    clang-22   cocci
x86_64                randconfig-2101-20260929    gcc-14     cocci
x86_64                randconfig-2102-20260929    clang-22   cocci
x86_64                randconfig-2102-20260929    gcc-14     cocci
x86_64                randconfig-2103-20260929    clang-22   cocci
x86_64                randconfig-2200-20260929    clang-22   smatch
x86_64                randconfig-2300-20260929    clang-22   sparse
x86_64                randconfig-2301-20260929    clang-22   sparse
x86_64                randconfig-2302-20260929    clang-22   sparse
x86_64               randconfig-r2101-20260929    clang-24   cocci
x86_64               randconfig-r2102-20260929    clang-22   cocci
x86_64               randconfig-r2106-20260929    clang-22   cocci
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
xtensa                randconfig-1000-20260929    gcc-15.2.0
xtensa                randconfig-1001-20260929    gcc-9.5.0
xtensa                randconfig-2000-20260929    gcc-12.5.0
xtensa                randconfig-2000-20260929    gcc-16.1.0
xtensa                randconfig-2001-20260929    gcc-10.5.0
xtensa                randconfig-2001-20260929    gcc-12.5.0
xtensa               randconfig-r2101-20260929    clang-22   cocci
xtensa               randconfig-r2105-20260929    gcc-15.2.0 cocci
xtensa               randconfig-r2308-20260929    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
