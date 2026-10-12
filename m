Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBE0374A0B
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811428; cv=none; b=f6tElFuY7cuuk/EvnAf7xpot374Wp3DmvHnK5+Kh1gLx6Xl3s7cny0nHtPB/Prt7znXkGoag7jl68BfF72o/CTkVju9yPImYdyeD3TLLyQrnDIPP3WbixF+8YC7Zt8Fr7OX1q3lRozSATadLZhDZtgIW3bSMWHGQzSFabrxPxqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811428; c=relaxed/simple;
	bh=le44JWQtSr09oIK0IiPMn1zHwQ94vjT58/E9CBnarsA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ilXiPPW8V9MRnyq5m4KOi619NgAdmTxBsmIGPt7Sw5yOPe7WW2GXFurLXy8Kkj4Ls66JZjBDmfTEMlqPe7b/H+V9XJW41Q1Je9veQcapZU4yyq8jCluxl+9xO1cOHmOOKwGO2VrO5wth16MCEfc9KQubXkqYX7vQaPYovVieic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D4/sFkak; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D4/sFkak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791811427; x=1823347427;
  h=date:from:to:cc:subject:message-id;
  bh=le44JWQtSr09oIK0IiPMn1zHwQ94vjT58/E9CBnarsA=;
  b=D4/sFkakITcy6gXT2uzhx/oAQuZajQ//24K/fR9c+8UMkSq0w8wsGhJk
   Nlb8KqsFK5xNdxQD933tK+1pK701k4cxnVrZTBTO6zf7sBVOzMzeGjK3U
   a738sEgvPS2KJCkwDBd1bV3AEBEnFEN9PKOH9fhdGWInOYhuQFbkteGIj
   ebTZGYoQykcDCYaV1kT4BNktEtZEhoqI7qMd7iin023/sw/v12Kv8K12Z
   d/ANka3GBBcHsiClJ+tjk5PfS218iWweAeGJNCgM9wEbgZCK5Dpz2bqxo
   d4wh5vEcq7ktMfHO9Y/Cz4ClPs2NzMQt/Th1TrIf1O3dP0IGsZpJA4DBq
   Q==;
X-CSE-ConnectionGUID: QO6EMB0pQ5WFE1UdzGTFwA==
X-CSE-MsgGUID: 5iSPg9eLQq2QRePeDrDkjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="402981"
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="402981"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 06:23:16 -0700
X-CSE-ConnectionGUID: l0tCTG9oSm+2PDl2uxoOOQ==
X-CSE-MsgGUID: 9NqNigdbQ5quzdkWwqvv4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="2659499"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 12 Oct 2026 06:23:13 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGFzi-00000000BX3-3TiW;
	Mon, 12 Oct 2026 13:23:10 +0000
Date: Mon, 12 Oct 2026 21:22:15 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 50dba3e474f7c3932cba85ebd9a7188e7b8dd6d4
Message-ID: <202610122112.aAg2PojA-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 50dba3e474f7c3932cba85ebd9a7188e7b8dd6d4  sh: drop include/asm/sparsemem.h

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2101-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20261011
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- i386-randconfig-r2111-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- loongarch-randconfig-r2110-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2108-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2202-20261011
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- sparc64-randconfig-r2105-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2102-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2103-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2104-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2200-20261011
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
`-- xtensa-randconfig-r2109-20261011
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 1008m

configs tested: 454
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2101-20261011    gcc-15.2.0 cocci
alpha                randconfig-r2106-20261011    clang-24   cocci
alpha                randconfig-r2111-20261012    gcc-8.5.0  cocci
alpha                randconfig-r2202-20261012    gcc-15.2.0 smatch
alpha                randconfig-r2300-20261012    clang-19   sparse
alpha                randconfig-r2304-20261011    clang-24   sparse
alpha                randconfig-r2304-20261011    gcc-14.3.0 sparse
alpha                randconfig-r2305-20261011    clang-24   sparse
alpha                randconfig-r2311-20261012    clang-22   sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261012    gcc-13.4.0
arc                   randconfig-1001-20261012    gcc-8.5.0
arc                   randconfig-2000-20261011    gcc-8.5.0
arc                   randconfig-2000-20261012    gcc-16.1.0
arc                   randconfig-2001-20261011    gcc-8.5.0
arc                   randconfig-2001-20261012    gcc-16.1.0
arc                  randconfig-r2109-20261011    gcc-16.1.0 cocci
arc                  randconfig-r2200-20261012    gcc-16.1.0 smatch
arc                  randconfig-r2304-20261012    clang-19   sparse
arc                  randconfig-r2307-20261011    gcc-8.5.0  sparse
arc                  randconfig-r2311-20261011    clang-24   sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                         clps711x_defconfig    clang-24
arm                                  defconfig    clang-24
arm                             dove_defconfig    gcc-16.1.0
arm                             hisi_defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261012    clang-19
arm                   randconfig-1001-20261012    clang-24
arm                   randconfig-1002-20261012    gcc-8.5.0
arm                   randconfig-1003-20261012    clang-24
arm                   randconfig-2000-20261011    gcc-8.5.0
arm                   randconfig-2000-20261012    gcc-16.1.0
arm                   randconfig-2001-20261011    gcc-8.5.0
arm                   randconfig-2001-20261012    gcc-16.1.0
arm                  randconfig-r2102-20261011    clang-17   cocci
arm                  randconfig-r2300-20261011    clang-17   sparse
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261012    gcc-10.5.0
arm64                 randconfig-1001-20261012    clang-24
arm64                 randconfig-1002-20261012    gcc-8.5.0
arm64                 randconfig-1003-20261012    clang-17
arm64                 randconfig-2000-20261011    clang-24
arm64                 randconfig-2000-20261011    gcc-16.1.0
arm64                 randconfig-2000-20261012    gcc-16.1.0
arm64                 randconfig-2001-20261011    gcc-12.5.0
arm64                 randconfig-2001-20261011    gcc-16.1.0
arm64                 randconfig-2001-20261012    gcc-16.1.0
arm64                randconfig-r2100-20261011    gcc-16.1.0 cocci
arm64                randconfig-r2106-20261011    clang-22   cocci
arm64                randconfig-r2108-20261012    clang-24   cocci
arm64                randconfig-r2109-20261012    gcc-11.5.0 cocci
arm64                randconfig-r2303-20261011    clang-17   sparse
arm64                randconfig-r2311-20261011    gcc-13.4.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261012    gcc-9.5.0
csky                  randconfig-1001-20261012    gcc-16.1.0
csky                  randconfig-2000-20261011    gcc-16.1.0
csky                  randconfig-2000-20261011    gcc-9.5.0
csky                  randconfig-2000-20261012    gcc-16.1.0
csky                  randconfig-2001-20261011    gcc-16.1.0
csky                  randconfig-2001-20261012    gcc-16.1.0
csky                 randconfig-r2108-20261011    gcc-8.5.0  cocci
csky                 randconfig-r2202-20261011    gcc-9.5.0  smatch
csky                 randconfig-r2202-20261012    gcc-16.1.0 smatch
csky                 randconfig-r2303-20261012    gcc-9.5.0  sparse
csky                 randconfig-r2309-20261012    clang-22   sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261012    clang-24
hexagon               randconfig-1001-20261012    clang-17
hexagon               randconfig-2000-20261011    clang-19
hexagon               randconfig-2000-20261011    gcc-16.1.0
hexagon               randconfig-2000-20261012    gcc-16.1.0
hexagon               randconfig-2001-20261011    clang-17
hexagon               randconfig-2001-20261011    gcc-16.1.0
hexagon               randconfig-2001-20261012    gcc-16.1.0
hexagon              randconfig-r2100-20261011    clang-24   cocci
hexagon              randconfig-r2103-20261011    clang-22   cocci
hexagon              randconfig-r2104-20261011    clang-24   cocci
hexagon              randconfig-r2106-20261012    gcc-16.1.0 cocci
hexagon              randconfig-r2107-20261012    gcc-8.5.0  cocci
hexagon              randconfig-r2109-20261012    clang-24   cocci
hexagon              randconfig-r2302-20261012    clang-17   sparse
hexagon              randconfig-r2304-20261012    clang-17   sparse
hexagon              randconfig-r2308-20261011    clang-24   sparse
hexagon              randconfig-r2309-20261011    clang-24   sparse
hexagon              randconfig-r2310-20261011    clang-24   sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261012    clang-22
i386        buildonly-randconfig-1001-20261012    gcc-13
i386        buildonly-randconfig-1002-20261012    clang-22
i386        buildonly-randconfig-1003-20261012    clang-22
i386        buildonly-randconfig-1004-20261012    clang-22
i386        buildonly-randconfig-1005-20261012    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261012    clang-22
i386                  randconfig-1001-20261012    gcc-14
i386                  randconfig-1002-20261012    clang-22
i386                  randconfig-1003-20261012    clang-22
i386                  randconfig-1004-20261012    clang-22
i386                  randconfig-1005-20261012    clang-22
i386                  randconfig-1006-20261012    gcc-14
i386                  randconfig-1007-20261012    clang-22
i386                  randconfig-1008-20261012    clang-22
i386                  randconfig-1009-20261012    clang-22
i386                  randconfig-1010-20261012    clang-22
i386                  randconfig-1011-20261012    gcc-14
i386                  randconfig-1012-20261012    gcc-12
i386                  randconfig-1013-20261012    clang-22
i386                  randconfig-2000-20261011    gcc-8.5.0
i386                  randconfig-2000-20261012    gcc-16.1.0
i386                  randconfig-2001-20261011    gcc-8.5.0
i386                  randconfig-2001-20261012    gcc-16.1.0
i386                  randconfig-2100-20261011    gcc-14     cocci
i386                  randconfig-2100-20261012    clang-22   cocci
i386                  randconfig-2101-20261011    gcc-14     cocci
i386                  randconfig-2101-20261012    clang-22   cocci
i386                  randconfig-2102-20261011    gcc-14     cocci
i386                  randconfig-2102-20261012    clang-22   cocci
i386                  randconfig-2103-20261011    gcc-14     cocci
i386                  randconfig-2103-20261012    clang-22   cocci
i386                  randconfig-2104-20261011    gcc-14     cocci
i386                  randconfig-2104-20261012    clang-22   cocci
i386                  randconfig-2105-20261011    gcc-14     cocci
i386                  randconfig-2105-20261012    clang-22   cocci
i386                  randconfig-2200-20261011    clang-22   smatch
i386                  randconfig-2200-20261012    clang-22   smatch
i386                  randconfig-2300-20261011    gcc-14     sparse
i386                  randconfig-2300-20261012    gcc-14     sparse
i386                  randconfig-2301-20261011    gcc-14     sparse
i386                  randconfig-2301-20261012    gcc-14     sparse
i386                  randconfig-2302-20261011    gcc-14     sparse
i386                  randconfig-2302-20261012    gcc-14     sparse
i386                 randconfig-r2100-20261012    gcc-11.5.0 cocci
i386                 randconfig-r2104-20261012    gcc-8.5.0  cocci
i386                 randconfig-r2111-20261011    clang-22   cocci
i386                 randconfig-r2200-20261011    clang-22   smatch
i386                 randconfig-r2300-20261012    gcc-9.5.0  sparse
i386                 randconfig-r2302-20261011    gcc-14.3.0 sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261012    gcc-16.1.0
loongarch             randconfig-1001-20261012    clang-18
loongarch             randconfig-2000-20261011    gcc-8.5.0
loongarch             randconfig-2000-20261012    gcc-11.5.0
loongarch             randconfig-2001-20261011    gcc-8.5.0
loongarch             randconfig-2001-20261012    gcc-11.5.0
loongarch            randconfig-r2110-20261011    gcc-16.1.0 cocci
loongarch            randconfig-r2111-20261012    gcc-16.1.0 cocci
loongarch            randconfig-r2306-20261011    gcc-16.1.0 sparse
loongarch            randconfig-r2308-20261011    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                         m5272c3_defconfig    gcc-16.1.0
m68k                             q40_defconfig    gcc-16.1.0
m68k                 randconfig-r2201-20261012    gcc-13.4.0 smatch
m68k                 randconfig-r2310-20261011    clang-24   sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2104-20261012    gcc-16.1.0 cocci
microblaze           randconfig-r2202-20261012    gcc-15.2.0 smatch
microblaze           randconfig-r2306-20261011    clang-24   sparse
microblaze           randconfig-r2309-20261011    clang-24   sparse
microblaze           randconfig-r2310-20261012    clang-22   sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2103-20261011    gcc-16.1.0 cocci
mips                 randconfig-r2106-20261012    gcc-8.5.0  cocci
mips                 randconfig-r2107-20261011    clang-24   cocci
mips                 randconfig-r2300-20261012    clang-17   sparse
mips                 randconfig-r2302-20261011    gcc-12.5.0 sparse
mips                 randconfig-r2305-20261012    clang-17   sparse
mips                 randconfig-r2306-20261012    clang-22   sparse
mips                 randconfig-r2309-20261011    clang-24   sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261012    gcc-8.5.0
nios2                 randconfig-1001-20261012    gcc-11.5.0
nios2                 randconfig-2000-20261011    gcc-8.5.0
nios2                 randconfig-2000-20261012    gcc-11.5.0
nios2                 randconfig-2001-20261011    gcc-8.5.0
nios2                 randconfig-2001-20261012    gcc-11.5.0
nios2                randconfig-r2102-20261012    gcc-11.5.0 cocci
nios2                randconfig-r2110-20261012    gcc-8.5.0  cocci
nios2                randconfig-r2111-20261012    gcc-15.2.0 cocci
nios2                randconfig-r2202-20261011    gcc-8.5.0  smatch
nios2                randconfig-r2304-20261011    gcc-8.5.0  sparse
nios2                randconfig-r2307-20261011    clang-24   sparse
nios2                randconfig-r2308-20261011    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2101-20261012    clang-24   cocci
openrisc             randconfig-r2103-20261012    clang-24   cocci
openrisc             randconfig-r2104-20261011    clang-22   cocci
openrisc             randconfig-r2104-20261011    gcc-16.1.0 cocci
openrisc             randconfig-r2105-20261012    gcc-15.2.0 cocci
openrisc             randconfig-r2305-20261011    gcc-14.3.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261012    gcc-15.2.0
parisc                randconfig-1001-20261012    gcc-13.4.0
parisc                randconfig-2000-20261011    gcc-8.5.0
parisc                randconfig-2000-20261012    gcc-11.5.0
parisc                randconfig-2001-20261011    gcc-8.5.0
parisc                randconfig-2001-20261012    gcc-11.5.0
parisc               randconfig-r2100-20261011    gcc-8.5.0  cocci
parisc               randconfig-r2100-20261012    clang-20   cocci
parisc               randconfig-r2101-20261012    clang-20   cocci
parisc               randconfig-r2201-20261011    gcc-11.5.0 smatch
parisc               randconfig-r2201-20261012    gcc-16.1.0 smatch
parisc               randconfig-r2301-20261012    clang-19   sparse
parisc               randconfig-r2304-20261012    gcc-9.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                      kmeter1_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261012    clang-17
powerpc               randconfig-1001-20261012    gcc-8.5.0
powerpc               randconfig-2000-20261011    clang-22
powerpc               randconfig-2000-20261011    gcc-8.5.0
powerpc               randconfig-2000-20261012    gcc-14
powerpc               randconfig-2001-20261011    clang-22
powerpc               randconfig-2001-20261011    gcc-8.5.0
powerpc               randconfig-2001-20261012    gcc-14
powerpc              randconfig-r2101-20261011    gcc-8.5.0  cocci
powerpc              randconfig-r2103-20261012    gcc-11.5.0 cocci
powerpc              randconfig-r2106-20261012    gcc-15.2.0 cocci
powerpc              randconfig-r2111-20261011    clang-24   cocci
powerpc              randconfig-r2302-20261012    clang-19   sparse
powerpc              randconfig-r2305-20261012    clang-19   sparse
powerpc              randconfig-r2306-20261011    clang-24   sparse
powerpc              randconfig-r2311-20261011    clang-24   sparse
powerpc64             randconfig-1000-20261012    clang-24
powerpc64             randconfig-1001-20261012    clang-24
powerpc64             randconfig-2000-20261011    clang-22
powerpc64             randconfig-2000-20261011    gcc-8.5.0
powerpc64             randconfig-2000-20261012    gcc-14
powerpc64             randconfig-2001-20261011    clang-22
powerpc64             randconfig-2001-20261011    gcc-12.5.0
powerpc64             randconfig-2001-20261012    gcc-14
powerpc64            randconfig-r2101-20261011    gcc-16.1.0 cocci
powerpc64            randconfig-r2104-20261012    gcc-15.2.0 cocci
powerpc64            randconfig-r2106-20261011    gcc-16.1.0 cocci
powerpc64            randconfig-r2108-20261012    clang-20   cocci
powerpc64            randconfig-r2110-20261011    clang-22   cocci
powerpc64            randconfig-r2302-20261011    clang-24   sparse
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261012    clang-24
riscv                 randconfig-1001-20261012    clang-24
riscv                 randconfig-2000-20261011    gcc-13.4.0
riscv                 randconfig-2000-20261011    gcc-8.5.0
riscv                 randconfig-2000-20261012    gcc-14.3.0
riscv                 randconfig-2001-20261011    gcc-13.4.0
riscv                 randconfig-2001-20261011    gcc-8.5.0
riscv                 randconfig-2001-20261012    gcc-14.3.0
riscv                randconfig-r2107-20261011    clang-24   cocci
riscv                randconfig-r2110-20261012    gcc-15.2.0 cocci
riscv                randconfig-r2301-20261011    clang-24   sparse
riscv                randconfig-r2303-20261012    clang-19   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261012    clang-24
s390                  randconfig-1001-20261012    gcc-8.5.0
s390                  randconfig-2000-20261011    clang-17
s390                  randconfig-2000-20261011    gcc-13.4.0
s390                  randconfig-2000-20261012    gcc-14.3.0
s390                  randconfig-2001-20261011    clang-24
s390                  randconfig-2001-20261011    gcc-13.4.0
s390                  randconfig-2001-20261012    gcc-14.3.0
s390                 randconfig-r2201-20261012    clang-17   smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261012    gcc-16.1.0
sh                    randconfig-1001-20261012    gcc-16.1.0
sh                    randconfig-2000-20261011    gcc-13.4.0
sh                    randconfig-2000-20261012    gcc-14.3.0
sh                    randconfig-2001-20261011    gcc-13.4.0
sh                    randconfig-2001-20261011    gcc-16.1.0
sh                    randconfig-2001-20261012    gcc-14.3.0
sh                   randconfig-r2101-20261012    gcc-11.5.0 cocci
sh                   randconfig-r2107-20261012    gcc-15.2.0 cocci
sh                   randconfig-r2108-20261011    gcc-16.1.0 cocci
sh                   randconfig-r2303-20261011    clang-24   sparse
sh                   randconfig-r2305-20261011    gcc-13.4.0 sparse
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261012    gcc-13.4.0
sparc                 randconfig-1001-20261012    gcc-15.2.0
sparc                 randconfig-2000-20261011    gcc-8.5.0
sparc                 randconfig-2000-20261012    gcc-8.5.0
sparc                 randconfig-2001-20261011    gcc-8.5.0
sparc                 randconfig-2001-20261012    gcc-8.5.0
sparc                randconfig-r2105-20261011    clang-24   cocci
sparc                randconfig-r2105-20261012    gcc-8.5.0  cocci
sparc                randconfig-r2108-20261011    gcc-16.1.0 cocci
sparc                randconfig-r2200-20261011    gcc-8.5.0  smatch
sparc                randconfig-r2201-20261011    gcc-14.3.0 smatch
sparc                randconfig-r2202-20261011    gcc-16.1.0 smatch
sparc                randconfig-r2300-20261011    clang-24   sparse
sparc                randconfig-r2303-20261012    clang-17   sparse
sparc                randconfig-r2307-20261011    clang-24   sparse
sparc                randconfig-r2310-20261011    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261012    gcc-16.1.0
sparc64               randconfig-1001-20261012    clang-20
sparc64               randconfig-2000-20261011    clang-24
sparc64               randconfig-2000-20261011    gcc-8.5.0
sparc64               randconfig-2000-20261012    gcc-8.5.0
sparc64               randconfig-2001-20261011    gcc-10.5.0
sparc64               randconfig-2001-20261011    gcc-8.5.0
sparc64               randconfig-2001-20261012    gcc-8.5.0
sparc64              randconfig-r2100-20261012    clang-24   cocci
sparc64              randconfig-r2102-20261012    clang-20   cocci
sparc64              randconfig-r2105-20261011    clang-21   cocci
sparc64              randconfig-r2111-20261011    clang-22   cocci
sparc64              randconfig-r2301-20261011    gcc-16.1.0 sparse
sparc64              randconfig-r2302-20261012    gcc-9.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261012    gcc-14
um                    randconfig-1001-20261012    gcc-14
um                    randconfig-2000-20261011    gcc-14
um                    randconfig-2000-20261011    gcc-8.5.0
um                    randconfig-2000-20261012    gcc-8.5.0
um                    randconfig-2001-20261011    gcc-14
um                    randconfig-2001-20261011    gcc-8.5.0
um                    randconfig-2001-20261012    gcc-8.5.0
um                   randconfig-r2102-20261011    gcc-16.1.0 cocci
um                   randconfig-r2102-20261012    clang-24   cocci
um                   randconfig-r2103-20261012    clang-20   cocci
um                   randconfig-r2105-20261012    gcc-16.1.0 cocci
um                   randconfig-r2107-20261012    gcc-16.1.0 cocci
um                   randconfig-r2110-20261012    gcc-16.1.0 cocci
um                   randconfig-r2301-20261011    gcc-14.3.0 sparse
um                   randconfig-r2301-20261012    clang-17   sparse
um                   randconfig-r2303-20261011    gcc-14.3.0 sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261012    gcc-14
x86_64      buildonly-randconfig-1001-20261012    clang-22
x86_64      buildonly-randconfig-1002-20261012    clang-22
x86_64      buildonly-randconfig-1003-20261012    gcc-14
x86_64      buildonly-randconfig-1004-20261012    clang-22
x86_64      buildonly-randconfig-1005-20261012    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261012    clang-22
x86_64                randconfig-1001-20261012    clang-22
x86_64                randconfig-1002-20261012    gcc-14
x86_64                randconfig-1003-20261012    clang-22
x86_64                randconfig-1004-20261012    clang-22
x86_64                randconfig-1005-20261012    clang-22
x86_64                randconfig-1006-20261012    clang-22
x86_64                randconfig-1007-20261012    clang-22
x86_64                randconfig-1008-20261012    clang-22
x86_64                randconfig-1009-20261012    gcc-14
x86_64                randconfig-1010-20261012    gcc-14
x86_64                randconfig-1011-20261012    gcc-14
x86_64                randconfig-1012-20261012    clang-22
x86_64                randconfig-1013-20261012    clang-22
x86_64                randconfig-1014-20261012    gcc-12
x86_64                randconfig-1015-20261012    clang-22
x86_64                randconfig-1016-20261012    clang-22
x86_64                randconfig-1017-20261012    gcc-14
x86_64                randconfig-2000-20261011    clang-22
x86_64                randconfig-2000-20261012    gcc-14
x86_64                randconfig-2001-20261011    clang-22
x86_64                randconfig-2001-20261012    gcc-14
x86_64                randconfig-2100-20261011    gcc-12     cocci
x86_64                randconfig-2100-20261011    gcc-14     cocci
x86_64                randconfig-2100-20261012    clang-22   cocci
x86_64                randconfig-2101-20261011    gcc-14     cocci
x86_64                randconfig-2101-20261012    clang-22   cocci
x86_64                randconfig-2102-20261011    gcc-14     cocci
x86_64                randconfig-2102-20261012    clang-22   cocci
x86_64                randconfig-2103-20261011    gcc-14     cocci
x86_64                randconfig-2103-20261012    clang-22   cocci
x86_64                randconfig-2104-20261011    clang-22   cocci
x86_64                randconfig-2104-20261011    gcc-14     cocci
x86_64                randconfig-2104-20261012    clang-22   cocci
x86_64                randconfig-2105-20261011    gcc-14     cocci
x86_64                randconfig-2105-20261012    clang-22   cocci
x86_64                randconfig-2200-20261011    clang-22   smatch
x86_64                randconfig-2200-20261012    gcc-14     smatch
x86_64                randconfig-2300-20261011    gcc-14     sparse
x86_64                randconfig-2300-20261012    gcc-14     sparse
x86_64                randconfig-2301-20261011    gcc-14     sparse
x86_64                randconfig-2301-20261012    gcc-14     sparse
x86_64                randconfig-2302-20261011    gcc-14     sparse
x86_64                randconfig-2302-20261012    gcc-14     sparse
x86_64               randconfig-r2107-20261011    clang-22   cocci
x86_64               randconfig-r2108-20261012    gcc-11.5.0 cocci
x86_64               randconfig-r2109-20261011    gcc-8.5.0  cocci
x86_64               randconfig-r2109-20261012    clang-20   cocci
x86_64               randconfig-r2300-20261011    gcc-14.3.0 sparse
x86_64               randconfig-r2305-20261012    gcc-9.5.0  sparse
x86_64               randconfig-r2307-20261012    clang-22   sparse
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
xtensa                randconfig-1000-20261012    gcc-11.5.0
xtensa                randconfig-1001-20261012    gcc-9.5.0
xtensa                randconfig-2000-20261011    gcc-8.5.0
xtensa                randconfig-2000-20261012    gcc-8.5.0
xtensa                randconfig-2001-20261011    gcc-13.4.0
xtensa                randconfig-2001-20261011    gcc-8.5.0
xtensa                randconfig-2001-20261012    gcc-8.5.0
xtensa               randconfig-r2102-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2103-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2105-20261011    clang-22   cocci
xtensa               randconfig-r2109-20261011    gcc-12.5.0 cocci
xtensa               randconfig-r2110-20261011    clang-24   cocci
xtensa               randconfig-r2200-20261012    gcc-8.5.0  smatch
xtensa               randconfig-r2301-20261012    gcc-9.5.0  sparse
xtensa               randconfig-r2308-20261012    clang-22   sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
