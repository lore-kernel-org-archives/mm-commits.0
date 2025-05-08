Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33064221731
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731685; cv=none; b=GSWZ/KAyA5X9O8nAJD8rMUTUVHjsOpQ1DKig97SUg0eilBUyt3ql/KWS3Yk6iVf9kXsjGJx6XcOajnYgmVgODx1v7FkD4UjcYdRlvl6rDLrRjEpPmp/zZwfUS/KsJEe6LsMd4Fi65bFTnkReyNfbcMrW42I0hPXmAK6+jfB6I0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731685; c=relaxed/simple;
	bh=wLOj7qykLan5QQd5wi22BGVD+gTvaTk9uwLYP9hV1Xc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owAmWRzxMJdxu6Cn3mTqd5xTm32Y4wRI4eo9grWU5rBie9r/luI1BpR3el8Lt2MWUJt5PUnG69QeoW1zUoAxihb7OaqSlZgdbK8Hc6XgXsQTI3L6Go0bKqKlX/QH9XPhiO2gxcdG1+zJ+pzEDw6iIw8AYj/VaOT5nATcBAYQCpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=he5QOc76; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="he5QOc76"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746731682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ygf1dNqOf6YsaMTtyjehtfzH5cV/Mo6o8ZlNGHn2ZMM=;
	b=he5QOc76HlIsY6T917mq+auehjooIg7QAgRXnXRQjOy/4ecdOCL0fB+tvxyxSvU6Vn6VQZ
	O8gXCsnSVWTP+CJ8VDmFixMeVubFmS5KZh5+8qpxVsmljmRm+acmJnjdmfy6g1zUDF7JEI
	Tpt64STd8dpdEE9Rx2Ef7LFuF9jeUXg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-SXmJbfqnMdmAXEGhwQBEjA-1; Thu, 08 May 2025 15:14:41 -0400
X-MC-Unique: SXmJbfqnMdmAXEGhwQBEjA-1
X-Mimecast-MFC-AGG-ID: SXmJbfqnMdmAXEGhwQBEjA_1746731680
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43f405810b4so7164155e9.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731680; x=1747336480;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ygf1dNqOf6YsaMTtyjehtfzH5cV/Mo6o8ZlNGHn2ZMM=;
        b=WD+9zLpj/fNIGsJfVIrbA2gBdG6iN6dYEWBfcFtd2AUPWk2t1B/2Egrkn9jBWtRRHu
         2A9yNGaCDi3LSxVYkHOSw9HU3zwIg8fkTMazDhDrSzatsM8JSmo+UH4aU3kYHc2CWZ6/
         MTFNLlW6iw/qLVVuQBA2QGAcSpC91l27+kOoJxBWIH2F5pBf987bDMK++bfx83ftnvNp
         LvnV1Gac7wGNuaeZ67/KRLYdd/UWHzU+ahowVeWih+lOp2HoqesJiLfvmnPUfsLIiP9D
         WMLqp0C2EuAn2/XtOmtyYUucI5N0Gv/8jdcC3gBmyoXCOLNbuxDRjsGH3ClDqQXoS9yC
         crQg==
X-Forwarded-Encrypted: i=1; AJvYcCXOkV5X7oClQOcoI8i3NZn1fMdb66jHsdf65Egx/k27I0APMy3kmXLGd4ZJHrTgsVF4A1bj6T++XEiQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3IVKN8NMF/+dEJDu/zhTg6wv7R9QNdK8fJfKcacVUzTAg2qbR
	byg7LVO7pxnAhgh/oScq/oVXMQz8NydwmeZz8CLT+gtaSyxiep3S7ay2NGXs6sCrZAykb9oOPgj
	4wg/u9RsnZFMgp1EGGx2JpjnLEjR5vJgk6eRhlxYiQEqcRZ5x9wykDHLitiw=
X-Gm-Gg: ASbGncuTePJCf2BiVdG0B/K3BPuCiGTIs4zSNlCro2OyzXMIxxOcA5+LLsmRug6bXkM
	YKLuqlbPsiYkqAtGVm1seJPJJuy0I8C8TlVp4OzOnHkMWHMzEXyF9wtAairdovSOWXmjQPQyORr
	IjpAj/km89brL/fixTCDdT1R1BCQ7NWtHZ7+WximtdCbJ2xRlwmy4TRj7vs8EnsI0nNtGMcwMsU
	Qfztkp12OR5+GCY3BTx9cdn1XRYXj0iXpA8qCsQxyLaJHBhbmH16nnHhMAZFTeJWTI+ZFH9+Rim
	MyVxHF3DK9qNWMts+Ssmydnbbav0sD92suYaYVUqm8xam7tvPMhFztNhaMEcljalJ5g45HwUnr8
	c/Ws4mnZPZztSjV70aL47AhhxvO4EmSdoXd0KenE=
X-Received: by 2002:a05:600c:3e08:b0:442:c993:8d9f with SMTP id 5b1f17b1804b1-442d6d1901amr4289875e9.4.1746731679715;
        Thu, 08 May 2025 12:14:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzvujBqeVYBvtBcQ2APvsfVlz1dEc3q8Q1iWn9EM8uv8IFet82mIMoE7CZQ7tRSa75f2hO7w==
X-Received: by 2002:a05:600c:3e08:b0:442:c993:8d9f with SMTP id 5b1f17b1804b1-442d6d1901amr4289665e9.4.1746731679391;
        Thu, 08 May 2025 12:14:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67df639sm4438625e9.13.2025.05.08.12.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 12:14:38 -0700 (PDT)
Message-ID: <5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
Date: Thu, 8 May 2025 21:14:38 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Peter Xu <peterx@redhat.com>
Cc: Pantelis Antoniou <p.antoniou@partner.samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
 jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
 David Howells <dhowells@redhat.com>
References: <aBzI3sl6r3HtAWP4@x1.local>
 <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com> <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com> <aB0BI-inU839lcIq@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aB0BI-inU839lcIq@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.05.25 21:08, Peter Xu wrote:
> On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
>> It's doing the same wrong thing at a different place.
> 
> As I mentioned, I believe KVM has this wrong thing working so far..  and it
> doesn't block us from going right ultimately.  It's a matter of time.

Yes, KVM has it wrong and vfio probably as well. And they are usually 
not dealing with actual kernel allocations, but rather with MMIO ranges.

Sorry, no more hacks.

-- 
Cheers,

David / dhildenb

