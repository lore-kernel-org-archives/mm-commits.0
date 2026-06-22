Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8722D157487
	for <mm-commits@vger.kernel.org>; Mon, 22 Jun 2026 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782153981; cv=none; b=ZTdmkab38oFr//+rIDD9ElvCVDg2VexHz5FlCN1814ISin8K1fwWZkIbgiOl2MVW2yHx5r3ilh/sNVG4iyX9ToC1iusnuCEfetohuJuuLloVmw1CdF/FdJKOWLepSn1e8AT0Q1qSCuRve2zR3emQm7/7I9Lg/iI4Pf3U0NUkZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782153981; c=relaxed/simple;
	bh=LFeBm448ZH+AurP5febN8KfVhijbJzhf3SgQU1UwVuU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=uMl5ZznrNzjh+rOLDoTQMQWdpkNzqP/qE07K9ka7fnw/exZjbsi0oF+4eDMpgyIIxizVrrMKo05EnXocHiX6hCI4Q3BwiDW66ZQ2TZlfwXb5RBV3y3QMv1TfPGI3d4rVA2qkb22M++zrL4d7IdifBKx2Xhn+CyblSPzcC4YNBkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aOM9q3Iq; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aOM9q3Iq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782153979; x=1813689979;
  h=date:from:to:cc:subject:message-id;
  bh=LFeBm448ZH+AurP5febN8KfVhijbJzhf3SgQU1UwVuU=;
  b=aOM9q3Iqoi3SYnC70+i2/m8y8zkgCiU3uhtWAooilBgOKFtH9pov0f0V
   8S3yi1nXMVLFxSyYJkge8loJBvwNv1yWeln1ZTLAjKxWaFds6CU8+Gqkk
   SfTSbYUizSQXeC98Hl2+vKBDQpZp7iOg82FykfvOSonOcYLu8llt7Ned/
   IfEacOfNeM3j9ViF+XJsZHaCXI3GEw71Vg1b/SaP8SCrxWjhmiKvdmeSf
   uwEJzdrdVu6FvRRJseJ03gMlUahBTd0zKbxO0XOxIk8KtSM9gytCTPbvb
   FD4osyUQNgwVwC+YQzKHrBKQocB9bP71tuSkzV/kS7C1VCrkW2F0MPGEO
   Q==;
X-CSE-ConnectionGUID: xXNLDH5LTs2BjIwfI7oCPQ==
X-CSE-MsgGUID: 4UgXJWrbSqqcGXNiKSIn8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="93548905"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="93548905"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 11:46:19 -0700
X-CSE-ConnectionGUID: HhdaVeN2Sse/Vy28/pd6kA==
X-CSE-MsgGUID: YCPMOoY0QzmOmUlXHtvk5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="254391490"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 22 Jun 2026 11:46:17 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wbjen-000000001jh-2fFb;
	Mon, 22 Jun 2026 18:46:06 +0000
Date: Tue, 23 Jun 2026 02:45:39 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 e1201ff76176ef666b13d1a4ec6b6190ddc6abc8
Message-ID: <202606230227.UGnWbsis-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: e1201ff76176ef666b13d1a4ec6b6190ddc6abc8  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 952m

configs tested: 153
configs skipped: 16

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260622    gcc-15.2.0
arc                   randconfig-002-20260622    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                                 defconfig    clang-23
arm                   randconfig-001-20260622    gcc-13.4.0
arm                   randconfig-002-20260622    clang-23
arm                   randconfig-003-20260622    gcc-8.5.0
arm                   randconfig-004-20260622    gcc-15.2.0
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260622    gcc-8.5.0
arm64                 randconfig-002-20260622    gcc-13.4.0
arm64                 randconfig-003-20260622    gcc-8.5.0
arm64                 randconfig-004-20260622    clang-22
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260622    gcc-13.4.0
csky                  randconfig-002-20260622    gcc-11.5.0
hexagon                          allmodconfig    clang-23
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260622    clang-23
hexagon               randconfig-002-20260622    clang-23
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20260622    gcc-14
i386        buildonly-randconfig-002-20260622    clang-22
i386        buildonly-randconfig-003-20260622    gcc-14
i386        buildonly-randconfig-004-20260622    gcc-12
i386        buildonly-randconfig-005-20260622    gcc-14
i386        buildonly-randconfig-006-20260622    gcc-14
i386                                defconfig    clang-22
i386                  randconfig-001-20260622    gcc-14
i386                  randconfig-002-20260622    clang-22
i386                  randconfig-003-20260622    gcc-14
i386                  randconfig-004-20260622    gcc-14
i386                  randconfig-005-20260622    clang-22
i386                  randconfig-006-20260622    gcc-14
i386                  randconfig-007-20260622    clang-22
i386                  randconfig-011-20260622    gcc-14
i386                  randconfig-012-20260622    clang-22
i386                  randconfig-013-20260622    gcc-14
i386                  randconfig-014-20260622    clang-22
i386                  randconfig-015-20260622    clang-22
i386                  randconfig-016-20260622    clang-22
i386                  randconfig-017-20260622    clang-22
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260622    clang-18
loongarch             randconfig-002-20260622    clang-18
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260622    gcc-8.5.0
nios2                 randconfig-002-20260622    gcc-8.5.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260622    gcc-14.3.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260622    gcc-12.5.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc                       ebony_defconfig    clang-23
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260622    gcc-8.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260622    gcc-8.5.0
powerpc64                      randconfig-001    clang-16
powerpc64             randconfig-001-20260622    clang-21
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260622    clang-20
riscv                             allnoconfig    gcc-16.1.0
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260622    clang-23
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260622    gcc-14.3.0
s390                  randconfig-002-20260622    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260622    gcc-13.4.0
sh                    randconfig-002-20260622    gcc-15.2.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260622    gcc-16.1.0
sparc                 randconfig-002-20260622    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64               randconfig-001-20260622    gcc-16.1.0
sparc64               randconfig-002-20260622    clang-23
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260622    gcc-14
um                    randconfig-002-20260622    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                            allnoconfig    clang-22
x86_64      buildonly-randconfig-001-20260622    clang-22
x86_64      buildonly-randconfig-002-20260622    clang-22
x86_64      buildonly-randconfig-003-20260622    clang-22
x86_64      buildonly-randconfig-004-20260622    clang-22
x86_64      buildonly-randconfig-005-20260622    gcc-14
x86_64      buildonly-randconfig-006-20260622    clang-22
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260622    clang-22
x86_64                randconfig-002-20260622    gcc-14
x86_64                randconfig-003-20260622    clang-22
x86_64                randconfig-004-20260622    clang-22
x86_64                randconfig-005-20260622    gcc-14
x86_64                randconfig-006-20260622    gcc-14
x86_64                randconfig-011-20260622    clang-22
x86_64                randconfig-012-20260622    clang-22
x86_64                randconfig-013-20260622    gcc-14
x86_64                randconfig-014-20260622    gcc-14
x86_64                randconfig-015-20260622    clang-22
x86_64                randconfig-016-20260622    clang-22
x86_64                randconfig-071-20260622    gcc-14
x86_64                randconfig-072-20260622    gcc-14
x86_64                randconfig-073-20260622    clang-22
x86_64                randconfig-074-20260622    gcc-14
x86_64                randconfig-075-20260622    gcc-14
x86_64                randconfig-076-20260622    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                randconfig-001-20260622    gcc-16.1.0
xtensa                randconfig-002-20260622    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
