Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D041F938
	for <mm-commits@vger.kernel.org>; Sun, 16 Aug 2026 00:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786838726; cv=none; b=Cqs89BbJOYCLYHiyi3iJ6M6Oj+DLbxkZ8U2mNTF2YLdWpwoVtoRahOcgfbBrWaqnOfxC7/xjV5qft7QMhtpA9aS0f+V7jtCbYP605AzFElwtpL6WTIf6KQIvCEy+6j7CZa0CfgCDcT4DRhjjybfEp13trFKAiiET6EaV/0yrbno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786838726; c=relaxed/simple;
	bh=VaOQwjUn/5W+Vxjff4nmO2RENY8dlbFq5sFTlodLZMY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=adpy0egWUY34te84NQkevMUfPU2JfK9byE0Pv9pKepeGPDMaAs82utR1CmLui4P/mMsjnXO4HwgIx5AsEBo29HAvYXxMa3khzmSHZV/kasGmGbJWWAv223qODVTch9EO23rbKkMAg2cCfrzi8bPYj5YRO+8JVxXun210hwcn4sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKQ0fedU; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKQ0fedU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786838725; x=1818374725;
  h=date:from:to:cc:subject:message-id;
  bh=VaOQwjUn/5W+Vxjff4nmO2RENY8dlbFq5sFTlodLZMY=;
  b=bKQ0fedUX2joaCJG5I/vdTBCoLTJ0MsCZk+YmxR4Ie5Vj/tgN410j0aM
   jINgwaQyY1EIZOkNd1O+7swFDsiw/sDp25roJHV89XF1L45V9xzmY+3ci
   MYU/9HRb5PIZdNetRb59bZq55zd1gxFwW4z9Pwj5z4nXaH2V/QSG+NC11
   jhlRg4Eks6rYhVtmWdFTm0WuGEUJH8be2MmJvyKJZsSQbjy3II+r/Cw2y
   Ze2v2/3YaHVE+rFOst1B4ZhlXBFSZtlHv1ws4e3y2sebgVS1iqaQ19D1b
   j6Y5HwMFJu0rygVwWy2ttxUTNrgQkZ6tAXqL9URRs00KuGdrUjCuP3jAB
   g==;
X-CSE-ConnectionGUID: R7Y6wSeGQT+69x5+pzGFLQ==
X-CSE-MsgGUID: K4dbM1JkQ6+gDq3ofSp/tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11876"; a="87576796"
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="87576796"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2026 17:05:24 -0700
X-CSE-ConnectionGUID: 9rGtrACvRVu6jWmeacnoYQ==
X-CSE-MsgGUID: /4g+NdXbTxK1B4enuqfjWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="261284156"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 15 Aug 2026 17:05:23 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wvONM-00000000cYo-0uUj;
	Sun, 16 Aug 2026 00:05:20 +0000
Date: Sun, 16 Aug 2026 08:05:08 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 33f61b12d297562321533c048e034b1fb21c1cf3
Message-ID: <202608160855.VZWST6gY-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 33f61b12d297562321533c048e034b1fb21c1cf3  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 773m

configs tested: 99
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260815    gcc-11.5.0
arc                  randconfig-002-20260815    gcc-8.5.0
arm                  randconfig-001-20260815    clang-21
arm                  randconfig-002-20260815    gcc-8.5.0
arm                  randconfig-003-20260815    clang-17
arm                  randconfig-004-20260815    gcc-8.5.0
arm64                randconfig-001-20260815    clang-24
arm64                randconfig-002-20260815    gcc-8.5.0
arm64                randconfig-003-20260815    clang-17
arm64                randconfig-004-20260815    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260815    gcc-13.4.0
csky                 randconfig-002-20260815    gcc-15.2.0
hexagon              randconfig-001-20260815    clang-24
hexagon              randconfig-002-20260815    clang-22
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260815    gcc-14
i386       buildonly-randconfig-002-20260815    gcc-14
i386       buildonly-randconfig-003-20260815    gcc-14
i386       buildonly-randconfig-004-20260815    gcc-14
i386       buildonly-randconfig-005-20260815    gcc-14
i386       buildonly-randconfig-006-20260815    clang-22
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260815    clang-22
i386                 randconfig-002-20260815    clang-22
i386                 randconfig-003-20260815    gcc-14
i386                 randconfig-004-20260815    clang-22
i386                 randconfig-005-20260815    gcc-14
i386                 randconfig-006-20260815    gcc-14
i386                 randconfig-007-20260815    gcc-14
i386                 randconfig-011-20260815    clang-22
i386                 randconfig-012-20260815    gcc-14
i386                 randconfig-013-20260815    clang-22
i386                 randconfig-014-20260815    clang-22
i386                 randconfig-015-20260815    clang-22
i386                 randconfig-016-20260815    gcc-14
i386                 randconfig-017-20260815    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260815    clang-18
loongarch            randconfig-002-20260815    clang-18
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260815    gcc-8.5.0
nios2                randconfig-002-20260815    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260815    gcc-8.5.0
parisc               randconfig-002-20260815    gcc-16.1.0
powerpc              randconfig-001-20260815    gcc-9.5.0
powerpc              randconfig-002-20260815    clang-17
powerpc64            randconfig-001-20260815    gcc-11.5.0
powerpc64            randconfig-002-20260815    gcc-8.5.0
riscv                randconfig-001-20260815    gcc-8.5.0
riscv                randconfig-002-20260815    gcc-8.5.0
s390                 randconfig-001-20260815    clang-24
s390                 randconfig-002-20260815    clang-21
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260815    gcc-16.1.0
sh                   randconfig-002-20260815    gcc-11.5.0
sparc                randconfig-001-20260815    gcc-8.5.0
sparc                randconfig-002-20260815    gcc-16.1.0
sparc64              randconfig-001-20260815    clang-20
sparc64              randconfig-002-20260815    gcc-8.5.0
um                   randconfig-001-20260815    clang-24
um                   randconfig-002-20260815    clang-24
x86_64     buildonly-randconfig-001-20260815    clang-22
x86_64     buildonly-randconfig-002-20260815    gcc-14
x86_64     buildonly-randconfig-003-20260815    gcc-14
x86_64     buildonly-randconfig-004-20260815    gcc-14
x86_64     buildonly-randconfig-005-20260815    gcc-14
x86_64     buildonly-randconfig-006-20260815    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260815    gcc-13
x86_64               randconfig-002-20260815    clang-22
x86_64               randconfig-003-20260815    clang-22
x86_64               randconfig-004-20260815    clang-22
x86_64               randconfig-005-20260815    clang-22
x86_64               randconfig-006-20260815    gcc-14
x86_64               randconfig-011-20260815    clang-22
x86_64               randconfig-012-20260815    gcc-14
x86_64               randconfig-013-20260815    clang-22
x86_64               randconfig-014-20260815    clang-22
x86_64               randconfig-015-20260815    gcc-14
x86_64               randconfig-016-20260815    gcc-14
x86_64               randconfig-071-20260815    clang-22
x86_64               randconfig-072-20260815    clang-22
x86_64               randconfig-073-20260815    gcc-12
x86_64               randconfig-074-20260815    clang-22
x86_64               randconfig-075-20260815    clang-22
x86_64               randconfig-076-20260815    clang-22
xtensa               randconfig-001-20260815    gcc-8.5.0
xtensa               randconfig-002-20260815    gcc-8.5.0
xtensa                        virt_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
