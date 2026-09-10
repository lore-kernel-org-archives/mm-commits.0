Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968904A92C7
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789055018; cv=none; b=BmnD/IzUc3D65wGt2X6QvOyAHM9Hk+GQNhHk9CNCboCMXM5+sCc/S0MKoHD2Z9fECG/g8W1KsGEIvxxaUtgoZDlCyELwMnugXSDEiIefdSZywmaBep1UNVZV14EZy4S1KVRNWrQTSfwvCEl+WzUtvhIdC2i2ZEXg5IYJoSNr8XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789055018; c=relaxed/simple;
	bh=APtQhSLP5v64rwA65uzWlON02O9fx46Bp5IZaCHaeBY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=HSeMZGLmWur0OEvhQR3FsPXK8NonRRgshptStonXfaQMPBeemqGJkjryOKS7xBwcc1nBKYHybLIFp+jOtSGBi23p9kgS4xOPWIdIGMi20QIArL/blu2S0WFLQyxSJmUY7UMp2cBd8SKpQsNb4I7rU9vdwofFw/qCxFhfLeEPROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gr+Zy+/f; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gr+Zy+/f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789055017; x=1820591017;
  h=date:from:to:cc:subject:message-id;
  bh=APtQhSLP5v64rwA65uzWlON02O9fx46Bp5IZaCHaeBY=;
  b=Gr+Zy+/fkcd9gGQu7RXRmByVV+TC7l4oCnGGlo/Do6l8yOo88g1B5lFy
   JlLlfMPHj97HlTxtEGnf3e4r7dsBgAY9H7rpMqwoYzQdYR/c6cYmcKewB
   4WVv3mAayrCAU9Ksuzeca0vVrfq5uk0PEHbO657Ji+rUjlD85Cjxt3Ffl
   raBpW1jjCaGjYsYPk9l8H+HCNDia8WoU1S89Ua1x15iiaX/JKB5m8eT0A
   6NJXYn+NUYqohTb/v26urP+XlrVXWxOdfTN/qymtOfiiwu0vKN/wcsn78
   057brHfgsvlEe6U4EnubBCtEGoWrptt/9F3sbrCxUU/cKwhRUjztv9sLe
   w==;
X-CSE-ConnectionGUID: ocr98nq1Sny2nZ69bb51IA==
X-CSE-MsgGUID: orTlEnzmT5q6/btg8SjSKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="93200692"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="93200692"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:43:34 -0700
X-CSE-ConnectionGUID: ML1rlYKQRBGLkAIGYT/jhw==
X-CSE-MsgGUID: DjgB8EBKReqmRYuOGP+O9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="301572130"
Received: from igk-lkp-server01.igk.intel.com (HELO 2232cf45ba3c) ([10.211.93.152])
  by orviesa002.jf.intel.com with ESMTP; 10 Sep 2026 08:43:31 -0700
Received: from kbuild by 2232cf45ba3c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4gvx-000000000RD-2y6a;
	Thu, 10 Sep 2026 15:43:29 +0000
Date: Thu, 10 Sep 2026 17:42:37 +0200
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [akpm-mm:mm-new 358/388] mm/sparse-vmemmap.c:507:48: error:
 passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer
 without a cast
Message-ID: <202609101047.wFyYfjz9-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   cf558a250cf4475a8936902b8978fbb6c61016f8
commit: dd35ca2f2cac9d6439a2ba2f523b98b5a9a9f8f5 [358/388] mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260910/202609101047.wFyYfjz9-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260910/202609101047.wFyYfjz9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609101047.wFyYfjz9-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/sparse-vmemmap.c: In function 'vmemmap_populate_compound_pages':
   mm/sparse-vmemmap.c:507:48: error: implicit declaration of function 'device_zone'; did you mean 'device_move'? [-Wimplicit-function-declaration]
     507 |         page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                ^~~~~~~~~~~
         |                                                device_move
>> mm/sparse-vmemmap.c:507:48: error: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]
     507 |         page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                ^~~~~~~~~~~~~~~~~
         |                                                |
         |                                                int
   mm/sparse-vmemmap.c:172:78: note: expected 'struct zone *' but argument is of type 'int'
     172 | struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
         |                                                                 ~~~~~~~~~~~~~^~~~


vim +/vmemmap_shared_tail_page +507 mm/sparse-vmemmap.c

4917f55b4ef963 Joao Martins    2022-04-28  494  
4917f55b4ef963 Joao Martins    2022-04-28  495  static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
4917f55b4ef963 Joao Martins    2022-04-28  496  						     unsigned long start,
4917f55b4ef963 Joao Martins    2022-04-28  497  						     unsigned long end, int node,
4917f55b4ef963 Joao Martins    2022-04-28  498  						     struct dev_pagemap *pgmap)
4917f55b4ef963 Joao Martins    2022-04-28  499  {
4917f55b4ef963 Joao Martins    2022-04-28  500  	unsigned long size, addr;
4917f55b4ef963 Joao Martins    2022-04-28  501  	pte_t *pte;
4917f55b4ef963 Joao Martins    2022-04-28  502  	int rc;
d1d11861d8a018 Muchun Song     2026-09-08  503  	unsigned long flags = VMEMMAP_POPULATE_DAX;
8fbaacc4a64bd1 Muchun Song     2026-09-08  504  	struct page *page;
8fbaacc4a64bd1 Muchun Song     2026-09-08  505  	unsigned int order = pfn_to_section_order(start_pfn);
4917f55b4ef963 Joao Martins    2022-04-28  506  
8fbaacc4a64bd1 Muchun Song     2026-09-08 @507  	page = vmemmap_shared_tail_page(order, device_zone(node));
8fbaacc4a64bd1 Muchun Song     2026-09-08  508  	if (!page)
4917f55b4ef963 Joao Martins    2022-04-28  509  		return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  510  
8fbaacc4a64bd1 Muchun Song     2026-09-08  511  	if (reuse_compound_section(start_pfn, pgmap))
4917f55b4ef963 Joao Martins    2022-04-28  512  		return vmemmap_populate_range(start, end, node, NULL,
8fbaacc4a64bd1 Muchun Song     2026-09-08  513  					      page_to_pfn(page), flags);
4917f55b4ef963 Joao Martins    2022-04-28  514  
8fbaacc4a64bd1 Muchun Song     2026-09-08  515  	size = min(end - start, (1UL << order) * sizeof(struct page));
4917f55b4ef963 Joao Martins    2022-04-28  516  	for (addr = start; addr < end; addr += size) {
55896f935a60b9 Gautam Menghani 2022-06-12  517  		unsigned long next, last = addr + size;
4917f55b4ef963 Joao Martins    2022-04-28  518  
4917f55b4ef963 Joao Martins    2022-04-28  519  		/* Populate the head page vmemmap page */
d1d11861d8a018 Muchun Song     2026-09-08  520  		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
4917f55b4ef963 Joao Martins    2022-04-28  521  		if (!pte)
4917f55b4ef963 Joao Martins    2022-04-28  522  			return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  523  
4917f55b4ef963 Joao Martins    2022-04-28  524  		/* Populate the tail pages vmemmap page */
4917f55b4ef963 Joao Martins    2022-04-28  525  		next = addr + PAGE_SIZE;
d1d11861d8a018 Muchun Song     2026-09-08  526  		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
4917f55b4ef963 Joao Martins    2022-04-28  527  		if (!pte)
4917f55b4ef963 Joao Martins    2022-04-28  528  			return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  529  
4917f55b4ef963 Joao Martins    2022-04-28  530  		/*
8fbaacc4a64bd1 Muchun Song     2026-09-08  531  		 * Reuse the shared page for the rest of tail pages
ee65728e103bb7 Mike Rapoport   2022-06-27  532  		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
4917f55b4ef963 Joao Martins    2022-04-28  533  		 */
4917f55b4ef963 Joao Martins    2022-04-28  534  		next += PAGE_SIZE;
4917f55b4ef963 Joao Martins    2022-04-28  535  		rc = vmemmap_populate_range(next, last, node, NULL,
8fbaacc4a64bd1 Muchun Song     2026-09-08  536  					    page_to_pfn(page), flags);
4917f55b4ef963 Joao Martins    2022-04-28  537  		if (rc)
4917f55b4ef963 Joao Martins    2022-04-28  538  			return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  539  	}
4917f55b4ef963 Joao Martins    2022-04-28  540  
4917f55b4ef963 Joao Martins    2022-04-28  541  	return 0;
2beea70a3edc03 Joao Martins    2022-04-28  542  }
2beea70a3edc03 Joao Martins    2022-04-28  543  

:::::: The code at line 507 was first introduced by commit
:::::: 8fbaacc4a64bd1bfbfb11bfb48b5db3f4943cbd7 mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages

:::::: TO: Muchun Song <songmuchun@bytedance.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
