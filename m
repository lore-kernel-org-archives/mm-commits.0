Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C716346AC1;
	Thu, 14 May 2026 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778743911; cv=none; b=BFoHLNPA5PDQytIvKv9hoR6huiyG0joKHfpzYd3DQ5gq40FnEjnTkIgLPHXd5D7jmycHP0sSdYrN1Fx3xuxhAWaEqTOprI73njx9+05Cs5PWEf3POT7Y59ryCS9x9yo0lmXtKTBQt5V67agZ2tR8vYlTCrogdnJ2eHL27C/eRV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778743911; c=relaxed/simple;
	bh=Ay5uhoOGOYpltka+aAhsUFibbeXpCTRdpo6QYpLTuJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eX1exiQCpiNQ7kmw1ORp6wzU7A7YgZ6p43j2hmgkjHOK7ulcADR5POqGILiVZE0qUleUNjKxeS/wVDqLv6H54P4/XnWP579DVyeUENUacA0WOvU0xSjHSqjS7dBebbTlHf4ALGdgLnOF+9y0WEnAlWJl8wGj1cBTMAY2OCLQ6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsIdo/I5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsIdo/I5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191BC2BCB7;
	Thu, 14 May 2026 07:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778743911;
	bh=Ay5uhoOGOYpltka+aAhsUFibbeXpCTRdpo6QYpLTuJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsIdo/I5ob6nIZBCV0Nm0QvFRM7GAjZO6cce/dPC6LHVDh3BcmlKrraHqin4HjgxI
	 IL6P7Dgja8fqyb2B5K0+BSNARhjIWtqRcZ9ZAR7c+YIw4YgKZIrW1ToLL3FIQ6igIg
	 WnQFsWl/w+rIMlfLVUbVCT4X2ftfwu+NPs9ZMC/A7p4FJO5zooRyG8FZ+zq87V+1+X
	 O5Wqf35X/x2T316C3nKImY1vE+4NHf6I4b/UBY+IqZGOYM5JZrwKtQx/8k62mjWebt
	 pAdMzKN7BTLZbI0AzfT9eJmXX3oXOSh0ZNnKp7Qyk+wgGEwPvZnqMmZnfko2hdepbL
	 DGZI47eZsn4/Q==
Date: Thu, 14 May 2026 08:31:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:17: error:
 implicit declaration of function '__huge_pmd_unshare'; did you mean
 'huge_pmd_unshare'?
Message-ID: <agV6PCWZGvwNWutl@lucifer>
References: <202605140938.6Mcv6k8i-lkp@intel.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605140938.6Mcv6k8i-lkp@intel.com>

On Thu, May 14, 2026 at 09:04:19AM +0200, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   444fc9435e57157fcf30fc99aee44997f3458641
> commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
> config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260514/202605140938.6Mcv6k8i-lkp@intel.com/config)
> compiler: s390x-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605140938.6Mcv6k8i-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605140938.6Mcv6k8i-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/hugetlb.c: In function 'hugetlb_unshare_pmds':
> >> mm/hugetlb.c:7281:17: error: implicit declaration of function '__huge_pmd_unshare'; did you mean 'huge_pmd_unshare'? [-Wimplicit-function-declaration]
>     7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
>          |                 ^~~~~~~~~~~~~~~~~~
>          |                 huge_pmd_unshare
>

Ack, missed the !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING case. Will send
a patch for this :)

Cheers, Lorenzo

>
> vim +7281 mm/hugetlb.c
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
