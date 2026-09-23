Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E9F496D58
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161340; cv=none; b=VJaK1OXnUZGOsZnpZ9weSCM7i3RjjSljthU6rmS+rJelbpxPW7aT7tCmcFqnVM+JXPMEAXk6eRBCrGwFbkvb6tuQrcbJtC5eQNdad1i53JPaRcI6gbOaZL0/uFSztfSlJpaVOKEJQhxxIgh4PGgEldxpAb7xKp6b1u2GWyzdVac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161340; c=relaxed/simple;
	bh=nqTde3JsSd69V0UQEeIidhFd/55FQ+H6onaGQNDpxhM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=LPk/ROKXAfJdDpK7xCOo0YIyvnS9hdn7OvwKr3Cl4bd/P1iOgiboe1Pz5rusAl2jYKRLvk0sSxZxC2ll61RyddPAdf5Wzb6gB7Jvxf+VH9Zm1rxTne3Qx7gOhy6avRuIDhNEdCdBJP0R0sqmylvlI6rGKY23RJ+Jcpb0cyuqPp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UfYY16FV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UfYY16FV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790161339; x=1821697339;
  h=date:from:to:cc:subject:message-id;
  bh=nqTde3JsSd69V0UQEeIidhFd/55FQ+H6onaGQNDpxhM=;
  b=UfYY16FVJF3MUIoKpU3ZqFkYBrsw2P9oY3/Os0VuJ2UvhV9XiLu4kSz4
   /uu5LAKDjsjrN7bxzawaEXmtUhg6BiBe1I34MdanYQKg1KwjJtbMzep8y
   sKEsmKJ/mktzG4KEKkVqXQ6KA7ifT1TjkjQCoitP4s/ytOvlvF/2/unt/
   Xk2jY53e7nhEfaZ7G05AQxr7wGThKQzojxkjD6isemssNpmQ5+1feFE3D
   vwqwges7/NUw1pWX0m1r7PQzHpvfNCTv9yhRiKGfQLe5AtmTC0WnSqsXf
   6RXOCmJUsSGtR/tc9AXsbx3geyWWRWrdIlpj/TnxOPde99y8Jrsw36Ano
   g==;
X-CSE-ConnectionGUID: V+sA+XVnSV2+K079qP4YSw==
X-CSE-MsgGUID: w4z6iUzGRI+iiTww6FOObQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="108340641"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="108340641"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 04:02:01 -0700
X-CSE-ConnectionGUID: mxq/bKpNSK2CrWu0YvPCHQ==
X-CSE-MsgGUID: jPqDpC1oRKGjUszPWX8nTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="278289468"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 23 Sep 2026 04:01:58 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9Kjb-00000000Gy6-2aPg;
	Wed, 23 Sep 2026 11:01:55 +0000
Date: Wed, 23 Sep 2026 19:01:06 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 8d29b5365d528da545c1fe0768a55babadee95d0
Message-ID: <202609231903.l9QgUo5v-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 8d29b5365d528da545c1fe0768a55babadee95d0  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1767m

configs tested: 170
configs skipped: 10

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
arc                   randconfig-1000-20260923    gcc-8.5.0
arc                   randconfig-1001-20260923    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                        aspeed_g5_defconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20260923    gcc-8.5.0
arm                   randconfig-1001-20260923    clang-24
arm                   randconfig-1002-20260923    gcc-13.4.0
arm                   randconfig-1003-20260923    gcc-15.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260923    clang-24
arm64                 randconfig-1001-20260923    clang-17
arm64                 randconfig-1002-20260923    clang-24
arm64                 randconfig-1003-20260923    clang-18
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260923    gcc-11.5.0
csky                  randconfig-1001-20260923    gcc-9.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260923    clang-24
hexagon               randconfig-1001-20260923    clang-20
hexagon              randconfig-r1305-20260923    clang-17   sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20260923    clang-22
i386        buildonly-randconfig-1001-20260923    gcc-14
i386        buildonly-randconfig-1002-20260923    gcc-13
i386        buildonly-randconfig-1003-20260923    gcc-14
i386        buildonly-randconfig-1004-20260923    clang-22
i386        buildonly-randconfig-1005-20260923    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260923    clang-22
i386                  randconfig-1001-20260923    clang-22
i386                  randconfig-1002-20260923    clang-22
i386                  randconfig-1003-20260923    clang-22
i386                  randconfig-1004-20260923    gcc-14
i386                  randconfig-1005-20260923    clang-22
i386                  randconfig-1006-20260923    clang-22
i386                  randconfig-1007-20260923    clang-22
i386                  randconfig-1008-20260923    clang-22
i386                  randconfig-1009-20260923    gcc-14
i386                  randconfig-1010-20260923    clang-22
i386                  randconfig-1011-20260923    gcc-14
i386                  randconfig-1012-20260923    gcc-14
i386                  randconfig-1013-20260923    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260923    clang-24
loongarch             randconfig-1001-20260923    clang-24
loongarch            randconfig-r1308-20260923    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r1307-20260923    gcc-15.2.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                            ip28_defconfig    gcc-16.1.0
mips                        lemote2f_defconfig    gcc-16.1.0
mips                       maltaaprp_defconfig    clang-17
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260923    gcc-8.5.0
nios2                 randconfig-1001-20260923    gcc-9.5.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1309-20260923    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260923    gcc-9.5.0
parisc                randconfig-1001-20260923    gcc-15.2.0
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20260923    clang-17
powerpc               randconfig-1001-20260923    clang-24
powerpc                      tqm8555_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260923    clang-22
powerpc64             randconfig-1001-20260923    clang-24
powerpc64            randconfig-r1303-20260923    clang-17   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                     nommu_virt_defconfig    clang-24
riscv                 randconfig-1000-20260923    clang-24
riscv                 randconfig-1001-20260923    gcc-16.1.0
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260923    clang-24
s390                  randconfig-1001-20260923    gcc-16.1.0
s390                 randconfig-r1300-20260923    clang-20   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260923    gcc-11.5.0
sh                    randconfig-1001-20260923    gcc-9.5.0
sh                            se7619_defconfig    gcc-16.1.0
sh                         sh7757lcr_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260923    gcc-15.2.0
sparc                 randconfig-1001-20260923    gcc-13.4.0
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260923    gcc-14.3.0
sparc64               randconfig-1001-20260923    clang-24
sparc64              randconfig-r1306-20260923    gcc-16.1.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260923    clang-24
um                    randconfig-1001-20260923    gcc-12
um                   randconfig-r1304-20260923    clang-24   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20260923    gcc-14
x86_64      buildonly-randconfig-1001-20260923    clang-22
x86_64      buildonly-randconfig-1002-20260923    gcc-14
x86_64      buildonly-randconfig-1003-20260923    gcc-14
x86_64      buildonly-randconfig-1004-20260923    gcc-14
x86_64      buildonly-randconfig-1005-20260923    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260923    clang-22
x86_64                randconfig-1001-20260923    gcc-14
x86_64                randconfig-1002-20260923    gcc-13
x86_64                randconfig-1003-20260923    clang-22
x86_64                randconfig-1004-20260923    gcc-14
x86_64                randconfig-1005-20260923    clang-22
x86_64                randconfig-1006-20260923    clang-22
x86_64                randconfig-1007-20260923    gcc-13
x86_64                randconfig-1008-20260923    gcc-14
x86_64                randconfig-1009-20260923    gcc-13
x86_64                randconfig-1010-20260923    clang-22
x86_64                randconfig-1011-20260923    gcc-14
x86_64                randconfig-1012-20260923    gcc-14
x86_64                randconfig-1013-20260923    gcc-14
x86_64                randconfig-1014-20260923    gcc-14
x86_64                randconfig-1015-20260923    gcc-14
x86_64                randconfig-1016-20260923    gcc-14
x86_64                randconfig-1017-20260923    clang-22
x86_64               randconfig-r1301-20260923    gcc-14     sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                randconfig-1000-20260923    gcc-9.5.0
xtensa                randconfig-1001-20260923    gcc-11.5.0
xtensa               randconfig-r1302-20260923    gcc-14.3.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
