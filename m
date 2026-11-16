Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830617;
	b=hBync96X+ePZB7PD3pYPWvAvrgc9XG47l254be6jlxtBdEx8XpwZpIcAEFlxM9tpzuoC
	 2zvCWGD3AU9xTPIC04GYwa/+VGRPraBhODG2UfKXTePky/fNzISw7vQjoa9sI5jNEAB8D
	 c2TClKrtOuy/A49MPnvmij7nLxwxkcTTLquoE16cj2vQOSbYwf1QOIkFGz3/HZ6aGUPbm
	 u5Z1n4Xv3AD25ozz7KU138P1gnZlT6c2ztelKS3iY+xSnVrOxZ9dquvgknVIQHYYg96pe
	 HM+b+J0t9+E9VE6HFy+RKOYdUBhfC7Y4N2f/7aWF4E+5OXz9zb51etxUtfoN5UvvucA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830617;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=KAKjwwyfM8GckuDatAx4YODngPInnYZ8fpr560EFydE=;
	b=hdukG4Gd4bT66NWqzSGNRuhUhkDh/ZJmu8PmVHO9XzlaZkJrsQPF11V/mESWRNLTl/NM
	 VVb3VrsZP214I357UQxIqo9kt0cyBJ5ySZ75I9hqcpJK+oWBTyLHqA7BTRQXb/qSizK6c
	 SbMMIW7SN+02kNDh94cWdDZQCUeYHNB9gXeBH0IcMvKYEK4IkQkdU+wcAbqVePJhm9YeR
	 5TSlOo4fkU2OWr4wX/kY3jLoQR4tIFBc22TsOehD6uMUf1F1rL6zwHYG4Q00q1dN8PgwR
	 Am/Da0LJ2xKjVQ3lxJuo93cL+he3Ip8h4x97BXYPMq/vdlMegJ3XkQGh+g2/63FbdKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UxuP0GbT;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BA2606A32F
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 12:03:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4BA2606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UxuP0GbT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794830617; x=1826366617;
  h=date:from:to:cc:subject:message-id;
  bh=MTQnye4tdhZU1RABFGkyud7MbQ4LpmWOooDeIn3iXZA=;
  b=UxuP0GbTMRZf8QSZgDO5LOSUJbVji1CdlZK1GUrDl/rhU8KwfIWVV+7r
   c2jfH2DC2b9B0uqGHlyiHjVulS6cq3eaj3MlLlLtKLKbCxbMKGs3b2Xon
   75VNIkVXhoHibi6S23aJlDoQ8CnTsOtiiU34fAkWRwTWVKI8elXD/Ac9x
   MhX1Slqz9xH5yFUpJErMwt50TzHCRQgiry4Z/5P6MEKFtc5eCDy0eheOd
   8hhGvEyw4uLzkrtmnnB3hj8X1okl26D8bEQLRvq5SbI0WA//De1eiMaLo
   cCVkOLWBS7GRXia3PcGv/vwBMiPB+np+9JJzCyznHz/K6nxE7RDk/apKM
   A==;
X-CSE-ConnectionGUID: noPtNyNJQBi4uJtuXj3kpg==
X-CSE-MsgGUID: rhlBj15SQbikvX9bxkyyEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11967"; a="3552906"
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="3552906"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 04:03:37 -0800
X-CSE-ConnectionGUID: 9wlIlVGHRj+6u3paDlEkQw==
X-CSE-MsgGUID: Jb5si7C1TO6bn3TnN9r8PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="9427047"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 16 Nov 2026 04:03:34 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSvQq-000000018U4-0RY5;
	Mon, 16 Nov 2026 12:03:32 +0000
Date: Mon, 16 Nov 2026 20:02:33 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 0bce4c3c7589a80b09a4f21fcb41811cca5153a1
Message-ID: <20261116200233.QOfRd5KG-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0bce4c3c7589a80b09a4f21fcb41811cca5153a1  lib/test_xarray: check unused spare node after range creation

elapsed time: 918m

configs tested: 616
configs skipped: 15

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261115    gcc-14.4.0
alpha                 randconfig-2000-20261115    gcc-8.5.0
alpha                 randconfig-2000-20261116    gcc-10.5.0
alpha                 randconfig-2001-20261115    gcc-16.2.0
alpha                 randconfig-2001-20261115    gcc-8.5.0
alpha                 randconfig-2001-20261116    gcc-10.5.0
alpha                 randconfig-2200-20261115    gcc-8.5.0  smatch
alpha                 randconfig-2200-20261116    gcc-15.3.0 smatch
alpha                randconfig-r2102-20261115    gcc-8.5.0  cocci
alpha                randconfig-r2105-20261115    gcc-8.5.0  cocci
alpha                randconfig-r2109-20261115    gcc-13.5.0 cocci
alpha                randconfig-r2111-20261115    gcc-13.5.0 cocci
alpha                randconfig-r2111-20261115    gcc-15.3.0 cocci
alpha                randconfig-r2310-20261115    gcc-11.5.0 sparse
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                  nsimosci_hs_smp_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261116    gcc-8.5.0
arc                   randconfig-1001-20261116    gcc-8.5.0
arc                   randconfig-2000-20261115    gcc-8.5.0
arc                   randconfig-2000-20261116    gcc-13.5.0
arc                   randconfig-2001-20261115    gcc-16.2.0
arc                   randconfig-2001-20261115    gcc-8.5.0
arc                   randconfig-2001-20261116    gcc-13.5.0
arc                   randconfig-2002-20261115    gcc-14.4.0
arc                   randconfig-2002-20261115    gcc-8.5.0
arc                   randconfig-2002-20261116    gcc-13.5.0
arc                   randconfig-2003-20261115    gcc-16.2.0
arc                   randconfig-2003-20261115    gcc-8.5.0
arc                   randconfig-2003-20261116    gcc-13.5.0
arc                   randconfig-2004-20261115    gcc-8.5.0
arc                   randconfig-2004-20261116    gcc-13.5.0
arc                   randconfig-2005-20261115    gcc-8.5.0
arc                   randconfig-2005-20261116    gcc-13.5.0
arc                   randconfig-2200-20261115    gcc-16.2.0 smatch
arc                  randconfig-r2100-20261115    gcc-8.5.0  cocci
arc                  randconfig-r2101-20261115    gcc-8.5.0  cocci
arc                  randconfig-r2103-20261115    gcc-8.5.0  cocci
arc                  randconfig-r2108-20261115    gcc-13.5.0 cocci
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                        aspeed_g5_defconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                        imx_v4_v5_defconfig    clang-24
arm                           moxart_defconfig    gcc-16.2.0
arm                              mxs_defconfig    clang-17
arm                   randconfig-1000-20261116    gcc-8.5.0
arm                   randconfig-1001-20261116    gcc-8.5.0
arm                   randconfig-1002-20261116    gcc-8.5.0
arm                   randconfig-1003-20261116    gcc-8.5.0
arm                   randconfig-2000-20261115    clang-24
arm                   randconfig-2000-20261116    gcc-15.3.0
arm                   randconfig-2001-20261115    clang-24
arm                   randconfig-2001-20261115    gcc-10.5.0
arm                   randconfig-2001-20261116    gcc-15.3.0
arm                   randconfig-2002-20261115    clang-24
arm                   randconfig-2002-20261115    gcc-8.5.0
arm                   randconfig-2002-20261116    gcc-15.3.0
arm                   randconfig-2200-20261115    clang-17   smatch
arm                   randconfig-2200-20261116    gcc-13.5.0 smatch
arm                  randconfig-r2101-20261115    gcc-8.5.0  cocci
arm                  randconfig-r2102-20261115    gcc-10.5.0 cocci
arm                  randconfig-r2104-20261115    gcc-15.3.0 cocci
arm                  randconfig-r2104-20261115    gcc-8.5.0  cocci
arm                  randconfig-r2105-20261115    gcc-15.3.0 cocci
arm                  randconfig-r2106-20261115    gcc-8.5.0  cocci
arm                  randconfig-r2109-20261115    gcc-11.5.0 cocci
arm                  randconfig-r2306-20261115    gcc-11.5.0 sparse
arm                  randconfig-r2308-20261115    gcc-11.5.0 sparse
arm                  randconfig-r2309-20261115    clang-22   sparse
arm                         realview_defconfig    clang-17
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261116    gcc-10.5.0
arm64                 randconfig-1000-20261116    gcc-8.5.0
arm64                 randconfig-1001-20261116    clang-24
arm64                 randconfig-1001-20261116    gcc-10.5.0
arm64                 randconfig-1002-20261116    gcc-10.5.0
arm64                 randconfig-1002-20261116    gcc-13.5.0
arm64                 randconfig-1003-20261116    gcc-10.5.0
arm64                 randconfig-1003-20261116    gcc-15.3.0
arm64                 randconfig-2000-20261115    clang-24
arm64                 randconfig-2000-20261115    gcc-13.5.0
arm64                 randconfig-2000-20261116    gcc-15.3.0
arm64                 randconfig-2001-20261115    clang-22
arm64                 randconfig-2001-20261115    clang-24
arm64                 randconfig-2001-20261116    gcc-15.3.0
arm64                 randconfig-2002-20261115    clang-24
arm64                 randconfig-2002-20261115    gcc-8.5.0
arm64                 randconfig-2002-20261116    gcc-15.3.0
arm64                 randconfig-2200-20261115    gcc-15.3.0 smatch
arm64                 randconfig-2200-20261116    gcc-8.5.0  smatch
arm64                randconfig-r2102-20261115    gcc-14     cocci
arm64                randconfig-r2104-20261115    gcc-8.5.0  cocci
arm64                randconfig-r2107-20261115    gcc-8.5.0  cocci
arm64                randconfig-r2110-20261115    gcc-8.5.0  cocci
arm64                randconfig-r2306-20261115    clang-20   sparse
arm64                randconfig-r2307-20261115    clang-20   sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261116    gcc-10.5.0
csky                  randconfig-1001-20261116    gcc-10.5.0
csky                  randconfig-1001-20261116    gcc-16.2.0
csky                  randconfig-2000-20261115    gcc-14.4.0
csky                  randconfig-2000-20261116    gcc-16.2.0
csky                  randconfig-2001-20261115    gcc-12.5.0
csky                  randconfig-2001-20261115    gcc-14.4.0
csky                  randconfig-2001-20261116    gcc-16.2.0
csky                  randconfig-2200-20261115    gcc-12.5.0 smatch
csky                  randconfig-2200-20261116    gcc-16.2.0 smatch
csky                 randconfig-r2103-20261115    gcc-13.5.0 cocci
csky                 randconfig-r2106-20261115    gcc-16.2.0 cocci
csky                 randconfig-r2110-20261115    gcc-16.2.0 cocci
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261116    clang-17
hexagon               randconfig-1001-20261116    clang-17
hexagon               randconfig-2000-20261115    clang-24
hexagon               randconfig-2000-20261115    gcc-14.4.0
hexagon               randconfig-2000-20261116    gcc-16.2.0
hexagon               randconfig-2001-20261115    clang-24
hexagon               randconfig-2001-20261115    gcc-14.4.0
hexagon               randconfig-2001-20261116    gcc-16.2.0
hexagon               randconfig-2200-20261115    clang-24   smatch
hexagon              randconfig-r2109-20261115    gcc-8.5.0  cocci
hexagon              randconfig-r2301-20261115    clang-24   sparse
hexagon              randconfig-r2310-20261115    clang-20   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261116    gcc-14
i386        buildonly-randconfig-1001-20261116    gcc-12
i386        buildonly-randconfig-1001-20261116    gcc-14
i386        buildonly-randconfig-1002-20261116    clang-22
i386        buildonly-randconfig-1002-20261116    gcc-14
i386        buildonly-randconfig-1003-20261116    gcc-14
i386        buildonly-randconfig-1004-20261116    clang-22
i386        buildonly-randconfig-1004-20261116    gcc-14
i386        buildonly-randconfig-1005-20261116    gcc-14
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261116    gcc-14
i386                  randconfig-1001-20261116    gcc-14
i386                  randconfig-1002-20261116    gcc-14
i386                  randconfig-1003-20261116    gcc-14
i386                  randconfig-1004-20261116    gcc-14
i386                  randconfig-1005-20261116    gcc-14
i386                  randconfig-1006-20261116    gcc-14
i386                  randconfig-2000-20261115    gcc-14
i386                  randconfig-2000-20261116    gcc-14
i386                  randconfig-2001-20261115    gcc-14
i386                  randconfig-2001-20261116    gcc-14
i386                  randconfig-2002-20261115    gcc-12
i386                  randconfig-2002-20261115    gcc-14
i386                  randconfig-2002-20261116    gcc-14
i386                  randconfig-2003-20261115    clang-22
i386                  randconfig-2003-20261115    gcc-14
i386                  randconfig-2003-20261116    gcc-14
i386                  randconfig-2004-20261115    gcc-14
i386                  randconfig-2004-20261116    gcc-14
i386                  randconfig-2005-20261115    gcc-12
i386                  randconfig-2005-20261115    gcc-14
i386                  randconfig-2005-20261116    gcc-14
i386                  randconfig-2100-20261115    clang-22   cocci
i386                  randconfig-2100-20261115    gcc-14     cocci
i386                  randconfig-2101-20261115    clang-22   cocci
i386                  randconfig-2101-20261115    gcc-14     cocci
i386                  randconfig-2102-20261115    clang-22   cocci
i386                  randconfig-2102-20261115    gcc-14     cocci
i386                  randconfig-2103-20261115    gcc-14     cocci
i386                  randconfig-2104-20261115    gcc-14     cocci
i386                  randconfig-2105-20261115    gcc-14     cocci
i386                  randconfig-2200-20261115    gcc-14     smatch
i386                  randconfig-2200-20261116    gcc-14     smatch
i386                  randconfig-2300-20261115    clang-22   sparse
i386                  randconfig-2301-20261115    clang-22   sparse
i386                  randconfig-2301-20261115    gcc-14     sparse
i386                  randconfig-2302-20261115    clang-22   sparse
i386                 randconfig-r2100-20261116    gcc-16.2.0 cocci
i386                 randconfig-r2102-20261116    gcc-16.2.0 cocci
i386                 randconfig-r2108-20261115    gcc-14     cocci
i386                 randconfig-r2300-20261115    gcc-8.5.0  sparse
i386                 randconfig-r2304-20261115    gcc-8.5.0  sparse
i386                 randconfig-r2307-20261115    clang-22   sparse
i386                 randconfig-r2311-20261115    clang-20   sparse
i386                 randconfig-r2311-20261115    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261116    clang-17
loongarch             randconfig-1001-20261116    clang-17
loongarch             randconfig-2000-20261115    gcc-16.2.0
loongarch             randconfig-2000-20261115    gcc-8.5.0
loongarch             randconfig-2000-20261116    gcc-11.5.0
loongarch             randconfig-2001-20261115    clang-20
loongarch             randconfig-2001-20261115    gcc-8.5.0
loongarch             randconfig-2001-20261116    gcc-11.5.0
loongarch             randconfig-2200-20261115    gcc-16.2.0 smatch
loongarch             randconfig-2200-20261116    clang-19   smatch
loongarch            randconfig-r2109-20261115    gcc-13.5.0 cocci
loongarch            randconfig-r2111-20261116    gcc-14.4.0 cocci
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5208evb_defconfig    clang-17
m68k                        m5329evb_defconfig    clang-17
m68k                  randconfig-2000-20261115    gcc-15.3.0
m68k                  randconfig-2000-20261115    gcc-8.5.0
m68k                  randconfig-2000-20261116    gcc-10.5.0
m68k                  randconfig-2001-20261115    gcc-8.5.0
m68k                  randconfig-2001-20261116    gcc-10.5.0
m68k                  randconfig-2200-20261115    gcc-8.5.0  smatch
m68k                  randconfig-2200-20261116    gcc-14.4.0 smatch
m68k                 randconfig-r2102-20261115    gcc-8.5.0  cocci
m68k                 randconfig-r2105-20261115    gcc-8.5.0  cocci
m68k                 randconfig-r2111-20261115    gcc-16.2.0 cocci
m68k                 randconfig-r2111-20261115    gcc-8.5.0  cocci
m68k                 randconfig-r2304-20261115    gcc-8.5.0  sparse
m68k                 randconfig-r2310-20261115    clang-22   sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261115    gcc-10.5.0
microblaze            randconfig-2000-20261115    gcc-8.5.0
microblaze            randconfig-2000-20261116    gcc-10.5.0
microblaze            randconfig-2001-20261115    gcc-16.2.0
microblaze            randconfig-2001-20261115    gcc-8.5.0
microblaze            randconfig-2001-20261116    gcc-10.5.0
microblaze            randconfig-2200-20261115    gcc-12.5.0 smatch
microblaze            randconfig-2200-20261116    gcc-11.5.0 smatch
microblaze           randconfig-r2104-20261115    gcc-8.5.0  cocci
microblaze           randconfig-r2108-20261115    gcc-16.2.0 cocci
microblaze           randconfig-r2301-20261115    gcc-8.5.0  sparse
microblaze           randconfig-r2306-20261115    clang-22   sparse
microblaze           randconfig-r2311-20261115    gcc-11.5.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath25_defconfig    clang-24
mips                   cavium_octeon_defconfig    clang-17
mips                          cobalt_defconfig    gcc-16.2.0
mips                            ip28_defconfig    gcc-16.2.0
mips                            jazz_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261115    clang-17
mips                  randconfig-2000-20261115    gcc-10.5.0
mips                  randconfig-2001-20261115    clang-20
mips                  randconfig-2001-20261115    gcc-10.5.0
mips                  randconfig-2002-20261115    clang-24
mips                  randconfig-2002-20261115    gcc-10.5.0
mips                  randconfig-2200-20261115    clang-24   smatch
mips                  randconfig-2200-20261116    gcc-8.5.0  smatch
mips                 randconfig-r2108-20261116    gcc-14.4.0 cocci
mips                 randconfig-r2111-20261115    gcc-13.5.0 cocci
mips                 randconfig-r2300-20261115    clang-24   sparse
mips                 randconfig-r2302-20261115    clang-17   sparse
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261116    clang-17
nios2                 randconfig-1001-20261116    clang-17
nios2                 randconfig-2000-20261115    gcc-8.5.0
nios2                 randconfig-2000-20261116    gcc-11.5.0
nios2                 randconfig-2001-20261115    gcc-8.5.0
nios2                 randconfig-2001-20261116    gcc-11.5.0
nios2                 randconfig-2200-20261115    gcc-11.5.0 smatch
nios2                randconfig-r2100-20261115    gcc-11.5.0 cocci
nios2                randconfig-r2103-20261115    gcc-14     cocci
nios2                randconfig-r2302-20261115    clang-24   sparse
nios2                randconfig-r2309-20261115    gcc-11.5.0 sparse
nios2                randconfig-r2310-20261115    gcc-16.2.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261115    gcc-10.5.0
openrisc              randconfig-2001-20261115    gcc-10.5.0
openrisc              randconfig-2001-20261115    gcc-12.5.0
openrisc              randconfig-2002-20261115    gcc-10.5.0
openrisc              randconfig-2200-20261115    gcc-12.5.0 smatch
openrisc              randconfig-2200-20261116    gcc-15.3.0 smatch
openrisc             randconfig-r2100-20261115    gcc-8.5.0  cocci
openrisc             randconfig-r2103-20261115    gcc-15.3.0 cocci
openrisc             randconfig-r2306-20261115    gcc-16.2.0 sparse
openrisc             randconfig-r2307-20261115    gcc-11.5.0 sparse
openrisc             randconfig-r2308-20261115    clang-20   sparse
openrisc             randconfig-r2311-20261115    gcc-10.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-2000-20261115    gcc-8.5.0
parisc                randconfig-2000-20261116    gcc-11.5.0
parisc                randconfig-2001-20261115    gcc-14.4.0
parisc                randconfig-2001-20261115    gcc-8.5.0
parisc                randconfig-2001-20261116    gcc-11.5.0
parisc                randconfig-2200-20261115    gcc-10.5.0 smatch
parisc               randconfig-r2101-20261116    gcc-16.2.0 cocci
parisc               randconfig-r2104-20261115    gcc-11.5.0 cocci
parisc               randconfig-r2105-20261115    gcc-14     cocci
parisc               randconfig-r2107-20261115    gcc-13.5.0 cocci
parisc               randconfig-r2108-20261115    gcc-8.5.0  cocci
parisc               randconfig-r2309-20261115    clang-20   sparse
parisc               randconfig-r2310-20261115    gcc-10.5.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                        eiger_defconfig    clang-17
powerpc                       ep88xc_defconfig    clang-24
powerpc                     gamecube_defconfig    clang-24
powerpc                        holly_defconfig    clang-24
powerpc                     mvme5100_defconfig    clang-24
powerpc                      powernv_defconfig    clang-24
powerpc               randconfig-2000-20261115    gcc-15.3.0
powerpc               randconfig-2000-20261115    gcc-8.5.0
powerpc               randconfig-2000-20261116    clang-17
powerpc               randconfig-2001-20261115    gcc-8.5.0
powerpc               randconfig-2001-20261115    gcc-9.5.0
powerpc               randconfig-2001-20261116    clang-17
powerpc               randconfig-2002-20261115    clang-24
powerpc               randconfig-2002-20261115    gcc-8.5.0
powerpc               randconfig-2002-20261116    clang-17
powerpc               randconfig-2200-20261115    clang-17   smatch
powerpc              randconfig-r2103-20261115    gcc-8.5.0  cocci
powerpc              randconfig-r2106-20261116    gcc-14.4.0 cocci
powerpc              randconfig-r2301-20261115    clang-24   sparse
powerpc              randconfig-r2307-20261115    gcc-16.2.0 sparse
powerpc                      stx_gp3_defconfig    clang-24
powerpc                         warp_defconfig    clang-24
powerpc64             randconfig-2000-20261115    gcc-13.5.0
powerpc64             randconfig-2000-20261115    gcc-8.5.0
powerpc64             randconfig-2000-20261116    clang-17
powerpc64             randconfig-2001-20261115    gcc-8.5.0
powerpc64             randconfig-2001-20261116    clang-17
powerpc64             randconfig-2002-20261115    gcc-8.5.0
powerpc64             randconfig-2002-20261116    clang-17
powerpc64             randconfig-2200-20261115    clang-24   smatch
powerpc64             randconfig-2200-20261116    clang-19   smatch
powerpc64            randconfig-r2300-20261115    gcc-10.5.0 sparse
powerpc64            randconfig-r2304-20261115    clang-24   sparse
powerpc64            randconfig-r2308-20261115    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261116    clang-17
riscv                 randconfig-1000-20261116    gcc-15.3.0
riscv                 randconfig-1001-20261116    clang-17
riscv                 randconfig-1001-20261116    gcc-9.5.0
riscv                 randconfig-2000-20261115    clang-20
riscv                 randconfig-2000-20261115    gcc-8.5.0
riscv                 randconfig-2001-20261115    gcc-8.5.0
riscv                 randconfig-2002-20261115    gcc-11.5.0
riscv                 randconfig-2002-20261115    gcc-8.5.0
riscv                 randconfig-2003-20261115    gcc-8.5.0
riscv                 randconfig-2004-20261115    gcc-15.3.0
riscv                 randconfig-2004-20261115    gcc-8.5.0
riscv                 randconfig-2005-20261115    gcc-8.5.0
riscv                 randconfig-2005-20261115    gcc-9.5.0
riscv                 randconfig-2200-20261115    clang-24   smatch
riscv                 randconfig-2200-20261116    clang-24   smatch
riscv                randconfig-r2105-20261115    gcc-11.5.0 cocci
riscv                randconfig-r2106-20261115    gcc-13.5.0 cocci
riscv                randconfig-r2107-20261115    clang-24   cocci
riscv                randconfig-r2305-20261115    gcc-8.5.0  sparse
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261116    clang-17
s390                  randconfig-1000-20261116    gcc-8.5.0
s390                  randconfig-1001-20261116    clang-17
s390                  randconfig-2000-20261115    gcc-11.5.0
s390                  randconfig-2000-20261115    gcc-13.5.0
s390                  randconfig-2001-20261115    clang-17
s390                  randconfig-2001-20261115    gcc-13.5.0
s390                  randconfig-2002-20261115    clang-24
s390                  randconfig-2002-20261115    gcc-13.5.0
s390                  randconfig-2003-20261115    clang-24
s390                  randconfig-2003-20261115    gcc-13.5.0
s390                  randconfig-2004-20261115    gcc-13.5.0
s390                  randconfig-2004-20261115    gcc-8.5.0
s390                  randconfig-2005-20261115    gcc-13.5.0
s390                  randconfig-2200-20261115    clang-24   smatch
s390                 randconfig-r2110-20261115    gcc-13.5.0 cocci
s390                 randconfig-r2305-20261115    clang-19   sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                         edosk7760_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261116    clang-17
sh                    randconfig-1000-20261116    gcc-14.4.0
sh                    randconfig-1001-20261116    clang-17
sh                    randconfig-1001-20261116    gcc-16.2.0
sh                    randconfig-2000-20261115    gcc-10.5.0
sh                    randconfig-2000-20261115    gcc-12.5.0
sh                    randconfig-2001-20261115    gcc-12.5.0
sh                    randconfig-2002-20261115    gcc-10.5.0
sh                    randconfig-2002-20261115    gcc-12.5.0
sh                    randconfig-2003-20261115    gcc-12.5.0
sh                    randconfig-2003-20261115    gcc-16.2.0
sh                    randconfig-2004-20261115    gcc-10.5.0
sh                    randconfig-2004-20261115    gcc-12.5.0
sh                    randconfig-2005-20261115    gcc-12.5.0
sh                    randconfig-2200-20261115    gcc-16.2.0 smatch
sh                    randconfig-2200-20261116    gcc-15.3.0 smatch
sh                   randconfig-r2102-20261115    gcc-8.5.0  cocci
sh                   randconfig-r2104-20261116    gcc-16.2.0 cocci
sh                   randconfig-r2107-20261115    gcc-16.2.0 cocci
sh                   randconfig-r2309-20261115    gcc-11.5.0 sparse
sh                       rts7751r2d1_defconfig    gcc-16.2.0
sh                           sdk7786_defconfig    clang-17
sh                            se7206_defconfig    clang-17
sh                            se7619_defconfig    gcc-16.2.0
sh                   sh7785lcr_32bit_defconfig    gcc-16.2.0
sh                               ul2_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261116    gcc-16.2.0
sparc                 randconfig-1001-20261116    gcc-16.2.0
sparc                 randconfig-2000-20261115    clang-24
sparc                 randconfig-2000-20261115    gcc-8.5.0
sparc                 randconfig-2000-20261116    gcc-14
sparc                 randconfig-2001-20261115    clang-24
sparc                 randconfig-2001-20261115    gcc-8.5.0
sparc                 randconfig-2001-20261116    gcc-14
sparc                 randconfig-2200-20261115    gcc-16.2.0 smatch
sparc                randconfig-r2101-20261115    gcc-15.3.0 cocci
sparc                randconfig-r2107-20261116    gcc-14.4.0 cocci
sparc                randconfig-r2110-20261116    gcc-14.4.0 cocci
sparc                randconfig-r2303-20261115    gcc-8.5.0  sparse
sparc                randconfig-r2305-20261115    clang-24   sparse
sparc                randconfig-r2306-20261115    gcc-11.5.0 sparse
sparc                        sparc64_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261116    gcc-16.2.0
sparc64               randconfig-1001-20261116    gcc-16.2.0
sparc64               randconfig-2000-20261115    clang-24
sparc64               randconfig-2000-20261115    gcc-15.3.0
sparc64               randconfig-2000-20261116    gcc-14
sparc64               randconfig-2001-20261115    clang-24
sparc64               randconfig-2001-20261115    gcc-9.5.0
sparc64               randconfig-2001-20261116    gcc-14
sparc64               randconfig-2200-20261115    gcc-13.5.0 smatch
sparc64               randconfig-2200-20261116    gcc-8.5.0  smatch
sparc64              randconfig-r2100-20261115    gcc-15.3.0 cocci
sparc64              randconfig-r2100-20261115    gcc-8.5.0  cocci
sparc64              randconfig-r2103-20261116    gcc-16.2.0 cocci
sparc64              randconfig-r2107-20261115    gcc-13.5.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261116    gcc-16.2.0
um                    randconfig-1001-20261116    gcc-16.2.0
um                    randconfig-2000-20261115    clang-24
um                    randconfig-2000-20261115    gcc-14
um                    randconfig-2000-20261116    gcc-14
um                    randconfig-2001-20261115    clang-24
um                    randconfig-2001-20261116    gcc-14
um                    randconfig-2200-20261115    clang-24   smatch
um                    randconfig-2200-20261116    gcc-14     smatch
um                   randconfig-r2100-20261115    gcc-14     cocci
um                   randconfig-r2104-20261115    gcc-14     cocci
um                   randconfig-r2106-20261115    clang-24   cocci
um                   randconfig-r2109-20261115    gcc-16.2.0 cocci
um                   randconfig-r2110-20261115    gcc-16.2.0 cocci
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261116    gcc-14
x86_64      buildonly-randconfig-1001-20261116    gcc-12
x86_64      buildonly-randconfig-1001-20261116    gcc-14
x86_64      buildonly-randconfig-1002-20261116    clang-22
x86_64      buildonly-randconfig-1002-20261116    gcc-14
x86_64      buildonly-randconfig-1003-20261116    clang-22
x86_64      buildonly-randconfig-1003-20261116    gcc-14
x86_64      buildonly-randconfig-1004-20261116    gcc-14
x86_64      buildonly-randconfig-1005-20261116    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261116    gcc-14
x86_64                randconfig-1001-20261116    gcc-14
x86_64                randconfig-1002-20261116    gcc-14
x86_64                randconfig-1003-20261116    gcc-14
x86_64                randconfig-1004-20261116    gcc-14
x86_64                randconfig-1005-20261116    gcc-14
x86_64                randconfig-1006-20261116    clang-22
x86_64                randconfig-1007-20261116    clang-22
x86_64                randconfig-1008-20261116    clang-22
x86_64                randconfig-1009-20261116    clang-22
x86_64                randconfig-1010-20261116    clang-22
x86_64                randconfig-1011-20261116    clang-22
x86_64                randconfig-1012-20261116    clang-22
x86_64                randconfig-1013-20261116    clang-22
x86_64                randconfig-1014-20261116    clang-22
x86_64                randconfig-1014-20261116    gcc-14
x86_64                randconfig-1015-20261116    clang-22
x86_64                randconfig-1016-20261116    clang-22
x86_64                randconfig-1017-20261116    clang-22
x86_64                randconfig-1017-20261116    gcc-14
x86_64                randconfig-2000-20261115    gcc-14
x86_64                randconfig-2000-20261116    gcc-14
x86_64                randconfig-2001-20261115    gcc-14
x86_64                randconfig-2001-20261116    gcc-14
x86_64                randconfig-2002-20261115    gcc-14
x86_64                randconfig-2002-20261116    gcc-14
x86_64                randconfig-2003-20261115    clang-22
x86_64                randconfig-2003-20261115    gcc-14
x86_64                randconfig-2003-20261116    gcc-14
x86_64                randconfig-2004-20261115    clang-22
x86_64                randconfig-2004-20261115    gcc-14
x86_64                randconfig-2004-20261116    gcc-14
x86_64                randconfig-2005-20261115    gcc-14
x86_64                randconfig-2005-20261116    gcc-14
x86_64                randconfig-2100-20261115    clang-22   cocci
x86_64                randconfig-2100-20261116    gcc-14     cocci
x86_64                randconfig-2101-20261115    clang-22   cocci
x86_64                randconfig-2101-20261116    gcc-14     cocci
x86_64                randconfig-2102-20261115    clang-22   cocci
x86_64                randconfig-2102-20261115    gcc-14     cocci
x86_64                randconfig-2102-20261116    gcc-14     cocci
x86_64                randconfig-2103-20261115    clang-22   cocci
x86_64                randconfig-2103-20261116    gcc-14     cocci
x86_64                randconfig-2104-20261115    clang-22   cocci
x86_64                randconfig-2104-20261115    gcc-14     cocci
x86_64                randconfig-2104-20261116    gcc-14     cocci
x86_64                randconfig-2105-20261115    clang-22   cocci
x86_64                randconfig-2105-20261115    gcc-14     cocci
x86_64                randconfig-2105-20261116    gcc-14     cocci
x86_64                randconfig-2200-20261115    clang-22   smatch
x86_64                randconfig-2200-20261116    clang-22   smatch
x86_64                randconfig-2300-20261115    clang-22   sparse
x86_64                randconfig-2300-20261115    gcc-14     sparse
x86_64                randconfig-2301-20261115    clang-22   sparse
x86_64                randconfig-2302-20261115    clang-22   sparse
x86_64               randconfig-r2101-20261115    clang-22   cocci
x86_64               randconfig-r2101-20261115    gcc-14     cocci
x86_64               randconfig-r2101-20261115    gcc-8.5.0  cocci
x86_64               randconfig-r2102-20261115    gcc-15.3.0 cocci
x86_64               randconfig-r2105-20261115    gcc-8.5.0  cocci
x86_64               randconfig-r2105-20261116    gcc-16.2.0 cocci
x86_64               randconfig-r2110-20261115    gcc-13.5.0 cocci
x86_64               randconfig-r2302-20261115    gcc-8.5.0  sparse
x86_64               randconfig-r2303-20261115    gcc-8.5.0  sparse
x86_64               randconfig-r2311-20261115    gcc-16.2.0 sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261116    gcc-16.2.0
xtensa                randconfig-1001-20261116    gcc-16.2.0
xtensa                randconfig-2000-20261115    gcc-14.4.0
xtensa                randconfig-2000-20261115    gcc-8.5.0
xtensa                randconfig-2000-20261116    gcc-16.2.0
xtensa                randconfig-2001-20261115    gcc-10.5.0
xtensa                randconfig-2001-20261115    gcc-14.4.0
xtensa                randconfig-2001-20261116    gcc-16.2.0
xtensa                randconfig-2200-20261115    gcc-14.4.0 smatch
xtensa               randconfig-r2106-20261115    gcc-13.5.0 cocci
xtensa               randconfig-r2109-20261116    gcc-14.4.0 cocci
xtensa               randconfig-r2303-20261115    clang-24   sparse
xtensa               randconfig-r2308-20261115    clang-22   sparse
xtensa               randconfig-r2308-20261115    gcc-16.2.0 sparse
xtensa               randconfig-r2309-20261115    gcc-16.2.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
