Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56561DF24F
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731826; cv=none; b=Wi9lQPPTvxgQZspDovnWORW4vuao7ZUkDxfIj2GmG5NrGfOg3gbRUaYsk9h+d3YBdg3FbEVNI8vVugilVoed93HoIqQiog1WUJmAjqljRLrPjFDQkJEpmOfiESciGvjFTxxT9Oj+wjYMn1jeayg2BxWP6TNOwxBDNObNaq02muY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731826; c=relaxed/simple;
	bh=ICdkc9kwAMzM6ex0pA/2TaUH9NFURUrtqruum4RzqYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dcB3YBAJrmg0sA1wPoHhP5xtXSU6hvo5qDInS9s1ZQynO5Y2uCfFUE7d3qgFsYP8Ewm9o0apAyr18bGvkv/VrTIC/dmNt8Xk2lzI6Thyk3afHQrjw9yQQmYDj9XI0SNIWP9F5B7kQcaLykskUhFv2bZ4d40X+rf8faoo6lpXnSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPMMO7CJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPMMO7CJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746731823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1H8/BcyZPPTnguXmJX+AqfCRjWrKTzn9HxYJ5qeChxE=;
	b=VPMMO7CJASslx6DWghCPalpw/xVTon+YLfabA7fmMOUDt2j4fzajrXW0OTdv2tWbowi7Ub
	9obFbRumutzPXOElrs+apMTNBtmPsfV/K5wK7Tn/HophRdzUgEiTRah7VAB1RDFs6Q+uoQ
	c6a30UHXKBhneJ6z39ZRG6Txyhq1ez4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-pQjw6FeBMXGO4KjphnClEQ-1; Thu, 08 May 2025 15:17:02 -0400
X-MC-Unique: pQjw6FeBMXGO4KjphnClEQ-1
X-Mimecast-MFC-AGG-ID: pQjw6FeBMXGO4KjphnClEQ_1746731821
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c2da64df9so617334f8f.0
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731821; x=1747336621;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1H8/BcyZPPTnguXmJX+AqfCRjWrKTzn9HxYJ5qeChxE=;
        b=m6V4w+kRAScwq8i4z2jXKoYEZ6XwMEWgudhvl9XM6afJVu+dsdhjYc2yVdkyAyTSFk
         woBgoZbc6NMJsTj2ExU/ESapDk09z4ktfLCvSrQoZEvyX7cWx6CmzoxVXOdyRbuMloT4
         gXhNIlADUvRQTwvpIZXSIzoNaKGJfseC48daB/RlRoZK79Dh+NFr2uQ39ERbHVAER2xa
         i6vatj9MtaM8aVbrE5JL3BhmF5NJnHuO7HL2Dt/9A5MPg097zopT18ZzJxAdCcFaF67R
         RrOCUKTTq36xWCPv/KMtNi3SJl3cIcLgHh+5/DaiOVmJdVYjjdm21q1H5zQLH6fPTP+U
         aa2w==
X-Forwarded-Encrypted: i=1; AJvYcCVvt5yXx3aett0DWxlQ0ZIbSDIeZWRtp4TIch8qWKJk8xy3WbVmtaFVYz4thCdj8haXz/TAc5vxzQL6@vger.kernel.org
X-Gm-Message-State: AOJu0YwoyvuEIotnO3tyJ8Vg76gmDv7h7hzChkru8MHVZ9iAiGNKkKyA
	smrUEtv2sx7t7VrWrqnQXQ1xWQ4x9E9Z/jMBybkw7jDMB5qfdyOfw6bV1VJbU9nKK76hKLwkqBt
	4rOB8gFi1Ss5lOhwkKQQ6UYRlp7/0m9meE4rAhUIkc6lKPS8ureOzCgzaZG8=
X-Gm-Gg: ASbGncuetOYxs96dK76s9npDbwxte4SQSJWGumysM/WQ9ERYe2GktssIWy0mcqodMGh
	ZyBlVoKd8CHhDW3ObWeFzQ4HI1c8DKjCbknRwVMBbPK0EEsUzKR/a10vGrPpi+488eXNBlG11ww
	LTvgfKiM8myewCmKoU58JpSJBNtUwyicwfUxJMHjb374Kg/ku8cyr5LSw2N9ckUgLGqn+fqCbNS
	W0OAXUuz20UMZV/vBJdUvaBC5Vey33mCl9ViMf7EW6+82A7msRcypbplmJo34iWk0hQIMRjwc7C
	Bw9HuCoNChEjEvpFZ4hK+UqfcnPAwxJoJ+hTqSlqULCJwVzkp/vNPSlW2KBXcCJE2u8K59U2CYT
	4HXWyVdBE72uUur4GtpXkT95hjrzkG1BM4N9TBec=
X-Received: by 2002:a05:6000:1846:b0:39c:30cd:352c with SMTP id ffacd0b85a97d-3a1f643ace0mr597846f8f.8.1746731820943;
        Thu, 08 May 2025 12:17:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IER4N0zkYhSnFjx/AlgLmn+IXqyoloaL1hUPQ9R1utdSr0dVq6e6ZcW0IHE5Mvv5nvIULFjsQ==
X-Received: by 2002:a05:6000:1846:b0:39c:30cd:352c with SMTP id ffacd0b85a97d-3a1f643ace0mr597828f8f.8.1746731820572;
        Thu, 08 May 2025 12:17:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f396asm814341f8f.59.2025.05.08.12.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 12:17:00 -0700 (PDT)
Message-ID: <97ac90b8-7707-4600-bbbd-e9b7d136959d@redhat.com>
Date: Thu, 8 May 2025 21:16:59 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
Cc: Pantelis Antoniou <p.antoniou@partner.samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 wade.farnsworth@siemens.com, jhubbard@nvidia.com, c.briere@samsung.com,
 artem.k@samsung.com, David Howells <dhowells@redhat.com>
References: <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com> <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com> <aB0BI-inU839lcIq@x1.local>
 <20250508191215.GB138689@ziepe.ca>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250508191215.GB138689@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.05.25 21:12, Jason Gunthorpe wrote:
> On Thu, May 08, 2025 at 03:08:19PM -0400, Peter Xu wrote:
>> On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
>>> It's doing the same wrong thing at a different place.
>>
>> As I mentioned, I believe KVM has this wrong thing working so far..  and it
>> doesn't block us from going right ultimately.  It's a matter of time.
> 
> AFAIK KVM is doing this wonky thing using mmu notifiers, it doesn't
> take page references on pte special pages..

Ah, and vfio also doesn't grab a ref in that case IIUC.

-- 
Cheers,

David / dhildenb

