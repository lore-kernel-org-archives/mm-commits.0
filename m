Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF431D5174
	for <mm-commits@vger.kernel.org>; Tue, 18 Aug 2026 04:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787027135; cv=none; b=IzycBf4RxYASFjDXTLMrQ6p8dRSrP46KDbVm+eDoMyyOnjbE1VvYIFX9uWMAZin40CQgwA2HPLtD7iSRTfKHqfsAP4zGE+WKfcL/NJle2TKZPJs8TtlzfCnrGSNMxmvBGTiX/8MdfDOkJTYEP7zKKcZ7qdeO4C8gya490ALipsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787027135; c=relaxed/simple;
	bh=AKfeuVMoPY1cuCSdmz85r2TT8nmwjetbFVFMFfAEzDs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=qVnt0BpJt1jXKrlGd7mdhKYuwCfZejofYbua4S6YNlluAoQ1ZTAyM38rC5N6UoauInCjCRmQ0UClinl42/6HSXxYVFFLut7zELFijHJaa4gR6Q8u8KEtFPJLFTJnDpO5VJmNmP0/808w29La2fLuOeYNlAf71nTZlaeGJXPXMfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dvgcvAco; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dvgcvAco"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787027132; x=1818563132;
  h=date:from:to:cc:subject:message-id;
  bh=AKfeuVMoPY1cuCSdmz85r2TT8nmwjetbFVFMFfAEzDs=;
  b=dvgcvAco1nl88C5bF/Ol9ZdyNiydgaPcyBNAWZDTgWsHRHv0SSPN1g3y
   p1uGp4hIbv2LTZy7KMw2qMW2sGN6D3TRmGNIkzC4CkzNDhkqN2+matkt2
   oVJoUF/wK07YLwCqkNcLmOsbfLdfy0qDUrR/SjH/UxzV+uSPpknepRWLb
   x7b6agAR1hUxPwJQxNuWZPOW+x2CQga8tJEn5yC2AZU0FUVz/m5n33duD
   tRfJS9uri0aC47Tbb8f4ASWvtL14bpDWQHzOH67GNn5ZR0weLDtxGNsun
   Cuf6B0y5h+Qjsflje7XDMUXOB35FFOrxI/HMij2988yTHJHMuBAtT91us
   w==;
X-CSE-ConnectionGUID: e9KpWybFSnqDw5LFBlViTQ==
X-CSE-MsgGUID: HbuYhNfCRTC29hKklFqK+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="86626840"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="86626840"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 21:25:32 -0700
X-CSE-ConnectionGUID: dVJfKGo5RmuomVQZdebHIQ==
X-CSE-MsgGUID: hQ+Ex7iwS1KuYgbCW5FNyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="264668673"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 17 Aug 2026 21:25:31 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wwBOB-00000000e6g-3E97;
	Tue, 18 Aug 2026 04:25:27 +0000
Date: Tue, 18 Aug 2026 12:24:58 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 4b65683fd25fe596b5b5947d934bb176413d077b
Message-ID: <202608181245.wv1B7pIh-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 4b65683fd25fe596b5b5947d934bb176413d077b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 2072m

configs tested: 165
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260817    gcc-8.5.0
arc                  randconfig-002-20260817    gcc-15.2.0
arc                  randconfig-002-20260817    gcc-8.5.0
arc                          tb10x_defconfig    gcc-16.1.0
arm                        at91_dt_defconfig    clang-17
arm                  randconfig-001-20260817    clang-24
arm                  randconfig-001-20260817    gcc-8.5.0
arm                  randconfig-002-20260817    clang-24
arm                  randconfig-002-20260817    gcc-8.5.0
arm                  randconfig-003-20260817    gcc-11.5.0
arm                  randconfig-003-20260817    gcc-8.5.0
arm                  randconfig-004-20260817    clang-24
arm                  randconfig-004-20260817    gcc-8.5.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260817    gcc-11.5.0
arm64                randconfig-001-20260817    gcc-13.4.0
arm64                randconfig-001-20260818    gcc-14.3.0
arm64                randconfig-002-20260817    gcc-11.5.0
arm64                randconfig-002-20260818    gcc-14.3.0
arm64                randconfig-003-20260817    clang-17
arm64                randconfig-003-20260817    gcc-11.5.0
arm64                randconfig-003-20260818    gcc-14.3.0
arm64                randconfig-004-20260817    clang-24
arm64                randconfig-004-20260817    gcc-11.5.0
arm64                randconfig-004-20260818    gcc-14.3.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260817    gcc-11.5.0
csky                 randconfig-001-20260818    gcc-14.3.0
csky                 randconfig-002-20260817    gcc-11.5.0
csky                 randconfig-002-20260817    gcc-13.4.0
csky                 randconfig-002-20260818    gcc-14.3.0
hexagon              randconfig-001-20260817    clang-24
hexagon              randconfig-001-20260817    gcc-8.5.0
hexagon              randconfig-001-20260818    gcc-10.5.0
hexagon              randconfig-002-20260817    clang-24
hexagon              randconfig-002-20260817    gcc-8.5.0
hexagon              randconfig-002-20260818    gcc-10.5.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-12
i386       buildonly-randconfig-001-20260817    gcc-12
i386       buildonly-randconfig-002-20260817    gcc-12
i386       buildonly-randconfig-002-20260817    gcc-14
i386       buildonly-randconfig-003-20260817    gcc-12
i386       buildonly-randconfig-004-20260817    gcc-12
i386       buildonly-randconfig-004-20260817    gcc-14
i386       buildonly-randconfig-005-20260817    clang-22
i386       buildonly-randconfig-005-20260817    gcc-12
i386       buildonly-randconfig-006-20260817    gcc-12
i386       buildonly-randconfig-006-20260817    gcc-14
i386                 randconfig-001-20260817    gcc-14
i386                 randconfig-002-20260817    gcc-14
i386                 randconfig-003-20260817    gcc-14
i386                 randconfig-004-20260817    gcc-14
i386                 randconfig-005-20260817    gcc-14
i386                 randconfig-006-20260817    gcc-14
i386                 randconfig-007-20260817    clang-22
i386                 randconfig-007-20260817    gcc-14
i386                 randconfig-011-20260817    clang-22
i386                 randconfig-011-20260817    gcc-13
i386                 randconfig-012-20260817    clang-22
i386                 randconfig-013-20260817    clang-22
i386                 randconfig-013-20260817    gcc-14
i386                 randconfig-014-20260817    clang-22
i386                 randconfig-014-20260817    gcc-14
i386                 randconfig-015-20260817    clang-22
i386                 randconfig-016-20260817    clang-22
i386                 randconfig-017-20260817    clang-22
i386                 randconfig-017-20260817    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260817    clang-24
loongarch            randconfig-001-20260817    gcc-8.5.0
loongarch            randconfig-001-20260818    gcc-10.5.0
loongarch            randconfig-002-20260817    clang-18
loongarch            randconfig-002-20260817    gcc-8.5.0
loongarch            randconfig-002-20260818    gcc-10.5.0
mips                        db1xxx_defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260817    gcc-8.5.0
nios2                randconfig-001-20260818    gcc-10.5.0
nios2                randconfig-002-20260817    gcc-8.5.0
nios2                randconfig-002-20260818    gcc-10.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-13.4.0
parisc               randconfig-001-20260817    gcc-12.5.0
parisc               randconfig-001-20260817    gcc-13.4.0
parisc               randconfig-001-20260818    clang-24
parisc               randconfig-002-20260817    gcc-13.4.0
parisc               randconfig-002-20260817    gcc-8.5.0
parisc               randconfig-002-20260818    clang-24
powerpc                     arches_defconfig    gcc-16.1.0
powerpc              randconfig-001-20260817    gcc-13.4.0
powerpc              randconfig-001-20260817    gcc-8.5.0
powerpc              randconfig-001-20260818    clang-24
powerpc              randconfig-002-20260817    clang-19
powerpc              randconfig-002-20260817    gcc-13.4.0
powerpc              randconfig-002-20260818    clang-24
powerpc64            randconfig-001-20260817    gcc-13.4.0
powerpc64            randconfig-001-20260818    clang-24
powerpc64            randconfig-002-20260817    clang-24
powerpc64            randconfig-002-20260817    gcc-13.4.0
powerpc64            randconfig-002-20260818    clang-24
riscv                randconfig-001-20260817    gcc-10.5.0
riscv                randconfig-001-20260817    gcc-13.4.0
riscv                randconfig-002-20260817    gcc-10.5.0
riscv                randconfig-002-20260817    gcc-11.5.0
s390                 randconfig-001-20260817    clang-17
s390                 randconfig-001-20260817    gcc-10.5.0
s390                 randconfig-002-20260817    gcc-10.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260817    gcc-10.5.0
sh                   randconfig-001-20260817    gcc-15.2.0
sh                   randconfig-002-20260817    gcc-10.5.0
sh                   randconfig-002-20260817    gcc-9.5.0
sparc                randconfig-001-20260817    gcc-16.1.0
sparc                randconfig-002-20260817    gcc-8.5.0
sparc64              randconfig-001-20260817    gcc-10.5.0
sparc64              randconfig-002-20260817    gcc-16.1.0
um                   randconfig-001-20260817    clang-24
um                   randconfig-002-20260817    clang-17
x86_64     buildonly-randconfig-001-20260817    clang-22
x86_64     buildonly-randconfig-001-20260817    gcc-14
x86_64     buildonly-randconfig-002-20260817    clang-22
x86_64     buildonly-randconfig-002-20260817    gcc-14
x86_64     buildonly-randconfig-003-20260817    gcc-14
x86_64     buildonly-randconfig-004-20260817    gcc-14
x86_64     buildonly-randconfig-005-20260817    clang-22
x86_64     buildonly-randconfig-005-20260817    gcc-14
x86_64     buildonly-randconfig-006-20260817    clang-22
x86_64     buildonly-randconfig-006-20260817    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260817    clang-22
x86_64               randconfig-002-20260817    clang-22
x86_64               randconfig-002-20260817    gcc-14
x86_64               randconfig-003-20260817    clang-22
x86_64               randconfig-003-20260817    gcc-14
x86_64               randconfig-004-20260817    clang-22
x86_64               randconfig-004-20260817    gcc-14
x86_64               randconfig-005-20260817    clang-22
x86_64               randconfig-006-20260817    clang-22
x86_64               randconfig-011-20260817    clang-22
x86_64               randconfig-012-20260817    clang-22
x86_64               randconfig-013-20260817    clang-22
x86_64               randconfig-013-20260817    gcc-14
x86_64               randconfig-014-20260817    clang-22
x86_64               randconfig-015-20260817    clang-22
x86_64               randconfig-016-20260817    clang-22
x86_64               randconfig-016-20260817    gcc-14
x86_64               randconfig-071-20260817    clang-22
x86_64               randconfig-072-20260817    clang-22
x86_64               randconfig-073-20260817    gcc-14
x86_64               randconfig-074-20260817    clang-22
x86_64               randconfig-075-20260817    clang-22
x86_64               randconfig-076-20260817    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260817    gcc-8.5.0
xtensa               randconfig-002-20260817    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
