Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011C714BF92
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087127; cv=none; b=LHt6YY6rUJVkeIKACbedmV0M90jhDiXpExp0y6ZLGie9ZG8n3VulXww1XaUg+/t95x3k5y6Z85OSsiTf9G/6Mm2IEzc9iOMSbysQc+1ykT3aEcO4wG63WiBhRdd1QHHiR6ZaD6v2GEYavlQ9TlJfdqNbqcO5TTsdNAaRJDQ7pr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087127; c=relaxed/simple;
	bh=NeXt/VQR55oQWvrZNtGzLa5p1Y9eazGeFFKk5W/tI6k=;
	h=Date:From:To:Cc:Subject:Message-ID; b=hX0WUq1LwUhCc7WajTUJQaL+szqBpU/07+ZCmVKSF79/NkiRTUD+84ykPeru9PkZq8P2fQM81ZyJYUu/ZYm2OToZs2mBNi2L1Zir+FVhwZbexdNWrnaCNsGBIYsoknQYh/nPZKI98kvx88H5dG6Dj5h0Tm8PRGvIouK4T5Mznbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CXVFN8ez; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CXVFN8ez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789087126; x=1820623126;
  h=date:from:to:cc:subject:message-id;
  bh=NeXt/VQR55oQWvrZNtGzLa5p1Y9eazGeFFKk5W/tI6k=;
  b=CXVFN8ezeueFctGQSlETywHYDs5tPzPyFsIZcXobuQbVBeri7rF5qRe8
   yw7Z2SrLHhensYyFHX+M3Lr3q6MwbQE6QANJli0Ly+/Xgpi19WrL9hZm0
   1pIqpZNUUo4nVILnT8+3KA4l42joejqbzXtPC0YAqzMLoeMCMDW0NlzUW
   ha73LbfsD9HeK5ZTXwCajz5cpfFmYYg4ayOVPOBOXtijFyyLMr3rlhZ/y
   y7BddLmyomQVStZTTq53B0sVsorO2pLGJENxWcxSq9jWnMgitlwSZLLUY
   EqZi/S2Hol+RXZavQheX4gVRo6wSoM6CAvjlDZgepvBn4T1LeykfNQI1D
   w==;
X-CSE-ConnectionGUID: HVZbEK5/QVSJHnpTqYS7XQ==
X-CSE-MsgGUID: cNLUMbjCRdiVcQrDzRPFMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89482942"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="89482942"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 17:38:46 -0700
X-CSE-ConnectionGUID: bu7mjKC3Q1Gz6iUNBsHMsg==
X-CSE-MsgGUID: M6AjY437SZiM4AWYaVGBtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="273720633"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 10 Sep 2026 17:38:40 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4pGu-000000000iQ-2XxP;
	Fri, 11 Sep 2026 00:37:58 +0000
Date: Fri, 11 Sep 2026 08:37:16 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new /391]
 arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: error: call to undeclared
 function 'device_zone'; ISO C99 and later do not support implicit function
 declarations
Message-ID: <202609110857.T3uVHRo8-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   1f78f28a2945f9e856b4ea8428ac41a6788e4b67
commit: 88ef4ca76f70778f2f51c9e749dc9bcc607a2424 [/391] powerpc/mm: switch device DAX to shared tail vmemmap pages
config: powerpc64-randconfig-002-20260911 (https://download.01.org/0day-ci/archive/20260911/202609110857.T3uVHRo8-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 96295a1412f9afbee9d4a3c2701e83f5a529a9cc)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260911/202609110857.T3uVHRo8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609110857.T3uVHRo8-lkp@intel.com/

Note: the akpm-mm/mm-new HEAD 1f78f28a2945f9e856b4ea8428ac41a6788e4b67 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

>> arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: error: call to undeclared function 'device_zone'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1274 |         tail_page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                     ^
   arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: note: did you mean 'device_move'?
   include/linux/device.h:1209:5: note: 'device_move' declared here
    1209 | int device_move(struct device *dev, struct device *new_parent,
         |     ^
>> arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: error: incompatible integer to pointer conversion passing 'int' to parameter of type 'struct zone *' [-Wint-conversion]
    1274 |         tail_page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                     ^~~~~~~~~~~~~~~~~
   include/linux/vmemmap-optimization.h:89:72: note: passing argument to parameter 'zone' here
      89 | struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
         |                                                                        ^
   2 errors generated.


vim +/device_zone +1274 arch/powerpc/mm/book3s64/radix_pgtable.c

  1253	
  1254	int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
  1255						      unsigned long start,
  1256						      unsigned long end, int node,
  1257						      struct dev_pagemap *pgmap)
  1258	{
  1259		/*
  1260		 * we want to map things as base page size mapping so that
  1261		 * we can save space in vmemmap. We could have huge mapping
  1262		 * covering out both edges.
  1263		 */
  1264		unsigned long addr;
  1265		unsigned long next;
  1266		pgd_t *pgd;
  1267		p4d_t *p4d;
  1268		pud_t *pud;
  1269		pmd_t *pmd;
  1270		pte_t *pte;
  1271		struct page *tail_page;
  1272		unsigned int order = pfn_to_section_order(start_pfn);
  1273	
> 1274		tail_page = vmemmap_shared_tail_page(order, device_zone(node));
  1275		if (!tail_page)
  1276			return -ENOMEM;
  1277	
  1278		for (addr = start; addr < end; addr = next) {
  1279	
  1280			pgd = pgd_offset_k(addr);
  1281			p4d = p4d_offset(pgd, addr);
  1282			pud = vmemmap_pud_alloc(p4d, node, addr);
  1283			if (!pud)
  1284				return -ENOMEM;
  1285			pmd = vmemmap_pmd_alloc(pud, node, addr);
  1286			if (!pmd)
  1287				return -ENOMEM;
  1288	
  1289			if (pmd_leaf(READ_ONCE(*pmd))) {
  1290				/* existing huge mapping. Skip the range */
  1291				next = pmd_addr_end(addr, end);
  1292				continue;
  1293			}
  1294			pte = vmemmap_pte_alloc(pmd, node, addr);
  1295			if (!pte)
  1296				return -ENOMEM;
  1297			if (!pte_none(*pte)) {
  1298				/*
  1299				 * This could be because we already have a compound
  1300				 * page whose VMEMMAP_RESERVE_NR pages were mapped and
  1301				 * this request fall in those pages.
  1302				 */
  1303				next = addr + PAGE_SIZE;
  1304				continue;
  1305			} else {
  1306				unsigned long nr_pages = 1UL << order;
  1307				unsigned long addr_pfn = page_to_pfn((struct page *)addr);
  1308				unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
  1309	
  1310				/*
  1311				 * if the address is aligned to huge page size it is the
  1312				 * head mapping.
  1313				 */
  1314				if (pfn_offset == 0) {
  1315					/* Populate the head page vmemmap page */
  1316					pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
  1317					if (!pte)
  1318						return -ENOMEM;
  1319					vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
  1320	
  1321					/*
  1322					 * Populate the tail pages vmemmap page
  1323					 * It can fall in different pmd, hence
  1324					 * vmemmap_populate_address()
  1325					 */
  1326					pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
  1327					if (!pte)
  1328						return -ENOMEM;
  1329	
  1330					next = addr + 2 * PAGE_SIZE;
  1331					continue;
  1332				}
  1333	
  1334				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
  1335				if (!pte)
  1336					return -ENOMEM;
  1337				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
  1338	
  1339				next = addr + PAGE_SIZE;
  1340				continue;
  1341			}
  1342		}
  1343		return 0;
  1344	}
  1345	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
