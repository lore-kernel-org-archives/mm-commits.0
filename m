Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F11B15A86D
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 05:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786165649; cv=none; b=MvQSWW4u560woFFjLUHVH7WQ7IUR1JdKZ2Lbx1APJHhdicmY6XlHDCXQzxchohRvFGJikedYl+WuTRGS36cFHnZ1LuzFjfvcsiJ3h6sz42BRw8LgYYj5wnyVKaRdGDqkM9p7iYWL3u4h9nj7woICaa0MY/WwsT2CSYzPf/ASK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786165649; c=relaxed/simple;
	bh=/Xi1ZoawYjvF26e6Kz5ej95BOmY21gnXZSm/krk+KYc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=fPtuKRrOUFpoGhqYTzI569D7Ael8RXUsyCixllQmVXoCsfZmO1y00woQs9bd7RCBebnMwvn5kcNknhYsHi8jToIpuDZ/aTaeROrdRjB7/F9IotMTlVdDZnmoCWyjV6uCeL4VzZs936zuWNxTM/gD6hjSQatFnBOowT8s3g09AQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KDtZ8CZp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KDtZ8CZp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786165648; x=1817701648;
  h=date:from:to:cc:subject:message-id;
  bh=/Xi1ZoawYjvF26e6Kz5ej95BOmY21gnXZSm/krk+KYc=;
  b=KDtZ8CZp1MZ6YYcU9GXxAkD1YrQa2CNQzusDpXa890kDubQgZyj3GERw
   ydTSmTK7QA7ntCLryNA5UDzvv9CrTehfiY4VL6/IZA5BFa/5PNnB8lcQC
   km7f9lUk9SH9+L61yx/ca9kyDILEQWOvMa2nOaeXc1j383txkVwvuFpxR
   oSbKXxLHOe7SGj78mGqNRI6+d27nN0qOgV2TpSoLgTnjZIeWtCpzsBhLd
   SJMA48SQf4fDZsAdEGiIk8miIg+ZgtgDD1OLBPqKsgGvKsl05QdtIBKMv
   6ek9BmdrT3w6PffLGq6/+VUQpDRftTbA+A609YGM8g70J42HOIUS8BXmP
   Q==;
X-CSE-ConnectionGUID: myljrYwHScKjmMuKY7prgA==
X-CSE-MsgGUID: SADTRV2gQOuZswMGx2WLSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11868"; a="109562886"
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="109562886"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 22:07:28 -0700
X-CSE-ConnectionGUID: 4fRn9+VBTv2t05qK7lUzjA==
X-CSE-MsgGUID: tPV6uJdCTNqkPS8Dry1UyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="260828899"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 07 Aug 2026 22:07:26 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wsZHH-00000000Jm1-3fN5;
	Sat, 08 Aug 2026 05:07:23 +0000
Date: Sat, 08 Aug 2026 13:06:48 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 8086604be9733378461a5534c39cb72635226b23
Message-ID: <202608081329.lUvUN2Er-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 8086604be9733378461a5534c39cb72635226b23  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- alpha-randconfig-r071-20260807
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 814m

configs tested: 97
configs skipped: 0

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260807    gcc-8.5.0
arc                  randconfig-002-20260807    gcc-14.3.0
arm                      imx_v4_v5_defconfig    clang-24
arm                  randconfig-001-20260807    clang-17
arm                  randconfig-002-20260807    gcc-12.5.0
arm                  randconfig-003-20260807    gcc-10.5.0
arm                  randconfig-004-20260807    gcc-16.1.0
arm64                randconfig-001-20260807    clang-24
arm64                randconfig-002-20260807    clang-24
arm64                randconfig-003-20260807    gcc-16.1.0
arm64                randconfig-004-20260807    clang-17
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260807    gcc-14.3.0
csky                 randconfig-002-20260807    gcc-16.1.0
hexagon              randconfig-001-20260807    clang-24
hexagon              randconfig-002-20260807    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260807    gcc-14
i386       buildonly-randconfig-002-20260807    gcc-14
i386       buildonly-randconfig-003-20260807    clang-22
i386       buildonly-randconfig-004-20260807    clang-22
i386       buildonly-randconfig-005-20260807    clang-22
i386       buildonly-randconfig-006-20260807    gcc-13
i386                 randconfig-001-20260807    clang-22
i386                 randconfig-002-20260807    clang-22
i386                 randconfig-003-20260807    clang-22
i386                 randconfig-004-20260807    gcc-14
i386                 randconfig-005-20260807    clang-22
i386                 randconfig-006-20260807    gcc-14
i386                 randconfig-007-20260807    gcc-14
i386                 randconfig-011-20260808    gcc-14
i386                 randconfig-012-20260808    clang-22
i386                 randconfig-013-20260808    gcc-14
i386                 randconfig-014-20260808    clang-22
i386                 randconfig-015-20260808    clang-22
i386                 randconfig-016-20260808    clang-22
i386                 randconfig-017-20260808    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260807    clang-24
loongarch            randconfig-002-20260807    clang-18
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260807    gcc-8.5.0
nios2                randconfig-002-20260807    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260807    gcc-9.5.0
parisc               randconfig-002-20260807    gcc-8.5.0
powerpc              randconfig-001-20260807    clang-24
powerpc              randconfig-002-20260807    clang-24
powerpc64            randconfig-001-20260807    gcc-8.5.0
powerpc64            randconfig-002-20260807    gcc-14.3.0
riscv                randconfig-001-20260807    gcc-12.5.0
riscv                randconfig-002-20260807    gcc-10.5.0
s390                 randconfig-001-20260807    gcc-9.5.0
s390                 randconfig-002-20260807    gcc-15.2.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260807    gcc-16.1.0
sh                   randconfig-002-20260807    gcc-16.1.0
sparc                randconfig-001-20260807    gcc-15.2.0
sparc                randconfig-002-20260807    gcc-16.1.0
sparc64              randconfig-001-20260807    clang-20
sparc64              randconfig-002-20260807    clang-20
um                   randconfig-001-20260807    gcc-14
um                   randconfig-002-20260807    clang-24
x86_64     buildonly-randconfig-001-20260807    clang-22
x86_64     buildonly-randconfig-002-20260807    gcc-14
x86_64     buildonly-randconfig-003-20260807    gcc-14
x86_64     buildonly-randconfig-004-20260807    clang-22
x86_64     buildonly-randconfig-005-20260807    clang-22
x86_64     buildonly-randconfig-006-20260807    clang-22
x86_64               randconfig-001-20260807    clang-22
x86_64               randconfig-002-20260807    gcc-14
x86_64               randconfig-003-20260807    clang-22
x86_64               randconfig-004-20260807    clang-22
x86_64               randconfig-005-20260807    clang-22
x86_64               randconfig-006-20260807    gcc-14
x86_64               randconfig-011-20260807    clang-22
x86_64               randconfig-012-20260807    clang-22
x86_64               randconfig-013-20260807    clang-22
x86_64               randconfig-014-20260807    gcc-14
x86_64               randconfig-015-20260807    gcc-14
x86_64               randconfig-016-20260807    gcc-14
x86_64               randconfig-071-20260807    gcc-13
x86_64               randconfig-072-20260807    clang-22
x86_64               randconfig-073-20260807    clang-22
x86_64               randconfig-074-20260807    clang-22
x86_64               randconfig-075-20260807    gcc-14
x86_64               randconfig-076-20260807    clang-22
xtensa               randconfig-001-20260807    gcc-8.5.0
xtensa               randconfig-002-20260807    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
