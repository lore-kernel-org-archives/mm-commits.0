Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4E5139D1B
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 13:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756991750; cv=none; b=fwPbArh/cEjLx9HCRj1AF82CrH7E4+IhgKjxNgdPnUs8NxysqoC6X3uWlG3UFo8UMRHkUpzczYB0m4AnrM14+RHtJBQmy7i+9P+43ZKavoIJr0K4VpO38b6WT3iNLmNnyEAWaa8OXCPUpeKAfwiFINKtUMluwF5VBPZ9yIUEvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756991750; c=relaxed/simple;
	bh=fFTJ6mxQOv6nVkCdJmVm9Y/PfZSAfFQFsIUSfttL284=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A1tbw2yi2eMsw307QpGuA9Srzd6/Fts/dDD5+of8ndrdcDU5WmA8u0SYgz6g2IFXC5DluE1l/52YYpmM4mVZI4X//zImpc3pC+6e2BJfVeMCf5Vq/CGOasBP+JSC+L/5wDjiU88ZXR5p1R52zeZXsQurwfDv1P+Ez3loLHTHnsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q9XLkdl8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q9XLkdl8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756991747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eshUblnVEQYFsqUMPphlrjcX4tGK55l+vplMTlyOOVo=;
	b=Q9XLkdl8Vu2/2fp1FStgm70oFsBWJy6cDnC0a2Z8p+UOwFtyAoD0E0rL12CQQztjzHb22R
	6tarEAHlJtDA2i0BLeahQ25cNJAbNL+UkdkjiJyHHY8DI/sexVqxgG1EIl5whGq4N8n/Ir
	k6xXrQaFMJ9ZKk1dtYWltZouVS03PeY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-ZArYeZgsOvyaB9vg9EsuDg-1; Thu, 04 Sep 2025 09:15:46 -0400
X-MC-Unique: ZArYeZgsOvyaB9vg9EsuDg-1
X-Mimecast-MFC-AGG-ID: ZArYeZgsOvyaB9vg9EsuDg_1756991745
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3dacc10dd30so761427f8f.0
        for <mm-commits@vger.kernel.org>; Thu, 04 Sep 2025 06:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756991745; x=1757596545;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eshUblnVEQYFsqUMPphlrjcX4tGK55l+vplMTlyOOVo=;
        b=StQxPGP/IZ2T/0qtpCiwTlJDO6t7NQBsnNq/6aSAsSNafsf3GhCwPSdowOQF0uFj96
         EzBBf4vamX2zkW122fkZf4RQN8lhoUzG5YBaZMTWYXEPIH/v7aC6f7N4zkix8lFxBo8Q
         7jfh+pslZb9vT8gnC0t9gy6zPlC9/AIZQm9zWrD+ZWaTc5cF5U90PZNmEPrCuxA0us9N
         tO/Ee6Sc0X5NBk1LVM8fdh6UFf6tf2IdwMIfkHjj5e91MBCLegYRIPVG8TiEaFcGVoYC
         sBFK6mgMHTgJzg75hbHLemRGrGPrO87CN+uLO53JNASRT9LTmalP09g+Tf27ToEq+0NT
         65mA==
X-Forwarded-Encrypted: i=1; AJvYcCX2zeZcBiu0PugfotMguY8+imGTdlN6j0Ud0fW4Xkmkdjh/2hu52AfB4GnebbNNd2Hvh7gZI23IV8WD@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6YqDhYnGTTcbPdREEyq5fNRNRVnWVyftFGkI0CnuuwsBIu+wE
	3cthWKlTNm+wzbbd0Aff43EbM2pcnupo9htbU1w9+wkPqhgS4MLbrbGZOzD5gYAaEzS0MecvT04
	buXK34ra4n/aFWf5C2jXr+fIDecuviRIgpEOLHSPg/PeikM5rRwq0RZSsdfJE9MQ=
X-Gm-Gg: ASbGncvEgWuEV3b4RuN6aVZjLFZccb/+pvDUTUYsNF+tttfjSZJ7OKiLBLpAEhmVY3F
	AnzuEgjVB+aMStYxFlqB6ScpK9eTKw8cFGUeqvKZ51xQ/pil7JSqx7sIF4gmDd54FS27Z40lf15
	c4q0gRKsIWHfHW/boikJThfbai/mya1DyONZ5+gzU9mtaZTjxM7lJc7itXdBz19mp8OCeeD6klM
	IrLvTwj20eUBzp8PMGzvv1gjFHSrHOsVbjFLK8SCnWAVi7olNyR6Surtv7LDqe9JtL2PlSWkTxD
	q4gPHwMctho5ZLUptcwoyg4TyRqpwOtPSy1RqEKcK8jhbifGWs1ZZ3PNOIogdHurwIyqY8+QiX4
	NA8PdeHyAe0dNoGEy0g9u6dzOQDd0dTteoBILdsq90lqrZwx/QuW/lZrXpneWdN+y
X-Received: by 2002:a5d:5888:0:b0:3e0:152a:87a9 with SMTP id ffacd0b85a97d-3e0152a8a81mr3128924f8f.28.1756991744763;
        Thu, 04 Sep 2025 06:15:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyp1eS82Q1M+Vq6QSjgf8J3HF2YN1d69YT061DHN3tOhrqQyvXG93uV818JJb5tIuQINnFBg==
X-Received: by 2002:a5d:5888:0:b0:3e0:152a:87a9 with SMTP id ffacd0b85a97d-3e0152a8a81mr3128893f8f.28.1756991744349;
        Thu, 04 Sep 2025 06:15:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm124281265e9.21.2025.09.04.06.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 06:15:43 -0700 (PDT)
Message-ID: <00ceb6b1-4dd8-4a8a-a588-4edc6469544b@redhat.com>
Date: Thu, 4 Sep 2025 15:15:42 +0200
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 sfr@canb.auug.org.au, rppt@kernel.org, lorenzo.stoakes@oracle.com,
 jcmvbkbc@gmail.com
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
 <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
 <9d209746-5e22-4ae8-a38d-f4988b4f7183@suse.cz>
 <0967d9a8-2677-4fac-89fa-4c75dc533ecd@redhat.com>
 <d45f0608-3ca4-44ef-950b-07b0388db639@suse.cz>
 <83819219-c972-4e4f-b343-d2b3cbe5f4d2@redhat.com>
 <aLmOv498CjpmpVqz@casper.infradead.org>
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
In-Reply-To: <aLmOv498CjpmpVqz@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.09.25 15:06, Matthew Wilcox wrote:
> On Thu, Sep 04, 2025 at 11:40:34AM +0200, David Hildenbrand wrote:
>> A plain
>>
>> 	#define folio_page(f, n) (&(f)->page + (n))	
>>
>> Would also make the compiler respect the const'ness of f, because "->page"
>> is not a pointer.
>>
>> Now, of course that would change once ->page becomes a pointer (memdescs
>> ...)
> 
> Right, once folio is a separate data structure from page, the constness
> of one does not naturally follow the other.  I'm not actually planning
> on having a page pointer in folio but rather pfn.  It's my feeling that
> we want the pfn of the folio more often than we want the page of the
> folio (eg so we can put the pfn in the page table).  Sometimes we want
> the kernel virtual address for the page (read() / write()) but we can't
> store folio->addr because highmem.  And I think pfn -> addr is more
> efficient than page -> addr.
> 
> ie I expect folio_page() to be implemented as:
> 
> struct page *folio_page(const struct folio *folio, unsigned long n)
> {
> 	return pfn_to_page(folio->pfn + n);
> }

Okay, thanks, so we could just exchange that implementation in the 
current _folio_page() proposal.

Thanks!

-- 
Cheers

David / dhildenb

