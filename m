Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE2437A828
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 17:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783014219; cv=none; b=Ay0jzH3zg9c5iCgoD9WRGKHTLYrH4b6IgCqeLEStTz55wb9KB97dqzm/M2QppSWiXAV9PFagiSQECb7Zj/Lv2nBYr/byW+fuOHT2uVD+mdVzTv8Hp8y0g87hBe7GSL3LAyE11zUWTh6qTzLiV3bOpr0Wbva2zMX6sa8J5hEf6jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783014219; c=relaxed/simple;
	bh=QEGMOc3SpuqbmNd6M2wJK5ocPmc94n1B/IOdlFDjgHY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=C+P9WqwbfVn6FxhwyWNKNhOIdieK2bNxhR+26aqK0VbbwjBJ1ZjjzXGz0lvs5tpxNdx3P8B7Pyc9cCznnFSf0S7BPokuUXTt0p4gR/i2LPn0ee2+bcxBZzEsReIv6b44egov8g/sTGg30kbxPyPT9KzuBw6kKfpX3xDp5DPc80I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZxFaTxm; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZxFaTxm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783014218; x=1814550218;
  h=date:from:to:cc:subject:message-id;
  bh=QEGMOc3SpuqbmNd6M2wJK5ocPmc94n1B/IOdlFDjgHY=;
  b=gZxFaTxm11B4TOXSVGgpWlV2Tv3+9hcDYcRM0J0dc9+duR9GDSpsHIrd
   RNO73j/8TQZi4G4rfKJ6gI3S2fhYb6wKPmHUCD6yNxtNp4vLZysqdwsDg
   91yZZ9ZFfZt8sgT8ZN8QKu2dvvzwzUj2LTduDPaxKarnCLfycW4NBdnDI
   XT2jw0mKz761UE0tYKjOQLp/+yoPwQKIQ9A1LOiOaEVdLnPTxbPxwhAaj
   uV8RXg58pJDk9grQKYELMprGrXqISmbxCt7rAlNbDUpLUjIIjEOBnOnsq
   4r1FClSt8+NPs8SN4t/tQTslT49ZTHvKom54DBCTCVx9+BV3zKBNH2zM0
   A==;
X-CSE-ConnectionGUID: /Odp+o0ST2qCpgGPDuv4pw==
X-CSE-MsgGUID: Qxhx+GFJQ7aPizfermPLdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="87688600"
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="87688600"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 10:43:37 -0700
X-CSE-ConnectionGUID: 7BhZeXN6RvKxoVjeSEDdLA==
X-CSE-MsgGUID: 7JE9EWfPRHKgCLJ+37a3Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="257263034"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 02 Jul 2026 10:43:35 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfLRj-00000000B2x-1n7W;
	Thu, 02 Jul 2026 17:43:31 +0000
Date: Fri, 03 Jul 2026 01:43:00 +0800
From: kernel test robot <lkp@intel.com>
To: Kir Chou <note351@hotmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, David Gow <davidgow@google.com>
Subject: [akpm-mm:mm-nonmm-unstable 59/59] WARNING: modpost: module
 random32_kunit uses symbol prandom_warmup from namespace
 EXPORTED_FOR_KUNIT_TESTING, but does not import it.
Message-ID: <202607030125.ziX4WI61-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   2ee1282ed36ff65ff425a4c6d3121bd701dcd547
commit: 1f9afe351aeb325ebb94489d40d8ab65f30f8d2a [59/59] lib/random32: convert selftest to KUnit
config: arm-randconfig-001-20260702 (https://download.01.org/0day-ci/archive/20260703/202607030125.ziX4WI61-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260703/202607030125.ziX4WI61-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607030125.ziX4WI61-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: module random32_kunit uses symbol prandom_warmup from namespace EXPORTED_FOR_KUNIT_TESTING, but does not import it.

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
