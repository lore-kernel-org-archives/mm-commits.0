Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294291D8E10
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 10:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746698938; cv=none; b=hqvIy7wOmAU9+xTFTyNmGKJEL0FuF3y1zI5KmyXATSGmFXEGmrvldWjYRpFuA/j3HObN1dHojOtgHqjIsPqjY6ATaCerzzZcIxSSteyloK7tNhb+SXHSK/JKRZAtjf7hJaPTtQ6HDASX2yycdqLoKHsOnZIapXD2spmIlqZyw+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746698938; c=relaxed/simple;
	bh=iQ3+QXz9AS0Kb9dmsi8qN7dfLBaQ3iUR5dO2uQbxnL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=vFU+LnOoWkHoSWaYuKWmluzYf1sasE2trJl730oE5xGGTJ0c3j6Yrqi61G1qNLSpWvrG++cPKX3oA/YHjn+/+gHpecgXeP8YflJXuhRQphWpFD10pXnAEQ9en4zhuEWhxGWHAEhZtkhsSqDiIbzMmcZ2x9UOv7mv7f5QMLL+D0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02C3B106F;
	Thu,  8 May 2025 03:08:45 -0700 (PDT)
Received: from [10.162.43.19] (K4MQJ0H1H2.blr.arm.com [10.162.43.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DE713F5A1;
	Thu,  8 May 2025 03:08:49 -0700 (PDT)
Message-ID: <addcfcdf-3ded-4d9d-8a96-6006d3b71a51@arm.com>
Date: Thu, 8 May 2025 15:38:46 +0530
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-optimize-mremap-by-pte-batching.patch added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, zhengqi.arch@bytedance.com, yang@os.amperecomputing.com,
 willy@infradead.org, vbabka@suse.cz, ryan.roberts@arm.com,
 peterx@redhat.com, mingo@kernel.org, maobibo@loongson.cn,
 lorenzo.stoakes@oracle.com, libang.li@antgroup.com, liam.howlett@oracle.com,
 jannh@google.com, ioworker0@gmail.com, hughd@google.com, david@redhat.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, anshuman.khandual@arm.com
References: <20250508014113.7E78FC4CEE2@smtp.kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250508014113.7E78FC4CEE2@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 08/05/25 7:11 am, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm: optimize mremap() by PTE batching
> has been added to the -mm mm-new branch.  Its filename is
>       mm-optimize-mremap-by-pte-batching.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-mremap-by-pte-batching.patch
> 
> This patch will later appear in the mm-new branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Dev Jain <dev.jain@arm.com>
> Subject: mm: optimize mremap() by PTE batching
> Date: Wed, 7 May 2025 11:32:56 +0530
> 
> To use PTE batching, we want to determine whether the folio mapped by the
> PTE is large, thus requiring the use of vm_normal_folio().  We want to
> avoid the cost of vm_normal_folio() if the code path doesn't already
> require the folio.  For arm64, pte_batch_hint() does the job.  To
> generalize this hint, add a helper which will determine whether two
> consecutive PTEs point to consecutive PFNs, in which case there is a high
> probability that the underlying folio is large.
> 
> Next, use folio_pte_batch() to optimize move_ptes().  On arm64, if the
> ptes are painted with the contig bit, then ptep_get() will iterate through
> all 16 entries to collect a/d bits.  Hence this optimization will result
> in a 16x reduction in the number of ptep_get() calls.  Next,
> ptep_get_and_clear() will eventually call contpte_try_unfold() on every
> contig block, thus flushing the TLB for the complete large folio range.
> Instead, use get_and_clear_full_ptes() so as to elide TLBIs on each contig
> block, and only do them on the starting and ending contig block.
> 
> Link: https://lkml.kernel.org/r/20250507060256.78278-3-dev.jain@arm.com
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Bang Li <libang.li@antgroup.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: bibo mao <maobibo@loongson.cn>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   include/linux/pgtable.h |   29 +++++++++++++++++++++++++++++
>   mm/mremap.c             |   37 ++++++++++++++++++++++++++++++-------
>   2 files changed, 59 insertions(+), 7 deletions(-)
> 
> --- a/include/linux/pgtable.h~mm-optimize-mremap-by-pte-batching
> +++ a/include/linux/pgtable.h
> @@ -369,6 +369,35 @@ static inline pgd_t pgdp_get(pgd_t *pgdp
>   }
>   #endif
>   
> +/**
> + * maybe_contiguous_pte_pfns - Hint whether the page mapped by the pte belongs
> + * to a large folio.
> + * @ptep: Pointer to the page table entry.
> + * @pte: The page table entry.
> + *
> + * This helper is invoked when the caller wants to batch over a set of ptes
> + * mapping a large folio, but the concerned code path does not already have
> + * the folio. We want to avoid the cost of vm_normal_folio() only to find that
> + * the underlying folio was small; i.e keep the small folio case as fast as
> + * possible.
> + *
> + * The caller must ensure that ptep + 1 exists.
> + */
> +static inline bool maybe_contiguous_pte_pfns(pte_t *ptep, pte_t pte)
> +{
> +	pte_t *next_ptep, next_pte;
> +
> +	if (pte_batch_hint(ptep, pte) != 1)
> +		return true;
> +
> +	next_ptep = ptep + 1;
> +	next_pte = ptep_get(next_ptep);
> +	if (!pte_present(next_pte))
> +		return false;
> +
> +	return unlikely(pte_pfn(next_pte) - pte_pfn(pte) == 1);
> +}
> +
>   #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>   static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>   					    unsigned long address,
> --- a/mm/mremap.c~mm-optimize-mremap-by-pte-batching
> +++ a/mm/mremap.c
> @@ -170,6 +170,23 @@ static pte_t move_soft_dirty_pte(pte_t p
>   	return pte;
>   }
>   
> +/* mremap a batch of PTEs mapping the same large folio */
> +static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
> +		pte_t *ptep, pte_t pte, int max_nr)
> +{
> +	const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
> +	struct folio *folio;
> +	int nr = 1;
> +
> +	if ((max_nr != 1) && maybe_contiguous_pte_pfns(ptep, pte)) {
> +		folio = vm_normal_folio(vma, addr, pte);
> +		if (folio && folio_test_large(folio))
> +			nr = folio_pte_batch(folio, addr, ptep, pte, max_nr,
> +					     flags, NULL, NULL, NULL);
> +	}
> +	return nr;
> +}
> +
>   static int move_ptes(struct pagetable_move_control *pmc,
>   		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
>   {
> @@ -177,7 +194,7 @@ static int move_ptes(struct pagetable_mo
>   	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
>   	struct mm_struct *mm = vma->vm_mm;
>   	pte_t *old_ptep, *new_ptep;
> -	pte_t pte;
> +	pte_t old_pte, pte;
>   	pmd_t dummy_pmdval;
>   	spinlock_t *old_ptl, *new_ptl;
>   	bool force_flush = false;
> @@ -186,6 +203,7 @@ static int move_ptes(struct pagetable_mo
>   	unsigned long old_end = old_addr + extent;
>   	unsigned long len = old_end - old_addr;
>   	int err = 0;
> +	int max_nr;
>   
>   	/*
>   	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
> @@ -236,12 +254,13 @@ static int move_ptes(struct pagetable_mo
>   	flush_tlb_batched_pending(vma->vm_mm);
>   	arch_enter_lazy_mmu_mode();
>   
> -	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
> -				   new_ptep++, new_addr += PAGE_SIZE) {
> -		if (pte_none(ptep_get(old_ptep)))
> +	for (int nr = 1; old_addr < old_end; old_ptep += nr, old_addr += nr * PAGE_SIZE,
> +				   new_ptep += nr, new_addr += nr * PAGE_SIZE) {

Apologies, this is wrong, I moved nr to the for loop thus nr will be 
initialized to 1 only once, what I intend to do is set this to 1 at the 
beginning of each iteration.

> +		max_nr = (old_end - old_addr) >> PAGE_SHIFT;
> +		old_pte = ptep_get(old_ptep);
> +		if (pte_none(old_pte))
>   			continue;
>   
> -		pte = ptep_get_and_clear(mm, old_addr, old_ptep);
>   		/*
>   		 * If we are remapping a valid PTE, make sure
>   		 * to flush TLB before we drop the PTL for the
> @@ -253,8 +272,12 @@ static int move_ptes(struct pagetable_mo
>   		 * the TLB entry for the old mapping has been
>   		 * flushed.
>   		 */
> -		if (pte_present(pte))
> +		if (pte_present(old_pte)) {
> +			nr = mremap_folio_pte_batch(vma, old_addr, old_ptep,
> +						    old_pte, max_nr);
>   			force_flush = true;
> +		}
> +		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr, 0);
>   		pte = move_pte(pte, old_addr, new_addr);
>   		pte = move_soft_dirty_pte(pte);
>   
> @@ -267,7 +290,7 @@ static int move_ptes(struct pagetable_mo
>   				else if (is_swap_pte(pte))
>   					pte = pte_swp_clear_uffd_wp(pte);
>   			}
> -			set_pte_at(mm, new_addr, new_ptep, pte);
> +			set_ptes(mm, new_addr, new_ptep, pte, nr);
>   		}
>   	}
>   
> _
> 
> Patches currently in -mm which might be from dev.jain@arm.com are
> 
> mempolicy-optimize-queue_folios_pte_range-by-pte-batching.patch
> mm-call-pointers-to-ptes-as-ptep.patch
> mm-optimize-mremap-by-pte-batching.patch
> 

