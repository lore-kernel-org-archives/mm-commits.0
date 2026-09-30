Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B694E433F
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776138; cv=none; b=KxCBi6LSlGQWD9bWRq18YuArhKO9nof9Fx3PX9wx0Mj3VefoC2EN4mD99Ie87d0JgNqOa1/3ZUFKm/afGy5PnDkZr5A7x1df6ZIlLHxxOG7C0+SH1dVTFn09m+r7IJcvgw2a3AQeabZoVQ7egcPqhFA+ss9Kj6hJ1AKMgsZ8sgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776138; c=relaxed/simple;
	bh=HOoNrgvKa7oKYIvpBZnfkmrduUhQxIQVQFa+l8T9z9g=;
	h=Date:From:To:Cc:Subject:Message-ID; b=KXkACPsIhdFxY1+0eqewBwJ3p50yeNKBqx8ow939r6s2wb0aNv6uXLlYqKyTXKQJCNQVfNO7XUb4OEQH/XNfZ6hIcMXCGoE78IqT1YN+9bs3rXmqBuUcTgi96xf+UqpDdPwn80b6i9pgbgZR5Nd8LlllbsD2risYY4Gg0s8bLNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sruxo3As; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sruxo3As"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790776132; x=1822312132;
  h=date:from:to:cc:subject:message-id;
  bh=HOoNrgvKa7oKYIvpBZnfkmrduUhQxIQVQFa+l8T9z9g=;
  b=Sruxo3AsEHo3vBXzD3kMfOZ40+WuGF3GWMFH3Yk89TlpmqG7dpmipVOr
   MqDBdrUijfIYYa2PrzTUhcTmt1REXgyBybxRAgPdzrQrOnfcPWpK8mOk6
   bheuXhEbRshS9dVmgjxNwA1NbyNLfCKNOZEkG6zBZ0WByyZ/XN7rGkyHZ
   4LTjWygydA7ZZPrX6s9iR03K2uVx46ovEC0GGolqEd43Iq6CVNwCyFVwN
   RiTE3oo5Fj3EcC+SU+H7subWyVrLoCR1oA1quLkzSYdlDvD4mJDLxNRpf
   000YZvVaE/ESel2sP3XfXTdABToJQH/gUdObs42Nwy0AHmCNEfBg1SL33
   A==;
X-CSE-ConnectionGUID: kgBApNctStGp6p2LCAwrPA==
X-CSE-MsgGUID: eyvX7MXnQ/+a8pFw9xosrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102886742"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102886742"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 06:48:45 -0700
X-CSE-ConnectionGUID: 8zLDpdhTRnOxM8+17QIJ0w==
X-CSE-MsgGUID: 1nF8cm+wS1qDWkJ8I1Mnxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="303629815"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 30 Sep 2026 06:48:43 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBufo-00000000Qgj-3nee;
	Wed, 30 Sep 2026 13:48:40 +0000
Date: Wed, 30 Sep 2026 21:48:08 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 4ae0714adaa1dac4639aa0b8001bce8b03343172
Message-ID: <202609302103.vFs7BLys-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 4ae0714adaa1dac4639aa0b8001bce8b03343172  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r2102-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2102-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20260930
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- i386-randconfig-r2106-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- m68k-randconfig-r2100-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- m68k-randconfig-r2107-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2100-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- x86_64-randconfig-2102-20260930
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 912m

configs tested: 261
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2107-20260930    gcc-8.5.0  cocci
alpha                randconfig-r2304-20260930    gcc-12.5.0 sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260930    gcc-13.4.0
arc                   randconfig-1001-20260930    gcc-11.5.0
arc                  randconfig-r2201-20260930    gcc-10.5.0 smatch
arc                  randconfig-r2202-20260930    gcc-16.1.0 smatch
arc                  randconfig-r2301-20260930    clang-24   sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                          mv78xx0_defconfig    clang-24
arm                   randconfig-1000-20260930    clang-24
arm                   randconfig-1001-20260930    gcc-10.5.0
arm                   randconfig-1002-20260930    clang-17
arm                   randconfig-1003-20260930    gcc-13.4.0
arm                  randconfig-r2101-20260930    clang-24   cocci
arm                  randconfig-r2102-20260930    clang-24   cocci
arm                  randconfig-r2200-20260930    clang-17   smatch
arm                          vf610m4_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260930    clang-24
arm64                 randconfig-1001-20260930    gcc-16.1.0
arm64                 randconfig-1002-20260930    clang-24
arm64                 randconfig-1003-20260930    clang-24
arm64                randconfig-r2102-20260930    gcc-8.5.0  cocci
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260930    gcc-9.5.0
csky                  randconfig-1001-20260930    gcc-16.1.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260930    clang-24
hexagon               randconfig-1001-20260930    clang-24
hexagon              randconfig-r2307-20260930    clang-21   sparse
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20260930    clang-22
i386        buildonly-randconfig-1001-20260930    gcc-14
i386        buildonly-randconfig-1002-20260930    gcc-14
i386        buildonly-randconfig-1003-20260930    clang-22
i386        buildonly-randconfig-1004-20260930    gcc-14
i386        buildonly-randconfig-1005-20260930    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260930    gcc-14
i386                  randconfig-1001-20260930    gcc-14
i386                  randconfig-1002-20260930    gcc-13
i386                  randconfig-1003-20260930    clang-22
i386                  randconfig-1004-20260930    gcc-14
i386                  randconfig-1005-20260930    clang-22
i386                  randconfig-1006-20260930    gcc-14
i386                  randconfig-1007-20260930    gcc-14
i386                  randconfig-1008-20260930    clang-22
i386                  randconfig-1009-20260930    clang-22
i386                  randconfig-1010-20260930    gcc-14
i386                  randconfig-1011-20260930    gcc-14
i386                  randconfig-1012-20260930    gcc-14
i386                  randconfig-1013-20260930    clang-22
i386                  randconfig-2100-20260930    clang-22   cocci
i386                  randconfig-2101-20260930    clang-22   cocci
i386                  randconfig-2102-20260930    clang-22   cocci
i386                  randconfig-2103-20260930    clang-22   cocci
i386                  randconfig-2200-20260930    gcc-14     smatch
i386                  randconfig-2300-20260930    gcc-13     sparse
i386                  randconfig-2300-20260930    gcc-14     sparse
i386                  randconfig-2301-20260930    clang-22   sparse
i386                  randconfig-2301-20260930    gcc-13     sparse
i386                  randconfig-2302-20260930    gcc-13     sparse
i386                  randconfig-2302-20260930    gcc-14     sparse
i386                 randconfig-r2106-20260930    clang-22   cocci
i386                 randconfig-r2202-20260930    gcc-13     smatch
i386                 randconfig-r2303-20260930    clang-24   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260930    clang-24
loongarch             randconfig-1001-20260930    gcc-16.1.0
loongarch            randconfig-r2308-20260930    clang-24   sparse
loongarch            randconfig-r2309-20260930    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2100-20260930    gcc-8.5.0  cocci
m68k                 randconfig-r2106-20260930    gcc-8.5.0  cocci
m68k                 randconfig-r2107-20260930    gcc-12.5.0 cocci
m68k                 randconfig-r2307-20260930    gcc-12.5.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                         bcm47xx_defconfig    clang-24
mips                          cobalt_defconfig    gcc-16.1.0
mips                       loongson3_defconfig    gcc-16.1.0
mips                 randconfig-r2305-20260930    gcc-9.5.0  sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260930    gcc-11.5.0
nios2                 randconfig-1001-20260930    gcc-11.5.0
nios2                randconfig-r2104-20260930    gcc-11.5.0 cocci
nios2                randconfig-r2200-20260930    gcc-10.5.0 smatch
nios2                randconfig-r2301-20260930    gcc-11.5.0 sparse
nios2                randconfig-r2306-20260930    gcc-8.5.0  sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260930    gcc-11.5.0
parisc                randconfig-1001-20260930    gcc-8.5.0
parisc               randconfig-r2303-20260930    gcc-11.5.0 sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       katmai_defconfig    clang-24
powerpc                   mpc866_ads_defconfig    clang-17
powerpc               randconfig-1000-20260930    clang-20
powerpc               randconfig-1001-20260930    clang-19
powerpc              randconfig-r2103-20260930    clang-24   cocci
powerpc              randconfig-r2306-20260930    gcc-12.5.0 sparse
powerpc                      tqm8548_defconfig    clang-24
powerpc64             randconfig-1000-20260930    clang-24
powerpc64             randconfig-1001-20260930    gcc-8.5.0
powerpc64            randconfig-r2105-20260930    gcc-10.5.0 cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260930    gcc-8.5.0
riscv                 randconfig-1001-20260930    clang-17
riscv                 randconfig-2000-20260930    gcc-14.3.0
riscv                 randconfig-2000-20260930    gcc-15.2.0
riscv                 randconfig-2001-20260930    gcc-14.3.0
riscv                 randconfig-2001-20260930    gcc-8.5.0
riscv                randconfig-r2300-20260930    clang-24   sparse
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260930    clang-24
s390                  randconfig-1001-20260930    clang-18
s390                  randconfig-2000-20260930    clang-24
s390                  randconfig-2000-20260930    gcc-14.3.0
s390                  randconfig-2001-20260930    gcc-14.3.0
s390                  randconfig-2001-20260930    gcc-8.5.0
s390                 randconfig-r2103-20260930    gcc-9.5.0  cocci
s390                 randconfig-r2104-20260930    gcc-8.5.0  cocci
s390                 randconfig-r2305-20260930    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260930    gcc-13.4.0
sh                    randconfig-1001-20260930    gcc-16.1.0
sh                    randconfig-2000-20260930    gcc-14.3.0
sh                    randconfig-2001-20260930    gcc-12.5.0
sh                    randconfig-2001-20260930    gcc-14.3.0
sh                   randconfig-r2101-20260930    gcc-12.5.0 cocci
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260930    gcc-8.5.0
sparc                 randconfig-1001-20260930    gcc-11.5.0
sparc                 randconfig-2000-20260930    gcc-10.5.0
sparc                 randconfig-2000-20260930    gcc-14.3.0
sparc                 randconfig-2001-20260930    gcc-10.5.0
sparc                 randconfig-2001-20260930    gcc-8.5.0
sparc                randconfig-r2302-20260930    clang-24   sparse
sparc                randconfig-r2308-20260930    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260930    gcc-8.5.0
sparc64               randconfig-1001-20260930    clang-22
sparc64               randconfig-2000-20260930    gcc-10.5.0
sparc64               randconfig-2000-20260930    gcc-8.5.0
sparc64               randconfig-2001-20260930    gcc-10.5.0
sparc64               randconfig-2001-20260930    gcc-9.5.0
sparc64              randconfig-r2304-20260930    clang-24   sparse
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260930    gcc-14
um                    randconfig-1001-20260930    gcc-14
um                    randconfig-2000-20260930    clang-24
um                    randconfig-2000-20260930    gcc-10.5.0
um                    randconfig-2001-20260930    clang-24
um                    randconfig-2001-20260930    gcc-10.5.0
um                   randconfig-r2100-20260930    clang-24   cocci
um                   randconfig-r2105-20260930    gcc-8.5.0  cocci
um                   randconfig-r2201-20260930    clang-17   smatch
um                   randconfig-r2300-20260930    clang-17   sparse
um                   randconfig-r2309-20260930    gcc-12.5.0 sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20260930    gcc-14
x86_64      buildonly-randconfig-1001-20260930    clang-22
x86_64      buildonly-randconfig-1002-20260930    gcc-14
x86_64      buildonly-randconfig-1003-20260930    gcc-14
x86_64      buildonly-randconfig-1004-20260930    gcc-14
x86_64      buildonly-randconfig-1005-20260930    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260930    clang-22
x86_64                randconfig-1001-20260930    clang-22
x86_64                randconfig-1002-20260930    gcc-14
x86_64                randconfig-1003-20260930    clang-22
x86_64                randconfig-1004-20260930    clang-22
x86_64                randconfig-1005-20260930    gcc-13
x86_64                randconfig-1006-20260930    gcc-14
x86_64                randconfig-1007-20260930    clang-22
x86_64                randconfig-1008-20260930    clang-22
x86_64                randconfig-1009-20260930    clang-22
x86_64                randconfig-1010-20260930    clang-22
x86_64                randconfig-1011-20260930    gcc-14
x86_64                randconfig-1012-20260930    clang-22
x86_64                randconfig-1013-20260930    clang-22
x86_64                randconfig-1014-20260930    gcc-14
x86_64                randconfig-1015-20260930    clang-22
x86_64                randconfig-1016-20260930    gcc-14
x86_64                randconfig-1017-20260930    clang-22
x86_64                randconfig-2100-20260930    clang-22   cocci
x86_64                randconfig-2101-20260930    clang-22   cocci
x86_64                randconfig-2102-20260930    clang-22   cocci
x86_64                randconfig-2102-20260930    gcc-14     cocci
x86_64                randconfig-2103-20260930    clang-22   cocci
x86_64                randconfig-2200-20260930    gcc-14     smatch
x86_64                randconfig-2300-20260930    clang-22   sparse
x86_64                randconfig-2300-20260930    gcc-13     sparse
x86_64                randconfig-2301-20260930    gcc-13     sparse
x86_64                randconfig-2301-20260930    gcc-14     sparse
x86_64                randconfig-2302-20260930    gcc-13     sparse
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
xtensa                randconfig-1000-20260930    gcc-15.2.0
xtensa                randconfig-1001-20260930    gcc-8.5.0
xtensa                randconfig-2000-20260930    gcc-10.5.0
xtensa                randconfig-2000-20260930    gcc-12.5.0
xtensa                randconfig-2001-20260930    gcc-10.5.0
xtensa               randconfig-r2302-20260930    gcc-15.2.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
