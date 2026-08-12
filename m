Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C997E1E5B70
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 01:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498636; cv=none; b=Cy7Uh7iI3Jf97hrCmhvieEofivp5+3pYuufIsF/53PxIIDcLsoSWyBiu8OJc0FSxkWZprVh5dklPBGkEvw84r6srddWYW0pvHCxdfm+z7FYOMMCwMymxywRxl1W9Nrayvepg8QrBCVuKoSYaTqHYBwwhbMWBo8UsxGERijK4grI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498636; c=relaxed/simple;
	bh=2q1eG+w++9DvhN5uDP9+vZkmqJMZMkCNqvHw6LpSRFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GBTF3znuflk7eEST41CilZADn9Mb8T9hU9DPEAYut9lhWwUG+eH+Jpc2DcvZI4zBCQVYUCUmM/AenmHgEUi5e9YAFUOqtsdZxZ/mOWYEjODUnzvA6J9Q6QyQBdTuimgMRpPKiSNX5yoF1MdbDA9FVDe/TDRJiktbtAt8Z3Ul3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jx/xY/si; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jx/xY/si"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=H0ZGdzMmIKtYJp3RsV2xlTw0lgUNEBmiwmapRBJo8mo=; b=Jx/xY/sivYPsdEBJG4NMpT/bTK
	6toolaa9tXlDwmGn/hAOHwD7500Xug3V6+YKCFy6CgpX4ii73tWcgiWt2mAMODR3bmda3IlQRRcvX
	5GOWm4PhoKjql/ooM0XVaJmq7Xv53TqCXGMWddpZXXdyJv1o0HRNqmb2QTUOqXxcvaNTV98n8f41u
	5cAkexCK2mGCq+gJqRCX8qHQJmibP67bOvRTht6od7qHoahRIWUDQVsqhRSEFeWPVgwUI4RL6D2Fz
	j2X81oZFjgh5EZaafnY/4QdXt/YL17q+2I7JfBha3QBESD17eOa49GLdV9rUVPm8UzSmN7ZYB3SEB
	kHU3I/8A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtxu5-0000000FDMq-0VmJ;
	Wed, 12 Aug 2026 01:37:13 +0000
Message-ID: <136c1a51-16b3-421d-a2a5-db4ee477dd14@infradead.org>
Date: Tue, 11 Aug 2026 18:37:12 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch added
 to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ljs@kernel.org
References: <20260812011928.412631F000E9@smtp.kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260812011928.412631F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/11/26 6:19 PM, Andrew Morton wrote:
> The patch titled
>      Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
> Date: Tue Aug 11 06:18:29 PM PDT 2026
> 
> fix kerneldoc
> 
> Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Closes: https://lore.kernel.org/e7911812-9b99-4f94-be6b-597bf202ffeb@infradead.org
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> 
>  include/linux/mm.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
> +++ a/include/linux/mm.h
> @@ -2319,7 +2319,7 @@ static inline bool vma_flags_is_cow_mapp
>  
>  /**
>   * vma_is_cow_mapping() - Is this VMA a CoW mapping?
> - * @desc: The VMA to check.
> + * @vma: The VMA to check.
>   *
>   * See vma_flags_is_cow_mapping() for details.
>   *
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
> mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch
> tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch
> mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
> selftests-mm-use-pattern-matching-in-gitignore-fix.patch
> alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
> selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
> mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
> mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
> lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
> drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
> 

-- 
~Randy
