Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2299B1990A7
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746728810; cv=none; b=Vuf+BK03FmClYIb1SdVi6h7z/jknSfvGBrYttHYicRr32+c9Hqlxu39DGWU2xtTMPy2WmQIlw9knVGUxJwWlriiNGYiJyf/kN3YvGs4K8OdEJd3DEdot4EDV6iJTtMIR4g5Toczw3HghgBeREYWvafCpihTXqeyr8birFMz3enc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746728810; c=relaxed/simple;
	bh=EYVwbkY8QN1JVedKEvKZPSjpiZKGC+hK5RMNv5OFpP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P8kxJkQvfVRpgM6cGvFpIaIv6vqlrAjiCr5SPhNi4Uu5ufrcvNZh4kewS6JSZ4x1qoJ+uN/hM+CAoODPnMnqPkRtfZ7kboyWbMK1zdEzdPlB+g877l/Nh51rp8EjMWKPyRlv0LAa2BowLEkuuAYVCM73n4oRoWCN6pxTUFrr3Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EbojEoWz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EbojEoWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746728806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pnuQtAH6HsVggeMTKull00dcQKSfwGdV2pzHFuTHE50=;
	b=EbojEoWzOAXyEefB3u9zBYoACf+1IjG7UnwiewL4FJ061wY3NKEfFhBkXhrP+gegQxPOAI
	o16HLiZDDnNaA1D+RFklO1R8QNnD0YoOVoaDuocIO7wKM6KKOj2FkmoY+C52xeZhKBhA6I
	Y3Hy5NW4MgCBjXTFykKRq6CF6oYlJbU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-vOyPNDicPLm46Sp4v6705A-1; Thu, 08 May 2025 14:26:43 -0400
X-MC-Unique: vOyPNDicPLm46Sp4v6705A-1
X-Mimecast-MFC-AGG-ID: vOyPNDicPLm46Sp4v6705A_1746728802
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d209dc2d3so6107945e9.3
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 11:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746728802; x=1747333602;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pnuQtAH6HsVggeMTKull00dcQKSfwGdV2pzHFuTHE50=;
        b=Zhe+SuZ3XA2xOyx+CLwHew/E4kzhh1eo1WpXEyOsXx6hJ9GHFaa4VSlBVDekO8S6mY
         Hwa6m8FSTXzdk+MiafRtqmgg10ByaVDnuSuopbZUmZD3l0vTRYo7xeXzLtqS8zqYxj+r
         18rKZ3ijX3dlRAVELQKcHNEwmtPhqWLcDNIZIgasjSpYI02ta2kv2J+Qe8IPv8z6osrC
         ILNhzWHb/ExmKfqEPiaH5yaUjsfTANPAQN/94gtZHv6vLrzJxNJX23VvruQ71dOotEz9
         Ht1GbQdBQXJP6sN7m/VAXQw8b4tEwa6ENN1fLUeY1YhepTDdPG57i30qsnv5mSEemqZE
         xLBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqObv1jxP5b37DxA2QwdmsLEjgFMQjXYaKCwIo7RqTJzzPKo8Tly0AdwWWRA0dc1JuSRu4LQRU8FqS@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz5ID2Tox/Xvo9s5OWU4xJy8BEx91MVA/7jIszGIEqs4BpJOUf
	TTOK+ufiyW2SzhCOcVV0Y507kKS5r3J+F5Vi3t6UZt7ZpF/WoszJquPa4KbaJIa07m85UUqK/Nw
	WDdtq4CB7QTic9C3fHEe6kCX2rRirVJaE4GHYopzC8a4XdapDrbMR9tdpQfg=
X-Gm-Gg: ASbGncuFi7+Avmv0lCkqyUSZFKpbBs4IB9ZnR8KrPgqvbkecHrN/P1Ews9CGHmvG7hp
	YMUFOsQsRbSd+bL13mhrYB2BAHu98RHWbxl7ze3eo5lLpfyiZg3DW2LS1YJDbrivlh1ll31MUNK
	79gBYSUamkMsmiwD5umZejg4XyPQGQFGgvWszMbWawqv/Gac/ibiGShI5nf7i2m1/IOzKsyTrXO
	u7RUoPT6riILXOE5rlw1NcsdAlZvKJXzapcdN3YHOOanKu24DwU0J07crIASfTlScd7UEVVKDTF
	/MGxmsh6u4VkqDzMFGdPwTZ7LJHMtWEd5I2Ox43rhGlYNvEX+P+x7y9Sv/tBkFfroZDQly2MZgz
	I9z4ZJtDnCrFm+lnk/SNT7Qey5+XFx5WibrZcZgo=
X-Received: by 2002:a05:600c:699b:b0:43c:fceb:91a with SMTP id 5b1f17b1804b1-442d6d3dcbbmr3208275e9.11.1746728802184;
        Thu, 08 May 2025 11:26:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpLzWgtyiptMpyE065Mdu8S1kknJadlfyww/0yqvjmHe4MJ1TRKM1D8kqgJ3G4Lfyu7RnDwg==
X-Received: by 2002:a05:600c:699b:b0:43c:fceb:91a with SMTP id 5b1f17b1804b1-442d6d3dcbbmr3208145e9.11.1746728801837;
        Thu, 08 May 2025 11:26:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d687adc0sm2969255e9.35.2025.05.08.11.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 11:26:41 -0700 (PDT)
Message-ID: <4f99f64c-1e95-47e1-9065-cbd7bb9daa6f@redhat.com>
Date: Thu, 8 May 2025 20:26:40 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 wade.farnsworth@siemens.com, jhubbard@nvidia.com, c.briere@samsung.com,
 artem.k@samsung.com, David Howells <dhowells@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
 <CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
 <aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
 <aBzI3sl6r3HtAWP4@x1.local> <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250508211136.7a0a3865@sarc.samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> I agree, but it's not my code that's doing it.

I know. And it's not GUP that's broken.

Taking a ref on a page and returning a page when explicitly told not
to even lookup a page (including if there is no page, or if the page
contains unrelated garbage -- e.g., from a memory hole during boot etc)
cannot possibly work. And that's what GUP is all about.

> This has been going on for more than a decade at this point.
> 
> Can we get a plan on how to go around fixing these issues correctly?
> 
> 1. Drivers/subsystems (DRM in this case) are doing remap_pfn_range() to
> map system memory with a page attached to user space.
> Up until recently this was OK, since no-one tried to pin the pages for
> any reason. It doesn't seem like this is the right way to do it.
> What is the right way?

I recently had a similar discussion with Lorenzo. (CC)

Worth looking at

commit 8e553520596bbd5ce832e26e9d721e6a0c797b8b
Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date:   Mon Mar 31 13:56:08 2025 +0100

     intel_th: avoid using deprecated page->mapping, index fields
     
     The struct page->mapping, index fields are deprecated and soon to be only
     available as part of a folio.
     
     It is likely the intel_th code which sets page->mapping, index is was
     implemented out of concern that some aspect of the page fault logic may
     encounter unexpected problems should they not.
     
     However, the appropriate interface for inserting kernel-allocated memory is
     vm_insert_page() in a VM_MIXEDMAP. By using the helper function
     vmf_insert_mixed() we can do this with minimal churn in the existing fault
     handler.
     
     ...

Take a look at how kernel/trace/ring_buffer.c and io_uring/memmap.c use vm_insert_pages().

It can be done lazily during page faults using vmf_insert_mixed().

> 
> 2. DRM in particular has no standardized way to handle mapping system
> memory Buffer Objects (BOs) to userspace. Each driver is free to do it's
> own thing and does so. What is the right way to handle this case.

Probably this should all be properly refactored to map kernel allocations
as refcounted into user page tables.

> 
> 3. While we go about fixing it, this has caused a pretty significant
> userspace regression, where the address space that those BOs reside
> cannot be used for I/O when a network filesystem is involved. I think
> it's a matter of time when regular filesystem start using the same
> method of pining and doing I/O instead of using the filecache on fast
> memory mediums.

I am surprised that whoever did that change didn't realize that this simply
doesn't work and never did work earlier :(

-- 
Cheers,

David / dhildenb

