Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E7213C9C4
	for <mm-commits@vger.kernel.org>; Sun,  3 May 2026 13:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777814275; cv=none; b=lMF1tnUGFB6LQpmeU2l/Glh9ToInor1jOaKaWSqoWhm6dao5E2iG/72i5bR54mhiLc8mZjFS4ms+8dTrBC1TlT14oMHO7R4EiUdzVZphbkzaMtFIWYRNjmZ0ekYNc9gRIGs0PGSxi49RwRqj4o5uMikLMQ9viO8Bf4ShRVCFlIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777814275; c=relaxed/simple;
	bh=FA/oICrk0l5fnF0DtAR3Yl0cIYuEj/8I0FIfSSW8rQE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=HC/oHs2msO3bXgGfDK+WxvcXkXHuNCz2Zr4a9C6Clc5h5SQbd5kp8U8VAJuiJa5BXXihO+0zUCX8tRcgHjOGoIEniyUT+WeTUGybALSaAquDv0G+vYqL8s6ge4hl98yff9iqpfqPIqdxTAQf5QCipub6tHlbDkOdnaRh44HYlsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CJ8R8PuF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CJ8R8PuF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777814273; x=1809350273;
  h=date:from:to:cc:subject:message-id;
  bh=FA/oICrk0l5fnF0DtAR3Yl0cIYuEj/8I0FIfSSW8rQE=;
  b=CJ8R8PuFgIJshQnPLGhyNQ4OdLJBZz2TP+e5I5vvlMHr0vQom9S0rmTw
   JwmdYQpWIONSiD9yOle3xD7J3L4vc8MA0xPKsLc0MWXLhZFmxCZ1WsCGI
   yWyMKckcbY1Sce+YFhCodJ8tLjOC235J2wGoqm9zG3UteOkXMHv9Ge8g8
   am/9Q2ltZhLwqXZ5nIkIXlrNNxyBlI5h4A6f9YwcOj9Rk4IU0WlbTHsUv
   HQ9Xs7jkAFsgDc1yx/lvwjF5BhMQLfRn83Ut28HqhNyOkXgWCFp9gfOzp
   DcxA9wiA/FdYED9EbMmEX62BXma7kHXJjsZLfsvewRl1/6sScOv5fToJU
   w==;
X-CSE-ConnectionGUID: CaSbPjbhQJauGCAC2cyXkQ==
X-CSE-MsgGUID: Q+4UxiiCT+OcXemm6L8vKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11775"; a="77719880"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="77719880"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 06:17:53 -0700
X-CSE-ConnectionGUID: J5UNBXW7Q1CU/N2pKIL6jQ==
X-CSE-MsgGUID: qjQAudKMQCGZGr5omLlNJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="258644667"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 03 May 2026 06:17:51 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJWhf-000000002Zl-2hfL;
	Sun, 03 May 2026 13:17:47 +0000
Date: Sun, 03 May 2026 21:17:01 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 312ca1abefe5eac64bce040076802808d3c80cac
Message-ID: <202605032138.oeUyFcz9-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 312ca1abefe5eac64bce040076802808d3c80cac  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 744m

configs tested: 262
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              alldefconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260503    gcc-15.2.0
arc                   randconfig-001-20260503    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260503    gcc-10.5.0
arc                   randconfig-002-20260503    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260503    gcc-12.5.0
arm                   randconfig-001-20260503    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260503    clang-23
arm                   randconfig-003-20260503    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260503    clang-23
arm                   randconfig-004-20260503    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    gcc-15.2.0
arm64                 randconfig-001-20260503    gcc-15.2.0
arm64                 randconfig-001-20260503    gcc-8.5.0
arm64                          randconfig-002    gcc-15.2.0
arm64                 randconfig-002-20260503    gcc-15.2.0
arm64                 randconfig-002-20260503    gcc-8.5.0
arm64                          randconfig-003    gcc-15.2.0
arm64                 randconfig-003-20260503    clang-17
arm64                 randconfig-003-20260503    gcc-15.2.0
arm64                          randconfig-004    gcc-15.2.0
arm64                 randconfig-004-20260503    clang-23
arm64                 randconfig-004-20260503    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    gcc-15.2.0
csky                  randconfig-001-20260503    gcc-15.2.0
csky                           randconfig-002    gcc-15.2.0
csky                  randconfig-002-20260503    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260503    clang-17
hexagon               randconfig-001-20260503    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260503    clang-23
hexagon               randconfig-002-20260503    gcc-11.5.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260503    clang-20
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260503    clang-20
i386        buildonly-randconfig-002-20260503    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260503    clang-20
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260503    clang-20
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260503    clang-20
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260503    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260503    clang-20
i386                  randconfig-002-20260503    clang-20
i386                  randconfig-002-20260503    gcc-14
i386                  randconfig-003-20260503    clang-20
i386                  randconfig-003-20260503    gcc-14
i386                  randconfig-004-20260503    clang-20
i386                  randconfig-005-20260503    clang-20
i386                  randconfig-005-20260503    gcc-14
i386                  randconfig-006-20260503    clang-20
i386                  randconfig-007-20260503    clang-20
i386                  randconfig-011-20260503    clang-20
i386                  randconfig-012-20260503    clang-20
i386                  randconfig-013-20260503    clang-20
i386                  randconfig-014-20260503    clang-20
i386                  randconfig-015-20260503    gcc-14
i386                  randconfig-016-20260503    gcc-14
i386                  randconfig-017-20260503    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260503    gcc-11.5.0
loongarch             randconfig-001-20260503    gcc-15.2.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260503    clang-20
loongarch             randconfig-002-20260503    gcc-11.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
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
mips                          malta_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260503    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260503    gcc-11.5.0
nios2                 randconfig-002-20260503    gcc-8.5.0
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
parisc                randconfig-001-20260503    gcc-15.2.0
parisc                randconfig-002-20260503    gcc-15.2.0
parisc                randconfig-002-20260503    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260503    clang-23
powerpc               randconfig-001-20260503    gcc-15.2.0
powerpc               randconfig-002-20260503    gcc-14.3.0
powerpc               randconfig-002-20260503    gcc-15.2.0
powerpc64             randconfig-001-20260503    gcc-15.2.0
powerpc64             randconfig-001-20260503    gcc-8.5.0
powerpc64             randconfig-002-20260503    gcc-10.5.0
powerpc64             randconfig-002-20260503    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260503    clang-23
riscv                 randconfig-002-20260503    clang-23
riscv                 randconfig-002-20260503    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260503    clang-23
s390                  randconfig-001-20260503    gcc-14.3.0
s390                  randconfig-002-20260503    clang-23
s390                  randconfig-002-20260503    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260503    clang-23
sh                    randconfig-001-20260503    gcc-13.4.0
sh                    randconfig-002-20260503    clang-23
sh                    randconfig-002-20260503    gcc-12.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260503    gcc-15.2.0
sparc                 randconfig-001-20260503    gcc-8.5.0
sparc                 randconfig-002-20260503    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260503    gcc-11.5.0
sparc64               randconfig-001-20260503    gcc-15.2.0
sparc64               randconfig-002-20260503    gcc-15.2.0
sparc64               randconfig-002-20260503    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260503    clang-17
um                    randconfig-001-20260503    gcc-15.2.0
um                    randconfig-002-20260503    clang-23
um                    randconfig-002-20260503    gcc-15.2.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260503    clang-20
x86_64      buildonly-randconfig-002-20260503    clang-20
x86_64      buildonly-randconfig-002-20260503    gcc-14
x86_64      buildonly-randconfig-003-20260503    clang-20
x86_64      buildonly-randconfig-003-20260503    gcc-14
x86_64      buildonly-randconfig-004-20260503    clang-20
x86_64      buildonly-randconfig-005-20260503    clang-20
x86_64      buildonly-randconfig-005-20260503    gcc-14
x86_64      buildonly-randconfig-006-20260503    clang-20
x86_64      buildonly-randconfig-006-20260503    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260503    gcc-14
x86_64                randconfig-002-20260503    gcc-14
x86_64                randconfig-003-20260503    clang-20
x86_64                randconfig-004-20260503    gcc-14
x86_64                randconfig-005-20260503    gcc-14
x86_64                randconfig-006-20260503    gcc-14
x86_64                randconfig-011-20260503    clang-20
x86_64                randconfig-012-20260503    clang-20
x86_64                randconfig-013-20260503    clang-20
x86_64                randconfig-014-20260503    clang-20
x86_64                randconfig-015-20260503    clang-20
x86_64                randconfig-015-20260503    gcc-14
x86_64                randconfig-016-20260503    clang-20
x86_64                randconfig-016-20260503    gcc-14
x86_64                randconfig-071-20260503    clang-20
x86_64                randconfig-072-20260503    clang-20
x86_64                randconfig-073-20260503    clang-20
x86_64                randconfig-074-20260503    clang-20
x86_64                randconfig-075-20260503    clang-20
x86_64                randconfig-076-20260503    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260503    gcc-11.5.0
xtensa                randconfig-001-20260503    gcc-15.2.0
xtensa                randconfig-002-20260503    gcc-13.4.0
xtensa                randconfig-002-20260503    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
