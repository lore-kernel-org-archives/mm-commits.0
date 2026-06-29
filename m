Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DD93FD941
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 11:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782732106; cv=none; b=oNv5x8uXPE4wLPvnLedctQwAjQo5/kxFwfdJFhbXp+zsXGqGIU9odf8XzwVajczUpmbr60tv7hInTx0B09zbpP4ntgn2/dRKk0Dxh8dwWTCc8KaFYL0YVVliqfppsLoDnMiXJgBogL8OovanbPCmWifnhpMtZZ5NO80sCmvoE9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782732106; c=relaxed/simple;
	bh=5LWEXxUWHTCSVKsPU06YRisBpoOzrLgoMx8poq2lJhs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=JcDwl8YhXvf+3QB6NNKEOP2uNKdvxu2XEsU8cm5kAy3ufpcrEx1ql4AhynuYIq3Z04qDFzjchhYGFYLxdL2qkaW0TwIiOwXSly7NS89qBMTxFfz7LuZRkHGEH7ARlDAiC10hDmwmrbimJvSCB12dWe5S3Saq0k6V7aL8yOwPOus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXzh9/9T; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXzh9/9T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782732105; x=1814268105;
  h=date:from:to:cc:subject:message-id;
  bh=5LWEXxUWHTCSVKsPU06YRisBpoOzrLgoMx8poq2lJhs=;
  b=HXzh9/9TSBT4UGCfM0c7T+sRFG9+Y4T8bKd63DwVBiXg4NyWRM35bYfT
   D6Mu+BJkiWUXwAqtoYn5WrI+WUmf6uPpgLsEKHo85H68sfe/EByZOOmRE
   wSXNEtgvaXe4ThyVgjTc3Zo/fXpoC+1SRGwZ++d2Au6zWTAzCqyuM3sjz
   3XaGmCDk7YUXl31LspNJB3NvxY7WVeNzJiMy7IG8Qy/v29zJt8MtDNRo1
   DQGRtNLPh87E+LrIuxSwJKGT/oP/u4HN5IdY1CZXvqnkwahitakV2xegG
   GWwbsgKWnQA8hvbw00k83aosRWr2P524Ss+GcshVNK9QAocWvrpvsP4XX
   g==;
X-CSE-ConnectionGUID: TPT7KD0yRtmcYqLFxm3lRg==
X-CSE-MsgGUID: 4X6pbONsR7u3TriFzhasMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11831"; a="87323613"
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="87323613"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 04:19:03 -0700
X-CSE-ConnectionGUID: oup/CHX1TU+U6w3blX9YZg==
X-CSE-MsgGUID: M6uJRUDKT0evHSKxIi8TIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="250865264"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 29 Jun 2026 04:19:01 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1weA0v-000000007Kv-3gAR;
	Mon, 29 Jun 2026 11:18:57 +0000
Date: Mon, 29 Jun 2026 19:18:51 +0800
From: kernel test robot <lkp@intel.com>
To: Wenchao Hao <haowenchao@xiaomi.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>
Subject: [akpm-mm:mm-new 107/142] mm/zsmalloc.c:800:21: warning:
 'obj_to_class_idx' defined but not used
Message-ID: <202606291933.Cw5TBs54-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   88cefc306c43b58d9bb65c9e96e284306710d961
commit: b3a8a00229ce2b0367afff075a00d53b92e1234a [107/142] mm/zsmalloc: encode class index in obj value for lockless class lookup
config: csky-randconfig-001-20260629 (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/zsmalloc.c:800:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]
     800 | static unsigned int obj_to_class_idx(unsigned long obj)
         |                     ^~~~~~~~~~~~~~~~


vim +/obj_to_class_idx +800 mm/zsmalloc.c

   798	
   799	/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
 > 800	static unsigned int obj_to_class_idx(unsigned long obj)
   801	{
   802		return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
   803	}
   804	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
