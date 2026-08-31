Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D89330F540
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 08:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788164176; cv=none; b=BAdcaEYJIUTFo5MM02SV0GR/sw2WBq1xAwslMujrle5gKZuojYLpf9qpvetkEm9NfQSF6gYI6Fxb7W1/pA3CO+NP+uyBm2Ju/vJLYTVl6yyn5SR6zrxboYU1ceaERHdsDudRUK4fOhXfj+KQcFHVamQtzbiSirR0w7N6v+dbEWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788164176; c=relaxed/simple;
	bh=0U702yJcbd24Mu5PvfVhwQ/Kix6w1KoMLIReavJw4Cs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=pY47gghNiQqshen8wfj9FB42OtUYqrpAgqy35LmZd1eG5BsXBge3nyLt/6Q/sahAsb0IZ7BbSpIqmmp5KGYUe441ZmHk+uIRRkSIilI1DK7jQapaVZB8xF+P5+QpioM0NiTbYgENkoY3xaiNjr3j9djbgUhDKiNBdTQOvjpWynE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=io7ADe37; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="io7ADe37"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788164174; x=1819700174;
  h=date:from:to:cc:subject:message-id;
  bh=0U702yJcbd24Mu5PvfVhwQ/Kix6w1KoMLIReavJw4Cs=;
  b=io7ADe37mTFtMU2mArqtfiEndTIq8IYeT1mRkNn7RG+9WhbF9A41+LyY
   L8sNyeZwX1pu1fb5iaHgI19If0lR+5ss3/oOOuY90MFANxmjE9At4Fa6j
   3ykqvrJeNbW3qEzRNIWa99T8AXQZSnzUoVC4LkYeQa/q4SYIvBZ1kqitX
   WkrDFNc0av7Zp8ngH4U8ZVNWEzU4Vkmzj3nsRpHPGxjAyrBr+gVJGFL13
   cmwfYJkQ3NatjQRFAwdlC3ddpWrAp199LH/lN3Fkv3p4XyaQ7BBc+5PW0
   Sh0GvOZ8cQL1zR9fHC1O923+2iWcOlNQtagPZpmP62UrMFQ4Y9xPkGTwo
   g==;
X-CSE-ConnectionGUID: H/LZHAr6R0CW9skpr/v4HQ==
X-CSE-MsgGUID: 2OA+FkXNSW6fhio5BdUhcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="100076775"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="100076775"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:16:13 -0700
X-CSE-ConnectionGUID: JA2LiJtbSeyyxboh5pUlzg==
X-CSE-MsgGUID: +z45bSEwQyug/K4UVqvIIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="274002441"
Received: from lkp-server01.sh.intel.com (HELO 12c799cf0c09) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 31 Aug 2026 01:16:10 -0700
Received: from kbuild by 12c799cf0c09 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0x9w-000000000NY-31uk;
	Mon, 31 Aug 2026 08:14:38 +0000
Date: Mon, 31 Aug 2026 15:51:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 da6c37ed8beb273e3308e42d4bca3ce11b4432fa
Message-ID: <202608311524.TNSAy5ID-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: da6c37ed8beb273e3308e42d4bca3ce11b4432fa  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 848m

configs tested: 166
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260831    gcc-8.5.0
arc                   randconfig-002-20260831    gcc-14.3.0
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                       aspeed_g5_defconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                   randconfig-001-20260831    clang-20
arm                   randconfig-002-20260831    gcc-16.1.0
arm                   randconfig-003-20260831    gcc-14.3.0
arm                   randconfig-004-20260831    gcc-16.1.0
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260831    gcc-16.1.0
arm64                 randconfig-002-20260831    clang-24
arm64                 randconfig-003-20260831    gcc-16.1.0
arm64                 randconfig-004-20260831    clang-21
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260831    gcc-16.1.0
csky                  randconfig-002-20260831    gcc-16.1.0
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                             defconfig    clang-24
hexagon               randconfig-001-20260831    clang-24
hexagon               randconfig-002-20260831    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260831    clang-22
i386        buildonly-randconfig-002-20260831    gcc-14
i386        buildonly-randconfig-003-20260831    clang-22
i386        buildonly-randconfig-004-20260831    gcc-14
i386        buildonly-randconfig-005-20260831    gcc-13
i386        buildonly-randconfig-006-20260831    clang-22
i386                                defconfig    clang-22
i386                  randconfig-001-20260831    clang-22
i386                  randconfig-002-20260831    clang-22
i386                  randconfig-003-20260831    clang-22
i386                  randconfig-004-20260831    gcc-14
i386                  randconfig-005-20260831    gcc-14
i386                  randconfig-006-20260831    gcc-14
i386                  randconfig-007-20260831    clang-22
i386                  randconfig-011-20260831    clang-22
i386                  randconfig-012-20260831    clang-22
i386                  randconfig-013-20260831    gcc-14
i386                  randconfig-014-20260831    gcc-14
i386                  randconfig-015-20260831    gcc-12
i386                  randconfig-016-20260831    gcc-14
i386                  randconfig-017-20260831    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch                loongson64_defconfig    clang-24
loongarch             randconfig-001-20260831    clang-24
loongarch             randconfig-002-20260831    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                          eyeq6_defconfig    clang-24
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260831    gcc-11.5.0
nios2                 randconfig-002-20260831    gcc-8.5.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260831    gcc-8.5.0
parisc                randconfig-002-20260831    gcc-15.2.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260831    clang-21
powerpc               randconfig-002-20260831    clang-21
powerpc64             randconfig-001-20260831    clang-24
powerpc64             randconfig-002-20260831    gcc-14.3.0
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                 randconfig-001-20260831    clang-17
riscv                 randconfig-002-20260831    gcc-8.5.0
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260831    clang-17
s390                  randconfig-002-20260831    clang-24
s390                       zfcpdump_defconfig    clang-22
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                          r7780mp_defconfig    gcc-16.1.0
sh                    randconfig-001-20260831    gcc-14.3.0
sh                    randconfig-002-20260831    gcc-16.1.0
sh                          sdk7780_defconfig    gcc-16.1.0
sh                           se7343_defconfig    gcc-16.1.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260831    gcc-11.5.0
sparc                 randconfig-002-20260831    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64               randconfig-001-20260831    gcc-15.2.0
sparc64               randconfig-002-20260831    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260831    clang-20
um                    randconfig-002-20260831    clang-20
um                           x86_64_defconfig    clang-24
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260831    gcc-14
x86_64      buildonly-randconfig-002-20260831    gcc-14
x86_64      buildonly-randconfig-003-20260831    gcc-13
x86_64      buildonly-randconfig-004-20260831    clang-22
x86_64      buildonly-randconfig-005-20260831    gcc-13
x86_64      buildonly-randconfig-006-20260831    clang-22
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260831    gcc-14
x86_64                randconfig-002-20260831    gcc-14
x86_64                randconfig-003-20260831    gcc-14
x86_64                randconfig-004-20260831    gcc-12
x86_64                randconfig-005-20260831    clang-22
x86_64                randconfig-006-20260831    gcc-14
x86_64                randconfig-011-20260831    clang-22
x86_64                randconfig-012-20260831    clang-22
x86_64                randconfig-013-20260831    gcc-14
x86_64                randconfig-014-20260831    clang-22
x86_64                randconfig-015-20260831    gcc-14
x86_64                randconfig-016-20260831    clang-22
x86_64                randconfig-071-20260831    clang-22
x86_64                randconfig-072-20260831    clang-22
x86_64                randconfig-073-20260831    gcc-14
x86_64                randconfig-074-20260831    clang-22
x86_64                randconfig-075-20260831    clang-22
x86_64                randconfig-076-20260831    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                       common_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260831    gcc-11.5.0
xtensa                randconfig-002-20260831    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
