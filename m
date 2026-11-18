Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019444;
	b=eqkLb6LsjU/ZH17uEQSpd7XbVgyyoJBdhc5qe9v1oFbIvp8D3YjupPIEHkfX/vljgBVI
	 eKRqxIS9pZ14UjYLLiOgauUY0rwU0W2CoadRI7bA0jC/ZI5rxvBiXzDmhsww0+kSfzvEg
	 37jHDKo9Fqp1E8zAYUNLnta0HjM+k1y04PoIFxi40NDKV0IQSsGQxidze5llpZtYx0nCv
	 0uMKim4f/dqvWlDzV86UmrGf5HMQyssTmetAD4lYxyX02gvDx+hP/dIX9Xusxe+xwNCD0
	 qfo7ulLwadhNfc1npcGcxYZSufuPfVJSEgNoY8VCtYb7c+NxVvtK99ZVmv028ZxN/Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019444;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=L/Svui1qVLq5GafgKOc9LGyC6Wf42oJCCy5o0NvmvQg=;
	b=iRp+Jetxx0f5lxf37Vk0tLQrnsCt0TB9MWMzzqUgNrTOBIhDUvIXO/PklS5eaEOic/B3
	 KeWDX+QKHwoY+6iHLb4APB7cavuKFKqJUBeIJwGE+i/FO3D+14gfVZXnkCuT3iqSstqEo
	 871UmxDQZPLE9IZhdOIiE/G7lRwyiURvPZNqpmB8sVQ03gvaqxGECD7GGdmCAo1dmV5p3
	 B1cWvKrvHuM1LPR/Xyfrgai8UM5ZV9L3Gvm2smg7B83kuYtVPHO5slmLb9NyuMeG2geJZ
	 ATJYrtvkYd+rFMblFM4FU5M+A0NxADxT7tFkVgJDX86K1X/3p5X1oPe0IVprYI1K0ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=K7d3aAb8;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C82F606B577
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 16:30:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C82F606B577
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=K7d3aAb8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795019442; x=1826555442;
  h=date:from:to:cc:subject:message-id;
  bh=wPGQiFmq9LUhG+61u9LboJAEyCif1cmHjg1bNs4rHtU=;
  b=K7d3aAb8ggYTb1hlcLF+FcvvnbLUR/lj7a4mOuGJdrjN2NVSnaRRwDX9
   5vfdM6TDxVJFJu4NDLvu856MNRPiTSz8bfTmMEUS4xZzTYh+eZ6FuaOqk
   8ybQaV8l4LT0VCRBzSleKC9UI7Xu+j02qekYQeNWsAjfmQsUL7OJp5sEM
   uWyWdGDyg1ab/MVLUzPFqY47swjo0m/aiiqacum2J+E+Xu44fHO0dlCs3
   +00wl06vHZRRjo/Rw2JrwT9kEu5j1mw+dLlGhLfbrbYTPcky9bK/8ASuC
   isU2yO3lqGTBa+dMDIl6cW11hcZvlKtcyJWNFwfc3E4k49qWJguppsGv1
   w==;
X-CSE-ConnectionGUID: a3WK00vqQmGfIW3m09iUwA==
X-CSE-MsgGUID: GRZk1J12RRSRyyjptXn8iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3731451"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3731451"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 08:30:41 -0800
X-CSE-ConnectionGUID: NsPa0Th7QVi3sjM0CEQCcw==
X-CSE-MsgGUID: GzNZpRtIR3ewdp9X7jKnyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="10091886"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 18 Nov 2026 08:30:40 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTiYP-00000001DrQ-1u1n;
	Wed, 18 Nov 2026 16:30:37 +0000
Date: Thu, 19 Nov 2026 00:30:16 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 25fee5b1762b8799dd8b72c2f6d666eb01680cc7
Message-ID: <20261119003016.UVcJ2gnE-lkp@intel.com>
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
branch HEAD: 25fee5b1762b8799dd8b72c2f6d666eb01680cc7  mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT

elapsed time: 1141m

configs tested: 429
configs skipped: 12

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261118    gcc-16.2.0
alpha                 randconfig-2001-20261118    gcc-16.2.0
alpha                 randconfig-2200-20261117    gcc-8.5.0  smatch
alpha                 randconfig-2200-20261118    gcc-13.5.0 smatch
alpha                randconfig-r2100-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2101-20261118    clang-22   cocci
alpha                randconfig-r2101-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2103-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2104-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2109-20261117    gcc-14.4.0 cocci
alpha                randconfig-r2303-20261118    gcc-16.2.0 sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261118    gcc-16.2.0
arc                   randconfig-1001-20261118    gcc-8.5.0
arc                   randconfig-2000-20261117    gcc-12.5.0
arc                   randconfig-2000-20261118    gcc-11.5.0
arc                   randconfig-2001-20261117    gcc-14.4.0
arc                   randconfig-2001-20261118    gcc-11.5.0
arc                   randconfig-2002-20261117    gcc-16.2.0
arc                   randconfig-2002-20261118    gcc-11.5.0
arc                   randconfig-2003-20261117    gcc-8.5.0
arc                   randconfig-2003-20261118    gcc-11.5.0
arc                   randconfig-2004-20261117    gcc-16.2.0
arc                   randconfig-2004-20261118    gcc-11.5.0
arc                   randconfig-2005-20261117    gcc-10.5.0
arc                   randconfig-2005-20261118    gcc-11.5.0
arc                   randconfig-2200-20261117    gcc-8.5.0  smatch
arc                   randconfig-2200-20261118    gcc-9.5.0  smatch
arc                  randconfig-r2107-20261117    gcc-8.5.0  cocci
arc                  randconfig-r2302-20261117    gcc-16.2.0 sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                          assabet_defconfig    clang-22
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261118    gcc-8.5.0
arm                   randconfig-1001-20261118    gcc-8.5.0
arm                   randconfig-1002-20261118    gcc-10.5.0
arm                   randconfig-1003-20261118    gcc-8.5.0
arm                   randconfig-2000-20261117    gcc-10.5.0
arm                   randconfig-2000-20261118    gcc-13.5.0
arm                   randconfig-2001-20261117    gcc-10.5.0
arm                   randconfig-2001-20261117    gcc-12.5.0
arm                   randconfig-2001-20261118    gcc-13.5.0
arm                   randconfig-2002-20261117    gcc-10.5.0
arm                   randconfig-2002-20261118    gcc-13.5.0
arm                   randconfig-2200-20261118    gcc-8.5.0  smatch
arm                  randconfig-r2105-20261118    clang-24   cocci
arm                  randconfig-r2309-20261117    gcc-11.5.0 sparse
arm                            sunxi_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261118    clang-17
arm64                 randconfig-1001-20261118    gcc-13.5.0
arm64                 randconfig-1002-20261118    clang-18
arm64                 randconfig-1003-20261118    gcc-13.5.0
arm64                 randconfig-2000-20261117    gcc-10.5.0
arm64                 randconfig-2000-20261117    gcc-15.3.0
arm64                 randconfig-2000-20261118    gcc-13.5.0
arm64                 randconfig-2001-20261117    clang-21
arm64                 randconfig-2001-20261117    gcc-10.5.0
arm64                 randconfig-2001-20261118    gcc-13.5.0
arm64                 randconfig-2002-20261117    gcc-10.5.0
arm64                 randconfig-2002-20261117    gcc-15.3.0
arm64                 randconfig-2002-20261118    gcc-13.5.0
arm64                 randconfig-2200-20261118    clang-24   smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261118    gcc-16.2.0
csky                  randconfig-1001-20261118    gcc-16.2.0
csky                  randconfig-2000-20261117    gcc-16.2.0
csky                  randconfig-2000-20261118    gcc-16.2.0
csky                  randconfig-2001-20261117    gcc-16.2.0
csky                  randconfig-2001-20261118    gcc-16.2.0
csky                  randconfig-2200-20261117    gcc-14.4.0 smatch
csky                  randconfig-2200-20261118    gcc-16.2.0 smatch
csky                 randconfig-r2101-20261118    clang-24   cocci
csky                 randconfig-r2104-20261118    clang-24   cocci
csky                 randconfig-r2300-20261118    gcc-16.2.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261118    clang-24
hexagon               randconfig-1001-20261118    clang-22
hexagon               randconfig-2000-20261117    gcc-16.2.0
hexagon               randconfig-2000-20261118    gcc-16.2.0
hexagon               randconfig-2001-20261117    gcc-16.2.0
hexagon               randconfig-2001-20261118    gcc-16.2.0
hexagon               randconfig-2200-20261117    clang-17   smatch
hexagon               randconfig-2200-20261118    clang-20   smatch
hexagon              randconfig-r2105-20261118    clang-22   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261118    gcc-12
i386        buildonly-randconfig-1001-20261118    gcc-14
i386        buildonly-randconfig-1002-20261118    clang-22
i386        buildonly-randconfig-1003-20261118    gcc-14
i386        buildonly-randconfig-1004-20261118    clang-22
i386        buildonly-randconfig-1005-20261118    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1007-20261118    clang-22
i386                  randconfig-1008-20261118    clang-22
i386                  randconfig-1009-20261118    gcc-14
i386                  randconfig-1010-20261118    clang-22
i386                  randconfig-1011-20261118    gcc-14
i386                  randconfig-1012-20261118    clang-22
i386                  randconfig-1013-20261118    clang-22
i386                  randconfig-2000-20261117    clang-22
i386                  randconfig-2000-20261118    gcc-14
i386                  randconfig-2001-20261117    clang-22
i386                  randconfig-2001-20261118    gcc-14
i386                  randconfig-2002-20261117    clang-22
i386                  randconfig-2002-20261118    gcc-14
i386                  randconfig-2003-20261117    clang-22
i386                  randconfig-2003-20261118    gcc-14
i386                  randconfig-2004-20261117    clang-22
i386                  randconfig-2004-20261118    gcc-14
i386                  randconfig-2005-20261117    clang-22
i386                  randconfig-2005-20261118    gcc-14
i386                  randconfig-2100-20261117    clang-22   cocci
i386                  randconfig-2100-20261118    gcc-14     cocci
i386                  randconfig-2101-20261117    clang-22   cocci
i386                  randconfig-2101-20261118    gcc-14     cocci
i386                  randconfig-2102-20261117    clang-22   cocci
i386                  randconfig-2102-20261118    gcc-14     cocci
i386                  randconfig-2103-20261117    clang-22   cocci
i386                  randconfig-2103-20261118    gcc-14     cocci
i386                  randconfig-2104-20261117    clang-22   cocci
i386                  randconfig-2104-20261118    gcc-14     cocci
i386                  randconfig-2105-20261117    clang-22   cocci
i386                  randconfig-2105-20261118    gcc-14     cocci
i386                  randconfig-2200-20261118    gcc-13     smatch
i386                  randconfig-2300-20261117    clang-22   sparse
i386                  randconfig-2301-20261117    clang-22   sparse
i386                  randconfig-2302-20261117    clang-22   sparse
i386                 randconfig-r2110-20261118    clang-24   cocci
i386                 randconfig-r2311-20261117    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261118    gcc-16.2.0
loongarch             randconfig-1001-20261118    clang-20
loongarch             randconfig-2000-20261117    gcc-8.5.0
loongarch             randconfig-2000-20261118    gcc-11.5.0
loongarch             randconfig-2001-20261117    gcc-8.5.0
loongarch             randconfig-2001-20261118    gcc-11.5.0
loongarch             randconfig-2200-20261117    gcc-13.5.0 smatch
loongarch             randconfig-2200-20261118    gcc-16.2.0 smatch
loongarch            randconfig-r2304-20261117    gcc-16.2.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                         m5407c3_defconfig    gcc-16.2.0
m68k                          nettel_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261118    gcc-16.2.0
m68k                  randconfig-2001-20261118    gcc-16.2.0
m68k                  randconfig-2200-20261118    gcc-12.5.0 smatch
m68k                 randconfig-r2105-20261118    gcc-13.5.0 cocci
m68k                 randconfig-r2301-20261117    gcc-16.2.0 sparse
m68k                 randconfig-r2307-20261117    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
microblaze            randconfig-2000-20261118    gcc-16.2.0
microblaze            randconfig-2001-20261118    gcc-16.2.0
microblaze            randconfig-2200-20261117    gcc-14.4.0 smatch
microblaze            randconfig-2200-20261118    gcc-13.5.0 smatch
microblaze           randconfig-r2106-20261118    clang-24   cocci
microblaze           randconfig-r2107-20261117    gcc-8.5.0  cocci
microblaze           randconfig-r2109-20261118    clang-24   cocci
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  randconfig-2000-20261118    gcc-15.3.0
mips                  randconfig-2001-20261118    gcc-15.3.0
mips                  randconfig-2002-20261118    gcc-15.3.0
mips                  randconfig-2200-20261117    clang-24   smatch
mips                  randconfig-2200-20261118    clang-24   smatch
mips                 randconfig-r2100-20261118    clang-24   cocci
mips                 randconfig-r2102-20261118    clang-24   cocci
mips                 randconfig-r2108-20261117    clang-17   cocci
mips                 randconfig-r2109-20261117    gcc-8.5.0  cocci
mips                 randconfig-r2111-20261117    clang-24   cocci
mips                          rt305x_defconfig    clang-17
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261118    gcc-11.5.0
nios2                 randconfig-1001-20261118    gcc-8.5.0
nios2                 randconfig-2000-20261117    gcc-8.5.0
nios2                 randconfig-2000-20261118    gcc-11.5.0
nios2                 randconfig-2001-20261117    gcc-8.5.0
nios2                 randconfig-2001-20261118    gcc-11.5.0
nios2                 randconfig-2200-20261117    gcc-11.5.0 smatch
nios2                 randconfig-2200-20261118    gcc-8.5.0  smatch
nios2                randconfig-r2107-20261118    clang-24   cocci
nios2                randconfig-r2304-20261118    gcc-16.2.0 sparse
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc          de0_nano_multicore_defconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261118    gcc-15.3.0
openrisc              randconfig-2001-20261118    gcc-15.3.0
openrisc              randconfig-2002-20261118    gcc-15.3.0
openrisc              randconfig-2200-20261117    gcc-16.2.0 smatch
openrisc             randconfig-r2310-20261117    gcc-10.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261118    gcc-8.5.0
parisc                randconfig-1001-20261118    gcc-12.5.0
parisc                randconfig-2000-20261117    gcc-8.5.0
parisc                randconfig-2000-20261118    gcc-11.5.0
parisc                randconfig-2001-20261117    gcc-8.5.0
parisc                randconfig-2001-20261118    gcc-11.5.0
parisc                randconfig-2200-20261117    gcc-8.5.0  smatch
parisc                randconfig-2200-20261118    gcc-11.5.0 smatch
parisc               randconfig-r2110-20261117    gcc-8.5.0  cocci
parisc               randconfig-r2308-20261117    gcc-8.5.0  sparse
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261118    clang-24
powerpc               randconfig-1001-20261118    clang-24
powerpc               randconfig-2000-20261117    gcc-8.5.0
powerpc               randconfig-2000-20261118    clang-21
powerpc               randconfig-2001-20261117    gcc-8.5.0
powerpc               randconfig-2001-20261118    clang-21
powerpc               randconfig-2002-20261117    gcc-8.5.0
powerpc               randconfig-2002-20261118    clang-21
powerpc               randconfig-2200-20261117    gcc-8.5.0  smatch
powerpc               randconfig-2200-20261118    clang-24   smatch
powerpc              randconfig-r2102-20261118    clang-22   cocci
powerpc              randconfig-r2108-20261118    clang-24   cocci
powerpc                      redwood_defconfig    clang-24
powerpc64             randconfig-1000-20261118    gcc-11.5.0
powerpc64             randconfig-1001-20261118    clang-24
powerpc64             randconfig-2000-20261117    gcc-8.5.0
powerpc64             randconfig-2000-20261118    clang-21
powerpc64             randconfig-2001-20261117    gcc-8.5.0
powerpc64             randconfig-2001-20261118    clang-21
powerpc64             randconfig-2002-20261117    gcc-8.5.0
powerpc64             randconfig-2002-20261118    clang-21
powerpc64             randconfig-2200-20261117    gcc-8.5.0  smatch
powerpc64             randconfig-2200-20261118    clang-24   smatch
powerpc64            randconfig-r2306-20261117    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                     nommu_k210_defconfig    clang-24
riscv                 randconfig-1000-20261118    gcc-13.5.0
riscv                 randconfig-1001-20261118    gcc-11.5.0
riscv                 randconfig-2000-20261117    gcc-11.5.0
riscv                 randconfig-2000-20261118    gcc-8.5.0
riscv                 randconfig-2001-20261117    gcc-11.5.0
riscv                 randconfig-2001-20261118    gcc-8.5.0
riscv                 randconfig-2002-20261117    gcc-11.5.0
riscv                 randconfig-2002-20261118    gcc-8.5.0
riscv                 randconfig-2003-20261117    gcc-11.5.0
riscv                 randconfig-2003-20261118    gcc-8.5.0
riscv                 randconfig-2004-20261117    gcc-11.5.0
riscv                 randconfig-2004-20261118    gcc-8.5.0
riscv                 randconfig-2005-20261117    gcc-11.5.0
riscv                 randconfig-2005-20261118    gcc-8.5.0
riscv                 randconfig-2200-20261117    clang-24   smatch
riscv                 randconfig-2200-20261118    clang-24   smatch
riscv                randconfig-r2108-20261117    gcc-8.5.0  cocci
riscv                randconfig-r2300-20261117    gcc-16.2.0 sparse
riscv                randconfig-r2302-20261118    gcc-16.2.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261118    clang-24
s390                  randconfig-1001-20261118    gcc-11.5.0
s390                  randconfig-2000-20261117    gcc-13.5.0
s390                  randconfig-2000-20261117    gcc-15.3.0
s390                  randconfig-2000-20261118    clang-24
s390                  randconfig-2001-20261117    clang-24
s390                  randconfig-2001-20261117    gcc-15.3.0
s390                  randconfig-2001-20261118    clang-24
s390                  randconfig-2002-20261117    clang-17
s390                  randconfig-2002-20261117    gcc-15.3.0
s390                  randconfig-2002-20261118    clang-24
s390                  randconfig-2003-20261117    clang-24
s390                  randconfig-2003-20261117    gcc-15.3.0
s390                  randconfig-2003-20261118    clang-24
s390                  randconfig-2004-20261117    gcc-15.3.0
s390                  randconfig-2004-20261117    gcc-8.5.0
s390                  randconfig-2004-20261118    clang-24
s390                  randconfig-2005-20261117    gcc-15.3.0
s390                  randconfig-2005-20261118    clang-24
s390                  randconfig-2200-20261117    gcc-11.5.0 smatch
s390                  randconfig-2200-20261118    gcc-8.5.0  smatch
s390                 randconfig-r2111-20261118    clang-24   cocci
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261118    gcc-16.2.0
sh                    randconfig-1001-20261118    gcc-16.2.0
sh                    randconfig-2000-20261117    gcc-14.4.0
sh                    randconfig-2000-20261117    gcc-16.2.0
sh                    randconfig-2000-20261118    gcc-9.5.0
sh                    randconfig-2001-20261117    gcc-14.4.0
sh                    randconfig-2001-20261117    gcc-16.2.0
sh                    randconfig-2001-20261118    gcc-9.5.0
sh                    randconfig-2002-20261117    gcc-14.4.0
sh                    randconfig-2002-20261117    gcc-16.2.0
sh                    randconfig-2002-20261118    gcc-9.5.0
sh                    randconfig-2003-20261117    gcc-10.5.0
sh                    randconfig-2003-20261117    gcc-14.4.0
sh                    randconfig-2003-20261118    gcc-9.5.0
sh                    randconfig-2004-20261117    gcc-12.5.0
sh                    randconfig-2004-20261117    gcc-14.4.0
sh                    randconfig-2004-20261118    gcc-9.5.0
sh                    randconfig-2005-20261117    gcc-14.4.0
sh                    randconfig-2005-20261118    gcc-9.5.0
sh                    randconfig-2200-20261117    gcc-16.2.0 smatch
sh                    randconfig-2200-20261118    gcc-13.5.0 smatch
sh                   randconfig-r2100-20261118    clang-22   cocci
sh                   randconfig-r2110-20261117    gcc-16.2.0 cocci
sh                   randconfig-r2303-20261117    gcc-16.2.0 sparse
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-2000-20261117    gcc-14
sparc                 randconfig-2000-20261118    clang-24
sparc                 randconfig-2001-20261117    gcc-14
sparc                 randconfig-2001-20261118    clang-24
sparc                 randconfig-2200-20261118    gcc-13.5.0 smatch
sparc                randconfig-r2102-20261118    gcc-13.5.0 cocci
sparc                randconfig-r2106-20261117    gcc-8.5.0  cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-2000-20261117    gcc-14
sparc64               randconfig-2000-20261118    clang-24
sparc64               randconfig-2001-20261117    gcc-14
sparc64               randconfig-2001-20261118    clang-24
sparc64               randconfig-2200-20261117    gcc-8.5.0  smatch
sparc64               randconfig-2200-20261118    clang-22   smatch
sparc64              randconfig-r2103-20261118    clang-24   cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-2000-20261117    gcc-14
um                    randconfig-2000-20261118    clang-24
um                    randconfig-2001-20261117    gcc-14
um                    randconfig-2001-20261118    clang-24
um                    randconfig-2200-20261117    clang-21   smatch
um                    randconfig-2200-20261118    clang-24   smatch
um                   randconfig-r2106-20261117    clang-24   cocci
um                   randconfig-r2301-20261118    gcc-16.2.0 sparse
um                   randconfig-r2305-20261118    gcc-16.2.0 sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261118    gcc-14
x86_64      buildonly-randconfig-1001-20261118    gcc-12
x86_64      buildonly-randconfig-1002-20261118    gcc-12
x86_64      buildonly-randconfig-1003-20261118    clang-22
x86_64      buildonly-randconfig-1004-20261118    gcc-14
x86_64      buildonly-randconfig-1005-20261118    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1012-20261118    gcc-14
x86_64                randconfig-1013-20261118    clang-22
x86_64                randconfig-1014-20261118    gcc-14
x86_64                randconfig-1015-20261118    gcc-13
x86_64                randconfig-1016-20261118    clang-22
x86_64                randconfig-1017-20261118    gcc-14
x86_64                randconfig-2000-20261117    clang-22
x86_64                randconfig-2000-20261117    gcc-14
x86_64                randconfig-2000-20261118    gcc-13
x86_64                randconfig-2001-20261117    gcc-14
x86_64                randconfig-2001-20261118    gcc-13
x86_64                randconfig-2002-20261117    gcc-14
x86_64                randconfig-2002-20261118    gcc-13
x86_64                randconfig-2003-20261117    clang-22
x86_64                randconfig-2003-20261117    gcc-14
x86_64                randconfig-2003-20261118    gcc-13
x86_64                randconfig-2004-20261117    gcc-14
x86_64                randconfig-2004-20261118    gcc-13
x86_64                randconfig-2005-20261117    gcc-14
x86_64                randconfig-2005-20261118    gcc-13
x86_64                randconfig-2100-20261117    gcc-14     cocci
x86_64                randconfig-2101-20261117    gcc-14     cocci
x86_64                randconfig-2102-20261117    clang-22   cocci
x86_64                randconfig-2102-20261117    gcc-14     cocci
x86_64                randconfig-2103-20261117    clang-22   cocci
x86_64                randconfig-2103-20261117    gcc-14     cocci
x86_64                randconfig-2104-20261117    clang-22   cocci
x86_64                randconfig-2104-20261117    gcc-14     cocci
x86_64                randconfig-2105-20261117    clang-22   cocci
x86_64                randconfig-2105-20261117    gcc-14     cocci
x86_64                randconfig-2200-20261117    gcc-14     smatch
x86_64                randconfig-2200-20261118    clang-22   smatch
x86_64                randconfig-2300-20261117    clang-22   sparse
x86_64                randconfig-2301-20261117    clang-22   sparse
x86_64                randconfig-2302-20261117    clang-22   sparse
x86_64               randconfig-r2104-20261118    clang-22   cocci
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-2000-20261117    gcc-16.2.0
xtensa                randconfig-2000-20261118    gcc-16.2.0
xtensa                randconfig-2001-20261117    gcc-16.2.0
xtensa                randconfig-2001-20261118    gcc-16.2.0
xtensa                randconfig-2200-20261117    gcc-8.5.0  smatch
xtensa               randconfig-r2103-20261118    clang-22   cocci
xtensa               randconfig-r2111-20261117    gcc-8.5.0  cocci
xtensa               randconfig-r2305-20261117    gcc-16.2.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
