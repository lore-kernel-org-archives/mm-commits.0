Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D290208AF
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100856; cv=none; b=L7v606oqii/epjlGJLYQ8w14urjGum9JpNi3BuiJJECBvCCbItLaVdc3rPaurzU0qiuzpvpnbTXbXD2IrOGcb9kwA5DgactOAkcoOxsNA1NLhDTawxJ/yeAUACrW4v72P7zBaYdylFYvjF7kSE0mKzRFhNhiXGvEl1pHAUdWWtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100856; c=relaxed/simple;
	bh=smYRTmdvbuaYI1e/2X5d3gP2CrHdaypqU0vQp05Fxss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=crXs3Jm/ViLb2BARlEenz9OkXDej00RQ4CeFOQJv2oRYmnOaQTB8r1rspjxfTy52GPsTschMUImIqi9cREg+jiox4Q1Xp+Cg3UKBiZcxPOhxliM7/Hc2sUUQG98CV/SW11sFk1AAPd5crKGsQRjxyvhaDYpWhIsfXw/9v4gkh4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3x5fYwC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3x5fYwC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715100853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qTUjjA/hi6Ag991gIfDR4zg+SozvAIgnV3UvjBkEkiQ=;
	b=D3x5fYwC96W0k1ZsTLpOS+1kQwB5C9pC+Fu+L6HSazJFQy5LBt3mUsZ70UbMF8gmcjJjA4
	F44l6R/cRexNY/IxysONUu7HicEIEDYXWzrqQ3CLXBTB7om9Qjh9VEul4OUnl+Gs2kkx4U
	ygnRpDTZiz2oxvukn7/HmV46tyPpsNI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-d9oaahLMOT2XFZFQFV5YNw-1; Tue, 07 May 2024 12:54:12 -0400
X-MC-Unique: d9oaahLMOT2XFZFQFV5YNw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-417fb8195d7so14616035e9.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2024 09:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715100851; x=1715705651;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qTUjjA/hi6Ag991gIfDR4zg+SozvAIgnV3UvjBkEkiQ=;
        b=mfsYzPaFF4N/oBZHtrx5YEJPr944UxXIg7pAwxD0VfhVRfewoxV/XfzxM/v5DaGT0s
         /WMAyUnJaFvHcBNxuwCfiosn199xrgbFfg7hKlNHi4JFDUsrOBRx+g+L9qtVfbMko3Gd
         jYlUKvcs3FKQBbwRlnho1Ni5N38orJWl/MqjaI2Db+/sHq55wPRrC7QVgjEY5XlmVQrq
         PONNBn4T3X3ctE5WyIIsf5/4M7wDSD8HGMgQVzz0C/9+kA4dCreoik2UG05zak6mFznI
         2mlv/dXChOS2MlpcgD6waHcBca3VX4glSE9GSfR7sZsqUUe//bJjoLEfinCgIQeBE2QQ
         +FfQ==
X-Gm-Message-State: AOJu0YyFtHzoSewbtbBOZpWHRjyMLYUnpe2pFYSH1qBKJe3QbuLS5WAb
	cib4lmMLyeOX2J5Uak7VFWc+FCN10t9wzNKIFMQugE/ORZO2SOkM7Dl4cRJZZbiQ1mj+xoV7O/9
	ttYALc0N+2NIezf3r/y4/14OHJ7w9Bf7Pc7x54UO6i1ZsKX+fXvEkgIqB3sE=
X-Received: by 2002:a05:600c:4fc7:b0:419:f3f9:8ee3 with SMTP id 5b1f17b1804b1-41f71302a8amr2180695e9.5.1715100851271;
        Tue, 07 May 2024 09:54:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCfd1Vp8nn6saE1H64SvKBftXuCtTnEHodO8KHHwE5j5ELZ7YbZLY3ZN1Q9sVzOffTG//MYQ==
X-Received: by 2002:a05:600c:4fc7:b0:419:f3f9:8ee3 with SMTP id 5b1f17b1804b1-41f71302a8amr2180505e9.5.1715100850803;
        Tue, 07 May 2024 09:54:10 -0700 (PDT)
Received: from ?IPV6:2003:cb:c744:b500:3f9d:130d:ea00:afc7? (p200300cbc744b5003f9d130dea00afc7.dip0.t-ipconnect.de. [2003:cb:c744:b500:3f9d:130d:ea00:afc7])
        by smtp.gmail.com with ESMTPSA id i14-20020a05600c354e00b004169836bf9asm24000582wmq.23.2024.05.07.09.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 09:54:10 -0700 (PDT)
Message-ID: <a0397765-ffac-4422-b82d-2f3460d6f9f8@redhat.com>
Date: Tue, 7 May 2024 18:54:09 +0200
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, xiehuan09@gmail.com,
 wangkefeng.wang@huawei.com, songmuchun@bytedance.com, shy828301@gmail.com,
 ryan.roberts@arm.com, peterx@redhat.com, minchan@kernel.org,
 mhocko@suse.com, fengwei.yin@intel.com, 21cnbao@gmail.com,
 ioworker0@gmail.com
References: <20240506005757.7819CC113CC@smtp.kernel.org>
 <4e4a03e7-9c2e-4e23-8e76-3b2feae4ccb4@redhat.com>
 <20240507085526.5f4ea12e85e637dbc8e2e9df@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240507085526.5f4ea12e85e637dbc8e2e9df@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.05.24 17:55, Andrew Morton wrote:
> On Tue, 7 May 2024 10:15:24 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>> On 06.05.24 02:57, Andrew Morton wrote:
>>>
>>> The quilt patch titled
>>>        Subject: mm/madvise: optimize lazyfreeing with mTHP in madvise_free
>>> has been removed from the -mm tree.  Its filename was
>>>        mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch
>>>
>>> This patch was dropped because it was merged into the mm-stable branch
>>> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>
>>
>> Andrew,
>>
>> this series was moved to mm-stable a bit too fast for my taste.
> 
> It was nearly three weeks.

I'm sorry, I replied to the wrong mail. I thought this was:

[1] https://lkml.kernel.org/r/20240501042700.83974-1-ioworker0@gmail.com

Because *that* is in mm-stable now as well. The major rewrite in v3 
(sent April 29) that had no reviews but broke compilation and was resend 
in v4 (send May 1), to be moved to mm-stable on May 6.

That's certainly too rushed for my taste for something that is not high 
provide just before the merge window is about to open.

I have it on my review list, but was expecting this to not get moved to 
mm-stable at this point. I won't be able to review it this/next week. I 
see other people are reviewing it now.

> 
>> Review is still going on, can we still remove that from mm-stable?
> 
> I can rebase if needed.  Is there a reason to do so?  Nothing that
> can't be fixed up with followup patches?

This here is good to go and saw sufficient review. [1] was too fast for 
my taste, but it's up to you to decide if we want to fix that up piece 
by piece as more review happens.

-- 
Cheers,

David / dhildenb

