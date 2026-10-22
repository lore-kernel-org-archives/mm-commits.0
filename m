Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792669561;
	b=nqBY2Gqw6/cf8Ho59ub806l9Wu0qRrM5VhEWNmwYH8QxZCMm6BQ7YpADvic9h7Fqb//Y
	 1W0umJKCqxxxGgKpxMy6GwA7P5xkfmlaF7pjWiPsR3hTQNSSqdVegOjkIUZMsctGRwcW6
	 9LNH7UVBpSgZMmd4vuv91TaMDGyc7icByNdLsuSKXMvGXCqm0LKQg9sHt6enaxdS5EH2r
	 zNQeA0aLZDtdP48xN7HhPwD3SzimjrneZW51MLxaj7pnFwdTQB4INazlc3lxFD37TqNyu
	 JQV45//4l8HjSqd7HkhS5PdVc3agb39ML8b5O28C0/MdaGnByPzmCSHJuA6KjwJx17g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792669561;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=USbtgh62wFC1WQ6cU2P1Xc6e6Ra4Ga/3qKN+14Dq2pQ=;
	b=hleyqS/oBejTSg3pbVU9QyFf870zsVvqbFntt6/HfMqcVi9DkR7z9kehxnKEMVvmkDoB
	 2hN9Obfc6Fn6jaB+WpoqjiZ1kPD2WVXZWAEqNwK0xAEfmD7gQMyt5A75dcCDH9dXoPF+8
	 nkYZ5kNXlMIleGZ1nipMFu9pULkWaWxq50FelFD98LuLW8dypRwvF/sARYQo4IdcI20Xx
	 102q9lc0ve88CfdnLfYeXWRQC9uqdXEO4PJ/qGT1ql2sFyxGlIo+tb/l/RxTeIqCjwbZZ
	 mzHUntuTXafZMzy8XQmVnQly8vROZBnM9QAIT23Z4KbffcvXJnMJGxnSQGiBCr+fkKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NM9EWUn9;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608FC606A31A
	for <mm-commits@vger.kernel.org>; Thu, 22 Oct 2026 11:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 608FC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NM9EWUn9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792669561; x=1824205561;
  h=date:from:to:cc:subject:message-id;
  bh=HKxHSVHqAYPZmYpFDbYDrsW4NXQmpQX1pMNdm1jLBBo=;
  b=NM9EWUn9fnfClrGTMvXAliZlm73iBy0RoiF2Xx7+Wqs2mrSLzuO/ICoT
   WsnxtmNZ1p5gEPgRyNFXq/7HrxTvVU8KO+ldinUY29aW14dCjWPMeRFtp
   AzfqHo8pVElUU7T/KDB83I3/MCEROovot8c8mftW8OsQvidScm1Sm8Neg
   y6DwePnV/7ggmE42JJCexwaR9A9oAJjEL/hRZWi2BuEFY5pq33u0zg5PW
   t+btT7OuDHo+sq/NhePseX7SFBXMFYutemRX6TUhvsVJHdlwdeyEsnaF6
   4QyNbKnGIYg1G9qLqTMArMiG0xMKTALFWilrCiZDsCoOB+S1cfLnpmVXC
   A==;
X-CSE-ConnectionGUID: b0wHsdGATMGEnQC1OlbPHg==
X-CSE-MsgGUID: s5v8FL4eRvukDPqTuu4FIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1424310"
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="1424310"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 04:46:00 -0700
X-CSE-ConnectionGUID: fc1UzM6aQ0u7TltgRva7Nw==
X-CSE-MsgGUID: k0aPXvojR7Gbvol0ptSk8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="3733808"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 22 Oct 2026 04:45:58 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xJrF5-00000000QzS-3xIi;
	Thu, 22 Oct 2026 11:45:55 +0000
Date: Thu, 22 Oct 2026 19:45:52 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
Message-ID: <202610221944.PBO9ny7O-lkp@intel.com>
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
branch HEAD: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1542m

configs tested: 162
configs skipped: 8

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
arc                   randconfig-1000-20261022    gcc-11.5.0
arc                   randconfig-1001-20261022    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                           collie_defconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                       integrator_defconfig    clang-24
arm                   randconfig-1000-20261022    gcc-10.5.0
arm                   randconfig-1001-20261022    clang-21
arm                   randconfig-1002-20261022    clang-17
arm                   randconfig-1003-20261022    clang-19
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261021    clang-21
arm64                 randconfig-1001-20261021    gcc-13.5.0
arm64                 randconfig-1002-20261021    clang-24
arm64                 randconfig-1003-20261021    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261021    gcc-16.2.0
csky                  randconfig-1001-20261021    gcc-10.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261021    clang-24
hexagon               randconfig-1001-20261021    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261021    gcc-14
i386        buildonly-randconfig-1001-20261021    gcc-14
i386        buildonly-randconfig-1002-20261021    gcc-14
i386        buildonly-randconfig-1003-20261021    clang-22
i386        buildonly-randconfig-1004-20261021    clang-22
i386        buildonly-randconfig-1005-20261021    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261021    clang-22
i386                  randconfig-1001-20261021    gcc-14
i386                  randconfig-1002-20261021    clang-22
i386                  randconfig-1003-20261021    gcc-14
i386                  randconfig-1004-20261021    gcc-14
i386                  randconfig-1005-20261021    clang-22
i386                  randconfig-1006-20261021    gcc-14
i386                  randconfig-1007-20261021    clang-22
i386                  randconfig-1008-20261021    gcc-12
i386                  randconfig-1009-20261021    gcc-14
i386                  randconfig-1010-20261021    clang-22
i386                  randconfig-1011-20261021    clang-22
i386                  randconfig-1012-20261021    clang-22
i386                  randconfig-1013-20261021    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261021    gcc-15.3.0
loongarch             randconfig-1001-20261021    clang-21
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                           multi_defconfig    gcc-16.2.0
m68k                          nettel_defconfig    gcc-16.2.0
m68k                           sun3x_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261021    gcc-11.5.0
nios2                 randconfig-1001-20261021    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261022    gcc-8.5.0
parisc                randconfig-1001-20261022    gcc-15.3.0
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                       chrp32_defconfig    clang-24
powerpc               randconfig-1000-20261022    gcc-14.4.0
powerpc               randconfig-1001-20261022    clang-24
powerpc64             randconfig-1000-20261022    gcc-12.5.0
powerpc64             randconfig-1001-20261022    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261021    gcc-13.5.0
riscv                 randconfig-1001-20261021    gcc-15.3.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261021    clang-24
s390                  randconfig-1001-20261021    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261021    gcc-16.2.0
sh                    randconfig-1001-20261021    gcc-10.5.0
sh                           rsk7203_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261021    gcc-16.2.0
sparc                 randconfig-1001-20261021    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261021    gcc-8.5.0
sparc64               randconfig-1001-20261021    gcc-11.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261021    clang-24
um                    randconfig-1001-20261021    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261021    gcc-14
x86_64      buildonly-randconfig-1001-20261021    gcc-12
x86_64      buildonly-randconfig-1002-20261021    gcc-14
x86_64      buildonly-randconfig-1003-20261021    gcc-14
x86_64      buildonly-randconfig-1004-20261021    clang-22
x86_64      buildonly-randconfig-1005-20261021    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261021    clang-22
x86_64                randconfig-1001-20261021    clang-22
x86_64                randconfig-1002-20261021    gcc-14
x86_64                randconfig-1003-20261021    gcc-14
x86_64                randconfig-1004-20261021    gcc-14
x86_64                randconfig-1005-20261021    clang-22
x86_64                randconfig-1006-20261021    gcc-14
x86_64                randconfig-1007-20261021    clang-22
x86_64                randconfig-1008-20261021    gcc-14
x86_64                randconfig-1009-20261021    gcc-14
x86_64                randconfig-1010-20261021    gcc-13
x86_64                randconfig-1011-20261021    clang-22
x86_64                randconfig-1012-20261021    gcc-14
x86_64                randconfig-1013-20261021    gcc-13
x86_64                randconfig-1014-20261021    clang-22
x86_64                randconfig-1015-20261021    gcc-14
x86_64                randconfig-1016-20261021    clang-22
x86_64                randconfig-1017-20261021    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261021    gcc-14.4.0
xtensa                randconfig-1001-20261021    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
