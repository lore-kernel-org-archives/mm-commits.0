Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD65C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 14:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07AC610FF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 14:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347994AbhIHPAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 11:00:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352030AbhIHPAW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 11:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631113154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JddFk7V5OzJJqqpk6r3LOWHcaS8mo6s0hrLkLoQnq1A=;
        b=P/7UAePl1WiiGpW2Kp61kr8RvrkdnFtNzmMMIj4ChjPUuhv9XWRZ1c1e2VbuQB13x2+fGp
        AUaxdq1enxcBg2U0FhtQ7O3DQisUhqP1jfF80/o3pyge8b2xYiD46YgGlOwB4WADvE71a5
        ZMfUqIrva5yxnL/wq4EiBIQcX6Y0ElU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-mngQ3GxbPJuOoVMh_fN8Bw-1; Wed, 08 Sep 2021 10:59:13 -0400
X-MC-Unique: mngQ3GxbPJuOoVMh_fN8Bw-1
Received: by mail-wm1-f69.google.com with SMTP id s197-20020a1ca9ce000000b002e72ba822dcso1184840wme.6
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 07:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JddFk7V5OzJJqqpk6r3LOWHcaS8mo6s0hrLkLoQnq1A=;
        b=NVs2bnV3DjPfSDngPb8bc0uDc4YqiuYwg10WZ0p7qil0U3jo6iMUzaFiEov3NpcRP/
         nTIqhAN8Z8Wprj2claQu+toowt1g294nd/UgfbjbMs4gQH9mC2mXo0LWod82Isb/zkET
         mQCNgAPOFH0Xm/zqRHDwZS+/8Mg58elnpTo7CrIkbaPzYtH5S6RkinJSJf30o/yJH6ye
         hY/H4tr7yg6p6tC0B0w3VdI6GEKHwu3xVSX1+Cc9hWzkuQfQwi/T+n5QS+N8aXVNMR/b
         O5phd9lqFiR3iqs1O9wfAifH6bAqKlha/5BuBYmOmOcTBaEzqDp73Pei5shoniSSw85T
         p5BA==
X-Gm-Message-State: AOAM530gcKxzwEze4PKa8ANW4+P5huefkF54UOCnm8/9Whc0ht4BdmFp
        2eP20BoUscSbkS81BDB4o40MfONTAjxIBqo4duoVPdLxBwxDhGw1DJ0XL26JLE5KJkQJM5+sPWa
        qh/W7wFqY7sAeUENhsrT66Q==
X-Received: by 2002:a7b:c316:: with SMTP id k22mr4145923wmj.56.1631113152527;
        Wed, 08 Sep 2021 07:59:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3hMM7PtyOhlB68VzldcctPar2Oy21UrjsG+VDVtz0IzObwSSHWWA0YXRBb0PuerDrMg2xYQ==
X-Received: by 2002:a7b:c316:: with SMTP id k22mr4145884wmj.56.1631113152281;
        Wed, 08 Sep 2021 07:59:12 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6125.dip0.t-ipconnect.de. [91.12.97.37])
        by smtp.gmail.com with ESMTPSA id o2sm2529573wrh.13.2021.09.08.07.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 07:59:11 -0700 (PDT)
Subject: Re: [patch 031/147] mm, slub: protect put_cpu_partial() with disabled
 irqs instead of cmpxchg
From:   David Hildenbrand <david@redhat.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        bigeasy@linutronix.de, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Cc:     brouer@redhat.com
References: <20210908025436.dvsgeCXAh%akpm@linux-foundation.org>
 <d35ad130-c72a-c47b-9d00-5c7bb5196421@redhat.com>
 <c29dc2e4-df74-c5cc-9580-9cdff7e2a309@suse.cz>
 <1a8ecf24-dca4-54f2-cdbf-9135b856b773@redhat.com>
Organization: Red Hat
Message-ID: <6524bba5-f737-3ab4-ee90-d6c70bac04f7@redhat.com>
Date:   Wed, 8 Sep 2021 16:59:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1a8ecf24-dca4-54f2-cdbf-9135b856b773@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 08.09.21 16:55, David Hildenbrand wrote:
> On 08.09.21 15:58, Vlastimil Babka wrote:
>> On 9/8/21 15:05, Jesper Dangaard Brouer wrote:
>>>
>>>
>>> On 08/09/2021 04.54, Andrew Morton wrote:
>>>> From: Vlastimil Babka <vbabka@suse.cz>
>>>> Subject: mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
>>>>
>>>> Jann Horn reported [1] the following theoretically possible race:
>>>>
>>>>      task A: put_cpu_partial() calls preempt_disable()
>>>>      task A: oldpage = this_cpu_read(s->cpu_slab->partial)
>>>>      interrupt: kfree() reaches unfreeze_partials() and discards the page
>>>>      task B (on another CPU): reallocates page as page cache
>>>>      task A: reads page->pages and page->pobjects, which are actually
>>>>      halves of the pointer page->lru.prev
>>>>      task B (on another CPU): frees page
>>>>      interrupt: allocates page as SLUB page and places it on the percpu partial list
>>>>      task A: this_cpu_cmpxchg() succeeds
>>>>
>>>>      which would cause page->pages and page->pobjects to end up containing
>>>>      halves of pointers that would then influence when put_cpu_partial()
>>>>      happens and show up in root-only sysfs files. Maybe that's acceptable,
>>>>      I don't know. But there should probably at least be a comment for now
>>>>      to point out that we're reading union fields of a page that might be
>>>>      in a completely different state.
>>>>
>>>> Additionally, the this_cpu_cmpxchg() approach in put_cpu_partial() is only
>>>> safe against s->cpu_slab->partial manipulation in ___slab_alloc() if the
>>>> latter disables irqs, otherwise a __slab_free() in an irq handler could
>>>> call put_cpu_partial() in the middle of ___slab_alloc() manipulating
>>>> ->partial and corrupt it.  This becomes an issue on RT after a local_lock
>>>> is introduced in later patch.  The fix means taking the local_lock also in
>>>> put_cpu_partial() on RT.
>>>>
>>>> After debugging this issue, Mike Galbraith suggested [2] that to avoid
>>>> different locking schemes on RT and !RT, we can just protect
>>>> put_cpu_partial() with disabled irqs (to be converted to
>>>> local_lock_irqsave() later) everywhere.  This should be acceptable as it's
>>>> not a fast path, and moving the actual partial unfreezing outside of the
>>>> irq disabled section makes it short, and with the retry loop gone the code
>>>> can be also simplified.  In addition, the race reported by Jann should no
>>>> longer be possible.
>>>
>>> Based on my microbench[0] measurement changing preempt_disable to
>>> local_irq_save will cost us 11 cycles (TSC).  I'm not against the
>>> change, I just want people to keep this in mind.
>>
>> OK, but this is not a fast path for every allocation/free, so it gets
>> amortized. Also it eliminates a this_cpu_cmpxchg loop, and I'd expect
>> cmpxchg to be expensive too?
>>
>>> On my E5-1650 v4 @ 3.60GHz:
>>>     - preempt_disable(+enable)  cost: 11 cycles(tsc) 3.161 ns
>>>     - local_irq_save (+restore) cost: 22 cycles(tsc) 6.331 ns
>>>
>>> Notice the non-save/restore variant is superfast:
>>>     - local_irq_disable(+enable) cost: 6 cycles(tsc) 1.844 ns
>>
>> It actually surprises me that it's that cheap, and would have expected
>> changing the irq state would be the costly part, not the saving/restoring.
>> Incidentally, would you know what's the cost of save+restore when the
>> irqs are already disabled, so it's effectively a no-op?
> 
> It surprises me as well. That would imply that protecting short RCU
> sections using
> 
> local_irq_disable
> local_irq_enable
> 
> instead of via
> 
> preempt_disable
> preempt_enable
> 
> would actually be very beneficial.
> 
> Are the numbers trustworthy? :)
> 

.. and especially did the benchmark consider side effects of 
enabling/disabling interrupts (pipeline flushes etc ..)?

-- 
Thanks,

David / dhildenb

