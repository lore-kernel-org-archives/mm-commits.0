Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6040146016
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 09:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720516275; cv=none; b=Oij2G/I/dF19DN+YN5BLGkxSirX6nDBeju9Kc07yXiZ2YL5/QIVLwSVNr62kGxguxTXI3trrSf3aZFJHAg7JnZZA7j9cqijnITPHLFY/AQXrhziloYGsCJWAXysj9b50JQaEryOM5KeOEgTaDEYpRQeIWrgfldYaWpeBRYiJATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720516275; c=relaxed/simple;
	bh=tiozuPh/Jny+av339u6qg14li4muj3cIspYZar+byq8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NVsMLJp1EEqSRg3bBzIBpXJMeTHpRviz0LZl1rOND1Sf5RI4e6ZbpwujY3V5u8ybwbzvPXWr82k756v00YRPsoykzMYhsEL9ETLAZPb7lOrUXOWRF8JnCANBryLzib31eEP98fv0jlU9heQqHkb0fmlDsA7Etlxv/FomZy1pw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l2gtW+Rr; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2gtW+Rr"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fb457b53c8so30943755ad.0
        for <mm-commits@vger.kernel.org>; Tue, 09 Jul 2024 02:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720516273; x=1721121073; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ErBk7ICYDqJSt6bHwSCVCEnaxk0sWUmv+dLeFvgj4Yg=;
        b=l2gtW+RrnNNqC5aOyFYnzmZabMY8iF5skvEJQ3zct1dDa/a80siHVEbJWEYMV4lLAU
         lVYmzKy45ANaFuwnsSy5Z9hIdaOke6z+rbkTRlDPFO5ED+rWXrjm2gsJadngiFl27eer
         t5F/Udp7NbYcqxCmOEAeRv5WJMYaA0tD9w6KvjM+EqkPkiPEFRffToW+mGJ6sBjqWW5+
         acRN1/GMDMOr4k4siDMeO/zIVVXwqs2eaqDYt6TLKUwkMl8Q2qdqYnXoPyCKmz0o+cVS
         IxGXF08KMCTt910uaqRM9nDpHpR/bcDJPr4rKIgNI2wwKDoiuJpvlgSVkEXXrXeMXnI4
         Madg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720516273; x=1721121073;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ErBk7ICYDqJSt6bHwSCVCEnaxk0sWUmv+dLeFvgj4Yg=;
        b=KhOlm4WgB9mZaSVLicjEgNVlMP9VupzRgoKL5mDxaQ7r7VIWPDgOzxcUmGXqTnTzBe
         7yDMLe7rUGo5+H8CkwdmV+hCUUgQ+AorpEF9CUh9TDfMwO6oHEFN4tlqoWoNweb/mP84
         NSuOcjaG1YvQtS3ZWI69u31hXJ8vUWBUv7+lV+TR4dF3tW2LdgB8S07tZBY8ywV+uKWb
         AiNxLKoSXqjQ9SDnHuCTlS9zoo3FI1boq4R6mHAPJSnBJobZpVKN8cbmDaOWHGO6rh4f
         e6mU3y3nKboRuBYk0HYOhvf2Vugu5WOoq/SmqhNKxTMQoGy3Q4tQ9kun4+iZQqoiZ521
         ykEw==
X-Forwarded-Encrypted: i=1; AJvYcCVZ4dcvCya9TL/KKBWWceHyOnJIaoCctwLcnYe/efU4E4ez/I2bS6rS9n3zJt42p2bHE06KsB+TmPk2WDiXlkprgn7a530Gu5MH8A==
X-Gm-Message-State: AOJu0YyNazkQl25oa00uqOXDaonLn5aiQiG5DBvnzHSN8JkWrjCj8HdB
	jo1jOk80MH2ln/yiMx8ViRbwdsHCoYXt4nAdy24LHl6eTOskH0Hm
X-Google-Smtp-Source: AGHT+IF1+LLxY+7xJcrEiACbGZHThQ1Qpas1vE8xp5rWHGNAZVvso0R/9RF850rHwx9MTOFiyJtvwg==
X-Received: by 2002:a17:902:da90:b0:1f4:b43f:9c01 with SMTP id d9443c01a7336-1fbb6f0b529mr15445915ad.64.1720516272602;
        Tue, 09 Jul 2024 02:11:12 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a292a4sm11517645ad.66.2024.07.09.02.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 02:11:11 -0700 (PDT)
Message-ID: <135c3a9a-d453-4b9e-ae6b-c6b331072363@gmail.com>
Date: Tue, 9 Jul 2024 17:11:07 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
From: Alex Shi <seakeel@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 vbabka@suse.cz, pasha.tatashin@soleen.com, keescook@chromium.org,
 hannes@cmpxchg.org, alexs@kernel.org
References: <20240708214255.9F454C116B1@smtp.kernel.org>
 <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
 <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com>
 <CAJuCfpFqVf=-e0b1ZbdY+7y5uuA7P267Z8AQ22wj7pRBMFSdYg@mail.gmail.com>
 <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com>
Content-Language: en-US
In-Reply-To: <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/9/24 4:19 PM, Alex Shi wrote:
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
> 
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

with above change, could we remove SLAB_OBJ_EXT from MEMCG?
They seems no relationship except the SLAB_MATCH?

diff --git a/init/Kconfig b/init/Kconfig
index 26bf8bb0a7ce..61e43ac9fe75 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -965,7 +965,6 @@ config MEMCG
        bool "Memory controller"
        select PAGE_COUNTER
        select EVENTFD
-       select SLAB_OBJ_EXT
        help
          Provides control over the memory footprint of tasks in a cgroup.
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
