Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795731219;
	b=RixbLzBDSZT4mUDLNgeZdADA6zVY9fRf+kfkxOmH3sN+VNj+FNHzwkMlLnjLQzglwATX
	 HG6qV0abOTyw6Fd0g0QYM/LAmod03ngaZTz0tMLRfATXkzI5ye/rQK9ZD5F66ObxvqSFs
	 9piT9aF6E79L+3NbH4/7rxqUvzXConNFMZgr7wGz1drpuh3xXcgEq6Om0uHawGCBByem/
	 OK7iu0Ih8MVLHP96pjItP2opQeMwStyeprMSDu/OtJu46Ipq8cLk63NYvBnk8RjL/AGgv
	 HyNOVIJhKahdDQjGiskZ5YdCRSRDCJyUTAmczK0O3uJKqGMidrieI3zioBbDILrB6BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795731219;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=YoJXnMTUFSyDOcNqnOU29iLtNayehLzVCQI83ZKpgd8=;
	b=ugs43s4HxZyAUJxnlhVZRtAPOsRbv7FuwvvJAN2US+PThRQJCXr1PYnstyKbRsZGxpGt
	 pBp0/MCzJcO9+hwS3GwwFeN7WK+txpco6xxfOpbD9RrZuh623dCt5XRpJqoJNWbkIxFQ1
	 uFA5wUoHpk/wanct90UrEWt9tatdWwU7Y+IE8umd8iPgpiR97EiWywFVR59lZQ5J8n2Po
	 PZU6SuSmQtosE6xccA4qfkKOxacl6IC94TvYx/Db7q/UO+Pt9JHn1e9Sy8kVdX3CZwWFm
	 UTLQJA9gX10kayGs7+/WQALtOgOF9KgBfJJwdWnKlKRmN6jvHX8mzUDAdlcrsVvEkZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AhbHg5yD;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1E5606A31C
	for <mm-commits@vger.kernel.org>; Thu, 26 Nov 2026 22:13:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A1E5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AhbHg5yD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795731219; x=1827267219;
  h=date:from:to:cc:subject:message-id;
  bh=BJKauYG3n2EPwWXrOokhSSAOP3Y4jaiaY9L3bTO/25M=;
  b=AhbHg5yDZECYGhf8TZvv51OhWEaAlz27tyzg3dCzGuetrCqmzcS4khFu
   926OxEvKa6v1WhH5uPsCZOwyIbvl9jQuYgVjyCY7HUGjgtvmmVVmOonFJ
   bhmUq8PT0N/ZYtoiu+so2uCqDuN/3d1wyjVkYZ0FPNTDDV+K8qGq1SJet
   rnnlo7xe9eQ/I1dCHcg+PE/mktQagfAx5b0gTdREfNYVUTn+Zcw2zjXHV
   U0H1/tYtCrUcou/+Cibbd+shJoZkC4yhwHTmk3oLIgg3pWYFC37MkjBbd
   BqVAedS15QrXBbsjHQ/0w/CfjrzKpFQLA1GgeAgs04UfVZVAZb08vfsjP
   A==;
X-CSE-ConnectionGUID: isqiDaljQGOrNsiXTVbUPA==
X-CSE-MsgGUID: bvapUJGVScKsGs9pQRyKJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="4552107"
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="4552107"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 14:13:38 -0800
X-CSE-ConnectionGUID: 7SuZNcspSUWAfEdjrT8HWg==
X-CSE-MsgGUID: cWuQ7auOT1ywjKQgIKoGyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="12287348"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 26 Nov 2026 14:13:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWhig-00000001UyE-20oQ;
	Thu, 26 Nov 2026 22:13:34 +0000
Date: Fri, 27 Nov 2026 06:12:55 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 3d27e49eb905a5119e78fbe3d3890f376d15c728
Message-ID: <20261127061255.sXY6esvU-lkp@intel.com>
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
branch HEAD: 3d27e49eb905a5119e78fbe3d3890f376d15c728  tools/mm: page-types: flush pending idle bitmap bits after walking

elapsed time: 1355m

configs tested: 358
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                     allnoconfig    gcc-16.2.0
alpha                    allyesconfig    gcc-16.2.0
alpha                       defconfig    gcc-16.2.0
alpha        randconfig-2000-20261126    gcc-13.5.0
alpha        randconfig-2000-20261126    gcc-15.3.0
alpha        randconfig-2001-20261126    gcc-13.5.0
alpha        randconfig-2200-20261126    gcc-9.5.0  smatch
alpha       randconfig-r2100-20261126    gcc-10.5.0 cocci
alpha       randconfig-r2306-20261126    gcc-13.5.0 sparse
alpha       randconfig-r2310-20261126    gcc-10.5.0 sparse
arc                      allmodconfig    gcc-16.2.0
arc                       allnoconfig    gcc-16.2.0
arc                      allyesconfig    gcc-16.2.0
arc                         defconfig    gcc-16.2.0
arc          randconfig-2000-20261126    gcc-11.5.0
arc          randconfig-2000-20261126    gcc-9.5.0
arc          randconfig-2001-20261126    gcc-8.5.0
arc          randconfig-2001-20261126    gcc-9.5.0
arc          randconfig-2002-20261126    gcc-8.5.0
arc          randconfig-2002-20261126    gcc-9.5.0
arc          randconfig-2003-20261126    gcc-9.5.0
arc          randconfig-2004-20261126    gcc-15.3.0
arc          randconfig-2004-20261126    gcc-9.5.0
arc          randconfig-2005-20261126    gcc-9.5.0
arc          randconfig-2200-20261126    gcc-8.5.0  smatch
arc         randconfig-r2107-20261126    gcc-14.4.0 cocci
arc         randconfig-r2306-20261126    clang-18   sparse
arm                       allnoconfig    clang-17
arm                       allnoconfig    gcc-16.2.0
arm                      allyesconfig    gcc-16.2.0
arm                         defconfig    gcc-16.2.0
arm                  ep93xx_defconfig    clang-24
arm                  gemini_defconfig    clang-24
arm                  ixp4xx_defconfig    gcc-16.2.0
arm          randconfig-2000-20261126    gcc-11.5.0
arm          randconfig-2000-20261126    gcc-8.5.0
arm          randconfig-2001-20261126    gcc-11.5.0
arm          randconfig-2002-20261126    gcc-11.5.0
arm          randconfig-2002-20261126    gcc-13.5.0
arm          randconfig-2200-20261126    gcc-8.5.0  smatch
arm         randconfig-r2304-20261126    clang-22   sparse
arm64                    allmodconfig    clang-24
arm64                     allnoconfig    gcc-16.2.0
arm64                       defconfig    gcc-16.2.0
arm64        randconfig-1000-20261126    gcc-8.5.0
arm64        randconfig-1001-20261126    gcc-8.5.0
arm64        randconfig-1002-20261126    gcc-8.5.0
arm64        randconfig-1003-20261126    gcc-8.5.0
arm64        randconfig-2000-20261126    clang-24
arm64        randconfig-2000-20261126    gcc-11.5.0
arm64        randconfig-2001-20261126    clang-20
arm64        randconfig-2001-20261126    gcc-11.5.0
arm64        randconfig-2002-20261126    clang-24
arm64        randconfig-2002-20261126    gcc-11.5.0
arm64        randconfig-2200-20261126    clang-24   smatch
arm64       randconfig-r2301-20261126    clang-22   sparse
arm64       randconfig-r2302-20261126    clang-22   sparse
csky                     allmodconfig    gcc-16.2.0
csky                      allnoconfig    gcc-16.2.0
csky                        defconfig    gcc-16.2.0
csky         randconfig-1000-20261126    gcc-8.5.0
csky         randconfig-1001-20261126    gcc-8.5.0
csky         randconfig-2000-20261126    gcc-13.5.0
csky         randconfig-2000-20261126    gcc-16.2.0
csky         randconfig-2001-20261126    gcc-13.5.0
csky         randconfig-2200-20261126    gcc-13.5.0 smatch
csky        randconfig-r2104-20261126    gcc-14.4.0 cocci
csky        randconfig-r2300-20261126    gcc-12.5.0 sparse
hexagon                  allmodconfig    clang-24
hexagon                  allmodconfig    gcc-16.2.0
hexagon                   allnoconfig    clang-24
hexagon                   allnoconfig    gcc-16.2.0
hexagon                     defconfig    gcc-16.2.0
hexagon      randconfig-2000-20261126    clang-24
hexagon      randconfig-2000-20261126    gcc-13.5.0
hexagon      randconfig-2001-20261126    clang-17
hexagon      randconfig-2001-20261126    gcc-13.5.0
hexagon      randconfig-2200-20261126    clang-17   smatch
hexagon     randconfig-r2103-20261126    gcc-10.5.0 cocci
hexagon     randconfig-r2307-20261126    clang-18   sparse
hexagon     randconfig-r2309-20261126    clang-18   sparse
hexagon     randconfig-r2310-20261126    clang-24   sparse
i386                     allmodconfig    gcc-14
i386                      allnoconfig    gcc-14
i386                      allnoconfig    gcc-16.2.0
i386                        defconfig    gcc-16.2.0
i386         randconfig-1000-20261126    clang-22
i386         randconfig-1001-20261126    clang-22
i386         randconfig-1002-20261126    clang-22
i386         randconfig-1003-20261126    clang-22
i386         randconfig-1004-20261126    clang-22
i386         randconfig-1005-20261126    clang-22
i386         randconfig-1006-20261126    clang-22
i386         randconfig-2000-20261126    clang-22
i386         randconfig-2001-20261126    clang-22
i386         randconfig-2002-20261126    clang-22
i386         randconfig-2003-20261126    clang-22
i386         randconfig-2003-20261126    gcc-14
i386         randconfig-2004-20261126    clang-22
i386         randconfig-2005-20261126    clang-22
i386         randconfig-2100-20261126    clang-22   cocci
i386         randconfig-2101-20261126    clang-22   cocci
i386         randconfig-2102-20261126    clang-22   cocci
i386         randconfig-2102-20261126    gcc-14     cocci
i386         randconfig-2103-20261126    clang-22   cocci
i386         randconfig-2103-20261126    gcc-12     cocci
i386         randconfig-2104-20261126    clang-22   cocci
i386         randconfig-2105-20261126    clang-22   cocci
i386         randconfig-2105-20261126    gcc-14     cocci
i386         randconfig-2200-20261126    gcc-14     smatch
i386         randconfig-2300-20261126    gcc-14     sparse
i386         randconfig-2301-20261126    clang-22   sparse
i386         randconfig-2301-20261126    gcc-14     sparse
i386         randconfig-2302-20261126    gcc-14     sparse
i386        randconfig-r2109-20261126    clang-22   cocci
loongarch                allmodconfig    clang-19
loongarch                 allnoconfig    clang-20
loongarch                 allnoconfig    gcc-16.2.0
loongarch                   defconfig    clang-24
loongarch    randconfig-2000-20261126    gcc-12.5.0
loongarch    randconfig-2001-20261126    clang-18
loongarch    randconfig-2001-20261126    gcc-12.5.0
loongarch    randconfig-2200-20261126    gcc-14.4.0 smatch
loongarch   randconfig-r2300-20261126    clang-22   sparse
loongarch   randconfig-r2307-20261126    gcc-10.5.0 sparse
m68k                     allmodconfig    gcc-16.2.0
m68k                      allnoconfig    gcc-16.2.0
m68k                     allyesconfig    gcc-16.2.0
m68k                        defconfig    clang-24
m68k         randconfig-2000-20261126    gcc-13.5.0
m68k         randconfig-2000-20261126    gcc-8.5.0
m68k         randconfig-2001-20261126    gcc-13.5.0
m68k         randconfig-2001-20261126    gcc-8.5.0
m68k        randconfig-r2104-20261126    gcc-10.5.0 cocci
m68k        randconfig-r2308-20261126    gcc-9.5.0  sparse
microblaze                allnoconfig    gcc-16.2.0
microblaze               allyesconfig    gcc-16.2.0
microblaze                  defconfig    clang-24
microblaze   randconfig-2000-20261126    gcc-13.5.0
microblaze   randconfig-2000-20261126    gcc-15.3.0
microblaze   randconfig-2001-20261126    gcc-13.5.0
microblaze   randconfig-2001-20261126    gcc-8.5.0
microblaze   randconfig-2200-20261126    gcc-9.5.0  smatch
mips                     allmodconfig    gcc-16.2.0
mips                      allnoconfig    gcc-16.2.0
mips                     allyesconfig    gcc-16.2.0
mips         randconfig-2000-20261126    gcc-16.2.0
mips         randconfig-2000-20261126    gcc-8.5.0
mips         randconfig-2001-20261126    gcc-15.3.0
mips         randconfig-2001-20261126    gcc-16.2.0
mips         randconfig-2002-20261126    gcc-16.2.0
mips         randconfig-2002-20261126    gcc-9.5.0
mips        randconfig-r2303-20261126    clang-20   sparse
mips        randconfig-r2311-20261126    clang-24   sparse
nios2                    allmodconfig    gcc-11.5.0
nios2                     allnoconfig    clang-24
nios2                     allnoconfig    gcc-11.5.0
nios2                       defconfig    clang-24
nios2        randconfig-2000-20261126    gcc-11.5.0
nios2        randconfig-2000-20261126    gcc-12.5.0
nios2        randconfig-2001-20261126    gcc-12.5.0
nios2        randconfig-2001-20261126    gcc-9.5.0
nios2        randconfig-2200-20261126    gcc-9.5.0  smatch
nios2       randconfig-r2109-20261126    gcc-11.5.0 cocci
nios2       randconfig-r2111-20261126    clang-22   cocci
nios2       randconfig-r2308-20261126    gcc-10.5.0 sparse
openrisc                 allmodconfig    gcc-16.2.0
openrisc                  allnoconfig    clang-24
openrisc                  allnoconfig    gcc-16.2.0
openrisc                    defconfig    gcc-16.2.0
openrisc     randconfig-2000-20261126    gcc-16.2.0
openrisc     randconfig-2001-20261126    gcc-13.5.0
openrisc     randconfig-2001-20261126    gcc-16.2.0
openrisc     randconfig-2002-20261126    gcc-16.2.0
openrisc     randconfig-2200-20261126    gcc-9.5.0  smatch
openrisc    randconfig-r2102-20261126    gcc-12.5.0 cocci
openrisc    randconfig-r2105-20261126    gcc-10.5.0 cocci
openrisc    randconfig-r2306-20261126    gcc-10.5.0 sparse
openrisc    randconfig-r2309-20261126    gcc-12.5.0 sparse
openrisc    randconfig-r2311-20261126    gcc-10.5.0 sparse
parisc                   allmodconfig    gcc-16.2.0
parisc                    allnoconfig    clang-24
parisc                    allnoconfig    gcc-16.2.0
parisc                   allyesconfig    clang-17
parisc                   allyesconfig    gcc-16.2.0
parisc                      defconfig    gcc-16.2.0
parisc       randconfig-1000-20261126    gcc-13.5.0
parisc       randconfig-1001-20261126    gcc-13.5.0
parisc       randconfig-2000-20261126    gcc-12.5.0
parisc       randconfig-2000-20261126    gcc-8.5.0
parisc       randconfig-2001-20261126    gcc-12.5.0
parisc       randconfig-2001-20261126    gcc-8.5.0
parisc       randconfig-2200-20261126    gcc-15.3.0 smatch
parisc64                    defconfig    clang-24
powerpc             akebono_defconfig    clang-24
powerpc                  allmodconfig    gcc-16.2.0
powerpc                   allnoconfig    clang-24
powerpc                   allnoconfig    gcc-16.2.0
powerpc            ge_imp3a_defconfig    gcc-16.2.0
powerpc          mpc885_ads_defconfig    clang-24
powerpc      randconfig-1000-20261126    gcc-13.5.0
powerpc      randconfig-1001-20261126    gcc-13.5.0
powerpc      randconfig-2000-20261126    clang-24
powerpc      randconfig-2001-20261126    clang-24
powerpc      randconfig-2002-20261126    clang-24
powerpc      randconfig-2200-20261126    clang-24   smatch
powerpc     randconfig-r2303-20261126    clang-22   sparse
powerpc     randconfig-r2305-20261126    clang-22   sparse
powerpc64    randconfig-1000-20261126    gcc-13.5.0
powerpc64    randconfig-1001-20261126    gcc-13.5.0
powerpc64    randconfig-2000-20261126    clang-24
powerpc64    randconfig-2001-20261126    clang-24
powerpc64    randconfig-2002-20261126    clang-24
powerpc64    randconfig-2200-20261126    clang-24   smatch
powerpc64   randconfig-r2105-20261126    gcc-16.2.0 cocci
powerpc64   randconfig-r2106-20261126    clang-24   cocci
powerpc64   randconfig-r2308-20261126    clang-18   sparse
powerpc64   randconfig-r2311-20261126    clang-18   sparse
riscv                    allmodconfig    clang-24
riscv                     allnoconfig    clang-24
riscv                     allnoconfig    gcc-16.2.0
riscv                    allyesconfig    clang-24
riscv                       defconfig    gcc-16.2.0
riscv        randconfig-2000-20261126    gcc-10.5.0
riscv        randconfig-2001-20261126    clang-24
riscv        randconfig-2001-20261126    gcc-10.5.0
riscv        randconfig-2002-20261126    clang-20
riscv        randconfig-2002-20261126    gcc-10.5.0
riscv        randconfig-2003-20261126    gcc-10.5.0
riscv        randconfig-2003-20261126    gcc-16.2.0
riscv        randconfig-2004-20261126    gcc-10.5.0
riscv        randconfig-2005-20261126    clang-24
riscv        randconfig-2005-20261126    gcc-10.5.0
riscv        randconfig-2200-20261126    gcc-8.5.0  smatch
riscv       randconfig-r2102-20261126    gcc-10.5.0 cocci
riscv       randconfig-r2107-20261126    clang-22   cocci
s390                     allmodconfig    clang-17
s390                     allmodconfig    clang-24
s390                      allnoconfig    clang-24
s390                     allyesconfig    gcc-16.2.0
s390                        defconfig    gcc-16.2.0
s390         randconfig-2000-20261126    clang-18
s390         randconfig-2000-20261126    clang-24
s390         randconfig-2001-20261126    clang-24
s390         randconfig-2001-20261126    gcc-8.5.0
s390         randconfig-2002-20261126    clang-24
s390         randconfig-2003-20261126    clang-18
s390         randconfig-2003-20261126    clang-24
s390         randconfig-2004-20261126    clang-24
s390         randconfig-2004-20261126    gcc-10.5.0
s390         randconfig-2005-20261126    clang-21
s390         randconfig-2005-20261126    clang-24
s390         randconfig-2200-20261126    gcc-16.2.0 smatch
s390        randconfig-r2100-20261126    gcc-8.5.0  cocci
s390        randconfig-r2101-20261126    clang-24   cocci
sh                       allmodconfig    gcc-16.2.0
sh                        allnoconfig    clang-24
sh                        allnoconfig    gcc-16.2.0
sh                       allyesconfig    clang-17
sh                       allyesconfig    gcc-16.2.0
sh                          defconfig    gcc-14
sh           randconfig-2000-20261126    gcc-16.2.0
sh           randconfig-2000-20261126    gcc-9.5.0
sh           randconfig-2001-20261126    gcc-13.5.0
sh           randconfig-2001-20261126    gcc-9.5.0
sh           randconfig-2002-20261126    gcc-11.5.0
sh           randconfig-2002-20261126    gcc-9.5.0
sh           randconfig-2003-20261126    gcc-9.5.0
sh           randconfig-2004-20261126    gcc-16.2.0
sh           randconfig-2004-20261126    gcc-9.5.0
sh           randconfig-2005-20261126    gcc-16.2.0
sh           randconfig-2005-20261126    gcc-9.5.0
sh           randconfig-2200-20261126    gcc-16.2.0 smatch
sh          randconfig-r2103-20261126    gcc-16.2.0 cocci
sh          randconfig-r2304-20261126    gcc-9.5.0  sparse
sh              rts7751r2d1_defconfig    gcc-16.2.0
sh                   se7721_defconfig    gcc-16.2.0
sparc                     allnoconfig    clang-24
sparc                     allnoconfig    gcc-16.2.0
sparc                       defconfig    gcc-16.2.0
sparc        randconfig-2000-20261126    gcc-8.5.0
sparc        randconfig-2001-20261126    gcc-13.5.0
sparc        randconfig-2001-20261126    gcc-8.5.0
sparc        randconfig-2200-20261126    gcc-13.5.0 smatch
sparc       randconfig-r2101-20261126    gcc-10.5.0 cocci
sparc       randconfig-r2110-20261126    clang-22   cocci
sparc       randconfig-r2110-20261126    gcc-16.2.0 cocci
sparc       randconfig-r2307-20261126    clang-18   sparse
sparc64                  allmodconfig    clang-20
sparc64                     defconfig    gcc-14
sparc64      randconfig-2000-20261126    clang-24
sparc64      randconfig-2000-20261126    gcc-8.5.0
sparc64      randconfig-2001-20261126    gcc-8.5.0
sparc64      randconfig-2200-20261126    gcc-12.5.0 smatch
sparc64     randconfig-r2302-20261126    clang-20   sparse
sparc64     randconfig-r2310-20261126    clang-18   sparse
um                       allmodconfig    clang-17
um                        allnoconfig    clang-17
um                        allnoconfig    clang-24
um                       allyesconfig    gcc-14
um                       allyesconfig    gcc-16.2.0
um                          defconfig    gcc-14
um                     i386_defconfig    gcc-14
um           randconfig-2000-20261126    clang-17
um           randconfig-2000-20261126    gcc-8.5.0
um           randconfig-2001-20261126    clang-17
um           randconfig-2001-20261126    gcc-8.5.0
um           randconfig-2200-20261126    gcc-12     smatch
um          randconfig-r2108-20261126    clang-24   cocci
um          randconfig-r2305-20261126    clang-24   sparse
um                   x86_64_defconfig    gcc-14
x86_64                    allnoconfig    clang-22
x86_64                    allnoconfig    clang-24
x86_64                      defconfig    gcc-14
x86_64                          kexec    clang-22
x86_64       randconfig-2000-20261126    clang-22
x86_64       randconfig-2001-20261126    clang-22
x86_64       randconfig-2001-20261126    gcc-14
x86_64       randconfig-2002-20261126    clang-22
x86_64       randconfig-2003-20261126    clang-22
x86_64       randconfig-2004-20261126    clang-22
x86_64       randconfig-2005-20261126    clang-22
x86_64       randconfig-2100-20261126    clang-22   cocci
x86_64       randconfig-2100-20261126    gcc-14     cocci
x86_64       randconfig-2101-20261126    clang-22   cocci
x86_64       randconfig-2101-20261126    gcc-14     cocci
x86_64       randconfig-2102-20261126    gcc-14     cocci
x86_64       randconfig-2103-20261126    clang-22   cocci
x86_64       randconfig-2103-20261126    gcc-14     cocci
x86_64       randconfig-2104-20261126    gcc-14     cocci
x86_64       randconfig-2105-20261126    gcc-14     cocci
x86_64       randconfig-2200-20261126    clang-22   smatch
x86_64       randconfig-2300-20261126    gcc-12     sparse
x86_64       randconfig-2300-20261126    gcc-14     sparse
x86_64       randconfig-2301-20261126    gcc-14     sparse
x86_64       randconfig-2302-20261126    gcc-14     sparse
x86_64      randconfig-r2106-20261126    clang-22   cocci
x86_64      randconfig-r2108-20261126    clang-22   cocci
x86_64      randconfig-r2111-20261126    gcc-14     cocci
x86_64                       rhel-9.4    clang-22
x86_64                   rhel-9.4-bpf    clang-22
x86_64                   rhel-9.4-bpf    gcc-14
x86_64                  rhel-9.4-func    clang-22
x86_64            rhel-9.4-kselftests    clang-22
x86_64                 rhel-9.4-kunit    clang-22
x86_64                 rhel-9.4-kunit    gcc-14
x86_64                   rhel-9.4-ltp    clang-22
x86_64                   rhel-9.4-ltp    gcc-14
x86_64                  rhel-9.4-rust    clang-22
x86_64                  rhel-9.4-rust    clang-22
xtensa                    allnoconfig    clang-24
xtensa                    allnoconfig    gcc-16.2.0
xtensa                   allyesconfig    gcc-16.2.0
xtensa       randconfig-2000-20261126    gcc-13.5.0
xtensa       randconfig-2001-20261126    gcc-13.5.0
xtensa       randconfig-2001-20261126    gcc-15.3.0
xtensa       randconfig-2200-20261126    gcc-11.5.0 smatch
xtensa      randconfig-r2309-20261126    gcc-10.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
