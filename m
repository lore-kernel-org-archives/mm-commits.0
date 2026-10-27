Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793119319;
	b=zaqucxBPJBeVyivWSG7qJ5zE6TO1ek6utNoTvWEJuEC7n61e5iNPW0EZmIpgPNqhiqb1
	 elQUJZvK9PFNeArKoIsLDaKTqia6RtH8EFj1cnD+Xr353ckP7hUlh/YTGQ1+zrb12c9Yc
	 +J+1zcorSFpw6R0usQ3FwuaWvXCnA7gKf/dLKbET2eJ3PKhom9Uw8hQBRgwkC0xUV4UGU
	 aIhUvN0ExPrzSzpdRtaBDWlLU+ZfCecbPN+eq8FmoSSxE2enX8RQykB1kp96q+47yDv65
	 kzzv1NCnLcHLPrHfwVUJYb4geZnZ70tf6GGCqorRVd1/7I0vGMPkTYTGbCuO6gFP5Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793119319;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=U2+NgVVulxRc8ahHRVCwgPRTd6JNZHZQ/ltArk8SrNU=;
	b=uL0tn9WpEXkiQkhBbTzF3qiiFQggDtKYn7QnA/pTzbNev0ySWMD+wdYYniMrPBBGoqFu
	 rwFSOireo98FLYf/OeneIM/iIt6EkZdXInM1aC8vIgjCXvS1B6Db0tfiRq6XpPmzuqMcF
	 UlMLZ15+A2HxVfocPIZvAMmw1f2qJQ3MpeGIYb7KHb7rnbdK5O19EA2ImRxq90awrIGx0
	 yyU/hitAgpiK+eqdgqqXH2dyqVv8sh/gS9jDozEQwPcxFIiRlwscWAUqcPwnyAsVTaEN+
	 SOIOu5MxWD60M4DCzjgCXQPx/iSBUtmwySwB5rR6BC6I5n+3zOuFgdNyuL4vulyYBBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EPl36iuO;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA6A606A31A
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 16:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DA6A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EPl36iuO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793119318; x=1824655318;
  h=date:from:to:cc:subject:message-id;
  bh=dFfn4QXTGS2lBVup7ty5eBIeHER8pfxxsVUC3O+sdRc=;
  b=EPl36iuOrHKRShUE/iVet0SVFCxCHXibq45jI/CySZWvpnOufDNvhHnv
   Up3/38y32y0ymcN0cC+Wkpe4ErOx/vdjpynOeDr6PD3MOMLZZFWVwVk6v
   n6AQuYgwGpsXA/maByc5pyGDNHrbD+075Yhdh32ynYffUwfncA97K1+rX
   2vRxYv9KwOVhyORn1beFqm5BYZjtsZYkINW4R8I3U72ZTkZFERXNtjbde
   VhO/0O8WuZ813l1QpruM/jD0actwonbrTiZSFXX9F29FBTcCsyDkbsi70
   L8OtYTH0T7gRXz0euUS0t1MYL8Ple7sSe3YtMGLvMsnhmq7zEjl97UR8y
   Q==;
X-CSE-ConnectionGUID: in3kel8yTpGm6IXATg3JMw==
X-CSE-MsgGUID: sVvVMi2zRo692nn0sn2tmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1839929"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1839929"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 09:41:57 -0700
X-CSE-ConnectionGUID: 2RfWKlaxRdy4e0fCjvk7pA==
X-CSE-MsgGUID: MnMWm26dTyK9r5CwQ84gHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="4931352"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 27 Oct 2026 09:41:56 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLkFF-00000000XVU-0Ft5;
	Tue, 27 Oct 2026 16:41:53 +0000
Date: Wed, 28 Oct 2026 00:41:16 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 7bf01f16a4d05028fbeff4d90bab40df25142a24
Message-ID: <202610280012.QUR2Xaq7-lkp@intel.com>
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
branch HEAD: 7bf01f16a4d05028fbeff4d90bab40df25142a24  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1139m

configs tested: 159
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261027    gcc-10.5.0
arc                   randconfig-1001-20261027    gcc-16.2.0
arm                                allnoconfig    clang-17
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261027    clang-24
arm                   randconfig-1001-20261027    gcc-10.5.0
arm                   randconfig-1002-20261027    gcc-8.5.0
arm                   randconfig-1003-20261027    gcc-10.5.0
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261027    gcc-13.5.0
arm64                 randconfig-1001-20261027    clang-17
arm64                 randconfig-1002-20261027    gcc-8.5.0
arm64                 randconfig-1003-20261027    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261027    gcc-16.2.0
csky                  randconfig-1001-20261027    gcc-16.2.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261027    clang-24
hexagon               randconfig-1001-20261027    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261027    gcc-14
i386        buildonly-randconfig-1001-20261027    gcc-14
i386        buildonly-randconfig-1002-20261027    clang-22
i386        buildonly-randconfig-1003-20261027    gcc-14
i386        buildonly-randconfig-1004-20261027    clang-22
i386        buildonly-randconfig-1005-20261027    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261027    gcc-12
i386                  randconfig-1001-20261027    clang-22
i386                  randconfig-1002-20261027    gcc-14
i386                  randconfig-1003-20261027    gcc-14
i386                  randconfig-1004-20261027    gcc-14
i386                  randconfig-1005-20261027    gcc-12
i386                  randconfig-1006-20261027    clang-22
i386                  randconfig-1007-20261027    gcc-14
i386                  randconfig-1008-20261027    gcc-14
i386                  randconfig-1009-20261027    gcc-14
i386                  randconfig-1010-20261027    clang-22
i386                  randconfig-1011-20261027    gcc-14
i386                  randconfig-1012-20261027    clang-22
i386                  randconfig-1013-20261027    clang-22
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261027    gcc-13.5.0
loongarch             randconfig-1001-20261027    gcc-15.3.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  decstation_r4k_defconfig    gcc-16.2.0
mips                        rbtx49xx_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261027    gcc-8.5.0
nios2                 randconfig-1001-20261027    gcc-8.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261027    gcc-12.5.0
parisc                randconfig-1001-20261027    gcc-10.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                      akebono_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                  mpc8313_rdb_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261027    gcc-15.3.0
powerpc               randconfig-1001-20261027    gcc-8.5.0
powerpc                      redwood_defconfig    clang-24
powerpc64             randconfig-1000-20261027    gcc-10.5.0
powerpc64             randconfig-1001-20261027    clang-22
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261027    gcc-15.3.0
riscv                 randconfig-1001-20261027    clang-20
s390                              alldefconfig    gcc-16.2.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261027    gcc-8.5.0
s390                  randconfig-1001-20261027    gcc-9.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                         apsh4ad0a_defconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261027    gcc-16.2.0
sh                    randconfig-1001-20261027    gcc-16.2.0
sh                           sdk7786_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261027    gcc-14.4.0
sparc                 randconfig-1001-20261027    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261027    clang-20
sparc64               randconfig-1001-20261027    clang-20
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261027    clang-24
um                    randconfig-1001-20261027    clang-20
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261027    clang-22
x86_64      buildonly-randconfig-1001-20261027    gcc-14
x86_64      buildonly-randconfig-1002-20261027    clang-22
x86_64      buildonly-randconfig-1003-20261027    gcc-12
x86_64      buildonly-randconfig-1004-20261027    gcc-14
x86_64      buildonly-randconfig-1005-20261027    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261027    gcc-14
x86_64                randconfig-1001-20261027    gcc-14
x86_64                randconfig-1002-20261027    gcc-14
x86_64                randconfig-1003-20261027    gcc-14
x86_64                randconfig-1004-20261027    clang-22
x86_64                randconfig-1005-20261027    clang-22
x86_64                randconfig-1006-20261027    gcc-14
x86_64                randconfig-1007-20261027    clang-22
x86_64                randconfig-1008-20261027    clang-22
x86_64                randconfig-1009-20261027    gcc-14
x86_64                randconfig-1010-20261027    clang-22
x86_64                randconfig-1011-20261027    gcc-14
x86_64                randconfig-1012-20261027    clang-22
x86_64                randconfig-1013-20261027    clang-22
x86_64                randconfig-1014-20261027    clang-22
x86_64                randconfig-1015-20261027    clang-22
x86_64                randconfig-1016-20261027    clang-22
x86_64                randconfig-1017-20261027    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261027    gcc-8.5.0
xtensa                randconfig-1001-20261027    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
