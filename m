Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0EE33D503
	for <mm-commits@vger.kernel.org>; Sat, 19 Sep 2026 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829212; cv=none; b=LhPZOtGrI85aa9qR4YEscuSVRvaU8jVd0egjVP7UQkoPmNnCYNWhvvCtdAU+oALO7AICmRWuqajYWadn20VRqgaoV48M1mQgu9D+Tc+yGhYuKezxy1ToiClEK4IQTlNu/cHK1FsDrX86vOtdxGIyrRLpf9v0B//JnuSUtsWYz8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829212; c=relaxed/simple;
	bh=bdviDNSc62StKYmd5Gp+BM2n8hRFMr7+Dls4R3Y11Gw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=uND+o4U/Hr4VhaXju7syO9dlyVuANPm4lQWkh/fp53mxuIb7t9VkDrG62JkO5ejLdIlRpiGkkIlnpB/wuSpU0okk968XqOwSjFamY4U+/uyUOPPb6BcYRHEvwky9y9BJoZ2BozoRfmlc8vxrwK76adbriQSUKnP3i9YOspq32Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F7FZaasq; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F7FZaasq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789829209; x=1821365209;
  h=date:from:to:cc:subject:message-id;
  bh=bdviDNSc62StKYmd5Gp+BM2n8hRFMr7+Dls4R3Y11Gw=;
  b=F7FZaasqdzepwZjkTyBZ6zcdzv0YVMhC/GNJd0ajOz8Bq84X/TBMB3ek
   /pff2cuKUWd/Vt3z1X4DQcfSdjEaHegi3ssD8osotf2UD/VwiPBFvdPg7
   BwMj2B5vCvPEfVtmxFi2+9IMHruZSje1nbyTYGh5pj/cMv7Px/LJQSRlp
   NUX1+M7uNZb3dJ/TqcorqzGnTmf0yAc5Q1j+95SeRzLuKMKVZhVux59Lg
   lg8UBavLmIx7q1kClkREyZ6o7aqGuRIunzB8rpP2ePOJ9+8ZCUP+vXjRy
   SvoWkDwxPj+5JnQL3c2/jpj1rvufyy/gsblOSSwnHoyl+trlKA0WHgMbW
   A==;
X-CSE-ConnectionGUID: QzpdmItfRAiT0qMbRisfqw==
X-CSE-MsgGUID: HGWmBxoESSq81A1LSiqyrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="77922689"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="77922689"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 07:46:49 -0700
X-CSE-ConnectionGUID: jKcht4byQRm6lTBeCDPFcQ==
X-CSE-MsgGUID: HY9w1F77Q6m6pyHwZcPbVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="272163073"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 19 Sep 2026 07:46:47 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x7wKy-00000000B09-3XBI;
	Sat, 19 Sep 2026 14:46:44 +0000
Date: Sat, 19 Sep 2026 22:46:28 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 854157fc9d011b8dd5a1a86a237447e28d681eb9
Message-ID: <202609192223.y5jKCkQi-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 854157fc9d011b8dd5a1a86a237447e28d681eb9  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: m

configs tested: 171
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260919    gcc-15.2.0
arc                   randconfig-1001-20260919    gcc-13.4.0
arc                  randconfig-r1302-20260919    gcc-10.5.0 sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20260919    gcc-10.5.0
arm                   randconfig-1001-20260919    gcc-11.5.0
arm                   randconfig-1002-20260919    gcc-13.4.0
arm                   randconfig-1003-20260919    gcc-15.2.0
arm                           sp7021_defconfig    gcc-16.1.0
arm                        versatile_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260919    gcc-16.1.0
arm64                 randconfig-1001-20260919    gcc-10.5.0
arm64                 randconfig-1002-20260919    gcc-8.5.0
arm64                 randconfig-1003-20260919    clang-24
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260919    gcc-11.5.0
csky                  randconfig-1001-20260919    gcc-16.1.0
csky                 randconfig-r1301-20260919    gcc-10.5.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260919    clang-17
hexagon               randconfig-1001-20260919    clang-18
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20260919    clang-22
i386        buildonly-randconfig-1001-20260919    clang-22
i386        buildonly-randconfig-1002-20260919    clang-22
i386        buildonly-randconfig-1003-20260919    clang-22
i386        buildonly-randconfig-1004-20260919    gcc-14
i386        buildonly-randconfig-1005-20260919    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260919    clang-22
i386                  randconfig-1001-20260919    clang-22
i386                  randconfig-1002-20260919    clang-22
i386                  randconfig-1003-20260919    clang-22
i386                  randconfig-1004-20260919    clang-22
i386                  randconfig-1005-20260919    gcc-14
i386                  randconfig-1006-20260919    gcc-14
i386                  randconfig-1007-20260919    clang-22
i386                  randconfig-1008-20260919    clang-22
i386                  randconfig-1009-20260919    gcc-14
i386                  randconfig-1010-20260919    clang-22
i386                  randconfig-1011-20260919    gcc-14
i386                  randconfig-1012-20260919    gcc-14
i386                  randconfig-1013-20260919    gcc-14
i386                 randconfig-r1303-20260919    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260919    clang-24
loongarch             randconfig-1001-20260919    clang-18
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       loongson3_defconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260919    gcc-8.5.0
nios2                 randconfig-1001-20260919    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1308-20260919    gcc-14.3.0 sparse
parisc                            alldefconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260919    gcc-8.5.0
parisc                randconfig-1001-20260919    gcc-11.5.0
parisc               randconfig-r1306-20260919    gcc-12.5.0 sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       katmai_defconfig    clang-24
powerpc                  mpc8315_rdb_defconfig    clang-24
powerpc                  mpc834x_itx_defconfig    clang-24
powerpc               randconfig-1000-20260919    clang-21
powerpc               randconfig-1001-20260919    gcc-16.1.0
powerpc              randconfig-r1305-20260919    clang-24   sparse
powerpc                      tqm8541_defconfig    clang-24
powerpc64             randconfig-1000-20260919    clang-17
powerpc64             randconfig-1001-20260919    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260919    clang-24
riscv                 randconfig-1001-20260919    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260919    clang-24
s390                  randconfig-1001-20260919    clang-19
s390                 randconfig-r1307-20260919    clang-24   sparse
s390                 randconfig-r1309-20260919    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                                j2_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260919    gcc-15.2.0
sh                    randconfig-1001-20260919    gcc-9.5.0
sh                    secureedge5410_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260919    gcc-11.5.0
sparc                 randconfig-1001-20260919    gcc-16.1.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260919    clang-20
sparc64               randconfig-1001-20260919    clang-22
sparc64              randconfig-r1304-20260919    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260919    clang-24
um                    randconfig-1001-20260919    gcc-12
um                            x86_64_defconfig    clang-24
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260919    clang-22
x86_64      buildonly-randconfig-1001-20260919    gcc-14
x86_64      buildonly-randconfig-1002-20260919    clang-22
x86_64      buildonly-randconfig-1003-20260919    clang-22
x86_64      buildonly-randconfig-1004-20260919    gcc-13
x86_64      buildonly-randconfig-1005-20260919    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260919    clang-22
x86_64                randconfig-1001-20260919    clang-22
x86_64                randconfig-1002-20260919    clang-22
x86_64                randconfig-1003-20260919    clang-22
x86_64                randconfig-1004-20260919    gcc-14
x86_64                randconfig-1005-20260919    clang-22
x86_64                randconfig-1012-20260919    gcc-14
x86_64                randconfig-1013-20260919    gcc-14
x86_64                randconfig-1014-20260919    clang-22
x86_64                randconfig-1015-20260919    gcc-14
x86_64                randconfig-1016-20260919    gcc-14
x86_64                randconfig-1017-20260919    clang-22
x86_64               randconfig-r1300-20260919    clang-22   sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260919    gcc-13.4.0
xtensa                randconfig-1001-20260919    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
