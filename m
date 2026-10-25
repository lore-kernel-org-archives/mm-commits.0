Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792914167;
	b=ge5qCxPB0HTuWzA4ShF2I7O++PbmC4u6i4EePYltHQmtPtaq0Fvk7Sss7sV+SPPFzk50
	 Orkfl9la4whsFgnW8OKV6IG28RIhmt5n+rZTSlaD49jzFlzljQNUunPG5Sn0bq/BgUtJr
	 E1D6cSTSq2MkIqQLwkzFWeoRVHcGIjFo75vAFGr2pz811wqJDslRqxDBj0yCOPwMmjX0P
	 OqKXs/ZZF7XiPSj4BBfID5DMI3x0fMqnfPrfljtQauC72WuYe+cnP6UReFt9HKx+8Lu72
	 bcDmNqE2WiV//wrCeUwTjb6wTvtiLoXsqN6FpnECi3jI62HGGBhQhZjFm0VijpAQyJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792914167;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=UOamm9FXz+RobRXwLnxToUC0Y6UEC8OdlmShWJTdkvk=;
	b=PD3Kw8qItUYplX1TV2frN84RCYAFDSRHm2i/7uk6gWCN5zpcgH3NQ4K4YmKNj2yJ90NZ
	 VkSeiTFLgfZfqktxGNc0mhOe8T+TbWHweSPobTvZPjKU1BZen7scjtNJV8I2dDno6lO6M
	 R0dUGZSM78Ec97RjJ1v1Ju7vd3rw0OtwYQt5OiETtmoHUNCePsdPW320gJRNROKv8z+fn
	 gAXx+FevuV9doJY600Z6NPJdd8SL/jhxgU+XsYnc/BRFl0fW9rE1cI+i5RCf6TZw/TFBF
	 4TDk4kbufSxV4UsftV6RjqQSSRr5l5LIWi4/tobkMC0IPJbHG65lzthKaNzR6HLbPpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Jws1xh4l;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0D1606A31A
	for <mm-commits@vger.kernel.org>; Sun, 25 Oct 2026 07:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB0D1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Jws1xh4l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792914165; x=1824450165;
  h=date:from:to:cc:subject:message-id;
  bh=w3qrypn9AR07EOCVuR0E3CRcksGJr7htkZiZcW23iDY=;
  b=Jws1xh4l7b1l5s6xowA+MsBJcXCCyww+guK+rZtPNCRtxJPRLbhXp0Fy
   9czP8aaLsln3SGv9y5Ek1lCs0QZII+FoNI18UaevY7hkvS03vZ3pLtajL
   MMHfTTxsOkG3skEMpTC1pJy4CiI05Zh23PqCQ381E41mADYiTVs/0uzQu
   CIA3ufDQVFHjqsm5FYPG+72ag4bI0PwmQwKUijqlxQuA4DwoVi3tsKKLq
   anYiy6vGkvvm0IS8XxaLKWalgS9T7NwcjgHtMge/ifNbvPJGVH+jV6VOm
   Cn4U0Iyy8T2UY7ZSa6yler+bu8Zogo/6Xro+h3fbh5ZuMN50EeFaCS/fV
   w==;
X-CSE-ConnectionGUID: U5DQXKSWSK2yHrZ5fIFQ1A==
X-CSE-MsgGUID: 1O18PO57See8S0jz0fRUlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11945"; a="1480001"
X-IronPort-AV: E=Sophos;i="6.27,177,1787036400"; 
   d="scan'208";a="1480001"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 00:42:45 -0700
X-CSE-ConnectionGUID: CyKTLklPR06WojuShqD8OA==
X-CSE-MsgGUID: W3FI8CxWRu6FJqDVhMxDaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,177,1787036400"; 
   d="scan'208";a="4367660"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 25 Oct 2026 00:42:42 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKssJ-00000000UeQ-0K3X;
	Sun, 25 Oct 2026 07:42:39 +0000
Date: Sun, 25 Oct 2026 15:42:01 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 09e0a4f618cb8159c993d3140914523fe5d4dfee
Message-ID: <202610251552.ddrndIJh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 09e0a4f618cb8159c993d3140914523fe5d4dfee  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1150m

configs tested: 245
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261025    clang-24
arc                   randconfig-1001-20261025    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                       footbridge_defconfig    gcc-16.2.0
arm                          mv78xx0_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261025    clang-24
arm                   randconfig-1001-20261025    clang-24
arm                   randconfig-1002-20261025    clang-24
arm                   randconfig-1003-20261025    clang-24
arm                        spear13xx_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261024    clang-24
arm64                 randconfig-1000-20261025    clang-24
arm64                 randconfig-1001-20261024    clang-24
arm64                 randconfig-1001-20261025    clang-24
arm64                 randconfig-1002-20261024    gcc-10.5.0
arm64                 randconfig-1002-20261025    clang-24
arm64                 randconfig-1003-20261024    clang-19
arm64                 randconfig-1003-20261025    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261024    gcc-16.2.0
csky                  randconfig-1000-20261025    clang-24
csky                  randconfig-1001-20261024    gcc-11.5.0
csky                  randconfig-1001-20261025    clang-24
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261025    clang-24
hexagon               randconfig-1001-20261025    clang-24
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261025    gcc-14
i386        buildonly-randconfig-1001-20261025    gcc-14
i386        buildonly-randconfig-1002-20261025    gcc-14
i386        buildonly-randconfig-1003-20261025    gcc-14
i386        buildonly-randconfig-1004-20261025    gcc-14
i386        buildonly-randconfig-1005-20261025    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261024    clang-22
i386                  randconfig-1000-20261025    clang-22
i386                  randconfig-1001-20261024    clang-22
i386                  randconfig-1001-20261025    clang-22
i386                  randconfig-1002-20261024    clang-22
i386                  randconfig-1002-20261025    clang-22
i386                  randconfig-1003-20261024    gcc-14
i386                  randconfig-1003-20261025    clang-22
i386                  randconfig-1004-20261024    clang-22
i386                  randconfig-1004-20261025    clang-22
i386                  randconfig-1005-20261024    gcc-13
i386                  randconfig-1005-20261025    clang-22
i386                  randconfig-1006-20261024    gcc-14
i386                  randconfig-1006-20261025    clang-22
i386                  randconfig-1007-20261024    gcc-14
i386                  randconfig-1007-20261025    gcc-14
i386                  randconfig-1008-20261024    gcc-14
i386                  randconfig-1008-20261025    gcc-14
i386                  randconfig-1009-20261024    gcc-14
i386                  randconfig-1009-20261025    gcc-14
i386                  randconfig-1010-20261024    clang-22
i386                  randconfig-1010-20261025    gcc-14
i386                  randconfig-1011-20261024    clang-22
i386                  randconfig-1011-20261025    gcc-14
i386                  randconfig-1012-20261024    gcc-14
i386                  randconfig-1012-20261025    gcc-14
i386                  randconfig-1013-20261024    clang-22
i386                  randconfig-1013-20261025    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261025    clang-24
loongarch             randconfig-1001-20261025    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                   decstation_64_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261025    clang-24
nios2                 randconfig-1001-20261025    clang-24
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261024    gcc-15.3.0
parisc                randconfig-1000-20261025    clang-24
parisc                randconfig-1001-20261024    gcc-8.5.0
parisc                randconfig-1001-20261025    clang-24
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261024    gcc-12.5.0
powerpc               randconfig-1000-20261025    clang-24
powerpc               randconfig-1001-20261024    gcc-14.4.0
powerpc               randconfig-1001-20261025    clang-24
powerpc                      tqm8555_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261024    clang-19
powerpc64             randconfig-1000-20261025    clang-24
powerpc64             randconfig-1001-20261024    clang-24
powerpc64             randconfig-1001-20261025    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261025    gcc-10.5.0
riscv                 randconfig-1001-20261025    gcc-10.5.0
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261025    gcc-10.5.0
s390                  randconfig-1001-20261025    gcc-10.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                           polaris_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261025    gcc-10.5.0
sh                    randconfig-1001-20261025    gcc-10.5.0
sh                            se7712_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261025    gcc-14
sparc                 randconfig-1001-20261025    gcc-14
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261025    gcc-14
sparc64               randconfig-1001-20261025    gcc-14
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261025    gcc-14
um                    randconfig-1001-20261025    gcc-14
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261025    gcc-14
x86_64      buildonly-randconfig-1001-20261025    gcc-14
x86_64      buildonly-randconfig-1002-20261025    gcc-14
x86_64      buildonly-randconfig-1003-20261025    gcc-14
x86_64      buildonly-randconfig-1004-20261025    gcc-14
x86_64      buildonly-randconfig-1005-20261025    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261024    clang-22
x86_64                randconfig-1000-20261024    gcc-14
x86_64                randconfig-1001-20261024    gcc-14
x86_64                randconfig-1002-20261024    gcc-14
x86_64                randconfig-1003-20261024    gcc-14
x86_64                randconfig-1004-20261024    clang-22
x86_64                randconfig-1004-20261024    gcc-14
x86_64                randconfig-1005-20261024    gcc-14
x86_64                randconfig-1006-20261024    gcc-14
x86_64                randconfig-1006-20261025    clang-22
x86_64                randconfig-1007-20261024    gcc-13
x86_64                randconfig-1007-20261025    clang-22
x86_64                randconfig-1008-20261024    gcc-14
x86_64                randconfig-1008-20261025    clang-22
x86_64                randconfig-1009-20261024    clang-22
x86_64                randconfig-1009-20261025    clang-22
x86_64                randconfig-1010-20261024    gcc-14
x86_64                randconfig-1010-20261025    clang-22
x86_64                randconfig-1011-20261024    clang-22
x86_64                randconfig-1011-20261025    clang-22
x86_64                randconfig-1012-20261024    gcc-14
x86_64                randconfig-1012-20261025    clang-22
x86_64                randconfig-1013-20261024    clang-22
x86_64                randconfig-1013-20261025    clang-22
x86_64                randconfig-1014-20261024    clang-22
x86_64                randconfig-1014-20261025    clang-22
x86_64                randconfig-1015-20261024    clang-22
x86_64                randconfig-1015-20261025    clang-22
x86_64                randconfig-1016-20261024    clang-22
x86_64                randconfig-1016-20261025    clang-22
x86_64                randconfig-1017-20261024    clang-22
x86_64                randconfig-1017-20261025    clang-22
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261025    gcc-14
xtensa                randconfig-1001-20261025    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
