Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A91773530
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 08:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715069731; cv=none; b=TBB6OpB9AHEIQOMnsfjLDQG2A3oRshQaGIVN5r4yTws8HfS3XzMTfcX3JWS8PDT4hF3yWeZdVujuqBK99HvwK1FYVvESvzKh1dtcPlnTTTU8rqd8DbxWr+g4mq64Xl7c5eND6XrQpCHnspt0ToeoXmG7/KusB7MhHDoputT/hFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715069731; c=relaxed/simple;
	bh=ZdFPE3wdB2ygnCGEDWN5bqbwsJUgl0LrSdKnwNQ3PhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dVEqmflrDO9B9bGnYm9LYvsojJs8zGiaLLyLwo9ml6JezvpTfEhlcgQNSkuFzIchGe89KA3Im9Zi7IzTFdTSm94kvWZLbRW3qmG5oZabnN16WzcRAMCLeEz4GmnlQoL2QqP0GCoo7JGPK1pN/qrSJWw8XyvHcCs7o5l7tQvgJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DypTTb/s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DypTTb/s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715069729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Djs3hBCyIJ8NwqENqdUWF5YZ3I/LX82bn8p/ogaOFnk=;
	b=DypTTb/s2A5vOtWfpGhr0IF9AEhMLt+9AzRumV7udyH6oZvtvawA5zS4wrtmdAhlknVNsm
	gRl/7KGaYDm80WFL3dhPmZh+6nOl6qTPfvvf92UNIgwRON1lFWo63nblndZ1DIuxhblx2L
	Q4n4kSF/kWANhtUmWEEB6yKfEml0Nn8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-_bDa-UgrMEKemcdsI-VBmw-1; Tue, 07 May 2024 04:15:27 -0400
X-MC-Unique: _bDa-UgrMEKemcdsI-VBmw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4183d08093bso10352405e9.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2024 01:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715069726; x=1715674526;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Djs3hBCyIJ8NwqENqdUWF5YZ3I/LX82bn8p/ogaOFnk=;
        b=QHY8pBYKqajXBh5NbCLAx7PZJDrk5Pj5/nErsgel81Az+O5FnMQyakZM8YGhdOlNEr
         LmLpfRWfaXvr/we4khDLMzGXeXS0ivsoKmBVPZdovrr37KNUNNiLLODjHhxbJbwFcldC
         yR6SNip7iD7oS1hf0S6x5BkgJSlZyCqNQJIz43uFHOO9I7c60lICGVqzTgYh879nweFA
         0u8GvCC8ZphE4zdgd48xy1ivD0MHFqOnG8fHoiDgZDjQRjHYtoTf7fzRnrnjoI2aFP2V
         Vn/RElxDY7LD+QWmLdneTyhWoEs6iTnwNqoPDwNLXY/3xzelA8o5I1JhNsMfiRsQGcWx
         irSw==
X-Forwarded-Encrypted: i=1; AJvYcCXEer9+1ZzvDghAgxqH+EMH0p09LOl2eSPdg863MwFPm2Qx6AzjNRgtBFlsWvWTnBibZ1Zp2b5d6vsbdDwmNle08F92EnSHrIDPIg==
X-Gm-Message-State: AOJu0YzFNVkcXMyz0QMKK1zYUOxk9eUa0d+TP1Bpvghj/pMtKNdVNfkY
	JO9//Rw/Id6oPI1m0Rytislbz4hoh5wkTxMAj1Lov4NU3wKnL9GiSWYh13jWYzXmNGvKnU0pIhc
	nXyq4ihYO9VGeCL9WDcDXcxmoyd21Q98SLEdZYRLex0zNooNVrcknFZVObVQ=
X-Received: by 2002:a05:600c:458d:b0:41a:b8be:a0b5 with SMTP id r13-20020a05600c458d00b0041ab8bea0b5mr9344419wmo.10.1715069726440;
        Tue, 07 May 2024 01:15:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiF0+/N53r9BKL8AZZQnlsTkCQ83KZ1GhIqQJTYN7uI35d7tBLT9ZbmYkDaN1pLHUPsEJscg==
X-Received: by 2002:a05:600c:458d:b0:41a:b8be:a0b5 with SMTP id r13-20020a05600c458d00b0041ab8bea0b5mr9344393wmo.10.1715069726020;
        Tue, 07 May 2024 01:15:26 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id d10-20020a05600c3aca00b00418a9961c47sm18370633wms.47.2024.05.07.01.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 01:15:25 -0700 (PDT)
Message-ID: <4e4a03e7-9c2e-4e23-8e76-3b2feae4ccb4@redhat.com>
Date: Tue, 7 May 2024 10:15:24 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-stable]
 mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch removed from
 -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 zokeefe@google.com, xiehuan09@gmail.com, wangkefeng.wang@huawei.com,
 songmuchun@bytedance.com, shy828301@gmail.com, ryan.roberts@arm.com,
 peterx@redhat.com, minchan@kernel.org, mhocko@suse.com,
 fengwei.yin@intel.com, 21cnbao@gmail.com, ioworker0@gmail.com
References: <20240506005757.7819CC113CC@smtp.kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240506005757.7819CC113CC@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.05.24 02:57, Andrew Morton wrote:
> 
> The quilt patch titled
>       Subject: mm/madvise: optimize lazyfreeing with mTHP in madvise_free
> has been removed from the -mm tree.  Its filename was
>       mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch
> 
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 

Andrew,

this series was moved to mm-stable a bit too fast for my taste.

Review is still going on, can we still remove that from mm-stable?

-- 
Cheers,

David / dhildenb

