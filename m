Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CAB3002A9
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778613302; cv=none; b=D24BKkaGgDkBf+9qJk2Pn8unU/hu6lSpgjtvZHfIBbu+0W/t2Hw2O8ZZBwEvOCdXdw21fRHKLZzEYoiK4pkys9vbOJsavdUnJjeh8EhOhOn8teTLaba76D9i8gMLxyfzf4E+HD8/4r3fXSDcZH1d/lDGXDZvGQUQWuCyc5G42wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778613302; c=relaxed/simple;
	bh=fLnUj5Oo3ItdvS2tfhxisVTi7vQLwdA+UbD22bUQWds=;
	h=Date:From:To:Cc:Subject:Message-ID; b=C+VBwRr1LbXkhwA//Pe1174F6t5lZDzQxfNF94bioFv0BQQdW1Hrd84Dn4EMeJGMQKGYFH5yu13c2QIr3Pgi7cXmDKeh0mLv55VoNeUTNsY6D2FhO4sfVhLzxgVlm9GUXHCL+CLBhH6wGE/NLXbBfew/8ZP99bKbXFEpjAl2JOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W/K0mx7p; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W/K0mx7p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778613301; x=1810149301;
  h=date:from:to:cc:subject:message-id;
  bh=fLnUj5Oo3ItdvS2tfhxisVTi7vQLwdA+UbD22bUQWds=;
  b=W/K0mx7p0HxCCkHq6wasjosC47JF47G+THm4dlb3VYw0vp4sQtzuvQN2
   iQvnRHVXP8ipJ9QYlmKKjR24/VgXZAgdjKECxVrQb04lAcufIFbXb53rI
   hVaXDgJUbKGXTBYgHmJBDAHAjksB+XDhuAMTSiqTAFjnHrZRZk1Tal+ZZ
   f3qLxQmjc+OUtUtK3m0q7nHozvz6OrpDGapmvmXmD4eRWm9F7d3GGtN4L
   IofrgWnjp9xVCBABMJJKoZ5aNOBS30YqvNtYytwE6oYu3ipckujlyKUrv
   vBGCwtybQDGQUToVpNhDuCuLiCKaDNzv5VHhAo81YnBdpRs/HXnBwdDqN
   w==;
X-CSE-ConnectionGUID: dvI5re78RYWBefnmA1fXWw==
X-CSE-MsgGUID: sZVb741dRgq8JZJAhKUaiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83405987"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="83405987"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:15:00 -0700
X-CSE-ConnectionGUID: 6sSl0Z4MQvaxRI+IVRICVw==
X-CSE-MsgGUID: yVmodjmWSR2wah+z9RdtMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="242828219"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 12 May 2026 12:14:58 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wMsZE-000000002fX-1Jhq;
	Tue, 12 May 2026 19:14:56 +0000
Date: Wed, 13 May 2026 03:14:36 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 30424114b17dd65c098749cedcaef301c1dd2f86
Message-ID: <202605130326.W8qdYEvy-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 30424114b17dd65c098749cedcaef301c1dd2f86  mm/memory_hotplug: factor out altmap freeing checks

elapsed time: 760m

configs tested: 337
configs skipped: 15

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                         haps_hs_defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260512    gcc-11.5.0
arc                   randconfig-001-20260512    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260512    gcc-11.5.0
arc                   randconfig-002-20260512    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                      footbridge_defconfig    clang-17
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260512    clang-23
arm                   randconfig-001-20260512    gcc-11.5.0
arm                   randconfig-001-20260512    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260512    gcc-11.5.0
arm                   randconfig-002-20260512    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260512    clang-23
arm                   randconfig-003-20260512    gcc-11.5.0
arm                   randconfig-003-20260512    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260512    gcc-11.5.0
arm                   randconfig-004-20260512    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    clang-23
arm64                 randconfig-001-20260512    clang-23
arm64                 randconfig-001-20260512    gcc-12.5.0
arm64                 randconfig-001-20260512    gcc-14.3.0
arm64                          randconfig-002    clang-23
arm64                 randconfig-002-20260512    clang-23
arm64                 randconfig-002-20260512    gcc-14.3.0
arm64                 randconfig-002-20260512    gcc-8.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260512    clang-23
arm64                 randconfig-003-20260512    gcc-14.3.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260512    clang-23
arm64                 randconfig-004-20260512    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    clang-23
csky                  randconfig-001-20260512    clang-23
csky                  randconfig-001-20260512    gcc-11.5.0
csky                  randconfig-001-20260512    gcc-14.3.0
csky                           randconfig-002    clang-23
csky                  randconfig-002-20260512    clang-23
csky                  randconfig-002-20260512    gcc-12.5.0
csky                  randconfig-002-20260512    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260512    clang-23
hexagon               randconfig-001-20260512    gcc-10.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260512    clang-23
hexagon               randconfig-002-20260512    gcc-10.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260512    gcc-14
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260512    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260512    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260512    clang-20
i386        buildonly-randconfig-004-20260512    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260512    clang-20
i386        buildonly-randconfig-005-20260512    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260512    clang-20
i386        buildonly-randconfig-006-20260512    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260512    clang-20
i386                  randconfig-001-20260512    gcc-14
i386                  randconfig-002-20260512    gcc-14
i386                  randconfig-003-20260512    gcc-13
i386                  randconfig-003-20260512    gcc-14
i386                  randconfig-004-20260512    clang-20
i386                  randconfig-004-20260512    gcc-14
i386                  randconfig-005-20260512    clang-20
i386                  randconfig-005-20260512    gcc-14
i386                  randconfig-006-20260512    clang-20
i386                  randconfig-006-20260512    gcc-14
i386                  randconfig-007-20260512    clang-20
i386                  randconfig-007-20260512    gcc-14
i386                           randconfig-011    clang-20
i386                  randconfig-011-20260512    clang-20
i386                  randconfig-011-20260512    gcc-14
i386                           randconfig-012    clang-20
i386                  randconfig-012-20260512    clang-20
i386                           randconfig-013    clang-20
i386                  randconfig-013-20260512    clang-20
i386                           randconfig-014    clang-20
i386                  randconfig-014-20260512    clang-20
i386                           randconfig-015    clang-20
i386                  randconfig-015-20260512    clang-20
i386                  randconfig-015-20260512    gcc-14
i386                           randconfig-016    clang-20
i386                  randconfig-016-20260512    clang-20
i386                  randconfig-016-20260512    gcc-14
i386                           randconfig-017    clang-20
i386                  randconfig-017-20260512    clang-20
i386                  randconfig-017-20260512    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260512    clang-18
loongarch             randconfig-001-20260512    gcc-10.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260512    gcc-10.5.0
loongarch             randconfig-002-20260512    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                     cu1000-neo_defconfig    gcc-15.2.0
mips                   sb1250_swarm_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260512    gcc-10.5.0
nios2                 randconfig-001-20260512    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260512    gcc-10.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260512    gcc-11.5.0
parisc                randconfig-001-20260512    gcc-12.5.0
parisc                randconfig-001-20260513    gcc-8.5.0
parisc                randconfig-002-20260512    gcc-12.5.0
parisc                randconfig-002-20260512    gcc-9.5.0
parisc                randconfig-002-20260513    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260512    clang-23
powerpc               randconfig-001-20260512    gcc-12.5.0
powerpc               randconfig-001-20260513    gcc-8.5.0
powerpc               randconfig-002-20260512    gcc-12.5.0
powerpc               randconfig-002-20260513    gcc-8.5.0
powerpc64             randconfig-001-20260512    gcc-12.5.0
powerpc64             randconfig-001-20260513    gcc-8.5.0
powerpc64             randconfig-002-20260512    gcc-12.5.0
powerpc64             randconfig-002-20260513    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260512    gcc-15.2.0
riscv                 randconfig-001-20260512    gcc-9.5.0
riscv                 randconfig-001-20260513    gcc-15.2.0
riscv                 randconfig-002-20260512    gcc-15.2.0
riscv                 randconfig-002-20260512    gcc-8.5.0
riscv                 randconfig-002-20260513    gcc-15.2.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260512    clang-18
s390                  randconfig-001-20260512    gcc-15.2.0
s390                  randconfig-001-20260513    gcc-15.2.0
s390                  randconfig-002-20260512    clang-23
s390                  randconfig-002-20260512    gcc-15.2.0
s390                  randconfig-002-20260513    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260512    gcc-15.2.0
sh                    randconfig-001-20260513    gcc-15.2.0
sh                    randconfig-002-20260512    gcc-15.2.0
sh                    randconfig-002-20260513    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                          randconfig-001    gcc-13.4.0
sparc                 randconfig-001-20260512    gcc-13.4.0
sparc                          randconfig-002    gcc-13.4.0
sparc                 randconfig-002-20260512    gcc-12.5.0
sparc                 randconfig-002-20260512    gcc-13.4.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-13.4.0
sparc64               randconfig-001-20260512    gcc-13.4.0
sparc64               randconfig-001-20260512    gcc-14.3.0
sparc64                        randconfig-002    gcc-13.4.0
sparc64               randconfig-002-20260512    gcc-13.4.0
sparc64               randconfig-002-20260512    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-13.4.0
um                    randconfig-001-20260512    gcc-13.4.0
um                    randconfig-001-20260512    gcc-14
um                             randconfig-002    gcc-13.4.0
um                    randconfig-002-20260512    clang-23
um                    randconfig-002-20260512    gcc-13.4.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260512    gcc-14
x86_64      buildonly-randconfig-002-20260512    clang-20
x86_64      buildonly-randconfig-002-20260512    gcc-14
x86_64      buildonly-randconfig-003-20260512    gcc-14
x86_64      buildonly-randconfig-004-20260512    clang-20
x86_64      buildonly-randconfig-004-20260512    gcc-14
x86_64      buildonly-randconfig-005-20260512    gcc-14
x86_64      buildonly-randconfig-006-20260512    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260512    clang-20
x86_64                randconfig-001-20260512    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260512    gcc-14
x86_64                         randconfig-003    gcc-14
x86_64                randconfig-003-20260512    gcc-14
x86_64                         randconfig-004    gcc-14
x86_64                randconfig-004-20260512    gcc-12
x86_64                randconfig-004-20260512    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260512    gcc-14
x86_64                         randconfig-006    gcc-14
x86_64                randconfig-006-20260512    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260512    clang-20
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260512    clang-20
x86_64                         randconfig-013    clang-20
x86_64                randconfig-013-20260512    clang-20
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260512    clang-20
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260512    clang-20
x86_64                randconfig-015-20260512    gcc-14
x86_64                         randconfig-016    clang-20
x86_64                randconfig-016-20260512    clang-20
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260512    clang-20
x86_64                randconfig-071-20260512    gcc-13
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260512    clang-20
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260512    clang-20
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260512    clang-20
x86_64                randconfig-074-20260512    gcc-14
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260512    clang-20
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260512    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                         randconfig-001    gcc-13.4.0
xtensa                randconfig-001-20260512    gcc-13.4.0
xtensa                randconfig-001-20260512    gcc-8.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260512    gcc-13.4.0
xtensa                randconfig-002-20260512    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
