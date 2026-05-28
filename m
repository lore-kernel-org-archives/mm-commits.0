Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B11372661
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956170; cv=none; b=rJkm3f3LqQf4fYyCNW9fOm4++8kZanR7gvv2Ytve7FsNJFdnXyW/lQMSU17nb3MnWl+NJG72jJc+UpkLStb8WVShhDzXAdGkHaCnTFRI/vtbQkdkV0fwx2N58UNpDHPkWQUM2HpGy7H3aY7EqDCh3js1s52aqmZF3PqDgLozbXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956170; c=relaxed/simple;
	bh=XRG8W9NAHc+HbEyj0+UtCgt+HhS+ZeeZXcAuoLpSGFE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Mswzm/nRLXXDFkGiwiZvEYYJHgby0H3TV4U6RgWI0x6jmLBWR9wOzVjOjN2o/GPewXdB1Nojfzj7MU4p3aGJQ7CETsAYdATNO/68uryeHo9USulLHHm0z+jv/w3vv0XkvlAXDLaT/MMozCLbEHMdak6TRPNbbXVS5yb9H6sV2ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IHGDkimU; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IHGDkimU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779956167; x=1811492167;
  h=date:from:to:cc:subject:message-id;
  bh=XRG8W9NAHc+HbEyj0+UtCgt+HhS+ZeeZXcAuoLpSGFE=;
  b=IHGDkimUC1MfgVBtimXvqjELLUBoBJGBQd3UPiTmQBzPJy3BHjXCdyG2
   m8hByVb3A2XfOL38mxuwI8WH/pi3NuRHgFu+jeg8sGBzNc0zW8lojsZIN
   Y4fuuUS9HKmjLQiEr7ol2DBxNY9Cppp0Szpn0p/mlFfrEfkxthNA2+DeQ
   nIBUKu4hfjxAB4D5lr4KgHuWsCuaNLNIcvq9VtXlQTNAgfmkhr90AYVHJ
   OA2lmiXWp5cz/DII+NElLnsTWLWsCzlCkBet15dAmw6zdGXT6IXB1rjI8
   pAEPzZ3pD/AEtqF9WCmc0fG8tkhR3WRlbCnUHy6bl7So9XzJWf10djulB
   A==;
X-CSE-ConnectionGUID: lRM6m6WAQHamdPsaIdfFng==
X-CSE-MsgGUID: pIcDASyITYqHY8Nos8JDVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80520124"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80520124"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 01:16:07 -0700
X-CSE-ConnectionGUID: 91NmiBW4RE2ttYlQlBmu7g==
X-CSE-MsgGUID: 7247Q2d1SaOkJYI760tmCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="266088107"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 28 May 2026 01:16:04 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSVuL-000000005j0-3mpc;
	Thu, 28 May 2026 08:16:01 +0000
Date: Thu, 28 May 2026 16:15:31 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: [akpm-mm:mm-new 429/433] mm/swap_state.c:468:19: error: call
 to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202605281620.lc3rtkBm-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   d7d405cc33d6e3eeba2d6ec8f0b595da2a5c600a
commit: a5e62d9e00dac6f96174c397a82da30e7ae53064 [429/433] mm: switch deferred split shrinker to list_lru
config: hexagon-defconfig (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/swap_state.c:468:19: error: call to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
         |                          ^
   1 error generated.


vim +/folio_memcg_alloc_deferred +468 mm/swap_state.c

   390	
   391	/*
   392	 * Try to allocate a folio of given order in the swap cache.
   393	 *
   394	 * This helper resolves the potential races of swap allocation
   395	 * and prepares a folio to be used for swap IO. May return following
   396	 * value:
   397	 *
   398	 * -ENOMEM / -EBUSY: Order is too large or in conflict with sub slot,
   399	 *                   caller should shrink the order and retry
   400	 * -ENOENT / -EEXIST: Target swap entry is unavailable or cached, the caller
   401	 *                    should abort or try to use the cached folio instead
   402	 */
   403	static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
   404						swp_entry_t targ_entry, gfp_t gfp,
   405						unsigned int order, struct vm_fault *vmf,
   406						struct mempolicy *mpol, pgoff_t ilx)
   407	{
   408		int err;
   409		swp_entry_t entry;
   410		struct folio *folio;
   411		void *shadow = NULL;
   412		unsigned short memcg_id;
   413		unsigned long address, nr_pages = 1UL << order;
   414		struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
   415	
   416		VM_WARN_ON_ONCE(nr_pages > SWAPFILE_CLUSTER);
   417		entry.val = round_down(targ_entry.val, nr_pages);
   418	
   419		/* Check if the slot and range are available, skip allocation if not */
   420		spin_lock(&ci->lock);
   421		err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
   422		spin_unlock(&ci->lock);
   423		if (unlikely(err))
   424			return ERR_PTR(err);
   425	
   426		/*
   427		 * Limit THP gfp. The limitation is a no-op for typical
   428		 * GFP_HIGHUSER_MOVABLE but matters for shmem.
   429		 */
   430		if (order)
   431			gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
   432	
   433		if (mpol || !vmf) {
   434			folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
   435		} else {
   436			address = round_down(vmf->address, PAGE_SIZE << order);
   437			folio = vma_alloc_folio(gfp, order, vmf->vma, address);
   438		}
   439		if (unlikely(!folio))
   440			return ERR_PTR(-ENOMEM);
   441	
   442		/* Double check the range is still not in conflict */
   443		spin_lock(&ci->lock);
   444		err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
   445		if (unlikely(err)) {
   446			spin_unlock(&ci->lock);
   447			folio_put(folio);
   448			return ERR_PTR(err);
   449		}
   450	
   451		__folio_set_locked(folio);
   452		__folio_set_swapbacked(folio);
   453		__swap_cache_do_add_folio(ci, folio, entry);
   454		spin_unlock(&ci->lock);
   455	
   456		if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
   457						   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
   458			spin_lock(&ci->lock);
   459			__swap_cache_do_del_folio(ci, folio, entry, shadow);
   460			spin_unlock(&ci->lock);
   461			folio_unlock(folio);
   462			/* nr_pages refs from swap cache, 1 from allocation */
   463			folio_put_refs(folio, nr_pages + 1);
   464			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
   465			return ERR_PTR(-ENOMEM);
   466		}
   467	
 > 468		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
   469			spin_lock(&ci->lock);
   470			__swap_cache_do_del_folio(ci, folio, entry, shadow);
   471			spin_unlock(&ci->lock);
   472			folio_unlock(folio);
   473			/* nr_pages refs from swap cache, 1 from allocation */
   474			folio_put_refs(folio, nr_pages + 1);
   475			return ERR_PTR(-ENOMEM);
   476		}
   477	
   478		/* memsw uncharges swap when folio is added to swap cache */
   479		memcg1_swapin(folio);
   480		if (shadow)
   481			workingset_refault(folio, shadow);
   482	
   483		node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
   484		lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
   485	
   486		/* Caller will initiate read into locked new_folio */
   487		folio_add_lru(folio);
   488		return folio;
   489	}
   490	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
