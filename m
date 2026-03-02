Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6503A331C
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 21:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485729; cv=none; b=EW9gvPjfulqPTwaueWnXwumKrc6qOZ+hZMxq26vNQ0c/C+g95qViq8N9GbpNOOsgSpsQqiIWBpXL/uhhWusIM38AKhIKOLFkfJJGkGTmXNkdwad4mh9m5wsszHXfyQKrp9vpJFz3D+ANsuUfPG7tahTKMJwDWmCt+49BDKEwU8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485729; c=relaxed/simple;
	bh=VLUsfJ8h+D9a6cgKf5ILbCaejLnicA6M7q9WifS5EdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JSgGxJwTSo0iDOY0HAuwqLpTxJIsufBoTXKF1dS0PQdz5fH9nwNzpW7LZF3hRynNMYe3SQ3C4GcpsWO6vVL4hjrYRXjKubI8iEw0i1sKci8wDTc05/a0FPWKSvcZbl7r2H4y+0zbZbHdn5CkGHml4ykuZoPrvIMUM9yxdzZMi94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ai14CCHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ai14CCHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B3C19423;
	Mon,  2 Mar 2026 21:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772485729;
	bh=VLUsfJ8h+D9a6cgKf5ILbCaejLnicA6M7q9WifS5EdY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ai14CCHL81PmCrThxnP5ePfcklaCG2c4QB48iAE9Rc+lxNBKduw6VCvntK1oBjPX1
	 qEm6fJb7jQUJYNW7wn9B8QOq/mCfopAi5KN8Mr+wNxUhmQniFpLWONRYBTDmdv8oJy
	 /HSb+mTUd/Y8XJ4sajzss5kEi2Ijs6VGMRY6OmXqbZ69kV9qn2Z5JRiNUVTNlJxEhT
	 WIKseN5Cr8IsG362JvhLOvRse/iDj6727Lh8c3SfTOOgm3G6PYCtSRav4kP/aulKua
	 lvPIniv4Ne/dcD3n8WjZV5LpfcJssUnEnnzK+G0ZTCJ8O6zyoGwNTcptTJV85gY4Tm
	 r4PzKHYHOvf/g==
Message-ID: <f6f30640-750f-4c52-ac4b-fa900bd21ac6@kernel.org>
Date: Mon, 2 Mar 2026 22:08:44 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch
 added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 willy@infradead.org, peterx@redhat.com, joshua.hahnjy@gmail.com,
 jhubbard@nvidia.com, jgg@ziepe.ca, dywoq.contact@gmail.com,
 aleks.koyf@gmail.com
References: <20260302204309.E824DC19423@smtp.kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260302204309.E824DC19423@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/2/26 21:43, Andrew Morton wrote:
> The patch titled
>      Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
> has been added to the -mm mm-new branch.  Its filename is
>      mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch
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
> From: Alexey Suchkov <aleks.koyf@gmail.com>
> Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
> Date: Mon, 2 Mar 2026 22:34:05 +0300
> 
> The local variable 'seq' in gup_fast (mm/gup.c) was declared
> without initialization which, with gcc-15.2.1 can trigger:
> 
> mm/gup.c:3165:20: warning: `seq' may be used uninitialized [-Wmaybe-uninitialized]
> 
> Work around this by initializing 'seq' to 0.  This does not change
> behavior, since read_seqcount_retry() always writes to it before use.
> 
> Link: https://lkml.kernel.org/r/20260302193405.37961-1-dywoq.contact@gmail.com
> Signed-off-by: Alexey Suchkov <dywoq.contact@gmail.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/gup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/gup.c~mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning
> +++ a/mm/gup.c
> @@ -3131,7 +3131,7 @@ static unsigned long gup_fast(unsigned l
>  {
>  	unsigned long flags;
>  	int nr_pinned = 0;
> -	unsigned seq;
> +	unsigned int seq = 0;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
>  	    !gup_fast_permitted(start, end))

Odd, because raw_seqcount_try_begin() does as a first thing

	start = raw_read_seqcount(s);

I don't seem to get the warnings on "gcc (Debian 15.2.0-14) 15.2.0".


But certainly does not hurt.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David
