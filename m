Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716692472AF
	for <mm-commits@vger.kernel.org>; Wed, 26 Aug 2026 01:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787706892; cv=none; b=sa5XrtxwJNQEGZvlW33Y9qE/4It8wFND6p761cpm944yuCxXkKYFCNrjFuQyAjNpy/0lW7ZcHc++9iIWuC4zzoeVxrIgl/rBVByVnXQkIA/rk3GaRaOUt6fSO6OQzKpKzVqMm8tR1KNloMPdu1/G9WxsuptZ7lyXKk0AnFjs4ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787706892; c=relaxed/simple;
	bh=MN9m1g5Yz/k5WhNsRHT4dQtbYlDO4tuN8qaTTI6cHE0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=RHttaZxbbT0dvupyO4OqxO+zCAwmphdOc3rp3eCJy4GdAcK2CXsjPYnaY/kHIjUdbSBm07s+iA9gATWMntYTTdXR/Ggt+1MyBKLMHX2xXUc8/2xGqJ1K6kqcCIKmApus04Zqn+FHFa7YRI6RXs+fGa7pSpb119IUdkF4wOy8l9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Co0gN+qi; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Co0gN+qi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787706890; x=1819242890;
  h=date:from:to:cc:subject:message-id;
  bh=MN9m1g5Yz/k5WhNsRHT4dQtbYlDO4tuN8qaTTI6cHE0=;
  b=Co0gN+qiImnPUPWwMUc49GG8+2Ru7RmCW3bhZ6RdYVNqlX5mbo/l5Znb
   pSg3JF2X2YfbX1QFgrJFG9Mz23EUCvfeZmlm3R5Ss7CajmcKzs6HPQMh8
   A4KFMlzIwpI9FFNRpVqb8nXYR+90tKsO+ZnSyRN8gKVnFN0j4K2+xncqL
   cgYLgCUWg2YFz4FcBcL3Lj1FaNspl06bILmLH/FfFPfi7EKIN2PdIKLPP
   OCWYLxhqHBO4WmUzjG+tH167B5RGdxEuu+wI7mBtO54w57KBSMIIkiOLS
   djXjiqLhJOPpFK53vg5NhxIdH2hIyFNkyKXENhNnjDqd8MnGd+7rCguIh
   Q==;
X-CSE-ConnectionGUID: T1P2DzPpSba379xzf6qyGQ==
X-CSE-MsgGUID: +2FTPtk2RACf4XWk7SOkxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="92002193"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="92002193"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 18:14:49 -0700
X-CSE-ConnectionGUID: SAdetNXoTXyvgPnReeOsHg==
X-CSE-MsgGUID: Sf/SUP8+Q/CJ/oeYgx/ioA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="271224585"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 25 Aug 2026 18:14:48 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wz2E0-000000006iV-2Odw;
	Wed, 26 Aug 2026 01:14:44 +0000
Date: Wed, 26 Aug 2026 09:14:19 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 1a46b1e97bde62afa7d925bb0dcd9f9748a1d7c3
Message-ID: <202608260904.mMJZXd01-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1a46b1e97bde62afa7d925bb0dcd9f9748a1d7c3  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 854m

configs tested: 108
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260825    gcc-8.5.0
arc                  randconfig-002-20260825    gcc-8.5.0
arm                  randconfig-001-20260825    clang-20
arm                  randconfig-002-20260825    gcc-8.5.0
arm                  randconfig-003-20260825    clang-24
arm                  randconfig-004-20260825    gcc-13.4.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260825    gcc-13.4.0
arm64                randconfig-002-20260825    clang-24
arm64                randconfig-003-20260825    clang-24
arm64                randconfig-004-20260825    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260825    gcc-11.5.0
csky                 randconfig-002-20260825    gcc-9.5.0
hexagon              randconfig-001-20260825    clang-17
hexagon              randconfig-002-20260825    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260825    clang-22
i386       buildonly-randconfig-002-20260825    gcc-14
i386       buildonly-randconfig-003-20260825    gcc-12
i386       buildonly-randconfig-004-20260825    clang-22
i386       buildonly-randconfig-005-20260825    gcc-14
i386       buildonly-randconfig-006-20260825    gcc-14
i386                 randconfig-001-20260825    clang-22
i386                 randconfig-001-20260826    gcc-14
i386                 randconfig-002-20260825    gcc-14
i386                 randconfig-002-20260826    clang-22
i386                 randconfig-003-20260825    clang-22
i386                 randconfig-003-20260826    clang-22
i386                 randconfig-004-20260826    clang-22
i386                 randconfig-005-20260825    gcc-14
i386                 randconfig-005-20260826    gcc-14
i386                 randconfig-006-20260825    gcc-14
i386                 randconfig-006-20260826    clang-22
i386                 randconfig-007-20260826    gcc-14
i386                 randconfig-011-20260825    gcc-14
i386                 randconfig-012-20260825    clang-22
i386                 randconfig-013-20260825    clang-22
i386                 randconfig-014-20260825    clang-22
i386                 randconfig-015-20260825    clang-22
i386                 randconfig-016-20260825    gcc-13
i386                 randconfig-017-20260825    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260825    gcc-16.1.0
loongarch            randconfig-002-20260825    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260825    gcc-9.5.0
nios2                randconfig-002-20260825    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260825    gcc-12.5.0
parisc               randconfig-002-20260825    gcc-14.3.0
powerpc                     chrp32_defconfig    clang-24
powerpc              randconfig-001-20260825    clang-24
powerpc              randconfig-002-20260825    gcc-8.5.0
powerpc64            randconfig-001-20260825    clang-24
powerpc64            randconfig-002-20260825    clang-24
riscv                randconfig-001-20260825    gcc-13.4.0
riscv                randconfig-002-20260825    gcc-15.2.0
s390                 randconfig-001-20260825    clang-24
s390                 randconfig-002-20260825    clang-24
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260825    gcc-15.2.0
sh                   randconfig-002-20260825    gcc-9.5.0
sparc                randconfig-001-20260825    gcc-8.5.0
sparc                randconfig-002-20260825    gcc-12.5.0
sparc64              randconfig-001-20260825    gcc-10.5.0
sparc64              randconfig-002-20260825    clang-24
um                   randconfig-001-20260825    gcc-14
um                   randconfig-002-20260825    gcc-12
x86_64              buildonly-randconfig-001    gcc-12
x86_64     buildonly-randconfig-001-20260825    gcc-12
x86_64     buildonly-randconfig-002-20260825    gcc-14
x86_64     buildonly-randconfig-003-20260825    clang-22
x86_64     buildonly-randconfig-004-20260825    gcc-14
x86_64     buildonly-randconfig-005-20260825    clang-22
x86_64     buildonly-randconfig-006-20260825    clang-22
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260825    clang-22
x86_64               randconfig-002-20260825    clang-22
x86_64               randconfig-003-20260825    clang-22
x86_64               randconfig-004-20260825    clang-22
x86_64               randconfig-005-20260825    clang-22
x86_64               randconfig-006-20260825    gcc-13
x86_64               randconfig-011-20260825    gcc-14
x86_64               randconfig-012-20260825    gcc-14
x86_64               randconfig-013-20260825    clang-22
x86_64               randconfig-014-20260825    gcc-12
x86_64               randconfig-015-20260825    gcc-14
x86_64               randconfig-016-20260825    gcc-14
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260825    clang-22
x86_64               randconfig-072-20260825    clang-22
x86_64               randconfig-073-20260825    clang-22
x86_64               randconfig-074-20260825    gcc-14
x86_64               randconfig-075-20260825    clang-22
x86_64               randconfig-076-20260825    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260825    gcc-14.3.0
xtensa               randconfig-002-20260825    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
