Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597904;
	b=Z9fyKBAIWRcA0eTf09gjDpm/SZ3476tvB921V1J7qMe1WwZKoOKRYIFb3Drfj1Je/Bil
	 NnqVLULOxrUVF2WVuBPSnbTUhMx2KxRU0w6mDnyd8SghVe88QRf56rfqNRDazo+/N/XVJ
	 mUYMQec4xNejJZXVzn1fy78dSqEPeNcN8pqRLTa84qqjo6/jn2hs7ne1kPXwJ7Sz7otXW
	 q71jjA95pcBtMmpmy00Z0AXuieIS3KL5R2p7fLOiqVx+cnwDTqVvoccYMnKHPKkJUlZiz
	 nZkkvpEJiv+PdYYLG9ZLtCKkma72Ea/6gvt5uIGC8t9sPlmJ5HhPJatEM/3FPHszFqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597904;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=qJYOZcivbLq828D0xvU0z7PYgdxh2+M1Tj7NqW3b2WA=;
	b=xnUCkNhwYPM16jhpmqmcBHrz+sdShmBGdA3jnXkiF7B6wjiR/+LvL5KCKQK1/lCbwL32
	 tbWdfJUAfWXU50uNiKGXYRVNRJIVm0qVJHmJ2dDqOhyzVYIQLB2OfFWvC19ybCwqATVM/
	 aNTi9KLeZ9qLVXS9KxmVAaVO6/R3bJvJNduC4gUhkkFCpMp+zLr3IOf8WDT5IDBoPZMXT
	 XjtnCggZs9OlK4QEHc8Mg9uXGMvpZtXM59dKEa7yObUjWu7TzPTqizrI6qUpDX4Bg7S80
	 JP1WphYn1TmyEzmOsBYkPhs/fzaAJs8JxY60f+NQzlzxgALELTJmCwBrq5NjOa+b5pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bNKJSfNc;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44469606A330
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 09:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44469606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bNKJSfNc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795597904; x=1827133904;
  h=date:from:to:cc:subject:message-id;
  bh=+OsOF4mTypKI3g/2ImKggGy6etdSrh8Cg4tiZHWiKMU=;
  b=bNKJSfNcoO/T5nP/4ibedchx7t7Mc9CqpISCq6EberQfD9pibsK+I2vu
   LeQPdup7W30RZrYZdk3CrO2pj5WzEDU4E1UUIOcVyBx6eWMxxnazJaXU0
   FjFHlsrGfw/ssQYapHOwRYLUgWKFTL5CamEzU8nAStwFNOY849sBZzik/
   YleTlggOrBW6xpbDFWLl+67GQwoGiLlFr4SAalhLfDE+P7EY8UpqRWIR0
   nWBMmqmn2qdYg6PfScJ/TgsltSzo/+v09H66STQ21zUPC369ZI037+68O
   iAl2nStNDs6Nm3bQ+g0PVmT0V8m81uOl4F4gD8713WhVchen2J7piFVq1
   g==;
X-CSE-ConnectionGUID: x+/g9YeUQdm+6Ioq6jV/ZQ==
X-CSE-MsgGUID: M0QDjzUwSja4K9+mfz3//w==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4356528"
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="4356528"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 01:11:42 -0800
X-CSE-ConnectionGUID: gBo5neSdSmmOZ4gpTwlfPA==
X-CSE-MsgGUID: BJW3ILDcSNSsiV07gMSjbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="12244639"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 25 Nov 2026 01:11:40 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xW92P-00000001RDg-3Ely;
	Wed, 25 Nov 2026 09:11:37 +0000
Date: Wed, 25 Nov 2026 17:11:00 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 5bd93e4b0b357e9d0a13199887aacbf04d1ce216
Message-ID: <20261125171100.saOKmaXt-lkp@intel.com>
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
branch HEAD: 5bd93e4b0b357e9d0a13199887aacbf04d1ce216  kmsan: fix metadata loss during HugeTLB struct page reinitialization

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/20261124160931.EqppdQp5-lkp@intel.com

    drivers/hid/hid-steam.c:557 steam_send_report_id() warn: check sign expansion for '__UNIQUE_ID_x__640'

Warning ids grouped by kconfigs:

recent_errors
`-- arm64-randconfig-2200-20261124
    `-- drivers-hid-hid-steam.c-steam_send_report_id()-warn:check-sign-expansion-for-__UNIQUE_ID_x__640

elapsed time: 958m

configs tested: 486
configs skipped: 17

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261124    gcc-11.5.0
alpha                 randconfig-2000-20261124    gcc-8.5.0
alpha                 randconfig-2001-20261124    gcc-11.5.0
alpha                 randconfig-2200-20261124    gcc-8.5.0  smatch
alpha                randconfig-r2101-20261124    clang-22   cocci
alpha                randconfig-r2103-20261124    gcc-9.5.0  cocci
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261125    gcc-8.5.0
arc                   randconfig-1001-20261125    gcc-8.5.0
arc                   randconfig-2000-20261124    gcc-11.5.0
arc                   randconfig-2000-20261124    gcc-8.5.0
arc                   randconfig-2001-20261124    gcc-11.5.0
arc                   randconfig-2001-20261124    gcc-15.3.0
arc                   randconfig-2002-20261124    gcc-11.5.0
arc                   randconfig-2002-20261124    gcc-13.5.0
arc                   randconfig-2003-20261124    gcc-11.5.0
arc                   randconfig-2003-20261124    gcc-8.5.0
arc                   randconfig-2004-20261124    gcc-11.5.0
arc                   randconfig-2004-20261124    gcc-13.5.0
arc                   randconfig-2005-20261124    gcc-11.5.0
arc                   randconfig-2200-20261124    gcc-8.5.0  smatch
arc                  randconfig-r2101-20261124    gcc-16.2.0 cocci
arc                  randconfig-r2300-20261124    gcc-16.2.0 sparse
arc                  randconfig-r2307-20261124    clang-24   sparse
arc                  randconfig-r2307-20261124    gcc-10.5.0 sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                         clps711x_defconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                          lpc32xx_defconfig    clang-17
arm                           moxart_defconfig    clang-17
arm                           moxart_defconfig    clang-24
arm                          mv78xx0_defconfig    gcc-16.2.0
arm                           pxa168_defconfig    clang-17
arm                           pxa3xx_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261125    gcc-8.5.0
arm                   randconfig-1001-20261125    gcc-8.5.0
arm                   randconfig-1002-20261125    gcc-8.5.0
arm                   randconfig-1003-20261125    gcc-8.5.0
arm                   randconfig-2000-20261124    clang-17
arm                   randconfig-2000-20261124    gcc-8.5.0
arm                   randconfig-2001-20261124    clang-17
arm                   randconfig-2002-20261124    clang-17
arm                   randconfig-2002-20261124    clang-24
arm                   randconfig-2200-20261124    clang-17   smatch
arm                  randconfig-r2101-20261124    clang-24   cocci
arm                  randconfig-r2105-20261124    gcc-16.2.0 cocci
arm                  randconfig-r2300-20261124    clang-22   sparse
arm                  randconfig-r2302-20261124    clang-18   sparse
arm                  randconfig-r2303-20261124    gcc-16.2.0 sparse
arm                  randconfig-r2304-20261124    gcc-16.2.0 sparse
arm                  randconfig-r2305-20261124    gcc-14.4.0 sparse
arm                  randconfig-r2308-20261124    clang-24   sparse
arm                  randconfig-r2311-20261124    clang-24   sparse
arm                          socfpga_defconfig    clang-17
arm                           sp7021_defconfig    clang-24
arm                           sp7021_defconfig    gcc-16.2.0
arm                            u8500_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261125    clang-24
arm64                 randconfig-1001-20261125    clang-24
arm64                 randconfig-1002-20261125    clang-24
arm64                 randconfig-1003-20261125    clang-24
arm64                 randconfig-2000-20261124    clang-17
arm64                 randconfig-2000-20261124    clang-24
arm64                 randconfig-2001-20261124    clang-17
arm64                 randconfig-2001-20261124    gcc-8.5.0
arm64                 randconfig-2002-20261124    clang-17
arm64                 randconfig-2002-20261124    clang-24
arm64                 randconfig-2200-20261124    gcc-16.2.0 smatch
arm64                randconfig-r2109-20261124    clang-24   cocci
arm64                randconfig-r2111-20261124    gcc-15.3.0 cocci
arm64                randconfig-r2300-20261124    gcc-16.2.0 sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261125    clang-24
csky                  randconfig-1001-20261125    clang-24
csky                  randconfig-2000-20261124    gcc-16.2.0
csky                  randconfig-2000-20261124    gcc-9.5.0
csky                  randconfig-2001-20261124    gcc-16.2.0
csky                  randconfig-2200-20261124    gcc-15.3.0 smatch
csky                 randconfig-r2105-20261124    clang-22   cocci
csky                 randconfig-r2302-20261124    gcc-14.4.0 sparse
csky                 randconfig-r2309-20261124    clang-24   sparse
csky                 randconfig-r2311-20261124    gcc-15.3.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261125    gcc-11.5.0
hexagon               randconfig-1001-20261125    gcc-11.5.0
hexagon               randconfig-2000-20261124    clang-17
hexagon               randconfig-2000-20261124    gcc-16.2.0
hexagon               randconfig-2001-20261124    clang-17
hexagon               randconfig-2001-20261124    gcc-16.2.0
hexagon               randconfig-2200-20261125    clang-17   smatch
hexagon              randconfig-r2103-20261124    clang-22   cocci
hexagon              randconfig-r2107-20261124    gcc-14     cocci
hexagon              randconfig-r2108-20261124    clang-24   cocci
hexagon              randconfig-r2111-20261124    clang-17   cocci
hexagon              randconfig-r2302-20261124    gcc-16.2.0 sparse
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261125    clang-22
i386        buildonly-randconfig-1001-20261125    clang-22
i386        buildonly-randconfig-1002-20261125    clang-22
i386        buildonly-randconfig-1003-20261125    clang-22
i386        buildonly-randconfig-1004-20261125    clang-22
i386        buildonly-randconfig-1005-20261125    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261125    clang-22
i386                  randconfig-1001-20261125    clang-22
i386                  randconfig-1002-20261125    clang-22
i386                  randconfig-1003-20261125    clang-22
i386                  randconfig-1004-20261125    clang-22
i386                  randconfig-1005-20261125    clang-22
i386                  randconfig-1006-20261125    clang-22
i386                  randconfig-2000-20261124    clang-22
i386                  randconfig-2000-20261124    gcc-14
i386                  randconfig-2001-20261124    clang-22
i386                  randconfig-2001-20261124    gcc-14
i386                  randconfig-2002-20261124    gcc-14
i386                  randconfig-2003-20261124    clang-22
i386                  randconfig-2003-20261124    gcc-14
i386                  randconfig-2004-20261124    gcc-14
i386                  randconfig-2005-20261124    gcc-14
i386                  randconfig-2100-20261124    gcc-14     cocci
i386                  randconfig-2101-20261124    gcc-14     cocci
i386                  randconfig-2102-20261124    clang-22   cocci
i386                  randconfig-2102-20261124    gcc-14     cocci
i386                  randconfig-2103-20261124    gcc-14     cocci
i386                  randconfig-2104-20261124    gcc-12     cocci
i386                  randconfig-2104-20261124    gcc-14     cocci
i386                  randconfig-2105-20261124    gcc-14     cocci
i386                  randconfig-2200-20261124    clang-22   smatch
i386                  randconfig-2300-20261124    clang-22   sparse
i386                  randconfig-2300-20261124    gcc-14     sparse
i386                  randconfig-2301-20261124    gcc-14     sparse
i386                  randconfig-2302-20261124    clang-22   sparse
i386                  randconfig-2302-20261124    gcc-14     sparse
i386                 randconfig-r2103-20261124    gcc-16.2.0 cocci
i386                 randconfig-r2104-20261124    clang-22   cocci
i386                 randconfig-r2109-20261124    gcc-14     cocci
i386                 randconfig-r2300-20261124    clang-18   sparse
i386                 randconfig-r2300-20261124    gcc-14.4.0 sparse
i386                 randconfig-r2301-20261124    gcc-16.2.0 sparse
i386                 randconfig-r2303-20261124    clang-22   sparse
i386                 randconfig-r2303-20261124    gcc-14.4.0 sparse
i386                 randconfig-r2305-20261124    gcc-16.2.0 sparse
i386                 randconfig-r2306-20261124    clang-24   sparse
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261125    gcc-11.5.0
loongarch             randconfig-1001-20261125    gcc-11.5.0
loongarch             randconfig-2000-20261124    clang-18
loongarch             randconfig-2001-20261124    clang-18
loongarch             randconfig-2001-20261124    gcc-12.5.0
loongarch             randconfig-2200-20261124    gcc-16.2.0 smatch
loongarch            randconfig-r2100-20261124    gcc-12.5.0 cocci
loongarch            randconfig-r2100-20261124    gcc-9.5.0  cocci
loongarch            randconfig-r2304-20261124    gcc-14.4.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                  randconfig-2000-20261124    gcc-11.5.0
m68k                  randconfig-2000-20261124    gcc-12.5.0
m68k                  randconfig-2001-20261124    gcc-11.5.0
m68k                  randconfig-2001-20261124    gcc-14.4.0
m68k                  randconfig-2200-20261124    gcc-10.5.0 smatch
m68k                 randconfig-r2102-20261124    gcc-9.5.0  cocci
m68k                 randconfig-r2105-20261124    gcc-15.3.0 cocci
m68k                 randconfig-r2107-20261124    clang-20   cocci
m68k                 randconfig-r2306-20261124    gcc-15.3.0 sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261124    gcc-11.5.0
microblaze            randconfig-2000-20261124    gcc-8.5.0
microblaze            randconfig-2001-20261124    gcc-11.5.0
microblaze            randconfig-2001-20261124    gcc-15.3.0
microblaze            randconfig-2200-20261124    gcc-8.5.0  smatch
microblaze           randconfig-r2107-20261124    gcc-11.5.0 cocci
microblaze           randconfig-r2108-20261124    gcc-15.3.0 cocci
microblaze           randconfig-r2301-20261124    gcc-14.4.0 sparse
microblaze           randconfig-r2302-20261124    gcc-16.2.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath79_defconfig    clang-17
mips                      decstation_defconfig    clang-17
mips                  decstation_r4k_defconfig    clang-17
mips                            gcw0_defconfig    clang-24
mips                       pic32mzda_defconfig    clang-24
mips                  randconfig-2000-20261124    clang-20
mips                  randconfig-2000-20261124    gcc-16.2.0
mips                  randconfig-2001-20261124    clang-20
mips                  randconfig-2001-20261124    gcc-16.2.0
mips                  randconfig-2002-20261124    clang-24
mips                  randconfig-2002-20261124    gcc-16.2.0
mips                  randconfig-2200-20261124    clang-20   smatch
mips                 randconfig-r2100-20261124    gcc-16.2.0 cocci
mips                 randconfig-r2107-20261124    clang-24   cocci
mips                 randconfig-r2110-20261124    gcc-14     cocci
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261125    gcc-11.5.0
nios2                 randconfig-1001-20261125    gcc-11.5.0
nios2                 randconfig-2000-20261124    clang-18
nios2                 randconfig-2000-20261124    gcc-11.5.0
nios2                 randconfig-2001-20261124    clang-18
nios2                 randconfig-2001-20261124    gcc-11.5.0
nios2                 randconfig-2200-20261124    gcc-11.5.0 smatch
nios2                randconfig-r2100-20261124    clang-22   cocci
nios2                randconfig-r2104-20261124    gcc-9.5.0  cocci
nios2                randconfig-r2108-20261124    clang-20   cocci
nios2                randconfig-r2111-20261124    gcc-14     cocci
nios2                randconfig-r2304-20261124    clang-22   sparse
nios2                randconfig-r2305-20261124    clang-22   sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261124    gcc-16.2.0
openrisc              randconfig-2001-20261124    gcc-11.5.0
openrisc              randconfig-2001-20261124    gcc-16.2.0
openrisc              randconfig-2002-20261124    gcc-16.2.0
openrisc              randconfig-2200-20261124    gcc-11.5.0 smatch
openrisc             randconfig-r2102-20261124    clang-22   cocci
openrisc             randconfig-r2106-20261124    gcc-15.3.0 cocci
openrisc             randconfig-r2111-20261124    gcc-11.5.0 cocci
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261125    clang-24
parisc                randconfig-1001-20261125    clang-24
parisc                randconfig-2000-20261124    clang-18
parisc                randconfig-2000-20261124    gcc-8.5.0
parisc                randconfig-2001-20261124    clang-18
parisc                randconfig-2001-20261124    gcc-8.5.0
parisc                randconfig-2200-20261124    gcc-9.5.0  smatch
parisc               randconfig-r2104-20261124    gcc-12.5.0 cocci
parisc               randconfig-r2311-20261124    clang-24   sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                      asp8347_defconfig    clang-24
powerpc               randconfig-1000-20261125    clang-24
powerpc               randconfig-1001-20261125    clang-24
powerpc               randconfig-2000-20261124    clang-17
powerpc               randconfig-2000-20261124    clang-24
powerpc               randconfig-2001-20261124    clang-24
powerpc               randconfig-2001-20261124    gcc-10.5.0
powerpc               randconfig-2002-20261124    clang-24
powerpc               randconfig-2200-20261124    clang-21   smatch
powerpc              randconfig-r2102-20261124    clang-22   cocci
powerpc              randconfig-r2102-20261124    gcc-16.2.0 cocci
powerpc              randconfig-r2104-20261124    gcc-16.2.0 cocci
powerpc              randconfig-r2106-20261124    clang-20   cocci
powerpc              randconfig-r2106-20261124    clang-24   cocci
powerpc              randconfig-r2301-20261124    clang-18   sparse
powerpc              randconfig-r2302-20261124    clang-22   sparse
powerpc64             randconfig-1000-20261125    clang-24
powerpc64             randconfig-1001-20261125    clang-24
powerpc64             randconfig-2000-20261124    clang-24
powerpc64             randconfig-2001-20261124    clang-22
powerpc64             randconfig-2001-20261124    clang-24
powerpc64             randconfig-2002-20261124    clang-24
powerpc64             randconfig-2200-20261124    gcc-12.5.0 smatch
powerpc64            randconfig-r2101-20261124    clang-22   cocci
powerpc64            randconfig-r2105-20261124    clang-22   cocci
powerpc64            randconfig-r2105-20261124    gcc-16.2.0 cocci
powerpc64            randconfig-r2110-20261124    clang-24   cocci
powerpc64            randconfig-r2300-20261124    gcc-8.5.0  sparse
powerpc64            randconfig-r2310-20261124    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261125    gcc-8.5.0
riscv                 randconfig-1001-20261125    gcc-8.5.0
riscv                 randconfig-2000-20261124    gcc-16.2.0
riscv                 randconfig-2001-20261124    clang-24
riscv                 randconfig-2001-20261124    gcc-16.2.0
riscv                 randconfig-2002-20261124    clang-24
riscv                 randconfig-2002-20261124    gcc-16.2.0
riscv                 randconfig-2003-20261124    gcc-16.2.0
riscv                 randconfig-2003-20261124    gcc-8.5.0
riscv                 randconfig-2004-20261124    gcc-16.2.0
riscv                 randconfig-2005-20261124    clang-18
riscv                 randconfig-2005-20261124    gcc-16.2.0
riscv                 randconfig-2200-20261124    gcc-14.4.0 smatch
riscv                randconfig-r2102-20261124    gcc-16.2.0 cocci
riscv                randconfig-r2103-20261124    clang-24   cocci
riscv                randconfig-r2107-20261124    clang-24   cocci
riscv                randconfig-r2110-20261124    gcc-11.5.0 cocci
riscv                randconfig-r2111-20261124    clang-20   cocci
riscv                randconfig-r2305-20261124    clang-18   sparse
riscv                randconfig-r2305-20261124    gcc-16.2.0 sparse
riscv                randconfig-r2306-20261124    clang-24   sparse
riscv                randconfig-r2308-20261124    clang-24   sparse
riscv                randconfig-r2310-20261124    gcc-11.5.0 sparse
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261125    gcc-8.5.0
s390                  randconfig-1001-20261125    gcc-8.5.0
s390                  randconfig-2000-20261124    clang-19
s390                  randconfig-2000-20261124    clang-24
s390                  randconfig-2001-20261124    clang-24
s390                  randconfig-2001-20261124    gcc-14.4.0
s390                  randconfig-2002-20261124    clang-24
s390                  randconfig-2003-20261124    clang-24
s390                  randconfig-2004-20261124    clang-24
s390                  randconfig-2005-20261124    clang-24
s390                  randconfig-2200-20261124    clang-24   smatch
s390                 randconfig-r2106-20261124    gcc-14     cocci
s390                 randconfig-r2110-20261124    clang-20   cocci
s390                 randconfig-r2303-20261124    clang-18   sparse
s390                 randconfig-r2303-20261124    gcc-16.2.0 sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                              espt_defconfig    clang-24
sh                    randconfig-1000-20261125    gcc-8.5.0
sh                    randconfig-1001-20261125    gcc-8.5.0
sh                    randconfig-2000-20261124    gcc-11.5.0
sh                    randconfig-2000-20261124    gcc-9.5.0
sh                    randconfig-2001-20261124    gcc-11.5.0
sh                    randconfig-2002-20261124    gcc-11.5.0
sh                    randconfig-2002-20261124    gcc-16.2.0
sh                    randconfig-2003-20261124    gcc-11.5.0
sh                    randconfig-2004-20261124    gcc-11.5.0
sh                    randconfig-2004-20261124    gcc-16.2.0
sh                    randconfig-2005-20261124    gcc-11.5.0
sh                    randconfig-2200-20261124    gcc-16.2.0 smatch
sh                   randconfig-r2103-20261124    clang-22   cocci
sh                   randconfig-r2106-20261124    gcc-11.5.0 cocci
sh                   randconfig-r2107-20261124    gcc-15.3.0 cocci
sh                   randconfig-r2109-20261124    gcc-11.5.0 cocci
sh                   randconfig-r2110-20261124    gcc-14.4.0 cocci
sh                   randconfig-r2302-20261124    gcc-15.3.0 sparse
sh                   randconfig-r2307-20261124    clang-24   sparse
sh                            se7343_defconfig    gcc-16.2.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-2000-20261124    gcc-16.2.0
sparc                 randconfig-2000-20261124    gcc-8.5.0
sparc                 randconfig-2001-20261124    gcc-15.3.0
sparc                 randconfig-2001-20261124    gcc-8.5.0
sparc                 randconfig-2200-20261124    gcc-11.5.0 smatch
sparc                randconfig-r2104-20261124    gcc-16.2.0 cocci
sparc                randconfig-r2108-20261124    clang-24   cocci
sparc                randconfig-r2304-20261124    gcc-8.5.0  sparse
sparc                randconfig-r2309-20261124    clang-24   sparse
sparc                randconfig-r2310-20261124    clang-24   sparse
sparc64                           alldefconfig    clang-24
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-2000-20261124    clang-24
sparc64               randconfig-2000-20261124    gcc-8.5.0
sparc64               randconfig-2001-20261124    gcc-8.5.0
sparc64               randconfig-2200-20261124    clang-24   smatch
sparc64              randconfig-r2105-20261124    gcc-9.5.0  cocci
sparc64              randconfig-r2106-20261124    clang-20   cocci
sparc64              randconfig-r2108-20261124    gcc-14     cocci
sparc64              randconfig-r2109-20261124    clang-20   cocci
sparc64              randconfig-r2109-20261124    gcc-15.3.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-2000-20261124    gcc-14
um                    randconfig-2000-20261124    gcc-8.5.0
um                    randconfig-2001-20261124    gcc-14
um                    randconfig-2001-20261124    gcc-8.5.0
um                    randconfig-2200-20261124    gcc-14     smatch
um                   randconfig-r2100-20261124    clang-22   cocci
um                   randconfig-r2101-20261124    gcc-9.5.0  cocci
um                   randconfig-r2102-20261124    clang-24   cocci
um                   randconfig-r2103-20261124    gcc-16.2.0 cocci
um                   randconfig-r2301-20261124    gcc-16.2.0 sparse
um                   randconfig-r2304-20261124    clang-18   sparse
um                   randconfig-r2308-20261124    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261125    clang-22
x86_64      buildonly-randconfig-1001-20261125    clang-22
x86_64      buildonly-randconfig-1002-20261125    clang-22
x86_64      buildonly-randconfig-1003-20261125    clang-22
x86_64      buildonly-randconfig-1004-20261125    clang-22
x86_64      buildonly-randconfig-1005-20261125    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261125    clang-22
x86_64                randconfig-1001-20261125    clang-22
x86_64                randconfig-1002-20261125    clang-22
x86_64                randconfig-1003-20261125    clang-22
x86_64                randconfig-1004-20261125    clang-22
x86_64                randconfig-1005-20261125    clang-22
x86_64                randconfig-2000-20261124    clang-22
x86_64                randconfig-2000-20261124    gcc-14
x86_64                randconfig-2001-20261124    clang-22
x86_64                randconfig-2001-20261124    gcc-14
x86_64                randconfig-2002-20261124    gcc-14
x86_64                randconfig-2003-20261124    clang-22
x86_64                randconfig-2003-20261124    gcc-14
x86_64                randconfig-2004-20261124    gcc-14
x86_64                randconfig-2005-20261124    gcc-14
x86_64                randconfig-2100-20261124    gcc-14     cocci
x86_64                randconfig-2101-20261124    gcc-14     cocci
x86_64                randconfig-2102-20261124    gcc-14     cocci
x86_64                randconfig-2103-20261124    gcc-14     cocci
x86_64                randconfig-2104-20261124    clang-22   cocci
x86_64                randconfig-2104-20261124    gcc-14     cocci
x86_64                randconfig-2105-20261124    gcc-14     cocci
x86_64                randconfig-2200-20261124    gcc-14     smatch
x86_64                randconfig-2300-20261124    gcc-14     sparse
x86_64                randconfig-2301-20261124    gcc-14     sparse
x86_64                randconfig-2302-20261124    gcc-14     sparse
x86_64               randconfig-r2110-20261124    gcc-15.3.0 cocci
x86_64               randconfig-r2301-20261124    clang-22   sparse
x86_64               randconfig-r2309-20261124    gcc-14     sparse
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
xtensa                   audio_kc705_defconfig    clang-17
xtensa                           iss_defconfig    gcc-16.2.0
xtensa                randconfig-2000-20261124    gcc-11.5.0
xtensa                randconfig-2000-20261124    gcc-16.2.0
xtensa                randconfig-2001-20261124    gcc-13.5.0
xtensa                randconfig-2001-20261124    gcc-16.2.0
xtensa                randconfig-2200-20261124    gcc-9.5.0  smatch
xtensa               randconfig-r2100-20261124    gcc-16.2.0 cocci
xtensa               randconfig-r2101-20261124    gcc-16.2.0 cocci
xtensa               randconfig-r2108-20261124    gcc-11.5.0 cocci
xtensa               randconfig-r2111-20261124    clang-24   cocci
xtensa               randconfig-r2305-20261124    gcc-10.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
