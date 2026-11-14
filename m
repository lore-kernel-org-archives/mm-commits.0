Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794691335;
	b=mlEvB+qQd7s8x0JBW3k/E+Foxw3ltUJVCJhIsUTlkArzVup2gLVMJTc7M1f1uzBn77IZ
	 RRQpZI89e3eaCQ//B3ZPQFWprAmX71vq7wje3UEs4DJzLcA9KW30XenXf/DFjZ/ZrhWMF
	 5abDyR7H/j1ElV3JRRsIlrGsS4K0fr4AU9D+p/xudK2kHIqh1T1o8krcrCfS1c2D4uWPt
	 ea9pECqVCYQSI/Dsy0MU/IzOWKihF6vZQ7wPhnHGJd1409+IdvfoTMadecvMTxixozgZe
	 HPNwxaf37mq6bp6QD24V7qCMCVR4QCSjpdKb2P8g1z9gxBYZM+noNWrJqDm7zIKBEnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794691335;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=KP+xhGuqOBCrniIfNXqK5UXjpj2LBeDitK/IHjyAWLs=;
	b=5JTlytUecZ1eWEdb5tPtBHdxD/1OI7FtWapGHJJY3jHA/+n+fZY7Y8S7Jmo1yA1Zm2Bw
	 4/WlSEQF/GuHEZdBvXK8sloZ4bvQcf+gJ02dD0fogeoG6r1NEBka0wVpDWWy4O1FO0Nvr
	 QFDJroEZa/50Do0lavq/20YWbfLKg3Vpt/cJWAAPNjM9i4tc5TtVk4B+CWeuQXIO+WLLo
	 T2R6wiCbh54Tqj2inQKurbMYUSUKOJPuXgCOLkQCDuQD9b0kzj+zGUYWziXfG+lxsY9oA
	 Y6+fcehDh31ePps4CduodiYaQLdRF9U5RHug1AmeuByysqXSPuHP6G4CdzatkFMXCAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VJQ3PDl2;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61812606A330
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:22:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61812606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VJQ3PDl2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794691335; x=1826227335;
  h=date:from:to:cc:subject:message-id;
  bh=xwHfC60tUs13wURSEaf5tPhljOfQWW/KWgG0lIYh5R0=;
  b=VJQ3PDl2Pb834VXO5VbGyBekfIMvBxaNreAIGewPDBKQsrN0jC71Oix6
   6d6WxieurD5xHz50W3M+nygDiCk4OYqJ48TBHNM+1GoDlnzwJXq+k4ddQ
   O3nM1KnIVPSWsdk/CGQ87067X7J2ptV0HibUaT4zSUDMT8fpjtqP3XypB
   XV9YZpPIwZ7dKKDDbij9TRV70QOOHs413y0NYPczJgL7CxsrRJ0SxwVFR
   gWQl9Pr0Kiej7ziDnym4xB1ifYDVyYJFWai5CLCWW6J1yVJSL8mpE47vw
   Ol0mqQofkVSqSVHxSYNQSttRBWYEdKpuQHsuf/FdF8T/28DvM1ifTQuGb
   Q==;
X-CSE-ConnectionGUID: lhaqI7MoSSaDbGsmvCpF7g==
X-CSE-MsgGUID: GMEAqNdCQByN152EBIFw9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11966"; a="3345821"
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="3345821"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2026 13:22:14 -0800
X-CSE-ConnectionGUID: VxhAk3XCRmiG6twZBbpPeQ==
X-CSE-MsgGUID: 1DpS6jDeS7WkWrIQvEEWsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="9746716"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 14 Nov 2026 13:22:12 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSLCL-0000000160q-2N5A;
	Sat, 14 Nov 2026 21:22:09 +0000
Date: Sun, 15 Nov 2026 05:21:14 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 6ec534d64f85e949a5d58070678dcd7711875a7c
Message-ID: <20261115052113.pCDYACX7-lkp@intel.com>
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
branch HEAD: 6ec534d64f85e949a5d58070678dcd7711875a7c  mm/madvise: zap markers from guard regions

elapsed time: 793m

configs tested: 344
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261114    gcc-8.5.0
alpha                 randconfig-2001-20261114    gcc-9.5.0
alpha                 randconfig-2200-20261114    gcc-9.5.0  smatch
alpha                randconfig-r2109-20261114    gcc-13.5.0 cocci
alpha                randconfig-r2110-20261114    gcc-16.2.0 cocci
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261115    gcc-11.5.0
arc                   randconfig-1001-20261115    gcc-11.5.0
arc                   randconfig-2000-20261114    gcc-11.5.0
arc                   randconfig-2001-20261114    gcc-13.5.0
arc                   randconfig-2002-20261114    gcc-11.5.0
arc                   randconfig-2003-20261114    gcc-13.5.0
arc                   randconfig-2004-20261114    gcc-8.5.0
arc                   randconfig-2005-20261114    gcc-9.5.0
arc                   randconfig-2200-20261114    gcc-8.5.0  smatch
arc                  randconfig-r2308-20261114    gcc-8.5.0  sparse
arc                  randconfig-r2309-20261114    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-1000-20261115    gcc-11.5.0
arm                   randconfig-1001-20261115    gcc-11.5.0
arm                   randconfig-1002-20261115    gcc-11.5.0
arm                   randconfig-1003-20261115    gcc-11.5.0
arm                   randconfig-2000-20261114    gcc-10.5.0
arm                   randconfig-2001-20261114    gcc-11.5.0
arm                   randconfig-2002-20261114    gcc-10.5.0
arm                   randconfig-2200-20261114    clang-17   smatch
arm                  randconfig-r2106-20261114    clang-17   cocci
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261114    gcc-16.2.0
arm64                 randconfig-1001-20261114    gcc-16.2.0
arm64                 randconfig-1002-20261114    gcc-16.2.0
arm64                 randconfig-1003-20261114    gcc-16.2.0
arm64                 randconfig-2000-20261114    clang-22
arm64                 randconfig-2001-20261114    gcc-14.4.0
arm64                 randconfig-2002-20261114    clang-24
arm64                 randconfig-2200-20261114    clang-17   smatch
arm64                randconfig-r2104-20261114    clang-17   cocci
arm64                randconfig-r2108-20261114    clang-24   cocci
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261114    gcc-16.2.0
csky                  randconfig-1001-20261114    gcc-16.2.0
csky                  randconfig-2000-20261114    gcc-16.2.0
csky                  randconfig-2001-20261114    gcc-13.5.0
csky                  randconfig-2200-20261114    gcc-16.2.0 smatch
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261114    clang-24
hexagon               randconfig-1001-20261114    clang-24
hexagon               randconfig-2000-20261114    clang-24
hexagon               randconfig-2001-20261114    clang-24
hexagon               randconfig-2200-20261114    clang-24   smatch
hexagon              randconfig-r2311-20261114    clang-17   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261114    gcc-14
i386        buildonly-randconfig-1001-20261114    gcc-14
i386        buildonly-randconfig-1002-20261114    gcc-14
i386        buildonly-randconfig-1003-20261114    gcc-14
i386        buildonly-randconfig-1004-20261114    gcc-14
i386        buildonly-randconfig-1005-20261114    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261114    gcc-12
i386                  randconfig-1000-20261115    clang-22
i386                  randconfig-1001-20261114    gcc-12
i386                  randconfig-1001-20261115    clang-22
i386                  randconfig-1002-20261114    gcc-12
i386                  randconfig-1002-20261115    clang-22
i386                  randconfig-1003-20261114    gcc-12
i386                  randconfig-1003-20261115    clang-22
i386                  randconfig-1004-20261114    gcc-12
i386                  randconfig-1004-20261115    clang-22
i386                  randconfig-1005-20261114    gcc-12
i386                  randconfig-1005-20261115    clang-22
i386                  randconfig-1006-20261114    gcc-12
i386                  randconfig-1006-20261115    clang-22
i386                  randconfig-1007-20261114    clang-22
i386                  randconfig-1008-20261114    clang-22
i386                  randconfig-1009-20261114    clang-22
i386                  randconfig-1010-20261114    clang-22
i386                  randconfig-1011-20261114    clang-22
i386                  randconfig-1012-20261114    clang-22
i386                  randconfig-1013-20261114    clang-22
i386                  randconfig-2000-20261114    clang-22
i386                  randconfig-2001-20261114    clang-22
i386                  randconfig-2002-20261114    clang-22
i386                  randconfig-2003-20261114    gcc-14
i386                  randconfig-2004-20261114    gcc-14
i386                  randconfig-2005-20261114    gcc-14
i386                  randconfig-2100-20261114    gcc-14     cocci
i386                  randconfig-2101-20261114    clang-22   cocci
i386                  randconfig-2102-20261114    gcc-14     cocci
i386                  randconfig-2103-20261114    gcc-14     cocci
i386                  randconfig-2104-20261114    gcc-14     cocci
i386                  randconfig-2105-20261114    clang-22   cocci
i386                  randconfig-2200-20261114    gcc-14     smatch
i386                  randconfig-2300-20261114    gcc-12     sparse
i386                  randconfig-2301-20261114    gcc-14     sparse
i386                  randconfig-2302-20261114    gcc-14     sparse
i386                 randconfig-r2100-20261114    gcc-14     cocci
i386                 randconfig-r2306-20261114    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261114    clang-24
loongarch             randconfig-1001-20261114    clang-24
loongarch             randconfig-2000-20261114    clang-22
loongarch             randconfig-2001-20261114    clang-24
loongarch             randconfig-2200-20261114    clang-18   smatch
loongarch            randconfig-r2111-20261114    clang-22   cocci
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                  randconfig-2000-20261114    gcc-8.5.0
m68k                  randconfig-2001-20261114    gcc-12.5.0
m68k                  randconfig-2200-20261114    gcc-16.2.0 smatch
m68k                 randconfig-r2310-20261114    gcc-14.4.0 sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261114    gcc-15.3.0
microblaze            randconfig-2001-20261114    gcc-9.5.0
microblaze            randconfig-2200-20261114    gcc-9.5.0  smatch
microblaze           randconfig-r2105-20261114    gcc-8.5.0  cocci
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  randconfig-2000-20261114    clang-24
mips                  randconfig-2001-20261114    gcc-8.5.0
mips                  randconfig-2002-20261114    gcc-13.5.0
mips                  randconfig-2200-20261114    gcc-15.3.0 smatch
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261114    clang-24
nios2                 randconfig-1001-20261114    clang-24
nios2                 randconfig-2000-20261114    gcc-11.5.0
nios2                 randconfig-2001-20261114    gcc-11.5.0
nios2                 randconfig-2200-20261114    gcc-11.5.0 smatch
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc              randconfig-2000-20261114    gcc-16.2.0
openrisc              randconfig-2001-20261114    gcc-9.5.0
openrisc              randconfig-2002-20261114    gcc-16.2.0
openrisc              randconfig-2200-20261114    gcc-16.2.0 smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                randconfig-2000-20261114    gcc-13.5.0
parisc                randconfig-2001-20261114    gcc-15.3.0
parisc                randconfig-2200-20261114    gcc-8.5.0  smatch
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-2000-20261114    gcc-8.5.0
powerpc               randconfig-2001-20261114    clang-19
powerpc               randconfig-2002-20261114    clang-21
powerpc               randconfig-2200-20261114    clang-24   smatch
powerpc64             randconfig-2000-20261114    clang-19
powerpc64             randconfig-2001-20261114    gcc-8.5.0
powerpc64             randconfig-2002-20261114    clang-24
powerpc64             randconfig-2200-20261114    clang-17   smatch
powerpc64            randconfig-r2301-20261114    gcc-14.4.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                 randconfig-1000-20261114    gcc-15.3.0
riscv                 randconfig-1001-20261114    gcc-15.3.0
riscv                 randconfig-2000-20261114    clang-24
riscv                 randconfig-2001-20261114    gcc-16.2.0
riscv                 randconfig-2002-20261114    gcc-14.4.0
riscv                 randconfig-2003-20261114    gcc-12.5.0
riscv                 randconfig-2004-20261114    clang-17
riscv                 randconfig-2005-20261114    clang-19
riscv                 randconfig-2200-20261114    clang-24   smatch
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                  randconfig-1000-20261114    gcc-15.3.0
s390                  randconfig-1001-20261114    gcc-15.3.0
s390                  randconfig-2000-20261114    clang-21
s390                  randconfig-2001-20261114    clang-24
s390                  randconfig-2002-20261114    clang-24
s390                  randconfig-2003-20261114    gcc-12.5.0
s390                  randconfig-2004-20261114    clang-17
s390                  randconfig-2005-20261114    clang-24
s390                  randconfig-2200-20261114    clang-24   smatch
s390                 randconfig-r2305-20261114    clang-24   sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261114    gcc-15.3.0
sh                    randconfig-1001-20261114    gcc-15.3.0
sh                    randconfig-2000-20261114    gcc-16.2.0
sh                    randconfig-2001-20261114    gcc-16.2.0
sh                    randconfig-2002-20261114    gcc-16.2.0
sh                    randconfig-2003-20261114    gcc-16.2.0
sh                    randconfig-2004-20261114    gcc-11.5.0
sh                    randconfig-2005-20261114    gcc-13.5.0
sh                    randconfig-2200-20261114    gcc-9.5.0  smatch
sh                   randconfig-r2300-20261114    gcc-16.2.0 sparse
sh                   randconfig-r2302-20261114    gcc-13.5.0 sparse
sh                   randconfig-r2303-20261114    gcc-15.3.0 sparse
sh                   randconfig-r2304-20261114    gcc-13.5.0 sparse
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                 randconfig-1000-20261114    gcc-12.5.0
sparc                 randconfig-1001-20261114    gcc-12.5.0
sparc                 randconfig-2000-20261114    gcc-11.5.0
sparc                 randconfig-2001-20261114    gcc-13.5.0
sparc                 randconfig-2200-20261114    gcc-8.5.0  smatch
sparc                randconfig-r2101-20261114    gcc-13.5.0 cocci
sparc                randconfig-r2103-20261114    gcc-8.5.0  cocci
sparc                randconfig-r2107-20261114    gcc-16.2.0 cocci
sparc                randconfig-r2307-20261114    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261114    gcc-12.5.0
sparc64               randconfig-1001-20261114    gcc-12.5.0
sparc64               randconfig-2000-20261114    clang-24
sparc64               randconfig-2001-20261114    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261114    gcc-12.5.0
um                    randconfig-1001-20261114    gcc-12.5.0
um                    randconfig-2000-20261114    clang-24
um                    randconfig-2001-20261114    clang-21
um                    randconfig-2200-20261114    gcc-14     smatch
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261114    gcc-14
x86_64      buildonly-randconfig-1001-20261114    gcc-14
x86_64      buildonly-randconfig-1002-20261114    gcc-14
x86_64      buildonly-randconfig-1003-20261114    gcc-14
x86_64      buildonly-randconfig-1004-20261114    gcc-14
x86_64      buildonly-randconfig-1005-20261114    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261114    gcc-14
x86_64                randconfig-1000-20261115    gcc-14
x86_64                randconfig-1001-20261114    gcc-14
x86_64                randconfig-1001-20261115    gcc-14
x86_64                randconfig-1002-20261114    gcc-14
x86_64                randconfig-1002-20261115    gcc-14
x86_64                randconfig-1003-20261114    gcc-14
x86_64                randconfig-1003-20261115    gcc-14
x86_64                randconfig-1004-20261114    gcc-14
x86_64                randconfig-1004-20261115    gcc-14
x86_64                randconfig-1005-20261114    gcc-14
x86_64                randconfig-1005-20261115    gcc-14
x86_64                randconfig-1006-20261114    gcc-14
x86_64                randconfig-1007-20261114    gcc-14
x86_64                randconfig-1008-20261114    gcc-14
x86_64                randconfig-1009-20261114    gcc-14
x86_64                randconfig-1010-20261114    gcc-14
x86_64                randconfig-1011-20261114    gcc-14
x86_64                randconfig-1012-20261114    clang-22
x86_64                randconfig-1012-20261115    gcc-14
x86_64                randconfig-1013-20261114    clang-22
x86_64                randconfig-1013-20261115    gcc-14
x86_64                randconfig-1014-20261114    clang-22
x86_64                randconfig-1014-20261115    gcc-14
x86_64                randconfig-1015-20261114    clang-22
x86_64                randconfig-1015-20261115    gcc-14
x86_64                randconfig-1016-20261114    clang-22
x86_64                randconfig-1016-20261115    gcc-14
x86_64                randconfig-1017-20261114    clang-22
x86_64                randconfig-1017-20261115    gcc-14
x86_64                randconfig-2000-20261114    gcc-14
x86_64                randconfig-2001-20261114    gcc-14
x86_64                randconfig-2002-20261114    clang-22
x86_64                randconfig-2003-20261114    gcc-14
x86_64                randconfig-2004-20261114    gcc-14
x86_64                randconfig-2005-20261114    gcc-14
x86_64                randconfig-2100-20261114    gcc-14     cocci
x86_64                randconfig-2101-20261114    gcc-12     cocci
x86_64                randconfig-2102-20261114    clang-22   cocci
x86_64                randconfig-2103-20261114    clang-22   cocci
x86_64                randconfig-2104-20261114    gcc-14     cocci
x86_64                randconfig-2105-20261114    gcc-14     cocci
x86_64                randconfig-2200-20261114    gcc-14     smatch
x86_64                randconfig-2300-20261114    gcc-12     sparse
x86_64                randconfig-2301-20261114    gcc-14     sparse
x86_64                randconfig-2302-20261114    clang-22   sparse
x86_64               randconfig-r2102-20261114    clang-22   cocci
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
xtensa                randconfig-1000-20261114    gcc-12.5.0
xtensa                randconfig-1001-20261114    gcc-12.5.0
xtensa                randconfig-2000-20261114    gcc-9.5.0
xtensa                randconfig-2001-20261114    gcc-11.5.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
