Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F51B131E49
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 00:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766190692; cv=none; b=ZlN2TAvNcywDvlNzkwwDTx3XOZ37uZC8LAfVRaZPBilfWiG4LfZRaKkXsE62uqOc/9PCi9WWhJvGl+/ePKn1SjpGWLC7u0ipo3gZSxPOkLvBpze4rNKj+Fc3ZGp09w+mJvfIdjQajvhWObuaxGbN9ORzpw0GXIkL2DA+OoHImmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766190692; c=relaxed/simple;
	bh=WpzT5b5EOPfbdzn32kTKltlkLi6BuxvsUmaO1fzLApI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpmyTmrMeXQyVe25TzxIUKRujulJqs0gMtJuoD9bD6m0YSu7Vg7eUIuHggnVSiEaEwAro48WikIvh99wGB5ZRvbNqpDaTcCm7P76kVRryr7I9r2C5FWyLQNK5CxZmsiEV1cDXoFlEXvgfyD0GhUJR3ojB0qiegYy4Dh85hAleWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gv0LBTnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gv0LBTnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDF9C4CEF1;
	Sat, 20 Dec 2025 00:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766190691;
	bh=WpzT5b5EOPfbdzn32kTKltlkLi6BuxvsUmaO1fzLApI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gv0LBTnLpL8rRExLlVWi3YbWV/xvYhXae33FLoGmmcrKEupM1wc8AtlF+X+jikyhh
	 QJgpDhxa0yUmN5mjjmd7cQz4m8rnSwJtoXHr0aqaEIhdqOckCGUy6CtTTiETb/A7BZ
	 fszptH+6jnKOL7met9A8cnhIP2fj7muR6zu5KUWP+tOk/AdNS3jVKnNSIALnqa7rYi
	 bAdS6Qht69GspiwNpykKgR5mmYVJP0qKmKmfZF8YD29Wbxmh8mcr4UYzyz1psk/hs2
	 iq+ZpwSlWr/wEkxoKr4MrJvSl0We/lZdIWe4cHO4v8CgFUDEch2G7n8nWh54M8u5bm
	 8dk88M6vk8+pA==
Date: Fri, 19 Dec 2025 16:31:25 -0800
From: Dennis Zhou <dennis@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tj@kernel.org, cl@gentwo.org,
	a909204013@gmail.com, niuwl1@chinatelecom.cn
Subject: Re: + mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch
 added to mm-new branch
Message-ID: <aUXuXQMpBtbXzfFo@snowbird>
References: <20251216204201.A8C33C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216204201.A8C33C4CEFB@smtp.kernel.org>

Hi Andrew,

On Tue, Dec 16, 2025 at 12:42:00PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/percpu: drop unused max_upa in pcpu_build_alloc_info()
> has been added to the -mm mm-new branch.  Its filename is
>      mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> The mm-new branch of mm.git is not included in linux-next
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
> From: WanLi Niu <niuwl1@chinatelecom.cn>
> Subject: mm/percpu: drop unused max_upa in pcpu_build_alloc_info()
> Date: Mon, 8 Dec 2025 17:26:27 +0800
> 
> pcpu_build_alloc_info() only needs the initial upa as the starting point
> for the downward search.  Storing it in max_upa and reusing it adds no
> value.  Iterate from upa directly to remove the redundant local variable
> without changing behavior, improving readability.
> 
> Link: https://lkml.kernel.org/r/20251208092627.5603-1-niuwl1@chinatelecom.cn
> Signed-off-by: WanLi Niu <niuwl1@chinatelecom.cn>
> Co-developed-by: hlleng <a909204013@gmail.com>
> Signed-off-by: hlleng <a909204013@gmail.com>
> Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/percpu.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> --- a/mm/percpu.c~mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info
> +++ a/mm/percpu.c
> @@ -2800,7 +2800,7 @@ static struct pcpu_alloc_info * __init _
>  	const size_t static_size = __per_cpu_end - __per_cpu_start;
>  	int nr_groups = 1, nr_units = 0;
>  	size_t size_sum, min_unit_size, alloc_size;
> -	int upa, max_upa, best_upa;	/* units_per_alloc */
> +	int upa, best_upa;	/* units_per_alloc */
>  	int last_allocs, group, unit;
>  	unsigned int cpu, tcpu;
>  	struct pcpu_alloc_info *ai;
> @@ -2817,7 +2817,7 @@ static struct pcpu_alloc_info * __init _
>  	dyn_size = size_sum - static_size - reserved_size;
>  
>  	/*
> -	 * Determine min_unit_size, alloc_size and max_upa such that
> +	 * Determine min_unit_size, alloc_size such that
>  	 * alloc_size is multiple of atom_size and is the smallest
>  	 * which can accommodate 4k aligned segments which are equal to
>  	 * or larger than min_unit_size.
> @@ -2829,7 +2829,6 @@ static struct pcpu_alloc_info * __init _
>  	upa = alloc_size / min_unit_size;
>  	while (alloc_size % upa || (offset_in_page(alloc_size / upa)))
>  		upa--;
> -	max_upa = upa;
>  
>  	cpumask_copy(&mask, cpu_possible_mask);
>  
> @@ -2860,7 +2859,7 @@ static struct pcpu_alloc_info * __init _
>  	 */
>  	last_allocs = INT_MAX;
>  	best_upa = 0;
> -	for (upa = max_upa; upa; upa--) {
> +	for (; upa; upa--) {
>  		int allocs = 0, wasted = 0;
>  
>  		if (alloc_size % upa || (offset_in_page(alloc_size / upa)))
> _
> 
> Patches currently in -mm which might be from niuwl1@chinatelecom.cn are
> 
> mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch
> 

I'd prefer if we dropped this because it's part of init code and makes
it clear max_upa is the outcome of the code above and the start for the
code below.

Separately, I just sent you a respin of the percpu double free check
[1].

[1] https://lore.kernel.org/lkml/20251220002737.84100-1-dennis@kernel.org/


Thanks,
Dennis
