Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9251A56B849
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788982175; cv=none; b=tsh5o4yJtSDujQRuGwAhc2UyjIQuNCfA+hVhWwlkkKwKMoDmu01/by9iiD2yZhpo8NaxALq8EH9sIE7l1kgLELQtTCXjBz11MvpjR/g0Bpbnpr8AOkXTQX5yn/6ruzPKrEM62K0BiFEjj5Qdj46lR2QhMWIRqXNVXpmH9OkE2Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788982175; c=relaxed/simple;
	bh=xzfWP/TVVBxMP3dUwP2H+KfdNNLSmSz0v0xO+M2s2js=;
	h=Date:From:To:Cc:Subject:Message-ID; b=fteZGnWomR4eZ5mmdhk1Aq6NjcqlqY+QpzW97cECLkrvwpQsfu/m8SqRENVOssglPuwRquU9QrlJS0xl9VHR2nKngFVbdvRXNO+dUS7lS76dy8KjW+ETKqqwWMvLZX+z2IbIxC+Wz+k6gLNyzldBhl6I6/c75QUbBGf2IIYK5/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxTepDgW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxTepDgW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788982172; x=1820518172;
  h=date:from:to:cc:subject:message-id;
  bh=xzfWP/TVVBxMP3dUwP2H+KfdNNLSmSz0v0xO+M2s2js=;
  b=BxTepDgWOseNlL4j8vFw9h/B2WJ3XWEGm3+l2Nfh6ogbI9hcwR7imboi
   qqOgSCbryNF4PGJcf0jr1yfJnFz37DH6w3323Yd7Vm8V8QpDNh4nLdk2H
   VQSOIyfk4vcw4IAT27Mp7mdZxmK5JLgw7ltAj31jvBLmi01+2jQ6XnaqU
   rcVBXUG0+h0JCGWRKpOVgB1h3+K5rHZCqnfIXhSDIni8taZk82jEDw9HR
   Jqj7SKgEp+HNOzkIWrTdVwtc2U0wDoX8PEJAK3nAo+ub74A+FMGrHfA9w
   d6L7AViuIsaPpNDlnQZrmueKZ4iMC8gWmbvIRSuujYII5buoKHoCK4zjY
   w==;
X-CSE-ConnectionGUID: hN+KcGc7TAuOLxGj++QHPw==
X-CSE-MsgGUID: 53eVpBjHSueUOHlkvHXkCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100939900"
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="100939900"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 12:29:30 -0700
X-CSE-ConnectionGUID: U2YWfNcASp6WxK6fcf/CHw==
X-CSE-MsgGUID: 4I9LEY48QpyPWbVMGDitUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="274927121"
Received: from lkp-server01.sh.intel.com (HELO a3e91e2cf319) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 09 Sep 2026 12:29:28 -0700
Received: from kbuild by a3e91e2cf319 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4Nz3-000000000r0-3a93;
	Wed, 09 Sep 2026 19:29:25 +0000
Date: Thu, 10 Sep 2026 03:28:37 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 356/376] include/linux/mmzone.h:1692:10:
 error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202609100351.ALNh2KwC-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0bffe67ab8a72b3725cc31c4b525709bd3a3e223
commit: 6ebb1b77696e9870a9621c0cedee2508357cb480 [356/376] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
config: x86_64-randconfig-123-20260910 (https://download.01.org/0day-ci/archive/20260910/202609100351.ALNh2KwC-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260910/202609100351.ALNh2KwC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:17:
   In file included from include/linux/gfp.h:7:
>> include/linux/mmzone.h:1692:10: error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1692 |         return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
         |                 ^
>> include/linux/mmzone.h:1692:26: error: member reference type 'int' is not a pointer
    1692 |         return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
         |                 ~~~~~~~~~~~~~~  ^
>> include/linux/mmzone.h:1780:35: error: conflicting types for 'NODE_DATA'
    1780 | static inline struct pglist_data *NODE_DATA(int nid)
         |                                   ^
   include/linux/mmzone.h:1692:10: note: previous implicit declaration is here
    1692 |         return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
         |                 ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^


vim +/NODE_DATA +1692 include/linux/mmzone.h

  1689	
  1690	static inline struct zone *device_zone(int nid)
  1691	{
> 1692		return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
  1693	}
  1694	#else
  1695	static inline bool zone_is_zone_device(const struct zone *zone)
  1696	{
  1697		return false;
  1698	}
  1699	
  1700	static inline struct zone *device_zone(int nid)
  1701	{
  1702		return NULL;
  1703	}
  1704	#endif
  1705	
  1706	/*
  1707	 * Returns true if a zone has pages managed by the buddy allocator.
  1708	 * All the reclaim decisions have to use this function rather than
  1709	 * populated_zone(). If the whole zone is reserved then we can easily
  1710	 * end up with populated_zone() && !managed_zone().
  1711	 */
  1712	static inline bool managed_zone(const struct zone *zone)
  1713	{
  1714		return zone_managed_pages(zone);
  1715	}
  1716	
  1717	/* Returns true if a zone has memory */
  1718	static inline bool populated_zone(const struct zone *zone)
  1719	{
  1720		return zone->present_pages;
  1721	}
  1722	
  1723	#ifdef CONFIG_NUMA
  1724	static inline int zone_to_nid(const struct zone *zone)
  1725	{
  1726		return zone->node;
  1727	}
  1728	
  1729	static inline void zone_set_nid(struct zone *zone, int nid)
  1730	{
  1731		zone->node = nid;
  1732	}
  1733	#else
  1734	static inline int zone_to_nid(const struct zone *zone)
  1735	{
  1736		return 0;
  1737	}
  1738	
  1739	static inline void zone_set_nid(struct zone *zone, int nid) {}
  1740	#endif
  1741	
  1742	extern int movable_zone;
  1743	
  1744	static inline int is_highmem_idx(enum zone_type idx)
  1745	{
  1746	#ifdef CONFIG_HIGHMEM
  1747		return (idx == ZONE_HIGHMEM ||
  1748			(idx == ZONE_MOVABLE && movable_zone == ZONE_HIGHMEM));
  1749	#else
  1750		return 0;
  1751	#endif
  1752	}
  1753	
  1754	/**
  1755	 * is_highmem - helper function to quickly check if a struct zone is a
  1756	 *              highmem zone or not.  This is an attempt to keep references
  1757	 *              to ZONE_{DMA/NORMAL/HIGHMEM/etc} in general code to a minimum.
  1758	 * @zone: pointer to struct zone variable
  1759	 * Return: 1 for a highmem zone, 0 otherwise
  1760	 */
  1761	static inline int is_highmem(const struct zone *zone)
  1762	{
  1763		return is_highmem_idx(zone_idx(zone));
  1764	}
  1765	
  1766	bool has_managed_zone(enum zone_type zone);
  1767	static inline bool has_managed_dma(void)
  1768	{
  1769	#ifdef CONFIG_ZONE_DMA
  1770		return has_managed_zone(ZONE_DMA);
  1771	#else
  1772		return false;
  1773	#endif
  1774	}
  1775	
  1776	
  1777	#ifndef CONFIG_NUMA
  1778	
  1779	extern struct pglist_data contig_page_data;
> 1780	static inline struct pglist_data *NODE_DATA(int nid)
  1781	{
  1782		return &contig_page_data;
  1783	}
  1784	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
