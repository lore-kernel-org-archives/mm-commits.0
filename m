Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B69F15530D
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720516658; cv=none; b=Ckx40mirxmS6VoQxdQU6qzdmaS4y1r9t64pSCS7E9X0NjOJlCKe+MIfIEf/OVwE4x1pBTyhCwqqkkUToP4y+56gCsiRS9uc1j06bczWA/lJprufC0z+8v20CDIUzHnwRWifHJW7/jezsWi97GkITU3DTtgEQIoWiDEvol3myupA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720516658; c=relaxed/simple;
	bh=KTYqipsn9GE/ngFpgDLUVHOnS7zTTtM2rRJP+bc2ltI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UL59sF4+8mX0blDOWdfBbvKCuTamgnZYxqYLWLx59wsV+nIAtO6OAbChP0Od/ZTUY8LDuK1ii6IlHvWn+s04iOx4+00C4F9VCiXw7lXHLLd4KOXTKFZ/bM6iw1wab2gNEOdPKZ7sf13AftiDMVndjlrk0UW8sqT/qf3nrRXRClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nlrBixNu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aGFB4Vxf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=l+vCqymY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+aqZidtJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nlrBixNu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aGFB4Vxf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="l+vCqymY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+aqZidtJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1DAD21F7A6;
	Tue,  9 Jul 2024 09:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1720516654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/kQcGrMR5M6RlPl9mR8R8sbHUz1+nI1rCILgtU+7aSw=;
	b=nlrBixNuBlGpv2kawZ/K4GhH0FdzivJxZGA0bMB/CYfWdEjGY4cemZ2JHWQp/YvLX++Zg/
	lURtloYxjgGDR4tnIW2V4ydkBDfZ/btNoqPLO1wi0kigq1QTGtdBoSzV4mNEcorB7xwdxA
	nzFiDVFqMdk5FD2RuiyQj6Vk+Snlkb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1720516654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/kQcGrMR5M6RlPl9mR8R8sbHUz1+nI1rCILgtU+7aSw=;
	b=aGFB4Vxf9R+EyM1eckR+TY9s6WRE7WLUgfwRx++KG3NB1OYEF3k4KUL8CQYA7/yGU4q0th
	/Fn87huTEtrkYtAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1720516653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/kQcGrMR5M6RlPl9mR8R8sbHUz1+nI1rCILgtU+7aSw=;
	b=l+vCqymYNEaZDvWjWBEdcI945fDLniRtJXJrYQSszb0uGHbvg4wOiIgrEZhJh5w2/AZ6jn
	DVF1oeA0Cs+1v9giZjbMkmGQvpgoUTyNZu5KhA1H4NM2UOJ/CLQflowzuBaIXTXfvhkDD1
	PDX+iqf8fNcFN7OB84ETJqlDeDQPr5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1720516653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/kQcGrMR5M6RlPl9mR8R8sbHUz1+nI1rCILgtU+7aSw=;
	b=+aqZidtJczjN2VInaRLiJLDQ5sFj4DnsaIt1+YCsn9xmltkfJMVCWR4ziX4HKMgfzGeZEk
	o8KfXnoB6dPNQaDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06A7B1396E;
	Tue,  9 Jul 2024 09:17:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LY0SAS0AjWa0NwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 09 Jul 2024 09:17:33 +0000
Message-ID: <d1c603d0-6d6b-42c4-a690-a6647131998b@suse.cz>
Date: Tue, 9 Jul 2024 11:17:32 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
Content-Language: en-US
To: Alex Shi <seakeel@gmail.com>, Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 pasha.tatashin@soleen.com, keescook@chromium.org, hannes@cmpxchg.org,
 alexs@kernel.org
References: <20240708214255.9F454C116B1@smtp.kernel.org>
 <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
 <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com>
 <CAJuCfpFqVf=-e0b1ZbdY+7y5uuA7P267Z8AQ22wj7pRBMFSdYg@mail.gmail.com>
 <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,google.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,cmpxchg.org:email,imap1.dmz-prg2.suse.org:helo,linux-foundation.org:email,chromium.org:email,soleen.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 7/9/24 10:19 AM, Alex Shi wrote:
> 
> 
> On 7/9/24 12:34 PM, Suren Baghdasaryan wrote:
>> On Tue, Jul 9, 2024 at 1:53 AM Alex Shi <seakeel@gmail.com> wrote:
>>>
>>>
>>>
>>> On 7/9/24 9:14 AM, Suren Baghdasaryan wrote:
>>>> On Mon, Jul 8, 2024 at 2:42 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>>
>>>>>
>>>>> The patch titled
>>>>>      Subject: mm/memcg: alignment memcg_data define condition
>>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>>      mm-memcg-alignment-memcg_data-define-condition.patch
>>>>
>>>> FYI, just posted my objection to this change at
>>>> https://lore.kernel.org/all/CAJuCfpEjB8wvodBDB__yR8pF5F3uGMPxue-tap68RYCO0O-K1Q@mail.gmail.com/
>>>> It will break CONFIG_MEM_ALLOC_PROFILING=y && CONFIG_MEMCG=n case.
>>>
>>> Hi Suren,
>>>
>>> Thanks a lot for point out the problem!
>>> Now I understand why we put page/folio.memcg_data under CONFIG_SLAB_OBJ_EXT.
>>> We need the memcg_data member only for SLAB_MATCH(memcg_data, obj_exts), even
>>> no CONFIG_MEMCG, isn't it?
>>>
>>> So for the config logical and SLAB_MATCH needs, could we keep this patch
>>> with a fix like the following? The match only checked with both configs
>>> enabled.
>> 
>> No. The point of that check is to enforce that slab.obj_exts always
>> matches page.memcg_data / folio.memcg_data (enforcing the same layout
>> for slab, page and folio structs). Consider your original change when
>> CONFIG_MEM_ALLOC_PROFILING=y && CONFIG_MEMCG=n. slab.obj_exts exists
>> but page.memcg_data does not, so layouts of these structs do not
>> match. By adding the change you are suggesting below you simply avoid
>> the check that warns you about this mismatch. So, you are not fixing
>> the problem, just removing the safety checks that would correctly
>> complain about it.
>> 
> 
> Hi Suren,
> 
> Thanks for reply!
> But what's the point of 2 members match each other in different struct?
> Is there any problem w/o the match checking on CONFIG_MEM_ALLOC_PROFILING=y
> && CONFIG_MEMCG=n?
> 
> No, the kernel works well under my test with MEM_ALLOC_PROFILING/MEMCG/KASAN
> random combined. 

I'm guessing it works only by luck thanks to _struct_page_alignment. Once
you keep obj_exts in struct slab, but remove memcg_data in struct
page/folio, it could (on 64bit) result in struct page/folio being 56 bytes,
and struct slab being 64 bytes, and then this will fail:

static_assert(sizeof(struct slab) <= sizeof(struct page));

_struct_page_alignment might fix it up silently, but only with
CONFIG_HAVE_ALIGNED_STRUCT_PAGE.

We could maybe make it more obvious like this? for page/folio

#ifdef CONFIG_MEMCG
	unsigned long memcg_data;
#elif defined(CONFIG_SLAB_OBJ_EXT)
	unsigned long _unused_slab_obj_ext;
#endif

And adjusting SLAB_MATCH() assertions accordingly. As a result it will stop
exposing the unused memcg_data field in page/folio with !CONFIG_MEMCG &&
CONFIG_MEM_ALLOC_PROFILING.

Or maybe CONFIG_MEM_ALLOC_PROFILING could reuse the field in that !MEMCG
case instead of needing a page_ext? (or was that the plan already?)

Vlastimil

> As Willy's purpose, the page struct will be replaced by "unsigned long mem_desc;"
> https://lore.kernel.org/lkml/YvV1KTyzZ+Jrtj9x@casper.infradead.org/
> With this destination, slab, folio, page struct better be used differently
> and not to relay on each other.
> 
> In fact there is another solution work conventionally for logical match:
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index ef09c4eef6d3..8f9a01a24f18 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -180,7 +180,7 @@ struct page {
>         /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
>         atomic_t _refcount;
>  
> -#ifdef CONFIG_SLAB_OBJ_EXT
> +#if defined(CONFIG_SLAB_OBJ_EXT) || defined(CONIFG_MEMCG)
>         unsigned long memcg_data;
>  #endif
>  
> @@ -343,7 +343,7 @@ struct folio {
>                         };
>                         atomic_t _mapcount;
>                         atomic_t _refcount;
> -#ifdef CONFIG_SLAB_OBJ_EXT
> +#if defined(CONFIG_SLAB_OBJ_EXT) || defined(CONIFG_MEMCG)
>                         unsigned long memcg_data;
>  #endif
>  #if defined(WANT_PAGE_VIRTUAL)
> 
> But compere above convention solution, the current way is simple and closer
> to our destination, and we could easy fall back even it fails, isn't it?
> 
> Thanks
> Alex
> 
>>>
>>> Thanks a lot!
>>> Alex
>>>
>>> diff --git a/mm/slab.h b/mm/slab.h
>>> index 3586e6183224..9e7ccaf868e2 100644
>>> --- a/mm/slab.h
>>> +++ b/mm/slab.h
>>> @@ -97,7 +97,7 @@ struct slab {
>>>  SLAB_MATCH(flags, __page_flags);
>>>  SLAB_MATCH(compound_head, slab_cache); /* Ensure bit 0 is clear */
>>>  SLAB_MATCH(_refcount, __page_refcount);
>>> -#ifdef CONFIG_SLAB_OBJ_EXT
>>> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_MEMCG)
>>>  SLAB_MATCH(memcg_data, obj_exts);
>>>  #endif
>>>  #undef SLAB_MATCH
>>>>
>>>>>
>>>>> This patch will shortly appear at
>>>>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-alignment-memcg_data-define-condition.patch
>>>>>
>>>>> This patch will later appear in the mm-unstable branch at
>>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>>
>>>>> Before you just go and hit "reply", please:
>>>>>    a) Consider who else should be cc'ed
>>>>>    b) Prefer to cc a suitable mailing list as well
>>>>>    c) Ideally: find the original patch on the mailing list and do a
>>>>>       reply-to-all to that, adding suitable additional cc's
>>>>>
>>>>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>>>>
>>>>> The -mm tree is included into linux-next via the mm-everything
>>>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>> and is updated there every 2-3 working days
>>>>>
>>>>> ------------------------------------------------------
>>>>> From: "Alex Shi (Tencent)" <alexs@kernel.org>
>>>>> Subject: mm/memcg: alignment memcg_data define condition
>>>>> Date: Mon, 8 Jul 2024 14:32:36 +0800
>>>>>
>>>>> commit 21c690a349ba ("mm: introduce slabobj_ext to support slab object
>>>>> extensions") changed the folio/page->memcg_data define condition from
>>>>> MEMCG to SLAB_OBJ_EXT.  The code works well, since config SLAB_OBJ_EXT is
>>>>> fold into MEMCG in init/Kconfig.
>>>>>
>>>>> But many related functions that deal with memcg_data still defined under
>>>>> MEMCG instead of SLAB_OBJ_EXT, and FOLIO_MATCH with memcg_data are defined
>>>>> under MEMCG too.  That looks weird and incorrect with memcg_data raw
>>>>> meaning.
>>>>>
>>>>> So let's put memcg_data under MEMCG config to alignment the definition
>>>>> with FOLIO_MATCH and its usage in functions.
>>>>>
>>>>> Link: https://lkml.kernel.org/r/20240708063236.1096395-1-alexs@kernel.org
>>>>> Signed-off-by: Alex Shi (Tencent) <alexs@kernel.org>
>>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>>> Cc: Kees Cook <keescook@chromium.org>
>>>>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
>>>>> Cc: Suren Baghdasaryan <surenb@google.com>
>>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>>> ---
>>>>>
>>>>>  include/linux/mm_types.h |    4 ++--
>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> --- a/include/linux/mm_types.h~mm-memcg-alignment-memcg_data-define-condition
>>>>> +++ a/include/linux/mm_types.h
>>>>> @@ -180,7 +180,7 @@ struct page {
>>>>>         /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
>>>>>         atomic_t _refcount;
>>>>>
>>>>> -#ifdef CONFIG_SLAB_OBJ_EXT
>>>>> +#ifdef CONFIG_MEMCG
>>>>>         unsigned long memcg_data;
>>>>>  #endif
>>>>>
>>>>> @@ -343,7 +343,7 @@ struct folio {
>>>>>                         };
>>>>>                         atomic_t _mapcount;
>>>>>                         atomic_t _refcount;
>>>>> -#ifdef CONFIG_SLAB_OBJ_EXT
>>>>> +#ifdef CONFIG_MEMCG
>>>>>                         unsigned long memcg_data;
>>>>>  #endif
>>>>>  #if defined(WANT_PAGE_VIRTUAL)
>>>>> _
>>>>>
>>>>> Patches currently in -mm which might be from alexs@kernel.org are
>>>>>
>>>>> mm-memcg-alignment-memcg_data-define-condition.patch
>>>>>

