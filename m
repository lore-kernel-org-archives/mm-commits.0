Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792424906;
	b=nKLucwmq1YQKLBLbWFPvQICsTLNNTPMl8UqUQJaB4ZstRPqAJcwJtsyTTWAhC5yQ//XM
	 ApnGsA7Hc0tbe29sUJuy/F+5rUQRUwTjec9LllYrldwlTe0prWKjBSRbjhtxohPlVrBAE
	 gJi+KhaT4HCSBYl7WQlMrhD91zVtkWzLFFKEryi7HQoXPKzExeJQypE6hxqyg/kV3sXf0
	 e5/7gZyjjnYhJ+mScsyG3uS3zgwZta5QeCExfKNwD+ZKMFtZKLtmOuZWYyYELLhHWS/gn
	 S5EA4plIbXXd1g641Ke7hX3jJeCK4jBWFpqsizuLBg6+H2J/OZwyBwTCzwJA2EUV4ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792424906;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=F8PVlVs2IJaK6fJestfGqrxDWHNz0DI/vUp6pIrI+Pk=;
	b=NTrfdky0JwNsRkCw/1WfUO/HmOl9wo2o8TltEL5e4riEQqGBkO8z2S/x89Ar/mJhcxmY
	 UtD1JYaghqV2eACNAI+H+FrW9OgGv/rN0IFpUll9RvQhWRkpiS+Kyhz7m+xby7p2RPK+d
	 tG+PHyBxnUTuvLdEhSdsPKYPIOgJ9zeTBPm/FBH/9bgCVzFxU/iF9zS7MKBd8F+zyrEAy
	 fzROyUie+P9xokE7UVbrbRvAh6aidfvB0QIIaBt16ukNhwsI0x7tOR+oRe7kZK7i0If0+
	 rAhl1sm1hNpsK60am5krbVpUUUW5OeaR0/VYlGleAlilDOQCA2PVl5QzHaZKCliAKlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hucouDr7;
	arc=none smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4B1608829D
	for <mm-commits@vger.kernel.org>; Mon, 19 Oct 2026 15:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E4B1608829D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hucouDr7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792424905; x=1823960905;
  h=date:from:to:cc:subject:message-id;
  bh=rnE4ZqNt7wRMBKTIcVXaTrmIhT9zQtM3P3J7+zT1ghE=;
  b=hucouDr71oFvcLAh/AEg+tltIe3POf+mmpoELoYgH/xZtDp2XUjPKt7e
   16TlkS/9qbMfIHgCQsMQEM8EZjf+KcyNxxwZmXuSnvCiLl/r7S2oQunBw
   9kSYVh49KTjAHQlBMboLR1YjwK2YdQnIr1TdqVZgWAggcmB7omd93tZCu
   c+nf7NSyku/raKsBe/VD2tweWiNLRiB8hyoXUcdUBzIl86apzwggtKQBn
   P96uyyGOmUs/FxuBS6u+VhfzhoEBrM6R8gNm7FGL87TQEdK9cWaymZvwI
   MwHDLXV9S+V+IRZHawkmtJKnvC6Ae+kRw1Aw+L869NUa2xhYUMD6rYNxz
   w==;
X-CSE-ConnectionGUID: ZMpLcrmTQuCdUuvwH/ufBA==
X-CSE-MsgGUID: nHb1LJbRSeK+dWOfGy8YBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1005104"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1005104"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:48:25 -0700
X-CSE-ConnectionGUID: M+c19PufTYqpUqsf9s+7Qw==
X-CSE-MsgGUID: VoiUl8uvQDmy1FFtTlCDYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="3035350"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 19 Oct 2026 08:48:23 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIpb2-00000000Ls6-0xva;
	Mon, 19 Oct 2026 15:48:20 +0000
Date: Mon, 19 Oct 2026 23:48:01 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 2887e63d2e8e0cf55402612d8996ce955a2c3e55
Message-ID: <202610192358.tww7xinY-lkp@intel.com>
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
branch HEAD: 2887e63d2e8e0cf55402612d8996ce955a2c3e55  riscv: mm: exclude invalid THP PMDs from page table check

elapsed time: 809m

configs tested: 304
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                randconfig-r2302-20261019    gcc-11.5.0 sparse
alpha                randconfig-r2308-20261019    gcc-15.3.0 sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261019    gcc-8.5.0
arc                   randconfig-1001-20261019    gcc-16.2.0
arc                   randconfig-2000-20261019    gcc-8.5.0
arc                   randconfig-2001-20261019    gcc-8.5.0
arc                  randconfig-r2103-20261019    gcc-8.5.0  cocci
arc                  randconfig-r2104-20261019    clang-24   cocci
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                         mvebu_v7_defconfig    clang-24
arm                              pxa_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261019    clang-24
arm                   randconfig-1001-20261019    clang-18
arm                   randconfig-1002-20261019    clang-21
arm                   randconfig-1003-20261019    clang-24
arm                   randconfig-2000-20261019    gcc-8.5.0
arm                   randconfig-2001-20261019    clang-17
arm                   randconfig-2001-20261019    gcc-8.5.0
arm                  randconfig-r2105-20261019    clang-24   cocci
arm                            spitz_defconfig    gcc-16.2.0
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261019    clang-21
arm64                 randconfig-1001-20261019    clang-24
arm64                 randconfig-1002-20261019    gcc-8.5.0
arm64                 randconfig-1003-20261019    clang-24
arm64                 randconfig-2000-20261019    gcc-14.4.0
arm64                 randconfig-2000-20261019    gcc-15.3.0
arm64                 randconfig-2001-20261019    gcc-15.3.0
arm64                 randconfig-2001-20261019    gcc-8.5.0
arm64                randconfig-r2100-20261019    gcc-14.4.0 cocci
arm64                randconfig-r2106-20261019    clang-24   cocci
arm64                randconfig-r2202-20261019    gcc-15.3.0 smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261019    gcc-14.4.0
csky                  randconfig-1001-20261019    gcc-12.5.0
csky                  randconfig-2000-20261019    gcc-15.3.0
csky                  randconfig-2000-20261019    gcc-16.2.0
csky                  randconfig-2001-20261019    gcc-15.3.0
csky                 randconfig-r2102-20261019    gcc-14.4.0 cocci
csky                 randconfig-r2310-20261019    gcc-16.2.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261019    clang-24
hexagon               randconfig-1001-20261019    clang-24
hexagon               randconfig-2000-20261019    clang-17
hexagon               randconfig-2000-20261019    gcc-15.3.0
hexagon               randconfig-2001-20261019    clang-24
hexagon               randconfig-2001-20261019    gcc-15.3.0
hexagon              randconfig-r2201-20261019    clang-24   smatch
hexagon              randconfig-r2308-20261019    clang-20   sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261019    gcc-14
i386        buildonly-randconfig-1001-20261019    gcc-14
i386        buildonly-randconfig-1002-20261019    gcc-14
i386        buildonly-randconfig-1003-20261019    clang-22
i386        buildonly-randconfig-1004-20261019    clang-22
i386        buildonly-randconfig-1005-20261019    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261019    gcc-14
i386                  randconfig-1001-20261019    clang-22
i386                  randconfig-1002-20261019    gcc-14
i386                  randconfig-1003-20261019    gcc-12
i386                  randconfig-1004-20261019    gcc-14
i386                  randconfig-1005-20261019    clang-22
i386                  randconfig-1006-20261019    gcc-14
i386                  randconfig-1007-20261019    gcc-14
i386                  randconfig-1008-20261019    gcc-14
i386                  randconfig-1009-20261019    clang-22
i386                  randconfig-1010-20261019    gcc-14
i386                  randconfig-1011-20261019    clang-22
i386                  randconfig-1012-20261019    gcc-14
i386                  randconfig-1013-20261019    clang-22
i386                  randconfig-2000-20261019    clang-22
i386                  randconfig-2000-20261019    gcc-8.5.0
i386                  randconfig-2001-20261019    clang-22
i386                  randconfig-2001-20261019    gcc-8.5.0
i386                  randconfig-2100-20261019    gcc-14     cocci
i386                  randconfig-2101-20261019    gcc-14     cocci
i386                  randconfig-2102-20261019    clang-22   cocci
i386                  randconfig-2102-20261019    gcc-14     cocci
i386                  randconfig-2103-20261019    gcc-14     cocci
i386                  randconfig-2104-20261019    gcc-14     cocci
i386                  randconfig-2105-20261019    gcc-14     cocci
i386                  randconfig-2200-20261019    gcc-14     smatch
i386                  randconfig-2300-20261019    gcc-14     sparse
i386                  randconfig-2301-20261019    gcc-14     sparse
i386                  randconfig-2302-20261019    clang-22   sparse
i386                  randconfig-2302-20261019    gcc-14     sparse
i386                 randconfig-r2101-20261019    gcc-13     cocci
i386                 randconfig-r2303-20261019    clang-22   sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261019    gcc-16.2.0
loongarch             randconfig-1001-20261019    gcc-16.2.0
loongarch             randconfig-2000-20261019    clang-24
loongarch             randconfig-2000-20261019    gcc-11.5.0
loongarch             randconfig-2001-20261019    gcc-11.5.0
loongarch             randconfig-2001-20261019    gcc-12.5.0
loongarch            randconfig-r2103-20261019    gcc-14.4.0 cocci
loongarch            randconfig-r2200-20261019    gcc-16.2.0 smatch
m68k                              alldefconfig    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                 randconfig-r2311-20261019    clang-20   sparse
m68k                            sun3_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
microblaze           randconfig-r2108-20261019    gcc-14.4.0 cocci
microblaze           randconfig-r2304-20261019    gcc-15.3.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            ip30_defconfig    gcc-16.2.0
mips                       maltasmvp_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261019    gcc-10.5.0
nios2                 randconfig-1001-20261019    gcc-8.5.0
nios2                 randconfig-2000-20261019    gcc-11.5.0
nios2                 randconfig-2001-20261019    gcc-11.5.0
nios2                randconfig-r2305-20261019    gcc-11.5.0 sparse
nios2                randconfig-r2306-20261019    gcc-10.5.0 sparse
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc             randconfig-r2106-20261019    gcc-14.4.0 cocci
openrisc             randconfig-r2301-20261019    gcc-10.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261019    gcc-12.5.0
parisc                randconfig-1001-20261019    gcc-10.5.0
parisc                randconfig-2000-20261019    gcc-11.5.0
parisc                randconfig-2000-20261019    gcc-15.3.0
parisc                randconfig-2001-20261019    gcc-11.5.0
parisc                randconfig-2001-20261019    gcc-8.5.0
parisc               randconfig-r2102-20261019    gcc-12.5.0 cocci
parisc               randconfig-r2105-20261019    gcc-10.5.0 cocci
parisc               randconfig-r2300-20261019    gcc-10.5.0 sparse
parisc               randconfig-r2310-20261019    clang-20   sparse
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261019    clang-24
powerpc               randconfig-1001-20261019    gcc-8.5.0
powerpc               randconfig-2000-20261019    clang-22
powerpc               randconfig-2000-20261019    gcc-8.5.0
powerpc               randconfig-2001-20261019    clang-22
powerpc               randconfig-2001-20261019    clang-24
powerpc              randconfig-r2109-20261019    clang-17   cocci
powerpc              randconfig-r2111-20261019    clang-24   cocci
powerpc              randconfig-r2307-20261019    clang-20   sparse
powerpc64             randconfig-1000-20261019    gcc-10.5.0
powerpc64             randconfig-1001-20261019    gcc-11.5.0
powerpc64             randconfig-2000-20261019    clang-22
powerpc64             randconfig-2000-20261019    clang-24
powerpc64             randconfig-2001-20261019    clang-22
powerpc64             randconfig-2001-20261019    clang-24
powerpc64            randconfig-r2201-20261019    clang-24   smatch
powerpc64            randconfig-r2306-20261019    clang-20   sparse
powerpc64            randconfig-r2309-20261019    clang-20   sparse
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261019    gcc-11.5.0
riscv                 randconfig-1001-20261019    gcc-9.5.0
riscv                 randconfig-2000-20261019    clang-17
riscv                 randconfig-2000-20261019    gcc-13.5.0
riscv                 randconfig-2001-20261019    clang-24
riscv                 randconfig-2001-20261019    gcc-13.5.0
riscv                randconfig-r2101-20261019    gcc-14.4.0 cocci
riscv                randconfig-r2107-20261019    clang-24   cocci
riscv                randconfig-r2111-20261019    gcc-8.5.0  cocci
riscv                randconfig-r2200-20261019    clang-19   smatch
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                  randconfig-1000-20261019    gcc-8.5.0
s390                  randconfig-1001-20261019    gcc-9.5.0
s390                  randconfig-2000-20261019    clang-20
s390                  randconfig-2000-20261019    gcc-13.5.0
s390                  randconfig-2001-20261019    gcc-10.5.0
s390                  randconfig-2001-20261019    gcc-13.5.0
s390                 randconfig-r2202-20261019    clang-24   smatch
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261019    gcc-10.5.0
sh                    randconfig-1001-20261019    gcc-16.2.0
sh                    randconfig-2000-20261019    gcc-13.5.0
sh                    randconfig-2001-20261019    gcc-13.5.0
sh                    randconfig-2001-20261019    gcc-15.3.0
sh                           sdk7780_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261019    gcc-16.2.0
sparc                 randconfig-1001-20261019    gcc-12.5.0
sparc                 randconfig-2000-20261019    gcc-11.5.0
sparc                 randconfig-2000-20261019    gcc-16.2.0
sparc                 randconfig-2001-20261019    gcc-11.5.0
sparc                randconfig-r2100-20261019    gcc-13.5.0 cocci
sparc                randconfig-r2110-20261019    gcc-14.4.0 cocci
sparc                randconfig-r2311-20261019    gcc-14.4.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261019    gcc-15.3.0
sparc64               randconfig-1001-20261019    clang-20
sparc64               randconfig-2000-20261019    gcc-11.5.0
sparc64               randconfig-2000-20261019    gcc-8.5.0
sparc64               randconfig-2001-20261019    clang-24
sparc64               randconfig-2001-20261019    gcc-11.5.0
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261019    clang-24
um                    randconfig-1001-20261019    clang-20
um                    randconfig-2000-20261019    gcc-11.5.0
um                    randconfig-2000-20261019    gcc-12
um                    randconfig-2001-20261019    gcc-11.5.0
um                    randconfig-2001-20261019    gcc-12
um                   randconfig-r2104-20261019    clang-17   cocci
um                   randconfig-r2110-20261019    clang-24   cocci
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261019    clang-22
x86_64      buildonly-randconfig-1001-20261019    clang-22
x86_64      buildonly-randconfig-1002-20261019    gcc-14
x86_64      buildonly-randconfig-1003-20261019    gcc-14
x86_64      buildonly-randconfig-1004-20261019    gcc-14
x86_64      buildonly-randconfig-1005-20261019    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261019    gcc-14
x86_64                randconfig-1001-20261019    gcc-14
x86_64                randconfig-1002-20261019    gcc-14
x86_64                randconfig-1003-20261019    gcc-14
x86_64                randconfig-1004-20261019    clang-22
x86_64                randconfig-1005-20261019    gcc-14
x86_64                randconfig-1006-20261019    clang-22
x86_64                randconfig-1007-20261019    clang-22
x86_64                randconfig-1008-20261019    gcc-14
x86_64                randconfig-1009-20261019    gcc-14
x86_64                randconfig-1010-20261019    clang-22
x86_64                randconfig-1011-20261019    gcc-14
x86_64                randconfig-1012-20261019    gcc-14
x86_64                randconfig-1013-20261019    clang-22
x86_64                randconfig-1014-20261019    clang-22
x86_64                randconfig-1015-20261019    clang-22
x86_64                randconfig-1016-20261019    gcc-13
x86_64                randconfig-1017-20261019    gcc-14
x86_64                randconfig-2000-20261019    clang-22
x86_64                randconfig-2000-20261019    gcc-14
x86_64                randconfig-2001-20261019    clang-22
x86_64                randconfig-2100-20261019    clang-22   cocci
x86_64                randconfig-2101-20261019    clang-22   cocci
x86_64                randconfig-2101-20261019    gcc-14     cocci
x86_64                randconfig-2102-20261019    clang-22   cocci
x86_64                randconfig-2103-20261019    clang-22   cocci
x86_64                randconfig-2103-20261019    gcc-14     cocci
x86_64                randconfig-2104-20261019    clang-22   cocci
x86_64                randconfig-2105-20261019    clang-22   cocci
x86_64                randconfig-2105-20261019    gcc-14     cocci
x86_64                randconfig-2200-20261019    clang-22   smatch
x86_64                randconfig-2300-20261019    gcc-14     sparse
x86_64                randconfig-2301-20261019    clang-22   sparse
x86_64                randconfig-2301-20261019    gcc-14     sparse
x86_64                randconfig-2302-20261019    gcc-14     sparse
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
xtensa                randconfig-1000-20261019    gcc-16.2.0
xtensa                randconfig-2000-20261019    gcc-11.5.0
xtensa                randconfig-2000-20261019    gcc-15.3.0
xtensa                randconfig-2001-20261019    gcc-11.5.0
xtensa                randconfig-2001-20261019    gcc-8.5.0
xtensa               randconfig-r2107-20261019    gcc-12.5.0 cocci
xtensa               randconfig-r2108-20261019    gcc-14.4.0 cocci
xtensa               randconfig-r2109-20261019    gcc-14.4.0 cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
