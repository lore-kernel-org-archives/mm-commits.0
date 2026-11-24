Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795512735;
	b=G7u00VfYV3TMEIFCBxy+Tq7S9q5E9F5Mwe/x7Ktgl5Q/0tl1xwB6tpH3kIFC6wAppuPi
	 RPJgafrKm1puLr1c09GIw27LoYTHoPkvhjh8Wq+AAoZrsnr7N5idUcPapACphnohCFo4Y
	 qMpJ522TgkYAhksPZRVD4x/Y6RGJDup/0zwh4pMmVQdggu4okSOh8a0uzvo13eSi17p6q
	 T4CMrICZoCvqqzPDexM+EkAR0U6xNXHGNN4S77n1tEEaLPXCaxyd4nlEssv+ROYBXDFcv
	 zUPmHJXA0UHIBgHDok+sGX/5IpKVw8N/rZxWCM1x3pFYMKcDl1a6XbiPMc3gaD8gM1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795512735;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=3leLo9NeoASMjuHKjFkn70Hkk1Zt7EsVVrRg3CEIPNU=;
	b=0pIdNbkV+r/Hmm4S7kGnAc4q4pnZSIwZFHdfralni603tINvl6rKej6J9FxiftNgl+9d
	 /U7/91Sn1ZAMLQxH0TqOHIDb/YlYXX9vMNXJKhjUvYoN34coiSmBXvy+voVGzOzBtOjvF
	 /QeUk+8AuqJ7iyJcJNzZqvPLyyNfD7Xhqwh9B7BB5q+6fQGvqwYD9LESh5J8cYnQK0aDM
	 9glQAxf50hVXnATf/voLm2UG3gyVYiBMe0Fc/rHMUmAKyKGUwHYGNH8P5l2hhaGKiNJMQ
	 Foe0wQvW1EODC/kqRcFRqzgIEK0m/79b5jh722eBdN22dwPXWv5R9BeaChfjMbQTFrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VpeYB4If;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E643606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 09:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E643606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VpeYB4If
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795512734; x=1827048734;
  h=date:from:to:cc:subject:message-id;
  bh=U5dVBxe0C8PTbXSZYUiCEkVItK+wepeVFxuUBfm5N+8=;
  b=VpeYB4If0tZw2HaLZTsaGKBiso61gJYGy2Lp6+vNitSS4m+m/NBB2G2u
   xSgvtvKpwTtnMn4EnH2mmIPpug7pPidvutDIfV4NRXTtXb01XbYjwyvLJ
   wMlwiYoiiZ7cBFlnQP+s29CkprQIzDCLucU8drbMV0FVlw3o/lpRS/uQc
   bY6ZIs4Xf49qopVum0m0NdqX62ARoqAlmq24msdlNGqzLDduqLhaD1Q3Y
   y7TC0r47FXznjIzJrDn8YVru4rLrma+EpZ5ugmc+D+Zz7ZX2HEef1L2uq
   VW/qY/NFnaimnCP4SaLCna8GGOHjcj06cDcduxM+3MRYvinqknzQAUju+
   w==;
X-CSE-ConnectionGUID: IBV5ky4rQd6Hm2mREztE7w==
X-CSE-MsgGUID: MgYQ2KaqRvyqSfxjHv71RA==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="4252038"
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="4252038"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 01:03:21 -0800
X-CSE-ConnectionGUID: pudJ75leRby1OENaek7xuA==
X-CSE-MsgGUID: oLnWS+hwT42h2Zst9Dhxnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="11815405"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 24 Nov 2026 01:03:18 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xVmQl-00000001OvS-49og;
	Tue, 24 Nov 2026 09:03:15 +0000
Date: Tue, 24 Nov 2026 17:03:00 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 87cdbd9bd63174de47ba16555bfe9800a8f3da07
Message-ID: <20261124170300.4E39XncB-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 87cdbd9bd63174de47ba16555bfe9800a8f3da07  mm/mm_init: move pageblock migratetype init to memmap helpers

elapsed time: 989m

configs tested: 280
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261123    gcc-14.4.0
alpha                 randconfig-2001-20261123    gcc-8.5.0
alpha                 randconfig-2200-20261123    gcc-12.5.0 smatch
alpha                randconfig-r2301-20261123    gcc-10.5.0 sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261124    gcc-8.5.0
arc                   randconfig-1001-20261124    gcc-16.2.0
arc                   randconfig-2000-20261123    gcc-14.4.0
arc                   randconfig-2001-20261123    gcc-12.5.0
arc                   randconfig-2002-20261123    gcc-8.5.0
arc                   randconfig-2003-20261123    gcc-12.5.0
arc                   randconfig-2004-20261123    gcc-14.4.0
arc                   randconfig-2005-20261123    gcc-12.5.0
arc                   randconfig-2200-20261123    gcc-12.5.0 smatch
arc                  randconfig-r2105-20261123    gcc-15.3.0 cocci
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                       integrator_defconfig    clang-24
arm                         keystone_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261124    gcc-16.2.0
arm                   randconfig-1001-20261124    clang-24
arm                   randconfig-1002-20261124    clang-18
arm                   randconfig-1003-20261124    gcc-8.5.0
arm                   randconfig-2000-20261123    gcc-16.2.0
arm                   randconfig-2001-20261123    gcc-8.5.0
arm                   randconfig-2002-20261123    clang-20
arm                   randconfig-2200-20261123    gcc-8.5.0  smatch
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261124    gcc-8.5.0
arm64                 randconfig-1001-20261124    gcc-8.5.0
arm64                 randconfig-1002-20261124    gcc-8.5.0
arm64                 randconfig-1003-20261124    clang-22
arm64                 randconfig-2000-20261123    clang-24
arm64                 randconfig-2001-20261123    gcc-8.5.0
arm64                 randconfig-2002-20261123    clang-24
arm64                 randconfig-2200-20261123    clang-17   smatch
arm64                randconfig-r2107-20261123    clang-17   cocci
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261124    gcc-14.4.0
csky                  randconfig-1001-20261124    gcc-16.2.0
csky                  randconfig-2000-20261123    gcc-14.4.0
csky                  randconfig-2001-20261123    gcc-12.5.0
csky                  randconfig-2200-20261123    gcc-16.2.0 smatch
csky                 randconfig-r2104-20261123    gcc-15.3.0 cocci
csky                 randconfig-r2110-20261123    gcc-16.2.0 cocci
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261124    clang-24
hexagon               randconfig-1001-20261124    clang-24
hexagon               randconfig-2000-20261123    clang-18
hexagon               randconfig-2001-20261123    clang-24
hexagon               randconfig-2200-20261123    clang-24   smatch
hexagon              randconfig-r2103-20261123    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261124    clang-22
i386        buildonly-randconfig-1001-20261124    gcc-14
i386        buildonly-randconfig-1002-20261124    gcc-14
i386        buildonly-randconfig-1003-20261124    gcc-12
i386        buildonly-randconfig-1004-20261124    clang-22
i386        buildonly-randconfig-1005-20261124    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261124    gcc-14
i386                  randconfig-1001-20261124    gcc-14
i386                  randconfig-1002-20261124    clang-22
i386                  randconfig-1003-20261124    clang-22
i386                  randconfig-1004-20261124    gcc-14
i386                  randconfig-1005-20261124    gcc-14
i386                  randconfig-1006-20261124    gcc-14
i386                  randconfig-2000-20261123    clang-22
i386                  randconfig-2001-20261123    clang-22
i386                  randconfig-2002-20261123    gcc-14
i386                  randconfig-2003-20261123    clang-22
i386                  randconfig-2004-20261123    gcc-14
i386                  randconfig-2005-20261123    gcc-12
i386                  randconfig-2100-20261123    clang-22   cocci
i386                  randconfig-2101-20261123    clang-22   cocci
i386                  randconfig-2102-20261123    clang-22   cocci
i386                  randconfig-2103-20261123    gcc-14     cocci
i386                  randconfig-2104-20261123    clang-22   cocci
i386                  randconfig-2105-20261123    gcc-14     cocci
i386                  randconfig-2200-20261123    gcc-14     smatch
i386                  randconfig-2300-20261123    gcc-13     sparse
i386                  randconfig-2301-20261123    clang-22   sparse
i386                  randconfig-2302-20261123    clang-22   sparse
i386                 randconfig-r2101-20261123    clang-22   cocci
i386                 randconfig-r2108-20261123    gcc-12     cocci
i386                 randconfig-r2303-20261123    clang-22   sparse
i386                 randconfig-r2304-20261123    gcc-14     sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261124    gcc-16.2.0
loongarch             randconfig-1001-20261124    clang-18
loongarch             randconfig-2000-20261123    gcc-16.2.0
loongarch             randconfig-2001-20261123    clang-22
loongarch             randconfig-2200-20261123    clang-24   smatch
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261123    gcc-15.3.0
m68k                  randconfig-2001-20261123    gcc-9.5.0
m68k                  randconfig-2200-20261123    gcc-8.5.0  smatch
m68k                 randconfig-r2300-20261123    gcc-12.5.0 sparse
m68k                 randconfig-r2302-20261123    gcc-8.5.0  sparse
m68k                 randconfig-r2308-20261123    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
microblaze            randconfig-2000-20261123    gcc-8.5.0
microblaze            randconfig-2200-20261123    gcc-16.2.0 smatch
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  randconfig-2000-20261123    gcc-8.5.0
mips                  randconfig-2001-20261123    gcc-10.5.0
mips                  randconfig-2002-20261123    gcc-16.2.0
mips                  randconfig-2200-20261123    gcc-14.4.0 smatch
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261124    gcc-10.5.0
nios2                 randconfig-1001-20261124    gcc-11.5.0
nios2                 randconfig-2000-20261123    gcc-8.5.0
nios2                 randconfig-2001-20261123    gcc-11.5.0
nios2                 randconfig-2200-20261123    gcc-8.5.0  smatch
nios2                randconfig-r2305-20261123    gcc-8.5.0  sparse
nios2                randconfig-r2311-20261123    gcc-8.5.0  sparse
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc          de0_nano_multicore_defconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261123    gcc-10.5.0
openrisc              randconfig-2001-20261123    gcc-16.2.0
openrisc              randconfig-2002-20261123    gcc-10.5.0
openrisc              randconfig-2200-20261123    gcc-12.5.0 smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261124    gcc-12.5.0
parisc                randconfig-1001-20261124    gcc-14.4.0
parisc                randconfig-2000-20261123    gcc-8.5.0
parisc                randconfig-2001-20261123    gcc-10.5.0
parisc                randconfig-2200-20261123    gcc-14.4.0 smatch
parisc               randconfig-r2106-20261123    gcc-8.5.0  cocci
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                  canyonlands_defconfig    clang-22
powerpc               randconfig-1000-20261124    clang-24
powerpc               randconfig-1001-20261124    gcc-13.5.0
powerpc               randconfig-2000-20261123    gcc-8.5.0
powerpc               randconfig-2001-20261123    clang-24
powerpc               randconfig-2002-20261123    clang-21
powerpc               randconfig-2200-20261123    gcc-9.5.0  smatch
powerpc              randconfig-r2310-20261123    clang-24   sparse
powerpc64             randconfig-1000-20261124    clang-24
powerpc64             randconfig-1001-20261124    clang-24
powerpc64             randconfig-2000-20261123    gcc-8.5.0
powerpc64             randconfig-2001-20261123    clang-24
powerpc64             randconfig-2002-20261123    clang-24
powerpc64             randconfig-2200-20261123    gcc-15.3.0 smatch
powerpc64            randconfig-r2102-20261123    gcc-15.3.0 cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-2000-20261123    gcc-11.5.0
riscv                 randconfig-2001-20261123    gcc-13.5.0
riscv                 randconfig-2002-20261123    gcc-8.5.0
riscv                 randconfig-2003-20261123    gcc-8.5.0
riscv                 randconfig-2004-20261123    clang-24
riscv                 randconfig-2005-20261123    gcc-13.5.0
riscv                 randconfig-2200-20261123    clang-17   smatch
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-2000-20261123    gcc-15.3.0
s390                  randconfig-2001-20261123    gcc-9.5.0
s390                  randconfig-2002-20261123    clang-20
s390                  randconfig-2003-20261123    clang-22
s390                  randconfig-2004-20261123    gcc-15.3.0
s390                  randconfig-2005-20261123    gcc-8.5.0
s390                  randconfig-2200-20261123    clang-24   smatch
s390                 randconfig-r2111-20261123    clang-24   cocci
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                  kfr2r09-romimage_defconfig    gcc-16.2.0
sh                    randconfig-2000-20261123    gcc-16.2.0
sh                    randconfig-2001-20261123    gcc-16.2.0
sh                    randconfig-2002-20261123    gcc-10.5.0
sh                    randconfig-2003-20261123    gcc-16.2.0
sh                    randconfig-2004-20261123    gcc-14.4.0
sh                    randconfig-2005-20261123    gcc-16.2.0
sh                    randconfig-2200-20261123    gcc-16.2.0 smatch
sh                   randconfig-r2306-20261123    gcc-12.5.0 sparse
sh                           rsk7269_defconfig    gcc-16.2.0
sh                    rts7751r2dplus_defconfig    gcc-16.2.0
sh                           urquell_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261124    gcc-14.4.0
sparc                 randconfig-1001-20261124    gcc-8.5.0
sparc                 randconfig-2000-20261123    gcc-16.2.0
sparc                 randconfig-2001-20261123    gcc-8.5.0
sparc                 randconfig-2200-20261123    gcc-12.5.0 smatch
sparc                randconfig-r2109-20261123    gcc-16.2.0 cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261124    clang-20
sparc64               randconfig-1001-20261124    gcc-13.5.0
sparc64               randconfig-2000-20261123    clang-24
sparc64               randconfig-2001-20261123    gcc-9.5.0
sparc64               randconfig-2200-20261123    clang-22   smatch
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261124    clang-24
um                    randconfig-1001-20261124    clang-24
um                    randconfig-2000-20261123    gcc-14
um                    randconfig-2001-20261123    gcc-14
um                    randconfig-2200-20261123    clang-21   smatch
um                   randconfig-r2307-20261123    clang-19   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261124    gcc-14
x86_64      buildonly-randconfig-1001-20261124    gcc-14
x86_64      buildonly-randconfig-1002-20261124    gcc-14
x86_64      buildonly-randconfig-1003-20261124    gcc-14
x86_64      buildonly-randconfig-1004-20261124    gcc-14
x86_64      buildonly-randconfig-1005-20261124    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261124    gcc-14
x86_64                randconfig-1001-20261124    gcc-14
x86_64                randconfig-1002-20261124    gcc-14
x86_64                randconfig-1003-20261124    clang-22
x86_64                randconfig-1004-20261124    gcc-12
x86_64                randconfig-1005-20261124    gcc-12
x86_64                randconfig-2000-20261123    gcc-14
x86_64                randconfig-2001-20261123    gcc-14
x86_64                randconfig-2002-20261123    gcc-14
x86_64                randconfig-2003-20261123    gcc-14
x86_64                randconfig-2004-20261123    gcc-14
x86_64                randconfig-2005-20261123    gcc-14
x86_64                randconfig-2100-20261123    gcc-14     cocci
x86_64                randconfig-2101-20261123    clang-22   cocci
x86_64                randconfig-2102-20261123    clang-22   cocci
x86_64                randconfig-2103-20261123    clang-22   cocci
x86_64                randconfig-2104-20261123    clang-22   cocci
x86_64                randconfig-2105-20261123    gcc-13     cocci
x86_64                randconfig-2200-20261123    gcc-14     smatch
x86_64                randconfig-2300-20261123    clang-22   sparse
x86_64                randconfig-2301-20261123    gcc-14     sparse
x86_64                randconfig-2302-20261123    gcc-14     sparse
x86_64               randconfig-r2309-20261123    gcc-14     sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261124    gcc-8.5.0
xtensa                randconfig-1001-20261124    gcc-8.5.0
xtensa                randconfig-2000-20261123    gcc-16.2.0
xtensa                randconfig-2001-20261123    gcc-8.5.0
xtensa                randconfig-2200-20261123    gcc-8.5.0  smatch
xtensa               randconfig-r2100-20261123    gcc-9.5.0  cocci

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
