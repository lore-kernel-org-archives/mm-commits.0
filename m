Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626141C3F02
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 22:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744236651; cv=none; b=sJC/YLeQk5lCcv3IpYfwSuMnGJ3iVtghFyYlzooZSJxU0ABNlU9cBbiYqrN7VB4VJXtFmD4l+erxlDD7BJdNgAFirj4hDYblYVBJCKWxYnjNxP9d19ZQGDWtn/IiDqlKsSLpLs2/LXYCjXwV3ldKJM6NDWy30qkxjH6+Fih8D1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744236651; c=relaxed/simple;
	bh=xZ6/brL4PxwWuZSYvzdhQ0Ld1yAiBuGdd1LFoQ5wtKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IAmf0oEEhMLIQ95VPR3jqK794UaqX5OIlWzWH7vCkfcFlu1MEN1pkvKXGDJXmnTel9aGU2Gy4o1iY9zpmXMUkjeKezuC9sXVtLLsBkvKuKogLRpp7M3AHNU4unfYRoh4lAk4x6TTuG3BSnggaM3tCTIoRlp16U5qk+sB8ARElh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oCpRYKt1; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oCpRYKt1"
Date: Wed, 9 Apr 2025 18:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744236636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dw2AeEghvEWYkbRui+n5URzrCPRz6+F/9btodlj4EVQ=;
	b=oCpRYKt1VE2hASZ6JQjcUZaS4Fx07lpbx9YDQoxfxMblHKE9jqRMOITAcJzp5+PXxewTKw
	zJl1ZNGM0+u5Tn5Pm5emm7AXqxPsNk9ez7IHmbWL7489dlhstWstFmAaHzySWt0wRwXXpg
	pQybc5vQysz0YvqA2sFwNvFXSNWuFEg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, surenb@google.com, stable@vger.kernel.org, 
	janghyuck.kim@samsung.com, tjmercier@google.com
Subject: Re: +
 alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
 added to mm-hotfixes-unstable branch
Message-ID: <hzrrdhrvtabiz7g4bvj53lg64f7th5d7ravduisnaqmwmmqubr@f52xy2uq6222>
References: <20250409211241.70C37C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409211241.70C37C4CEE2@smtp.kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 09, 2025 at 02:12:40PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: alloc_tag: handle incomplete bulk allocations in vm_module_tags_populate
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
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

I don't think we want to rush this patch, given that it's not fixing an
actual crash.

I'm currently chasing a crash (null ptr deref, slab obj extension vector
seems to not be getting allocated correctly) in 6.15-rc1, so I'm
wondering what's missing in our test coverage.

> ------------------------------------------------------
> From: "T.J. Mercier" <tjmercier@google.com>
> Subject: alloc_tag: handle incomplete bulk allocations in vm_module_tags_populate
> Date: Wed, 9 Apr 2025 19:54:47 +0000
> 
> alloc_pages_bulk_node may partially succeed and allocate fewer than the
> requested nr_pages.  There are several conditions under which this can
> occur, but we have encountered the case where CONFIG_PAGE_OWNER is enabled
> causing all bulk allocations to always fallback to single page allocations
> due to commit 187ad460b841 ("mm/page_alloc: avoid page allocator recursion
> with pagesets.lock held").
> 
> Currently vm_module_tags_populate immediately fails when
> alloc_pages_bulk_node returns fewer than the requested number of pages. 
> This patch causes vm_module_tags_populate to retry bulk allocations for
> the remaining memory instead.
> 
> Link: https://lkml.kernel.org/r/20250409195448.3697351-1-tjmercier@google.com
> Fixes: 187ad460b841 ("mm/page_alloc: avoid page allocator recursion with pagesets.lock held")
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> Reported-by: Janghyuck Kim <janghyuck.kim@samsung.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/alloc_tag.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> --- a/lib/alloc_tag.c~alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate
> +++ a/lib/alloc_tag.c
> @@ -422,11 +422,20 @@ static int vm_module_tags_populate(void)
>  		unsigned long old_shadow_end = ALIGN(phys_end, MODULE_ALIGN);
>  		unsigned long new_shadow_end = ALIGN(new_end, MODULE_ALIGN);
>  		unsigned long more_pages;
> -		unsigned long nr;
> +		unsigned long nr = 0;
>  
>  		more_pages = ALIGN(new_end - phys_end, PAGE_SIZE) >> PAGE_SHIFT;
> -		nr = alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
> -					   NUMA_NO_NODE, more_pages, next_page);
> +		while (nr < more_pages) {
> +			unsigned long allocated;
> +
> +			allocated = alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
> +				NUMA_NO_NODE, more_pages - nr, next_page + nr);
> +
> +			if (!allocated)
> +				break;
> +			nr += allocated;
> +		}
> +
>  		if (nr < more_pages ||
>  		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
>  				     next_page, PAGE_SHIFT) < 0) {
> _
> 
> Patches currently in -mm which might be from tjmercier@google.com are
> 
> alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
> 
