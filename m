Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793030020;
	b=fFtlOdnRM6NNfljoE7f7PLMHqeudT0qgmrV7OaQBl1m3sY8kwxT97A24HSkLk7UuCXTj
	 QBppU9HZsVutcMIsCh41UMo82zf3/qRUzD41t3OL5xvIFilUwpgxbKR+uBMNXlGSPbWXc
	 YgFlztbTPeflSTOtfQQyJcqah7fynxNfyKQixZ4a4u4+VhpMfeEaVoAV6mgGxluxT8ldk
	 x4R0UJPmv2Te6ApDPPWWhWjlxOJPsTsv8z4zN4ghAs993wYr49NnJtJ+XQAFX36UA7HoW
	 298Ah7/M0C2s3zNddetKndHWYJF6gNM18fd3JnlTgfvmyTRcC0s1SMhRoYeNNIFYxRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793030020;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=VqxzS8fwgzLWYbePYKVt+w8xAcU28yr4TDFbVUA1IHc=;
	b=JR0vP9enSxycUebPNgD+FQ1T7X/T8XVdxUY9Q1YBpYyObDTtQxJAaitO39zXLlFExu/A
	 cSNFun6gyKf4Pu6ZE9+cencyf8neAhwau6dK6gi62LxEe/7Ce4l1ZdC5t/NOo0ie1qUYt
	 DN04yktnAmp2mwnq82zAip8R2/UpEkG2oh4b6O/dHDTkJ6/KJr242vziyeX1+gmlm/4IN
	 lmDxZuS6ATKIcm4ZcASfOZ4GvcEtbHN1WHoQ2FCVyo52ZRDe2GQgW+8DjV5MBue4kl1DS
	 aoiUXhES/ODImBuVMC27JhsqHqoX+OJhWH8oeYs7q+aG+XNTHjywkdLxDOjz3V8Vd9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FRq0znW1;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50FA606A31B
	for <mm-commits@vger.kernel.org>; Mon, 26 Oct 2026 15:53:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B50FA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FRq0znW1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793030018; x=1824566018;
  h=date:from:to:cc:subject:message-id;
  bh=V1LNmW1CHrNm69ucLl2xVsTweBKFJp7gHFdBmSZIikE=;
  b=FRq0znW15s/RaMEjBoZMT/fN2L1pyXJC7MMeIFhqa6mm0e2r7iVTgK6H
   4w3xPXJRWrBdm6AbEhEihm9zLapPli8/MrGNJEVhpZ/cWxw9FtNqbnO4M
   GxZr+d/6C7y9iQwGQ57WZXd/fUz8+B8Xeq5qE/JJJrF0kHd3cBMwPmdlS
   gYvd0jx525geApZqssAK+9RXaUgaEb2p8R0va2I89+BjGWvGgbwSgCQZ/
   Dach1hgpxWbicD1BR4AAPs8hsP8CztF2xoZz5JxfJRs6kBMMt8A/X4PNt
   5c+UV+F9rCSKa9wkOsc/dJCHzOow7a26MLVT6rFk9NxM6HGwodjBakAoX
   Q==;
X-CSE-ConnectionGUID: zkcEMxPcRue/REwyTyDciw==
X-CSE-MsgGUID: UPhgyeIuTxq71hlADWj3jA==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1708029"
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="1708029"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 08:53:37 -0700
X-CSE-ConnectionGUID: /CVOf7moT6O5j9eoSA81ZQ==
X-CSE-MsgGUID: +oJ5XFDwSBO1OPEUsD3iAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="4446541"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 26 Oct 2026 08:53:35 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLN0v-00000000WB0-0Opp;
	Mon, 26 Oct 2026 15:53:33 +0000
Date: Mon, 26 Oct 2026 23:53:11 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 73b6c575e9b3679e871df98b23758e90df2c6efa
Message-ID: <202610262301.ot4w6DSx-lkp@intel.com>
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
branch HEAD: 73b6c575e9b3679e871df98b23758e90df2c6efa  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1000m

configs tested: 158
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261026    gcc-11.5.0
arc                   randconfig-1001-20261026    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                           pxa910_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261026    gcc-13.5.0
arm                   randconfig-1001-20261026    gcc-15.3.0
arm                   randconfig-1002-20261026    gcc-13.5.0
arm                   randconfig-1003-20261026    clang-24
arm                     vt8500_v6_v7_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261026    clang-17
arm64                 randconfig-1001-20261026    gcc-14.4.0
arm64                 randconfig-1002-20261026    clang-24
arm64                 randconfig-1003-20261026    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261026    gcc-16.2.0
csky                  randconfig-1001-20261026    gcc-9.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261026    clang-24
hexagon               randconfig-1001-20261026    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261026    gcc-13
i386        buildonly-randconfig-1001-20261026    gcc-14
i386        buildonly-randconfig-1002-20261026    gcc-14
i386        buildonly-randconfig-1003-20261026    gcc-14
i386        buildonly-randconfig-1004-20261026    gcc-14
i386        buildonly-randconfig-1005-20261026    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261026    clang-22
i386                  randconfig-1001-20261026    gcc-14
i386                  randconfig-1002-20261026    gcc-14
i386                  randconfig-1003-20261026    gcc-14
i386                  randconfig-1004-20261026    gcc-13
i386                  randconfig-1005-20261026    clang-22
i386                  randconfig-1006-20261026    gcc-13
i386                  randconfig-1007-20261026    gcc-14
i386                  randconfig-1008-20261026    clang-22
i386                  randconfig-1009-20261026    clang-22
i386                  randconfig-1010-20261026    gcc-12
i386                  randconfig-1011-20261026    clang-22
i386                  randconfig-1012-20261026    gcc-14
i386                  randconfig-1013-20261026    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261026    clang-24
loongarch             randconfig-1001-20261026    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                 econet_en751221_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261026    gcc-11.5.0
nios2                 randconfig-1001-20261026    gcc-9.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261026    gcc-9.5.0
parisc                randconfig-1001-20261026    gcc-15.3.0
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                      mpc83xx_defconfig    clang-21
powerpc                      powernv_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261026    gcc-8.5.0
powerpc               randconfig-1001-20261026    gcc-8.5.0
powerpc64             randconfig-1000-20261026    clang-20
powerpc64             randconfig-1001-20261026    gcc-14.4.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261026    gcc-10.5.0
riscv                 randconfig-1001-20261026    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261026    clang-17
s390                  randconfig-1001-20261026    clang-24
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261026    gcc-15.3.0
sh                    randconfig-1001-20261026    gcc-13.5.0
sh                            se7722_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261026    gcc-8.5.0
sparc                 randconfig-1001-20261026    gcc-8.5.0
sparc                        sparc32_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261026    clang-24
sparc64               randconfig-1001-20261026    clang-24
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261026    clang-22
um                    randconfig-1001-20261026    gcc-14
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261026    gcc-14
x86_64      buildonly-randconfig-1001-20261026    clang-22
x86_64      buildonly-randconfig-1002-20261026    clang-22
x86_64      buildonly-randconfig-1003-20261026    clang-22
x86_64      buildonly-randconfig-1004-20261026    clang-22
x86_64      buildonly-randconfig-1005-20261026    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261026    clang-22
x86_64                randconfig-1001-20261026    clang-22
x86_64                randconfig-1002-20261026    clang-22
x86_64                randconfig-1003-20261026    gcc-13
x86_64                randconfig-1004-20261026    clang-22
x86_64                randconfig-1005-20261026    gcc-14
x86_64                randconfig-1006-20261026    clang-22
x86_64                randconfig-1007-20261026    gcc-14
x86_64                randconfig-1008-20261026    gcc-14
x86_64                randconfig-1009-20261026    clang-22
x86_64                randconfig-1010-20261026    clang-22
x86_64                randconfig-1011-20261026    gcc-14
x86_64                randconfig-1012-20261026    gcc-14
x86_64                randconfig-1013-20261026    gcc-14
x86_64                randconfig-1014-20261026    gcc-14
x86_64                randconfig-1015-20261026    clang-22
x86_64                randconfig-1016-20261026    gcc-14
x86_64                randconfig-1017-20261026    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                   audio_kc705_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261026    gcc-13.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
