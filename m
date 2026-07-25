Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115521EF39E
	for <mm-commits@vger.kernel.org>; Sat, 25 Jul 2026 07:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784963588; cv=none; b=eeKARk40KcT6HkOVAagXR+7k18dWXx71I4uKON+AEPzQxxiZxr31nEMvaUUR1kXmseP66XTzbYUp2PlzF9LXo2rJi/4RsLm2i4DNj7zqsbn+wv3Y9eC6hwMOEKwfJC58TxY53Lo8AK5FoxlLMR8UUOySoaQjo2OKW3upCzgP2zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784963588; c=relaxed/simple;
	bh=MpetJc+dqyBth0NSHhYUJzOujxWmY7Dbkr/tCp/KxjA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=KkiazY8++W6hT10N3/y9eErEBUI8xLDG/k9sTi+rQG6OzrxDBRC3kG4TATKYTIycKPs9Zs3j/dSFe1dBHgliECMx9jl786fM4F/3g01Grx2KM9TKocEwDB2xp+7BFc8hjFqThFGfCZZJH6fxdRxmikMWpzWfD4knrdloI0tPqQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QROhDAIA; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QROhDAIA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784963587; x=1816499587;
  h=date:from:to:cc:subject:message-id;
  bh=MpetJc+dqyBth0NSHhYUJzOujxWmY7Dbkr/tCp/KxjA=;
  b=QROhDAIABA5K7iS4+vyvoqpFSh0DX36qNTAoZbJ1P5qSmlkWc5Mz4Wgq
   PspHB7VJW+2BTT0Z5jIaHHadDfKPi9/u3wE3a8WR7nhKdtit8zYKWpAx0
   W9/TEgyUBazzkQSKd6NGny2nbSBzZizO3olrX8r+FFXLrnbeX+XXjSY4m
   fdS+K7nzym4BTZHB/qtLDsNJczSyVnVKTFZKbwWKt6KNJ9/MP1uB+ipRe
   hIXH0SoQT4dyVgf4R6HTm1GFLKiTx1fjp12ocajXcV14JQ69xJzrHlY8i
   tRNGTDjS7AQZLvsPM7qKCmP1O+uRmee6SA9ICqWw0YV21o/WgkKmmBiOI
   g==;
X-CSE-ConnectionGUID: z1iOLZ9aTPSyxXPi/RAFYA==
X-CSE-MsgGUID: IEUyY46QR+2ZJsSZ0tbJOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="73160271"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="73160271"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 00:13:06 -0700
X-CSE-ConnectionGUID: MVE1/rlCQHmLB5Ops7gaAA==
X-CSE-MsgGUID: GR3LEALYSeSyKPcCYqUYOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="259560280"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 25 Jul 2026 00:13:05 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnWYl-00000000bXi-0kmc;
	Sat, 25 Jul 2026 07:12:43 +0000
Date: Sat, 25 Jul 2026 15:11:38 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-ID: <202607251512.KMStVfrY-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
|-- microblaze-randconfig-r072-20260725
|   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
`-- um-randconfig-r073-20260725
    |-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
    `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

elapsed time: 998m

configs tested: 92
configs skipped: 8

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260725    gcc-11.5.0
arc                  randconfig-002-20260725    gcc-8.5.0
arm                  randconfig-001-20260725    gcc-8.5.0
arm                  randconfig-002-20260725    clang-21
arm                  randconfig-003-20260725    gcc-10.5.0
arm                  randconfig-004-20260725    gcc-15.2.0
arm64                randconfig-001-20260725    clang-24
arm64                randconfig-002-20260725    gcc-13.4.0
arm64                randconfig-003-20260725    clang-24
arm64                randconfig-004-20260725    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260725    gcc-9.5.0
csky                 randconfig-002-20260725    gcc-16.1.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260725    clang-17
hexagon              randconfig-002-20260725    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260725    clang-22
i386       buildonly-randconfig-002-20260725    gcc-14
i386       buildonly-randconfig-003-20260725    clang-22
i386       buildonly-randconfig-004-20260725    clang-22
i386       buildonly-randconfig-005-20260725    gcc-14
i386       buildonly-randconfig-006-20260725    gcc-14
i386                 randconfig-001-20260725    clang-22
i386                 randconfig-002-20260725    gcc-14
i386                 randconfig-003-20260725    gcc-14
i386                 randconfig-004-20260725    gcc-12
i386                 randconfig-005-20260725    clang-22
i386                 randconfig-006-20260725    gcc-14
i386                 randconfig-007-20260725    gcc-14
i386                 randconfig-011-20260725    gcc-14
i386                 randconfig-012-20260725    gcc-14
i386                 randconfig-013-20260725    gcc-14
i386                 randconfig-014-20260725    clang-22
i386                 randconfig-015-20260725    clang-22
i386                 randconfig-016-20260725    clang-22
i386                 randconfig-017-20260725    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260725    gcc-16.1.0
loongarch            randconfig-002-20260725    gcc-13.4.0
m68k                      m5249evb_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260725    gcc-11.5.0
nios2                randconfig-002-20260725    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260725    gcc-10.5.0
parisc               randconfig-002-20260725    gcc-12.5.0
powerpc              randconfig-001-20260725    gcc-9.5.0
powerpc              randconfig-002-20260725    gcc-15.2.0
powerpc64            randconfig-001-20260725    clang-17
powerpc64            randconfig-002-20260725    clang-24
riscv                randconfig-001-20260725    gcc-8.5.0
riscv                randconfig-002-20260725    gcc-8.5.0
s390                 randconfig-001-20260725    gcc-10.5.0
s390                 randconfig-002-20260725    gcc-16.1.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260725    gcc-16.1.0
sh                   randconfig-002-20260725    gcc-11.5.0
sparc                randconfig-001-20260725    gcc-16.1.0
sparc                randconfig-002-20260725    gcc-8.5.0
sparc64              randconfig-001-20260725    gcc-8.5.0
sparc64              randconfig-002-20260725    gcc-10.5.0
um                   randconfig-001-20260725    gcc-14
um                   randconfig-002-20260725    clang-24
x86_64               randconfig-001-20260725    gcc-14
x86_64               randconfig-002-20260725    clang-22
x86_64               randconfig-003-20260725    clang-22
x86_64               randconfig-004-20260725    clang-22
x86_64               randconfig-005-20260725    clang-22
x86_64               randconfig-006-20260725    clang-22
x86_64               randconfig-011-20260725    gcc-14
x86_64               randconfig-012-20260725    gcc-14
x86_64               randconfig-013-20260725    gcc-14
x86_64               randconfig-014-20260725    gcc-14
x86_64               randconfig-015-20260725    gcc-14
x86_64               randconfig-016-20260725    gcc-14
x86_64               randconfig-071-20260725    gcc-14
x86_64               randconfig-072-20260725    gcc-14
x86_64               randconfig-073-20260725    gcc-14
x86_64               randconfig-074-20260725    gcc-14
x86_64               randconfig-075-20260725    gcc-14
x86_64               randconfig-076-20260725    clang-22
xtensa               randconfig-001-20260725    gcc-16.1.0
xtensa               randconfig-002-20260725    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
