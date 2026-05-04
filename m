Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C4939DBED
	for <mm-commits@vger.kernel.org>; Mon,  4 May 2026 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902195; cv=none; b=K3rOHLlfLfq5mJMeFHb4DqLvCEUr+cUnD45NHa1qM1CfQfimBHHSP8wnb5xmUFHkH0Y743N732qkozrJeYeozvTQmr5NqqqNC3Ee/vDZNz2PEsNmE5SEDe1vAzkhuo9v49X1zbVL4H3fO7QdhN7PLepekAetuWdqMiUO6aVQJuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902195; c=relaxed/simple;
	bh=lXUFBMKtKHMcP4YG/D/l3S4QZNbwuhzVGbFID+Lb5BE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=QVLFBeMOBLMwM/IxuW8307DIR6P3807a8zdPs6HiU7ev8537L6/6vVLRrSpqnGyTy5GAAz7dQgd9yanHZGdrFQpi62U2So5HfvS50+XTS/8gZA3esXP+UY7ylrrlCLOETTzoxvj25Wt7JVSIqudKzpP2B5leafwk533KIL1gGw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FVCff5+i; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FVCff5+i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777902193; x=1809438193;
  h=date:from:to:cc:subject:message-id;
  bh=lXUFBMKtKHMcP4YG/D/l3S4QZNbwuhzVGbFID+Lb5BE=;
  b=FVCff5+i+650zXV+Bo8TQ8KzNcMLoIfXQ4jXzHjwOG4qyRBmywIHlEKK
   JAmfVcTztxw62OfTNJLCw2TwaYe7r7QMdtwGlLok2lCg0gwzgzv3TwW+/
   RLx51w/shiUA/5djeRZMtlYpnPslhbo2FnYZd20in0iVRq1YIJWtLpZka
   DOZajpIzHQ8XH19WoE643ZDELTrXBRP5FJUvqGDynSkHNCf+dEniNj8VD
   fIKWq8JP3X0IEnIPJmQkvIpWRprHColP9NjBlURqxjEYMle6r0PxBSNUI
   QWSKKlfXhn0eJ14IFJ3thg9e2o1aXQroASX3BVXmEzRpEJ2tYDve7Un/V
   w==;
X-CSE-ConnectionGUID: eyyQhx9jTSGU4A9RF2e05Q==
X-CSE-MsgGUID: xrNudLo1SyKu6swIgGdStQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78619999"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="78619999"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 06:43:12 -0700
X-CSE-ConnectionGUID: Nr4KljfoSr2ErPoOoYf4ng==
X-CSE-MsgGUID: a+Qp9JQJT+W3IVXkmgsVWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="258868695"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 May 2026 06:43:10 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJtZa-000000003m5-49kP;
	Mon, 04 May 2026 13:43:03 +0000
Date: Mon, 04 May 2026 21:42:13 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 7480614ff12ced7ceb0d80be8ada5218a575d62a
Message-ID: <202605042102.lNTjHz0k-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 7480614ff12ced7ceb0d80be8ada5218a575d62a  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

elapsed time: 786m

configs tested: 155
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260504    gcc-12.5.0
arc                   randconfig-002-20260504    gcc-13.4.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260504    clang-20
arm                   randconfig-002-20260504    clang-23
arm                   randconfig-003-20260504    gcc-13.4.0
arm                   randconfig-004-20260504    clang-23
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260504    gcc-8.5.0
arm64                 randconfig-002-20260504    gcc-8.5.0
arm64                 randconfig-003-20260504    clang-23
arm64                 randconfig-004-20260504    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260504    gcc-15.2.0
csky                  randconfig-002-20260504    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260504    clang-23
hexagon               randconfig-002-20260504    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260504    gcc-14
i386        buildonly-randconfig-002-20260504    gcc-14
i386        buildonly-randconfig-003-20260504    gcc-12
i386        buildonly-randconfig-004-20260504    gcc-14
i386        buildonly-randconfig-005-20260504    gcc-14
i386        buildonly-randconfig-006-20260504    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260504    clang-20
i386                  randconfig-002-20260504    gcc-14
i386                  randconfig-003-20260504    gcc-14
i386                  randconfig-004-20260504    gcc-14
i386                  randconfig-005-20260504    gcc-14
i386                  randconfig-006-20260504    clang-20
i386                  randconfig-007-20260504    clang-20
i386                  randconfig-011-20260504    clang-20
i386                  randconfig-012-20260504    clang-20
i386                  randconfig-013-20260504    clang-20
i386                  randconfig-014-20260504    clang-20
i386                  randconfig-015-20260504    clang-20
i386                  randconfig-016-20260504    gcc-13
i386                  randconfig-017-20260504    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260504    clang-18
loongarch             randconfig-002-20260504    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           ip22_defconfig    gcc-15.2.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260504    gcc-11.5.0
nios2                 randconfig-002-20260504    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    gcc-13.4.0
parisc                randconfig-001-20260504    gcc-13.4.0
parisc                         randconfig-002    gcc-8.5.0
parisc                randconfig-002-20260504    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        randconfig-001    gcc-13.4.0
powerpc               randconfig-001-20260504    gcc-12.5.0
powerpc                        randconfig-002    gcc-10.5.0
powerpc               randconfig-002-20260504    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260504    gcc-10.5.0
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260504    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260504    gcc-8.5.0
riscv                 randconfig-002-20260504    gcc-8.5.0
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260504    clang-23
s390                  randconfig-002-20260504    gcc-13.4.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260504    gcc-10.5.0
sh                    randconfig-002-20260504    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260504    gcc-12
x86_64      buildonly-randconfig-002-20260504    clang-20
x86_64      buildonly-randconfig-003-20260504    clang-20
x86_64      buildonly-randconfig-004-20260504    gcc-14
x86_64      buildonly-randconfig-005-20260504    clang-20
x86_64      buildonly-randconfig-006-20260504    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260504    clang-20
x86_64                randconfig-002-20260504    clang-20
x86_64                randconfig-003-20260504    gcc-14
x86_64                randconfig-004-20260504    clang-20
x86_64                randconfig-005-20260504    clang-20
x86_64                randconfig-006-20260504    clang-20
x86_64                randconfig-011-20260504    gcc-14
x86_64                randconfig-012-20260504    gcc-14
x86_64                randconfig-013-20260504    gcc-14
x86_64                randconfig-014-20260504    gcc-14
x86_64                randconfig-015-20260504    clang-20
x86_64                randconfig-016-20260504    clang-20
x86_64                randconfig-071-20260504    clang-20
x86_64                randconfig-072-20260504    gcc-14
x86_64                randconfig-073-20260504    clang-20
x86_64                randconfig-074-20260504    clang-20
x86_64                randconfig-075-20260504    gcc-14
x86_64                randconfig-076-20260504    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
