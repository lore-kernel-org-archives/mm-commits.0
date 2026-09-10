Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C103AB29D
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789064706; cv=none; b=Rxv6p1FnQvATtXs1/sJwSoIp9KuPfw+wyKZIiQI6HnOZBbtz16ydDRH8A5QW/Foqd4WrK55nrfeJtYTFxOW2TeLe8UTsxyWDfcnrpeuS7hDN1/cfoRXJtn9KJgPfviaO9rOTPP1RkB3smfHNoPDnpUHgn85o3TVggc/qImbX7iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789064706; c=relaxed/simple;
	bh=tzmxgyjlRh1Bcs8wyT/PurkgjJIxoAotpZY7mffUuHU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ddcf2n1ghz5sUDrjraKkE1P3gkVqkBw12Mbbiws72kDWT0pdvvvgYasrQ0erMHQiJFGd7ld5oFlPGRlhNUmjfTjqdfxO9Tc0kA76zfVZhD3oHd8tXvSPpKObX86XGu+Pl1MmONFjst+kwizeCnASpIDB6F8oGy+kKGbEjDEBN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBtb1ysh; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBtb1ysh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789064704; x=1820600704;
  h=date:from:to:cc:subject:message-id;
  bh=tzmxgyjlRh1Bcs8wyT/PurkgjJIxoAotpZY7mffUuHU=;
  b=MBtb1yshI8q/YvLXXkt5x8n4kqF/a2RzEa84W6Njc0NkSjI6b6Q8BV1+
   W9dQ6TXU9JWFHm9pbJlCmQnaBcMGeufQ2owCAsUdouzzSeXSBSfBRaYrY
   yDTODJGjOUwr1CJHYVq2sSNZl06t6TL7+bo89H7PCCT6f4qVms60YBkVz
   969iurA+9zvlJYHFFlnwDi+5Bt77N1JX4OEyBd5EvPiKZT6TvXAo7EI7i
   rfyXCGkRsZ653SavBfvNHL7cqa75U9XmVGl1TjCJJWrRd83y18yKpoB09
   b8Alm22HA+ODBTF5GUiLwS0Ome2XjhEHHHLa7sttnL9y1knRrJtQvotgP
   w==;
X-CSE-ConnectionGUID: j01vnZ32QwGpWEl7sbVl9A==
X-CSE-MsgGUID: Jg2/6ebLQt2jpDX2M0TVVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="107039479"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="107039479"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 11:25:04 -0700
X-CSE-ConnectionGUID: CF7tBJgRRduXNch6kR7lkw==
X-CSE-MsgGUID: racymfY0TZKA2nXeuOcLnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="301601882"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 10 Sep 2026 11:25:03 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4jSF-000000000Pb-44Ty;
	Thu, 10 Sep 2026 18:24:59 +0000
Date: Fri, 11 Sep 2026 02:24:29 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 cf558a250cf4475a8936902b8978fbb6c61016f8
Message-ID: <202609110219.ZSBCJ3ud-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: cf558a250cf4475a8936902b8978fbb6c61016f8  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609101047.wFyYfjz9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609102250.lIycVv3n-lkp@intel.com

    mm/sparse-vmemmap.c:505:48: error: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]
    mm/sparse-vmemmap.c:507:48: error: implicit declaration of function 'device_zone'; did you mean 'device_move'? [-Werror=implicit-function-declaration]
    mm/sparse-vmemmap.c:507:48: warning: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- s390-randconfig-r121-20260910
|   |-- mm-sparse-vmemmap.c:error:implicit-declaration-of-function-device_zone
|   `-- mm-sparse-vmemmap.c:warning:passing-argument-of-vmemmap_shared_tail_page-makes-pointer-from-integer-without-a-cast
`-- x86_64-randconfig-122-20260910
    `-- mm-sparse-vmemmap.c:error:passing-argument-of-vmemmap_shared_tail_page-makes-pointer-from-integer-without-a-cast

elapsed time: 888m

configs tested: 81
configs skipped: 5

tested configs:
alpha               allnoconfig    gcc-16.1.0
alpha              allyesconfig    gcc-16.1.0
arc                allmodconfig    gcc-16.1.0
arc                 allnoconfig    gcc-16.1.0
arc                allyesconfig    gcc-16.1.0
arm                 allnoconfig    clang-17
arm                 allnoconfig    gcc-16.1.0
arm                allyesconfig    gcc-16.1.0
arm64              allmodconfig    clang-24
arm64               allnoconfig    gcc-16.1.0
csky               allmodconfig    gcc-16.1.0
csky                allnoconfig    gcc-16.1.0
hexagon            allmodconfig    clang-24
hexagon            allmodconfig    gcc-16.1.0
hexagon             allnoconfig    clang-24
hexagon             allnoconfig    gcc-16.1.0
i386               allmodconfig    gcc-14
i386                allnoconfig    gcc-14
i386                allnoconfig    gcc-16.1.0
loongarch          allmodconfig    clang-19
loongarch           allnoconfig    clang-20
loongarch           allnoconfig    gcc-16.1.0
m68k               allmodconfig    gcc-16.1.0
m68k                allnoconfig    gcc-16.1.0
m68k               allyesconfig    gcc-16.1.0
microblaze          allnoconfig    gcc-16.1.0
microblaze         allyesconfig    gcc-16.1.0
mips               allmodconfig    gcc-16.1.0
mips                allnoconfig    gcc-16.1.0
mips               allyesconfig    gcc-16.1.0
nios2              allmodconfig    clang-20
nios2              allmodconfig    gcc-11.5.0
nios2               allnoconfig    clang-24
nios2               allnoconfig    gcc-11.5.0
openrisc           allmodconfig    clang-20
openrisc           allmodconfig    gcc-16.1.0
openrisc            allnoconfig    clang-24
openrisc            allnoconfig    gcc-16.1.0
openrisc              defconfig    gcc-16.1.0
parisc             allmodconfig    gcc-16.1.0
parisc              allnoconfig    clang-24
parisc              allnoconfig    gcc-16.1.0
parisc             allyesconfig    clang-17
parisc             allyesconfig    gcc-16.1.0
powerpc            allmodconfig    gcc-16.1.0
powerpc             allnoconfig    clang-24
powerpc             allnoconfig    gcc-16.1.0
riscv              allmodconfig    clang-24
riscv               allnoconfig    clang-24
riscv               allnoconfig    gcc-16.1.0
riscv              allyesconfig    clang-24
riscv                 defconfig    clang-24
s390               allmodconfig    clang-17
s390               allmodconfig    clang-24
s390                allnoconfig    clang-24
s390               allyesconfig    gcc-16.1.0
sh                 allmodconfig    gcc-16.1.0
sh                  allnoconfig    clang-24
sh                  allnoconfig    gcc-16.1.0
sh                 allyesconfig    clang-17
sh                 allyesconfig    gcc-16.1.0
sparc               allnoconfig    clang-24
sparc               allnoconfig    gcc-16.1.0
sparc                 defconfig    gcc-16.1.0
sparc64            allmodconfig    clang-20
um                 allmodconfig    clang-17
um                  allnoconfig    clang-17
um                  allnoconfig    clang-24
um                 allyesconfig    gcc-14
um                 allyesconfig    gcc-16.1.0
x86_64              allnoconfig    clang-22
x86_64              allnoconfig    clang-24
x86_64                    kexec    clang-22
x86_64                 rhel-9.4    clang-22
x86_64            rhel-9.4-func    clang-22
x86_64      rhel-9.4-kselftests    clang-22
x86_64            rhel-9.4-rust    clang-22
xtensa              allnoconfig    clang-24
xtensa              allnoconfig    gcc-16.1.0
xtensa             allyesconfig    clang-20
xtensa             allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
