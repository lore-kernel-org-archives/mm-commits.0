Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005383A875B
	for <mm-commits@vger.kernel.org>; Fri, 14 Aug 2026 21:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786743978; cv=none; b=OIR1yp7YoORvUGWUBVuJR1RmpEFwW7dLy7J1/e59AFEGjVuNie9JS5LCDKNVYUxv8WNwNQxXkSma/D2LZpWQRIPN99GdC1+MORx4jWh9pfmIjUMoVIqq5zbW8oSBZ0oWNunKfyZNbWkf9r1Uk6L6ccj/zgX6gU6khjZ3S8S8VTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786743978; c=relaxed/simple;
	bh=5icbQX2VJlEt+gAZ3GH5ApZAlYrfxqHnTWTlpRn0QWs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=mI+sVs9wUE7rPK7NE3D3k9iy4MPUlWC1+opp4TzJLNBxJ/jNFe/+mRTl+bSh/3IgC7ehS4h1U9XZFT2GhlAGmE9J2siCTuR8w2qtAN04jdXpdWp9C+aQwNfNeTHO6dHxLyA9jV+elfrVEkAejE/8HqlElZLZ7hSTAGY1yQ2/7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cz4G0/Wg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cz4G0/Wg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786743973; x=1818279973;
  h=date:from:to:cc:subject:message-id;
  bh=5icbQX2VJlEt+gAZ3GH5ApZAlYrfxqHnTWTlpRn0QWs=;
  b=cz4G0/WgGAue1wWLC3h7geKRhj0AzWVIh8oFac5GaQoCb7rhttf19gBH
   hBUXm7l3odCwzk5Kvx/8z4VP0WxbJhc/DsITNLt3LYaKb+c7T6Na92H9g
   fXvnzMyOdtEEybWWQr+rJRQk+r1o6yvrj6dtunIgwI5De+wkDlmNe66m6
   P9ksapeLWnVQj0gxY0n5oYrA5olOSVWbZtqewiEwNmGye3vCZLRDH8W8G
   H6yDjhdIwTXls//r0rICwD2z6ONuIORILEVRKbpIcdnC3r08y6/zNKu5f
   BVD1ZJ7WgWhTjUl+CiYovoElN2DUSRe2TRC04/JPGcEZ2e+QWZGjnST0R
   g==;
X-CSE-ConnectionGUID: OGzRXJdWTl+5u0N6BUagqA==
X-CSE-MsgGUID: 7VyOvDb0S16hUh1oqWb+5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="86287675"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="86287675"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 14:46:12 -0700
X-CSE-ConnectionGUID: XRPJ+L0RSb6Yc3rFAESRMw==
X-CSE-MsgGUID: Brw3EAkeStumoDoyW/MbXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="260091269"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 14 Aug 2026 14:46:11 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuzj6-00000000aIH-2usI;
	Fri, 14 Aug 2026 21:46:08 +0000
Date: Sat, 15 Aug 2026 05:45:37 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 6c2cdf00fe5205942b5f29e16905603a1717b931
Message-ID: <202608150524.CchPIr2M-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 6c2cdf00fe5205942b5f29e16905603a1717b931  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 794m

configs tested: 97
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260814    gcc-10.5.0
arc                  randconfig-002-20260814    gcc-12.5.0
arm                  randconfig-001-20260814    gcc-16.1.0
arm                  randconfig-002-20260814    gcc-10.5.0
arm                  randconfig-003-20260814    gcc-16.1.0
arm                  randconfig-004-20260814    clang-17
arm64                randconfig-001-20260814    gcc-10.5.0
arm64                randconfig-002-20260814    clang-24
arm64                randconfig-003-20260814    clang-19
arm64                randconfig-004-20260814    clang-17
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260814    gcc-16.1.0
csky                 randconfig-002-20260814    gcc-10.5.0
hexagon              randconfig-001-20260814    clang-17
hexagon              randconfig-002-20260814    clang-19
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260814    clang-22
i386       buildonly-randconfig-002-20260814    gcc-13
i386       buildonly-randconfig-003-20260814    clang-22
i386       buildonly-randconfig-004-20260814    clang-22
i386       buildonly-randconfig-005-20260814    gcc-13
i386       buildonly-randconfig-006-20260814    gcc-14
i386                 randconfig-001-20260814    clang-22
i386                 randconfig-002-20260814    gcc-14
i386                 randconfig-003-20260814    gcc-14
i386                 randconfig-004-20260814    clang-22
i386                 randconfig-005-20260814    clang-22
i386                 randconfig-006-20260814    clang-22
i386                 randconfig-007-20260814    clang-22
i386                 randconfig-011-20260814    gcc-14
i386                 randconfig-012-20260814    gcc-12
i386                 randconfig-013-20260814    gcc-12
i386                 randconfig-014-20260814    gcc-14
i386                 randconfig-015-20260814    gcc-12
i386                 randconfig-016-20260814    gcc-14
i386                 randconfig-017-20260814    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260814    gcc-16.1.0
loongarch            randconfig-002-20260814    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260814    gcc-11.5.0
nios2                randconfig-002-20260814    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260814    gcc-15.2.0
parisc               randconfig-002-20260814    gcc-9.5.0
powerpc              randconfig-001-20260814    gcc-8.5.0
powerpc              randconfig-002-20260814    clang-18
powerpc                    tqm5200_defconfig    gcc-16.1.0
powerpc64            randconfig-001-20260814    gcc-14.3.0
powerpc64            randconfig-002-20260814    gcc-8.5.0
riscv                randconfig-001-20260814    gcc-14.3.0
riscv                randconfig-002-20260814    clang-24
s390                 randconfig-001-20260814    gcc-11.5.0
s390                 randconfig-002-20260814    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260814    gcc-16.1.0
sh                   randconfig-002-20260814    gcc-16.1.0
sparc                randconfig-001-20260814    gcc-16.1.0
sparc                randconfig-002-20260814    gcc-15.2.0
sparc64              randconfig-001-20260814    gcc-8.5.0
sparc64              randconfig-002-20260814    clang-24
um                   randconfig-001-20260814    gcc-14
um                   randconfig-002-20260814    clang-22
x86_64     buildonly-randconfig-001-20260814    clang-22
x86_64     buildonly-randconfig-002-20260814    clang-22
x86_64     buildonly-randconfig-003-20260814    clang-22
x86_64     buildonly-randconfig-004-20260814    clang-22
x86_64     buildonly-randconfig-005-20260814    clang-22
x86_64     buildonly-randconfig-006-20260814    gcc-14
x86_64               randconfig-001-20260814    gcc-14
x86_64               randconfig-002-20260814    clang-22
x86_64               randconfig-003-20260814    clang-22
x86_64               randconfig-004-20260814    clang-22
x86_64               randconfig-005-20260814    gcc-14
x86_64               randconfig-006-20260814    gcc-14
x86_64               randconfig-011-20260814    clang-22
x86_64               randconfig-012-20260814    gcc-13
x86_64               randconfig-013-20260814    clang-22
x86_64               randconfig-014-20260814    gcc-14
x86_64               randconfig-015-20260814    gcc-14
x86_64               randconfig-016-20260814    clang-22
x86_64               randconfig-071-20260814    gcc-14
x86_64               randconfig-072-20260814    clang-22
x86_64               randconfig-073-20260814    clang-22
x86_64               randconfig-074-20260814    gcc-13
x86_64               randconfig-075-20260814    gcc-14
x86_64               randconfig-076-20260814    clang-22
xtensa               randconfig-001-20260814    gcc-9.5.0
xtensa               randconfig-002-20260814    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
