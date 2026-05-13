Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A3439281B
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778697436; cv=none; b=FZGPWGdcxHQ2ihTKNSdkI4E5Hv111osmg3ELwiIBxwWuOa+eaEb0KPumJydBYobbOEEaDucryASnpjVPpJTLE+diuffbbKeihGMoP3ZtpElR67g8j1gfJxa9f6ZfbKwO5Z5Myjphf/jxVdmLsPJ/9FCIuvIvyg2qRelvMF0tpPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778697436; c=relaxed/simple;
	bh=KkwjqngUn3yyqONCywdbNwk2+HEXMQ0bcSipeqW1zwo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=PEMeRhqnvrhH8zAp3lLn1DQUvOlRMR8xhWvikd5ha+q6PbZFxfLXZQAripqBNxMZrU3trcZEwk3x7IfW5xVJZlmrWPDtMzdNLMZElQVdXcdggmuH6xksl5tk6W4W9pR8aWja0jp1t74nyrCZLR7ly3UCBLtWvJ/nPuVhuXaNqdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVr6omwg; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVr6omwg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778697435; x=1810233435;
  h=date:from:to:cc:subject:message-id;
  bh=KkwjqngUn3yyqONCywdbNwk2+HEXMQ0bcSipeqW1zwo=;
  b=JVr6omwglGqzt22kqtn+FJ7mWhZ1pH3ewyHg9y4OCzOyh1GgYn8jHmA8
   J92x1cF9CXcmq4W9iuXXdf+nMBgFsavNHW6zO0RKB7leOcDcGTPjy7Cfs
   Tf8mULtOnlMbkqpcJi8MC/06IWQAp7z3mSN1GUGFzuicnSXq12qEzovW9
   j+pKPSI7f47sDalGVGKQabD7BtF6On+ha7v4rOXwxWPuVkc9uoCE9CXB7
   a7C161/1Rn0ezq2emaoh/Sg/ahOn7mLxSusw8VAKoP83cWvnP+CDbZVG3
   9b80PWZK/QphD1zJvMZi7804PRivghleo3bs42Jax3qNkr4XnHwtj6LXA
   g==;
X-CSE-ConnectionGUID: jkvSr2EDRdui09eR84/XEw==
X-CSE-MsgGUID: 1s2meIg2SI6ruEnfFSx93w==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83505939"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="83505939"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 11:37:15 -0700
X-CSE-ConnectionGUID: W1SEZYX2QYeOt/9W8BieVw==
X-CSE-MsgGUID: h03F4QpSTpOkcqMFH33MJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="243128340"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 13 May 2026 11:37:13 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNESE-000000004rb-2HYF;
	Wed, 13 May 2026 18:37:10 +0000
Date: Thu, 14 May 2026 02:36:53 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 2c3f468717231305523ddcd94d91c0d5e4a72419
Message-ID: <202605140240.m60BM8lM-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2c3f468717231305523ddcd94d91c0d5e4a72419  mm/hugetlb_cma: restrict hugetlb_cma parameter to gigantic-page alignment

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605092036.9mdDJbEZ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com

    mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001-20260513
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- arm-randconfig-003-20260513
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- csky-randconfig-r073-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- i386-randconfig-141
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- i386-randconfig-141-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- m68k-randconfig-r071-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- parisc-randconfig-r072-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- sh-allmodconfig
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- sh-allnoconfig
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- sh-allyesconfig
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- sh-randconfig-001-20260513
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
`-- sh-randconfig-r062-20260513
    `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used

elapsed time: 748m

configs tested: 276
configs skipped: 17

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
arc                   randconfig-001-20260513    gcc-14.3.0
arc                   randconfig-001-20260513    gcc-8.5.0
arc                   randconfig-002-20260513    gcc-14.3.0
arc                   randconfig-002-20260513    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                          ixp4xx_defconfig    gcc-15.2.0
arm                   randconfig-001-20260513    gcc-14.3.0
arm                   randconfig-001-20260513    gcc-8.5.0
arm                   randconfig-002-20260513    gcc-14.3.0
arm                   randconfig-003-20260513    gcc-13.4.0
arm                   randconfig-003-20260513    gcc-14.3.0
arm                   randconfig-004-20260513    clang-23
arm                   randconfig-004-20260513    gcc-14.3.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    clang-23
arm64                 randconfig-001-20260513    clang-23
arm64                 randconfig-001-20260513    gcc-12.5.0
arm64                          randconfig-002    clang-23
arm64                 randconfig-002-20260513    clang-23
arm64                 randconfig-002-20260513    gcc-12.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260513    clang-23
arm64                 randconfig-003-20260513    gcc-12.5.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260513    clang-17
arm64                 randconfig-004-20260513    clang-23
arm64                 randconfig-004-20260513    gcc-12.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    clang-23
csky                  randconfig-001-20260513    clang-23
csky                  randconfig-001-20260513    gcc-12.5.0
csky                  randconfig-001-20260513    gcc-13.4.0
csky                           randconfig-002    clang-23
csky                  randconfig-002-20260513    clang-23
csky                  randconfig-002-20260513    gcc-10.5.0
csky                  randconfig-002-20260513    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260513    clang-23
hexagon               randconfig-001-20260513    gcc-11.5.0
hexagon               randconfig-001-20260513    gcc-8.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260513    clang-23
hexagon               randconfig-002-20260513    gcc-11.5.0
hexagon               randconfig-002-20260513    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260513    clang-20
i386        buildonly-randconfig-002-20260513    clang-20
i386        buildonly-randconfig-002-20260513    gcc-14
i386        buildonly-randconfig-003-20260513    clang-20
i386        buildonly-randconfig-004-20260513    clang-20
i386        buildonly-randconfig-005-20260513    clang-20
i386        buildonly-randconfig-006-20260513    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260513    clang-20
i386                  randconfig-001-20260513    gcc-14
i386                  randconfig-002-20260513    clang-20
i386                  randconfig-003-20260513    clang-20
i386                  randconfig-003-20260513    gcc-14
i386                  randconfig-004-20260513    clang-20
i386                  randconfig-004-20260513    gcc-14
i386                  randconfig-005-20260513    clang-20
i386                  randconfig-005-20260513    gcc-12
i386                  randconfig-006-20260513    clang-20
i386                  randconfig-006-20260513    gcc-14
i386                  randconfig-007-20260513    clang-20
i386                  randconfig-011-20260513    clang-20
i386                  randconfig-012-20260513    clang-20
i386                  randconfig-012-20260513    gcc-14
i386                  randconfig-013-20260513    clang-20
i386                  randconfig-014-20260513    clang-20
i386                  randconfig-015-20260513    clang-20
i386                  randconfig-016-20260513    clang-20
i386                  randconfig-017-20260513    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260513    clang-19
loongarch             randconfig-001-20260513    gcc-11.5.0
loongarch             randconfig-001-20260513    gcc-8.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260513    clang-23
loongarch             randconfig-002-20260513    gcc-11.5.0
loongarch             randconfig-002-20260513    gcc-8.5.0
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
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260513    gcc-11.5.0
nios2                 randconfig-001-20260513    gcc-8.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260513    gcc-11.5.0
nios2                 randconfig-002-20260513    gcc-8.5.0
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
parisc                randconfig-001-20260513    gcc-8.5.0
parisc                randconfig-002-20260513    gcc-8.5.0
parisc                randconfig-002-20260513    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260513    gcc-8.5.0
powerpc               randconfig-002-20260513    gcc-8.5.0
powerpc64             randconfig-001-20260513    gcc-8.5.0
powerpc64             randconfig-002-20260513    clang-23
powerpc64             randconfig-002-20260513    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260513    clang-17
riscv                 randconfig-001-20260513    gcc-15.2.0
riscv                 randconfig-002-20260513    clang-23
riscv                 randconfig-002-20260513    gcc-15.2.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260513    clang-23
s390                  randconfig-001-20260513    gcc-15.2.0
s390                  randconfig-002-20260513    gcc-12.5.0
s390                  randconfig-002-20260513    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                 kfr2r09-romimage_defconfig    gcc-15.2.0
sh                    randconfig-001-20260513    gcc-15.2.0
sh                    randconfig-002-20260513    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260513    gcc-11.5.0
sparc                 randconfig-002-20260513    gcc-11.5.0
sparc                 randconfig-002-20260513    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260513    gcc-11.5.0
sparc64               randconfig-001-20260513    gcc-8.5.0
sparc64               randconfig-002-20260513    gcc-11.5.0
sparc64               randconfig-002-20260513    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260513    gcc-11.5.0
um                    randconfig-001-20260513    gcc-14
um                    randconfig-002-20260513    clang-23
um                    randconfig-002-20260513    gcc-11.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260513    gcc-12
x86_64      buildonly-randconfig-002-20260513    gcc-12
x86_64      buildonly-randconfig-003-20260513    gcc-12
x86_64      buildonly-randconfig-004-20260513    gcc-12
x86_64      buildonly-randconfig-005-20260513    gcc-12
x86_64      buildonly-randconfig-006-20260513    gcc-12
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260513    clang-20
x86_64                randconfig-001-20260513    gcc-13
x86_64                randconfig-002-20260513    clang-20
x86_64                randconfig-002-20260513    gcc-14
x86_64                randconfig-003-20260513    clang-20
x86_64                randconfig-004-20260513    clang-20
x86_64                randconfig-005-20260513    clang-20
x86_64                randconfig-006-20260513    clang-20
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260513    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260513    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260513    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260513    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260513    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260513    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260513    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260513    gcc-12
x86_64                randconfig-072-20260513    gcc-14
x86_64                         randconfig-073    gcc-14
x86_64                randconfig-073-20260513    gcc-12
x86_64                randconfig-073-20260513    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260513    gcc-14
x86_64                         randconfig-075    gcc-14
x86_64                randconfig-075-20260513    gcc-14
x86_64                         randconfig-076    gcc-14
x86_64                randconfig-076-20260513    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260513    gcc-11.5.0
xtensa                randconfig-001-20260513    gcc-8.5.0
xtensa                randconfig-002-20260513    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
