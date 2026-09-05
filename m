Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A1A3932C8
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 06:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788588073; cv=none; b=qp9lZKQ0JgWFcBmi1RFKdLeQB6Rkc0jSNMQHZibJlPFy9HZRdmhVpEGYNwCJ/rmM4GQkuX/pQ7ihgIejpVbxmV6m49vB94vlgWLzFsdx39pUKkjAszW7lpW1Ps5idRf3BGudjc0l+MSfARDFwABgW8Rnds3uC3i3M7s0pG4p4Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788588073; c=relaxed/simple;
	bh=lM22okNgFz1OuO8OLS+hbAQLYLsF6ANgD6I/iw0cgQU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=k3bOOSpzulr4tQtUlq3VkEnZQDMuE3t5t8kKjOuQTUMA6Wn9cHl1dC7J9ibSC6YklCaU94a9Gh/I2wFwpixK1JDa9nYX8JftOdJVBFN2uP5ubTMKmHngO88SmCc0xWaxDWILRjJfy82TidwvBWevyEFZLl9UuRvV16ICrz6kisk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+I9aY96; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+I9aY96"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788588071; x=1820124071;
  h=date:from:to:cc:subject:message-id;
  bh=lM22okNgFz1OuO8OLS+hbAQLYLsF6ANgD6I/iw0cgQU=;
  b=J+I9aY96uUlyDU1JK7qhDRCq7JH4GgICLJHpPd3ZY8W5jCGjMb1nJmtm
   IQ6JmO80nf6UtH5CaYU0p4YQeN3x08gooWHiCQoQhfq07UfLnclAapNmG
   UykDtwfYnuA6cBYzBtQDq5pUIX74FzUIAUjVO5a9vqvs0Qrx6xTmEy/Bp
   tR5EbQemLZPThRPopqCqvRB9S6EpGPR3rwFQwDpYy/Woa81gfRABcW8Qw
   G15I3G8hH/P09QwF05uD2s079l4yje0N3LBnsyfhunpAKV4paqU+AaqIu
   4L0lx87SEP5ZQg1AZrfZEv7OujNW9mVpMbAypcMluKwHIzibD0f617791
   A==;
X-CSE-ConnectionGUID: 66ETm53jRH268tIVXFk6eA==
X-CSE-MsgGUID: rvolg7RwSUuezvVbEYOPGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="106601154"
X-IronPort-AV: E=Sophos;i="6.25,263,1779174000"; 
   d="scan'208";a="106601154"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 23:01:10 -0700
X-CSE-ConnectionGUID: jHx/Xdi8Qc+O/62lcj6/xA==
X-CSE-MsgGUID: Up5SPOhLSqCiO1GgvNOexw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,263,1779174000"; 
   d="scan'208";a="267655865"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 04 Sep 2026 23:01:09 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2jSc-0000000009j-28qD;
	Sat, 05 Sep 2026 06:01:06 +0000
Date: Sat, 05 Sep 2026 14:01:06 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
Message-ID: <202609051403.2OSmiAZR-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com

    mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-161-20260904
    `-- mm-memory_hotplug.c:warning:node_is_memoryless-defined-but-not-used

elapsed time: 1477m

configs tested: 52
configs skipped: 3

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon       allnoconfig    clang-24
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um           allyesconfig    gcc-14
x86_64        allnoconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
