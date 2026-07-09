Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF46A4DBD93
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621209; cv=none; b=SRs9KxL2meL6PQI/udav3/dIs2OMco8/CJl9oZYG4b+KJCUBx/lT4fQiMjeCqJpq+0YxGZt0XXN9a5tsS84ht+16lS9ZZZYV7rK6vUcZDvpJO3rLiTfDVnmAdP5AzTRbzQnCDwaX5TYnqyZOZdcsTubFGSCOjlhZELpmQZKN5vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621209; c=relaxed/simple;
	bh=8gBhi1ORBX+A50QV36hb2+k5R5F4tpqt0htS/u1Moo4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=gHQbsswEvB4qqSlISF8ezSL6WhI69hj18nVcargoqd30dR0QyxKZmG+18KBipGF2tSxDENhbNuf2WuCXx1URQLhPKgiPmcDm0JGca0f0yA2PYQQvrtqukEl3hL9xx4swHdyK74t22aHtvDqZxgZa6YizYTUJ3dGdMATCbZhX6Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iVLf+1SM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iVLf+1SM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783621208; x=1815157208;
  h=date:from:to:cc:subject:message-id;
  bh=8gBhi1ORBX+A50QV36hb2+k5R5F4tpqt0htS/u1Moo4=;
  b=iVLf+1SMx5fUWFm4D6CW47uSUAxWeVFCDAxITAQXDQkmYF/1UDoBX+d9
   1Qq/YXylS0Ai+RxTacrQKyq+tFt2PRgpiTVe9WUYT9DyIMRKJIzNEcmb+
   J7x5hKfOaK7pBibIEi0sGLgE5wGD6ZagWVu30Fm62SS1fNHHzqyzlr8cQ
   U6AOzx+eqyGsmrXUvPZAK89jIctS0n1tbJ/n6XbcOzawW2eTdRMkDE4Et
   c0cT0EYVR+9eRxNAaBP9pB68Vrr4tbpaS7Pt56Aa58utc6FmdSw1BC3fW
   J71cCHcgTtieT+16jmzNTnPSn9s7e7y0pa1V1wHbtSecYHDc4bQy7X/e7
   g==;
X-CSE-ConnectionGUID: 0JJ5RGwtRHKqTRZN96/xVw==
X-CSE-MsgGUID: V4JBQCI1QnaHrrj76lV2NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="95689634"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="95689634"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:20:07 -0700
X-CSE-ConnectionGUID: 8WEgy/CRQYGRGSmXkz334Q==
X-CSE-MsgGUID: 8rIRdb24TR2OTaViBvXNdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="255307540"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 09 Jul 2026 11:20:05 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whtLt-00000000Hz5-3e7W;
	Thu, 09 Jul 2026 18:20:01 +0000
Date: Fri, 10 Jul 2026 02:19:35 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 59e34180e138a293260301c139cf7ee800978533
Message-ID: <202607100221.C2m3eOCN-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 59e34180e138a293260301c139cf7ee800978533  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp@intel.com

    mm/alloc_tag.c:356:58: error: implicit declaration of function 'compat_ptr' [-Wimplicit-function-declaration]
    mm/alloc_tag.c:472:58: error: implicit declaration of function 'compat_ptr' [-Wimplicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- sparc-randconfig-r063-20260709
|   `-- mm-alloc_tag.c:error:implicit-declaration-of-function-compat_ptr
`-- sparc64-randconfig-001-20260709
    `-- mm-alloc_tag.c:error:implicit-declaration-of-function-compat_ptr

elapsed time: 732m

configs tested: 312
configs skipped: 12

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260709    gcc-8.5.0
arc                   randconfig-002-20260709    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                         at91_dt_defconfig    clang-17
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260709    gcc-8.5.0
arm                   randconfig-002-20260709    gcc-8.5.0
arm                   randconfig-003-20260709    gcc-8.5.0
arm                   randconfig-004-20260709    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260709    clang-22
arm64                 randconfig-001-20260709    gcc-16.1.0
arm64                 randconfig-002-20260709    gcc-16.1.0
arm64                 randconfig-002-20260709    gcc-8.5.0
arm64                 randconfig-003-20260709    clang-22
arm64                 randconfig-003-20260709    gcc-16.1.0
arm64                 randconfig-004-20260709    gcc-16.1.0
arm64                 randconfig-004-20260709    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260709    gcc-14.3.0
csky                  randconfig-001-20260709    gcc-16.1.0
csky                  randconfig-002-20260709    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260709    clang-17
hexagon               randconfig-001-20260709    clang-18
hexagon               randconfig-002-20260709    clang-18
hexagon               randconfig-002-20260709    clang-23
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260709    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260709    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260709    gcc-13
i386        buildonly-randconfig-003-20260709    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260709    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260709    clang-22
i386        buildonly-randconfig-005-20260709    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260709    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260709    clang-22
i386                  randconfig-001-20260709    gcc-14
i386                  randconfig-002-20260709    gcc-14
i386                  randconfig-003-20260709    clang-22
i386                  randconfig-003-20260709    gcc-14
i386                  randconfig-004-20260709    clang-22
i386                  randconfig-004-20260709    gcc-14
i386                  randconfig-005-20260709    gcc-14
i386                  randconfig-006-20260709    gcc-14
i386                  randconfig-007-20260709    clang-22
i386                  randconfig-007-20260709    gcc-14
i386                  randconfig-011-20260709    clang-22
i386                  randconfig-011-20260709    gcc-14
i386                  randconfig-012-20260709    gcc-14
i386                  randconfig-013-20260709    clang-22
i386                  randconfig-013-20260709    gcc-14
i386                  randconfig-014-20260709    gcc-14
i386                  randconfig-015-20260709    clang-22
i386                  randconfig-015-20260709    gcc-14
i386                  randconfig-016-20260709    clang-22
i386                  randconfig-016-20260709    gcc-14
i386                  randconfig-017-20260709    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260709    clang-18
loongarch             randconfig-002-20260709    clang-18
loongarch             randconfig-002-20260709    clang-23
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                      m54418evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260709    clang-18
nios2                 randconfig-001-20260709    gcc-8.5.0
nios2                 randconfig-002-20260709    clang-18
nios2                 randconfig-002-20260709    gcc-8.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260709    clang-23
parisc                randconfig-001-20260709    gcc-9.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260709    clang-23
parisc                randconfig-002-20260709    gcc-8.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260709    clang-23
powerpc               randconfig-001-20260709    gcc-14.3.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260709    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260709    clang-19
powerpc64             randconfig-001-20260709    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260709    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-22
riscv                 randconfig-001-20260709    clang-22
riscv                 randconfig-001-20260709    clang-23
riscv                          randconfig-002    clang-22
riscv                 randconfig-002-20260709    clang-22
riscv                 randconfig-002-20260709    gcc-10.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-22
s390                  randconfig-001-20260709    clang-17
s390                  randconfig-001-20260709    clang-22
s390                           randconfig-002    clang-22
s390                  randconfig-002-20260709    clang-22
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-22
sh                    randconfig-001-20260709    clang-22
sh                    randconfig-001-20260709    gcc-16.1.0
sh                             randconfig-002    clang-22
sh                    randconfig-002-20260709    clang-22
sh                    randconfig-002-20260709    gcc-12.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260709    gcc-15.2.0
sparc                 randconfig-001-20260709    gcc-8.5.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260709    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260709    gcc-15.2.0
sparc64               randconfig-001-20260709    gcc-8.5.0
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260709    clang-23
sparc64               randconfig-002-20260709    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-23
um                    randconfig-001-20260709    gcc-14
um                    randconfig-001-20260709    gcc-8.5.0
um                             randconfig-002    clang-23
um                    randconfig-002-20260709    clang-23
um                    randconfig-002-20260709    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260709    clang-22
x86_64      buildonly-randconfig-001-20260709    gcc-13
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260709    clang-22
x86_64      buildonly-randconfig-002-20260709    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260709    clang-22
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260709    clang-22
x86_64      buildonly-randconfig-004-20260709    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260709    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260709    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260709    clang-22
x86_64                randconfig-001-20260709    gcc-14
x86_64                         randconfig-002    clang-22
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260709    clang-22
x86_64                randconfig-002-20260709    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260709    clang-22
x86_64                randconfig-003-20260709    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260709    clang-22
x86_64                randconfig-004-20260709    gcc-14
x86_64                         randconfig-005    clang-22
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260709    clang-22
x86_64                randconfig-005-20260709    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260709    clang-22
x86_64                randconfig-006-20260709    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260709    clang-22
x86_64                randconfig-011-20260709    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260709    clang-22
x86_64                randconfig-012-20260709    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260709    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260709    clang-22
x86_64                randconfig-014-20260709    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260709    gcc-13
x86_64                randconfig-015-20260709    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260709    clang-22
x86_64                randconfig-016-20260709    gcc-14
x86_64                randconfig-071-20260709    clang-22
x86_64                randconfig-071-20260709    gcc-14
x86_64                randconfig-072-20260709    clang-22
x86_64                randconfig-072-20260709    gcc-14
x86_64                randconfig-073-20260709    clang-22
x86_64                randconfig-073-20260709    gcc-13
x86_64                randconfig-074-20260709    clang-22
x86_64                randconfig-074-20260709    gcc-14
x86_64                randconfig-075-20260709    clang-22
x86_64                randconfig-076-20260709    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260709    gcc-8.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260709    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
