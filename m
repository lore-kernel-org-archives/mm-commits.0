Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052A12D24A1
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 09:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756977384; cv=none; b=dnFxC8eVO/Hc15kxnaQVVq6id6wnyJNnieLrBXCnXwstanklUoNB7u/Jigo8NEmY8e2rqyvmvK+MkMkpwE9lEpBqGZZIykdWJfoGoZ5EihUgggvgiUBmCAMQe4nRkiaAYz9M40ZOFs6IV+zPs+/ks4YqfAbjYRetLLBdqk+WCOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756977384; c=relaxed/simple;
	bh=kBGur4Dzb0JeqzqfTR6TPUvDnJ2EW70HUXrvK4u/h+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b+HcX1SU45rhUvDhRz36dJBrASSN/tg9hXpKelFm06Z2Edd6TL9tbtKe+KmL+eI2TzURnvcg03tkGj5mVCTiEoOCnFoD30lKlTt7cXqiHaoy6bRFJqZb/qH5dahPKmRpDgaDbQS6LmDTaLZl1qCrX9eh6i2nHcMqxBpRaH7mbvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZgYxGyh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZgYxGyh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756977382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=puXWuW4OtWRBTYi/6jRW0RETR1sh0K4frWOyWHBWukg=;
	b=LZgYxGyhGkmkcxm9R95RGNkjwJgot3/rclSZsiB2BLcXzzhD1mEM78owfVO5pBp3pqMvxk
	7C5KNsTUDEdvV0q5kOouGwL7Z9BP8BLNn1cqQgnd6aJI9kyOSC3F31Q6XeZo5oDXSJWLDF
	S4xC+4J033WTSYBEHtXidfJnBKXqQJc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-ygP-1Ot9Pxu5tM57QBZD1g-1; Thu, 04 Sep 2025 05:16:20 -0400
X-MC-Unique: ygP-1Ot9Pxu5tM57QBZD1g-1
X-Mimecast-MFC-AGG-ID: ygP-1Ot9Pxu5tM57QBZD1g_1756977379
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45cb612d362so4370775e9.3
        for <mm-commits@vger.kernel.org>; Thu, 04 Sep 2025 02:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756977379; x=1757582179;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=puXWuW4OtWRBTYi/6jRW0RETR1sh0K4frWOyWHBWukg=;
        b=IGesMzR1SHsX2E1p51rBlpVTyMZEpa2HkA9c6x49DMj4yR3IkDsiMWYiR+s0KQXJmR
         ITMQ5NNJYZn34QtN3H8MRLkjr672PVjF0PgSVX55APbhCBp6622IBnTNtldLp6ClHndD
         t1/dvx0Xia5neiRLu1QACFj6Ejburnp6L5eIfOYlkxA4v1mYr4NwZG/0evJ7NKivkcOA
         aESzYRD6FptiTbjPXtxR1/yXIqVjczfRtkPpvvLzRWK7lDIhPg/gKbcNKXvRX7OkgSMn
         IWtXV7kRe9grIkk0mhryRODiw/YOXsVX46NmsTnGhLuxDe5zccpYcRiHQ/wry/NRx1sD
         qb4w==
X-Forwarded-Encrypted: i=1; AJvYcCUkVQr+uZ3p9pdXLyKVeYceSft74EZAl436p7hcGKmk2RcL9CJxLhdumrXq74knCBDgVkjhj56cWW3J@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5qwC900y4VsZAjzIlSLNcyALqghuPNoPykp4+ofVOGzcKlOzW
	r6T+SeOiUvXgkGhWkQMfU0Z8w3fiNlgdwsDU8K19lJwA0PgVO3pPJiJvTNaTIsvtrsbRNmuaJWE
	NZdvkLwVB7W/FFXS4Gdjud/HQWJzI1TkYzxU6jlqQher/I1LbRckoVcE2RjA6acY=
X-Gm-Gg: ASbGncvd5d/f23oPvIVCR3YHxXlt9PudNC+ofO2qj8OgrqDgEg3eU2ak/aDVHLtON57
	G2kd16XjMVNAfZcCMwcltkP/hi1FQ4TK1fur8gDUlCF3jO+h1m9oX1yLJDkwap22NK0aXRH99qa
	VSwMLCWyIk1zfN46hUWupisu1z7MHCWSscKkrIC6qj4vlWGsxS00DtKVlhKS98uvQ1egulIV+MD
	/hH0v5/OgR9eLTW3s0VwIeuzE/aQFflsXAhoiWJKEOjhxdYZnCuuE9wMcBT2OGH0aooWdUpuUqF
	4+ZZhFZljAyzeTQVE6LtdigNAFXqqmguBdSV+iIrixXWX6KVLtkOUR40nEVXoR8EeNOSGt9HFHe
	YM00qS6+3+QUyRBSC8SxSbqDqbDgRhNsPLyYabXzhRskeCX90vVJImbVA1P9gYhhX
X-Received: by 2002:a05:600c:5d6:b0:45b:9818:eb7d with SMTP id 5b1f17b1804b1-45b9818efb0mr61464195e9.30.1756977379122;
        Thu, 04 Sep 2025 02:16:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2QvcghdBYLtrUxiQLdHIzMlPIJfjDPyVlLJdeTpvaaSDEN3U6TOMdE8A5NojzbNZwhoWjYA==
X-Received: by 2002:a05:600c:5d6:b0:45b:9818:eb7d with SMTP id 5b1f17b1804b1-45b9818efb0mr61464075e9.30.1756977378684;
        Thu, 04 Sep 2025 02:16:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dcfcb1497sm15429285e9.1.2025.09.04.02.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 02:16:18 -0700 (PDT)
Message-ID: <0967d9a8-2677-4fac-89fa-4c75dc533ecd@redhat.com>
Date: Thu, 4 Sep 2025 11:16:16 +0200
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
To: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 sfr@canb.auug.org.au, rppt@kernel.org, lorenzo.stoakes@oracle.com,
 jcmvbkbc@gmail.com
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
 <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
 <9d209746-5e22-4ae8-a38d-f4988b4f7183@suse.cz>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <9d209746-5e22-4ae8-a38d-f4988b4f7183@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.09.25 09:57, Vlastimil Babka wrote:
> On 9/4/25 08:37, David Hildenbrand wrote:
>> On 04.09.25 04:59, Andrew Morton wrote:
>>>
>>> The patch titled
>>>        Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>        mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
>>>
>>> This patch will shortly appear at
>>>        https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
>>>
>>> This patch will later appear in the mm-unstable branch at
>>>       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>
>>> Before you just go and hit "reply", please:
>>>      a) Consider who else should be cc'ed
>>>      b) Prefer to cc a suitable mailing list as well
>>>      c) Ideally: find the original patch on the mailing list and do a
>>>         reply-to-all to that, adding suitable additional cc's
>>>
>>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>>
>>> The -mm tree is included into linux-next via the mm-everything
>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>> and is updated there every 2-3 working days
>>>
>>> ------------------------------------------------------
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>> Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
>>> Date: Wed Sep  3 07:51:59 PM PDT 2025
>>>
>>> nastily "fix" folio_page()
>>>
>>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>> Cc: Max Filippov <jcmvbkbc@gmail.com>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>
>>>    include/linux/page-flags.h |    4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> --- a/include/linux/page-flags.h~mm-constify-highmem-related-functions-for-improved-const-correctness-fix
>>> +++ a/include/linux/page-flags.h
>>> @@ -316,9 +316,9 @@ static __always_inline unsigned long _co
>>>     * check that the page number lies within @folio; the caller is presumed
>>>     * to have a reference to the page.
>>>     */
>>> -static inline struct page *folio_page(struct folio *folio, unsigned long n)
>>> +static inline struct page *folio_page(const struct folio *folio, unsigned long n)
>>>    {
>>> -	return &folio->page + n;
>>> +	return (struct page *)(&folio->page + n);
>>>    }
>>>    
>>>    static __always_inline int PageTail(const struct page *page)
>>> _
>>>
>>
>>
>> I think we should do the following. And I'm wondering if we should squash that
>> into the relevant nth_page patch instead:
> 
> Sounds good, seems to be working for page_folio().
> 
>>   From 6ada1d36d18969db587ab647757a9538ee1d09a6 Mon Sep 17 00:00:00 2001
>> From: David Hildenbrand <david@redhat.com>
>> Date: Thu, 4 Sep 2025 08:35:24 +0200
>> Subject: [PATCH] fixup folio_page() const correctness
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>    include/linux/page-flags.h | 13 +++++++++----
>>    1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index faf17ca211b4f..3a9e73abea3e3 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -307,6 +307,12 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>>    	const struct page *:	(const struct folio *)_compound_head(p), \
>>    	struct page *:		(struct folio *)_compound_head(p)))
>>    
>> +static inline const struct page *_folio_page(const struct folio *folio,
>> +		unsigned long n)
>> +{
>> +	return &folio->page + n;
> 
> Maybe you can just copy/paste "&(f)->page + (n)" twice directly and not need
> this wrapper? Maybe not even the casts as they would follow from the type of
> f automatically?

Well, then the inline function is gone (which I enjoyed having), and the 
there would not be much sense in having the generic at all?

I mean, sure, the compiler would bail out on any other passed types and 
probably spit out less weird compiler errors compared to a simple macro.

-- 
Cheers

David / dhildenb

