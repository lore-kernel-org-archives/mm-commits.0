Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7323A1A55
	for <mm-commits@vger.kernel.org>; Fri,  4 Sep 2026 22:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788561189; cv=none; b=HFGPw/wtuM+0T2dIUNvIThGyz7+feU4L7Rgv+Kc6oNEBMF2fiWwiMLtjuvPvEUuVjOhe0hZLpIW/o+tp/hDIJWI1YzeDnDX8uD1O7qCnBUWLDfHCysIaiSxfP+srglSUnjq0XfMkgCdznP44BKhdLmMRKGHVG5pjZ++VvtYqoMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788561189; c=relaxed/simple;
	bh=VmuDvGGu5gYnC6uQaNYccGAJzm010w0N5hZH+dEWsE4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=hLAL23FgNSs9wAAPfj19uuwK9d77o4SwJ1q59q+Eyd/iHUGQktujuPBzo3zzEFh9zfaBtzr6yR9KDwiXDveAQYYTZTqh3/5kUEf6vji8jJhAAqD9Qxn5kHBO0feP9Jb5T7zTTfuBGPFrwka+dThHPVru35X7/ZfYB3G9QDOw2JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OKtHdjP6; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OKtHdjP6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788561187; x=1820097187;
  h=date:from:to:cc:subject:message-id;
  bh=VmuDvGGu5gYnC6uQaNYccGAJzm010w0N5hZH+dEWsE4=;
  b=OKtHdjP6wSNBkDbUt694gtxk1HkYwA7prVQZd1ffN90DsZ0p0/kMDY6F
   Q32VZhhqbK2LthM5zfRgYVZ/Gbh7Oiz/6ylVKxUgDv3IYMbg1KAXNQjkL
   IBvovRzmXzk9kRfqHYLI9/EQ9OC83cbRWP/Kn8GKPKr1f5EbxzQ+4K4Xf
   ImCaps9U1VinfwqdhDrzklvvtgodnVBhH3r6ILokzxBBS6c5D41ZFs1uS
   /26ngHvrIOpuO7IdpkUXY7kUY0zFYYMAvT6WftKzqVGswRGwx+VAKAqPu
   J3y88WYNaR4icAzCNyYpivbUmbUJjYOqnM04Cr8SbeOYmyJwndw4w8esJ
   w==;
X-CSE-ConnectionGUID: vAOK4JzUQICYRDwhjHlPtQ==
X-CSE-MsgGUID: b5bVnprlQBiJiWuEVwh9oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="106584643"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="106584643"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 15:33:07 -0700
X-CSE-ConnectionGUID: LrHTzWPBQl6cMnrSigAXOw==
X-CSE-MsgGUID: 1SdEnM2xTwyPVLZOw10xAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="270683256"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 04 Sep 2026 15:33:06 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2cT0-00000000ADe-3wVC;
	Fri, 04 Sep 2026 22:33:02 +0000
Date: Sat, 05 Sep 2026 06:32:19 +0800
From: kernel test robot <lkp@intel.com>
To: Gregory Price <gourry@gourry.net>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 301/316] mm/memory_hotplug.c:1507:13:
 warning: 'node_is_memoryless' defined but not used
Message-ID: <202609050628.ywCLhOj5-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

Hi Gregory,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
commit: 77a622e07892674da28eb3ad349ddd96df10aded [301/316] mm/memory_hotplug: factor out node_is_memoryless()
config: x86_64-randconfig-161-20260904 (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]
    1507 | static bool node_is_memoryless(int nid)
         |             ^~~~~~~~~~~~~~~~~~


vim +/node_is_memoryless +1507 mm/memory_hotplug.c

  1505	
  1506	/* Caller must hold the memory hotplug lock for this check. */
> 1507	static bool node_is_memoryless(int nid)
  1508	{
  1509		/*
  1510		 * A node still spanning pages (especially ZONE_DEVICE) is not
  1511		 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
  1512		 * e.g. once a memory block has been onlined.
  1513		 */
  1514		if (node_spanned_pages(nid))
  1515			return false;
  1516		/*
  1517		 * Offline memory blocks may not be spanned by the node yet, but they
  1518		 * link to it in sysfs and can be onlined later, so the node is not
  1519		 * memoryless while any remain.
  1520		 */
  1521		return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
  1522	}
  1523	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
