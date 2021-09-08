Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D1FC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 17:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566F561166
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 17:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352400AbhIHRPw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 13:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350179AbhIHRPv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 13:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631121281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ejqc40sWfMbE1YSHcLCom16WT8UJzripXSIXzFK8K1w=;
        b=AnZo5VnmhXDVVxIC9rb471Yrb+9EyZWvb5UDtx7HKnfELya/DX3ejA9zcvpySvKoh+E//0
        SUNccLOa3zyR7cNiyEz++uVvJIn7k8UFaVlijR7GiWCGQexADi0K8+aUGqP3t3KKF6LHh2
        qR7d0+hv5ypiubIi+VdUOh3PKGiWDeg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-HtEJm02kN0yPtfZlVNjLlg-1; Wed, 08 Sep 2021 13:14:40 -0400
X-MC-Unique: HtEJm02kN0yPtfZlVNjLlg-1
Received: by mail-lj1-f200.google.com with SMTP id v2-20020a2e5042000000b001def54ff19eso1310354ljd.2
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 10:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ejqc40sWfMbE1YSHcLCom16WT8UJzripXSIXzFK8K1w=;
        b=NpSOyiIicVrPes1GIbUniKcnA/TeLXlgB61kxr/e3UrsDrc/o3sYbAnobSB1IGbTv5
         J70Pr5Y+hZ9eBmSf9d/M3M0XiPMbYa6QLOOmFNNxrF5Hi8binFzQpLC4y0pEgxAFFrKN
         BkGjdQNBzdqZ5Bc7eZkAGswf04X3DjGTEJJNzuEuE1pxuS4vSdnn5BtoczAmSreKIR4Z
         G2ZXvtPDtc/IbWYNyw88BFqb7x9vbL6buXLeIowthzTqG900MUHDfdAslzkQZHiuvBH6
         OEKwosspsRIGunjNON3OBQOv4wd5+r8m25ptRtaxv/avjz4N6b/gewXlu/qqSm1YlBR7
         qslQ==
X-Gm-Message-State: AOAM531itQyAiVEYnxCPv7GtH7t0Bsmnyon8Syhy1k4mPD39oLT5EMcR
        MWR6PkeWyVsWrKUCpv6GhQTsQgn9NhAuSvsxuKY685pRjNyzMnrdeES5sOzIU209qdI5kQ3NlsI
        XLFa8nIu1EgitAUPGasi06A==
X-Received: by 2002:a05:651c:1683:: with SMTP id bd3mr3731264ljb.323.1631121278710;
        Wed, 08 Sep 2021 10:14:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+I/SsfLJUbJ18xeXxd4lV7F2XPmOj+17jTuyWR1+uDvSd+DyIl24dNLFt0ngeBrBrTTFKIQ==
X-Received: by 2002:a05:651c:1683:: with SMTP id bd3mr3731245ljb.323.1631121278468;
        Wed, 08 Sep 2021 10:14:38 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id r5sm243505lfm.2.2021.09.08.10.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 10:14:37 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com
Subject: Re: [patch 031/147] mm, slub: protect put_cpu_partial() with disabled
 irqs instead of cmpxchg
To:     David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        bigeasy@linutronix.de, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
References: <20210908025436.dvsgeCXAh%akpm@linux-foundation.org>
 <d35ad130-c72a-c47b-9d00-5c7bb5196421@redhat.com>
 <c29dc2e4-df74-c5cc-9580-9cdff7e2a309@suse.cz>
 <1a8ecf24-dca4-54f2-cdbf-9135b856b773@redhat.com>
 <6524bba5-f737-3ab4-ee90-d6c70bac04f7@redhat.com>
Message-ID: <3a83989f-aa36-3aee-d92f-5ddc912d7fc5@redhat.com>
Date:   Wed, 8 Sep 2021 19:14:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6524bba5-f737-3ab4-ee90-d6c70bac04f7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 08/09/2021 16.59, David Hildenbrand wrote:
> On 08.09.21 16:55, David Hildenbrand wrote:
>> On 08.09.21 15:58, Vlastimil Babka wrote:
>>> On 9/8/21 15:05, Jesper Dangaard Brouer wrote:
>>>>
>>>>
>>>> On 08/09/2021 04.54, Andrew Morton wrote:
>>>>> From: Vlastimil Babka <vbabka@suse.cz>
>>>>> Subject: mm, slub: protect put_cpu_partial() with disabled irqs 
>>>>> instead of cmpxchg
>>>>>
>>>>> Jann Horn reported [1] the following theoretically possible race:
>>>>>
>>>>>      task A: put_cpu_partial() calls preempt_disable()
>>>>>      task A: oldpage = this_cpu_read(s->cpu_slab->partial)
>>>>>      interrupt: kfree() reaches unfreeze_partials() and discards 
>>>>> the page
>>>>>      task B (on another CPU): reallocates page as page cache
>>>>>      task A: reads page->pages and page->pobjects, which are actually
>>>>>      halves of the pointer page->lru.prev
>>>>>      task B (on another CPU): frees page
>>>>>      interrupt: allocates page as SLUB page and places it on the 
>>>>> percpu partial list
>>>>>      task A: this_cpu_cmpxchg() succeeds
>>>>>
>>>>>      which would cause page->pages and page->pobjects to end up 
>>>>> containing
>>>>>      halves of pointers that would then influence when 
>>>>> put_cpu_partial()
>>>>>      happens and show up in root-only sysfs files. Maybe that's 
>>>>> acceptable,
>>>>>      I don't know. But there should probably at least be a comment 
>>>>> for now
>>>>>      to point out that we're reading union fields of a page that 
>>>>> might be
>>>>>      in a completely different state.
>>>>>
>>>>> Additionally, the this_cpu_cmpxchg() approach in put_cpu_partial() 
>>>>> is only
>>>>> safe against s->cpu_slab->partial manipulation in ___slab_alloc() 
>>>>> if the
>>>>> latter disables irqs, otherwise a __slab_free() in an irq handler 
>>>>> could
>>>>> call put_cpu_partial() in the middle of ___slab_alloc() manipulating
>>>>> ->partial and corrupt it.  This becomes an issue on RT after a 
>>>>> local_lock
>>>>> is introduced in later patch.  The fix means taking the local_lock 
>>>>> also in
>>>>> put_cpu_partial() on RT.
>>>>>
>>>>> After debugging this issue, Mike Galbraith suggested [2] that to avoid
>>>>> different locking schemes on RT and !RT, we can just protect
>>>>> put_cpu_partial() with disabled irqs (to be converted to
>>>>> local_lock_irqsave() later) everywhere.  This should be acceptable 
>>>>> as it's
>>>>> not a fast path, and moving the actual partial unfreezing outside 
>>>>> of the
>>>>> irq disabled section makes it short, and with the retry loop gone 
>>>>> the code
>>>>> can be also simplified.  In addition, the race reported by Jann 
>>>>> should no
>>>>> longer be possible.
>>>>
>>>> Based on my microbench[0] measurement changing preempt_disable to
>>>> local_irq_save will cost us 11 cycles (TSC).  I'm not against the
>>>> change, I just want people to keep this in mind.
>>>
>>> OK, but this is not a fast path for every allocation/free, so it gets
>>> amortized. Also it eliminates a this_cpu_cmpxchg loop, and I'd expect
>>> cmpxchg to be expensive too?
>>>
>>>> On my E5-1650 v4 @ 3.60GHz:
>>>>     - preempt_disable(+enable)  cost: 11 cycles(tsc) 3.161 ns
>>>>     - local_irq_save (+restore) cost: 22 cycles(tsc) 6.331 ns
>>>>
>>>> Notice the non-save/restore variant is superfast:
>>>>     - local_irq_disable(+enable) cost: 6 cycles(tsc) 1.844 ns
>>>
>>> It actually surprises me that it's that cheap, and would have expected
>>> changing the irq state would be the costly part, not the 
>>> saving/restoring.
>>> Incidentally, would you know what's the cost of save+restore when the
>>> irqs are already disabled, so it's effectively a no-op?
>>
>> It surprises me as well. That would imply that protecting short RCU
>> sections using
>>
>> local_irq_disable
>> local_irq_enable
>>
>> instead of via
>>
>> preempt_disable
>> preempt_enable
>>
>> would actually be very beneficial.

Please don't draw this as a general conclusion.
As Linus describe in details, the IRQ disable/enable will be very 
micro-arch specific.

The preempt_disable/enable will likely be more stable/consistent across 
micro-archs.
Keep an eye out for kernel config options when juding 
preempt_disable/enable performance [1]

[1] 
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_sample.c#L363-L367


>>
>> Are the numbers trustworthy? :)
>>
> 
> .. and especially did the benchmark consider side effects of 
> enabling/disabling interrupts (pipeline flushes etc ..)?
> 

Of-cause not, this is a microbenchmark... they are per definition not 
trustworthy :-P

-Jesper

