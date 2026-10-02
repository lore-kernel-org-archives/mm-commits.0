Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C78352003
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 03:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790912492; cv=none; b=N+qk40VrhyTPKXrkfvLNQ69mS7R/l6P9c3R+cHsgcCspQU9Pmrk0dLu/XwQ1LuOJALop02Kk3WejoWaqodTtQB6irJAAea+n5aRIhn2BbtkihAp0dqQlZ0cktrsgFL2i/+fOPHLyd9gjYpcleBQy9rmsc6momNkzRd99s4gAZRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790912492; c=relaxed/simple;
	bh=c0DaZbITOuajcSNWCM8zpyYtyss46YRn2NudfMy31Lo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=dXtCjwoXaSsu2LEBtK9q+7tsVWkoyPG7K0LcwZMl7AnvmsV7a9ccWFaXEYCjcaXQH0YZqPfVEVq0aKj6teabK9AV7YaaZOy4B4KnUIsxjpvD719YPDqbVIP63Jk17Xi+7DWqrsnOyCU5U7X6yfvpnFMCm+JBR81FLcAVHlKjp/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGSstUII; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGSstUII"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790912489; x=1822448489;
  h=date:from:to:cc:subject:message-id;
  bh=c0DaZbITOuajcSNWCM8zpyYtyss46YRn2NudfMy31Lo=;
  b=RGSstUII4k/9/DZq70BPTk/u3hAsci379Ik7CYX2+gs3vrlRQBiSmf48
   ufgiWjB9E/ci2dDNtOtGoWXVGNF/Qgkavk53hEw+FAZWbLn6C05JSNJDc
   fy1cgU0tw/G8oYgbW7wXz/7CyyDU+/+76l/ukzCK+FD9FC97L3QanXSlt
   cwztMGHnHDzIyCDC7GbIZv9xT5Se4auxkVCKc1e/yxsKok4NFNg2XISCQ
   ZBh2z+I+ErDw/vVNKpGzfiAKLKvA/Xae3m6hLKADy9wNoRD4+Wz+/F8Vp
   xFW4Zpg8zldSgB8VIVegtfmlnL2Z2M5OVyNkO247evJScDVJ/OhzEdN2Y
   g==;
X-CSE-ConnectionGUID: Xfz+B1XKSpm1JdcYDguGuw==
X-CSE-MsgGUID: ryvHPiNZSKi0LGhVNNQkEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90818542"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="90818542"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 20:41:27 -0700
X-CSE-ConnectionGUID: 4rcMFL9HRZmIMtYX749d6A==
X-CSE-MsgGUID: JDqhaByISp20zI+SATsbrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="172709"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 01 Oct 2026 20:41:25 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xCU9C-00000000ScD-2DRv;
	Fri, 02 Oct 2026 03:41:22 +0000
Date: Fri, 02 Oct 2026 11:40:24 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 21c3620df8ad362e9f2069ac35577c2a2f782f33
Message-ID: <202610021120.LED8YkcD-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 21c3620df8ad362e9f2069ac35577c2a2f782f33  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 747m

configs tested: 220
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2105-20261001    gcc-15.2.0 cocci
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261001    gcc-15.2.0
arc                   randconfig-1001-20261001    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261001    gcc-13.4.0
arm                   randconfig-1001-20261001    clang-21
arm                   randconfig-1002-20261001    gcc-13.4.0
arm                   randconfig-1003-20261001    gcc-8.5.0
arm                         realview_defconfig    clang-17
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261001    gcc-8.5.0
arm64                 randconfig-1001-20261001    gcc-10.5.0
arm64                 randconfig-1002-20261001    gcc-8.5.0
arm64                 randconfig-1003-20261001    gcc-8.5.0
arm64                randconfig-r2201-20261001    gcc-16.1.0 smatch
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261001    gcc-15.2.0
csky                  randconfig-1001-20261001    gcc-9.5.0
csky                 randconfig-r2305-20261001    gcc-15.2.0 sparse
csky                 randconfig-r2309-20261001    clang-24   sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261001    clang-20
hexagon               randconfig-1001-20261001    clang-20
hexagon              randconfig-r2103-20261001    clang-24   cocci
hexagon              randconfig-r2304-20261001    gcc-15.2.0 sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261001    gcc-13
i386        buildonly-randconfig-1001-20261001    clang-22
i386        buildonly-randconfig-1002-20261001    gcc-14
i386        buildonly-randconfig-1003-20261001    clang-22
i386        buildonly-randconfig-1004-20261001    clang-22
i386        buildonly-randconfig-1005-20261001    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261001    gcc-13
i386                  randconfig-1001-20261001    gcc-14
i386                  randconfig-1002-20261001    clang-22
i386                  randconfig-1003-20261001    gcc-14
i386                  randconfig-1004-20261001    gcc-14
i386                  randconfig-1005-20261001    gcc-14
i386                  randconfig-1006-20261001    clang-22
i386                  randconfig-1007-20261002    gcc-14
i386                  randconfig-1008-20261002    clang-22
i386                  randconfig-1009-20261002    clang-22
i386                  randconfig-1010-20261002    clang-22
i386                  randconfig-1011-20261002    clang-22
i386                  randconfig-1012-20261002    gcc-14
i386                  randconfig-1013-20261002    clang-22
i386                  randconfig-2100-20261001    gcc-14     cocci
i386                  randconfig-2101-20261001    gcc-14     cocci
i386                  randconfig-2102-20261001    gcc-14     cocci
i386                  randconfig-2103-20261001    gcc-14     cocci
i386                  randconfig-2200-20261001    clang-22   smatch
i386                  randconfig-2300-20261001    gcc-14     sparse
i386                  randconfig-2301-20261001    gcc-14     sparse
i386                  randconfig-2302-20261001    gcc-14     sparse
i386                 randconfig-r2308-20261001    clang-24   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261001    clang-18
loongarch             randconfig-1001-20261001    clang-24
loongarch            randconfig-r2107-20261001    gcc-15.2.0 cocci
loongarch            randconfig-r2302-20261001    gcc-15.2.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2202-20261001    gcc-8.5.0  smatch
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261001    gcc-11.5.0
nios2                 randconfig-1001-20261001    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261001    gcc-13.4.0
parisc                randconfig-1001-20261001    gcc-15.2.0
parisc               randconfig-r2102-20261001    clang-24   cocci
parisc               randconfig-r2104-20261001    gcc-15.2.0 cocci
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                     amigaone_defconfig    gcc-16.1.0
powerpc                        eiger_defconfig    clang-24
powerpc                    lite5200b_defconfig    clang-24
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc               randconfig-1000-20261001    clang-24
powerpc               randconfig-1001-20261001    gcc-12.5.0
powerpc              randconfig-r2303-20261001    gcc-15.2.0 sparse
powerpc64             randconfig-1000-20261001    gcc-16.1.0
powerpc64             randconfig-1001-20261001    gcc-14.3.0
powerpc64            randconfig-r2307-20261001    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261001    gcc-14.3.0
riscv                 randconfig-1001-20261001    gcc-12.5.0
riscv                 randconfig-2000-20261001    gcc-10.5.0
riscv                 randconfig-2001-20261001    gcc-10.5.0
riscv                randconfig-r2300-20261001    gcc-15.2.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261001    gcc-10.5.0
s390                  randconfig-1001-20261001    clang-24
s390                  randconfig-2000-20261001    gcc-10.5.0
s390                  randconfig-2001-20261001    gcc-10.5.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                             hp6xx_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261001    gcc-15.2.0
sh                    randconfig-1001-20261001    gcc-9.5.0
sh                    randconfig-2000-20261001    gcc-10.5.0
sh                    randconfig-2001-20261001    gcc-10.5.0
sh                   randconfig-r2301-20261001    gcc-15.2.0 sparse
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261002    gcc-12.5.0
sparc                 randconfig-1001-20261002    gcc-16.1.0
sparc                 randconfig-2000-20261001    clang-24
sparc                 randconfig-2001-20261001    clang-24
sparc                randconfig-r2101-20261001    clang-24   cocci
sparc                randconfig-r2106-20261001    gcc-15.2.0 cocci
sparc                randconfig-r2200-20261001    gcc-8.5.0  smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261002    gcc-8.5.0
sparc64               randconfig-1001-20261002    gcc-11.5.0
sparc64               randconfig-2000-20261001    clang-24
sparc64               randconfig-2001-20261001    clang-24
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261002    clang-24
um                    randconfig-1001-20261002    clang-24
um                    randconfig-2000-20261001    clang-24
um                    randconfig-2001-20261001    clang-24
um                   randconfig-r2100-20261001    clang-24   cocci
um                   randconfig-r2306-20261001    clang-24   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261001    clang-22
x86_64      buildonly-randconfig-1001-20261001    clang-22
x86_64      buildonly-randconfig-1002-20261001    gcc-13
x86_64      buildonly-randconfig-1003-20261001    clang-22
x86_64      buildonly-randconfig-1004-20261001    clang-22
x86_64      buildonly-randconfig-1005-20261001    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261001    clang-22
x86_64                randconfig-1001-20261001    clang-22
x86_64                randconfig-1002-20261001    gcc-14
x86_64                randconfig-1003-20261001    clang-22
x86_64                randconfig-1004-20261001    clang-22
x86_64                randconfig-1005-20261001    clang-22
x86_64                randconfig-1006-20261002    clang-22
x86_64                randconfig-1007-20261002    gcc-14
x86_64                randconfig-1008-20261002    gcc-14
x86_64                randconfig-1009-20261002    gcc-12
x86_64                randconfig-1010-20261002    clang-22
x86_64                randconfig-1011-20261002    clang-22
x86_64                randconfig-1012-20261001    clang-22
x86_64                randconfig-1013-20261001    gcc-14
x86_64                randconfig-1014-20261001    gcc-12
x86_64                randconfig-1015-20261001    clang-22
x86_64                randconfig-1016-20261001    clang-22
x86_64                randconfig-1017-20261001    clang-22
x86_64                randconfig-2100-20261001    gcc-14     cocci
x86_64                randconfig-2101-20261001    gcc-14     cocci
x86_64                randconfig-2102-20261001    gcc-14     cocci
x86_64                randconfig-2103-20261001    gcc-14     cocci
x86_64                randconfig-2200-20261001    clang-22   smatch
x86_64                randconfig-2300-20261001    gcc-14     sparse
x86_64                randconfig-2301-20261001    gcc-14     sparse
x86_64                randconfig-2302-20261001    gcc-14     sparse
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
xtensa                randconfig-1000-20261002    gcc-14.3.0
xtensa                randconfig-1001-20261002    gcc-8.5.0
xtensa                randconfig-2000-20261001    clang-24
xtensa                randconfig-2001-20261001    clang-24
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
