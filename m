Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A420B6F06A
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 07:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756280872; cv=none; b=tCC/LyyYY/n7NBMmW28IFPdTbdaO0smAxDKf1PRXPA+dHVzS6GaIIahK5wHBcQ9Bshh7OcwHxixPvu0BlNajb4+bbVZglkjfxvFeLf3wJr3FBIenQnvS+aNYMGTZPNlvcH2s72WCz3o+zQT2y7PmWdZZ6hybHMLR+89Y1jMTQOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756280872; c=relaxed/simple;
	bh=KqqDeYG0IfXc2f7fBe2nB/yJuyGlO4pyPDchjG1lGu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhhge40rjUtVckktn+poKiBUikIx1DUVN0h4Rds0QZ0Q4uAxzWg8sjKOHMNLzVzCHx1CHxlEBEdqd7hYKhXa7rYROrRptpbRdLSOEVVfDQ0KPDPuF7WjLygaCs42cgEMC0npaZnZcwNmXAMT4Ff5fp+MbLKaSkyh37hRQ0yIYjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nzFZbRPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzFZbRPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D04C4CEEB;
	Wed, 27 Aug 2025 07:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756280872;
	bh=KqqDeYG0IfXc2f7fBe2nB/yJuyGlO4pyPDchjG1lGu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nzFZbRPZhzzhTLgiY80zcGwHP+37J90ekB9e6xe+quoddFxYKcEj1tc7t6ioUtWws
	 +Bi7h/GvFPged+V1/lgrA8vMEeGLCC3lgaKyHSY5ptZjxoT4qK9Tb2oEC1znmgxK5P
	 y6gh/18I58pL1nVi8JrxKLjO64cKVPO5jufZGcB+Uqufqx+cP1YJBGdmNhVogLM6On
	 gAiFBknIxTuWiGDAgXOnFpcTgA1t3KjAO9H7l9E/DVNtn15qMM4Z1sdoE9S4PhWRQj
	 mbIeGr9iKmKrn8zP7a6Dmw0rEpuTHEpyzRTt1XqSEM7kJNf87m2EqNHxvO1PogMuqA
	 gik/oos+/vwWg==
Date: Wed, 27 Aug 2025 10:47:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, david@redhat.com
Subject: Re: + memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch added
 to mm-unstable branch
Message-ID: <aK64IsMNJUvMbn5Y@kernel.org>
References: <20250827032507.C1989C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827032507.C1989C4CEEB@smtp.kernel.org>

Hi Andrew,

On Tue, Aug 26, 2025 at 08:25:07PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
> has been added to the -mm mm-unstable branch.  Its filename is
>      memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch

Can you drop it please?
I am meaning to take it via memblock tree.
 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch
> 
> This patch will later appear in the mm-unstable branch at
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
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Subject: memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
> Date: Tue, 26 Aug 2025 10:19:46 +0300
> 
> The kernel-doc description of MEMBLOCK_RSRV_NOINIT and
> memblock_reserved_mark_noinit() do not accurately describe their
> functionality.
> 
> Expand their kernel doc to make it clear that the user of
> MEMBLOCK_RSRV_NOINIT is responsible to properly initialize the struct
> pages for such regions and add more details about effects of using this
> flag.
> 
> Link: https://lkml.kernel.org/r/20250826071947.1949725-1-rppt@kernel.org
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/memblock.h |    5 +++--
>  mm/memblock.c            |   15 +++++++++++----
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> --- a/include/linux/memblock.h~memblock-fix-kernel-doc-for-memblock_rsrv_noinit
> +++ a/include/linux/memblock.h
> @@ -40,8 +40,9 @@ extern unsigned long long max_possible_p
>   * via a driver, and never indicated in the firmware-provided memory map as
>   * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
>   * kernel resource tree.
> - * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
> - * not initialized (only for reserved regions).
> + * @MEMBLOCK_RSRV_NOINIT: reserved memory region for which struct pages are not
> + * fully initialized. Users of this flag are responsible to properly initialize
> + * struct pages of this region
>   * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
>   * either explictitly with memblock_reserve_kern() or via memblock
>   * allocation APIs. All memblock allocations set this flag.
> --- a/mm/memblock.c~memblock-fix-kernel-doc-for-memblock_rsrv_noinit
> +++ a/mm/memblock.c
> @@ -1091,13 +1091,20 @@ int __init_memblock memblock_clear_nomap
>  
>  /**
>   * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
> - * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
> - * for this region.
> + * MEMBLOCK_RSRV_NOINIT
> + *
>   * @base: the base phys addr of the region
>   * @size: the size of the region
>   *
> - * struct pages will not be initialized for reserved memory regions marked with
> - * %MEMBLOCK_RSRV_NOINIT.
> + * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
> + * not be fully initialized to allow the caller optimize their initialization.
> + *
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flag
> + * completely bypasses the initialization of struct pages for such region.
> + *
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, struct pages in this
> + * region will be initialized with default values but won't be marked as
> + * reserved.
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> _
> 
> Patches currently in -mm which might be from rppt@kernel.org are
> 
> init-mainc-fix-boot-time-tracing-crash.patch
> kho-allow-scratch-areas-with-zero-size.patch
> lib-test_kho-fixes-for-error-handling.patch
> selftest-kho-update-generation-of-initrd.patch
> memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch
> 

-- 
Sincerely yours,
Mike.
