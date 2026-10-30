Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381082;
	b=xLsnOn9p4GwhSWTNMLmilNR8znnHE/ZgcWoDbdoYM7HRgfnNJx+mzotPKVxLdblAo2n5
	 2sPUA64ONcTLesTmRT9vbWTYMmD/ZBdAXEKymFmLuUp2ygAgYI8bZmdDxe01BSYma1tNS
	 wccMhMEhCL2oPoTZt2Eqd8Po0b4AR2nQmAGNK4yDNXN2Z7tqRNWxxkRihEUqScHFeRReb
	 i/LVsW2RL7bVVRGQLP03JpXPUljY6mROBKIjVcg5ETEH2tS1/oGCigJorP02rNNsY4ijO
	 NYj8D1MxY8oY4F71JhfdHjvZKigE7/aTPjBY+ZBd13IewmCoI9zHvLsQNw9tT/x2IlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381082;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=cjvzieB2xfmCXn6g+QLg66M3I+bYxfDfj3rVMKyJmB4=;
	b=KLZj3RC38mrt6a4svZwJDP4qrrlwRxrwTzRw5ds/fYwry/XtWkcXEgJMyPEawkKMgRQR
	 zJW/jT4zh7GE3jEFzIuD1wpwfWyRbJrsRW2XEWfdtSqsLzD81rTGgwEJIM4PUtQTn0Wjg
	 3w+BdKuZ6NrGVtTZ7V83tcIOpozNcHTclR2tnxbQoiNHARsdkbV1trt5Rfm2+K3YoPd9I
	 znSYMH4cvabYL/kcbD/Z2EH1dYxJEAn/5la0Ht+6SHc0ErCPuJua3VXAuqh37wglrrPRh
	 88Eb7tHU1eomyfFNCByNiXqIehfH/sqI/DGUg74B0oivZ0hkYF0EXbd4yZbldei7uHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JzPh9nGm;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B26B606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 17:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B26B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JzPh9nGm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793381081; x=1824917081;
  h=date:from:to:cc:subject:message-id;
  bh=XmjgKkiq8T6KWlXFBZuxUsxwhzykkYonEf3QZviu7js=;
  b=JzPh9nGmeu9lOZNAkFKHrpYapQiyNvATZmbXwo0xaZvdg5F0Ri+gAQhp
   qWnfJr67kJK8gny4VaKZ1TgGy8DtY4ptsXorSXnowlmLw83vSMx/PLF/5
   wzNpO0NBK2XQU1lBLkm5OgE7AZV+yWQC+UddbI2wW/ZYUaHk/GdN9u361
   uAoHoBNlbbk8cL+PMFrjdFYu0/ncNoy4qwbHIhK+ZYgvzkYD5Wvy6w6lW
   c66VW56YVVRF0ovP402VXym6ZD2GNRAyDf+mooCkr+zZTkB6ztn9OKuVE
   qAirTAqnPflbiLgb2qzdbrEFWSdGH8SfyEpuS9CrQr32tHbNDjA1szl6/
   w==;
X-CSE-ConnectionGUID: cj8O0E+SQg+ml2Fk/vE0Pg==
X-CSE-MsgGUID: u4cUbHWITyCi7E8DO+kNFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2185136"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2185136"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 10:24:40 -0700
X-CSE-ConnectionGUID: m5cmepwQR+aJRfHdSWkKNg==
X-CSE-MsgGUID: eQh22w8HSEWmxGnQPOyxUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5893783"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 30 Oct 2026 10:24:39 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMqLE-00000000c2W-2pDC;
	Fri, 30 Oct 2026 17:24:36 +0000
Date: Sat, 31 Oct 2026 01:24:28 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9c449f885765cf8d80b2c60b1971e774bba51a3f
Message-ID: <202610310125.u2fTWy6p-lkp@intel.com>
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
branch HEAD: 9c449f885765cf8d80b2c60b1971e774bba51a3f  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 929m

configs tested: 154
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261030    gcc-12.5.0
arc                   randconfig-1001-20261030    gcc-10.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261030    clang-19
arm                   randconfig-1001-20261030    gcc-8.5.0
arm                   randconfig-1002-20261030    clang-24
arm                   randconfig-1003-20261030    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261030    clang-24
arm64                 randconfig-1001-20261030    gcc-13.5.0
arm64                 randconfig-1002-20261030    gcc-8.5.0
arm64                 randconfig-1003-20261030    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261030    gcc-16.2.0
csky                  randconfig-1001-20261030    gcc-14.4.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
i386                              alldefconfig    gcc-14
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261030    gcc-14
i386        buildonly-randconfig-1001-20261030    gcc-14
i386        buildonly-randconfig-1002-20261030    clang-22
i386        buildonly-randconfig-1003-20261030    gcc-14
i386        buildonly-randconfig-1004-20261030    gcc-14
i386        buildonly-randconfig-1005-20261030    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261030    clang-22
i386                  randconfig-1001-20261030    clang-22
i386                  randconfig-1002-20261030    gcc-14
i386                  randconfig-1003-20261030    clang-22
i386                  randconfig-1004-20261030    clang-22
i386                  randconfig-1005-20261030    gcc-14
i386                  randconfig-1006-20261030    gcc-14
i386                  randconfig-1008-20261030    gcc-14
i386                  randconfig-1010-20261030    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                        m5275evb_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261030    gcc-10.5.0
parisc                randconfig-1001-20261030    gcc-16.2.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                    currituck_defconfig    clang-24
powerpc                    microwatt_defconfig    gcc-16.2.0
powerpc                  mpc837x_rdb_defconfig    gcc-16.2.0
powerpc                   mpc866_ads_defconfig    clang-17
powerpc               randconfig-1000-20261030    clang-24
powerpc               randconfig-1001-20261030    gcc-11.5.0
powerpc                     socrates_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261030    clang-24
powerpc64             randconfig-1001-20261030    gcc-10.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv              nommu_k210_sdcard_defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261030    gcc-13.5.0
riscv                 randconfig-1001-20261030    gcc-15.3.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261030    gcc-9.5.0
s390                  randconfig-1001-20261030    gcc-11.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261030    gcc-12.5.0
sh                    randconfig-1001-20261030    gcc-10.5.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261030    gcc-8.5.0
sparc                 randconfig-1001-20261030    gcc-14.4.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261030    gcc-13.5.0
sparc64               randconfig-1001-20261030    gcc-11.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261030    clang-17
um                    randconfig-1001-20261030    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261030    gcc-14
x86_64      buildonly-randconfig-1001-20261030    clang-22
x86_64      buildonly-randconfig-1002-20261030    clang-22
x86_64      buildonly-randconfig-1003-20261030    gcc-14
x86_64      buildonly-randconfig-1004-20261030    gcc-14
x86_64      buildonly-randconfig-1005-20261030    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261030    clang-22
x86_64                randconfig-1001-20261030    gcc-14
x86_64                randconfig-1002-20261030    clang-22
x86_64                randconfig-1003-20261030    gcc-14
x86_64                randconfig-1004-20261030    gcc-14
x86_64                randconfig-1005-20261030    gcc-14
x86_64                randconfig-1006-20261030    gcc-14
x86_64                randconfig-1007-20261030    clang-22
x86_64                randconfig-1008-20261030    gcc-14
x86_64                randconfig-1009-20261030    gcc-14
x86_64                randconfig-1010-20261030    gcc-14
x86_64                randconfig-1011-20261030    clang-22
x86_64                randconfig-1012-20261030    gcc-14
x86_64                randconfig-1013-20261030    clang-22
x86_64                randconfig-1014-20261030    clang-22
x86_64                randconfig-1015-20261030    clang-22
x86_64                randconfig-1016-20261030    clang-22
x86_64                randconfig-1017-20261030    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261030    gcc-10.5.0
xtensa                randconfig-1001-20261030    gcc-16.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
