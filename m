Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66F226B2CE
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 09:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978844; cv=none; b=XTBM/iFrDKotuLYV617fxDI1BclcI5BRgtNmu+iAByRv1Vrs+6KItP+SjIb+CwP2oAAiG/fwowifXF2ZI74VlK0WhnuGlYrlDamQMr8ZEd/L082HO0qUR30rEDg7VfA+Poz5sC3PVyJt7GXDd1zrjT/6x8BujrToCY4rwDLY5VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978844; c=relaxed/simple;
	bh=slbGazSHYGKcf420nfu6gB7vj6oJ5kIePDbGGc4k//s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rEtH6ELstTf0a/3tHSr+UIPDkXtsTFEGo9myNm5mhANZD7erTAclbpKEwWIvjPepIT81/Qooq3uR2vbFUVUB1rkN57CTPG2lwt6buID9P1dfY+trU6JhVEtxzPo1N5JeH4L2iOn7xqDB//yp4HA6rTBLz4zUKCXdPdN98A3iUwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VmGUOeAr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VmGUOeAr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756978841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kWJivqXLCAcaVG9tXe91+NtVzU8S02wfSwlj9fG1Rcc=;
	b=VmGUOeArIa4fuN01eNih25hkL8scdC4iqYuC9zBbeQOxMFZ60SgW7TzGGvZ5BLlNLLlWBj
	ogFv0Kdrbtrw7MY03hJxBZLd7yxBT+iXD6822vGCyD+v/XpO0uDi0bHDI0eTXislTH1kXE
	E20BrJrmpuu0o7YYGp1KhaU7YuAvS34=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-WXE4ttiFOfuiBPNu48GjAg-1; Thu, 04 Sep 2025 05:40:40 -0400
X-MC-Unique: WXE4ttiFOfuiBPNu48GjAg-1
X-Mimecast-MFC-AGG-ID: WXE4ttiFOfuiBPNu48GjAg_1756978837
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8af0b8deso4370435e9.0
        for <mm-commits@vger.kernel.org>; Thu, 04 Sep 2025 02:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756978837; x=1757583637;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kWJivqXLCAcaVG9tXe91+NtVzU8S02wfSwlj9fG1Rcc=;
        b=BzW7xm+az82xGOmHB3W/LLuBhztNx84eZWSSVjTGzvw+UwFX7TgE0Vsfk1zk/7XVv2
         MkK+Bcr8QWou05BbC6LxdqLAnR79F3c3wMXWQGrGmaQqNG2VxtrHd3MboeLAkZ6bejKI
         hsG1c4ZZpiHU85DVjf/hrnsh54pTqygCGc/uUaVn2M5itJjmdrM4Y1GVrc/bjFsyTOMm
         XDsDOFHxfnbsnZoEkCSGI1jAoo43m/3aEXBNR076fVuHbuG/XxxN5kI645s/2n2XYgHb
         ESvzw7TKd+wfj03jNSa4FpXcm7mSW0T9LCO6o8RtDSLXzYc2qB3v61coRGTbpP3IUIBp
         +nCw==
X-Forwarded-Encrypted: i=1; AJvYcCWIYG2RnGInU6t0jlQ3a4sNvhx23XfEW5vr7qedKRrBGtAY8h2SI8rqgfP4FIDouofHIqK7RIrWraG5@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4S7nKNcJwexzLdzUtAfpqEyVSA4UOazvfP2ASLcRATp9MfzLP
	fswQllR3Awapyxt/YW9lINNAEMZxQwSB91JXPzspcBVSmxqsOs1seyL6S0HMFw98ygWAkKB0YyO
	3cj2oYzqA9t+/sRO/hdMYIKFJJcVb8QE0LTL5W75voheq6EX90PAIwv7sYAdjaFc=
X-Gm-Gg: ASbGnctP2mCZfdd7RNKcmM5W6rPUwouz50jLHX/zvK4u5BMPZFCa1CfWuw1j5cPsFq1
	o2oF2GdqB+2uKcCPbdjXINUZ/AzmvZGzp3oB+c9BUvpwEp5IZh1miqS5+Mmm9B9HgRqVEj/XhGc
	it+AQGuCFTdOJb8KAkoQN+QBIzxStvrwOmUjqRfY/J0KBysP6gvom0cdd8rcjwu/z6cnxj66d3h
	HQMteaXho41bY7X3I7HjNxEyTY/qDaB9GXY2KDKrlKYl/q5PZB1dHxuKqHThqI2k0wwPUJzSxnN
	lO61cUPMZemx14SanGGtxq/Sfy5TDMn/BUeX6QCbnpz1Ph84i0r6zsG8k8pbuZORW0h1Z7NyZG1
	6PK1OZWmHxK0LQX+mun4syGMm9IzfF+I5uAmDXTbLLE7te+5E9/+kVKjc4grct0mA
X-Received: by 2002:a05:600c:a04:b0:45b:8504:3002 with SMTP id 5b1f17b1804b1-45b8554eb18mr162948795e9.10.1756978836688;
        Thu, 04 Sep 2025 02:40:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEspqrKjZLwlPMcgzuiizKoPNtpdNXsoHO2KueTcnGvveifxn/F/nNhN/5jgK2SdyU7MgKEyA==
X-Received: by 2002:a05:600c:a04:b0:45b:8504:3002 with SMTP id 5b1f17b1804b1-45b8554eb18mr162948475e9.10.1756978836174;
        Thu, 04 Sep 2025 02:40:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b93fae643sm123802295e9.3.2025.09.04.02.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 02:40:35 -0700 (PDT)
Message-ID: <83819219-c972-4e4f-b343-d2b3cbe5f4d2@redhat.com>
Date: Thu, 4 Sep 2025 11:40:34 +0200
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
 jcmvbkbc@gmail.com, Matthew Wilcox <willy@infradead.org>
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
 <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
 <9d209746-5e22-4ae8-a38d-f4988b4f7183@suse.cz>
 <0967d9a8-2677-4fac-89fa-4c75dc533ecd@redhat.com>
 <d45f0608-3ca4-44ef-950b-07b0388db639@suse.cz>
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
In-Reply-To: <d45f0608-3ca4-44ef-950b-07b0388db639@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.09.25 11:28, Vlastimil Babka wrote:
> On 9/4/25 11:16, David Hildenbrand wrote:
>> On 04.09.25 09:57, Vlastimil Babka wrote:
>>> On 9/4/25 08:37, David Hildenbrand wrote:
>>>> On 04.09.25 04:59, Andrew Morton wrote:
>>>>>
>>>>> The patch titled
>>>>>         Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
>>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>>         mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
>>>>>
>>>>> This patch will shortly appear at
>>>>>         https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
>>>>>
>>>>> This patch will later appear in the mm-unstable branch at
>>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>>
>>>>> Before you just go and hit "reply", please:
>>>>>       a) Consider who else should be cc'ed
>>>>>       b) Prefer to cc a suitable mailing list as well
>>>>>       c) Ideally: find the original patch on the mailing list and do a
>>>>>          reply-to-all to that, adding suitable additional cc's
>>>>>
>>>>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>>>>
>>>>> The -mm tree is included into linux-next via the mm-everything
>>>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>> and is updated there every 2-3 working days
>>>>>
>>>>> ------------------------------------------------------
>>>>> From: Andrew Morton <akpm@linux-foundation.org>
>>>>> Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
>>>>> Date: Wed Sep  3 07:51:59 PM PDT 2025
>>>>>
>>>>> nastily "fix" folio_page()
>>>>>
>>>>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>>>> Cc: Max Filippov <jcmvbkbc@gmail.com>
>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>>> Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>>> ---
>>>>>
>>>>>     include/linux/page-flags.h |    4 ++--
>>>>>     1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> --- a/include/linux/page-flags.h~mm-constify-highmem-related-functions-for-improved-const-correctness-fix
>>>>> +++ a/include/linux/page-flags.h
>>>>> @@ -316,9 +316,9 @@ static __always_inline unsigned long _co
>>>>>      * check that the page number lies within @folio; the caller is presumed
>>>>>      * to have a reference to the page.
>>>>>      */
>>>>> -static inline struct page *folio_page(struct folio *folio, unsigned long n)
>>>>> +static inline struct page *folio_page(const struct folio *folio, unsigned long n)
>>>>>     {
>>>>> -	return &folio->page + n;
>>>>> +	return (struct page *)(&folio->page + n);
>>>>>     }
>>>>>     
>>>>>     static __always_inline int PageTail(const struct page *page)
>>>>> _
>>>>>
>>>>
>>>>
>>>> I think we should do the following. And I'm wondering if we should squash that
>>>> into the relevant nth_page patch instead:
>>>
>>> Sounds good, seems to be working for page_folio().
>>>
>>>>    From 6ada1d36d18969db587ab647757a9538ee1d09a6 Mon Sep 17 00:00:00 2001
>>>> From: David Hildenbrand <david@redhat.com>
>>>> Date: Thu, 4 Sep 2025 08:35:24 +0200
>>>> Subject: [PATCH] fixup folio_page() const correctness
>>>>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>>     include/linux/page-flags.h | 13 +++++++++----
>>>>     1 file changed, 9 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>>> index faf17ca211b4f..3a9e73abea3e3 100644
>>>> --- a/include/linux/page-flags.h
>>>> +++ b/include/linux/page-flags.h
>>>> @@ -307,6 +307,12 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>>>>     	const struct page *:	(const struct folio *)_compound_head(p), \
>>>>     	struct page *:		(struct folio *)_compound_head(p)))
>>>>     
>>>> +static inline const struct page *_folio_page(const struct folio *folio,
>>>> +		unsigned long n)
>>>> +{
>>>> +	return &folio->page + n;
>>>
>>> Maybe you can just copy/paste "&(f)->page + (n)" twice directly and not need
>>> this wrapper? Maybe not even the casts as they would follow from the type of
>>> f automatically?
>>
>> Well, then the inline function is gone (which I enjoyed having), and the
>> there would not be much sense in having the generic at all?
> 
> I thought the benefit of the generic is if you pass const folio you get
> const page, and if you pass non-const you get non-stop, and it doesn't
> involve any cast of something already assumed const to non-const which I
> assume is bad (TM). But I don't know how much bad in practice (can it lead
> to optimizations screwing with your code?).
> 
> With the inline function in place there's such a cast const -> non-const on
> the page pointer it returns, but maybe it's fine because it only happens
> when the original folio was non-const? I don't know. It just doesn't seem to
> add benefits when only used via the generic?

Well, take a look at page_folio(), I really just mimic what they do.

I think the point is that with generics you can control that where you 
cast the const of is sane.

In Andrew's patch you just cast the const away unconditionally, which is 
rather nasty.

With generic you could write two functions _folio_page_non_const() + 
_folio_page_const(), but that's just stupid.

A plain

	#define folio_page(f, n) (&(f)->page + (n))	

Would also make the compiler respect the const'ness of f, because 
"->page" is not a pointer.

Now, of course that would change once ->page becomes a pointer (memdescs 
...)

-- 
Cheers

David / dhildenb

