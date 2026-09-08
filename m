Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6128A51A72F
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 10:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861777; cv=none; b=T/ksZEGpPwfpYLQiMPhIMhSXFFZAPSH4FQfwHA/FKaYtyzWsBpJXKofVjklLKYezb2Um2whZiLFrB6Nu26e4xGZWWZbBml2a4x+hs0h1PRy77CIm79svQ19363IxlEJl6YyEaUYDFVdjuxL6/KD/l6VumQnRuD6x8JL7qWkw8c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861777; c=relaxed/simple;
	bh=lOenf34xndDiZJzMvpI/y4dJR0P8wkP4cRibhZ8Cg3E=;
	h=Date:From:To:Cc:Subject:Message-ID; b=T/Aj/JqipYYPG9g15H3BlU4MUkMPq4VoApAnc8niRjd44fOarxO+v9d1acAM9gHDetHQx0ondSDZ+jOAhHoqCc3JKBwOROeYzSA3CXrlLtTCdQ7pmHGbeYMqsAiWJRJp4PvwpkD59SqfOvT5GQxR8GRxQ8W2I3I6WNBeHH+nMPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X2csJ4hA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X2csJ4hA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788861775; x=1820397775;
  h=date:from:to:cc:subject:message-id;
  bh=lOenf34xndDiZJzMvpI/y4dJR0P8wkP4cRibhZ8Cg3E=;
  b=X2csJ4hA3ZvArlFFL2b3Pst8ovOVa7VvTEAv/7VlvpzuUqlLWzWXNNbR
   mMXFnrQJdaX5sITGUB4I7rOHAeo9DIri2TEHnnH1jgEDFKDJVVX3zHlro
   8VBVPxwVI3Wt5jI2hcmO5xc7AOEaiA8UQFka3+R6dvRpk+LOLaUutAeoG
   Kdh0p25auCu6EdwVPVR59MiOBNxTUPzeuEHITcEJ92a8fRk903FK3m8nH
   itYzc7pTl4lOxhk7BhDapD99zoXplldiAkg89zL16FyKnQ2YURTcwX3jU
   1/UJv78qTs3mCSpO2mM2NBDqgIo0kLP7fP8SWPnc6u8zp/O9p6Evg7ARP
   w==;
X-CSE-ConnectionGUID: 33HFpz+AROqJuMzkYePZ8w==
X-CSE-MsgGUID: r0lvrMyEQm+JB9mKKCGdAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99852938"
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="99852938"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 03:02:54 -0700
X-CSE-ConnectionGUID: 69z3aZ3YQc6vTCP9kvNpNg==
X-CSE-MsgGUID: CvDo7uGIR6W/UNHeQIyZ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="274470861"
Received: from lkp-server01.sh.intel.com (HELO dff15f1b2031) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 08 Sep 2026 03:02:53 -0700
Received: from kbuild by dff15f1b2031 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x3sfB-000000001xF-3ykp;
	Tue, 08 Sep 2026 10:02:49 +0000
Date: Tue, 08 Sep 2026 18:02:41 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9d3243fc689fef444f87e0a703b4c99653137e1b
Message-ID: <202609081839.rwV5qR0y-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9d3243fc689fef444f87e0a703b4c99653137e1b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1865m

configs tested: 79
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    clang-20
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    clang-17
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    clang-17
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    clang-20
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
