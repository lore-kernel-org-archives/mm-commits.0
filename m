Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF4848E;
	Wed, 10 Jul 2024 12:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720614307; cv=none; b=kijfLGzf5T4/ElK85wC8R1Fd4vnTeunWMc3yWiqzHO/gsUAlVHbqe6Gt1hTgYypWniSeqVy5puk3YDHPjWAhBcNcvdnVU6bFMuB7CpET+eB7bszO6o7mWPKMGg/8nH5IM9RgpCXuNWNfjtyqcxrKrktdQiOptyNxlGeJIWOF8hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720614307; c=relaxed/simple;
	bh=z+lTZJB14ndJIGHPTlPs8KBnSZiT1XaHMAZ3poDB+wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+Wf0mkVjL21VtY17OJnD2/yve8ucIvyvho7PGdjtV3vZkt6vJhD7Qi5n+2T4dSiTvB1YWuzW+YDhUcRD9GZPbojnjlXOLebfsrYYYBCLtaFdBRqhz1nhFa1bLmGpvnFHEYC/7rP9JflMetrvsq7l6f3HF9/483xwyEJ2NxNU9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pRxtahh0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pRxtahh0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cfmMvx8WDFLp0zmpWD3jB0+etJ0cgAp8t2dSkwKdXN4=; b=pRxtahh0ohDbi51juGKSX0IGFY
	UKfVTw15PViaYKuh/0o1J4mwjX1KcsK39gHZ7xZcDXbY3woyP0CuImaFhBBJHqMgPACu6Fi1EfkKi
	e9mzSXCRSuwgFbq6mkmu8OeNkn9XGXBb+H/uJxzH5sjACVtXM+JpYKQLO5vU5QlITt1lpIeEMhHBj
	MYJCiDETH2i0gB7VrIie0dBkk6g6ix8R9gQRvoGEC1lRfupSwHjTzAvymkhEgY4sRbucxLVTDot5K
	m7FcPxOac7ycsYTzVVIBClNPXxjI13RYYd8rTtHz6vObQ3Vp+oB2KgBDVZdL7KJLI+w8h/jm4pvxF
	bGlfeSDA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sRWNZ-00000009FH4-0Ic8;
	Wed, 10 Jul 2024 12:25:01 +0000
Date: Wed, 10 Jul 2024 13:25:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
	fengwei.yin@intel.com, david@redhat.com, apopple@nvidia.com,
	rtummala@nvidia.com
Subject: Re: +
 mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch
 added to mm-hotfixes-unstable branch
Message-ID: <Zo59nOHY3bwBv_2G@casper.infradead.org>
References: <20240710053442.BCD8EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710053442.BCD8EC32781@smtp.kernel.org>

On Tue, Jul 09, 2024 at 10:34:42PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: fix PTE_AF handling in fault path on architectures with HW AF support
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch

This looks like v1 not v2?

> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Ram Tummala <rtummala@nvidia.com>
> Subject: mm: fix PTE_AF handling in fault path on architectures with HW AF support
> Date: Tue, 9 Jul 2024 17:09:42 -0700
> 
> Commit 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
> replaced do_set_pte() with set_pte_range() and that introduced a
> regression in the following faulting path of non-anonymous vmas on CPUs
> with HW AF (Access Flag) support.
> 
> handle_pte_fault()
>   do_pte_missing()
>     do_fault()
>       do_read_fault() || do_cow_fault() || do_shared_fault()
>         finish_fault()
>           set_pte_range()
> 
> The polarity of prefault calculation is incorrect.  This leads to prefault
> being incorrectly set for the faulting address.  The following if check
> will incorrectly clear the PTE_AF bit instead of setting it and the access
> will fault again on the same address due to the missing PTE_AF bit.
> 
>     if (prefault && arch_wants_old_prefaulted_pte())
>         entry = pte_mkold(entry);
> 
> On a subsequent fault on the same address, the faulting path will see a
> non NULL vmf->pte and instead of reaching the do_pte_missing() path,
> PTE_AF will be correctly set in handle_pte_fault() itself.
> 
> Due to this bug, performance degradation in the fault handling path will
> be observed due to unnecessary double faulting.
> 
> Link: https://lkml.kernel.org/r/20240710000942.623704-1-rtummala@nvidia.com
> Fixes: 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
> Signed-off-by: Ram Tummala <rtummala@nvidia.com>
> Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/memory.c~mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support
> +++ a/mm/memory.c
> @@ -4681,7 +4681,7 @@ void set_pte_range(struct vm_fault *vmf,
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	bool write = vmf->flags & FAULT_FLAG_WRITE;
> -	bool prefault = in_range(vmf->address, addr, nr * PAGE_SIZE);
> +	bool prefault = !in_range(vmf->address, addr, nr * PAGE_SIZE);
>  	pte_t entry;
>  
>  	flush_icache_pages(vma, page, nr);
> _
> 
> Patches currently in -mm which might be from rtummala@nvidia.com are
> 
> mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch
> 
