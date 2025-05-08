Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47902153CE
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 10:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746700771; cv=none; b=CX6Xd0sD8hDSHUO9vXf9S7PfRkmFnr5TRvC6s7EmqBPMYOFMcPW2a+pEQ4sDSnMO0TtvjkWUWf6JjG7py5QMTDZPUWNeOPUqTElSkE1sWxlY1Xl0Qst19V2C8thsjdCERj6fzaPZMgKPMppyhL5nts7f425FQAGTL0iiA/PvcLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746700771; c=relaxed/simple;
	bh=s0RnME7KcgCLL/k3+995bUNDXoyywiIwMC2WZiBwA2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mO7o6uwZJJn67WEgHPTNztkd1YuTqHMT9+Bg6D/RTKLb+uYlub3b3iqleANM+ahsVlbQQhgl9ut2ssJJUoeJa53D6KEdg6WrZhp5QurgRjecalcM29Pgzx4wst7QeEMPpr63CcmRszUIG/9PhUdYy38XnFXlTNP80tLskvEj/Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBZcO90u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBZcO90u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746700768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6t4cEg0LatFjlXf3QXDDfjGKg9CKcJBCQRCDHV4Ml9s=;
	b=SBZcO90uAImOBdOdZ+658QkBrl1OIoY0OJSS5zGhRcvOYLi0sWFTu1BZmjLD4oww9QloEF
	Vie4JFEHQakaGcX6ivLnsv+63ohZuxrs+ZIVOn2k8S2YL2IeZD6QXhqtqBEkVSYEP47Zzs
	tRhl9sjsn5YWWr77ni0F1UzrfXaMg1k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-i8qZii4mNESXCk-qg_WkvQ-1; Thu, 08 May 2025 06:39:27 -0400
X-MC-Unique: i8qZii4mNESXCk-qg_WkvQ-1
X-Mimecast-MFC-AGG-ID: i8qZii4mNESXCk-qg_WkvQ_1746700766
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3912fe32b08so449779f8f.3
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 03:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746700766; x=1747305566;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6t4cEg0LatFjlXf3QXDDfjGKg9CKcJBCQRCDHV4Ml9s=;
        b=AmzfaxxB5BF6lfNf4vap6H7q4ebNckTg47zyONoaxdfWxUhQrkRFVQ5U3eaOwnC6tM
         ym/n0moe7aEy5bljZcpbkqSvFNp//zRQii9PIHpwuN8gn3YxHuksP1yFdqYU2rUX7OYe
         EzbM2jOBhhPnddc1zxPLUiPC55g6Gxf70JT0xj0cf7CjjVJPdUih307TFl9gO3XiczM6
         7u18BrCx+EVizY6WPLM2fUkZ9fe8aJSrdH+rY7n52mIbzJ82HMacCoMSP6AGVS2BVJX+
         2f8SVm3LxxT+IkcUNhuE6EBDqwr1ZHGf0e2UBp6Ev/fhp1vRD2Vk5IQ+cShdKiET9ZJs
         XTyA==
X-Forwarded-Encrypted: i=1; AJvYcCUy5x+iyJ14rxn0ZgujG4+jhC5YTuJECphFzDKuK90F3FzGWRmr73998/oYa1+yAOYZ7p79UtQBw74v@vger.kernel.org
X-Gm-Message-State: AOJu0YxFZP5Dhxxj7qlwgh4BW+w/IUjVQ491qVOIruvNZnMN1samoJQX
	jk2eKYFvE9ydmg6m5L8hTEabWGwG4AyvhvxYKLwLhQTmkngk3RSPtSAYkSbw/Mwqb8iapMt4Vkt
	bB8SM7lg7qg0MjJ1XebPl4JMb6Y4R+hSW1pCISvA77EGkdh6M6KHULRZ2vt4=
X-Gm-Gg: ASbGncvQlb3k0m6pNOyii0YNZGGBZRFymNZdZTlDR9z8rl/AumUql6JqmpF0KzUU62s
	JBEuyYMy8KmLX+/RL932nAvyRnbBG8I1WNldXDbTC8J7ToZPVKG0oJs4gHBHSVhqDuQJwLJ9mBX
	G+xI4DLNudIGd76D7JxCkxMZZYNvzX1IYXEjTgB0wWR3pFDpyT72/nfdQL2nbyjr+zRAK4fVSLa
	8UGIUVK5Aj7i9T1XvUjmuKyh/HUP4cFDAmf2SJCulCfPRAbNBmvJVTHg8Tpuk+EllO8mpkuWCLo
	wnxvFeukCZdY4nlXSsAR7c5H+K7ZKTp6GMAl5+3mUJUeX0LymCzAOzLZZ4Qdhb9d4Xvd09IIV+o
	2nwIEy1x5uo+KcL4CMf2jSBwYEpMBEfydKWFB9jM=
X-Received: by 2002:a05:6000:2204:b0:3a0:8a1c:ef0 with SMTP id ffacd0b85a97d-3a0b49bbdb3mr5647134f8f.24.1746700766383;
        Thu, 08 May 2025 03:39:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdXDs/mmzgArA3it/b9dcUHvIQwRl6ZyxODI36lZy4UlDZeanVDMnOFVuRhm28CrNzwbBeew==
X-Received: by 2002:a05:6000:2204:b0:3a0:8a1c:ef0 with SMTP id ffacd0b85a97d-3a0b49bbdb3mr5647114f8f.24.1746700766017;
        Thu, 08 May 2025 03:39:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0b8542d91sm3004488f8f.5.2025.05.08.03.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 03:39:25 -0700 (PDT)
Message-ID: <364f77b4-a1c5-41e1-a147-3f534e18bcf9@redhat.com>
Date: Thu, 8 May 2025 12:39:24 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-optimize-mremap-by-pte-batching.patch added to mm-new branch
To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, zhengqi.arch@bytedance.com, yang@os.amperecomputing.com,
 willy@infradead.org, vbabka@suse.cz, ryan.roberts@arm.com,
 peterx@redhat.com, mingo@kernel.org, maobibo@loongson.cn,
 libang.li@antgroup.com, liam.howlett@oracle.com, jannh@google.com,
 ioworker0@gmail.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, anshuman.khandual@arm.com
References: <20250508014113.7E78FC4CEE2@smtp.kernel.org>
 <addcfcdf-3ded-4d9d-8a96-6006d3b71a51@arm.com>
 <66fada4e-c9e2-4d67-a939-9cc1a93239d7@lucifer.local>
 <d0fd1faf-ea5a-4b99-9b48-7e3e8725865e@arm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <d0fd1faf-ea5a-4b99-9b48-7e3e8725865e@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.05.25 12:19, Dev Jain wrote:
> 
> 
> On 08/05/25 3:41 pm, Lorenzo Stoakes wrote:
>> On Thu, May 08, 2025 at 03:38:46PM +0530, Dev Jain wrote:
>>>
>>>
>>> On 08/05/25 7:11 am, Andrew Morton wrote:
>>
>> [snip]
>>
>>>>     	/*
>>>>     	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
>>>> @@ -236,12 +254,13 @@ static int move_ptes(struct pagetable_mo
>>>>     	flush_tlb_batched_pending(vma->vm_mm);
>>>>     	arch_enter_lazy_mmu_mode();
>>>> -	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
>>>> -				   new_ptep++, new_addr += PAGE_SIZE) {
>>>> -		if (pte_none(ptep_get(old_ptep)))
>>>> +	for (int nr = 1; old_addr < old_end; old_ptep += nr, old_addr += nr * PAGE_SIZE,
>>>> +				   new_ptep += nr, new_addr += nr * PAGE_SIZE) {
>>>
>>> Apologies, this is wrong, I moved nr to the for loop thus nr will be
>>> initialized to 1 only once, what I intend to do is set this to 1 at the
>>> beginning of each iteration.
>>>
>>
>> Don't worry, Andrew will pull the series out of the mm-new tree based on review
>> push back automatically :)
>>
>> The mm-new tree is also intentionally designated as the 'anything goes' one
>> which has latest series in - easily applied, easily dropped, mm-unstable is
>> the one that goes to linux-next now and mm-stable is the final set of
>> patches that will be sent to Linus.
>>
>> So there's no need to proactively chase here unless it's heading for
>> mm-stable really!
> 
> Thanks for explaining what mm-new is, couldn't find anything about it on
> lore :)

You can find some more information at [1]. As the comment by Vlastimil 
explains, the naming in the article is a bit different to what we ended 
up with.

[1] https://lwn.net/Articles/1016724/

-- 
Cheers,

David / dhildenb

