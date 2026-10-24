Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792833070;
	b=o83YaxnrX3oRcXcZQ1Q4N/GcGH+Is/1Pr09knmMxPc52ugnVaeinI6QcdILPLaWWSr6K
	 2ykHU5k2AgRUpHoLnwIc8jPVduoDwc4USt9KV47HlNrPJHoPkc0uPV+y34DkfDC9hOLEG
	 U3LCdoNWt3naNdsI+LmKJlnIFhG2B2FRngJu/PgaRjT2PLuzcoMikP5PvtG5cWw4F0s05
	 lnGpad5ZN7HeWGQh/JWcOC+9llJUNqMW5oxLYlDyboQfroilpu+BDuAdW6/hMSw4OD8yw
	 TayTB/APc9XIC/PKJ4LdjBXE5NH8AYdxgVF4KboQPelW1riypppbgs2PEsQhwygGmdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792833070;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=+kvFalUR9ocw39ncWjk9hYOuY18oIedH9wIuk1qbQ8I=;
	b=2V/cBVPayVhTnAsSK6O2h3KD7MYD9vRMg5ebvAZIMws+/i7rtr5hR1a1Ilt3riitmn3h
	 JxcBxnYpTkS4ZNPZ+hdbHt4XFtUbBpkgRf0CHJiKST1rMnruFAvx8YQZZyj3LcTzMvAia
	 E+mD3lb3CAtDMYBsdJGSHFWWOkRpOlDOaZZXwdwpE64Turvdcw62anJvvq7M1tidRmBDR
	 37BTDIAwCh4oxVDjn+8eCb579277nJU52IUAj4r2wh2XOh4Y5Ac6ef8lsWQSC3nEL+0Es
	 ZA5Ptpa6rqj4pTfZe/Em1XKmuFAKf4EmsYldiS4kVGyFURbQy+7I4v87ulX4Xva26Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j0R5H7zu;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BED6606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BED6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j0R5H7zu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792833069; x=1824369069;
  h=date:from:to:cc:subject:message-id;
  bh=dWmbJf3qKZcmJWnouZwfjdmVDZovyLdezGpiUmsPyF4=;
  b=j0R5H7zuZUIIsbjG8EGgiReSdnJfMOWpjbCCZbR7OBfhDY0SnNBv9MUf
   Ag2WHRU+rHfthnfUZxcYnzFQULUWQHgTt4hJnOdqCFAT9xk16BA985HAv
   afEA/b9VhQs0rFlc9nv8pcLSu9gRfODUUNKKabgJKgtRCssWb8U9GZucv
   hV4MWXGBw9t6ig4fxyAnU+HvaG8vNa/93eydeancPRdtB1LRa5H/y9cHA
   m9JEpTbSTzZJ6yzKnSbXzci4iyqVu1E8Yaz9oDcCF53S+sCyzf9ZJXmed
   v2IJHSOiewtC69X6Vr0o7vg4ydToyrw/y8vz/esSW6LFEO+YtI7kqbtno
   g==;
X-CSE-ConnectionGUID: u93866kOSASbIzlqLNDNuw==
X-CSE-MsgGUID: hTP900qJSFCFRfsNmPEgJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1596671"
X-IronPort-AV: E=Sophos;i="6.27,176,1787036400"; 
   d="scan'208";a="1596671"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2026 02:11:09 -0700
X-CSE-ConnectionGUID: rIe/DfWcRmCgxfTY0Tb8Rg==
X-CSE-MsgGUID: lJP3SIZvTsOB8+AaK68n4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,176,1787036400"; 
   d="scan'208";a="4227639"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 24 Oct 2026 02:11:06 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKXmJ-00000000TjW-293X;
	Sat, 24 Oct 2026 09:11:03 +0000
Date: Sat, 24 Oct 2026 17:10:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 3fdcce698abd9193752ee89fb1a440cdceb1b74a
Message-ID: <202610241712.y3nMZLnk-lkp@intel.com>
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
branch HEAD: 3fdcce698abd9193752ee89fb1a440cdceb1b74a  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1222m

configs tested: 159
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
arc                   randconfig-1000-20261023    gcc-8.5.0
arc                   randconfig-1001-20261023    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261023    clang-24
arm                   randconfig-1001-20261023    gcc-8.5.0
arm                   randconfig-1002-20261023    clang-17
arm                   randconfig-1003-20261023    gcc-14.4.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261023    clang-20
arm64                 randconfig-1001-20261023    gcc-8.5.0
arm64                 randconfig-1002-20261023    gcc-8.5.0
arm64                 randconfig-1003-20261023    gcc-15.3.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1001-20261023    gcc-12.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261023    clang-24
hexagon               randconfig-1001-20261023    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261024    gcc-14
i386        buildonly-randconfig-1001-20261024    clang-22
i386        buildonly-randconfig-1002-20261024    clang-22
i386        buildonly-randconfig-1003-20261024    gcc-14
i386        buildonly-randconfig-1004-20261024    gcc-14
i386        buildonly-randconfig-1005-20261024    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261024    clang-22
i386                  randconfig-1001-20261024    clang-22
i386                  randconfig-1002-20261024    clang-22
i386                  randconfig-1003-20261024    gcc-14
i386                  randconfig-1004-20261024    clang-22
i386                  randconfig-1005-20261024    gcc-13
i386                  randconfig-1006-20261024    gcc-14
i386                  randconfig-1007-20261024    gcc-14
i386                  randconfig-1008-20261024    gcc-14
i386                  randconfig-1009-20261024    gcc-14
i386                  randconfig-1010-20261024    clang-22
i386                  randconfig-1011-20261024    clang-22
i386                  randconfig-1012-20261024    gcc-14
i386                  randconfig-1013-20261024    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261023    gcc-13.5.0
loongarch             randconfig-1001-20261023    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                           atari_defconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                         m5307c3_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           eyeq5_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261023    gcc-10.5.0
nios2                 randconfig-1001-20261023    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261024    gcc-15.3.0
parisc                randconfig-1001-20261024    gcc-8.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                    motionpro_defconfig    clang-24
powerpc                  mpc8313_rdb_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261024    gcc-12.5.0
powerpc               randconfig-1001-20261024    gcc-14.4.0
powerpc64             randconfig-1000-20261024    clang-19
powerpc64             randconfig-1001-20261024    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261023    gcc-8.5.0
riscv                 randconfig-1001-20261023    gcc-13.5.0
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261023    gcc-8.5.0
s390                  randconfig-1001-20261023    gcc-9.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                 ecovec24-romimage_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261023    gcc-10.5.0
sh                    randconfig-1001-20261023    gcc-16.2.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sh                               ul2_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261024    gcc-16.2.0
sparc                 randconfig-1001-20261024    gcc-15.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261024    clang-24
sparc64               randconfig-1001-20261024    clang-24
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261024    gcc-14
um                    randconfig-1001-20261024    gcc-14
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261024    clang-22
x86_64      buildonly-randconfig-1001-20261024    gcc-14
x86_64      buildonly-randconfig-1002-20261024    clang-22
x86_64      buildonly-randconfig-1003-20261024    gcc-14
x86_64      buildonly-randconfig-1004-20261024    clang-22
x86_64      buildonly-randconfig-1005-20261024    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261023    gcc-12
x86_64                randconfig-1001-20261023    gcc-14
x86_64                randconfig-1002-20261023    gcc-14
x86_64                randconfig-1003-20261023    clang-22
x86_64                randconfig-1004-20261023    gcc-12
x86_64                randconfig-1005-20261023    clang-22
x86_64                randconfig-1006-20261023    clang-22
x86_64                randconfig-1007-20261023    gcc-14
x86_64                randconfig-1008-20261023    gcc-14
x86_64                randconfig-1009-20261023    clang-22
x86_64                randconfig-1010-20261023    clang-22
x86_64                randconfig-1011-20261023    clang-22
x86_64                randconfig-1012-20261024    gcc-14
x86_64                randconfig-1013-20261024    clang-22
x86_64                randconfig-1014-20261024    clang-22
x86_64                randconfig-1015-20261024    clang-22
x86_64                randconfig-1016-20261024    clang-22
x86_64                randconfig-1017-20261024    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                randconfig-1000-20261024    gcc-15.3.0
xtensa                randconfig-1001-20261024    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
