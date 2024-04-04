Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613273FC2
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 07:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712215061; cv=none; b=BYiEGdL4YLMu0+YsU1vnjFAQQdB5/0kR4RNJ2aalajv/5JTrjkqzrWH6haCIjvnr9C49GomGObc4nVGi83CLBqSnUCdZL8J7ZGL5PrS2rbU9qRuKFXEEGoe3OEBJ0c5fw8HCaa5CkaG/R6kbBRMkD19hlTR29G2+9bErDo0D9W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712215061; c=relaxed/simple;
	bh=gVmufX1y5bVxKOGAtFRO/GnXgSJF+9Uuz4tBdj2qp00=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qhj4f9IhnIl+K6ov1XsxXGo0zhBA5CfXkUEBDi7aMwUykLAe38rEEuQXLUqCkgrhscEC0k88FTHqUSMnPNbU1TIK64tQgJ/sjPlG6DlkBvEzUzPgs6sfY0bN76PyLBW5rO2JNOnJTcxlZv9nFEJ9e6oGGDBLhHEK7X0b3/qtsZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NeB/oCch; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bu1HHOrW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NeB/oCch";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bu1HHOrW"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 908695D689;
	Thu,  4 Apr 2024 07:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712215057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w5FMjS1wr2Y69WzSteqjenDt/Dq+6//40cTXdXC5Bgk=;
	b=NeB/oCchXBOVqJh/hNOlDLp7lGnvyrYplrlEm4gxg+Ct1rbbWp1YBBO+Ou03QnGfHoWGos
	wyp4TfzVzYit3UaKvSp5gZ4rd8R7Qrxn/YCEew3mEhn3nj91lUiccAx6SoMcDdZdS15F2u
	ecXAdo9kB7mYrdeCJ265tnODR2TesOU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712215057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w5FMjS1wr2Y69WzSteqjenDt/Dq+6//40cTXdXC5Bgk=;
	b=Bu1HHOrWCTqIAHpCPAs0YVwezpx+nA518we7Lk5QjpWIipxOxcT3GfQ6MbAabgu8kj8N9X
	BvnBt1Jn3CKPK4BQ==
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 69FFC139E8;
	Thu,  4 Apr 2024 07:17:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id p2NHGRFUDmZbdgAAn2gu4w
	(envelope-from <vbabka@suse.cz>); Thu, 04 Apr 2024 07:17:37 +0000
Message-ID: <e268a0e7-41c9-442e-b025-638aff113388@suse.cz>
Date: Thu, 4 Apr 2024 09:17:37 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + stackdepot-rename-pool_index-to-pool_index_plus_1.patch added
 to mm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 osandov@fb.com, osalvador@suse.de, mhocko@suse.com, glider@google.com,
 elver@google.com, andreyknvl@gmail.com, pcc@google.com
References: <20240404015549.E6EE6C433C7@smtp.kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240404015549.E6EE6C433C7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[9];
	 FREEMAIL_TO(0.00)[linux-foundation.org,vger.kernel.org,fb.com,suse.de,suse.com,google.com,gmail.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On 4/4/24 3:55 AM, Andrew Morton wrote:
> The patch titled
>      Subject: stackdepot: rename pool_index to pool_index_plus_1
> has been added to the -mm mm-unstable branch.  Its filename is
>      stackdepot-rename-pool_index-to-pool_index_plus_1.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-rename-pool_index-to-pool_index_plus_1.patch
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
> From: Peter Collingbourne <pcc@google.com>
> Subject: stackdepot: rename pool_index to pool_index_plus_1
> Date: Mon, 1 Apr 2024 17:14:58 -0700
> 
> Commit 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
> changed the meaning of the pool_index field to mean "the pool index plus
> 1".  This made the code accessing this field less self-documenting, as
> well as causing debuggers such as drgn to not be able to easily remain
> compatible with both old and new kernels, because they typically do that
> by testing for presence of the new field.  Because stackdepot is a
> debugging tool, we should make sure that it is debugger friendly. 
> Therefore, give the field a different name to improve readability as well
> as enabling debugger backwards compatibility.

Can we please move this to mm-hotfixes-unstable otherwise 6.9 would become
an odd release with the new semantics and old name so debuggers wouldnt't
recognize the new semantics there.

> Link: https://lkml.kernel.org/r/20240402001500.53533-1-pcc@google.com
> Link: https://linux-review.googlesource.com/id/Ib3e70c36c1d230dd0a118dc22649b33e768b9f88
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Acked-by: Marco Elver <elver@google.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/stackdepot.h |    7 +++----
>  lib/stackdepot.c           |    4 ++--
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> --- a/include/linux/stackdepot.h~stackdepot-rename-pool_index-to-pool_index_plus_1
> +++ a/include/linux/stackdepot.h
> @@ -44,10 +44,9 @@ typedef u32 depot_stack_handle_t;
>  union handle_parts {
>  	depot_stack_handle_t handle;
>  	struct {
> -		/* pool_index is offset by 1 */
> -		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
> -		u32 offset	: DEPOT_OFFSET_BITS;
> -		u32 extra	: STACK_DEPOT_EXTRA_BITS;
> +		u32 pool_index_plus_1	: DEPOT_POOL_INDEX_BITS;
> +		u32 offset		: DEPOT_OFFSET_BITS;
> +		u32 extra		: STACK_DEPOT_EXTRA_BITS;
>  	};
>  };
>  
> --- a/lib/stackdepot.c~stackdepot-rename-pool_index-to-pool_index_plus_1
> +++ a/lib/stackdepot.c
> @@ -330,7 +330,7 @@ static struct stack_record *depot_pop_fr
>  	stack = current_pool + pool_offset;
>  
>  	/* Pre-initialize handle once. */
> -	stack->handle.pool_index = pool_index + 1;
> +	stack->handle.pool_index_plus_1 = pool_index + 1;
>  	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
>  	stack->handle.extra = 0;
>  	INIT_LIST_HEAD(&stack->hash_list);
> @@ -441,7 +441,7 @@ static struct stack_record *depot_fetch_
>  	const int pools_num_cached = READ_ONCE(pools_num);
>  	union handle_parts parts = { .handle = handle };
>  	void *pool;
> -	u32 pool_index = parts.pool_index - 1;
> +	u32 pool_index = parts.pool_index_plus_1 - 1;
>  	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
>  	struct stack_record *stack;
>  
> _
> 
> Patches currently in -mm which might be from pcc@google.com are
> 
> stackdepot-rename-pool_index-to-pool_index_plus_1.patch
> 

