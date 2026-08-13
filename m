Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7603B42124C
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786651219; cv=none; b=VKIZuo4a/zjk+e2gMt2RIASvwY7tO/d4gRSSCGmCJQop6AAjy40AlKKLAs2pMyeBVpqPYnn8nTMS9lfaA7pjJbrWq4Rtd0bYW6CE3XSrLsehTOtWmBdmN9Db29uVk7OuLuanJzq40g8T/blznXvSWigdzKAWNKwh4GDx6bgTzM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786651219; c=relaxed/simple;
	bh=9vzAxeBH2BtC0FH01hUcoTki5Yl0Y1uumD4S1t1C8BI=;
	h=Date:From:To:Cc:Subject:Message-ID; b=bevscbz+YibvVsAOatn+mbNhl/TwhAfs85i3zHJz6wySzArRbR/bJoWNdVwOZ/Ssgbf7AocG3jf/j1OTFSGkfvE5a8YWdbC3JijFtpxZnWaoeaCfWPo9yQrVznv8Ul9vHTeooTOKO0v2+6y9T8DEAjymOOmcSuKhMcaDYNyH+iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VcqdPH76; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VcqdPH76"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786651217; x=1818187217;
  h=date:from:to:cc:subject:message-id;
  bh=9vzAxeBH2BtC0FH01hUcoTki5Yl0Y1uumD4S1t1C8BI=;
  b=VcqdPH7669pxSmt2fjxEa3lqXZm6BRAruJLcGqq3nRzcviwOl56VisW6
   2BLiuyCX1Op96G107q519FHvry76g7MB+SgFuDYFREh0aDu1c02AQtGKi
   kNb/+bYczS06VDE2KXrKPouIFgn47ErUN7GbnLpI2amNUgCkt6YxaW9gi
   DrtyLpoitp4LHgQ6BSee4MuPeUSVwIzscnDUBnPt87EC9Ta1UtkmZEDMp
   fEWxnbDrcxLB67a3f46KI9PCdTEJnXxjVMqx2dmg6hRCWtF0KjuIh3oUc
   rpyv2fTTPZFNXmTFt05ri682dPWPta/ziMqtxPhdHtHi9nqQ531q84yT0
   w==;
X-CSE-ConnectionGUID: TvAnjo/RQ1+xjPLB1ODAjQ==
X-CSE-MsgGUID: JCgNhrqkR668CCKhb7AhPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="97900467"
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="97900467"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 13:00:16 -0700
X-CSE-ConnectionGUID: jl44uicwQouakakoggUYlA==
X-CSE-MsgGUID: Si13IeYuSzKRAqQMJYAx9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="260224902"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 13 Aug 2026 13:00:14 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wubb2-00000000WSI-2MhB;
	Thu, 13 Aug 2026 20:00:12 +0000
Date: Fri, 14 Aug 2026 04:00:07 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 7ba5daade5ab61776382020b708b1ef75c9af1ea
Message-ID: <202608140354.JfBGizlK-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 7ba5daade5ab61776382020b708b1ef75c9af1ea  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 786m

configs tested: 98
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260813    gcc-13.4.0
arc                  randconfig-002-20260813    gcc-8.5.0
arm                  randconfig-001-20260813    gcc-8.5.0
arm                  randconfig-002-20260813    clang-19
arm                  randconfig-003-20260813    gcc-8.5.0
arm                  randconfig-004-20260813    gcc-10.5.0
arm64                randconfig-001-20260813    clang-24
arm64                randconfig-002-20260813    gcc-8.5.0
arm64                randconfig-003-20260813    gcc-9.5.0
arm64                randconfig-004-20260813    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260813    gcc-16.1.0
csky                 randconfig-002-20260813    gcc-16.1.0
hexagon              randconfig-001-20260813    clang-24
hexagon              randconfig-002-20260813    clang-17
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260813    gcc-14
i386       buildonly-randconfig-002-20260813    clang-22
i386       buildonly-randconfig-003-20260813    gcc-14
i386       buildonly-randconfig-004-20260813    gcc-14
i386       buildonly-randconfig-005-20260813    clang-22
i386       buildonly-randconfig-006-20260813    gcc-12
i386                 randconfig-001-20260813    gcc-14
i386                 randconfig-002-20260813    clang-22
i386                 randconfig-003-20260813    clang-22
i386                 randconfig-004-20260813    clang-22
i386                 randconfig-005-20260813    gcc-14
i386                 randconfig-006-20260813    clang-22
i386                 randconfig-007-20260813    clang-22
i386                 randconfig-011-20260813    clang-22
i386                 randconfig-012-20260813    clang-22
i386                 randconfig-013-20260813    clang-22
i386                 randconfig-014-20260813    clang-22
i386                 randconfig-015-20260813    clang-22
i386                 randconfig-016-20260813    clang-22
i386                 randconfig-017-20260813    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260813    gcc-16.1.0
loongarch            randconfig-002-20260813    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260813    gcc-11.5.0
nios2                randconfig-002-20260813    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260813    gcc-12.5.0
parisc               randconfig-002-20260813    gcc-10.5.0
powerpc                      holly_defconfig    clang-24
powerpc              randconfig-001-20260813    gcc-8.5.0
powerpc              randconfig-002-20260813    gcc-13.4.0
powerpc64            randconfig-001-20260813    gcc-10.5.0
powerpc64            randconfig-002-20260813    gcc-11.5.0
riscv                randconfig-001-20260813    clang-24
riscv                randconfig-002-20260813    gcc-15.2.0
s390                 randconfig-001-20260813    gcc-8.5.0
s390                 randconfig-002-20260813    gcc-10.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260813    gcc-11.5.0
sh                   randconfig-002-20260813    gcc-9.5.0
sparc                randconfig-001-20260813    gcc-14.3.0
sparc                randconfig-002-20260813    gcc-8.5.0
sparc64              randconfig-001-20260813    clang-24
sparc64              randconfig-002-20260813    clang-20
um                   randconfig-001-20260813    gcc-14
um                   randconfig-002-20260813    gcc-14
x86_64     buildonly-randconfig-001-20260813    gcc-14
x86_64     buildonly-randconfig-002-20260813    clang-22
x86_64     buildonly-randconfig-003-20260813    gcc-14
x86_64     buildonly-randconfig-004-20260813    gcc-14
x86_64     buildonly-randconfig-005-20260813    gcc-14
x86_64     buildonly-randconfig-006-20260813    clang-22
x86_64               randconfig-001-20260813    gcc-14
x86_64               randconfig-002-20260813    clang-22
x86_64               randconfig-003-20260813    clang-22
x86_64               randconfig-004-20260813    clang-22
x86_64               randconfig-005-20260813    gcc-13
x86_64               randconfig-006-20260813    clang-22
x86_64               randconfig-011-20260813    clang-22
x86_64               randconfig-012-20260813    gcc-14
x86_64               randconfig-013-20260813    clang-22
x86_64               randconfig-014-20260813    clang-22
x86_64               randconfig-015-20260813    gcc-14
x86_64               randconfig-016-20260813    clang-22
x86_64               randconfig-071-20260813    gcc-14
x86_64               randconfig-072-20260813    gcc-14
x86_64               randconfig-073-20260813    gcc-14
x86_64               randconfig-074-20260813    gcc-14
x86_64               randconfig-075-20260813    gcc-14
x86_64               randconfig-076-20260813    clang-22
xtensa               randconfig-001-20260813    gcc-14.3.0
xtensa               randconfig-002-20260813    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
