Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB38726CE11
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 02:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786329894; cv=none; b=tsKweYDo2Uaz1OqMHn7HoF73njycZEiqxeYd8U7y2/vpVohFUNrhd9CxmhBsYOuTUdbgBwzJ753pKgZCPumCuh46WgbccwcLRezI43YHFmdUVjdmmvOz2rp4RTfgioIWQqT10oJ8rPlZe7Vx5zBr/fAA3t9IjEkwouEJI1Yqnk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786329894; c=relaxed/simple;
	bh=dNibfJOjzfB6Rk3tx3l6uL60JnhSxzt2abciXXd1ork=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Vua7J9ZDY6E+/mqJeUPTvtBkkswrmG8fKpFIOLUS5y7emOTyoj845viZiODW7gHhqVyExlVfSu4SkOaVXWxAY8maglc+t5D7MTj0NOx+i7yDBHBztHBjyZiwZahXgFO223SeoWqyV3thq83ziszfd5mKI76k1ZP0Nv8GSgNXnf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YZnLvwY5; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YZnLvwY5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786329893; x=1817865893;
  h=date:from:to:cc:subject:message-id;
  bh=dNibfJOjzfB6Rk3tx3l6uL60JnhSxzt2abciXXd1ork=;
  b=YZnLvwY5QjdKNdwjZmDG7X7mjZuasnuQ7aOp6q+chtJVvqzBJTI2aC8e
   GLlhHhYjiKF5rkme9IXzPX1Da988d6jJ1kjJ/eJKOwMvtH3CML/HPJcdj
   TkMcU5a6j1CUekuf+000+xk++09bii+q4KSwlYggq2+hyU37NCfS6+jaD
   ryAYD+rcurMBf6GZH5RtQ3X3++XCzoVbUmCycQDUmr0tVq1WEWyLUOG6J
   MIDfS2QzNJ41chqQGULXgtX3z9JR5+5JZzMfD/lRqGWgQAfFDHbcQWYvr
   YpitcKzhoMx9sUOySrU48wbmm6/BMUotOiGmcKVhc13w4IyQsaxV+QQxn
   w==;
X-CSE-ConnectionGUID: rjZI4pvJSd+329JuqqimMA==
X-CSE-MsgGUID: /VwlvaAZSPSfEN2qX3W6LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="86846350"
X-IronPort-AV: E=Sophos;i="6.25,214,1779174000"; 
   d="scan'208";a="86846350"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2026 19:44:53 -0700
X-CSE-ConnectionGUID: KZgL7WBwQayZLcwLgxo0Rw==
X-CSE-MsgGUID: 0LS2jt1XRLSB2e1r64fUGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,214,1779174000"; 
   d="scan'208";a="259593503"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 09 Aug 2026 19:44:51 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wtG0O-00000000Mc6-1PYP;
	Mon, 10 Aug 2026 02:44:48 +0000
Date: Mon, 10 Aug 2026 10:44:13 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-ID: <202608101053.PhnVUM4u-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: e0ffd277b09a7c9f1a436e5f75be37ac490bc59f  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- s390-randconfig-r071-20260809
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 1506m

configs tested: 234
configs skipped: 0

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260809    gcc-10.5.0
arc                  randconfig-001-20260809    gcc-12.5.0
arc                  randconfig-001-20260810    gcc-8.5.0
arc                  randconfig-002-20260809    gcc-12.5.0
arc                  randconfig-002-20260810    gcc-8.5.0
arm                           hisi_defconfig    gcc-16.1.0
arm                  randconfig-001-20260809    gcc-12.5.0
arm                  randconfig-001-20260809    gcc-8.5.0
arm                  randconfig-001-20260810    gcc-8.5.0
arm                  randconfig-002-20260809    gcc-10.5.0
arm                  randconfig-002-20260809    gcc-12.5.0
arm                  randconfig-002-20260810    gcc-8.5.0
arm                  randconfig-003-20260809    clang-24
arm                  randconfig-003-20260809    gcc-12.5.0
arm                  randconfig-003-20260810    gcc-8.5.0
arm                  randconfig-004-20260809    clang-17
arm                  randconfig-004-20260809    gcc-12.5.0
arm                  randconfig-004-20260810    gcc-8.5.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260809    gcc-10.5.0
arm64                randconfig-001-20260809    gcc-14.3.0
arm64                randconfig-001-20260810    gcc-16.1.0
arm64                randconfig-002-20260809    gcc-12.5.0
arm64                randconfig-002-20260809    gcc-14.3.0
arm64                randconfig-002-20260810    gcc-16.1.0
arm64                randconfig-003-20260809    clang-19
arm64                randconfig-003-20260809    gcc-14.3.0
arm64                randconfig-003-20260810    gcc-16.1.0
arm64                randconfig-004-20260809    clang-24
arm64                randconfig-004-20260809    gcc-14.3.0
arm64                randconfig-004-20260810    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260809    gcc-14.3.0
csky                 randconfig-001-20260809    gcc-16.1.0
csky                 randconfig-001-20260810    gcc-16.1.0
csky                 randconfig-002-20260809    gcc-14.3.0
csky                 randconfig-002-20260810    gcc-16.1.0
hexagon              randconfig-001-20260809    clang-17
hexagon              randconfig-001-20260809    gcc-12.5.0
hexagon              randconfig-001-20260810    gcc-10.5.0
hexagon              randconfig-002-20260809    clang-17
hexagon              randconfig-002-20260809    gcc-12.5.0
hexagon              randconfig-002-20260810    gcc-10.5.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    clang-22
i386       buildonly-randconfig-001-20260809    clang-22
i386       buildonly-randconfig-001-20260810    clang-22
i386       buildonly-randconfig-002-20260809    clang-22
i386       buildonly-randconfig-002-20260810    clang-22
i386       buildonly-randconfig-003-20260809    clang-22
i386       buildonly-randconfig-003-20260810    clang-22
i386       buildonly-randconfig-004-20260809    clang-22
i386       buildonly-randconfig-004-20260809    gcc-14
i386       buildonly-randconfig-004-20260810    clang-22
i386       buildonly-randconfig-005-20260809    clang-22
i386       buildonly-randconfig-005-20260809    gcc-14
i386       buildonly-randconfig-005-20260810    clang-22
i386       buildonly-randconfig-006-20260809    clang-22
i386       buildonly-randconfig-006-20260810    clang-22
i386                 randconfig-001-20260809    clang-22
i386                 randconfig-001-20260810    gcc-14
i386                 randconfig-002-20260809    clang-22
i386                 randconfig-002-20260809    gcc-14
i386                 randconfig-002-20260810    gcc-14
i386                 randconfig-003-20260809    clang-22
i386                 randconfig-003-20260810    gcc-14
i386                 randconfig-004-20260809    clang-22
i386                 randconfig-004-20260810    gcc-14
i386                 randconfig-005-20260809    clang-22
i386                 randconfig-005-20260810    gcc-14
i386                 randconfig-006-20260809    clang-22
i386                 randconfig-006-20260810    gcc-14
i386                 randconfig-007-20260809    clang-22
i386                 randconfig-007-20260809    gcc-14
i386                 randconfig-007-20260810    gcc-14
i386                          randconfig-011    clang-22
i386                 randconfig-011-20260809    clang-22
i386                 randconfig-011-20260809    gcc-14
i386                 randconfig-011-20260810    clang-22
i386                 randconfig-012-20260809    clang-22
i386                 randconfig-012-20260810    clang-22
i386                 randconfig-013-20260809    clang-22
i386                 randconfig-013-20260809    gcc-14
i386                 randconfig-013-20260810    clang-22
i386                 randconfig-014-20260809    clang-22
i386                 randconfig-014-20260809    gcc-14
i386                 randconfig-014-20260810    clang-22
i386                 randconfig-015-20260809    clang-22
i386                 randconfig-015-20260809    gcc-14
i386                 randconfig-015-20260810    clang-22
i386                 randconfig-016-20260809    clang-22
i386                 randconfig-016-20260810    clang-22
i386                 randconfig-017-20260809    clang-22
i386                 randconfig-017-20260810    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260809    clang-18
loongarch            randconfig-001-20260809    gcc-12.5.0
loongarch            randconfig-001-20260810    gcc-10.5.0
loongarch            randconfig-002-20260809    gcc-12.5.0
loongarch            randconfig-002-20260810    gcc-10.5.0
mips                         ath25_defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260809    gcc-12.5.0
nios2                randconfig-001-20260809    gcc-8.5.0
nios2                randconfig-001-20260810    gcc-10.5.0
nios2                randconfig-002-20260809    gcc-12.5.0
nios2                randconfig-002-20260809    gcc-8.5.0
nios2                randconfig-002-20260810    gcc-10.5.0
openrisc                 or1klitex_defconfig    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260809    gcc-15.2.0
parisc               randconfig-001-20260809    gcc-8.5.0
parisc               randconfig-001-20260810    gcc-8.5.0
parisc               randconfig-002-20260809    gcc-8.5.0
parisc               randconfig-002-20260810    gcc-8.5.0
powerpc              randconfig-001-20260809    clang-24
powerpc              randconfig-001-20260809    gcc-8.5.0
powerpc              randconfig-001-20260810    gcc-8.5.0
powerpc              randconfig-002-20260809    clang-24
powerpc              randconfig-002-20260809    gcc-8.5.0
powerpc              randconfig-002-20260810    gcc-8.5.0
powerpc64            randconfig-001-20260809    clang-17
powerpc64            randconfig-001-20260809    gcc-8.5.0
powerpc64            randconfig-001-20260810    gcc-8.5.0
powerpc64            randconfig-002-20260809    clang-24
powerpc64            randconfig-002-20260809    gcc-8.5.0
powerpc64            randconfig-002-20260810    gcc-8.5.0
riscv                randconfig-001-20260809    clang-24
riscv                randconfig-001-20260810    gcc-8.5.0
riscv                randconfig-002-20260809    clang-20
riscv                randconfig-002-20260809    clang-24
riscv                randconfig-002-20260810    gcc-8.5.0
s390                 randconfig-001-20260809    clang-24
s390                 randconfig-001-20260809    gcc-11.5.0
s390                 randconfig-001-20260810    gcc-8.5.0
s390                 randconfig-002-20260809    clang-24
s390                 randconfig-002-20260810    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260809    clang-24
sh                   randconfig-001-20260809    gcc-16.1.0
sh                   randconfig-001-20260810    gcc-8.5.0
sh                   randconfig-002-20260809    clang-24
sh                   randconfig-002-20260809    gcc-10.5.0
sh                   randconfig-002-20260810    gcc-8.5.0
sparc                         randconfig-001    gcc-16.1.0
sparc                randconfig-001-20260809    gcc-11.5.0
sparc                randconfig-001-20260809    gcc-8.5.0
sparc                randconfig-001-20260810    gcc-11.5.0
sparc                randconfig-002-20260809    gcc-11.5.0
sparc                randconfig-002-20260810    gcc-11.5.0
sparc64              randconfig-001-20260809    gcc-11.5.0
sparc64              randconfig-001-20260809    gcc-9.5.0
sparc64              randconfig-001-20260810    gcc-11.5.0
sparc64              randconfig-002-20260809    clang-24
sparc64              randconfig-002-20260809    gcc-11.5.0
sparc64              randconfig-002-20260810    gcc-11.5.0
um                   randconfig-001-20260809    clang-18
um                   randconfig-001-20260809    gcc-11.5.0
um                   randconfig-001-20260810    gcc-11.5.0
um                   randconfig-002-20260809    clang-17
um                   randconfig-002-20260809    gcc-11.5.0
um                   randconfig-002-20260810    gcc-11.5.0
x86_64     buildonly-randconfig-001-20260809    clang-22
x86_64     buildonly-randconfig-001-20260810    gcc-14
x86_64     buildonly-randconfig-002-20260809    clang-22
x86_64     buildonly-randconfig-002-20260809    gcc-14
x86_64     buildonly-randconfig-002-20260810    gcc-14
x86_64     buildonly-randconfig-003-20260809    clang-22
x86_64     buildonly-randconfig-003-20260809    gcc-14
x86_64     buildonly-randconfig-003-20260810    gcc-14
x86_64     buildonly-randconfig-004-20260809    clang-22
x86_64     buildonly-randconfig-004-20260810    gcc-14
x86_64     buildonly-randconfig-005-20260809    clang-22
x86_64     buildonly-randconfig-005-20260810    gcc-14
x86_64     buildonly-randconfig-006-20260809    clang-22
x86_64     buildonly-randconfig-006-20260809    gcc-14
x86_64     buildonly-randconfig-006-20260810    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260809    clang-22
x86_64               randconfig-001-20260810    gcc-14
x86_64               randconfig-002-20260809    clang-22
x86_64               randconfig-002-20260809    gcc-14
x86_64               randconfig-002-20260810    gcc-14
x86_64               randconfig-003-20260809    clang-22
x86_64               randconfig-003-20260810    gcc-14
x86_64               randconfig-004-20260809    clang-22
x86_64               randconfig-004-20260810    gcc-14
x86_64               randconfig-005-20260809    clang-22
x86_64               randconfig-005-20260810    gcc-14
x86_64               randconfig-006-20260809    clang-22
x86_64               randconfig-006-20260809    gcc-14
x86_64               randconfig-006-20260810    gcc-14
x86_64               randconfig-011-20260809    clang-22
x86_64               randconfig-011-20260809    gcc-14
x86_64               randconfig-011-20260810    clang-22
x86_64               randconfig-012-20260809    gcc-14
x86_64               randconfig-012-20260810    clang-22
x86_64               randconfig-013-20260809    gcc-14
x86_64               randconfig-013-20260810    clang-22
x86_64               randconfig-014-20260809    clang-22
x86_64               randconfig-014-20260809    gcc-14
x86_64               randconfig-014-20260810    clang-22
x86_64               randconfig-015-20260809    gcc-14
x86_64               randconfig-015-20260810    clang-22
x86_64               randconfig-016-20260809    clang-22
x86_64               randconfig-016-20260809    gcc-14
x86_64               randconfig-016-20260810    clang-22
x86_64               randconfig-071-20260809    clang-22
x86_64               randconfig-071-20260810    clang-22
x86_64               randconfig-072-20260809    clang-22
x86_64               randconfig-072-20260810    clang-22
x86_64               randconfig-073-20260809    clang-22
x86_64               randconfig-073-20260810    clang-22
x86_64               randconfig-074-20260809    clang-22
x86_64               randconfig-074-20260810    clang-22
x86_64               randconfig-075-20260809    clang-22
x86_64               randconfig-075-20260809    gcc-14
x86_64               randconfig-075-20260810    clang-22
x86_64               randconfig-076-20260809    clang-22
x86_64               randconfig-076-20260810    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260809    gcc-11.5.0
xtensa               randconfig-001-20260809    gcc-13.4.0
xtensa               randconfig-001-20260810    gcc-11.5.0
xtensa               randconfig-002-20260809    gcc-11.5.0
xtensa               randconfig-002-20260810    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
