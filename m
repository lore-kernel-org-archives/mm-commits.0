Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0798042A80
	for <mm-commits@vger.kernel.org>; Sun,  2 Aug 2026 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785634736; cv=none; b=dn2AC8XuYWRaCnDEpmO4mztRJ3IP7KZf5KLbJ+Zj6PYmeECJw/EeSB3GaHEPmbzdiYAWs2V0clN36MdYdtqQVyzUTetuWgHjKaatdcrD4WDV+TE6ZotOdfvu8gFNTAFz1KeVzckbf5sbExVfZhvnwbdv9Q+Nh3C8/UyFOSJFbGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785634736; c=relaxed/simple;
	bh=hS10nZx5Hn0mGgHEEt2AXD26Xiyvngo2nHPew1Xm0Sg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=CzMgTu1VlJ8MhmtYQUcLhDPLjwI+vo8py3Sro3WJnabD/vbPWDJDw0vae09MKz1ESyMlbeeGs6RKtjNZbkO22wn289aHWnos4A3yQHKZwpJJZM2pd+JWLuX8ymMjq5qfSfEyVk3WltmNA3j6HfdHj15GPZk3l8e+yRPhtlyz/NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZzzEX6Zb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZzzEX6Zb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785634735; x=1817170735;
  h=date:from:to:cc:subject:message-id;
  bh=hS10nZx5Hn0mGgHEEt2AXD26Xiyvngo2nHPew1Xm0Sg=;
  b=ZzzEX6ZbrxLjiXLzkRBRlxCmDeQQ4j9hTc+6tlTNYbHgmMF6T5ozxHW1
   Ghd6NQ8SXW9ohnJx2WVK7qrUxfUthfDIgGwEMe2EvSfRVtlcl+OZ5LK1p
   GKZdC1wka6tDchkSu4IjTLqiBknebnP4YyIk9zpZceR9Fdsqy9jzJgU6N
   3/KtmAd6W8hrfWWKWS9V0GzxVn1IRV9RHXs5xOx154E55raTtRke/ukMK
   B84r37AcEzaOy3OgOwCAzMG7XP/DD2AIZ7W/lYfN+my4FMiBVYmOKYeok
   bmUWns+Yn96BaBiJAuprXG9b932WAZMcfYgkCq7y9VL2CGT/TtGJPZmYo
   A==;
X-CSE-ConnectionGUID: KNPbIQYLQZqPj9sTJwyHDA==
X-CSE-MsgGUID: rMRLQqzITn2Z2kTXTVo9+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11862"; a="96575757"
X-IronPort-AV: E=Sophos;i="6.25,199,1779174000"; 
   d="scan'208";a="96575757"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2026 18:38:55 -0700
X-CSE-ConnectionGUID: 5mnELcdQSY6EdwCplfUJwQ==
X-CSE-MsgGUID: mDxZVVnkSG2YJmumGepz3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,199,1779174000"; 
   d="scan'208";a="285519037"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 01 Aug 2026 18:38:52 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wqLA9-000000004Ej-3hke;
	Sun, 02 Aug 2026 01:38:49 +0000
Date: Sun, 02 Aug 2026 09:38:15 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 1dbd7c34bb92dd9c0b0363b75f6ec444299af108
Message-ID: <202608020900.F5dVXAQc-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1dbd7c34bb92dd9c0b0363b75f6ec444299af108  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 744m

configs tested: 181
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260801    gcc-14.3.0
arc                  randconfig-001-20260802    gcc-15.2.0
arc                  randconfig-002-20260801    gcc-12.5.0
arc                  randconfig-002-20260802    gcc-15.2.0
arm                  randconfig-001-20260801    clang-24
arm                  randconfig-001-20260802    gcc-15.2.0
arm                  randconfig-002-20260801    gcc-8.5.0
arm                  randconfig-002-20260802    gcc-15.2.0
arm                  randconfig-003-20260801    gcc-12.5.0
arm                  randconfig-003-20260802    gcc-15.2.0
arm                  randconfig-004-20260801    clang-18
arm                  randconfig-004-20260802    gcc-15.2.0
arm64                randconfig-001-20260802    gcc-9.5.0
arm64                randconfig-002-20260802    gcc-9.5.0
arm64                randconfig-003-20260802    gcc-9.5.0
arm64                randconfig-004-20260802    gcc-9.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260801    gcc-12.5.0
csky                 randconfig-001-20260802    gcc-9.5.0
csky                 randconfig-002-20260801    gcc-10.5.0
csky                 randconfig-002-20260802    gcc-9.5.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260801    clang-24
hexagon              randconfig-001-20260802    clang-24
hexagon              randconfig-002-20260801    clang-17
hexagon              randconfig-002-20260802    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260801    clang-22
i386       buildonly-randconfig-001-20260802    gcc-14
i386       buildonly-randconfig-002-20260801    clang-22
i386       buildonly-randconfig-002-20260802    gcc-14
i386       buildonly-randconfig-003-20260801    clang-22
i386       buildonly-randconfig-003-20260802    gcc-14
i386       buildonly-randconfig-004-20260801    clang-22
i386       buildonly-randconfig-004-20260802    gcc-14
i386       buildonly-randconfig-005-20260801    gcc-14
i386       buildonly-randconfig-005-20260802    gcc-14
i386       buildonly-randconfig-006-20260801    gcc-14
i386       buildonly-randconfig-006-20260802    gcc-14
i386                 randconfig-001-20260801    clang-22
i386                 randconfig-001-20260802    gcc-14
i386                 randconfig-002-20260801    gcc-14
i386                 randconfig-002-20260802    gcc-14
i386                 randconfig-003-20260801    clang-22
i386                 randconfig-003-20260802    gcc-14
i386                 randconfig-004-20260801    clang-22
i386                 randconfig-004-20260802    gcc-14
i386                 randconfig-005-20260801    clang-22
i386                 randconfig-005-20260802    gcc-14
i386                 randconfig-006-20260801    clang-22
i386                 randconfig-006-20260802    gcc-14
i386                 randconfig-007-20260801    clang-22
i386                 randconfig-007-20260802    gcc-14
i386                 randconfig-011-20260801    clang-22
i386                 randconfig-011-20260802    gcc-14
i386                 randconfig-012-20260801    gcc-14
i386                 randconfig-012-20260802    gcc-14
i386                 randconfig-013-20260801    gcc-14
i386                 randconfig-013-20260802    gcc-14
i386                 randconfig-014-20260801    clang-22
i386                 randconfig-014-20260802    gcc-14
i386                 randconfig-015-20260801    clang-22
i386                 randconfig-015-20260802    gcc-14
i386                 randconfig-016-20260801    gcc-14
i386                 randconfig-016-20260802    gcc-14
i386                 randconfig-017-20260801    clang-22
i386                 randconfig-017-20260802    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260801    clang-18
loongarch            randconfig-001-20260802    clang-24
loongarch            randconfig-002-20260801    gcc-16.1.0
loongarch            randconfig-002-20260802    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260801    gcc-8.5.0
nios2                randconfig-001-20260802    clang-24
nios2                randconfig-002-20260801    gcc-11.5.0
nios2                randconfig-002-20260802    clang-24
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260801    gcc-11.5.0
parisc               randconfig-001-20260802    gcc-14.3.0
parisc               randconfig-002-20260801    gcc-9.5.0
parisc               randconfig-002-20260802    gcc-14.3.0
powerpc                  bluestone_defconfig    clang-24
powerpc              randconfig-001-20260801    clang-20
powerpc              randconfig-001-20260802    gcc-14.3.0
powerpc              randconfig-002-20260801    gcc-10.5.0
powerpc              randconfig-002-20260802    gcc-14.3.0
powerpc64            randconfig-001-20260801    clang-24
powerpc64            randconfig-001-20260802    gcc-14.3.0
powerpc64            randconfig-002-20260801    clang-24
powerpc64            randconfig-002-20260802    gcc-14.3.0
riscv                randconfig-001-20260801    gcc-14.3.0
riscv                randconfig-001-20260802    gcc-13.4.0
riscv                randconfig-002-20260801    clang-20
riscv                randconfig-002-20260802    gcc-13.4.0
s390                 randconfig-001-20260801    gcc-15.2.0
s390                 randconfig-001-20260802    gcc-13.4.0
s390                 randconfig-002-20260801    clang-24
s390                 randconfig-002-20260802    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260801    gcc-16.1.0
sh                   randconfig-001-20260802    gcc-13.4.0
sh                   randconfig-002-20260801    gcc-16.1.0
sh                   randconfig-002-20260802    gcc-13.4.0
sh                          se7724_defconfig    gcc-16.1.0
sparc                randconfig-001-20260801    gcc-8.5.0
sparc                randconfig-001-20260802    gcc-12.5.0
sparc                randconfig-002-20260801    gcc-11.5.0
sparc                randconfig-002-20260802    gcc-12.5.0
sparc64              randconfig-001-20260801    gcc-9.5.0
sparc64              randconfig-001-20260802    gcc-12.5.0
sparc64              randconfig-002-20260801    gcc-15.2.0
sparc64              randconfig-002-20260802    gcc-12.5.0
um                   randconfig-001-20260801    clang-17
um                   randconfig-001-20260802    gcc-12.5.0
um                   randconfig-002-20260801    gcc-14
um                   randconfig-002-20260802    gcc-12.5.0
x86_64     buildonly-randconfig-001-20260801    clang-22
x86_64     buildonly-randconfig-001-20260802    gcc-12
x86_64     buildonly-randconfig-002-20260801    clang-22
x86_64     buildonly-randconfig-002-20260802    gcc-12
x86_64     buildonly-randconfig-003-20260801    gcc-13
x86_64     buildonly-randconfig-003-20260802    gcc-12
x86_64     buildonly-randconfig-004-20260801    clang-22
x86_64     buildonly-randconfig-004-20260802    gcc-12
x86_64     buildonly-randconfig-005-20260801    clang-22
x86_64     buildonly-randconfig-005-20260802    gcc-12
x86_64     buildonly-randconfig-006-20260801    clang-22
x86_64     buildonly-randconfig-006-20260802    gcc-12
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260801    clang-22
x86_64               randconfig-001-20260802    clang-22
x86_64               randconfig-002-20260801    gcc-14
x86_64               randconfig-002-20260802    clang-22
x86_64               randconfig-003-20260801    gcc-14
x86_64               randconfig-003-20260802    clang-22
x86_64               randconfig-004-20260801    clang-22
x86_64               randconfig-004-20260802    clang-22
x86_64               randconfig-005-20260801    gcc-14
x86_64               randconfig-005-20260802    clang-22
x86_64               randconfig-006-20260801    gcc-14
x86_64               randconfig-006-20260802    clang-22
x86_64               randconfig-011-20260801    clang-22
x86_64               randconfig-011-20260802    clang-22
x86_64               randconfig-012-20260801    gcc-14
x86_64               randconfig-012-20260802    clang-22
x86_64               randconfig-013-20260801    clang-22
x86_64               randconfig-013-20260802    clang-22
x86_64               randconfig-014-20260801    gcc-14
x86_64               randconfig-014-20260802    clang-22
x86_64               randconfig-015-20260801    clang-22
x86_64               randconfig-015-20260802    clang-22
x86_64               randconfig-016-20260801    clang-22
x86_64               randconfig-016-20260802    clang-22
x86_64               randconfig-071-20260801    gcc-14
x86_64               randconfig-071-20260802    gcc-12
x86_64               randconfig-072-20260801    gcc-14
x86_64               randconfig-072-20260802    gcc-12
x86_64               randconfig-073-20260801    clang-22
x86_64               randconfig-073-20260802    gcc-12
x86_64               randconfig-074-20260801    gcc-14
x86_64               randconfig-074-20260802    gcc-12
x86_64               randconfig-075-20260801    clang-22
x86_64               randconfig-075-20260802    gcc-12
x86_64               randconfig-076-20260801    clang-22
x86_64               randconfig-076-20260802    gcc-12
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260801    gcc-9.5.0
xtensa               randconfig-001-20260802    gcc-12.5.0
xtensa               randconfig-002-20260801    gcc-15.2.0
xtensa               randconfig-002-20260802    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
