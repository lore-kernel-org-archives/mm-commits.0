Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7272E42A7A8
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 08:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790928950; cv=none; b=DlGXHFS4ECClchjrtAeBbTWY0tgyRBZXZ3mxb/xV9Tb8+TcRIfTbUHGViqo7tCsH2IPbWffxAGzmkBHq0FwCUiZhuVCDuB4EPdEgW7q9qZqZFxaN7iqvvPXbE1HQB0yw2RxmauKG0PUafyI6Vy+p/Tl/7opDJhWtN38BVH5o9nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790928950; c=relaxed/simple;
	bh=XqS7iHkEn2mR3jjBidMok/6j6tu+J6dN5j69f+dDAR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyYMdoTg0cpaouU2QjzmEg/gauLC0AF6jLATv3qF2Dg2ujqSOjiw2HpyFAqrbFGGxqX7RzzMc0K/kRGKljdv+0rUPDwPL8pR6WG2TxomOOGd/hbzD+NbMLaLUORW8yiZyjwLB6znFRV8ymMJEgi2wFQbKwjCuRpZeouZ8hwXcQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEKeuXGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEKeuXGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CE41F000FF;
	Fri,  2 Oct 2026 08:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790928943;
	bh=n7vbA/pjTnA64TkKaemDJcdQ81uFzW7AN8GzG7G0UaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IEKeuXGmRbt8IJtjBV/GIC1jhpHoFwIDof43BMcJ1MgL7epfLgmM4vH+Z4uY29f55
	 TBLJIy7EoWWjvaX3lEXghXju9zydSTmJks7yDfXpqWbZISmA5WoC/99nvcs+w72qPX
	 5qtGSom82ncUD/garuJhT4uDd/wLGbkL2wpSY0BvA7MCkwTn0MNE21dM2ZO02XyFk7
	 tZZ39JvyQQRHNDElsb4yXlWyAbpPPwTWwgEIGpUFWYTzZCLQZuDGL5KdCDaXhe9gEy
	 AHCM2qmmEGoqfbWAISNPZzI6G4otjcwPywHtTfLyrZmyB5OVEoP578mR3sm5lQietP
	 6RYhF5UXVx3ig==
Date: Fri, 2 Oct 2026 09:15:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Zi Yan <ziy@nvidia.com>
Subject: Re: mm-next: manual merge of the akpm/mm-unstable branch
Message-ID: <ar9n7y0cnAoAEVkx@gremlin>
References: <75edc952-3ada-4875-b3a9-6338d6f4d36e@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75edc952-3ada-4875-b3a9-6338d6f4d36e@kernel.org>

On Fri, Oct 02, 2026 at 08:22:17AM +0200, David Hildenbrand (Arm) wrote:
> Hi,
>
> today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:
>
>   arch/arm64/kvm/mmu.c
>
> between the commit:
>
>   71cc2c67fb8f KVM: arm64: Use stage-1 leaf size for VM_PFNMAP
>
> from Linus' tree and commits:
>
>   7a41ed87f53f mm: drop some redundant checks around hugetlb VMAs
>   f09773c2c4d0 mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
>
> from the akpm/mm-unstable branch.
>
> I resolved the conflicts manually:

Nice to see this from mm-next :)

This looks the same as [0] and similar to that this LGTM.

[0]:https://lore.kernel.org/all/ar5ZsSo2ybT39BEQ@sirena.org.uk/

>
>
> diff --cc arch/arm64/kvm/mmu.c
> index bf6d6526639f,73c8492e85c4..b0ea1a9391da
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@@ -1468,11 -1468,30 +1468,11 @@@ transparent_hugepage_adjust(struct kvm
>         return PAGE_SIZE;
>   }
>
>  -static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>  +static int get_vma_page_shift(struct vm_area_struct *vma)
>   {
> -       if (is_vm_hugetlb_page(vma))
>  -      unsigned long pa;
>  -
> +       if (vma_is_hugetlb(vma))
>                 return huge_page_shift(hstate_vma(vma));
>
>  -      if (!(vma->vm_flags & VM_PFNMAP))
>  -              return PAGE_SHIFT;
>  -
>  -      pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>  -
>  -#ifndef __PAGETABLE_PMD_FOLDED
>  -      if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
>  -          ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
>  -          ALIGN(hva, PUD_SIZE) <= vma->vm_end)
>  -              return PUD_SHIFT;
>  -#endif
>  -
>  -      if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
>  -          ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
>  -          ALIGN(hva, PMD_SIZE) <= vma->vm_end)
>  -              return PMD_SHIFT;
>  -
>         return PAGE_SHIFT;
>   }
>
> --
> Cheers,
>
> David
>

--
Cheers, Lorenzo
