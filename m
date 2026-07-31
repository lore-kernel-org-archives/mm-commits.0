Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E02942FCCB
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508356; cv=none; b=FiYoj+KW74QalIfdLgv4Hys0aS5SaKLLd6B8X6bUCCXwKUNMohmwiBlK+a5H9CNNNPRkE29KEI3PS97/bLPAmg9p67/Z3v+BkSZnEI5jiDD84R6mM0kIRBg0XINTuD2Trr97Yj+hgi8Dr/BbN+7QwcdCiVtkvZK4mMLb1dHIInw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508356; c=relaxed/simple;
	bh=eA+qpUMzk+socKsCRX4kGfvQe3dPY8NF1KuT4zh55Ws=;
	h=Date:From:To:Cc:Subject:Message-ID; b=MuDOCdJQRXiG48Ebsx2USG9KAydnUznCjj0JDaxKXHSaXTw9HAMAocB23VLetNsglRQR4Xr2xzkB2zzIOPjl9V69md/lpCYwa6oT7OL20aac9fbEGX7ueq6/ZN1Hv4Uz8cqv4kAc9WTlgG4TneEecDEGlgUIeU0Vw/HTzWZRZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VDNACTZl; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VDNACTZl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785508353; x=1817044353;
  h=date:from:to:cc:subject:message-id;
  bh=eA+qpUMzk+socKsCRX4kGfvQe3dPY8NF1KuT4zh55Ws=;
  b=VDNACTZlWQyOwLFU6odPsiu2Bd+mY6rajE+Nphug6UANA8MKnsiTpuKL
   1vONXnxPh+zQzyYHPdXfg056gG3yADMh58TXr8sXTld9RNYs2wKOzePFT
   HnzmYs8x6evs9dRKqsP3G37tNFUWo9HD0a6sypnT29XyIqz6WdDtgW2GQ
   tJoqY+zcxj5IdgqANRJQpqqqqF9Fhtbs0ldOtqwftZMdZFJs562xAk2Px
   BlIxmcCsJAm4UKc/TwfNSOtoTEq57rxBu1gywMVvqkUROJom6+n00Zv1E
   V/2FJiD1D1hO50cCZU2GJEAtOPLckGoZClQMBkqYI69Em892Wy1UVPuFv
   g==;
X-CSE-ConnectionGUID: gxOLK/eMQHWjl4KuyGiSzw==
X-CSE-MsgGUID: F8hXYcPhRBCLyDC2Y+UYTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="86085326"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="86085326"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:32:32 -0700
X-CSE-ConnectionGUID: U8aBB/S2R56Gx5S09zrCIw==
X-CSE-MsgGUID: Y1Y/0fbcSvSYdTUtqhFt1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="262551831"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 31 Jul 2026 07:32:30 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpoHj-000000001GH-3KRS;
	Fri, 31 Jul 2026 14:32:27 +0000
Date: Fri, 31 Jul 2026 22:31:38 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb
Message-ID: <202607312212.u1pPx1f6-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- powerpc64-randconfig-r072-20260731
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 795m

configs tested: 150
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260731    clang-17
arc                  randconfig-001-20260731    gcc-8.5.0
arc                  randconfig-002-20260731    clang-17
arc                  randconfig-002-20260731    gcc-16.1.0
arm                  randconfig-001-20260731    clang-17
arm                  randconfig-002-20260731    clang-17
arm                  randconfig-002-20260731    clang-19
arm                  randconfig-003-20260731    clang-17
arm                  randconfig-003-20260731    clang-24
arm                  randconfig-004-20260731    clang-17
arm                  randconfig-004-20260731    clang-24
arm64                randconfig-001-20260731    gcc-8.5.0
arm64                randconfig-002-20260731    clang-24
arm64                randconfig-002-20260731    gcc-8.5.0
arm64                randconfig-003-20260731    gcc-10.5.0
arm64                randconfig-003-20260731    gcc-8.5.0
arm64                randconfig-004-20260731    gcc-12.5.0
arm64                randconfig-004-20260731    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-8.5.0
csky                 randconfig-002-20260731    gcc-10.5.0
csky                 randconfig-002-20260731    gcc-8.5.0
hexagon              randconfig-001-20260731    clang-24
hexagon              randconfig-002-20260731    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260731    clang-22
i386       buildonly-randconfig-001-20260731    gcc-14
i386       buildonly-randconfig-002-20260731    clang-22
i386       buildonly-randconfig-003-20260731    clang-22
i386       buildonly-randconfig-004-20260731    clang-22
i386       buildonly-randconfig-004-20260731    gcc-13
i386       buildonly-randconfig-005-20260731    clang-22
i386       buildonly-randconfig-006-20260731    clang-22
i386       buildonly-randconfig-006-20260731    gcc-14
i386                 randconfig-001-20260731    gcc-14
i386                 randconfig-002-20260731    clang-22
i386                 randconfig-002-20260731    gcc-14
i386                 randconfig-003-20260731    clang-22
i386                 randconfig-003-20260731    gcc-14
i386                 randconfig-004-20260731    gcc-14
i386                 randconfig-005-20260731    gcc-14
i386                 randconfig-006-20260731    gcc-13
i386                 randconfig-006-20260731    gcc-14
i386                 randconfig-007-20260731    gcc-14
i386                 randconfig-011-20260731    clang-22
i386                 randconfig-012-20260731    clang-22
i386                 randconfig-013-20260731    clang-22
i386                 randconfig-013-20260731    gcc-14
i386                 randconfig-014-20260731    clang-22
i386                 randconfig-014-20260731    gcc-14
i386                 randconfig-015-20260731    clang-22
i386                 randconfig-015-20260731    gcc-14
i386                 randconfig-016-20260731    clang-22
i386                 randconfig-016-20260731    gcc-14
i386                 randconfig-017-20260731    clang-22
i386                 randconfig-017-20260731    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260731    clang-24
loongarch            randconfig-001-20260731    gcc-16.1.0
loongarch            randconfig-002-20260731    clang-24
mips                decstation_r4k_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260731    clang-24
nios2                randconfig-001-20260731    gcc-8.5.0
nios2                randconfig-002-20260731    clang-24
nios2                randconfig-002-20260731    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260731    gcc-8.5.0
parisc               randconfig-002-20260731    gcc-13.4.0
parisc               randconfig-002-20260731    gcc-8.5.0
powerpc              randconfig-001-20260731    clang-17
powerpc              randconfig-001-20260731    gcc-8.5.0
powerpc              randconfig-002-20260731    clang-24
powerpc              randconfig-002-20260731    gcc-8.5.0
powerpc64            randconfig-001-20260731    gcc-8.5.0
powerpc64            randconfig-002-20260731    gcc-8.5.0
riscv                randconfig-001-20260731    clang-19
riscv                randconfig-002-20260731    clang-19
riscv                randconfig-002-20260731    gcc-12.5.0
s390                 randconfig-001-20260731    clang-19
s390                 randconfig-001-20260731    clang-24
s390                 randconfig-002-20260731    clang-19
s390                 randconfig-002-20260731    clang-21
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260731    clang-19
sh                   randconfig-001-20260731    gcc-16.1.0
sh                   randconfig-002-20260731    clang-19
sh                   randconfig-002-20260731    gcc-16.1.0
sparc                         randconfig-001    gcc-14
sparc                randconfig-001-20260731    gcc-13.4.0
sparc                randconfig-001-20260731    gcc-14
sparc                randconfig-002-20260731    gcc-14
sparc                randconfig-002-20260731    gcc-8.5.0
sparc64              randconfig-001-20260731    clang-20
sparc64              randconfig-001-20260731    gcc-14
sparc64              randconfig-002-20260731    gcc-14
sparc64              randconfig-002-20260731    gcc-8.5.0
um                   randconfig-001-20260731    gcc-14
um                   randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-001-20260731    clang-22
x86_64     buildonly-randconfig-001-20260731    gcc-14
x86_64     buildonly-randconfig-002-20260731    clang-22
x86_64     buildonly-randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-003-20260731    clang-22
x86_64     buildonly-randconfig-003-20260731    gcc-14
x86_64     buildonly-randconfig-004-20260731    clang-22
x86_64     buildonly-randconfig-004-20260731    gcc-14
x86_64     buildonly-randconfig-005-20260731    clang-22
x86_64     buildonly-randconfig-005-20260731    gcc-14
x86_64     buildonly-randconfig-006-20260731    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260731    clang-22
x86_64               randconfig-001-20260731    gcc-14
x86_64               randconfig-002-20260731    gcc-14
x86_64               randconfig-003-20260731    gcc-14
x86_64               randconfig-004-20260731    gcc-14
x86_64               randconfig-005-20260731    clang-22
x86_64               randconfig-005-20260731    gcc-14
x86_64               randconfig-006-20260731    clang-22
x86_64               randconfig-006-20260731    gcc-14
x86_64               randconfig-011-20260731    clang-22
x86_64               randconfig-012-20260731    gcc-14
x86_64               randconfig-013-20260731    clang-22
x86_64               randconfig-014-20260731    clang-22
x86_64               randconfig-015-20260731    gcc-14
x86_64               randconfig-016-20260731    gcc-14
x86_64               randconfig-071-20260731    clang-22
x86_64               randconfig-071-20260731    gcc-14
x86_64               randconfig-072-20260731    clang-22
x86_64               randconfig-073-20260731    clang-22
x86_64               randconfig-074-20260731    clang-22
x86_64               randconfig-074-20260731    gcc-14
x86_64               randconfig-075-20260731    clang-22
x86_64               randconfig-075-20260731    gcc-14
x86_64               randconfig-076-20260731    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260731    gcc-14
xtensa               randconfig-001-20260731    gcc-9.5.0
xtensa               randconfig-002-20260731    gcc-11.5.0
xtensa               randconfig-002-20260731    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
