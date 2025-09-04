Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46772C1583
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 10:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756980070; cv=none; b=QJP5TJMJEXkb9dO8aWabbBtvsOJkCeMTQnJTgwL4OusTBFc8nBb5sZn6V1TG2foWMGgN2RUPXwoeGBZ+4SK/SjWkQMu+ih7NI+LzhEpS+j53cOQbSST22kOtbp+QaT7uupEM9SHfcb36UUw48WVxYRlOyA3LaV7wj4aK63skV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756980070; c=relaxed/simple;
	bh=mLKIddLJyucbvz10maHxQhsIyiOJfq+JwZICYg05/hU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HmA2Y73uh48Ik1wOpLpUJOW4Tcs75Axe6eF/n/USukzNDLZ+u1btPB1UtyCt6pyg0gCjIELKm7n1+da4VmmprOgxKobXfDC9xMFnfmnVi3BQekGbmYonPWAJHf+0dK9++dLFtLIkZ48iEg2gwZ3OJJGu42MimY6v22n6r3WPzhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WS/Kc3q1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WS/Kc3q1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756980066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CIN5qK324XvsW7T0FZqiVUIUcw0Yzw7GtZhE5BoOdiE=;
	b=WS/Kc3q1XA2MgdZd9ED77lPTolJqkKtIgGI9p15GHSAJlmqQp1z43x6vi8v3XQu4L41ZwL
	xXd+IXAK9BGm9zB9fZT118g1b4qghiL3tucPhJdMqchaKqROCEKc2GAnCpzVo2jRKIuE4M
	4XZR/ctoVijn6Z49vaxpZd2JDL9/0/k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-So-Nm5hvPbKmbMgadziZ8A-1; Thu, 04 Sep 2025 06:01:05 -0400
X-MC-Unique: So-Nm5hvPbKmbMgadziZ8A-1
X-Mimecast-MFC-AGG-ID: So-Nm5hvPbKmbMgadziZ8A_1756980064
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b71eef08eso5409965e9.0
        for <mm-commits@vger.kernel.org>; Thu, 04 Sep 2025 03:01:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756980064; x=1757584864;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CIN5qK324XvsW7T0FZqiVUIUcw0Yzw7GtZhE5BoOdiE=;
        b=JNxW2xUJujUYL0LggNVO0OU41wvOgL4Q8Flp9nOfKc/tNaKEBaX/cqrLCgQJdvIFe/
         BXTOCpoFYcGSPnLGMUrr5snEH3iSpDby8W5IhntvfSVpmDxwyRPmHE886OHIT+f9TAkx
         CBJsDPN7Er1LXZxRNUXWIQi6pVAqLoe4pDZ39vGTw7Gexov85XQ6GAgiQF0vdoCc8Jy5
         oQ37srvOd8XAADcoTGNXQSQMl4hLVXRkRQRVjRQGWuV3LW6j5dJQBedwYLPkXHJhlSg7
         UTMk6B5T/f90I6YsBokvgyyg6Y2nLzqcuZSpt+n6lr3nFjd7k8f6v/q3sSAXwBqHz1nF
         pRhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJRKEj2NhzJqJ2OQWmZY7k4x2irM/Zvs+gvmiyGNjDj7d49XNxsjfXfXQzsAn+N4dmx25I7xUgoQHg@vger.kernel.org
X-Gm-Message-State: AOJu0YyDPb6VmIKZ1Q1Sojn9pBKHLGEeB0Y6FBMEl6Be3/oWkBlVW/g1
	38vjvi4v1jdh5Ibm/uT8j/UEgC7ak9aArJ8uSqLsN4NIi+FAUcqOBFzNSkhv5SbWd7Sq/4OYtY5
	6+DRgB0EP8DfAUDwA/3cst3s218xO8xPDibRq1utRINmg2pijDdddLZGSa1uJ7v8=
X-Gm-Gg: ASbGncsMH6w9glFrPJ0qPU+lRsByC2t0jU+68PXozqfu2CG7z6pfmCNNQdnfwU0Gy4W
	XgDW9hqalneXhWN1D0JCzmbESm/BZZa12qrH98Q75iqEn36fzjV7WwrekX9KEaw3S5oQTooIC+4
	/SlAb3bJXvNR/bCE8YcDz+q7cXSyX4fVr/7HS+23Xh8pTWJCFZ0wQ5eriYkvNoTKjVDkmvTnq1e
	UBX7i1/+1wqOPRY/Tv9sKYfAuCQzQnyIdliqwgpmDqpqeAO5U2sXJbZrI/25K7hz5ZZ5oqHCx9O
	PVzYAEkywPTJMptaG+5PCoLNMecjS9B4pInAyopKoBT2DCH/ODHHzx3qMDr6Tr3Pt4RWlOdp788
	HOXiiDs1NYjlDy3ftaorPgRwX8QrnxNHb2me4K5+osst0k4azSlyuJRqXx7Lf/0ls
X-Received: by 2002:a05:600c:5492:b0:45b:9a7b:66ba with SMTP id 5b1f17b1804b1-45b9a7b67ffmr73366235e9.14.1756980063930;
        Thu, 04 Sep 2025 03:01:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGUrD1aRyw9876B2fTW1lK6AqmYO1i0a9HAbJYVnGtNnCkwB/kNWp5eSE38l5ZuF0wsk17Tw==
X-Received: by 2002:a05:600c:5492:b0:45b:9a7b:66ba with SMTP id 5b1f17b1804b1-45b9a7b67ffmr73365895e9.14.1756980063418;
        Thu, 04 Sep 2025 03:01:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b98e77231sm105745195e9.12.2025.09.04.03.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 03:01:02 -0700 (PDT)
Message-ID: <8d6584f6-ea71-437a-a487-c7cf730671cd@redhat.com>
Date: Thu, 4 Sep 2025 12:01:01 +0200
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
 <83819219-c972-4e4f-b343-d2b3cbe5f4d2@redhat.com>
 <06e88701-9660-49c3-b9df-934e94812773@suse.cz>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <06e88701-9660-49c3-b9df-934e94812773@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.09.25 11:48, Vlastimil Babka wrote:
> On 9/4/25 11:40, David Hildenbrand wrote:
>> On 04.09.25 11:28, Vlastimil Babka wrote:
>>> On 9/4/25 11:16, David Hildenbrand wrote:
>>>> On 04.09.25 09:57, Vlastimil Babka wrote:
>>>>> On 9/4/25 08:37, David Hildenbrand wrote:
>>>>>> On 04.09.25 04:59, Andrew Morton wrote:
>>> I thought the benefit of the generic is if you pass const folio you get
>>> const page, and if you pass non-const you get non-stop, and it doesn't
>>> involve any cast of something already assumed const to non-const which I
>>> assume is bad (TM). But I don't know how much bad in practice (can it lead
>>> to optimizations screwing with your code?).
>>>
>>> With the inline function in place there's such a cast const -> non-const on
>>> the page pointer it returns, but maybe it's fine because it only happens
>>> when the original folio was non-const? I don't know. It just doesn't seem to
>>> add benefits when only used via the generic?
>>
>> Well, take a look at page_folio(), I really just mimic what they do.
> 
> Yeah, but that one is different due to _compound_head() returning unsigned long.
> 
>> I think the point is that with generics you can control that where you
>> cast the const of is sane.
>>
>> In Andrew's patch you just cast the const away unconditionally, which is
>> rather nasty.
> 
> Yup I'm in favor of your approach.
> 
>> With generic you could write two functions _folio_page_non_const() +
>> _folio_page_const(), but that's just stupid.
>>
>> A plain
>>
>> 	#define folio_page(f, n) (&(f)->page + (n))	
>>
>> Would also make the compiler respect the const'ness of f, because
>> "->page" is not a pointer.
> 
> Hm that's true. The generic then only adds some type restrictions.
> 
>> Now, of course that would change once ->page becomes a pointer (memdescs
>> ...)
> 
> Right. I'm not opposed to your patch, just thought it could be smaller, but
> not insisting. Do you want anyone to use _folio_page() directly?

I think just like _compound_head it's rather implied that this is only 
for people that know what they are doing, but sure we could add a comment.

> If not
> maybe add a comment that it's internal and only folio_page() should be used,
> to help avoid accidental misuse?

Just to clarify: I'm not married to any of that, but I enjoyed having an 
inline function. So I'm mostly wondering "how could we do better than 
just going back to a plain macro".

I'll note that _compound_head() is rather special as in it essentially 
consumes a "const pointer" but then just looks up another pointer where 
we lose the const-ness.

-- 
Cheers

David / dhildenb

