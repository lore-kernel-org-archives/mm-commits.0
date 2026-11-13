Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794533681;
	b=wDa4U0CzR9T/fK2NiYTa0aRq5dRF1hEB8+4QMrx0tqMcDft1iQQHUbDwqDIyr38voHH0
	 sxZcQ/EuVyLETvCi0LIY56F+849bjVaXCE06RMWJr507V6oMBqw3WqR2xVVFQ5OzCR86R
	 LzumMkZxDAhS0topOhwhdXgqUALz5SneWDe+pKqxyLcS4uaUZY8v0x1H+6e2jJBJaFDh2
	 Q6lqvEV+kDgEWnHu+BnaWNWJk4LAhHWEiXj1GFGR0I+s15B/X7UuPtZqqaI7i4P+1S+fo
	 IhoFFYqh3IDAWXdsP96ctbTay2fre8I3Gj4XLIJ+G11lImjsPV3Egnto51lZrQMeEGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794533681;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=SmXB1T1DlkWcI+qjh/XbuuEYGGasK1b2JlDP33KWOzc=;
	b=tn9sWjntbQcxt6wmx1U1nev4msVOH4/A+hctDofo8vu1CSG3VStK5plJ326fPdbtiSNC
	 5VaP6XvT0yv4qqtLY3GD5uMfTV4W6GWKmCr9sK5HrEuQ4HC5ZAPwh/v5RPs+tdQIufrtJ
	 +TCq1NUR3JpSkdu9CYauD/jIQ3ssUKVIMMHLhwlUzyALhNZHwBNWVIp+xJg1u9++tdj4k
	 r1+No+/WeaWfTNeDk+oJIqRaxoRH+3jJhyJk/xRZR0JrRqyKOgprtl4RgLtqKrzj/jS6n
	 qsQsjuTmIxsnXKPnaSHHQfouc8lre2EUGg+7dAUYipOfoVO8J4HaE8N1Tcrss7jc28w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eB5+7BPY;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C7E606A323
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 01:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6C7E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eB5+7BPY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794533681; x=1826069681;
  h=date:from:to:cc:subject:message-id;
  bh=FtFeJ5zQCNT/HA3kx4L1V4YwCttMJZo5UMXnRhn3nMI=;
  b=eB5+7BPYVI9Cv4B8s91Z4k9DYZnxH7u3tcW7ws8Hk/sDl2LfA2lkh2Wo
   wwEKO+6uHbqKvK2BuPsqB+1EPmuhGFC5VFErvwOj5N76quUbLWKPbPlSh
   VIm6xFtiVoLO8e5POQnep3SOw0FX+H4jqXae0NjsrEJ7+Kj+s/Bg37G3A
   WVfYluM+ULaRkVrMiAppye8CdIHFNCZXOIHchYVDGnymxA6iHzIVH00ca
   6+y3Pv9wEV7PIM23XRGSQsIpqEf25ba8ImRARnnkHwOWM7oDNM04yADFb
   wnTbaPuW1JKftCrOWZ9UHAoTeJdCzGP3QmunHlK2FwbgKQc49kRYBix/k
   Q==;
X-CSE-ConnectionGUID: ES/hK+AFTLmDN4pymkgiQg==
X-CSE-MsgGUID: sJYBaxsXSRW4KYaxLm+/fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3321084"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3321084"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 17:34:39 -0800
X-CSE-ConnectionGUID: baDMv114RDi8CX3eiC68+w==
X-CSE-MsgGUID: d5dDC7+NT624YWRohN4G4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="10576615"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 12 Nov 2026 17:34:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRgBW-000000012IF-1DKt;
	Fri, 13 Nov 2026 01:34:34 +0000
Date: Fri, 13 Nov 2026 09:33:55 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 daed51c9105158768a3949395135aa6e0a04bb7e
Message-ID: <20261113093355.SmU2zVTx-lkp@intel.com>
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
branch HEAD: daed51c9105158768a3949395135aa6e0a04bb7e  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 992m

configs tested: 233
configs skipped: 19

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261112    clang-24
arc                   randconfig-1001-20261112    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                           ep93xx_defconfig    clang-24
arm                       integrator_defconfig    clang-24
arm                          lpc18xx_defconfig    clang-24
arm                   randconfig-1000-20261112    clang-24
arm                   randconfig-1001-20261112    clang-24
arm                   randconfig-1002-20261112    clang-24
arm                   randconfig-1003-20261112    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261112    gcc-14.4.0
arm64                 randconfig-1001-20261112    gcc-14.4.0
arm64                 randconfig-1002-20261112    gcc-14.4.0
arm64                 randconfig-1003-20261112    gcc-14.4.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261112    gcc-14.4.0
csky                  randconfig-1001-20261112    gcc-14.4.0
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261112    clang-17
hexagon               randconfig-1000-20261112    clang-24
hexagon               randconfig-1001-20261112    clang-24
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261112    clang-22
i386        buildonly-randconfig-1000-20261113    clang-22
i386        buildonly-randconfig-1001-20261112    clang-22
i386        buildonly-randconfig-1001-20261112    gcc-14
i386        buildonly-randconfig-1001-20261113    clang-22
i386        buildonly-randconfig-1002-20261112    clang-22
i386        buildonly-randconfig-1002-20261113    clang-22
i386        buildonly-randconfig-1003-20261112    clang-22
i386        buildonly-randconfig-1003-20261113    clang-22
i386        buildonly-randconfig-1004-20261112    clang-22
i386        buildonly-randconfig-1004-20261112    gcc-14
i386        buildonly-randconfig-1004-20261113    clang-22
i386        buildonly-randconfig-1005-20261112    clang-22
i386        buildonly-randconfig-1005-20261112    gcc-14
i386        buildonly-randconfig-1005-20261113    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261112    gcc-14
i386                  randconfig-1001-20261112    gcc-14
i386                  randconfig-1002-20261112    gcc-14
i386                  randconfig-1003-20261112    gcc-14
i386                  randconfig-1004-20261112    gcc-14
i386                  randconfig-1005-20261112    gcc-14
i386                  randconfig-1006-20261112    gcc-14
i386                  randconfig-1007-20261112    clang-22
i386                  randconfig-1007-20261113    clang-22
i386                  randconfig-1008-20261112    clang-22
i386                  randconfig-1008-20261113    clang-22
i386                  randconfig-1009-20261112    clang-22
i386                  randconfig-1009-20261113    clang-22
i386                  randconfig-1010-20261112    clang-22
i386                  randconfig-1010-20261113    clang-22
i386                  randconfig-1011-20261112    clang-22
i386                  randconfig-1011-20261113    clang-22
i386                  randconfig-1012-20261112    clang-22
i386                  randconfig-1012-20261113    clang-22
i386                  randconfig-1013-20261112    clang-22
i386                  randconfig-1013-20261113    clang-22
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261112    clang-24
loongarch             randconfig-1000-20261112    gcc-16.2.0
loongarch             randconfig-1001-20261112    clang-24
loongarch             randconfig-1001-20261112    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                          bigsur_defconfig    gcc-16.2.0
mips                       maltasmvp_defconfig    gcc-16.2.0
mips                       pic32mzda_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261112    clang-24
nios2                 randconfig-1000-20261112    gcc-8.5.0
nios2                 randconfig-1001-20261112    clang-24
nios2                 randconfig-1001-20261112    gcc-11.5.0
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261112    gcc-12.5.0
parisc                randconfig-1000-20261113    gcc-13.5.0
parisc                randconfig-1001-20261112    gcc-12.5.0
parisc                randconfig-1001-20261113    gcc-13.5.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261112    gcc-12.5.0
powerpc               randconfig-1000-20261113    gcc-13.5.0
powerpc               randconfig-1001-20261112    gcc-12.5.0
powerpc               randconfig-1001-20261113    gcc-13.5.0
powerpc64             randconfig-1000-20261112    gcc-12.5.0
powerpc64             randconfig-1000-20261113    gcc-13.5.0
powerpc64             randconfig-1001-20261112    gcc-12.5.0
powerpc64             randconfig-1001-20261113    gcc-13.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    sh7724_generic_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261112    gcc-8.5.0
sparc                 randconfig-1001-20261112    gcc-8.5.0
sparc                        sparc64_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261112    gcc-8.5.0
sparc64               randconfig-1001-20261112    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261112    gcc-8.5.0
um                    randconfig-1001-20261112    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261112    gcc-14
x86_64      buildonly-randconfig-1000-20261113    clang-22
x86_64      buildonly-randconfig-1001-20261112    gcc-14
x86_64      buildonly-randconfig-1001-20261113    clang-22
x86_64      buildonly-randconfig-1002-20261112    gcc-14
x86_64      buildonly-randconfig-1002-20261113    clang-22
x86_64      buildonly-randconfig-1003-20261112    gcc-14
x86_64      buildonly-randconfig-1003-20261113    clang-22
x86_64      buildonly-randconfig-1004-20261112    gcc-14
x86_64      buildonly-randconfig-1004-20261113    clang-22
x86_64      buildonly-randconfig-1005-20261112    gcc-14
x86_64      buildonly-randconfig-1005-20261113    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1006-20261112    gcc-14
x86_64                randconfig-1007-20261112    gcc-14
x86_64                randconfig-1008-20261112    gcc-14
x86_64                randconfig-1009-20261112    gcc-14
x86_64                randconfig-1010-20261112    gcc-14
x86_64                randconfig-1011-20261112    gcc-14
x86_64                randconfig-1012-20261112    clang-22
x86_64                randconfig-1012-20261113    gcc-14
x86_64                randconfig-1013-20261112    clang-22
x86_64                randconfig-1013-20261113    gcc-14
x86_64                randconfig-1014-20261112    clang-22
x86_64                randconfig-1014-20261113    gcc-14
x86_64                randconfig-1015-20261112    clang-22
x86_64                randconfig-1015-20261113    gcc-14
x86_64                randconfig-1016-20261112    clang-22
x86_64                randconfig-1016-20261113    gcc-14
x86_64                randconfig-1017-20261112    clang-22
x86_64                randconfig-1017-20261113    gcc-14
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
xtensa                randconfig-1000-20261112    gcc-8.5.0
xtensa                randconfig-1001-20261112    gcc-8.5.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
