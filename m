Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536548;
	b=BHSPE/z/aXoaIM9awQW1IacjMHZKJnxDxu0NTCvNoW8WfucRxk+nFPetba/xjvZsHKcd
	 bH0V1U1ZPsyXGOF8wKI14981T952mgn7a7+08lPMo8HbIjrBco/bM6VvO6lNcWNoZzT57
	 4MJukjizh03lfmm1jI1BIxaJMGJURsoLQgu+Blci8tpprDhWo36xUmHaMpp+gEET46iV9
	 PI1CIJbQifBwt4Ku5rdl/7sOVxVEHjkCm6GAMy/Fbc7Uz9IU6z1l9C9HFQg2lqpjOcDfr
	 6H21zpShWbkecMPEYkDYpjdub1vSwLjVsgkg0TiY5D8Z/5GFiqnZMQt9pjtjDa5BuSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536548;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=PvnA9UyYB09A3E004cKhj4DhYl5a/Iq2c25nOa9MoU4=;
	b=yabnd4LA9scHDEFeElw8/rZVAYecD0QWpXDLdc7YPSaF1Whjngd/NRKk6AsXIM7EzLYd
	 4+QBQrf1IYkqP0ZSOjQ0qqAvNrXmAldx27vH2HpbJHgJu9wNSmdERSGWeRWw+ixPX8hLR
	 uvwi41njp5xQRTh1+dOkCKMMsnP1cQxdn7zwG+JfYJeVnfXnmEQc10m8EE04yaFF2QGWH
	 3KUTrc7FtZavbsr2setEyJLcDehmUN4ueU+7v831Gx6Sg9h2ijto9s5Js+VybQqaeLFUq
	 OaTh7BXs53ntufXWsOjjgrTO/rNSjCCC/P7bxx2x1HwHT+T3fmI1NseNJ282mMXVfpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KC3DbUnl;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02BD606A319
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 22:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C02BD606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KC3DbUnl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792536548; x=1824072548;
  h=date:from:to:cc:subject:message-id;
  bh=LYOblehVC5QGAH9hfYsbb2HvSCv5rGDVxMrcoBtu05c=;
  b=KC3DbUnlH9RiRdazTdDcRvNVRi7r52TIPbFP+TS08wl12Soy3H4ciPxo
   MUjAI3in4gUxMUF6nnQBYPlegFFlH/VgjoyuBUjn9gJnUANWCMvQ7L3cn
   KRZFl50gwsy11aM1vZHDUaHZ6irUudTrWv04Ba1on1dIr7g5OFRNRZJsq
   NJWj/xgCwem2Vq6nBIz/04FM8dnq3IRnXwwvzwKxjP83sxnhDuxsZUVAr
   x+LlLp26ttQEpj6GwqC/yDwTtW3PSVwid98EtkzhyeGYq5xol+sR3jmBo
   N8wZFQviQYGNEBGJbO678io+ZSMfbhRFcLI8iIKVT0EaYvH7UhA0Ys2Bq
   g==;
X-CSE-ConnectionGUID: 3UIvsw6wTD6h3p04GMl2Eg==
X-CSE-MsgGUID: H7gSzk7sQOW88U4h+sRK0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1155360"
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="1155360"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 15:49:07 -0700
X-CSE-ConnectionGUID: hE5r6CS3TWKLmx1NUQH7iQ==
X-CSE-MsgGUID: b/Rhp6ixSOanmJdK9QAFlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3272377"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 20 Oct 2026 15:49:06 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xJIdj-00000000OcY-0Ili;
	Tue, 20 Oct 2026 22:49:03 +0000
Date: Wed, 21 Oct 2026 06:48:33 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 59d7f9ec14ad4b6f38c04d254f8f2bfb991e888e
Message-ID: <202610210630.BGP4enpf-lkp@intel.com>
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
branch HEAD: 59d7f9ec14ad4b6f38c04d254f8f2bfb991e888e  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1075m

configs tested: 162
configs skipped: 8

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
arc                   randconfig-1000-20261021    gcc-16.2.0
arc                   randconfig-1001-20261021    gcc-14.4.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                      am200epdkit_defconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                              mxs_defconfig    clang-17
arm                            omap1_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261021    clang-24
arm                   randconfig-1001-20261021    clang-17
arm                   randconfig-1002-20261021    gcc-14.4.0
arm                   randconfig-1003-20261021    clang-17
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261020    clang-17
arm64                 randconfig-1001-20261020    clang-24
arm64                 randconfig-1002-20261020    gcc-8.5.0
arm64                 randconfig-1003-20261020    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261020    gcc-16.2.0
csky                  randconfig-1001-20261020    gcc-15.3.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261020    clang-17
hexagon               randconfig-1001-20261020    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261020    clang-22
i386        buildonly-randconfig-1001-20261020    gcc-14
i386        buildonly-randconfig-1002-20261020    clang-22
i386        buildonly-randconfig-1003-20261020    clang-22
i386        buildonly-randconfig-1004-20261020    clang-22
i386        buildonly-randconfig-1005-20261020    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261020    clang-22
i386                  randconfig-1001-20261020    clang-22
i386                  randconfig-1002-20261020    gcc-14
i386                  randconfig-1003-20261020    clang-22
i386                  randconfig-1004-20261020    clang-22
i386                  randconfig-1005-20261020    gcc-14
i386                  randconfig-1006-20261020    clang-22
i386                  randconfig-1007-20261020    gcc-14
i386                  randconfig-1008-20261020    gcc-14
i386                  randconfig-1009-20261020    clang-22
i386                  randconfig-1010-20261020    gcc-14
i386                  randconfig-1011-20261020    gcc-14
i386                  randconfig-1012-20261020    clang-22
i386                  randconfig-1013-20261020    gcc-12
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261020    gcc-16.2.0
loongarch             randconfig-1001-20261020    clang-21
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261020    gcc-11.5.0
nios2                 randconfig-1001-20261020    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261020    gcc-15.3.0
parisc                randconfig-1001-20261020    gcc-13.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                       ppc64e_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261020    gcc-16.2.0
powerpc               randconfig-1001-20261020    clang-24
powerpc64             randconfig-1000-20261020    gcc-8.5.0
powerpc64             randconfig-1001-20261020    clang-17
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261020    gcc-12.5.0
riscv                 randconfig-1001-20261020    gcc-8.5.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261020    clang-24
s390                  randconfig-1001-20261020    gcc-10.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261020    gcc-16.2.0
sh                    randconfig-1001-20261020    gcc-11.5.0
sh                           rsk7264_defconfig    gcc-16.2.0
sh                            se7619_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261020    gcc-16.2.0
sparc                 randconfig-1001-20261020    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261020    clang-20
sparc64               randconfig-1001-20261020    clang-24
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261020    clang-17
um                    randconfig-1001-20261020    clang-20
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261020    clang-22
x86_64      buildonly-randconfig-1001-20261020    gcc-14
x86_64      buildonly-randconfig-1002-20261020    gcc-14
x86_64      buildonly-randconfig-1003-20261020    clang-22
x86_64      buildonly-randconfig-1004-20261020    gcc-13
x86_64      buildonly-randconfig-1005-20261020    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261020    clang-22
x86_64                randconfig-1001-20261020    clang-22
x86_64                randconfig-1002-20261020    clang-22
x86_64                randconfig-1003-20261020    gcc-14
x86_64                randconfig-1004-20261020    clang-22
x86_64                randconfig-1005-20261020    clang-22
x86_64                randconfig-1006-20261020    gcc-14
x86_64                randconfig-1007-20261020    gcc-14
x86_64                randconfig-1008-20261020    clang-22
x86_64                randconfig-1009-20261020    clang-22
x86_64                randconfig-1010-20261020    gcc-14
x86_64                randconfig-1011-20261020    clang-22
x86_64                randconfig-1012-20261020    gcc-14
x86_64                randconfig-1013-20261020    gcc-14
x86_64                randconfig-1014-20261020    clang-22
x86_64                randconfig-1015-20261020    gcc-14
x86_64                randconfig-1016-20261020    clang-22
x86_64                randconfig-1017-20261020    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                           iss_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261020    gcc-15.3.0
xtensa                randconfig-1001-20261020    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
