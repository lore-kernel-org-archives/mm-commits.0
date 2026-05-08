Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BC63C73DE
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251692; cv=none; b=IPqtUKEMHWkAfjv8EUXRgnTsYDGvKeM5RSLx4q3elvp3edDRw3Um3vwB6kaHKJGwmNQTWEpYuQ6wDsAgb3HAsv3IkKtKdXhNaALkWsH5OzWRfH8878Faxqe720rjIR+WbD1be4ZMK1fgV+jup2Kj8hyv3F01Zy5S8hUJLLFSi0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251692; c=relaxed/simple;
	bh=xvsq4CqWPWUSKU0LSjowARx9YXYro/oyt6Bu+ZsgeiM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=VhQDCuj6rrpG8p2UZlgmVQHF9LWwNrKg7pDA/L9LlGfe7M2rr5ybsKR0vvYghavO+gK1zHoO6FlXM/lWF/pBkoggPgCC0ebD5FAGhc1/M0L/Sk9bGQ6L89HOMyd3rX6FPGY7OXOJQlYxklvvFaK5DQOSdVghmkXFBrL0ndgM37s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zv112mup; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zv112mup"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778251691; x=1809787691;
  h=date:from:to:cc:subject:message-id;
  bh=xvsq4CqWPWUSKU0LSjowARx9YXYro/oyt6Bu+ZsgeiM=;
  b=Zv112mupKX1uuDEslvotBmm+j/pwKTzYKhhlNbtxRkTkH1PY157b2BJP
   fLee27hd/ukGaDsg7IK47k0AysW0BvzweUiwNhmYUwzTVhtWJOJf0vXQm
   ueDOQjrtxZsu55+Em5Vzngw9ckNYW5EwEhv5NBYSNMLg1J3VrO0/pq+Fg
   JjkzP4FWHv6NsnQXm761KoJ5XGhp6UK7WcR7xoiKROwRS/vfz/ZTxocx0
   j3OOl72C8Y9dWF5HUC5tBBLzQg0i75x2FgssneO2C/QXq2JL+nvnVaRmg
   arxFwKImbRxrIkkfQKC6VsB+9xSmykuod4uHyXvDJHyl0VEo4oWwkVD44
   w==;
X-CSE-ConnectionGUID: r6Gg8XiFSoO4vRHdNwC97A==
X-CSE-MsgGUID: VLM69J6oQj6qYwQbzblCDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="89809975"
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="89809975"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 07:48:11 -0700
X-CSE-ConnectionGUID: 3vRLHHLLQMWcLwOG0Gzjfg==
X-CSE-MsgGUID: lVAyJOMrRxOgWKvAUT8vFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="237027082"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 08 May 2026 07:48:09 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLMUo-000000000DB-0FqK;
	Fri, 08 May 2026 14:48:06 +0000
Date: Fri, 08 May 2026 22:47:24 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 830829a264f444b59a708d94915242e961bccc97
Message-ID: <202605082218.34ZE5Ouq-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 830829a264f444b59a708d94915242e961bccc97  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

elapsed time: 800m

configs tested: 267
configs skipped: 14

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                     haps_hs_smp_defconfig    gcc-15.2.0
arc                 nsimosci_hs_smp_defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260508    gcc-12.5.0
arc                   randconfig-001-20260508    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260508    gcc-12.5.0
arc                   randconfig-002-20260508    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                           h3600_defconfig    gcc-15.2.0
arm                        neponset_defconfig    gcc-15.2.0
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260508    gcc-12.5.0
arm                   randconfig-001-20260508    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260508    gcc-12.5.0
arm                   randconfig-002-20260508    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260508    gcc-12.5.0
arm                   randconfig-003-20260508    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260508    gcc-12.5.0
arm                   randconfig-004-20260508    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260508    gcc-14.3.0
arm64                 randconfig-002-20260508    gcc-14.3.0
arm64                 randconfig-003-20260508    gcc-14.3.0
arm64                 randconfig-004-20260508    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260508    gcc-14.3.0
csky                  randconfig-002-20260508    gcc-14.3.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260508    clang-23
hexagon               randconfig-002-20260508    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260508    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260508    clang-20
i386        buildonly-randconfig-002-20260508    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260508    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260508    clang-20
i386        buildonly-randconfig-004-20260508    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260508    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260508    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260508    gcc-14
i386                  randconfig-002-20260508    gcc-14
i386                  randconfig-003-20260508    gcc-14
i386                  randconfig-004-20260508    gcc-14
i386                  randconfig-005-20260508    gcc-14
i386                  randconfig-006-20260508    gcc-14
i386                  randconfig-007-20260508    gcc-14
i386                  randconfig-011-20260508    clang-20
i386                  randconfig-011-20260508    gcc-13
i386                  randconfig-012-20260508    gcc-13
i386                  randconfig-013-20260508    clang-20
i386                  randconfig-013-20260508    gcc-13
i386                  randconfig-014-20260508    gcc-13
i386                  randconfig-014-20260508    gcc-14
i386                  randconfig-015-20260508    clang-20
i386                  randconfig-015-20260508    gcc-13
i386                  randconfig-016-20260508    clang-20
i386                  randconfig-016-20260508    gcc-13
i386                  randconfig-017-20260508    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260508    clang-23
loongarch             randconfig-002-20260508    clang-23
loongarch             randconfig-002-20260508    gcc-12.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                      loongson3_defconfig    gcc-15.2.0
mips                        omega2p_defconfig    clang-23
mips                         rt305x_defconfig    clang-23
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260508    clang-23
nios2                 randconfig-001-20260508    gcc-11.5.0
nios2                 randconfig-002-20260508    clang-23
nios2                 randconfig-002-20260508    gcc-11.5.0
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
parisc                randconfig-001-20260508    gcc-9.5.0
parisc                randconfig-002-20260508    gcc-9.5.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                       holly_defconfig    clang-23
powerpc               randconfig-001-20260508    gcc-9.5.0
powerpc               randconfig-002-20260508    gcc-9.5.0
powerpc                     tqm8555_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260508    gcc-9.5.0
powerpc64             randconfig-002-20260508    gcc-9.5.0
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260508    clang-23
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260508    clang-23
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260508    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260508    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          polaris_defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-15.2.0
sh                    randconfig-001-20260508    clang-23
sh                    randconfig-001-20260508    gcc-15.2.0
sh                             randconfig-002    gcc-14.3.0
sh                    randconfig-002-20260508    clang-23
sh                    randconfig-002-20260508    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260508    gcc-12
sparc                 randconfig-001-20260508    gcc-12.5.0
sparc                 randconfig-002-20260508    gcc-12
sparc                 randconfig-002-20260508    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260508    gcc-12
sparc64               randconfig-001-20260508    gcc-8.5.0
sparc64               randconfig-002-20260508    clang-23
sparc64               randconfig-002-20260508    gcc-12
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260508    gcc-12
um                    randconfig-002-20260508    clang-23
um                    randconfig-002-20260508    gcc-12
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260508    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260508    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260508    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260508    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260508    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260508    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260508    clang-20
x86_64                randconfig-001-20260508    gcc-14
x86_64                randconfig-002-20260508    clang-20
x86_64                randconfig-003-20260508    clang-20
x86_64                randconfig-004-20260508    clang-20
x86_64                randconfig-004-20260508    gcc-14
x86_64                randconfig-005-20260508    clang-20
x86_64                randconfig-006-20260508    clang-20
x86_64                randconfig-006-20260508    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260508    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260508    clang-20
x86_64                randconfig-012-20260508    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260508    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260508    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260508    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260508    gcc-14
x86_64                randconfig-071-20260508    gcc-14
x86_64                randconfig-072-20260508    gcc-14
x86_64                randconfig-073-20260508    gcc-14
x86_64                randconfig-074-20260508    gcc-14
x86_64                randconfig-075-20260508    gcc-14
x86_64                randconfig-076-20260508    gcc-14
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
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260508    gcc-12
xtensa                randconfig-001-20260508    gcc-14.3.0
xtensa                randconfig-002-20260508    gcc-12
xtensa                randconfig-002-20260508    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
