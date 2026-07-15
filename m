Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BD71FECCD
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 04:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784091587; cv=none; b=V4yTSpw56Xp7E0x055bbEZC+jixqqhZknvRtHzfwk8ZMwfiagKt6LXOU0jdPjy3fWS4Wg58A7vjOx2z6KTvzNtkYo+cNioIoN76An6DJj78f14Y1+5DuGtZFNvaldJkNrr0wLWn/PrRXImhbaSGRx1Ia9IfRVSeMJO58T3otDkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784091587; c=relaxed/simple;
	bh=pHjAtwDVaR4xFZ5vSz6vmAvqXtYB5lZv4MIthoOc0xo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Kett/V0eMKakAHzdRWjsLG+Sqpv3vAfDWhZFt5yEhG+Y4c2RyaIh+GYsgv9OAvJFIbV5TMFmVKab3RMufffEytcPSgsSc83u1fHDxszMIVtMmKRi8lsIZy339Vf6toirNuR2gbLZKsqyh/vtW2BLVsrsAOER9YIVKoetAKEW84k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAW9xjUd; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAW9xjUd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784091585; x=1815627585;
  h=date:from:to:cc:subject:message-id;
  bh=pHjAtwDVaR4xFZ5vSz6vmAvqXtYB5lZv4MIthoOc0xo=;
  b=LAW9xjUdr6r0PgzScJZqPPdN2rastrLOK3nPN+30eE/GtKZDwGyn6Y0v
   NyUsunbVWoZRRxxV1GAXWd5N0Y7oElxyCu+N3/iDiDkNkatME6f/ZnYS1
   VvWrELx9VjzFHzfrc8Bi5NfU2G4hMkvhGXwBO17hQhr4ZLXcPsCYNgD/0
   44topz93DuDcT3LaRR0UVL3tc5UJFTdhFPC2upMbr6yr5G3KEGpswJ35w
   xc6x3DWKVERHy0JjebgdmW91uRW3oNYIoTdHyidQsAeXdmJQ1hKC39YYF
   MMlsvTzFh7vpRGSogjNMs8J+ViTaEI8UhSj2oNcoDyBQLv97hhKSqyzyu
   w==;
X-CSE-ConnectionGUID: LNlhA2BdRVuRageCc906tA==
X-CSE-MsgGUID: qiL2YGb4Rna8+LZsyi4AGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="88398074"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="88398074"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:59:45 -0700
X-CSE-ConnectionGUID: wq+V4eYERjSJVIkZjgtYaA==
X-CSE-MsgGUID: wjjKwBU+QA2/QG4vGOQ8Pg==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 14 Jul 2026 21:59:42 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wjriQ-00000000NIl-2wj2;
	Wed, 15 Jul 2026 04:59:30 +0000
Date: Wed, 15 Jul 2026 12:59:14 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 2fc4daf5c4774d70254201aaa5a9d50cae52af5e
Message-ID: <202607151200.G5oomtPt-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2fc4daf5c4774d70254201aaa5a9d50cae52af5e  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:672 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 653)
    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r071-20260714
|   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
|-- sparc-randconfig-r072-20260715
|   `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses
`-- x86_64-randconfig-161-20260714
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 853m

configs tested: 298
configs skipped: 26

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260715    gcc-10.5.0
arc                   randconfig-001-20260715    gcc-9.5.0
arc                   randconfig-002-20260715    gcc-10.5.0
arc                   randconfig-002-20260715    gcc-15.2.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260715    clang-23
arm                   randconfig-001-20260715    gcc-10.5.0
arm                   randconfig-002-20260715    gcc-10.5.0
arm                   randconfig-003-20260715    gcc-10.5.0
arm                   randconfig-003-20260715    gcc-15.2.0
arm                   randconfig-004-20260715    gcc-10.5.0
arm                         socfpga_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260714    clang-17
arm64                 randconfig-001-20260715    gcc-16.1.0
arm64                 randconfig-002-20260715    gcc-16.1.0
arm64                 randconfig-003-20260714    clang-17
arm64                 randconfig-003-20260715    gcc-16.1.0
arm64                 randconfig-004-20260714    clang-23
arm64                 randconfig-004-20260715    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260714    gcc-16.1.0
csky                  randconfig-001-20260715    gcc-16.1.0
csky                  randconfig-002-20260714    gcc-16.1.0
csky                  randconfig-002-20260715    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    clang-17
hexagon               randconfig-001-20260714    clang-20
hexagon                        randconfig-002    clang-23
hexagon               randconfig-002-20260714    clang-23
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260715    clang-22
i386        buildonly-randconfig-002-20260715    clang-22
i386        buildonly-randconfig-002-20260715    gcc-14
i386        buildonly-randconfig-003-20260715    clang-22
i386        buildonly-randconfig-003-20260715    gcc-14
i386        buildonly-randconfig-004-20260715    clang-22
i386        buildonly-randconfig-004-20260715    gcc-14
i386        buildonly-randconfig-005-20260715    clang-22
i386        buildonly-randconfig-006-20260715    clang-22
i386        buildonly-randconfig-006-20260715    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260714    gcc-14
i386                  randconfig-001-20260715    clang-22
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260714    gcc-13
i386                  randconfig-002-20260715    clang-22
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260714    clang-22
i386                  randconfig-003-20260715    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260714    gcc-14
i386                  randconfig-004-20260715    clang-22
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260714    gcc-13
i386                  randconfig-005-20260715    clang-22
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260714    gcc-14
i386                  randconfig-006-20260715    clang-22
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260714    clang-22
i386                  randconfig-007-20260715    clang-22
i386                  randconfig-011-20260714    gcc-14
i386                  randconfig-011-20260715    gcc-14
i386                  randconfig-012-20260714    clang-22
i386                  randconfig-012-20260715    gcc-14
i386                  randconfig-013-20260714    clang-22
i386                  randconfig-013-20260715    gcc-14
i386                  randconfig-014-20260714    gcc-14
i386                  randconfig-014-20260715    gcc-14
i386                  randconfig-015-20260714    gcc-14
i386                  randconfig-015-20260715    gcc-14
i386                  randconfig-016-20260714    clang-22
i386                  randconfig-016-20260715    gcc-14
i386                  randconfig-017-20260714    gcc-12
i386                  randconfig-017-20260715    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    clang-23
loongarch             randconfig-001-20260714    gcc-16.1.0
loongarch             randconfig-001-20260715    gcc-16.1.0
loongarch                      randconfig-002    gcc-16.1.0
loongarch             randconfig-002-20260714    gcc-14.3.0
loongarch             randconfig-002-20260715    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                           virt_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm63xx_defconfig    clang-23
mips                      maltaaprp_defconfig    clang-17
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260714    gcc-11.5.0
nios2                 randconfig-001-20260715    gcc-16.1.0
nios2                          randconfig-002    gcc-8.5.0
nios2                 randconfig-002-20260714    gcc-11.5.0
nios2                 randconfig-002-20260715    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260714    gcc-13.4.0
parisc                randconfig-001-20260715    clang-23
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260714    gcc-11.5.0
parisc                randconfig-002-20260715    clang-23
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260715    clang-23
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260715    clang-23
powerpc64             randconfig-001-20260715    clang-23
powerpc64             randconfig-002-20260715    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260714    clang-17
riscv                 randconfig-001-20260715    gcc-15.2.0
riscv                 randconfig-002-20260714    gcc-10.5.0
riscv                 randconfig-002-20260715    gcc-15.2.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260714    gcc-8.5.0
s390                  randconfig-001-20260715    gcc-15.2.0
s390                  randconfig-002-20260714    clang-23
s390                  randconfig-002-20260715    gcc-15.2.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260714    gcc-10.5.0
sh                    randconfig-001-20260715    gcc-15.2.0
sh                    randconfig-002-20260714    gcc-12.5.0
sh                    randconfig-002-20260715    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260714    gcc-8.5.0
sparc                 randconfig-001-20260715    gcc-16.1.0
sparc                 randconfig-002-20260714    gcc-8.5.0
sparc                 randconfig-002-20260715    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260714    gcc-11.5.0
sparc64               randconfig-001-20260715    gcc-16.1.0
sparc64               randconfig-002-20260714    gcc-9.5.0
sparc64               randconfig-002-20260715    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260714    gcc-14
um                    randconfig-001-20260715    gcc-16.1.0
um                    randconfig-002-20260714    gcc-14
um                    randconfig-002-20260715    gcc-16.1.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260714    clang-22
x86_64      buildonly-randconfig-001-20260715    gcc-14
x86_64      buildonly-randconfig-002-20260714    clang-22
x86_64      buildonly-randconfig-002-20260715    gcc-14
x86_64      buildonly-randconfig-003-20260714    clang-22
x86_64      buildonly-randconfig-003-20260715    gcc-14
x86_64      buildonly-randconfig-004-20260714    gcc-14
x86_64      buildonly-randconfig-004-20260715    gcc-14
x86_64      buildonly-randconfig-005-20260714    clang-22
x86_64      buildonly-randconfig-005-20260715    gcc-14
x86_64      buildonly-randconfig-006-20260714    gcc-14
x86_64      buildonly-randconfig-006-20260715    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260714    gcc-14
x86_64                randconfig-001-20260715    clang-22
x86_64                randconfig-002-20260714    gcc-12
x86_64                randconfig-002-20260715    clang-22
x86_64                randconfig-003-20260714    gcc-14
x86_64                randconfig-003-20260715    clang-22
x86_64                randconfig-004-20260714    gcc-14
x86_64                randconfig-004-20260715    clang-22
x86_64                randconfig-005-20260714    clang-22
x86_64                randconfig-005-20260715    clang-22
x86_64                randconfig-006-20260714    clang-22
x86_64                randconfig-006-20260715    clang-22
x86_64                randconfig-011-20260715    clang-22
x86_64                randconfig-012-20260715    clang-22
x86_64                randconfig-012-20260715    gcc-14
x86_64                randconfig-013-20260715    clang-22
x86_64                randconfig-014-20260715    clang-22
x86_64                randconfig-015-20260715    clang-22
x86_64                randconfig-016-20260715    clang-22
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260714    gcc-14
x86_64                randconfig-071-20260715    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260714    clang-22
x86_64                randconfig-072-20260715    gcc-14
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260714    clang-22
x86_64                randconfig-073-20260715    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260714    gcc-13
x86_64                randconfig-074-20260715    gcc-14
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260714    clang-22
x86_64                randconfig-075-20260715    gcc-14
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260714    gcc-14
x86_64                randconfig-076-20260715    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260714    gcc-11.5.0
xtensa                randconfig-001-20260715    gcc-16.1.0
xtensa                randconfig-002-20260714    gcc-9.5.0
xtensa                randconfig-002-20260715    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
