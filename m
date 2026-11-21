Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795223116;
	b=5lplQwHfDenI+Zt30riRxtzmuw5Tnv/YTk1rc5K8cmFxtVfC6PpO6QNc++m5pxilPMrb
	 P1o+iPoqfZ22tCdNF0VCc96vsFpfaxuySwucDG+od1BBtPEfzM8xZ74N0cFS6B8xA9LnO
	 8MYSjx7bnwy0pSPwu5J53d1AOPl9S97Gv+zCuboAh9J5BSQDRoPAsw4HSdBPYpQ75tVqy
	 y4KLPNRKIUYg4eWDMXYzbA8oYiYkBjBqlT++3Z7+qL4tErFuSYRxVUbT/DJ6oxeagLLNQ
	 EtPFtUDoeVwcCiMnb/zJCQ6MBnheKHJQEr8CCwMH6dBhYs9nXaSPWHon+5pD0qm0W2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795223116;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=D6MUpByqUl21YvI4aTwA26R8B7fmmb3EiqJS1yLvH2A=;
	b=pu4qPMPjBpC2ZGAL1tKIk4ZzDXlxdKo6O9R0tcVDbJRoVZercyVGYFR4y4NcAe9oNrQy
	 w2dfNeoBDXu4L6+UbOfTjRMdoqlWbVSLjOdqGzbqi63qvXGsea5CCXjxp117xCGmnNZRZ
	 e/0qthquy1jjKhcbkYpSsKCXQLM1H7TSeyGikUFjMcbLV40RU7Mtj619TOKuszxRAV7Rc
	 Kgti72OIV9vpYWDJf52qZUg9rLnQIabA4/DpOxGZRsfknJL/W0OUArtiXZinTlWHJeNgL
	 9RYdz9zmjfItRdcNUKZbDVPDSEjpShBD/cXCZrlM+9ByFprSqk9wTVwQy8tUz/FyKzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ccer8QBC;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9F1606A6B3
	for <mm-commits@vger.kernel.org>; Sat, 21 Nov 2026 01:05:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD9F1606A6B3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ccer8QBC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795223112; x=1826759112;
  h=date:from:to:cc:subject:message-id;
  bh=qkG1UrMDZs2x+TcV8lFs/sjiNEueuWccC0DFQWLou1U=;
  b=Ccer8QBCOeGzYBIWaifX76zpp/U7T/uEoPkkCv1HMqIP4+yo3aLAvCPt
   CIb7PQ8TDjkl/1Iu8AzuWV0IISroVyF+qZ2bAsf27FDlhgmRkHMQ1vf/B
   4vYqsQau7lPNO3mDEoAy1pYZ9OcuXa0LihgjOFHynFbB6RdmBR4k8hdyB
   I8CyrvmHWPaXnbxcyip5yLvy7n4D3BD0cF1IBnCIs7mv5YGe27XW5/Dbl
   BZc+h1JERyQy0E4y1t8XhxvfcjlzRRdONu8TQ6Z1bMqS1LzTxzds42DCN
   FnMx7D60CWrdW6G8IrHLrEGaMuqovIMMgECrIYOTC4NTNh3gOwxnsxT7o
   A==;
X-CSE-ConnectionGUID: 5snTVTPDSoGnBbMKzkyEnA==
X-CSE-MsgGUID: PTtxMHpGRzStS5AmHbUhBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4116066"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4116066"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 17:05:12 -0800
X-CSE-ConnectionGUID: +qcKEWHxQXCdMEx1EZsaDg==
X-CSE-MsgGUID: wXMdizheQVSLGIwPvmK++A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="11170173"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 20 Nov 2026 17:05:10 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUZXQ-00000001J6V-02Ze;
	Sat, 21 Nov 2026 01:05:08 +0000
Date: Sat, 21 Nov 2026 09:04:57 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 15f114dac9a7bde1796f0e54e22726fd31cfa8a5
Message-ID: <20261121090457.sQENk6l3-lkp@intel.com>
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
branch HEAD: 15f114dac9a7bde1796f0e54e22726fd31cfa8a5  lib/test_hmm: fix alloc tag leak when splitting device-private folios

elapsed time: 1091m

configs tested: 308
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                 randconfig-2000-20261120    gcc-13.5.0
alpha                 randconfig-2001-20261120    gcc-15.3.0
alpha                 randconfig-2200-20261120    gcc-15.3.0 smatch
alpha                randconfig-r2302-20261120    gcc-15.3.0 sparse
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                       axs103_smp_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261120    clang-17
arc                   randconfig-1000-20261121    clang-24
arc                   randconfig-1001-20261120    clang-17
arc                   randconfig-1001-20261121    clang-24
arc                   randconfig-2200-20261120    gcc-15.3.0 smatch
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                         clps711x_defconfig    gcc-16.2.0
arm                        omap2plus_defconfig    gcc-16.2.0
arm                           pxa168_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261120    clang-17
arm                   randconfig-1000-20261121    clang-24
arm                   randconfig-1001-20261120    clang-17
arm                   randconfig-1001-20261121    clang-24
arm                   randconfig-1002-20261120    clang-17
arm                   randconfig-1002-20261121    clang-24
arm                   randconfig-1003-20261120    clang-17
arm                   randconfig-1003-20261121    clang-24
arm                   randconfig-2000-20261120    gcc-11.5.0
arm                   randconfig-2001-20261120    gcc-8.5.0
arm                   randconfig-2002-20261120    clang-24
arm                   randconfig-2200-20261120    clang-17   smatch
arm                              rpc_defconfig    gcc-16.2.0
arm                         shmobile_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                 randconfig-1000-20261120    clang-18
arm64                 randconfig-1000-20261120    clang-24
arm64                 randconfig-1001-20261120    clang-18
arm64                 randconfig-1001-20261120    gcc-8.5.0
arm64                 randconfig-1002-20261120    clang-18
arm64                 randconfig-1003-20261120    clang-18
arm64                 randconfig-1003-20261120    clang-24
arm64                 randconfig-2000-20261120    clang-24
arm64                 randconfig-2001-20261120    gcc-8.5.0
arm64                 randconfig-2002-20261120    gcc-14.4.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                  randconfig-1000-20261120    clang-18
csky                  randconfig-1000-20261120    gcc-16.2.0
csky                  randconfig-1001-20261120    clang-18
csky                  randconfig-1001-20261120    gcc-12.5.0
csky                  randconfig-2001-20261120    gcc-16.2.0
csky                  randconfig-2200-20261120    gcc-15.3.0 smatch
csky                 randconfig-r2300-20261120    gcc-16.2.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon               randconfig-1000-20261120    gcc-10.5.0
hexagon               randconfig-1000-20261121    gcc-11.5.0
hexagon               randconfig-1001-20261120    gcc-10.5.0
hexagon               randconfig-1001-20261121    gcc-11.5.0
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261121    gcc-13
i386        buildonly-randconfig-1001-20261121    gcc-13
i386        buildonly-randconfig-1002-20261121    gcc-13
i386        buildonly-randconfig-1003-20261121    gcc-13
i386        buildonly-randconfig-1004-20261121    gcc-13
i386        buildonly-randconfig-1005-20261121    gcc-13
i386                  randconfig-1000-20261120    clang-22
i386                  randconfig-1000-20261120    gcc-14
i386                  randconfig-1001-20261120    clang-22
i386                  randconfig-1002-20261120    clang-22
i386                  randconfig-1003-20261120    clang-22
i386                  randconfig-1004-20261120    clang-22
i386                  randconfig-1005-20261120    clang-22
i386                  randconfig-1006-20261120    clang-22
i386                  randconfig-1006-20261120    gcc-14
i386                  randconfig-1007-20261120    clang-22
i386                  randconfig-1008-20261120    clang-22
i386                  randconfig-1009-20261120    clang-22
i386                  randconfig-1010-20261120    clang-22
i386                  randconfig-1011-20261120    clang-22
i386                  randconfig-1012-20261120    clang-22
i386                  randconfig-1013-20261120    clang-22
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261120    gcc-10.5.0
loongarch             randconfig-1000-20261121    gcc-11.5.0
loongarch             randconfig-1001-20261120    gcc-10.5.0
loongarch             randconfig-1001-20261121    gcc-11.5.0
loongarch             randconfig-2200-20261120    clang-18   smatch
loongarch            randconfig-r2101-20261120    clang-24   cocci
loongarch            randconfig-r2305-20261120    gcc-12.5.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5275evb_defconfig    gcc-16.2.0
m68k                         mvme16x_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261120    gcc-12.5.0
m68k                  randconfig-2001-20261120    gcc-8.5.0
m68k                  randconfig-2200-20261120    gcc-14.4.0 smatch
m68k                 randconfig-r2303-20261120    gcc-9.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261120    gcc-9.5.0
microblaze            randconfig-2200-20261120    gcc-11.5.0 smatch
microblaze           randconfig-r2308-20261120    gcc-15.3.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                 econet_en751221_defconfig    gcc-16.2.0
mips                           eyeq5_defconfig    gcc-16.2.0
mips                      loongson2k_defconfig    gcc-16.2.0
mips                       maltasmvp_defconfig    gcc-16.2.0
mips                  randconfig-2200-20261120    clang-24   smatch
mips                 randconfig-r2307-20261120    clang-24   sparse
mips                 randconfig-r2311-20261120    clang-24   sparse
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261120    gcc-10.5.0
nios2                 randconfig-1000-20261121    gcc-11.5.0
nios2                 randconfig-1001-20261120    gcc-10.5.0
nios2                 randconfig-1001-20261121    gcc-11.5.0
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261120    gcc-9.5.0
openrisc              randconfig-2200-20261120    gcc-11.5.0 smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                 generic-32bit_defconfig    gcc-16.2.0
parisc                randconfig-1000-20261120    gcc-11.5.0
parisc                randconfig-1000-20261121    gcc-10.5.0
parisc                randconfig-1001-20261120    gcc-11.5.0
parisc                randconfig-1001-20261121    gcc-10.5.0
parisc                randconfig-2200-20261120    gcc-8.5.0  smatch
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                       chrp32_defconfig    gcc-16.2.0
powerpc                         icon_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261120    gcc-11.5.0
powerpc               randconfig-1000-20261121    gcc-10.5.0
powerpc               randconfig-1001-20261120    gcc-11.5.0
powerpc               randconfig-1001-20261121    gcc-10.5.0
powerpc               randconfig-2200-20261120    clang-17   smatch
powerpc              randconfig-r2306-20261120    gcc-16.2.0 sparse
powerpc                      taishan_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261120    gcc-11.5.0
powerpc64             randconfig-1000-20261121    gcc-10.5.0
powerpc64             randconfig-1001-20261120    gcc-11.5.0
powerpc64             randconfig-1001-20261121    gcc-10.5.0
powerpc64             randconfig-2200-20261120    gcc-16.2.0 smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261120    gcc-11.5.0
riscv                 randconfig-1000-20261121    clang-17
riscv                 randconfig-1001-20261120    gcc-11.5.0
riscv                 randconfig-1001-20261121    clang-17
riscv                 randconfig-2001-20261120    gcc-10.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261120    gcc-11.5.0
s390                  randconfig-1000-20261121    clang-17
s390                  randconfig-1001-20261120    gcc-11.5.0
s390                  randconfig-1001-20261121    clang-17
s390                  randconfig-2000-20261120    gcc-8.5.0
s390                  randconfig-2200-20261120    clang-17   smatch
s390                        zfcpdump_defconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.2.0
sh                 ecovec24-romimage_defconfig    gcc-16.2.0
sh                           kfr2r09_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261120    gcc-11.5.0
sh                    randconfig-1000-20261121    clang-17
sh                    randconfig-1001-20261120    gcc-11.5.0
sh                    randconfig-1001-20261121    clang-17
sh                    randconfig-2000-20261120    gcc-16.2.0
sh                    randconfig-2001-20261120    gcc-16.2.0
sh                    randconfig-2002-20261120    gcc-16.2.0
sh                    randconfig-2003-20261120    gcc-11.5.0
sh                    randconfig-2004-20261120    gcc-16.2.0
sh                    randconfig-2005-20261120    gcc-15.3.0
sh                    randconfig-2200-20261120    gcc-11.5.0 smatch
sh                   randconfig-r2309-20261120    gcc-13.5.0 sparse
sh                         sh7785lcr_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261121    gcc-14
sparc                 randconfig-1000-20261121    gcc-8.5.0
sparc                 randconfig-1001-20261121    gcc-14
sparc                 randconfig-1001-20261121    gcc-8.5.0
sparc                 randconfig-2000-20261120    gcc-16.2.0
sparc                 randconfig-2001-20261120    gcc-8.5.0
sparc                randconfig-r2301-20261120    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261121    clang-20
sparc64               randconfig-1000-20261121    gcc-14
sparc64               randconfig-1001-20261121    clang-20
sparc64               randconfig-1001-20261121    gcc-14
sparc64               randconfig-2000-20261120    gcc-8.5.0
sparc64               randconfig-2001-20261120    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261121    gcc-14
um                    randconfig-1001-20261121    clang-24
um                    randconfig-1001-20261121    gcc-14
um                    randconfig-2000-20261120    clang-24
um                    randconfig-2001-20261120    gcc-14
um                    randconfig-2200-20261120    clang-24   smatch
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261120    clang-22
x86_64      buildonly-randconfig-1001-20261120    clang-22
x86_64      buildonly-randconfig-1002-20261120    clang-22
x86_64      buildonly-randconfig-1003-20261120    clang-22
x86_64      buildonly-randconfig-1004-20261120    clang-22
x86_64      buildonly-randconfig-1005-20261120    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261120    clang-22
x86_64                randconfig-1000-20261121    clang-22
x86_64                randconfig-1001-20261120    clang-22
x86_64                randconfig-1001-20261121    clang-22
x86_64                randconfig-1002-20261120    clang-22
x86_64                randconfig-1002-20261121    clang-22
x86_64                randconfig-1003-20261120    clang-22
x86_64                randconfig-1003-20261121    clang-22
x86_64                randconfig-1004-20261120    clang-22
x86_64                randconfig-1004-20261121    clang-22
x86_64                randconfig-1005-20261120    clang-22
x86_64                randconfig-1005-20261121    clang-22
x86_64                randconfig-1006-20261121    clang-22
x86_64                randconfig-1007-20261121    clang-22
x86_64                randconfig-1008-20261121    gcc-14
x86_64                randconfig-1009-20261121    clang-22
x86_64                randconfig-1010-20261121    gcc-14
x86_64                randconfig-1011-20261121    clang-22
x86_64                randconfig-1012-20261120    clang-22
x86_64                randconfig-1013-20261120    clang-22
x86_64                randconfig-1014-20261120    clang-22
x86_64                randconfig-1015-20261120    clang-22
x86_64                randconfig-1016-20261120    clang-22
x86_64                randconfig-1017-20261120    clang-22
x86_64                randconfig-2000-20261120    gcc-14
x86_64                randconfig-2001-20261120    gcc-14
x86_64                randconfig-2002-20261120    clang-22
x86_64                randconfig-2003-20261120    clang-22
x86_64                randconfig-2005-20261120    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                            alldefconfig    gcc-16.2.0
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261121    gcc-14
xtensa                randconfig-1000-20261121    gcc-8.5.0
xtensa                randconfig-1001-20261121    gcc-11.5.0
xtensa                randconfig-1001-20261121    gcc-14
xtensa                randconfig-2200-20261120    gcc-9.5.0  smatch
xtensa               randconfig-r2310-20261120    gcc-15.3.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
