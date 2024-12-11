Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C4E19CCF4
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733928837; cv=none; b=isqQ+VribwtLkeke5r63ySjBrHdv/XeMVb05aFTQfRgqMW/dBsBobIukEBsys/I2BMpMrSwVHfffvK2uQveHpeelb1KzwNIDrutHoRIwGlL0PKU9Tn6UamDAlHH9Xv1ljApTiJRqRpmuvgYkE3r1E3fKYXKNnzZyTTJqgoh39WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733928837; c=relaxed/simple;
	bh=CCrxpTvEG1fhSckaniqxY4Ws/Wv9InByBoFOQdbTlHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OqePZMI4SrIhqxEXhM2RqCcgZzmAUZPrbbdwoU5kiS+zzxxbYO/fw2hW6uwwJWjBMa6MqpCfjK8oX8voCWKf4Rd+qTojol+oM9C+/pX55EvvIZBZO/RkNSDPxp/KNp7O3AiEkSjPxQOsD4RBT/OqheyVVxky7xqUJdITxjWEcyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Mh2pY0ti; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Mh2pY0ti"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-725f4623df7so3141037b3a.2
        for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 06:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1733928834; x=1734533634; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4LOfo84l1MwONL67IInbcg65IOfZxQJkCGPTEONrmfw=;
        b=Mh2pY0tiP62m9G9VDUPE2gahUXu3hoepeK+K86VeODFC5ROnlJ9dGTW8m9NHn1Rlp4
         t+NNXAnpZ7qVBrh344NpAQkTA4lQaT77JgSZR2KqcOifAWikm4QghH8psaeQhownmdw0
         NIS8l0c4bNeG5NtwmkgNTJp8iUiLlmxaZvdWIxxd3fL8THNF5/w2n1szPFIo3PaIsvJV
         AP1v05bVeflUXRyGvC1HCxEFBCeAusO6Txj9bFP+a7BVQabvVfAOj8H52FYVIKOGhLbm
         1yl2o6B02/9ckI7jLwZu0aPQcdBeFdbMJGoFW1POZqCiTGpZe1DJ5BJ0nY3L+W6grpkk
         iR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733928834; x=1734533634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4LOfo84l1MwONL67IInbcg65IOfZxQJkCGPTEONrmfw=;
        b=HGeD1RgOsIXlpczofKmgNvMBeHs8jou7zgwxwQCk1+w83hJKOUKr8ac1nPCn48I0P/
         Lx3xlJ1m4xJlEptyofH+IbH9Ar6zo2lwLfksCZckWT7UCF+iZmoxI/J4eIOI9oFOdDOh
         xBSYfPlufukj4MI6zd1yzZQ40g8cAh4H9aQpdDYXvBbaVGnLrSYw6R5aaZTqtbYJ3oVb
         iek7qAhHwLbq1lbCjbrnUD95K7uj+J6ryZ4JkhRHNiPM5215AAEgDSMliku9ioNmt9f6
         jKiwi/TWYRFLFujCdExgIJFV/hTUM4OspUpeJwIgIPnKy0tNSmHZU+WhRLWTH6iVBIsF
         0LOg==
X-Forwarded-Encrypted: i=1; AJvYcCUovQ3TIdPvzvcE1jtr/nu2h42vaPMHRZLflzPfz5+SlPL4332AR2orK7BgJNkEaYWw6uJwxH8Hxv77@vger.kernel.org
X-Gm-Message-State: AOJu0YzxWFgKqjUP9BgI4Po6CY5mRUI71fZLk9vZAlWmih79gDV1FoKv
	nilrlZ8bIfG9PSPDCRHublH5lKonfjMsM8MSAgLp/WUesufsL3ApF0Ceh5z5H/I=
X-Gm-Gg: ASbGncsNxX8PZ/eA9SH6+uwjFtM8ViixnLWr58ujEQWR2wNnTeAmIyybokMKvtn7kmg
	lL24gD5tmf/5H9jaCOWuAcKX6BE8LqOZeTGX2pOajwiNlW7PWbOwHHCb+vsORY+HtMud55tByEK
	ErwaqMFqAtQZFrNu8H5rFrJgU67JEoUnfT9RwskjnTW4IPolJTiVzFCe4sFxUOgmPjUwN4lg1AA
	sAmWf8zCEOl8vfkKM8jGsFKbPQZC6VwA4r+rQ/+lq10Ey/H27Hpf9Zee5CLnJR1KYdImU1S5kU5
	oNuWgcLoeBA6WSHWoc7AE2+tEXWa/Gc/Ge8Ef3G5D3NuPU3I+A==
X-Google-Smtp-Source: AGHT+IFP/9kjpQmjn06cyD+by/lnWpWOMgvy2lrYnBDj2VQ2i3l6WdMoFpDwm0IamyrH65HcbiEyyA==
X-Received: by 2002:a05:6a20:d50c:b0:1e0:d7ec:5aae with SMTP id adf61e73a8af0-1e1c126ef4dmr5684813637.4.1733928834302;
        Wed, 11 Dec 2024 06:53:54 -0800 (PST)
Received: from ?IPV6:2409:8a28:f4f:a9a4:78ea:e338:289:89ae? ([2409:8a28:f4f:a9a4:78ea:e338:289:89ae])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725c7cba42fsm8811099b3a.123.2024.12.11.06.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 06:53:53 -0800 (PST)
Message-ID: <9961dda2-a857-4c82-8d2e-e8ab035f8ecc@bytedance.com>
Date: Wed, 11 Dec 2024 22:53:45 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-pgtable-make-ptlock-be-freed-by-rcu.patch added to
 mm-unstable branch
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 zokeefe@google.com, willy@infradead.org, will@kernel.org,
 rientjes@google.com, peterx@redhat.com, muchun.song@linux.dev,
 mgorman@suse.de, luto@kernel.org, lorenzo.stoakes@oracle.com,
 jannh@google.com, hughd@google.com, david@redhat.com,
 dave.hansen@linux.intel.com, dan.carpenter@linaro.org,
 catalin.marinas@arm.com, Thomas Gleixner <tglx@linutronix.de>,
 Mark Rutland <mark.rutland@arm.com>
References: <20241211030932.4DA94C4CED6@smtp.kernel.org>
 <20241211091202.GS21636@noisy.programming.kicks-ass.net>
 <e8ec5fa7-8742-4e30-afbf-279d09c49d6c@bytedance.com>
 <20241211125630.GT21636@noisy.programming.kicks-ass.net>
 <20241211133433.GC12500@noisy.programming.kicks-ass.net>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20241211133433.GC12500@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Peter,

On 2024/12/11 21:34, Peter Zijlstra wrote:
> On Wed, Dec 11, 2024 at 01:56:30PM +0100, Peter Zijlstra wrote:
>> On Wed, Dec 11, 2024 at 06:31:31PM +0800, Qi Zheng wrote:
>>
>>> Now, it is also possible not to use the mmu gather mechanism to
>>> free PTE pages:
>>>
>>> pte_free_tlb
>>> --> ___pte_free_tlb
>>>      --> pagetable_pte_dtor
>>> 	--> ptlock_free
>>>          paravirt_tlb_remove_table
>>> 	--> free PTE page
>>>
>>> pte_free
>>> --> pagetable_pte_dtor
>>>      --> ptlock_free
>>>      pagetable_free
>>>
>>> If we want to move the freeing of the ptlock into __tlb_remove_table(),
>>> we may need to define a pagetable_pte_dtor_no_ptlock() and let
>>> ___pte_free_tlb() to call it.
>>>
>>> And ALLOC_SPLIT_PTLOCKS only be enabled when the spinlock debug function
>>> is turned on, so I finally choose to only change ptlock itself without
>>> changing the general path.
>>
>> PREEMPT_RT will also have it on, and it feels a bit odd to have two
>> disparate RCU frees for something so very closely related.

Got it.

>>
>> We could push the whole of pagetable_*_dtor into tlb_remove_table(),
>> except that seems to cause trouble for p4d, which is not conforming.
>>
>> Argh, all this is a giant trainwreck and needs some serious cleanup, and

Indeed.

>> I feel your patch is just making it worse.

:(

>>
>> Notably:
>>
>>   - s390 pud isn't calling the existing pagetable_pud_[cd]tor()
>>   - none of the p4d things have pagetable_p4d_[cd]tor() (x86,arm64,s390,riscv)
>>     and they have inconsistent accounting
>>   - while much of the _ctor calls are in generic code, many of the _dtor
>>     calls are in arch code for hysterial raisins, this could easily be
>>     fixed
>>   - if we fix ptlock_free() to handle NULL, then all the _dtor()
>>     functions can use it, and we can observe they're all identical
>>     and can be folded
>>
>> after all that cleanup, you can move the _dtor from *_free_tlb() into
>> tlb_remove_table() -- which for the above case, would then have it
>> called from __tlb_remove_table_free().
>>
>> Thomas, you were looking for technical debt -- there's a ton of that
>> around here :/
> 
> Some of the above are in the below... I gave up after a while.

Thank you for such a detail suggestion! I will try to digest it and
implement it.

Thanks!

