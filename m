Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934822EB87B
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 09:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979325; cv=none; b=epgl2v06v+f4glRlk2dmf2c7pn+WJvnWSIR2ySWuz6gdRcaFdtRwhWlqNir1fXllQS7ENCLKIwyeI9cvaMmvkWwrPsJSA0qB8J3YQD8ogqJtD5SmOefD/i7sNP+ShKc+0E/DUjeYdXh3Yn+osPT5BczQltsayHADV5BlzG593TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979325; c=relaxed/simple;
	bh=6Mr9hdldTjd9ppc+FvQ3FbcPHJ+RkwnRmLzc8zCRkGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EkEEeZDW0lJCNXJ9TB75IehIxWrUGFZLN8WgqMu0Fy/ntk7MG325gn8kzTf0DYg0+m3v1vADZltwrg/AdoS8ROI48CfTZpzoUnPKlkQzbZFNuCNsPKflDcTLYKM3UuZD0TtIhA118PpAu6GRlTRb4dhgi4wqopyi7QrmP/BDx4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wIsgyxGI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7LObXtUW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wIsgyxGI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7LObXtUW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wIsgyxGI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7LObXtUW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wIsgyxGI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7LObXtUW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B42D23429C;
	Thu,  4 Sep 2025 09:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756979321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iCWTxPmGXDZZs+nXHJbiPcPZbuEcHy2vsnJ+f+uJIVQ=;
	b=wIsgyxGIb99SNvBYwuBtyjPD5seIj7L/Ss1ueh5fsGm6LnAne8B8LBvVPU8WwiOSLK3EpL
	4xcrP8uxDwYt3eDCBjnSj8ZUGHq5dckxkvcQv5G0ImV3ZxK8CgFsuuk/wAya/+Uf5EDedd
	6UvF9FghYlZRmoLCbrMV4Tw505ak9gI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756979321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iCWTxPmGXDZZs+nXHJbiPcPZbuEcHy2vsnJ+f+uJIVQ=;
	b=7LObXtUWCY5R+u/MgBc6I7MrvlybM4KpIUBruXmM4HxKYvMmkVm5R9MK0odlyCafHD9A3Z
	Sb4gXfyteiiKb1Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756979321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iCWTxPmGXDZZs+nXHJbiPcPZbuEcHy2vsnJ+f+uJIVQ=;
	b=wIsgyxGIb99SNvBYwuBtyjPD5seIj7L/Ss1ueh5fsGm6LnAne8B8LBvVPU8WwiOSLK3EpL
	4xcrP8uxDwYt3eDCBjnSj8ZUGHq5dckxkvcQv5G0ImV3ZxK8CgFsuuk/wAya/+Uf5EDedd
	6UvF9FghYlZRmoLCbrMV4Tw505ak9gI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756979321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iCWTxPmGXDZZs+nXHJbiPcPZbuEcHy2vsnJ+f+uJIVQ=;
	b=7LObXtUWCY5R+u/MgBc6I7MrvlybM4KpIUBruXmM4HxKYvMmkVm5R9MK0odlyCafHD9A3Z
	Sb4gXfyteiiKb1Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A193B13AA0;
	Thu,  4 Sep 2025 09:48:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ldccJ3lguWgdIgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 04 Sep 2025 09:48:41 +0000
Message-ID: <06e88701-9660-49c3-b9df-934e94812773@suse.cz>
Date: Thu, 4 Sep 2025 11:48:41 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
 added to mm-unstable branch
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 sfr@canb.auug.org.au, rppt@kernel.org, lorenzo.stoakes@oracle.com,
 jcmvbkbc@gmail.com, Matthew Wilcox <willy@infradead.org>
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
 <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
 <9d209746-5e22-4ae8-a38d-f4988b4f7183@suse.cz>
 <0967d9a8-2677-4fac-89fa-4c75dc533ecd@redhat.com>
 <d45f0608-3ca4-44ef-950b-07b0388db639@suse.cz>
 <83819219-c972-4e4f-b343-d2b3cbe5f4d2@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <83819219-c972-4e4f-b343-d2b3cbe5f4d2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,linux-foundation.org,vger.kernel.org,canb.auug.org.au,kernel.org,oracle.com,gmail.com,infradead.org];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 9/4/25 11:40, David Hildenbrand wrote:
> On 04.09.25 11:28, Vlastimil Babka wrote:
>> On 9/4/25 11:16, David Hildenbrand wrote:
>>> On 04.09.25 09:57, Vlastimil Babka wrote:
>>>> On 9/4/25 08:37, David Hildenbrand wrote:
>>>>> On 04.09.25 04:59, Andrew Morton wrote:
>> I thought the benefit of the generic is if you pass const folio you get
>> const page, and if you pass non-const you get non-stop, and it doesn't
>> involve any cast of something already assumed const to non-const which I
>> assume is bad (TM). But I don't know how much bad in practice (can it lead
>> to optimizations screwing with your code?).
>> 
>> With the inline function in place there's such a cast const -> non-const on
>> the page pointer it returns, but maybe it's fine because it only happens
>> when the original folio was non-const? I don't know. It just doesn't seem to
>> add benefits when only used via the generic?
> 
> Well, take a look at page_folio(), I really just mimic what they do.

Yeah, but that one is different due to _compound_head() returning unsigned long.

> I think the point is that with generics you can control that where you 
> cast the const of is sane.
> 
> In Andrew's patch you just cast the const away unconditionally, which is 
> rather nasty.

Yup I'm in favor of your approach.

> With generic you could write two functions _folio_page_non_const() + 
> _folio_page_const(), but that's just stupid.
> 
> A plain
> 
> 	#define folio_page(f, n) (&(f)->page + (n))	
> 
> Would also make the compiler respect the const'ness of f, because 
> "->page" is not a pointer.

Hm that's true. The generic then only adds some type restrictions.

> Now, of course that would change once ->page becomes a pointer (memdescs 
> ...)

Right. I'm not opposed to your patch, just thought it could be smaller, but
not insisting. Do you want anyone to use _folio_page() directly? If not
maybe add a comment that it's internal and only folio_page() should be used,
to help avoid accidental misuse?

I've also Cc'd willy on my previosus reply in case he has opinions.

