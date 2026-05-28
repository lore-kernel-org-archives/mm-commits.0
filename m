Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B993B0AF8
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 09:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961465; cv=none; b=ea/oOZ3J3JmGJuffqNjNmEXuIqXgh9wiLOMaWe11zvHlmqAk5OgwCyaR5YMbgTwYchAHo1bk4RUhK01Ah4N60lqq+N0WrJpZWueSD0cSdf4Qj5T1db9D6OxqjZl7ltnFkgEFGqwufZtXk1XfQpkDOUUyxVjP4lJv0Uh3WELwhNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961465; c=relaxed/simple;
	bh=/b4vOpec9iABpcQBE3MhMY+Yg/ru9RM5LcBZD8U9uew=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KYc5zF45sPNhiI5cCDDEH/BIqBHVOPHTg8NnKg3RUgrYCqEEmgm1UCvyTcVXCAzblEeO1ZIddqDglLtMMGqeqRo87kRWpGca74BrmkF1s092krJyIWOK1thm2i3jGY6+1dEFhABgnyWw1JJVBAeSXfDpyBJqB43EyROSeGh3xuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Urk34fJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Urk34fJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8561F000E9;
	Thu, 28 May 2026 09:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961463;
	bh=jeODhg2MK7/WnTZNEyznRuSHbbNRvWLI4usnQCb2UCI=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Urk34fJHgFhpclWq2tgQc11LJSzLB8Q6fNfdhVjHQLdYkeJOr6KJCI5iTTTeQLai2
	 TrPXjqkP2bpkbnu6Z2UiN1RP5ELa/Ssc9zLfsvbeS4AGltTPc/XxMR+sDEEOFvsgjQ
	 S6ckGrNIyLtgvnc/LuETN/tjHVYzzk271sSo2S9yx+FUlXWF1/g9syD+Rbm+UGkghg
	 daHJ7uvgkGzmces+LCBSJg4SbOuYVKLQaY9ESjtEScYeC/Il076wDCozZ7wz2b5QAN
	 TE6iEhpY9ev2mT5tRWzEJLpCqhDV9B+bXdcsuWt/On4k82X7zCTDXfX354SoAIbH5t
	 8UZP+fGg2ZkxA==
Message-ID: <5c340177-548e-4c9d-aaaa-d28b30b0903a@kernel.org>
Date: Thu, 28 May 2026 11:44:20 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch added
 to mm-hotfixes-unstable branch
Content-Language: en-US
To: Mark Brown <broonie@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 roman.gushchin@linux.dev, rientjes@google.com, harry@kernel.org
References: <20260525174125.746121F000E9@smtp.kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260525174125.746121F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/25/26 19:41, Andrew Morton wrote:
> The patch titled
>      Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
> Date: Mon, 25 May 2026 09:26:39 +0200
> 
> Make sure the maintainers and reviewers are CC'd on changes to the scripts
> and tools that depend on slab internals.
> 
> Link: https://lore.kernel.org/20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hm I've put that to slab/for-next too, and the slabinfo patches that
triggered this update as well [1] and they are also in the mm tree.

So I see next-20260527 now has that both from mm and slab trees (with
different sha1 hashes), but can't see any heads-up mail about that like in
the past? Did anything change, Mark?

[1] https://lore.kernel.org/all/bc96e4ee-faac-4bed-ac3d-54f1003be62d@suse.com/

> ---
> 
>  MAINTAINERS |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/MAINTAINERS~maintainers-add-slab-related-scripts-and-tools-to-slab-allocator
> +++ a/MAINTAINERS
> @@ -24622,6 +24622,12 @@ F:	mm/mempool.c
>  F:	mm/slab.h
>  F:	mm/slab_common.c
>  F:	mm/slub.c
> +F:	scripts/gdb/linux/slab.py
> +F:	tools/cgroup/memcg_slabinfo.py
> +F:	tools/include/linux/slab.h
> +F:	tools/lib/slab.c
> +F:	tools/mm/slabinfo-gnuplot.sh
> +F:	tools/mm/slabinfo.c
>  
>  SLCAN CAN NETWORK DRIVER
>  M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
> _
> 
> Patches currently in -mm which might be from vbabka@kernel.org are
> 
> maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch
> 

