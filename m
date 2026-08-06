Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BEC302146
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786057993; cv=none; b=XAIhdjFlYGyDqcakv0ZeAZmLs5+9qepfMhawNWSLLAQGUmRBmCBhQf2IrYSvgAoNPyaer8pasBk5NAHXuCbLdwSBssDw2/WFJ1RrZ6kFyJ6R1+yZjHzADZirZMhSk+SDT+67jVL+7OIIainqI9PgAKzoWvyE4LkOSTc2LMbCD1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786057993; c=relaxed/simple;
	bh=teCkrAmoo6hgkt2QOgVoP40Zm2UrvjBI1z/3Fi0Cb8I=;
	h=Date:From:To:Cc:Subject:Message-ID; b=T8iZO/WIsrfKWS8ZYxquCExroBtr23ul2i/6QYNAZ++EoRtiO5HEcp0ysepROdotUYtDnhdvSqx1CvYoFlrT/F8ZOUgNszvQeAL9HDVa4fvuenVuPZNYipU02cdz0EZZtt9z8MHTFcWpUqXuodXPATWhWzpH54NhTx1kInxTOTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JwcBszFI; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JwcBszFI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786057992; x=1817593992;
  h=date:from:to:cc:subject:message-id;
  bh=teCkrAmoo6hgkt2QOgVoP40Zm2UrvjBI1z/3Fi0Cb8I=;
  b=JwcBszFI5umCEkROdH9QNtF1q9eaII4G+P9g/tcs45dgYIj8oqKA/KZi
   2MIOLyo9wPz1x2ueUuyBxLFkUIy4F6vInYUVKOgsItfmHAGM1YVZQaGaO
   hQuIBljF7zr1BKK9M2/fWJy+N6mVX29oLykNlLLz1LyCAYo9t6Rtq+FM/
   Z7T5EmXCsHYEXuFN+/tyeudCK++LZKOMzbcsZ88cb+TzhGYQpensQYyMF
   mU1fnbthNMXk/4Nx9h3MoWQNMg86nsL8xkQHKwsYeXLe2dN+gkhUwhBrj
   qmud7XdOs7bc0AtJwJNhyDwxNnVSm+AMRduaMXWregiirjjWx3u8i5Z2Q
   g==;
X-CSE-ConnectionGUID: YG9bEZDxRmuGrokqS1vwmQ==
X-CSE-MsgGUID: QV6RMjYQTf+rS2Tc4oHl2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="85636239"
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="85636239"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 16:13:11 -0700
X-CSE-ConnectionGUID: zJXmgz1PRxu19IvuAVDscw==
X-CSE-MsgGUID: aWwJTnNDTeqWg83XAFA3Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="257929535"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 06 Aug 2026 16:13:02 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ws7Gl-00000000GXN-346p;
	Thu, 06 Aug 2026 23:12:59 +0000
Date: Fri, 07 Aug 2026 07:12:20 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 1fb556c523f6c18b43b1f52fb366f61c9963ce06
Message-ID: <202608070759.0EhTGUkj-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1fb556c523f6c18b43b1f52fb366f61c9963ce06  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- i386-randconfig-141-20260806
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 1494m

configs tested: 218
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                         axs101_defconfig    gcc-16.1.0
arc                  randconfig-001-20260806    gcc-11.5.0
arc                  randconfig-001-20260806    gcc-8.5.0
arc                  randconfig-001-20260807    gcc-14.3.0
arc                  randconfig-002-20260806    gcc-11.5.0
arc                  randconfig-002-20260807    gcc-14.3.0
arm                  randconfig-001-20260806    clang-24
arm                  randconfig-001-20260806    gcc-11.5.0
arm                  randconfig-001-20260807    gcc-14.3.0
arm                  randconfig-002-20260806    gcc-10.5.0
arm                  randconfig-002-20260806    gcc-11.5.0
arm                  randconfig-002-20260807    gcc-14.3.0
arm                  randconfig-003-20260806    gcc-11.5.0
arm                  randconfig-003-20260806    gcc-8.5.0
arm                  randconfig-003-20260807    gcc-14.3.0
arm                  randconfig-004-20260806    gcc-11.5.0
arm                  randconfig-004-20260806    gcc-8.5.0
arm                  randconfig-004-20260807    gcc-14.3.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260806    gcc-13.4.0
arm64                randconfig-001-20260806    gcc-8.5.0
arm64                randconfig-001-20260807    gcc-16.1.0
arm64                randconfig-002-20260806    gcc-11.5.0
arm64                randconfig-002-20260806    gcc-13.4.0
arm64                randconfig-002-20260807    gcc-16.1.0
arm64                randconfig-003-20260806    clang-17
arm64                randconfig-003-20260806    gcc-13.4.0
arm64                randconfig-003-20260807    gcc-16.1.0
arm64                randconfig-004-20260806    clang-17
arm64                randconfig-004-20260806    gcc-13.4.0
arm64                randconfig-004-20260807    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260806    gcc-13.4.0
csky                 randconfig-001-20260806    gcc-15.2.0
csky                 randconfig-001-20260807    gcc-16.1.0
csky                 randconfig-002-20260806    gcc-13.4.0
csky                 randconfig-002-20260807    gcc-16.1.0
hexagon              randconfig-001-20260806    clang-24
hexagon              randconfig-001-20260807    clang-18
hexagon              randconfig-002-20260806    clang-24
hexagon              randconfig-002-20260807    clang-18
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260806    gcc-14
i386       buildonly-randconfig-001-20260807    gcc-13
i386       buildonly-randconfig-002-20260806    gcc-14
i386       buildonly-randconfig-002-20260807    gcc-13
i386       buildonly-randconfig-003-20260806    clang-22
i386       buildonly-randconfig-003-20260806    gcc-14
i386       buildonly-randconfig-003-20260807    gcc-13
i386       buildonly-randconfig-004-20260806    clang-22
i386       buildonly-randconfig-004-20260806    gcc-14
i386       buildonly-randconfig-004-20260807    gcc-13
i386       buildonly-randconfig-005-20260806    gcc-14
i386       buildonly-randconfig-005-20260807    gcc-13
i386       buildonly-randconfig-006-20260806    gcc-14
i386       buildonly-randconfig-006-20260807    gcc-13
i386                 randconfig-001-20260806    clang-22
i386                 randconfig-001-20260806    gcc-14
i386                 randconfig-002-20260806    clang-22
i386                 randconfig-003-20260806    clang-22
i386                 randconfig-003-20260806    gcc-14
i386                 randconfig-004-20260806    clang-22
i386                 randconfig-005-20260806    clang-22
i386                 randconfig-006-20260806    clang-22
i386                 randconfig-007-20260806    clang-22
i386                 randconfig-007-20260806    gcc-14
i386                 randconfig-011-20260806    clang-22
i386                 randconfig-011-20260807    clang-22
i386                 randconfig-012-20260806    clang-22
i386                 randconfig-012-20260807    clang-22
i386                 randconfig-013-20260806    clang-22
i386                 randconfig-013-20260807    clang-22
i386                 randconfig-014-20260806    clang-22
i386                 randconfig-014-20260807    clang-22
i386                 randconfig-015-20260806    clang-22
i386                 randconfig-015-20260806    gcc-13
i386                 randconfig-015-20260807    clang-22
i386                 randconfig-016-20260806    clang-22
i386                 randconfig-016-20260807    clang-22
i386                 randconfig-017-20260806    clang-22
i386                 randconfig-017-20260807    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260806    clang-22
loongarch            randconfig-001-20260806    clang-24
loongarch            randconfig-001-20260807    clang-18
loongarch            randconfig-002-20260806    clang-24
loongarch            randconfig-002-20260807    clang-18
m68k                      m5208evb_defconfig    gcc-16.1.0
m68k                         sun3x_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260806    clang-24
nios2                randconfig-001-20260806    gcc-9.5.0
nios2                randconfig-001-20260807    clang-18
nios2                randconfig-002-20260806    clang-24
nios2                randconfig-002-20260806    gcc-11.5.0
nios2                randconfig-002-20260807    clang-18
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260806    gcc-8.5.0
parisc               randconfig-001-20260807    gcc-8.5.0
parisc               randconfig-002-20260806    gcc-8.5.0
parisc               randconfig-002-20260807    gcc-8.5.0
powerpc              randconfig-001-20260806    gcc-11.5.0
powerpc              randconfig-001-20260806    gcc-8.5.0
powerpc              randconfig-001-20260807    gcc-8.5.0
powerpc              randconfig-002-20260806    gcc-8.5.0
powerpc              randconfig-002-20260807    gcc-8.5.0
powerpc64            randconfig-001-20260806    gcc-8.5.0
powerpc64            randconfig-001-20260807    gcc-8.5.0
powerpc64            randconfig-002-20260806    clang-22
powerpc64            randconfig-002-20260806    gcc-8.5.0
powerpc64            randconfig-002-20260807    gcc-8.5.0
riscv                randconfig-001-20260806    gcc-13.4.0
riscv                randconfig-001-20260807    gcc-12.5.0
riscv                randconfig-002-20260806    gcc-13.4.0
riscv                randconfig-002-20260806    gcc-8.5.0
riscv                randconfig-002-20260807    gcc-12.5.0
s390                 randconfig-001-20260806    clang-24
s390                 randconfig-001-20260806    gcc-13.4.0
s390                 randconfig-001-20260807    gcc-12.5.0
s390                 randconfig-002-20260806    clang-24
s390                 randconfig-002-20260806    gcc-13.4.0
s390                 randconfig-002-20260807    gcc-12.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260806    gcc-11.5.0
sh                   randconfig-001-20260806    gcc-13.4.0
sh                   randconfig-001-20260807    gcc-12.5.0
sh                   randconfig-002-20260806    gcc-13.4.0
sh                   randconfig-002-20260806    gcc-16.1.0
sh                   randconfig-002-20260807    gcc-12.5.0
sparc                         randconfig-001    gcc-8.5.0
sparc                randconfig-001-20260806    gcc-16.1.0
sparc                randconfig-001-20260806    gcc-8.5.0
sparc                randconfig-001-20260807    gcc-16.1.0
sparc                randconfig-002-20260806    gcc-8.5.0
sparc                randconfig-002-20260807    gcc-16.1.0
sparc64              randconfig-001-20260806    clang-20
sparc64              randconfig-001-20260806    gcc-8.5.0
sparc64              randconfig-001-20260807    gcc-16.1.0
sparc64              randconfig-002-20260806    gcc-8.5.0
sparc64              randconfig-002-20260807    gcc-16.1.0
um                   randconfig-001-20260806    gcc-14
um                   randconfig-001-20260806    gcc-8.5.0
um                   randconfig-001-20260807    gcc-16.1.0
um                   randconfig-002-20260806    gcc-14
um                   randconfig-002-20260806    gcc-8.5.0
um                   randconfig-002-20260807    gcc-16.1.0
x86_64     buildonly-randconfig-001-20260806    clang-22
x86_64     buildonly-randconfig-001-20260807    clang-22
x86_64     buildonly-randconfig-002-20260806    clang-22
x86_64     buildonly-randconfig-002-20260807    clang-22
x86_64     buildonly-randconfig-003-20260806    clang-22
x86_64     buildonly-randconfig-003-20260806    gcc-14
x86_64     buildonly-randconfig-003-20260807    clang-22
x86_64     buildonly-randconfig-004-20260806    clang-22
x86_64     buildonly-randconfig-004-20260807    clang-22
x86_64     buildonly-randconfig-005-20260806    clang-22
x86_64     buildonly-randconfig-005-20260806    gcc-14
x86_64     buildonly-randconfig-005-20260807    clang-22
x86_64     buildonly-randconfig-006-20260806    clang-22
x86_64     buildonly-randconfig-006-20260806    gcc-14
x86_64     buildonly-randconfig-006-20260807    clang-22
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260806    clang-22
x86_64               randconfig-001-20260807    clang-22
x86_64               randconfig-002-20260806    clang-22
x86_64               randconfig-002-20260807    clang-22
x86_64               randconfig-003-20260806    clang-22
x86_64               randconfig-003-20260806    gcc-14
x86_64               randconfig-003-20260807    clang-22
x86_64               randconfig-004-20260806    clang-22
x86_64               randconfig-004-20260807    clang-22
x86_64               randconfig-005-20260806    clang-22
x86_64               randconfig-005-20260807    clang-22
x86_64               randconfig-006-20260806    clang-22
x86_64               randconfig-006-20260806    gcc-14
x86_64               randconfig-006-20260807    clang-22
x86_64               randconfig-011-20260806    clang-22
x86_64               randconfig-011-20260807    clang-22
x86_64               randconfig-012-20260806    clang-22
x86_64               randconfig-012-20260806    gcc-12
x86_64               randconfig-012-20260807    clang-22
x86_64               randconfig-013-20260806    clang-22
x86_64               randconfig-013-20260807    clang-22
x86_64               randconfig-014-20260806    clang-22
x86_64               randconfig-014-20260807    clang-22
x86_64               randconfig-015-20260806    clang-22
x86_64               randconfig-015-20260807    clang-22
x86_64               randconfig-016-20260806    clang-22
x86_64               randconfig-016-20260806    gcc-14
x86_64               randconfig-016-20260807    clang-22
x86_64               randconfig-071-20260806    gcc-14
x86_64               randconfig-071-20260807    clang-22
x86_64               randconfig-072-20260806    gcc-14
x86_64               randconfig-072-20260807    clang-22
x86_64               randconfig-073-20260806    gcc-14
x86_64               randconfig-073-20260807    clang-22
x86_64               randconfig-074-20260806    gcc-14
x86_64               randconfig-074-20260807    clang-22
x86_64               randconfig-075-20260806    clang-22
x86_64               randconfig-075-20260806    gcc-14
x86_64               randconfig-075-20260807    clang-22
x86_64               randconfig-076-20260806    gcc-14
x86_64               randconfig-076-20260807    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260806    gcc-14.3.0
xtensa               randconfig-001-20260806    gcc-8.5.0
xtensa               randconfig-001-20260807    gcc-16.1.0
xtensa               randconfig-002-20260806    gcc-16.1.0
xtensa               randconfig-002-20260806    gcc-8.5.0
xtensa               randconfig-002-20260807    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
