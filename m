Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEF73BED7A
	for <mm-commits@vger.kernel.org>; Sat, 17 Oct 2026 03:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206030; cv=none; b=lV5HpTBUNp01+fShtFmcUi47sS9Cb75P1JgoPCp/F5/S92zZ5oKPhh3tfR0fkqudv+b/zNt/1qWJiYmvAiFHKISmpIEBCwZB+XIjOiO7EoY+YYS2FXH4YM4Bfn7uxAbTJ4xhNZthY1u5QhwWh80v8aywHuo9agIzwiCqoiMN7WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206030; c=relaxed/simple;
	bh=yhkxpKG7hbFe7QFxlmahDP4c51CYA/HTlvgm6wjdRbg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=lkDJKwHQp84qBtWPZbbNfDdYV3+y+0Oj5fIgpT67nA9YrBQzFb8iC8ZyMaYariWoBBWqJ650yJnIQnH98ACK1SCHs0xUfb+UMAgaKJQaDkbCurBQQ74eCW9ZQN0ONUqrDgkXkVBfE184rw+4geJsprSj0apUKlPiIL1osmcSCCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MB3CTKqP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MB3CTKqP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792206016; x=1823742016;
  h=date:from:to:cc:subject:message-id;
  bh=yhkxpKG7hbFe7QFxlmahDP4c51CYA/HTlvgm6wjdRbg=;
  b=MB3CTKqPdWfAMfbsDhUYvuU94krawxoSmyIhLDjvVR7kLvDH9Jn+DWA7
   ilNYdMMyfhBmXFSyepmhVn7Ur0mQuUQ9JS8Fjh+hL7B0Soiq2YZu0Qakz
   /dmi+M54c0Wku3hkVS4PEQ/QAOuSnCXOLMohX7lpHABl4D1dMg+S33pac
   Te0LA/uBMI4zukg/5kVLVuJ/UIDkIobByIPDojrP9c6a2bOrJ4ktKnhCQ
   kYo2w9r4cmyw4HP9Ey/8f5CFwl6ySWBmFvjukVqf9C8cOA9YGxbz0AlM6
   oAzNhdr7T1zoFNsBRw2tNZQulguUHG2dipKhD8IWurwitLMw0a75+G2GP
   g==;
X-CSE-ConnectionGUID: Nev7LkrATGqBGbAO33UKKw==
X-CSE-MsgGUID: MII/HkTJTE+mt2pD4bOYfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11937"; a="1090294"
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="1090294"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 20:00:15 -0700
X-CSE-ConnectionGUID: NN3EKJJKSDeys0y3LUpJQg==
X-CSE-MsgGUID: 7Uv9Dm1WT+e1EagwLGq+sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="2144040"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 16 Oct 2026 20:00:13 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHueY-00000000IzS-40RJ;
	Sat, 17 Oct 2026 03:00:10 +0000
Date: Sat, 17 Oct 2026 10:59:15 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
Message-ID: <202610171013.FZ7lgaJX-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596  riscv: mm: exclude invalid THP PMDs from page table check

elapsed time: 804m

configs tested: 245
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2202-20261016    gcc-15.2.0 smatch
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261017    gcc-12.5.0
arc                   randconfig-1001-20261017    gcc-10.5.0
arc                   randconfig-2000-20261016    gcc-8.5.0
arc                   randconfig-2001-20261016    gcc-8.5.0
arc                  randconfig-r2107-20261016    gcc-8.5.0  cocci
arc                  randconfig-r2305-20261016    gcc-13.4.0 sparse
arc                  randconfig-r2308-20261016    gcc-15.2.0 sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           ep93xx_defconfig    clang-24
arm                          lpc18xx_defconfig    clang-24
arm                             qcom_defconfig    clang-24
arm                   randconfig-1000-20261017    gcc-8.5.0
arm                   randconfig-1001-20261017    clang-20
arm                   randconfig-1002-20261017    gcc-10.5.0
arm                   randconfig-1003-20261017    clang-22
arm                   randconfig-2000-20261016    gcc-12.5.0
arm                   randconfig-2001-20261016    gcc-8.5.0
arm                              rpc_defconfig    clang-19
arm                            sunxi_defconfig    gcc-16.1.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261016    gcc-8.5.0
arm64                 randconfig-1001-20261016    clang-19
arm64                 randconfig-1002-20261016    gcc-8.5.0
arm64                 randconfig-1003-20261016    clang-17
arm64                 randconfig-2000-20261016    gcc-13.4.0
arm64                 randconfig-2001-20261016    clang-18
arm64                randconfig-r2100-20261016    gcc-9.5.0  cocci
arm64                randconfig-r2310-20261016    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261016    gcc-13.4.0
csky                  randconfig-1001-20261016    gcc-11.5.0
csky                  randconfig-2000-20261016    gcc-16.1.0
csky                  randconfig-2001-20261016    gcc-12.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261016    clang-24
hexagon               randconfig-1001-20261016    clang-17
hexagon               randconfig-2000-20261016    clang-22
hexagon               randconfig-2001-20261016    clang-22
hexagon              randconfig-r2103-20261016    clang-17   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261017    clang-22
i386        buildonly-randconfig-1001-20261017    gcc-14
i386        buildonly-randconfig-1002-20261017    clang-22
i386        buildonly-randconfig-1003-20261017    gcc-14
i386        buildonly-randconfig-1004-20261017    clang-22
i386        buildonly-randconfig-1005-20261017    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261017    gcc-14
i386                  randconfig-1001-20261017    clang-22
i386                  randconfig-1002-20261017    gcc-14
i386                  randconfig-1003-20261017    gcc-14
i386                  randconfig-1004-20261017    gcc-14
i386                  randconfig-1005-20261017    gcc-14
i386                  randconfig-1006-20261017    gcc-14
i386                  randconfig-1007-20261016    clang-22
i386                  randconfig-1008-20261016    gcc-14
i386                  randconfig-1009-20261016    gcc-13
i386                  randconfig-1010-20261016    clang-22
i386                  randconfig-1011-20261016    clang-22
i386                  randconfig-1012-20261016    gcc-14
i386                  randconfig-1013-20261016    gcc-12
i386                  randconfig-2000-20261016    clang-22
i386                  randconfig-2001-20261016    clang-22
i386                  randconfig-2100-20261016    gcc-14     cocci
i386                  randconfig-2101-20261016    clang-22   cocci
i386                  randconfig-2102-20261016    clang-22   cocci
i386                  randconfig-2103-20261016    gcc-14     cocci
i386                  randconfig-2104-20261016    clang-22   cocci
i386                  randconfig-2105-20261016    clang-22   cocci
i386                  randconfig-2200-20261016    clang-22   smatch
i386                  randconfig-2300-20261016    gcc-14     sparse
i386                  randconfig-2301-20261016    clang-22   sparse
i386                  randconfig-2302-20261016    clang-22   sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261016    gcc-16.1.0
loongarch             randconfig-1001-20261016    clang-24
loongarch             randconfig-2000-20261016    gcc-16.1.0
loongarch             randconfig-2001-20261016    clang-18
loongarch            randconfig-r2304-20261016    gcc-13.4.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2104-20261016    gcc-8.5.0  cocci
microblaze           randconfig-r2105-20261016    gcc-12.5.0 cocci
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261016    gcc-11.5.0
nios2                 randconfig-1001-20261016    gcc-8.5.0
nios2                 randconfig-2000-20261016    gcc-8.5.0
nios2                 randconfig-2001-20261016    gcc-11.5.0
nios2                randconfig-r2309-20261016    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2301-20261016    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261016    gcc-15.2.0
parisc                randconfig-1000-20261017    gcc-10.5.0
parisc                randconfig-1001-20261017    gcc-8.5.0
parisc                randconfig-2000-20261016    gcc-8.5.0
parisc                randconfig-2001-20261016    gcc-10.5.0
parisc               randconfig-r2307-20261016    gcc-8.5.0  sparse
parisc               randconfig-r2311-20261016    gcc-8.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       pmac32_defconfig    clang-24
powerpc               randconfig-1000-20261017    clang-17
powerpc               randconfig-1001-20261017    gcc-15.2.0
powerpc               randconfig-2000-20261016    gcc-11.5.0
powerpc               randconfig-2001-20261016    gcc-9.5.0
powerpc64             randconfig-1000-20261017    clang-20
powerpc64             randconfig-1001-20261017    gcc-8.5.0
powerpc64             randconfig-2000-20261016    clang-24
powerpc64             randconfig-2001-20261016    gcc-8.5.0
powerpc64            randconfig-r2110-20261016    gcc-16.1.0 cocci
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261017    clang-19
riscv                 randconfig-1001-20261017    clang-24
riscv                 randconfig-2000-20261016    clang-24
riscv                 randconfig-2001-20261016    clang-24
riscv                randconfig-r2102-20261016    gcc-9.5.0  cocci
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261017    clang-24
s390                  randconfig-1001-20261017    clang-24
s390                  randconfig-2000-20261016    clang-24
s390                  randconfig-2001-20261016    gcc-8.5.0
s390                 randconfig-r2108-20261016    clang-24   cocci
s390                 randconfig-r2303-20261016    clang-17   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                           landisk_defconfig    gcc-16.1.0
sh                           lboxre2_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261017    gcc-16.1.0
sh                    randconfig-1001-20261017    gcc-10.5.0
sh                    randconfig-2000-20261016    gcc-16.1.0
sh                    randconfig-2001-20261016    gcc-12.5.0
sh                   randconfig-r2106-20261016    gcc-14.3.0 cocci
sh                   randconfig-r2111-20261016    gcc-15.2.0 cocci
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261016    gcc-16.1.0
sparc                 randconfig-1001-20261016    gcc-15.2.0
sparc                 randconfig-2000-20261016    gcc-16.1.0
sparc                 randconfig-2001-20261016    gcc-12.5.0
sparc                randconfig-r2200-20261016    gcc-8.5.0  smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261016    clang-20
sparc64               randconfig-1001-20261016    clang-24
sparc64               randconfig-2000-20261016    clang-24
sparc64               randconfig-2001-20261016    clang-24
sparc64              randconfig-r2109-20261016    gcc-13.4.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261016    gcc-14
um                    randconfig-1001-20261016    gcc-14
um                    randconfig-2000-20261016    clang-17
um                    randconfig-2001-20261016    gcc-14
um                   randconfig-r2101-20261016    clang-24   cocci
um                   randconfig-r2300-20261016    clang-17   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261017    gcc-14
x86_64      buildonly-randconfig-1001-20261017    clang-22
x86_64      buildonly-randconfig-1002-20261017    gcc-14
x86_64      buildonly-randconfig-1003-20261017    gcc-12
x86_64      buildonly-randconfig-1004-20261017    clang-22
x86_64      buildonly-randconfig-1005-20261017    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261017    gcc-14
x86_64                randconfig-1001-20261017    clang-22
x86_64                randconfig-1002-20261017    clang-22
x86_64                randconfig-1003-20261017    gcc-12
x86_64                randconfig-1004-20261017    gcc-14
x86_64                randconfig-1005-20261017    gcc-12
x86_64                randconfig-1006-20261017    clang-22
x86_64                randconfig-1007-20261017    clang-22
x86_64                randconfig-1008-20261017    gcc-12
x86_64                randconfig-1009-20261017    gcc-14
x86_64                randconfig-1010-20261017    gcc-13
x86_64                randconfig-1011-20261017    clang-22
x86_64                randconfig-1012-20261016    gcc-14
x86_64                randconfig-1013-20261016    gcc-12
x86_64                randconfig-1014-20261016    gcc-14
x86_64                randconfig-1015-20261016    gcc-14
x86_64                randconfig-1016-20261016    clang-22
x86_64                randconfig-1017-20261016    clang-22
x86_64                randconfig-2000-20261016    clang-22
x86_64                randconfig-2001-20261016    gcc-14
x86_64                randconfig-2100-20261016    gcc-14     cocci
x86_64                randconfig-2101-20261016    clang-22   cocci
x86_64                randconfig-2102-20261016    clang-22   cocci
x86_64                randconfig-2103-20261016    clang-22   cocci
x86_64                randconfig-2104-20261016    clang-22   cocci
x86_64                randconfig-2105-20261016    gcc-14     cocci
x86_64                randconfig-2200-20261016    gcc-14     smatch
x86_64                randconfig-2300-20261016    clang-22   sparse
x86_64                randconfig-2301-20261016    clang-22   sparse
x86_64                randconfig-2302-20261016    clang-22   sparse
x86_64               randconfig-r2201-20261016    gcc-14     smatch
x86_64               randconfig-r2302-20261016    clang-22   sparse
x86_64               randconfig-r2306-20261016    clang-22   sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261016    gcc-11.5.0
xtensa                randconfig-1001-20261016    gcc-9.5.0
xtensa                randconfig-2000-20261016    gcc-12.5.0
xtensa                randconfig-2001-20261016    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
