Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6845621D581
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746732876; cv=none; b=MQsmiMM6tTthAhndZQsLqaNW9126ii8zakE/1D1TzW/i7xp1isDLiQFuDmtSBkk8OmIYxShFXuT1VORohc6tnfJnq1x4st362b2jMhBlm6B3WgClxgZ52L1prYp+7cJzgNTBrfZlaCneitK63vJY/bWFvwtMqMOwefFZWiLy6NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746732876; c=relaxed/simple;
	bh=CP9U151h/C6D6bzbli8H1RcNr2mB+9WxqFRK7x15Xgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHGQhyPLpVsGn9A/zJcyG5gVZEEs+4L6KZwYz/bqE+rWbMCgShSU330IHIgZs6/KOD3VtMKrCKMjDPYBj9ZH9t6i/mnZtuzAcUVE/VPlqHC8xd7v7KVlp6utpOr1dPDHzfWTz/H3fbfl6VF9IF28zBJ/FLPMWODnBbuu7amOczg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bF7Uh8UK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bF7Uh8UK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746732873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=95R8tosj+mj8+aapgKIbbFFqy0wM80tIXYjskZvoIrY=;
	b=bF7Uh8UK6Frn++89JZg2NXXwt7uiTurylGViAvvIZCL19dvLghE+45xMpEtlqa1QuHaN4l
	lbjzqYNjUW8Xn27idcJwrbCiCtMcBxNzQWqvaAh5auUEOOee3JrcWcvH42fcrNq1Ljk/+1
	6+Txqkv4bZvfO3Bp18fd1wGyI47OfWg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-d05Y0lelMhSMMWBSvXi4aw-1; Thu, 08 May 2025 15:34:31 -0400
X-MC-Unique: d05Y0lelMhSMMWBSvXi4aw-1
X-Mimecast-MFC-AGG-ID: d05Y0lelMhSMMWBSvXi4aw_1746732871
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43efa869b19so8719185e9.2
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746732870; x=1747337670;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=95R8tosj+mj8+aapgKIbbFFqy0wM80tIXYjskZvoIrY=;
        b=S3RydV2e8nr0CsnOzLCM6TkpVsXh6iqs/heiD0HYSlmZs3Y19I18iDlQQ/pDSQomOm
         BY0zBWocJwE/qVgJz+ymqBgslfI/ENmCnYvTBS9QpUhjz1VYfVJ4sGcSAyfgvhOyVBHx
         YEdpKj5L+11xL77D6uiZD0l41cgmfE2XX8RTABga5oixogGuVE5aTFkKPpywQzcDQ9r7
         SwJZ0RYb6c06WYxhoaPT6jzMqrMNfqlTuQYt606L3nnqK8rzWXyLL6FIU8OiBEfbZcfc
         sCsHG6o0wzoKkPDY0Yqv2PhvjJlQuwfzME9m38P7iWfFy1OWs2Z9qBjYVWqxC2FQLtd0
         zX5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNwPTYOu/Di5eLDNlTED0YaVv6l59/VBzhfUqH7T6YlueBzg3YPFAP2AlJlrcccMxznkj8uhq5aIrV@vger.kernel.org
X-Gm-Message-State: AOJu0YxuH8+CD5aEf625eT+z1JB9xgXwjCgxHG308+ETQyTL8Ojuk1Fx
	wXUDso2BdzU8P1aU8rgG5ZPce2STvhHwp+9p2DIZ7dNEBxe8fk6B3lArKmmRUSoSpjZX4SpHnDZ
	8dgrF8s8tVZvUA14mXRtvFbii0ySgJa0A4n5R7Bez0+mQSEnrwShXBkN4NCI=
X-Gm-Gg: ASbGncuCW/ACN9mMbA8jFNA6qletSnIWfU5w7dUqR9bDV02RgwhDcQYt5ldvgleaUif
	wIs3tXj8igZrJSUj7vJ3WhEycNNXKU0yWiGudW7ecZKcYyUxgU9uvamhMIF18iP82u+Rz9ZRVBS
	V2MKF80b/hDZD6p7qdjkJ0vU5M4Dre6FnPOM/kP/kDCG0IwLWtAr5P4ubzegW7BwriuijS6i98b
	MzfqSZHCuMB5jlmIXSFT2itkZRczeYxEcjG/NQvWxPdojWQbnhE/tcQD32P4MQzgUxw9r1widcS
	NraXPGOzlQPeeyNlvrlJyLZNHBNY/MqUN3C6HHS+pBOdxuJpx+jQRknsyiCr5Ck5HY6QOjW9s3M
	Z0VOaF1uk67DDf22uWQAG7hBuz0mb+8zfs06Zyc0=
X-Received: by 2002:a05:600c:1553:b0:43c:f575:e305 with SMTP id 5b1f17b1804b1-442d6d3e24emr4341735e9.8.1746732870659;
        Thu, 08 May 2025 12:34:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEf+d1Q07IUv4s87ZcixF/p0yf+qoQwaMCW+Oracp1z/D4AbvdbgoCVUS55O1vlbUhJS7tp3A==
X-Received: by 2002:a05:600c:1553:b0:43c:f575:e305 with SMTP id 5b1f17b1804b1-442d6d3e24emr4341555e9.8.1746732870301;
        Thu, 08 May 2025 12:34:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd34be0csm46589795e9.18.2025.05.08.12.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 12:34:29 -0700 (PDT)
Message-ID: <5815c21f-7ecf-41bf-8bfe-89dbdc6c4595@redhat.com>
Date: Thu, 8 May 2025 21:34:28 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>,
 Pantelis Antoniou <p.antoniou@partner.samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 wade.farnsworth@siemens.com, jhubbard@nvidia.com, c.briere@samsung.com,
 artem.k@samsung.com, David Howells <dhowells@redhat.com>
References: <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com> <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com> <aB0BI-inU839lcIq@x1.local>
 <5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
 <20250508191920.GC138689@ziepe.ca>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250508191920.GC138689@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.05.25 21:19, Jason Gunthorpe wrote:
> On Thu, May 08, 2025 at 09:14:38PM +0200, David Hildenbrand wrote:
>> On 08.05.25 21:08, Peter Xu wrote:
>>> On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
>>>> It's doing the same wrong thing at a different place.
>>>
>>> As I mentioned, I believe KVM has this wrong thing working so far..  and it
>>> doesn't block us from going right ultimately.  It's a matter of time.
>>
>> Yes, KVM has it wrong and vfio probably as well. And they are usually not
>> dealing with actual kernel allocations, but rather with MMIO ranges.
> 
> vfio also doesn't take references on the things it pulls out of the
> VMA. The vfio bug is different, it lets you take a pte special
> phys_addr_t and reference it through the IOMMU without any
> refcounting. So when the VMA is destroyed and the page free'd by the
> GPU driver we just UAF it from VFIO through the iommu page
> table. Woops.

Right. What is_invalid_reserved_pfn() does is check that if it has a 
"struct page", that that one must be marked PG_reserved.

That PG_reserved check is a nasty check for MMIO pages or memory holes 
part of a present memory section.

So at least it will reject anything that is just an ordinary kernel 
allocation (!reserved).

-- 
Cheers,

David / dhildenb

