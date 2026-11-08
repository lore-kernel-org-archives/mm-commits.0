Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794172061;
	b=3ccDel22cq7Ia/KkmiQtfirAhVi5lkCX8/n2rzojcjbyA88b92GVzsUXBeWjGumLphC2
	 cULZyZJy0FDVqpdc9JkWmfOnlk3Z55FlVEWSfx2mw3mh+DyCaQSMW84UGx7JT5O8g1o/M
	 JIXxWuyeTLnDPUCdHOr4XuABSUJIRRRtZTBfV8y8PgJHNYuShtSV3Bmi422TILXQf0eKk
	 dftbUJombVachrTIPtKKFte/okYc8BUGXHmc4iBB02dMPQ+X2MOmzh3+Tp/4yToXq0H8W
	 7SQ60MVaoEFU9VQI2mijfV9S6ZdjtD36oTF9rmLUZR/MJ3c21Tb429En1BTJCj2tUzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794172061;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=BMolsQJC9CetZ2XpcZ94BwZn4NnUxWw7RTHyDvRFIj0=;
	b=ZwfmrXKd2fbm9J8YsdAOy3a1qdNpYB+wN+yfQZda97dzEoo5m4jDu/pXhXBcNGZKPIu6
	 wEWKr9Q3wutctsyvNRMT3l9QBwaI6yP9VdZXwBYojwP7f+ia6FfJyQxvgYZP/ZKBHdvFw
	 cev6y1euJNwpyq3znCSOCwjTQRZd8Xhp5WLISeZ/UNhVbOYz0YqxDCC8CKX3ymhVqAW+z
	 dMozf2n1os+PsyHbujGFpcrRUJOIsS/W/Wc1dFc0ymlS/d6c+fI24cVjFVaQ/KNSQdg51
	 qD8YFLt0QAX4vUddWTk5XPGpff/mGR6BmjsFfF8H7/PjXaFPf8x0r2BMX8qrsVJyliw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fqV5y0Qr;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E26B606A322
	for <mm-commits@vger.kernel.org>; Sun,  8 Nov 2026 21:07:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E26B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fqV5y0Qr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794172058; x=1825708058;
  h=date:from:to:cc:subject:message-id;
  bh=0W5PIzKJjt/s6hHuIy1C1bJdlnEcFmVwPOcacXpEDRk=;
  b=fqV5y0QrvjikBVffR+sjbM5z6KqGeTefUfGR349/ZVWu2tdWklcQOg+b
   vJXV7YFZ3h5TwBXBxUkzl+D3olxHf8wlk2DBSCr4ID5mg8rJuFxJYU5Ud
   iWV7++0GWIC1aR0VTvp8SV7Cvvjg1XUjcGgNSmPEBxd3XYjeMvXZe5JMw
   wWWgLWIDzNtqNshznyBB+//uJ4qGSeoG4E2CbRlVyxLE0zzxMR77QgG5S
   n5V2oh5ap7FU9PvG/aXqDj1jrGpQP0Y10LnJE8nuK8AHSFUY0uWV7suuq
   9x5+TljSlRvjCIjs98UAbquOxfqf2cUE8oiO2+aBfo0hsZU8azxp7BtOc
   g==;
X-CSE-ConnectionGUID: O7S2G6SYQH6+32mptloFTw==
X-CSE-MsgGUID: B+u+D4xpQIqnKM7CqBK60g==
X-IronPort-AV: E=McAfee;i="6800,10657,11960"; a="2934272"
X-IronPort-AV: E=Sophos;i="6.27,202,1787036400"; 
   d="scan'208";a="2934272"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 13:07:37 -0800
X-CSE-ConnectionGUID: 8kNAcwHfTn2KBf7o3AMx6w==
X-CSE-MsgGUID: WWIl57W/RbOwbaDmdgXWrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,202,1787036400"; 
   d="scan'208";a="9488567"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 08 Nov 2026 13:07:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQA6v-00000000tOV-2Yyw;
	Sun, 08 Nov 2026 21:07:33 +0000
Date: Mon, 09 Nov 2026 05:07:27 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 2c5dafa7f289d760f4492260b0988029aab478b0
Message-ID: <20261109050727.MEJyNecu-lkp@intel.com>
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
branch HEAD: 2c5dafa7f289d760f4492260b0988029aab478b0  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1136m

configs tested: 236
configs skipped: 12

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
arc                   randconfig-1000-20261108    gcc-11.5.0
arc                   randconfig-1000-20261109    clang-24
arc                   randconfig-1001-20261108    gcc-11.5.0
arc                   randconfig-1001-20261109    clang-24
arc                         vdk_hs38_defconfig    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-1000-20261108    gcc-11.5.0
arm                   randconfig-1000-20261109    clang-24
arm                   randconfig-1001-20261108    gcc-11.5.0
arm                   randconfig-1001-20261109    clang-24
arm                   randconfig-1002-20261108    gcc-11.5.0
arm                   randconfig-1002-20261109    clang-24
arm                   randconfig-1003-20261108    gcc-11.5.0
arm                   randconfig-1003-20261109    clang-24
arm                         realview_defconfig    clang-19
arm                         vexpress_defconfig    clang-19
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261108    clang-24
arm64                 randconfig-1001-20261108    clang-24
arm64                 randconfig-1002-20261108    clang-24
arm64                 randconfig-1003-20261108    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261108    clang-24
csky                  randconfig-1001-20261108    clang-24
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261108    gcc-16.2.0
hexagon               randconfig-1001-20261108    gcc-16.2.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261108    clang-22
i386        buildonly-randconfig-1001-20261108    clang-22
i386        buildonly-randconfig-1002-20261108    clang-22
i386        buildonly-randconfig-1003-20261108    clang-22
i386        buildonly-randconfig-1004-20261108    clang-22
i386        buildonly-randconfig-1005-20261108    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261108    gcc-14
i386                  randconfig-1001-20261108    gcc-14
i386                  randconfig-1002-20261108    gcc-14
i386                  randconfig-1003-20261108    gcc-14
i386                  randconfig-1004-20261108    gcc-14
i386                  randconfig-1005-20261108    gcc-14
i386                  randconfig-1006-20261108    gcc-14
i386                  randconfig-1007-20261108    clang-22
i386                  randconfig-1008-20261108    clang-22
i386                  randconfig-1009-20261108    clang-22
i386                  randconfig-1010-20261108    clang-22
i386                  randconfig-1011-20261108    clang-22
i386                  randconfig-1012-20261108    clang-22
i386                  randconfig-1013-20261108    clang-22
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261108    gcc-16.2.0
loongarch             randconfig-1001-20261108    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                           hp300_defconfig    clang-19
m68k                           multi_defconfig    clang-19
m68k                             q40_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            gcw0_defconfig    clang-19
mips                             gpr_defconfig    clang-24
mips                   maltasmvp_eva_defconfig    gcc-16.2.0
mips                            xway_defconfig    clang-19
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261108    gcc-16.2.0
nios2                 randconfig-1001-20261108    gcc-16.2.0
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
parisc                randconfig-1000-20261108    clang-24
parisc                randconfig-1001-20261108    clang-24
parisc64                             defconfig    clang-24
powerpc                      akebono_defconfig    clang-19
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                    bluestone_defconfig    clang-19
powerpc                       ep88xc_defconfig    clang-24
powerpc                    microwatt_defconfig    gcc-16.2.0
powerpc                       ppc44x_defconfig    clang-19
powerpc                      rainier_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261108    clang-24
powerpc               randconfig-1001-20261108    clang-24
powerpc                      stx_gp3_defconfig    clang-19
powerpc                      stx_gp3_defconfig    clang-24
powerpc                      taishan_defconfig    clang-19
powerpc                      taishan_defconfig    clang-24
powerpc                       tqm8xx_defconfig    clang-24
powerpc64             randconfig-1000-20261108    clang-24
powerpc64             randconfig-1001-20261108    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv              nommu_k210_sdcard_defconfig    clang-19
riscv                 randconfig-1000-20261109    gcc-8.5.0
riscv                 randconfig-1001-20261109    gcc-8.5.0
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261109    gcc-8.5.0
s390                  randconfig-1001-20261109    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                         apsh4ad0a_defconfig    clang-19
sh                                   defconfig    gcc-14
sh                           r7780mp_defconfig    gcc-16.2.0
sh                           r7785rp_defconfig    clang-19
sh                    randconfig-1000-20261109    gcc-8.5.0
sh                    randconfig-1001-20261109    gcc-8.5.0
sh                           rsk7264_defconfig    gcc-16.2.0
sh                            se7722_defconfig    gcc-16.2.0
sh                              sh03_defconfig    gcc-16.2.0
sh                         sh7763rdp_defconfig    clang-19
sh                   sh7785lcr_32bit_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261108    gcc-8.5.0
sparc                 randconfig-1001-20261108    gcc-11.5.0
sparc                 randconfig-1001-20261108    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261108    clang-24
sparc64               randconfig-1000-20261108    gcc-8.5.0
sparc64               randconfig-1001-20261108    clang-24
sparc64               randconfig-1001-20261108    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261108    gcc-14
um                    randconfig-1000-20261108    gcc-8.5.0
um                    randconfig-1001-20261108    gcc-14
um                    randconfig-1001-20261108    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261108    gcc-14
x86_64      buildonly-randconfig-1001-20261108    gcc-14
x86_64      buildonly-randconfig-1002-20261108    gcc-14
x86_64      buildonly-randconfig-1003-20261108    gcc-14
x86_64      buildonly-randconfig-1004-20261108    gcc-14
x86_64      buildonly-randconfig-1005-20261108    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261108    gcc-14
x86_64                randconfig-1001-20261108    gcc-14
x86_64                randconfig-1002-20261108    gcc-14
x86_64                randconfig-1003-20261108    gcc-14
x86_64                randconfig-1004-20261108    gcc-14
x86_64                randconfig-1005-20261108    gcc-14
x86_64                randconfig-1006-20261108    clang-22
x86_64                randconfig-1007-20261108    clang-22
x86_64                randconfig-1008-20261108    clang-22
x86_64                randconfig-1009-20261108    clang-22
x86_64                randconfig-1010-20261108    clang-22
x86_64                randconfig-1011-20261108    clang-22
x86_64                randconfig-1012-20261108    clang-22
x86_64                randconfig-1013-20261108    clang-22
x86_64                randconfig-1014-20261108    clang-22
x86_64                randconfig-1015-20261108    clang-22
x86_64                randconfig-1016-20261108    clang-22
x86_64                randconfig-1017-20261108    clang-22
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
xtensa                           iss_defconfig    clang-24
xtensa                randconfig-1000-20261108    gcc-8.5.0
xtensa                randconfig-1001-20261108    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
