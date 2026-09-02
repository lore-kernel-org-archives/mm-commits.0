Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B625306D2A
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788375231; cv=none; b=VLTkPs5FVYJTT6nGCvO8pvh2bIP/kZX6Bccf8nJN47y+NfUbs0oD/fHeSceTfs0eWZV0ULcU9W0g6D8Y9PAQi04/BWSYvYJgkgOtsMDL2do5wKW6FG1cTDTCB9oVdmzQ+veaj2GjyZI7bzg52kyY0K8+BwVFY3wdrDaGCjRjE+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788375231; c=relaxed/simple;
	bh=tyqBvBhaitEafSk7IFlesfHWtTBrzO7CcS/spKtX6XM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=C5MNV6215m9jTywe0uEaBCxhR7iB5e2zOxlA9gyvRDsiKaPCQQRejTnOVDojfyUJm9O6KIWletS/8V+YQPqlCz2nXLvFdvCTEm404FUmKwTfpYfjTZZTBTwt/gi2q203ZvK/jejfXjz/A44BRWV1xt/EHbg360rMT6kYhkUMPOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N0ooNUqt; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N0ooNUqt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788375230; x=1819911230;
  h=date:from:to:cc:subject:message-id;
  bh=tyqBvBhaitEafSk7IFlesfHWtTBrzO7CcS/spKtX6XM=;
  b=N0ooNUqtj5TqHKgEISOT4JYGunLppLGEJ/WzIg8YAlOLhWGu1OPlKRsc
   XpjFcp7VY7SqXhxBT+hzzrWYB604t8hVegmIwscOnadzHZqd4YMdmW8qt
   TRwmKD3qhNt2T3WsL6osHo8SY4iY+WpahcOPATg7VVPUXsKIPRjKpsaJ8
   TZYmY7RJuhJQOgkEDaX4gCtc+NUhsmBLPJuxmc5uArJP9o1bouKLxGo1b
   yzJ0iSaH1CKUVuGBRfA3U7E00E1yqlteiCDCkeV0exTXNdIW3fc1t6wS9
   m4L4ZHNdNDNwOj8hsKrKLyLGmhXQBm4FV/wA6Do+fSpDF612Hq8gTYeWM
   A==;
X-CSE-ConnectionGUID: zSykX9ORQlS3bZj1gt3SOA==
X-CSE-MsgGUID: yCTTtruITLGkA+W+65PqpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="100359920"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="100359920"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 11:53:50 -0700
X-CSE-ConnectionGUID: J9AHT+yTSoqIutuyyWVedQ==
X-CSE-MsgGUID: D0CqvWLBTSCCfTY9H3a+IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="272995110"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 02 Sep 2026 11:53:47 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x1q5h-000000003AI-28ct;
	Wed, 02 Sep 2026 18:53:45 +0000
Date: Thu, 03 Sep 2026 02:53:11 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 178b3d97bf1f15f598ea7cc615a40c115e528e1c
Message-ID: <202609030205.mM0yURLh-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 178b3d97bf1f15f598ea7cc615a40c115e528e1c  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 896m

configs tested: 74
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                    allnoconfig    gcc-16.1.0
alpha                   allyesconfig    gcc-16.1.0
arc                     allmodconfig    gcc-16.1.0
arc                      allnoconfig    gcc-16.1.0
arc                     allyesconfig    gcc-16.1.0
arc         randconfig-r072-20260902    gcc-10.5.0
arm                      allnoconfig    clang-17
arm                     allyesconfig    gcc-16.1.0
arm64                   allmodconfig    clang-24
arm64                    allnoconfig    gcc-16.1.0
arm64       randconfig-r112-20260902    clang-24
csky                    allmodconfig    gcc-16.1.0
csky                     allnoconfig    gcc-16.1.0
hexagon                 allmodconfig    clang-24
hexagon                  allnoconfig    clang-24
i386                    allmodconfig    gcc-14
i386                     allnoconfig    gcc-14
i386                    allyesconfig    gcc-14
i386         randconfig-061-20260902    clang-22
i386         randconfig-062-20260902    gcc-14
i386         randconfig-063-20260902    gcc-14
i386         randconfig-141-20260902    clang-22
loongarch               allmodconfig    clang-19
loongarch                allnoconfig    clang-20
m68k                    allmodconfig    gcc-16.1.0
m68k                     allnoconfig    gcc-16.1.0
m68k                    allyesconfig    gcc-16.1.0
m68k        randconfig-r052-20260902    gcc-16.1.0
microblaze               allnoconfig    gcc-16.1.0
microblaze              allyesconfig    gcc-16.1.0
microblaze  randconfig-r071-20260902    gcc-12.5.0
microblaze  randconfig-r111-20260902    gcc-11.5.0
microblaze  randconfig-r113-20260902    gcc-11.5.0
mips                    allmodconfig    gcc-16.1.0
mips                     allnoconfig    gcc-16.1.0
mips                    allyesconfig    gcc-16.1.0
nios2                   allmodconfig    gcc-11.5.0
nios2                    allnoconfig    gcc-11.5.0
nios2       randconfig-r054-20260902    gcc-11.5.0
openrisc                allmodconfig    gcc-16.1.0
openrisc                 allnoconfig    gcc-16.1.0
parisc                  allmodconfig    gcc-16.1.0
parisc                   allnoconfig    gcc-16.1.0
parisc                  allyesconfig    gcc-16.1.0
parisc      randconfig-r121-20260902    gcc-9.5.0
powerpc                 allmodconfig    gcc-16.1.0
powerpc                  allnoconfig    gcc-16.1.0
riscv                   allmodconfig    clang-24
riscv                    allnoconfig    gcc-16.1.0
riscv                   allyesconfig    clang-24
s390                    allmodconfig    clang-24
s390                     allnoconfig    clang-24
s390                    allyesconfig    gcc-16.1.0
sh                      allmodconfig    gcc-16.1.0
sh                       allnoconfig    gcc-16.1.0
sh                      allyesconfig    gcc-16.1.0
sparc                    allnoconfig    gcc-16.1.0
sparc64                 allmodconfig    clang-20
um                      allmodconfig    clang-17
um                       allnoconfig    clang-17
um                      allyesconfig    gcc-14
um          randconfig-r051-20260902    gcc-12
x86_64                  allmodconfig    clang-22
x86_64                   allnoconfig    clang-22
x86_64                  allyesconfig    clang-22
x86_64       randconfig-121-20260902    clang-22
x86_64       randconfig-122-20260902    clang-22
x86_64       randconfig-123-20260902    clang-22
x86_64       randconfig-161-20260902    clang-22
x86_64      randconfig-r122-20260902    gcc-14
x86_64                 rhel-9.4-rust    clang-22
xtensa                   allnoconfig    gcc-16.1.0
xtensa                  allyesconfig    gcc-16.1.0
xtensa      randconfig-r123-20260902    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
