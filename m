Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793930064;
	b=MRi82DUZUOsJut8K8ZkrhRDlp2V/sgrYVOXMJBjqnYg5Wx1HQiTWDlOCZEQORFjqgISP
	 Zsup79AJLr6ROMHYbdORTFZme0t3cgcjQClFec3pi8Ow7202z8nRBE7dd4LJ7hCwbNpJX
	 iylAsyrYmkwgpaRjrbnccbJ5NAG0k43ctlTmRMDqYEcB4d12+RJ7gzyAXxS+XkzyYBNOt
	 i5IjEBkln9iICWEbWZTpvodwnn9ZyfsZIFFDweV1fb0UVeJrIrmpq+TKAgNiZ2KmpdA73
	 8g2wB7t0FqaVryJOeocCDA42zumxsVBNjz/hTOKeWcdKNYvn9UPPIdb2ybggUa16kTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793930064;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=OzMiBDaS7l6UuJBibgUYEdXexUSYxGYeqcUpMn0sCvw=;
	b=e3X5+rc5Nw1+wXI9awafZaWlEYnLYZEGXaAS0Qj39XSITEZrq9uH6mYt+GZkvt3GEjog
	 OkIiuivKNM/W6i8YVRpkOxenWRszAP8LaHac+VZ8W+KjiI3cUvXjVOmY63EPvQDfGy7EE
	 MNMcfD2QNrHsitUhj8n4uyaFnEqZyly2j0WGkL57gm8VOtKjddX6BdhquR5zBK2WY8mcb
	 FdNVJ8kd3rTsW3c1YlQyMYLiKCULsTZAigc+JwaaG7LJfNctRQghFlWqDtSlZcX9qLdNx
	 NjPvVjNCmRv+q7o2y9sMZAa3schuZACjEpD17eMtLZmAuzS5VJ5w2QtO6iJFOarVMaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Q5Ip36GT;
	arc=none smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AC8606A33B
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 01:54:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45AC8606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Q5Ip36GT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793930063; x=1825466063;
  h=date:from:to:cc:subject:message-id;
  bh=L+qunJOHFga32xwjkuKGKZmxtc8ksnVinIWaJwTYBtU=;
  b=Q5Ip36GTVqfFsLs3+Houxo29w5hWv2IXothDB3NQ/hHVCj6rhWe/ULyq
   /PjDvwcDnc+rKLJvTAB1cKMf55y0yNd/Un53rLAMyzVrGSppcNIdB6DNe
   wsniCBWjm33THvxuXaqqOlxy2IqnUX6PBLRPjfhqS4/otEjySO4gYNKaP
   t+Mki+akZ5FIK8/kCKKVJt/qSbLM64UkouLMn0aAuiKT2cEbjiCSQ8QBE
   Kch624uMERdofM+0pix9aBg9f2uluQP/zsnktU3QZDmTNF3ujo5Ml9dre
   KMuA7fPKBIPpRt35u/iSlx+cI0qeUkZd1WQp+m0WgK4cvikX1Vi4AB/xb
   A==;
X-CSE-ConnectionGUID: TkPMPF8KRa6tWzHj2bDSwg==
X-CSE-MsgGUID: GvnbAjzkR4a7nMjq/z63mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2756210"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2756210"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 17:54:22 -0800
X-CSE-ConnectionGUID: eDDvYLrRTYKk6HXcsyQQ9w==
X-CSE-MsgGUID: P1njgYiMRoWioRZounNv8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7150858"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Nov 2026 17:54:20 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xP99m-00000000nBP-0Anl;
	Fri, 06 Nov 2026 01:54:18 +0000
Date: Fri, 06 Nov 2026 09:53:40 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
Message-ID: <20261106095340.lgMcCHGK-lkp@intel.com>
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
branch HEAD: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263  riscv: mm: fix concurrency in mark_new_valid_map()

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-net-wireless-ath-ath11k-dbring.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 1078m

configs tested: 347
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261105    gcc-11.5.0
alpha                 randconfig-2001-20261105    gcc-8.5.0
alpha                 randconfig-2200-20261105    gcc-9.5.0  smatch
alpha                randconfig-r2104-20261105    gcc-11.5.0 cocci
alpha                randconfig-r2105-20261105    gcc-9.5.0  cocci
alpha                randconfig-r2111-20261105    gcc-14.4.0 cocci
alpha                randconfig-r2310-20261105    gcc-8.5.0  sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261105    gcc-14.4.0
arc                   randconfig-1001-20261105    gcc-14.4.0
arc                   randconfig-2000-20261105    gcc-8.5.0
arc                   randconfig-2001-20261105    gcc-8.5.0
arc                   randconfig-2002-20261105    gcc-15.3.0
arc                   randconfig-2003-20261105    gcc-9.5.0
arc                   randconfig-2004-20261105    gcc-15.3.0
arc                   randconfig-2005-20261105    gcc-13.5.0
arc                   randconfig-2200-20261105    gcc-8.5.0  smatch
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                       integrator_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261105    gcc-14.4.0
arm                   randconfig-1001-20261105    gcc-14.4.0
arm                   randconfig-1002-20261105    gcc-14.4.0
arm                   randconfig-1003-20261105    gcc-14.4.0
arm                   randconfig-2000-20261105    gcc-10.5.0
arm                   randconfig-2001-20261105    clang-20
arm                   randconfig-2200-20261105    gcc-15.3.0 smatch
arm                          s3c6400_defconfig    gcc-16.2.0
arm                            sama5_defconfig    gcc-16.2.0
arm                            sunxi_defconfig    gcc-16.2.0
arm                            u8500_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261105    gcc-13.5.0
arm64                 randconfig-1001-20261105    gcc-13.5.0
arm64                 randconfig-1002-20261105    gcc-13.5.0
arm64                 randconfig-1003-20261105    gcc-13.5.0
arm64                 randconfig-2200-20261105    clang-20   smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261105    gcc-13.5.0
csky                  randconfig-1001-20261105    gcc-13.5.0
csky                  randconfig-2000-20261105    gcc-16.2.0
csky                  randconfig-2001-20261105    gcc-13.5.0
csky                  randconfig-2200-20261105    gcc-9.5.0  smatch
csky                 randconfig-r2107-20261105    gcc-12.5.0 cocci
csky                 randconfig-r2301-20261105    gcc-10.5.0 sparse
csky                 randconfig-r2306-20261105    gcc-16.2.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261105    clang-19
hexagon               randconfig-1000-20261105    clang-24
hexagon               randconfig-1001-20261105    clang-24
hexagon               randconfig-2000-20261105    clang-24
hexagon               randconfig-2001-20261105    clang-24
hexagon               randconfig-2200-20261105    clang-17   smatch
hexagon              randconfig-r2109-20261105    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261105    gcc-14
i386        buildonly-randconfig-1000-20261106    clang-22
i386        buildonly-randconfig-1001-20261105    gcc-14
i386        buildonly-randconfig-1001-20261106    clang-22
i386        buildonly-randconfig-1002-20261105    gcc-14
i386        buildonly-randconfig-1002-20261106    clang-22
i386        buildonly-randconfig-1003-20261105    gcc-14
i386        buildonly-randconfig-1003-20261106    clang-22
i386        buildonly-randconfig-1004-20261105    gcc-14
i386        buildonly-randconfig-1004-20261106    clang-22
i386        buildonly-randconfig-1005-20261105    gcc-14
i386        buildonly-randconfig-1005-20261106    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261105    gcc-14
i386                  randconfig-1001-20261105    gcc-14
i386                  randconfig-1002-20261105    clang-22
i386                  randconfig-1003-20261105    gcc-14
i386                  randconfig-1004-20261105    gcc-14
i386                  randconfig-1005-20261105    gcc-14
i386                  randconfig-1006-20261105    clang-22
i386                  randconfig-1007-20261105    clang-22
i386                  randconfig-1007-20261105    gcc-14
i386                  randconfig-1008-20261105    clang-22
i386                  randconfig-1009-20261105    clang-22
i386                  randconfig-1009-20261105    gcc-14
i386                  randconfig-1010-20261105    clang-22
i386                  randconfig-1011-20261105    clang-22
i386                  randconfig-1011-20261105    gcc-13
i386                  randconfig-1012-20261105    clang-22
i386                  randconfig-1013-20261105    clang-22
i386                  randconfig-2000-20261105    clang-22
i386                  randconfig-2001-20261105    clang-22
i386                  randconfig-2002-20261105    gcc-14
i386                  randconfig-2003-20261105    clang-22
i386                  randconfig-2004-20261105    clang-22
i386                  randconfig-2005-20261105    clang-22
i386                  randconfig-2100-20261105    clang-22   cocci
i386                  randconfig-2101-20261105    gcc-14     cocci
i386                  randconfig-2102-20261105    clang-22   cocci
i386                  randconfig-2103-20261105    gcc-14     cocci
i386                  randconfig-2104-20261105    gcc-14     cocci
i386                  randconfig-2105-20261105    gcc-14     cocci
i386                  randconfig-2200-20261105    clang-22   smatch
i386                  randconfig-2300-20261105    gcc-14     sparse
i386                  randconfig-2301-20261105    gcc-14     sparse
i386                  randconfig-2302-20261105    gcc-14     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261105    clang-24
loongarch             randconfig-1000-20261105    gcc-16.2.0
loongarch             randconfig-1001-20261105    clang-24
loongarch             randconfig-2000-20261105    gcc-12.5.0
loongarch             randconfig-2001-20261105    gcc-16.2.0
loongarch             randconfig-2200-20261105    gcc-16.2.0 smatch
loongarch            randconfig-r2304-20261105    clang-24   sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5208evb_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261105    gcc-14.4.0
m68k                  randconfig-2001-20261105    gcc-16.2.0
m68k                  randconfig-2200-20261105    gcc-8.5.0  smatch
m68k                 randconfig-r2103-20261105    gcc-8.5.0  cocci
m68k                 randconfig-r2300-20261105    gcc-9.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261105    gcc-15.3.0
microblaze            randconfig-2001-20261105    gcc-8.5.0
microblaze            randconfig-2200-20261105    gcc-9.5.0  smatch
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                      eyeq6lplus_defconfig    gcc-16.2.0
mips                            ip28_defconfig    gcc-16.2.0
mips                            mtx1_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261105    gcc-9.5.0
mips                  randconfig-2001-20261105    gcc-15.3.0
mips                  randconfig-2002-20261105    gcc-13.5.0
mips                  randconfig-2200-20261105    gcc-11.5.0 smatch
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261105    clang-24
nios2                 randconfig-1000-20261105    gcc-11.5.0
nios2                 randconfig-1001-20261105    clang-24
nios2                 randconfig-1001-20261105    gcc-10.5.0
nios2                 randconfig-2000-20261105    gcc-11.5.0
nios2                 randconfig-2001-20261105    gcc-8.5.0
nios2                 randconfig-2200-20261105    gcc-9.5.0  smatch
nios2                randconfig-r2100-20261105    gcc-10.5.0 cocci
nios2                randconfig-r2101-20261105    gcc-8.5.0  cocci
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261105    gcc-11.5.0
openrisc              randconfig-2001-20261105    gcc-16.2.0
openrisc              randconfig-2002-20261105    gcc-11.5.0
openrisc              randconfig-2200-20261105    gcc-16.2.0 smatch
openrisc             randconfig-r2110-20261105    gcc-16.2.0 cocci
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261105    clang-21
parisc                randconfig-1000-20261105    gcc-14.4.0
parisc                randconfig-1000-20261106    clang-19
parisc                randconfig-1001-20261105    clang-21
parisc                randconfig-1001-20261105    gcc-8.5.0
parisc                randconfig-1001-20261106    clang-19
parisc                randconfig-2000-20261105    gcc-8.5.0
parisc                randconfig-2001-20261105    gcc-15.3.0
parisc                randconfig-2200-20261105    gcc-15.3.0 smatch
parisc               randconfig-r2102-20261105    gcc-14.4.0 cocci
parisc               randconfig-r2308-20261105    gcc-16.2.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261105    clang-20
powerpc               randconfig-1000-20261105    clang-21
powerpc               randconfig-1000-20261106    clang-19
powerpc               randconfig-1001-20261105    clang-21
powerpc               randconfig-1001-20261105    clang-24
powerpc               randconfig-1001-20261106    clang-19
powerpc               randconfig-2000-20261105    clang-24
powerpc               randconfig-2001-20261105    gcc-16.2.0
powerpc               randconfig-2002-20261105    clang-24
powerpc               randconfig-2200-20261105    clang-17   smatch
powerpc              randconfig-r2303-20261105    clang-17   sparse
powerpc64             randconfig-1000-20261105    clang-21
powerpc64             randconfig-1000-20261105    clang-24
powerpc64             randconfig-1000-20261106    clang-19
powerpc64             randconfig-1001-20261105    clang-21
powerpc64             randconfig-1001-20261106    clang-19
powerpc64             randconfig-2000-20261105    clang-17
powerpc64             randconfig-2001-20261105    gcc-8.5.0
powerpc64             randconfig-2002-20261105    clang-18
powerpc64             randconfig-2200-20261105    clang-24   smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv              nommu_k210_sdcard_defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261105    clang-24
riscv                 randconfig-1001-20261105    clang-24
riscv                 randconfig-2000-20261105    clang-24
riscv                 randconfig-2001-20261105    clang-24
riscv                 randconfig-2002-20261105    clang-17
riscv                 randconfig-2003-20261105    clang-24
riscv                 randconfig-2004-20261105    clang-24
riscv                 randconfig-2005-20261105    clang-24
riscv                 randconfig-2200-20261105    clang-24   smatch
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261105    clang-24
s390                  randconfig-1001-20261105    clang-24
s390                  randconfig-2000-20261105    clang-24
s390                  randconfig-2001-20261105    gcc-8.5.0
s390                  randconfig-2002-20261105    clang-22
s390                  randconfig-2003-20261105    clang-24
s390                  randconfig-2004-20261105    clang-24
s390                  randconfig-2005-20261105    gcc-8.5.0
s390                  randconfig-2200-20261105    clang-24   smatch
s390                 randconfig-r2305-20261105    gcc-10.5.0 sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                              espt_defconfig    gcc-16.2.0
sh                           polaris_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261105    clang-24
sh                    randconfig-1001-20261105    clang-24
sh                    randconfig-2000-20261105    gcc-16.2.0
sh                    randconfig-2001-20261105    gcc-13.5.0
sh                    randconfig-2002-20261105    gcc-16.2.0
sh                    randconfig-2003-20261105    gcc-16.2.0
sh                    randconfig-2004-20261105    gcc-15.3.0
sh                    randconfig-2005-20261105    gcc-16.2.0
sh                    randconfig-2200-20261105    gcc-13.5.0 smatch
sh                              shx3_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261105    gcc-8.5.0
sparc                 randconfig-1001-20261105    gcc-8.5.0
sparc                 randconfig-2000-20261105    gcc-8.5.0
sparc                 randconfig-2001-20261105    gcc-13.5.0
sparc                 randconfig-2200-20261105    gcc-16.2.0 smatch
sparc                randconfig-r2311-20261105    gcc-16.2.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261105    gcc-8.5.0
sparc64               randconfig-1001-20261105    gcc-8.5.0
sparc64               randconfig-2000-20261105    clang-24
sparc64               randconfig-2001-20261105    clang-24
sparc64               randconfig-2200-20261105    gcc-8.5.0  smatch
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261105    gcc-8.5.0
um                    randconfig-1001-20261105    gcc-8.5.0
um                    randconfig-2000-20261105    gcc-14
um                    randconfig-2001-20261105    clang-17
um                    randconfig-2200-20261105    clang-19   smatch
um                   randconfig-r2106-20261105    gcc-14     cocci
um                   randconfig-r2309-20261105    clang-17   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            alldefconfig    gcc-16.2.0
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261105    clang-22
x86_64                randconfig-1001-20261105    clang-22
x86_64                randconfig-1002-20261105    clang-22
x86_64                randconfig-1003-20261105    clang-22
x86_64                randconfig-1004-20261105    clang-22
x86_64                randconfig-1005-20261105    clang-22
x86_64                randconfig-1006-20261105    clang-22
x86_64                randconfig-1007-20261105    gcc-14
x86_64                randconfig-1008-20261105    clang-22
x86_64                randconfig-1009-20261105    gcc-14
x86_64                randconfig-1010-20261105    gcc-13
x86_64                randconfig-1011-20261105    clang-22
x86_64                randconfig-2000-20261105    clang-22
x86_64                randconfig-2001-20261105    gcc-14
x86_64                randconfig-2002-20261105    gcc-14
x86_64                randconfig-2004-20261105    clang-22
x86_64                randconfig-2005-20261105    clang-22
x86_64                randconfig-2100-20261105    gcc-14     cocci
x86_64                randconfig-2101-20261105    gcc-14     cocci
x86_64                randconfig-2102-20261105    gcc-14     cocci
x86_64                randconfig-2103-20261105    gcc-14     cocci
x86_64                randconfig-2104-20261105    gcc-14     cocci
x86_64                randconfig-2105-20261105    gcc-14     cocci
x86_64                randconfig-2200-20261105    clang-22   smatch
x86_64                randconfig-2301-20261105    clang-22   sparse
x86_64                randconfig-2302-20261105    clang-22   sparse
x86_64               randconfig-r2108-20261105    gcc-14     cocci
x86_64               randconfig-r2307-20261105    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                 generic_kc705_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261105    gcc-8.5.0
xtensa                randconfig-1001-20261105    gcc-8.5.0
xtensa                randconfig-2000-20261105    gcc-13.5.0
xtensa                randconfig-2001-20261105    gcc-11.5.0
xtensa                randconfig-2200-20261105    gcc-8.5.0  smatch
xtensa               randconfig-r2302-20261105    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
