Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DCE28314E
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746727378; cv=none; b=H9SG49vNJ0wgVwXj66R5X+xhbVBjumnlcmB8C7VYunD5jxtTg99WWAd+7N2t22qsgZtXvpsPlVVVer6x5AGJd3mw6mXpN7KKgGjBaT+StbQISRCLsX2YZ9c6Yswi3+Dfv4xYnnpYUjGJHFpAbRJvjCciSb+0uoewQvp9SZMaa0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746727378; c=relaxed/simple;
	bh=rr+0ujm0Av0ufui47SzLn5WUtme8/E9314u5JrNIWUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O9NRjIlgomGV2Xy2TZxqYc5RHvAZnkHzTXcT5Ah2oEUUdjl6FzZzPjNBfd752lPuWeArx/P1yNeCxbIeHU0NxLheQ+2/KCsY462zs8jbXizg4u1LSCHio+sKDwfNy/TLPV+X1rWwTXC6kwAaajuo16CpD+Gtv4TbGqQdTWAFsio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HoG1ivw6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HoG1ivw6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746727375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hmZn+h3v3b1Kiuxg5EGyebbBkR0sPXG/8wqLyDoqdxE=;
	b=HoG1ivw6pj3phLQxc72V2JHRCF7MlUcPSTLc+jm3tRtM4yem6Jux9u8ytG71YUeFcN983u
	1yJlrlInRI+Kfk290AV64fbURWCBQWJ6rA3pUQ6ZDSZLc6fMabOIecamv8oBhHT+hVmdkX
	XlgusIgFYzbwR041nURHHKEsWZlT4ew=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-shDIgmNIMv2S2aMDROh-2A-1; Thu, 08 May 2025 14:02:54 -0400
X-MC-Unique: shDIgmNIMv2S2aMDROh-2A-1
X-Mimecast-MFC-AGG-ID: shDIgmNIMv2S2aMDROh-2A_1746727373
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-30c4cbc324bso6289651fa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 11:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746727373; x=1747332173;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hmZn+h3v3b1Kiuxg5EGyebbBkR0sPXG/8wqLyDoqdxE=;
        b=KqJpWrzbuaEC+JYskAMEVhHeozIueJKpnkehERhaRrXlY5lKKsM/BhJDfFvFIWVDd7
         +0wDUb467ysgrbOZZ3KzJTAPoO/eoF6MkTe2cxJw3TfzX5WxE6yPRyWSIfpsPG4ZIu0r
         HrWF4JO/DrUKEB2vhATHck4jEGVRbhUlrAROnTHkrZfhF2t9HwsG/ujDSXjOrBUSSelI
         wMbzxlYDVwGMHa93CTKAbX4wCzId248OOWR1dM0brzB0+1HJA+OD2ddOctc4uNPcQ1a7
         8il+fczqvyzTb8FPPbOuWiuZLMuMqBfqzm8OCrv5R9mQG+0zC0o1p7H6lMEVby8GJ1CG
         jrXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUTGLo+qdriKJobL2tF+lqW3oviAFF2NxlljrDLC05t9w4So2gqCnTx3u/fFnUe4Hj9LDGK5tTY5do@vger.kernel.org
X-Gm-Message-State: AOJu0YycxA+wPtQfZSpgpaJr5kwdmwQnDHoGsBErSCARvwwabtjGiZfx
	7Cuic7KHIu2afE6ryTNjZkUISOlnYUr0Lw7H6KimmoBp01528y5XtooCHdYjgrPL8BqDGkX+BnX
	WUVgfJ0xM5virLQAcnCOFR/UwZxZ1soh6as5qzz0TCJISq8JMVfGDHlogRC+LFmKDfXM=
X-Gm-Gg: ASbGnctU5dZepBwG8nOvgGjDPQboQrld4d5TMdZm5eu7W+bvsZ6PyU0Iq++RwMkdnQS
	+pVD62sukpGIWhzu8jmm8C3qW3fJitzR6Zo8jUXyhu/iIPc0xr4rbtA87kRbpmFiFhMcuZery/e
	aDvzoCcgFXJThGgyGpolOHnhALDxw7n9NFJ0MQRhktkx9koNOsZQTsc7bcl+elMpQCiVmtiIOAK
	i8PcDZoMIFd/nE4QhHVojJ4y9nJT6fRg63sKchf4LtAXOMa/iMudqERrIyI91juYt8UCL7j0Yly
	8j6GOEPpfax6a+NYiKmbSsAFX9Q3iLsZ80voKfR0S7jlHcHXwAmGUUsfG0NcqrjlhwGxVIL1d+s
	3GviZVjkph5pwLS4XyrXPy3Slm821qcpXxcRXug8=
X-Received: by 2002:a05:651c:551:b0:30b:c91d:35cb with SMTP id 38308e7fff4ca-326c453961fmr2067991fa.4.1746727372535;
        Thu, 08 May 2025 11:02:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpgzfw20j1EUeOh2qVaRcKn9yy7gE45JP778yOuvD0DRqLpxAzFnQT5qH3O6yk0IBzgyDsoA==
X-Received: by 2002:a05:600c:8215:b0:441:be49:d775 with SMTP id 5b1f17b1804b1-442d6d18c23mr2572505e9.5.1746727360306;
        Thu, 08 May 2025 11:02:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ec0e4sm637683f8f.40.2025.05.08.11.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 11:02:39 -0700 (PDT)
Message-ID: <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
Date: Thu, 8 May 2025 20:02:38 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
 jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
 David Howells <dhowells@redhat.com>
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
 <CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
 <aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
 <aBzI3sl6r3HtAWP4@x1.local> <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250508204711.6cf9f6e3@sarc.samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08.05.25 19:47, Pantelis Antoniou wrote:
> On Thu, 8 May 2025 14:35:35 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> Hi Jason,
> 
>> On Thu, May 08, 2025 at 05: 40: 15PM +0200, David Hildenbrand wrote:
>>>> I don't think there was a deliberate decision here, but there was
>>>> no > > conversion to remap_pfn_range(), the code (in DRM) was
>>>> always there. > > > >
>> On Thu, May 08, 2025 at 05:40:15PM +0200, David Hildenbrand wrote:
>>>> I don't think there was a deliberate decision here, but there was
>>>> no conversion to remap_pfn_range(), the code (in DRM) was always
>>>> there.
>>>>
>>>> The regression occurred when netfslib started using GUP for I/O
>>>> and when filesystems switched to it we hit this case.
>>>
>>> Okay, so GUP and DRM always worked that way. They are essentially
>>> incompatible at this point due to VM_PFNMAP.
>>>
>>> So netfslib requesting something that is impossible is the problem
>>> .. or rather filesystems switching to that and not realizing the
>>> problem.
>>>
>>> Hmmm
>>
>> This patch definately doesn't look very good as is.
>>
> 
> No argument praising its beauty from me.
> What is the right solution then?
> 
>> We *certainly* should not be even trying to touch the struct page of a
>> VMA_PFNMAP *at all*. By definition that is forbidden.
>>
>> It looks to me like vm_normal_page() already supports MIXEDMAP, so
>> probably the better hotfix is to have DRM use MIXEDMAP if it is
>> installing PFNs that it is willing to be used as struct page.
>>
>> But who knows if DRM can do that on arches that don't have
>> PTE_SPECIAL..
>>
> 
> The question from me is why a __get_free_pages() area that is passed
> to remap_pfn_range() gets the PFNMAP bit set.

remap *PFN* range is the wrong interface. You literally tell the system 
"map a PFN range and ignore any struct page" instead of "please map this 
refcounted page".

-- 
Cheers,

David / dhildenb

