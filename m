Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F9D39A049
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 10:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778754433; cv=none; b=pal5ap1+UQHuutSzpDOvPOk3gHmcAmZCu/TIt+XL+bhdwJ+dIUhHIV3EN8VrHesdj5wyQgitvGQ80VIupiUDtuVjsXyd79AZOwKdbOO9ZL2+mEsPnivYzdUhmuA8Nt9bZVu/h/DKUnazgPwIy2xsdeIw+NuzgphcEkoagKDl3Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778754433; c=relaxed/simple;
	bh=3HhlC1VUktv/C3dGPnW7KDEUOWMR3qKkiexr7vbL0e8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=BUJobhc5Bq5+fqxQT78ontlhFKibzkD/vEfmnUnJf7Ptf84DgMUALJWaIw7/PtBCugj81W/uKI8dmHMjrDrsT00US0NykvDogK2AeH1jGUbbLtEycVibHdvqWkVPK1lcYGyJ9JGZ2COC2YFm1ZL/liUYpCILY8rUYHNYt3DxNFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=StAVzRW4; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="StAVzRW4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778754432; x=1810290432;
  h=date:from:to:cc:subject:message-id;
  bh=3HhlC1VUktv/C3dGPnW7KDEUOWMR3qKkiexr7vbL0e8=;
  b=StAVzRW4SXOR17GaE+5sl/DdWU3NTsP9b2PuZXMUxsyt3rRvzd9Kdz6F
   FqSPZWjWLaPURq2gpngbGKnc593U+t/P/1SJHPm7NcN5cojkVtJgh/P7r
   lislSgfP16zQAj0LxOAUSAqSR9zvwgGsXx/QdaggHEubOlGhJS8E8h2xs
   FpFJTQXAHYjtNjrzwISPr8DYIa7IKUaJ+PrLPFCtJHQK0fo+970gpFiCP
   g6kY4ahdsA83xKIYdtCt+FI30hcxq5wee8ktwP9cno/2tRbH8tyj92Six
   oKTQcg3t5rUdJaebTuzPeJ/1oOUjRywUjItchRUS8Eh6Gcotvf/Db5pAL
   A==;
X-CSE-ConnectionGUID: CWpSLPu2RB220wqKIVvhcQ==
X-CSE-MsgGUID: lyz5rmeaTl6T84FzFd8U2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="90387543"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="90387543"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 03:27:12 -0700
X-CSE-ConnectionGUID: fkWXV+1hTsulGXbmFp5Yeg==
X-CSE-MsgGUID: 0LkLLypoQeysFUCEN0oKng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="240185684"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 14 May 2026 03:27:09 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNTHW-000000006M3-3fY3;
	Thu, 14 May 2026 10:27:06 +0000
Date: Thu, 14 May 2026 18:26:11 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:17: error:
 implicit declaration of function '__huge_pmd_unshare'; did you mean
 'huge_pmd_unshare'?
Message-ID: <202605141855.iUPf0H4F-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   444fc9435e57157fcf30fc99aee44997f3458641
commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
config: sh-defconfig (https://download.01.org/0day-ci/archive/20260514/202605141855.iUPf0H4F-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605141855.iUPf0H4F-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605141855.iUPf0H4F-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/hugetlb.c: In function 'hugetlb_unshare_pmds':
>> mm/hugetlb.c:7281:17: error: implicit declaration of function '__huge_pmd_unshare'; did you mean 'huge_pmd_unshare'? [-Wimplicit-function-declaration]
    7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
         |                 ^~~~~~~~~~~~~~~~~~
         |                 huge_pmd_unshare


vim +7281 mm/hugetlb.c

  7233	
  7234	/*
  7235	 * If @take_locks is false, the caller must ensure that no concurrent page table
  7236	 * access can happen (except for gup_fast() and hardware page walks).
  7237	 * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
  7238	 * concurrent page fault handling) and the file rmap lock.
  7239	 */
  7240	static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
  7241					   unsigned long start,
  7242					   unsigned long end,
  7243					   bool take_locks)
  7244	{
  7245		struct hstate *h = hstate_vma(vma);
  7246		unsigned long sz = huge_page_size(h);
  7247		struct mm_struct *mm = vma->vm_mm;
  7248		struct mmu_notifier_range range;
  7249		struct mmu_gather tlb;
  7250		unsigned long address;
  7251		spinlock_t *ptl;
  7252		pte_t *ptep;
  7253	
  7254		if (!(vma->vm_flags & VM_MAYSHARE))
  7255			return;
  7256	
  7257		if (start >= end)
  7258			return;
  7259	
  7260		flush_cache_range(vma, start, end);
  7261		tlb_gather_mmu_vma(&tlb, vma);
  7262	
  7263		/*
  7264		 * No need to call adjust_range_if_pmd_sharing_possible(), because
  7265		 * we have already done the PUD_SIZE alignment.
  7266		 */
  7267		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
  7268					start, end);
  7269		mmu_notifier_invalidate_range_start(&range);
  7270		if (take_locks) {
  7271			hugetlb_vma_lock_write(vma);
  7272			i_mmap_lock_write(vma->vm_file->f_mapping);
  7273		} else {
  7274			i_mmap_assert_write_locked(vma->vm_file->f_mapping);
  7275		}
  7276		for (address = start; address < end; address += PUD_SIZE) {
  7277			ptep = hugetlb_walk(vma, address, sz);
  7278			if (!ptep)
  7279				continue;
  7280			ptl = huge_pte_lock(h, mm, ptep);
> 7281			__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
  7282			spin_unlock(ptl);
  7283		}
  7284		huge_pmd_unshare_flush(&tlb, vma);
  7285		if (take_locks) {
  7286			i_mmap_unlock_write(vma->vm_file->f_mapping);
  7287			hugetlb_vma_unlock_write(vma);
  7288		}
  7289		/*
  7290		 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
  7291		 * Documentation/mm/mmu_notifier.rst.
  7292		 */
  7293		mmu_notifier_invalidate_range_end(&range);
  7294		tlb_finish_mmu(&tlb);
  7295	}
  7296	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
