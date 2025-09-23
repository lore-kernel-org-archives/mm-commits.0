Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F531E8B2
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 09:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758618160; cv=none; b=iUr2RifUly/U0gnjTNZElBaDUqeJ66tdHAcLOufEjN+oqE90ShUVfr78LqQeTfyn2z73EeaASd/JdI/yNVSe+ODzJdviHsPzY6Mn25fJSB01Y91Jr0SMKCvK5OJCfPZ8p6sXDOlZxjp72Y6txSOk4HlQC0uCGi7lt98Mbwm2X0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758618160; c=relaxed/simple;
	bh=Ca0dVfFeOQfqbmZm+jyb1DAU81B4soZB7493EkZPokw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CxoymIFNuKY+EK7WYBhstm5BhYCd498ACgx24H8RhlUM71yEiCokWMHzZEaNxhU5WXYRXi1MotwD8TJI2e3p5dohiOi/VnzO/NenlYVk4j1SnlaOBnXzFEwYGeMlmTmGV0l2qFyz9D7yNGultQOII9WvDJuBhRflBsmgyMbRTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G6fEMuT3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6fEMuT3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758618157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=25bRE8vn2g9x64R70edvxHdTqha5qNPQi8e11OJLNrY=;
	b=G6fEMuT3OxRWPDhaDU9NlpoJ9Bxf2EV3T+64KmrK9jX/WnzbadxUu2rfv+uLxqcH1TmzdH
	ZyFM7sIm8VXJFinptdoPBv91pHzfhEZeNEZs0bHNxePWD8Vy4ToNYDxx/us1x8Z4pJYR53
	Tn5waLb5y1wgrYROavrhgjEqVQ0v4cA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-ebShWeqHMTWJ99OHbSXD6w-1; Tue, 23 Sep 2025 05:02:36 -0400
X-MC-Unique: ebShWeqHMTWJ99OHbSXD6w-1
X-Mimecast-MFC-AGG-ID: ebShWeqHMTWJ99OHbSXD6w_1758618155
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso3612827f8f.0
        for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 02:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758618155; x=1759222955;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=25bRE8vn2g9x64R70edvxHdTqha5qNPQi8e11OJLNrY=;
        b=eAm5HYzFQLV8wOjNWUyQbvTcgVmQOOT1Knlj4hBn1AWE6OSoLWHuNn/MEvzCQqGu4b
         RkbeaXzLyjY6jlk/unuV3T8By27hSpmPcF53gdiUEMS+poAE58v4dF0R4MxitkGhRPUv
         2XRjb81/io9stjOhhxshgiwCchcKP6rCBxLBxx2c7BYEccusHoxU+yJSZ1uQTJCAsxVK
         rGLE0Ed1aSckA+paD4bm8NtFPlcjSNlDMn2pbT8CJ5MRKfhCV9l8GfmCB1TQojGhlDHf
         kC1ljmrIKB9TQf2HjYE2MsUkiC84ZDzk7WkV6VQUkkl8zumF69iqqPEzW/H6rFNg95Hf
         I1jQ==
X-Gm-Message-State: AOJu0YwizzvsB8acdwEer6/ZXHUH9iyJCVipFtn12TnM7aI1DNjeklXD
	Fi6gH96YHOo2qvK86PwMTeXPOV4ddSSHM+WvUIWNLiEpqLz+oHPGU/hj3xKi9I94SnC/FMSu9xx
	KtPAMJARJwGpwmeHpCdXJ/B15vTmdXnBlJZcuqxfvLulZbDV9XlQyOYCLumfme5o=
X-Gm-Gg: ASbGncugjRFD5OUrjZqhcnWoizgF96WlJ7vcUXbfpAo4NnJUTsVG6nTccDwWIZn3h0s
	hBrPsFULobXbUfIkRp6o4ut6S8Y1jBSR49lN0wHmMhXBfPN9EYmMTxEGaK92PV81UgbGdARI9ms
	V4ZPhiC3/NtGLCh9nYE2MKgnE+eQCtDLXyBAVjIPccLhRpX/4c6C30R1zByKpsZTHnC7hZcEZBk
	E0hHQd0bylPtchaR+qFz8qyBLbiJ006AsOPnEzUmbJlZZtpxjR6KFYpr4zPMatP00z1XkU7AMuN
	1awifj2pFKVoSFdwYqOB/uz9uw1YRQWF8J/dsNx1exH1u7JibKcMORrsZY9GBYG1VMcLX7naD6I
	oQdWkG5hifyk5SIEfb/4Yw+ZaPSRYWmVUPjtSLwwwc68lqNUcocZUX8U7gEhH/t+8pw==
X-Received: by 2002:a05:6000:144b:b0:3f3:ba4:29d7 with SMTP id ffacd0b85a97d-405caa503e2mr1482850f8f.43.1758618154653;
        Tue, 23 Sep 2025 02:02:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwZovLfJrJD/rNx/9npOjvxdbr+WZGeEuKVGmQ5vq1g0yAzBEryaVusJpbHoNSP9VyviMH/Q==
X-Received: by 2002:a05:6000:144b:b0:3f3:ba4:29d7 with SMTP id ffacd0b85a97d-405caa503e2mr1482816f8f.43.1758618154255;
        Tue, 23 Sep 2025 02:02:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07411f4dsm22921738f8f.26.2025.09.23.02.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 02:02:33 -0700 (PDT)
Message-ID: <545500cd-1d5b-4f86-aeb0-3461555d9284@redhat.com>
Date: Tue, 23 Sep 2025 11:02:32 +0200
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, sfr@canb.auug.org.au,
 rppt@kernel.org, lorenzo.stoakes@oracle.com, jcmvbkbc@gmail.com
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
 <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
 <20250921130536.c31bfc3b40a12aad8ad79c0b@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250921130536.c31bfc3b40a12aad8ad79c0b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.09.25 22:05, Andrew Morton wrote:
> On Thu, 4 Sep 2025 08:37:11 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
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
> Well I didn't merge anything new as a result of this patch and it's
> time to get this series into mm-stable.  So I'll use my nasty hack for
> now - could someone please prepare a followup to denastify it?

I can send a patch.

-- 
Cheers

David / dhildenb

