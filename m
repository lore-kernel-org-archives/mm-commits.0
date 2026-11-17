Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931785;
	b=LhmFjX3iMNqTNacTZb5CFMIttV0LctIfoD5sR806FLgeueSJfKe1rkKnVD/++aAqe/TT
	 8pRKKjFg+8VdQnoafLK3jr9225eoBfu+8ARW4jmDxH5/8zIN1oRrO4D/kA2f9Fs0+qo7C
	 E5Mv/TRQY1zXnzn5T5KLWbTFTqixbmq4yqYPaCdBQTubgz6S0j5VevGcElgUxv5nqI6eA
	 rx5k3IOo+ouFaB/efFnKAXos1ddyaDuMR9UswNq/nAQCc05rgcPlpTwVM4Asq1ItEvJBS
	 xMmQPihoWKQJwf9snPyjfNhYkOVIRKVV5G4Fw9/ekZ4Ok/jeMzZ/LrJ0bsw49x4DZ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931785;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=UvScUGHsM15lCFKb8FKHXeRBorNMwqwMVFB7TYVWqMM=;
	b=Q1IzSK/u6tUYxQFONH8yR8jydulbIi4b+r43uibTSAMUsLaTh+0RUE+arcKKf+kfk9nO
	 GuAH2RC4TEkuivsW34jBvqiEKMcEXOQ8ozj9o3bwXmuLP4BMzpCp19aQKvlAYluXknkz1
	 xEWuOJK38lKg8a8NqgiY4dI/YSDTjBqCLpCpoKJkUEbm4o5b2IClMN5FNPPSlvFTJDQLg
	 ZY00Pywuc8W+rcWm4WJu1TwxBeseYKWo78Zjf9vsQdSGSFMX3kXuWuxNXFiTzNfiQRxR6
	 ICsTtHXwEJ1HYM6xh6orREUeJ/cXrWF0G1HZLypssf4f69xsbw5hIU16Dd7CBpUMUVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Yuy7TRI3;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599C6606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 16:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 599C6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Yuy7TRI3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794931785; x=1826467785;
  h=date:from:to:cc:subject:message-id;
  bh=vkshbKx18VBVh0xRXNCtSh4UARbaMCneq8MscDrz50w=;
  b=Yuy7TRI3vhqhm/09uAwHNtpszTRsyi1+jvcQo9nS1n2lz7K8Iqn4jXFx
   NwZ6SK7R7vbtl5QHYDuz1lz7q79NhuhwFbF7M/IfAu4SBwoQ739Wt/sX4
   1BdfDtVCH+vlvzTQ4hw9QwevX1sVTeDQkTB+8AwY7XkLnD0A8CyBoLvU+
   VcvOOHYRIuG87Bvk/XFwkeQoKX7vyOp6G7bK2ZUWPk8om9ntTvtKWuA/G
   WxjYfa3fYDblBNXcJOauvSIsfRZvmSGoShQRuj4T6LDPDdrYO3/w6T+mS
   fqBdEzf7sSSkjbXYgEVJjqqc5t9X/UOVY3YCLp2M546MN0JSuNnAZgz0C
   A==;
X-CSE-ConnectionGUID: HwCMxFPuQbKfqE5OIiyKoQ==
X-CSE-MsgGUID: kB/h4nwRQsK+EZ314iZC/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3699029"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3699029"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 08:09:44 -0800
X-CSE-ConnectionGUID: R48YbB6nSZujGKMjG4IOuw==
X-CSE-MsgGUID: v/9V68TUQ2SSifJ3U8nRlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="10183685"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 17 Nov 2026 08:09:43 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTLka-0000000039i-3G6D;
	Tue, 17 Nov 2026 16:09:40 +0000
Date: Tue, 17 Nov 2026 17:09:02 +0100
From: kernel test robot <lkp@intel.com>
To: Aveline Noir <jm5905938@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, SJ Park <sj@kernel.org>
Subject: [akpm-mm:mm-new 316/342] mm/damon/tests/paddr-kunit.h:37:9:
 sparse: sparse: cast truncates bits from constant value (ffffffff000 becomes
 fffff000)
Message-ID: <20261117170155.fEdeuuhm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   c37b2f8a996722ec8fbcfadb045f9f787df65510
commit: 7a983cc1b57309a875a9e07a934c9944bf3d088d [316/342] mm/damon/paddr: add KUnit tests for addr_unit conversion
config: i386-randconfig-2302-20261117 (https://download.01.org/0day-ci/archive/20261117/20261117170155.fEdeuuhm-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261117/20261117170155.fEdeuuhm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261117170155.fEdeuuhm-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/damon/paddr.c: note: in included file:
>> mm/damon/tests/paddr-kunit.h:37:9: sparse: sparse: cast truncates bits from constant value (ffffffff000 becomes fffff000)

vim +37 mm/damon/tests/paddr-kunit.h

    26	
    27	static void damon_test_pa_addr_over_4g(struct kunit *test)
    28	{
    29		unsigned long addr = 0xffffffffUL;
    30		unsigned long addr_unit = 0x1000;
    31		u64 pa = 0xffffffff000ULL;
    32	
    33		if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
    34			kunit_skip(test, "phys_addr_t is 32-bit");
    35	
    36		KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
  > 37		KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
    38	}
    39	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
