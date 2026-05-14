Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6EC39A070;
	Thu, 14 May 2026 09:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778751294; cv=none; b=Tkw68qwBVpgA0AqPKr2PQ3r60w9TOEBQCcIuO7/1xwMJt2E4uqGi1O9LkCrZFVvnFqw2pYHj0sI9dYVvDSYh7tfk8o2Zr29LhCT+FsikQmbQwfBlOGaWyo6+5SqtfSY+LwsYD8INxVwZmucvEBvVqdmjBzOtoTedOxJMpLI1p1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778751294; c=relaxed/simple;
	bh=Vfnc6YuxQlJxA6PY7X5ZFvM4hXTzk0D7LNw7UTsZT84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1Y4TEqZeS1YWLBHKmNj53gVO3FY/KAgHgWWWZQ9fr3CMKiPZzWAv0dzfx6gHcKekYmiILsOXyQRim5H4M7qTzD0mLg8pb1eI39DKWa6ZrPF2U2CaBN6/CR+4LF7j0ga0BdpuoMt/v2lLdlZwVBzNvZCwLunl+hwMlw/YIYQK/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLrzU2sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLrzU2sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D4DC2BCB3;
	Thu, 14 May 2026 09:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778751294;
	bh=Vfnc6YuxQlJxA6PY7X5ZFvM4hXTzk0D7LNw7UTsZT84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FLrzU2sls1DQa8YN5s+ZKV70CwHVPGPLTjHOSFGUDOT/wO0P+LwknuxAgoOrg2DlO
	 vL+4z6KmIKpr3UsLUkRbIMYvYSRBSpjbnmIkppNe4ug68np2qYpAUej/mxebagdsMx
	 Araz5iwT+CiCFWnMEMrC5tkVSn85Zt9kypfjbLaT+iBnOd5j6O8rSeJsnPMBviFxms
	 /eyDJ2wvZgl2REilyQ0PVT2MLXvdZv/bq4xJtSBLNP4VLTKTKZue/rJGDWS3h/sKLS
	 3HIv2O/ywKPp0QTX1wuxe9hY3ZEEzqgxcwNJ9d9X/c1cWg2Ww3bw1z6vg24jeOK14X
	 PQlDgYorYjceQ==
Date: Thu, 14 May 2026 10:34:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:3: error: call to
 undeclared function '__huge_pmd_unshare'; ISO C99 and later do not support
 implicit function declarations
Message-ID: <agWXJeWRb6olB6fi@lucifer>
References: <202605141638.b5ZBd6IF-lkp@intel.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605141638.b5ZBd6IF-lkp@intel.com>

On Thu, May 14, 2026 at 04:37:45PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   444fc9435e57157fcf30fc99aee44997f3458641
> commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
> config: powerpc64-randconfig-001-20260514 (https://download.01.org/0day-ci/archive/20260514/202605141638.b5ZBd6IF-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605141638.b5ZBd6IF-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605141638.b5ZBd6IF-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> mm/hugetlb.c:7281:3: error: call to undeclared function '__huge_pmd_unshare'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
>          |                 ^
>    mm/hugetlb.c:7281:3: note: did you mean 'huge_pmd_unshare'?
>    mm/hugetlb.c:6973:5: note: 'huge_pmd_unshare' declared here
>     6973 | int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
>          |     ^
>    1 error generated.

Yup, I missed the !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING case, sending a fix.

Cheers, Lorenzo

>
>
> vim +/__huge_pmd_unshare +7281 mm/hugetlb.c
>
>   7233
>   7234	/*
>   7235	 * If @take_locks is false, the caller must ensure that no concurrent page table
>   7236	 * access can happen (except for gup_fast() and hardware page walks).
>   7237	 * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
>   7238	 * concurrent page fault handling) and the file rmap lock.
>   7239	 */
>   7240	static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
>   7241					   unsigned long start,
>   7242					   unsigned long end,
>   7243					   bool take_locks)
>   7244	{
>   7245		struct hstate *h = hstate_vma(vma);
>   7246		unsigned long sz = huge_page_size(h);
>   7247		struct mm_struct *mm = vma->vm_mm;
>   7248		struct mmu_notifier_range range;
>   7249		struct mmu_gather tlb;
>   7250		unsigned long address;
>   7251		spinlock_t *ptl;
>   7252		pte_t *ptep;
>   7253
>   7254		if (!(vma->vm_flags & VM_MAYSHARE))
>   7255			return;
>   7256
>   7257		if (start >= end)
>   7258			return;
>   7259
>   7260		flush_cache_range(vma, start, end);
>   7261		tlb_gather_mmu_vma(&tlb, vma);
>   7262
>   7263		/*
>   7264		 * No need to call adjust_range_if_pmd_sharing_possible(), because
>   7265		 * we have already done the PUD_SIZE alignment.
>   7266		 */
>   7267		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
>   7268					start, end);
>   7269		mmu_notifier_invalidate_range_start(&range);
>   7270		if (take_locks) {
>   7271			hugetlb_vma_lock_write(vma);
>   7272			i_mmap_lock_write(vma->vm_file->f_mapping);
>   7273		} else {
>   7274			i_mmap_assert_write_locked(vma->vm_file->f_mapping);
>   7275		}
>   7276		for (address = start; address < end; address += PUD_SIZE) {
>   7277			ptep = hugetlb_walk(vma, address, sz);
>   7278			if (!ptep)
>   7279				continue;
>   7280			ptl = huge_pte_lock(h, mm, ptep);
> > 7281			__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
>   7282			spin_unlock(ptl);
>   7283		}
>   7284		huge_pmd_unshare_flush(&tlb, vma);
>   7285		if (take_locks) {
>   7286			i_mmap_unlock_write(vma->vm_file->f_mapping);
>   7287			hugetlb_vma_unlock_write(vma);
>   7288		}
>   7289		/*
>   7290		 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
>   7291		 * Documentation/mm/mmu_notifier.rst.
>   7292		 */
>   7293		mmu_notifier_invalidate_range_end(&range);
>   7294		tlb_finish_mmu(&tlb);
>   7295	}
>   7296
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
