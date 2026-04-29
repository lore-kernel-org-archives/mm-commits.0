Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9194833F390
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777485318; cv=none; b=PaOI5fL7mGVgJxaQYkT7GJ/5JqNdNLwWOPH9PL7O9sjSavHKjrrFbzWjk+qPOSXW0H9QvQ8yAO/HH8HugWWl4DxH9q9QWdBOixX5iqrRHcJy/m5halG6eB2JAbqv8MPY6WcyMleBvmbRt6j3E9E4b77LffVbNJ6eUBughPORUkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777485318; c=relaxed/simple;
	bh=qES5wi9rHeFRKHA56944QIARsJl/dmyOMftYE0DrvjY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=R6CagoL+dXfX9VRKCp5FXdGO7f6JqK1zEQmqWX0iSQL3L5bePaYMtfXG1pBn/yrF9/rB5vl/UGJB2zLHPAnQzvrcdBa+v7WagGHK8QyhO/yUKcg65hRKFbP36iI44OGc5WkQkwOjnepz6hIXHksUSJGx3It0IRIy6IrngoYRjWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HB+oJsdW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HB+oJsdW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777485317; x=1809021317;
  h=date:from:to:cc:subject:message-id;
  bh=qES5wi9rHeFRKHA56944QIARsJl/dmyOMftYE0DrvjY=;
  b=HB+oJsdWwjrW2qzTm4asbcub57StaoyakGIvtZmuz69gYulUFBx7s9mO
   VWSh30IrPqOmQuCbbmnu1TRiV+sO9XWOwPrD/3utZXOiqEGGcRwIhhtIE
   6p43EhRCGu15bSMMlfgn97IkRG2LnrJw0Je3uaDzsNHseb+/4urRZ4nzC
   Eheeu5t0iz3IlpkZQMl3X+QcqjZi2j6LsF/rXSbZ3INxQCsYFTc8pBHzc
   8v3B3OR6A3VFqeyh+Ye9wIffrCANk+o112mM1gRaZZ7YjbGC9zw1OISxi
   DEP1XOl315eHFhhP4v+lWZv66sbi8pNvJGmfNEx7opxdYosGt7hQoI+cr
   Q==;
X-CSE-ConnectionGUID: l3QyZ3G7Rxmw0yO4g9DIIQ==
X-CSE-MsgGUID: h/FNPsSpS5K08KJAJLGjIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89884369"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89884369"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 10:55:16 -0700
X-CSE-ConnectionGUID: 3iiTamUzSy2ltJXGS6U1YA==
X-CSE-MsgGUID: IwKwGggbR9qySSnG1HQVkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="236106649"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 29 Apr 2026 10:55:14 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wI97w-00000000BKS-0GTU;
	Wed, 29 Apr 2026 17:55:12 +0000
Date: Thu, 30 Apr 2026 01:54:35 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 52dc268726a771d68839fb1e06e88b5157062a3f
Message-ID: <202604300126.K1nrQFEC-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 52dc268726a771d68839fb1e06e88b5157062a3f  flush dirty folio so that drop_caches can work

elapsed time: 1162m

configs tested: 93
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260430    gcc-8.5.0
arc                   randconfig-002-20260430    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386                  randconfig-011-20260430    clang-20
i386                  randconfig-012-20260430    gcc-14
i386                  randconfig-013-20260430    clang-20
i386                  randconfig-014-20260430    gcc-14
i386                  randconfig-015-20260430    gcc-14
i386                  randconfig-016-20260430    gcc-14
i386                  randconfig-017-20260430    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch             randconfig-001-20260430    gcc-14.3.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260430    gcc-12.5.0
parisc                randconfig-002-20260430    gcc-8.5.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                      pasemi_defconfig    clang-23
powerpc               randconfig-001-20260430    gcc-10.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-002-20260430    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260430    clang-23
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260430    clang-20
x86_64      buildonly-randconfig-002-20260430    clang-20
x86_64      buildonly-randconfig-003-20260430    clang-20
x86_64      buildonly-randconfig-004-20260430    clang-20
x86_64      buildonly-randconfig-005-20260430    gcc-14
x86_64      buildonly-randconfig-006-20260430    gcc-14
x86_64                              defconfig    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
