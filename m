Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793301382;
	b=Phq4iaekEs5nXep6jQfiEx8r/M8RQdiFCMnw0sEJiPdGOY5I0wpUvbql+6t8JEIpGdZH
	 s2hjRAFiv8KFhr8cDa/7KaRrelIoDJK6NWzIECxFyFrvla45XLiaRBvCWRssIACRY0M76
	 LjY577t/ctZnBRnEui/HFRqmkq3NrrQUwG92Rx2il95dbOU/9fF7D9Lx9aTGD+xD/llPD
	 BsC6HilezIxqt7IzAJQnFn7RFyNTauoHLlGd0pXLvBE6BBIYUYBEgGVpPRF+qSd1hGtMI
	 hEkTNGsWU7YRYJKj4wmgf0U3U0iRxXEgwlJcyzxqwLfg9a2TviR13YImnl/I9t24JjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793301382;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=EyacNsi1Pt7KRWo4B0P5Lt5n3rqa086gdIoleJ+a8Fk=;
	b=YqqZR/cE3JO5X4SdQzsaOFkKLVVLh2lyky934+WcAiyIy17pwG2HGLGA3p0xq/hd/tCU
	 TXuwOEnKJECh4R+ds12/SbsnTCBPp/v8k2iblrBGVp/Cn9dulyBVA83Gzr3uJW7mvM89K
	 yGdJJ2bQO4Om1javmF0KRW/zAQLuNBfrT3YlZbK1lGavuVwU2LgsY0EqwKlximEMkPK63
	 cJQHDsvrzgpuGkyBYZV+O1CPD3NnguYuQDDRS5LbGqzoYJT+D5EtYSe2LYqVpkstq1/Ff
	 sBHfs5m2jsi8ii1g+krUK5veCfFy02rqsXLASuTdg0cqOHITlwqCTS0MEhMSKq8o2HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dRDbvHT1;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E683D606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 19:16:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E683D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dRDbvHT1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793301379; x=1824837379;
  h=date:from:to:cc:subject:message-id;
  bh=jsZRERdKptpSe6ii8cQ8wuzPMMnwBRoNoKRHsz+QgeM=;
  b=dRDbvHT1W3sWgXXp8QRYPaVoXsMMIRKy6Y6CzTE/1NgKIL4CDCO+YQcK
   bqZipW65+4zeb5dT8PV4E18sJZxQhAWnAHaUpnTO8uazBIKCifbc9DQGM
   w33JjZt1yQDEovrdW0dsW/FUMFUBUvG+5EfCI2o5GN0qQ6gnJcQLUNSF1
   GqR2+SF4eDegl7uCG3JWF9mkv6bwlSWjlc9BwsRDwHa94Plv/Ot+iptFm
   +T7rVInJhWr/oIpFvuXKFnR3pvBOCh35EK4IyMHnE9cDIyZjgtbPAf25D
   15GIutcaN81TAMLMVuXweTDLBD0TaE/9KN0vX+pqHPsB8NzNvux1Qfqzq
   w==;
X-CSE-ConnectionGUID: 6DRMxj3EQhuHmvH7FAi6bA==
X-CSE-MsgGUID: 0bEsHk+xR5SdXKOk4RbZvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="1934634"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="1934634"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 12:15:27 -0700
X-CSE-ConnectionGUID: ypNkN7bPQL+P1zWGngso8g==
X-CSE-MsgGUID: iNogW8XYRYSQ0/pNyC0klA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="7005490"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 29 Oct 2026 12:15:25 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMVas-00000000ar2-1hY6;
	Thu, 29 Oct 2026 19:15:22 +0000
Date: Fri, 30 Oct 2026 03:14:53 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 d865f2677c44cb2171b833d6775cf692756fa8be
Message-ID: <202610300349.tvbNgoYB-lkp@intel.com>
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
branch HEAD: d865f2677c44cb2171b833d6775cf692756fa8be  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1046m

configs tested: 155
configs skipped: 8

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261029    gcc-12.5.0
arc                   randconfig-1001-20261029    gcc-14.4.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                          assabet_defconfig    clang-22
arm                                  defconfig    clang-24
arm                         mvebu_v5_defconfig    gcc-16.2.0
arm                        netwinder_defconfig    gcc-16.2.0
arm                          orion5x_defconfig    clang-21
arm                   randconfig-1000-20261029    clang-22
arm                   randconfig-1001-20261029    clang-18
arm                   randconfig-1002-20261029    clang-19
arm                   randconfig-1003-20261029    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261029    gcc-11.5.0
arm64                 randconfig-1001-20261029    clang-24
arm64                 randconfig-1002-20261029    gcc-8.5.0
arm64                 randconfig-1003-20261029    gcc-13.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261029    gcc-16.2.0
csky                  randconfig-1001-20261029    gcc-10.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261029    clang-22
hexagon               randconfig-1001-20261029    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261029    clang-22
i386        buildonly-randconfig-1001-20261029    clang-22
i386        buildonly-randconfig-1002-20261029    gcc-14
i386        buildonly-randconfig-1003-20261029    gcc-14
i386        buildonly-randconfig-1004-20261029    gcc-14
i386        buildonly-randconfig-1005-20261029    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261029    gcc-14
i386                  randconfig-1001-20261029    gcc-14
i386                  randconfig-1002-20261029    clang-22
i386                  randconfig-1003-20261029    clang-22
i386                  randconfig-1004-20261029    gcc-14
i386                  randconfig-1005-20261029    clang-22
i386                  randconfig-1006-20261029    clang-22
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261029    clang-20
loongarch             randconfig-1001-20261029    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            ip30_defconfig    gcc-16.2.0
nios2                             alldefconfig    gcc-11.5.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261029    gcc-8.5.0
nios2                 randconfig-1001-20261029    gcc-10.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261029    gcc-14.4.0
parisc                randconfig-1001-20261029    gcc-8.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                  mpc832x_rdb_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261029    clang-17
powerpc               randconfig-1001-20261029    gcc-15.3.0
powerpc64             randconfig-1000-20261029    gcc-15.3.0
powerpc64             randconfig-1001-20261029    clang-17
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261029    gcc-13.5.0
riscv                 randconfig-1001-20261029    gcc-15.3.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261029    clang-24
s390                  randconfig-1001-20261029    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261029    gcc-12.5.0
sh                    randconfig-1001-20261029    gcc-10.5.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261029    gcc-16.2.0
sparc                 randconfig-1001-20261029    gcc-14.4.0
sparc                        sparc32_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261029    clang-24
sparc64               randconfig-1001-20261029    gcc-15.3.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261029    clang-18
um                    randconfig-1001-20261029    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261029    gcc-12
x86_64      buildonly-randconfig-1001-20261029    gcc-14
x86_64      buildonly-randconfig-1002-20261029    clang-22
x86_64      buildonly-randconfig-1003-20261029    gcc-14
x86_64      buildonly-randconfig-1004-20261029    gcc-14
x86_64      buildonly-randconfig-1005-20261029    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261029    clang-22
x86_64                randconfig-1001-20261029    gcc-14
x86_64                randconfig-1002-20261029    clang-22
x86_64                randconfig-1003-20261029    clang-22
x86_64                randconfig-1004-20261029    gcc-14
x86_64                randconfig-1005-20261029    gcc-14
x86_64                randconfig-1006-20261029    gcc-14
x86_64                randconfig-1007-20261029    gcc-14
x86_64                randconfig-1008-20261029    gcc-14
x86_64                randconfig-1009-20261029    gcc-14
x86_64                randconfig-1010-20261029    gcc-13
x86_64                randconfig-1011-20261029    gcc-14
x86_64                randconfig-1012-20261029    gcc-14
x86_64                randconfig-1013-20261029    clang-22
x86_64                randconfig-1014-20261029    clang-22
x86_64                randconfig-1015-20261029    clang-22
x86_64                randconfig-1016-20261029    clang-22
x86_64                randconfig-1017-20261029    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261029    gcc-14.4.0
xtensa                randconfig-1001-20261029    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
