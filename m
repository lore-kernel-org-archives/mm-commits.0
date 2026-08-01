Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E69353A98
	for <mm-commits@vger.kernel.org>; Sat,  1 Aug 2026 04:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785556815; cv=none; b=o3GCVmYhmAwsOCImuc6LFvf/9y769sDLDutsrvS2IHhugGvcrmZsCSESYBea+1KGKw9dP8Vb6SH9ibR5XuICNPIjGsyolJ35LHVwvuWQyPJdzILagH1Fqegk6ATrNz8oiy+Hsjc84hFrzSGJDIp170LEmsyA5+0v2qWS5hE8HGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785556815; c=relaxed/simple;
	bh=7nUDrQMpdp8B/2IGadLa7D6zOIyf/M5G8NhUW2iIuk8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=QAZPPbrqmwxrf0ZaiqYxcpp2CS2OXAJKQvoExrMYTd+3uQ/uqiZZBCuIwmDBoiOJnABVCFRylt//shgJ3j9oCG/G7wsSK3jvWdPxpKLUkRQTxeW34AA6Cy0+uNbFm1lZh5AlcdwSwZz6Xyl4dANbmkUvnIHs6op3TZmc6BbkODg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pp6Y7scz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pp6Y7scz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785556815; x=1817092815;
  h=date:from:to:cc:subject:message-id;
  bh=7nUDrQMpdp8B/2IGadLa7D6zOIyf/M5G8NhUW2iIuk8=;
  b=Pp6Y7sczVtS62FyuhLEaBK7q3USd4YXYuhVt5RmugXBUsXrqYaPc3D4P
   SR+qVZUIgI8CZaFhEWDjCvzhOpXPIGattPijxcS1ezh+N8Nmjlbw1rQU7
   Blq+C6iuXp5Z+CMRqby9lpXKZ3VgAkfb95AvguGU6UPk0fSedYeZM6zc4
   0ZFaV6A3pqtTCzP6fT1aIw6K5RAbBs5OvuyacxfdEog1m4J5Ru5VQpdz+
   DJZNrzAJcKJ23zSLDkEHEpZB8+0/xzf0T7TtSmq7EufE0gWMzuhQicTFM
   yE4HfG9dJR/rgQdr6FvxQq5PWU3Dj4wVZuHJKnJkeWGs/9wwMrP1PRFzT
   g==;
X-CSE-ConnectionGUID: G9mTihJVRW+NszAsPuXvQQ==
X-CSE-MsgGUID: OcrsR5JxT6aVhLJA0C1kfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="97336112"
X-IronPort-AV: E=Sophos;i="6.25,197,1779174000"; 
   d="scan'208";a="97336112"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 21:00:14 -0700
X-CSE-ConnectionGUID: DnDHkbO4SiOvaw0fp3jpaw==
X-CSE-MsgGUID: udX62kEaTQOIj+Cs9er0RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,197,1779174000"; 
   d="scan'208";a="259491084"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 31 Jul 2026 21:00:12 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wq0tN-000000002iv-3aKB;
	Sat, 01 Aug 2026 04:00:09 +0000
Date: Sat, 01 Aug 2026 11:59:32 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 9e25ce807d1c5df0fb7ec68cc9eb4253ac4bd055
Message-ID: <202608011116.FOaI6WWp-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9e25ce807d1c5df0fb7ec68cc9eb4253ac4bd055  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
|-- hexagon-randconfig-r072-20260801
|   `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses
|-- i386-randconfig-141-20260801
|   `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses
`-- powerpc-randconfig-r073-20260801
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 786m

configs tested: 102
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260731    gcc-8.5.0
arc                  randconfig-002-20260731    gcc-16.1.0
arm                  randconfig-001-20260731    clang-17
arm                  randconfig-002-20260731    clang-19
arm                  randconfig-003-20260731    clang-24
arm                  randconfig-004-20260731    clang-24
arm                          u8500_defconfig    gcc-16.1.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260731    gcc-8.5.0
arm64                randconfig-002-20260731    clang-24
arm64                randconfig-003-20260731    gcc-10.5.0
arm64                randconfig-004-20260731    gcc-12.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-16.1.0
csky                 randconfig-002-20260731    gcc-10.5.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260731    clang-24
hexagon              randconfig-002-20260731    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260801    clang-22
i386       buildonly-randconfig-002-20260801    clang-22
i386       buildonly-randconfig-003-20260801    clang-22
i386       buildonly-randconfig-004-20260801    clang-22
i386       buildonly-randconfig-005-20260801    gcc-14
i386       buildonly-randconfig-006-20260801    gcc-14
i386                 randconfig-001-20260801    clang-22
i386                 randconfig-002-20260801    gcc-14
i386                 randconfig-003-20260801    clang-22
i386                 randconfig-004-20260801    clang-22
i386                 randconfig-005-20260801    clang-22
i386                 randconfig-006-20260801    clang-22
i386                 randconfig-007-20260801    clang-22
i386                 randconfig-011-20260801    clang-22
i386                 randconfig-012-20260801    gcc-14
i386                 randconfig-013-20260801    gcc-14
i386                 randconfig-014-20260801    clang-22
i386                 randconfig-015-20260801    clang-22
i386                 randconfig-016-20260801    gcc-14
i386                 randconfig-017-20260801    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260731    gcc-16.1.0
loongarch            randconfig-002-20260731    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260731    gcc-8.5.0
nios2                randconfig-002-20260731    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260801    gcc-11.5.0
parisc               randconfig-002-20260801    gcc-9.5.0
powerpc              randconfig-001-20260801    clang-20
powerpc              randconfig-002-20260801    gcc-10.5.0
powerpc64            randconfig-001-20260801    clang-24
powerpc64            randconfig-002-20260801    clang-24
riscv                randconfig-001-20260801    gcc-14.3.0
riscv                randconfig-002-20260801    clang-20
s390                 randconfig-001-20260801    gcc-15.2.0
s390                 randconfig-002-20260801    clang-24
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260801    gcc-16.1.0
sh                   randconfig-002-20260801    gcc-16.1.0
sparc                randconfig-001-20260801    gcc-8.5.0
sparc                randconfig-002-20260801    gcc-11.5.0
sparc64              randconfig-001-20260801    gcc-9.5.0
sparc64              randconfig-002-20260801    gcc-15.2.0
um                   randconfig-001-20260801    clang-17
um                   randconfig-002-20260801    gcc-14
x86_64     buildonly-randconfig-001-20260731    clang-22
x86_64     buildonly-randconfig-002-20260731    clang-22
x86_64     buildonly-randconfig-003-20260731    clang-22
x86_64     buildonly-randconfig-004-20260731    clang-22
x86_64     buildonly-randconfig-005-20260731    clang-22
x86_64     buildonly-randconfig-006-20260731    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260801    clang-22
x86_64               randconfig-002-20260801    gcc-14
x86_64               randconfig-003-20260801    gcc-14
x86_64               randconfig-004-20260801    clang-22
x86_64               randconfig-005-20260801    gcc-14
x86_64               randconfig-006-20260801    gcc-14
x86_64               randconfig-011-20260731    clang-22
x86_64               randconfig-012-20260731    gcc-14
x86_64               randconfig-013-20260731    clang-22
x86_64               randconfig-014-20260731    clang-22
x86_64               randconfig-015-20260731    gcc-14
x86_64               randconfig-016-20260731    gcc-14
x86_64               randconfig-071-20260801    gcc-14
x86_64               randconfig-072-20260801    gcc-14
x86_64               randconfig-073-20260801    clang-22
x86_64               randconfig-074-20260801    gcc-14
x86_64               randconfig-075-20260801    clang-22
x86_64               randconfig-076-20260801    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260801    gcc-9.5.0
xtensa               randconfig-002-20260801    gcc-15.2.0
xtensa                        virt_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
