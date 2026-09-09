Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9EC3B585F
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788991001; cv=none; b=B6LaXYvTTOZEUpZmVv+Of3HBkihG1ymU18y1FNb1APlqKdJm/kbQ5hktPD4VkmetLTgdfHyJt2pvuPJDxoet2Dqc2cPndGKcHVK8qktrGJ/LSkpVlcWfim7YSBbouplrUh8OPgWGIPSS66Le5XoL4DJGwV3ZBlBoFfhnM3YYlDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788991001; c=relaxed/simple;
	bh=FfcwknCvOB14lwM6tB+YRx4KGEn8x/b3vHavrs0EThc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Eeh5mCOACEfz3VSDtzy/ihV8agFyELuiNRJdpQhLTnaJnUssqIw5zRPZWviAYo7gq1b7bubtrvuaYmCEfSR0moHK9pEbbkNIbHFsJNnqqNDkFmJlJvcZ1+33TQqksC/YovzNH3CtevLANoPnsHSb1869UshUsVbVkW6fIOAg24U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LUjPZJC2; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LUjPZJC2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788990999; x=1820526999;
  h=date:from:to:cc:subject:message-id;
  bh=FfcwknCvOB14lwM6tB+YRx4KGEn8x/b3vHavrs0EThc=;
  b=LUjPZJC2VNHegsRy/q5x1IekkqYuzRy+lNPTIl2idBdThyZMfyVhIEyT
   omxPF71HFbGeogeNRHg2jLYJiqJ6y2nU4zzJxC8B4Qy822XeOlcqzkWs6
   x/cDhXeL+9/wS7DLzvkpQONHcd822nCObDEo42Vo8gb0e9zztOcJ9+CG0
   PON6eQgkTZCILr5XTF4nJ+dNhwBs/JpYTU2PLQmKbtqShk1hnMdGHlfCS
   4kWYSQaPWBrst8UPAMYr98+ygiE949lJsedywyQ20PdIZ3jVkfmO8IlU6
   oz4gPgdTiRJ/g2uyahadwADd8Wl+6gbEO2qRwMjLG+JgT0CrSjz6/p9Sq
   g==;
X-CSE-ConnectionGUID: Ykwtp9KMRYGU697ZXW8IfA==
X-CSE-MsgGUID: Lw4myon0RH2BInOj0eNR1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89449334"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89449334"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 14:56:35 -0700
X-CSE-ConnectionGUID: Snj2jEi4QeuWOhXtZogyJw==
X-CSE-MsgGUID: pp+WCcJYSwCjka1r3bQ+7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="275583826"
Received: from lkp-server01.sh.intel.com (HELO a3e91e2cf319) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 09 Sep 2026 14:56:34 -0700
Received: from kbuild by a3e91e2cf319 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4QHO-000000000z2-2sFx;
	Wed, 09 Sep 2026 21:56:30 +0000
Date: Thu, 10 Sep 2026 05:56:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 0bffe67ab8a72b3725cc31c4b525709bd3a3e223
Message-ID: <202609100517.0DrzxrW4-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0bffe67ab8a72b3725cc31c4b525709bd3a3e223  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com

    include/linux/mmzone.h:1692:10: error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    include/linux/mmzone.h:1692:26: error: member reference type 'int' is not a pointer
    include/linux/mmzone.h:1780:35: error: conflicting types for 'NODE_DATA'

Error/Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-123-20260910
    |-- include-linux-mmzone.h:error:call-to-undeclared-function-NODE_DATA-ISO-C99-and-later-do-not-support-implicit-function-declarations
    |-- include-linux-mmzone.h:error:conflicting-types-for-NODE_DATA
    `-- include-linux-mmzone.h:error:member-reference-type-int-is-not-a-pointer

elapsed time: 730m

configs tested: 69
configs skipped: 0

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
