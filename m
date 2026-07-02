Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E599342A79E
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782981406; cv=none; b=ps7ZEkiKOQ8F/tB950tJKuVrqNbGBpmTpwSG/5ucWOzm2qnJ5DF62KemLyjupLzrG/mdszSAN4bGFX7sA4iUu30eFPyypW3UF6KE5FMIrH5zY6LFHoiasYJ6g55gnRte0NK6Hwl06SdLaSrPiGshp9Vbn9R9p6gsyiait3a9408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782981406; c=relaxed/simple;
	bh=GCE808FFTnLZ4Sn03qLIa4l6n5Bo/CRIAmY9H7HpQdQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ec95fc04ZMswG5u5aiW79OsIWnVb8PHde4fvDVGJ7Vu8gYTTjJKlVAClQ2U/tlnIEziE4n3fP5dLgJcj3TYoHcxagUtInNR98ogaVD4HBm2BfspkIwKCm7RF/1pT5Yn7WPIp85JEbfYXODcaK45wQ5hOOxqJ0JS3q8c44N63KXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEd4QaID; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEd4QaID"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782981405; x=1814517405;
  h=date:from:to:cc:subject:message-id;
  bh=GCE808FFTnLZ4Sn03qLIa4l6n5Bo/CRIAmY9H7HpQdQ=;
  b=FEd4QaID4+sCM6ShhKk31iLWNOMaNw9ZGwEjs7u8AAaqaDbzAkiXcv7d
   eO2klD+c0s/kiD5DE+gMac3mm/0KgZ2pSZ2zlSCyO0OUZ+kCZSrJ27hoC
   npRcEikeQ8M3gcGkkk6brk9IP9SoI69TvrW061mL+TIfr97tet6y5+sRJ
   a7fD3Jr4Gv3E1pfsxGq9+y/fGMj0iGFCtZNAMl6PW5id+iNhf/DxOG77q
   pqq426hIwqbSMocyb0AcwSz8bdXD70W7IoAd0KHS7TSIAGvU3rLMLRxOO
   piifENQlfnrx/W+7znBqTZgnkwr1J3slSO+ieCb8PbEk7WycLli2FHwvP
   w==;
X-CSE-ConnectionGUID: 56S0QSXiT2Sea1wZs0we3Q==
X-CSE-MsgGUID: T8y76AGnQZa5InPBlEJrQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="83777434"
X-IronPort-AV: E=Sophos;i="6.25,143,1779174000"; 
   d="scan'208";a="83777434"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 01:36:44 -0700
X-CSE-ConnectionGUID: DuaOJZa+ScyqbzbUqd3j6w==
X-CSE-MsgGUID: PEtHunUbSp2A2RS5dDxPxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,143,1779174000"; 
   d="scan'208";a="251071725"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 02 Jul 2026 01:36:42 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfCuV-00000000AXv-0iV0;
	Thu, 02 Jul 2026 08:36:39 +0000
Date: Thu, 02 Jul 2026 16:35:57 +0800
From: kernel test robot <lkp@intel.com>
To: Kir Chou <note351@hotmail.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, David Gow <davidgow@google.com>
Subject: [akpm-mm:mm-nonmm-unstable 59/59] ERROR: modpost: module
 random32_kunit uses symbol prandom_warmup from namespace
 EXPORTED_FOR_KUNIT_TESTING, but does not import it.
Message-ID: <202607021628.xt8PbnU0-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   2ee1282ed36ff65ff425a4c6d3121bd701dcd547
commit: 1f9afe351aeb325ebb94489d40d8ab65f30f8d2a [59/59] lib/random32: convert selftest to KUnit
config: arm-randconfig-004-20260702 (https://download.01.org/0day-ci/archive/20260702/202607021628.xt8PbnU0-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260702/202607021628.xt8PbnU0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607021628.xt8PbnU0-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: module random32_kunit uses symbol prandom_warmup from namespace EXPORTED_FOR_KUNIT_TESTING, but does not import it.

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
