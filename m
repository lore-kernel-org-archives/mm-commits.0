Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAE0286A6
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 01:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720490024; cv=none; b=kibocp0+WC+9PCJMXDRBQ0WHZ6FrVM43SXokl+5qKlCjUtP+HniTK/a95AzbLpcMt9gjQ9M7epFcs7CBrYMKk7AweQ3t2Qoy/fdJbkeMV+2Skqg77hOCqzMr8JQR27RHKvV8Jrw8Dx7m1k3JGxzxGZKC9u5fZwzBNMfW7ax6EZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720490024; c=relaxed/simple;
	bh=5N8v+17M8TK2YRuQ/+91eNwAM4zrwMhWTFQpv5qv0+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=poZfEFxLEbmC/6luOZ3MtNGbZA++1iF+hbk5IQw+wHfbLYzbmG4W1DFQEOUvRJSHWlAIUyhsbcRl1ta/ldWQBkalMdgbyG3sTPalZsAISxXacno6mJ6ujn/0V/38rPa1ifElyTLO1VjRWXJtcNXIa7R5jMFbRSziBpM05X8Lf+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eo1MKVhs; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eo1MKVhs"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-75c3acf90f0so2436519a12.2
        for <mm-commits@vger.kernel.org>; Mon, 08 Jul 2024 18:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720490023; x=1721094823; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Uk8AKagpROu8zx2vqvVyEHMV75jmM/f+tkRCgv2328=;
        b=Eo1MKVhsSxZTLo6bAzlsR8Yl91/4bACH8l74bhhM8gijK0WHR7rm/wvifFtLbTb1iQ
         3kCnMEApEW72iALmVIB1kjNs9ff4ppQiStY7AeWJKfv6EuHnvjKD4rqB8APQbR+ypwLd
         G8f10G/q6NAfWB1LP1qpsZtOse+p7KqOe+oCkqzr1tNVK+dw4cPMILGWpKKMGmdqbvaQ
         7P5sJz/XYDYh8uAR7BKAc1iH3BsxJB8qqXQO5xPSgBj4GAqaxqiUT48WAxeWTqj/rQaG
         IYlKp/8cLY4S6umIPFeTZEyNUQ7HfJtbPOLVb7k/K2nbMA3YN1ePqqcxJD+nXOqIUsQ1
         l0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720490023; x=1721094823;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Uk8AKagpROu8zx2vqvVyEHMV75jmM/f+tkRCgv2328=;
        b=s9weXHsEBiLrAN7jwd2O4S3mg8NFnrZq+igLfxV0JW+pVn4/MMOs/Nse5qBjZ+V4/0
         2MB1YAVdhDnie03OE3MmWm0Ixf/dy0J6p167hoAv8ilcOuGELUoZzUrHwXo0ZB8e5yGw
         bcY0xlzBzKpttqUdoj82oMLey6poPAz6yYu30+/nC+8hlKZ4X0u4/datwGX695N0Wh03
         JHBilIk/7wg/5aIyWICEnfFZUBSeVplvhJLpaEPINHTml/CbeClFw1Tt0qxnBav9uPU/
         GRsf+KvalQeckLVQ1Etg7C7vTL5Z1XR9xSzmoFLuAQeyuMZiZ0UaPE3yK0UOBOLlYeQ8
         DeqQ==
X-Gm-Message-State: AOJu0Yzrb08j0r/sV0JuNQtMbyNxKdOhzq/HMRIEZ/1t2/t8dru8xGiq
	aDrVvU7RE+7VTVdhzD6925YGXAeyMY6AVwtHJQVZ1GYyQy8e5PMR
X-Google-Smtp-Source: AGHT+IFTqsdbanLVAvQGNcdiqz97vQIKV7UhH6t5LPiWJA+jl6h8lLFY4VAfv/idDN7H069OsZJSUQ==
X-Received: by 2002:a05:6a20:2452:b0:1be:cd00:8242 with SMTP id adf61e73a8af0-1c2984e35a9mr1295024637.52.1720490022577;
        Mon, 08 Jul 2024 18:53:42 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c99a97e8a5sm8918877a91.27.2024.07.08.18.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jul 2024 18:53:41 -0700 (PDT)
Message-ID: <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com>
Date: Tue, 9 Jul 2024 09:53:37 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
To: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, pasha.tatashin@soleen.com,
 keescook@chromium.org, hannes@cmpxchg.org, alexs@kernel.org
References: <20240708214255.9F454C116B1@smtp.kernel.org>
 <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/9/24 9:14 AM, Suren Baghdasaryan wrote:
> On Mon, Jul 8, 2024 at 2:42 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>
>> The patch titled
>>      Subject: mm/memcg: alignment memcg_data define condition
>> has been added to the -mm mm-unstable branch.  Its filename is
>>      mm-memcg-alignment-memcg_data-define-condition.patch
> 
> FYI, just posted my objection to this change at
> https://lore.kernel.org/all/CAJuCfpEjB8wvodBDB__yR8pF5F3uGMPxue-tap68RYCO0O-K1Q@mail.gmail.com/
> It will break CONFIG_MEM_ALLOC_PROFILING=y && CONFIG_MEMCG=n case.

Hi Suren,

Thanks a lot for point out the problem!
Now I understand why we put page/folio.memcg_data under CONFIG_SLAB_OBJ_EXT.
We need the memcg_data member only for SLAB_MATCH(memcg_data, obj_exts), even
no CONFIG_MEMCG, isn't it?

So for the config logical and SLAB_MATCH needs, could we keep this patch
with a fix like the following? The match only checked with both configs
enabled.

Thanks a lot!
Alex

diff --git a/mm/slab.h b/mm/slab.h
index 3586e6183224..9e7ccaf868e2 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -97,7 +97,7 @@ struct slab {
 SLAB_MATCH(flags, __page_flags);
 SLAB_MATCH(compound_head, slab_cache); /* Ensure bit 0 is clear */
 SLAB_MATCH(_refcount, __page_refcount);
-#ifdef CONFIG_SLAB_OBJ_EXT
+#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_MEMCG)
 SLAB_MATCH(memcg_data, obj_exts);
 #endif
 #undef SLAB_MATCH
> 
>>
>> This patch will shortly appear at
>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-alignment-memcg_data-define-condition.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: "Alex Shi (Tencent)" <alexs@kernel.org>
>> Subject: mm/memcg: alignment memcg_data define condition
>> Date: Mon, 8 Jul 2024 14:32:36 +0800
>>
>> commit 21c690a349ba ("mm: introduce slabobj_ext to support slab object
>> extensions") changed the folio/page->memcg_data define condition from
>> MEMCG to SLAB_OBJ_EXT.  The code works well, since config SLAB_OBJ_EXT is
>> fold into MEMCG in init/Kconfig.
>>
>> But many related functions that deal with memcg_data still defined under
>> MEMCG instead of SLAB_OBJ_EXT, and FOLIO_MATCH with memcg_data are defined
>> under MEMCG too.  That looks weird and incorrect with memcg_data raw
>> meaning.
>>
>> So let's put memcg_data under MEMCG config to alignment the definition
>> with FOLIO_MATCH and its usage in functions.
>>
>> Link: https://lkml.kernel.org/r/20240708063236.1096395-1-alexs@kernel.org
>> Signed-off-by: Alex Shi (Tencent) <alexs@kernel.org>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  include/linux/mm_types.h |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- a/include/linux/mm_types.h~mm-memcg-alignment-memcg_data-define-condition
>> +++ a/include/linux/mm_types.h
>> @@ -180,7 +180,7 @@ struct page {
>>         /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
>>         atomic_t _refcount;
>>
>> -#ifdef CONFIG_SLAB_OBJ_EXT
>> +#ifdef CONFIG_MEMCG
>>         unsigned long memcg_data;
>>  #endif
>>
>> @@ -343,7 +343,7 @@ struct folio {
>>                         };
>>                         atomic_t _mapcount;
>>                         atomic_t _refcount;
>> -#ifdef CONFIG_SLAB_OBJ_EXT
>> +#ifdef CONFIG_MEMCG
>>                         unsigned long memcg_data;
>>  #endif
>>  #if defined(WANT_PAGE_VIRTUAL)
>> _
>>
>> Patches currently in -mm which might be from alexs@kernel.org are
>>
>> mm-memcg-alignment-memcg_data-define-condition.patch
>>
