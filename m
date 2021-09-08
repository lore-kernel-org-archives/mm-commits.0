Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222E7C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 16:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0810161153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 16:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhIHQM5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346386AbhIHQM4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 12:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631117508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUxZ/+MbrnZB1clpNjfMApdQI0MDXAs5PNHhN+o12Ms=;
        b=USy9QY0z40brstvD4aRRcYA0SpjQi9qnK5WAFNpKmW8CGak7vRkG8rUH+aaze66i/J+biM
        /DKuCiGcm6xFJRunOqTqVkURf7fGbGQXDuakGcHPCgXtWzxaxGVcXgo/GDTGm8T9IS9hwL
        3sDMc2y1BjqZ6Ppg2J3Ua5J4LFleZTU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-AZRTLGdxN8u05MvDi4i8yQ-1; Wed, 08 Sep 2021 12:11:46 -0400
X-MC-Unique: AZRTLGdxN8u05MvDi4i8yQ-1
Received: by mail-lj1-f200.google.com with SMTP id a17-20020a2e7f11000000b001dbbb444489so1248521ljd.0
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 09:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TUxZ/+MbrnZB1clpNjfMApdQI0MDXAs5PNHhN+o12Ms=;
        b=6wjQFnqpXAJ+34dqSOmxWxyRRno0WO7louia+0oauPjo/tfbzuTenqEqNQjhN9kkb/
         qKW3g+NCbpLBhgUkltOyymk7dpLnMMk91XpUzU413495NdTm02AsFIJFmDAZiG2Wyy3Q
         eSKVAWoiYvodbAx7L79nFjU7eVcMsf6JGteB4UEDChOkgdhXxqowHGBD4ih1RzSnmbHQ
         wYzrwnJiNcemcbLlBUDGRnyBAQejp8eAQWnt5OKdgvQmnhLuZVj3F9TD/BdIpjO/34L1
         8dm04b5Xf0XFV0z+ohI+LwT83pQQrAMRTep+zX0cq+1rfLGKutyhEDFvqsAVVnL/QbtR
         otcw==
X-Gm-Message-State: AOAM532GRewg4KVsBDnxHBC4rGZuADJYXYP1E7canDQsMZMd/ilIdYWY
        V3CFMDlgCYoyb4zIL5N2Pdt/TL3zATn0KHojd8icGMghSwFL38FNPsMt4U9DNGugRbJkddPgO98
        y+nVFTgITY01e3nVVQ+ol4A==
X-Received: by 2002:a2e:7a12:: with SMTP id v18mr3293815ljc.204.1631117504827;
        Wed, 08 Sep 2021 09:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGU3Y6eSYjqKTQtWrjLosAwFUJyr0TPoFxGWqqrt1Qyu0OC2Dxsta51JVEQtEL0a78vg2sqw==
X-Received: by 2002:a2e:7a12:: with SMTP id v18mr3293803ljc.204.1631117504574;
        Wed, 08 Sep 2021 09:11:44 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id p14sm290447lji.56.2021.09.08.09.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 09:11:43 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com
Subject: Re: [patch 031/147] mm, slub: protect put_cpu_partial() with disabled
 irqs instead of cmpxchg
To:     Vlastimil Babka <vbabka@suse.cz>,
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
Message-ID: <0bc898a0-2c3f-a8db-ef19-e8c5ebc3ed71@redhat.com>
Date:   Wed, 8 Sep 2021 18:11:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c29dc2e4-df74-c5cc-9580-9cdff7e2a309@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 08/09/2021 15.58, Vlastimil Babka wrote:
> On 9/8/21 15:05, Jesper Dangaard Brouer wrote:
>>
>>
>> On 08/09/2021 04.54, Andrew Morton wrote:
>>> From: Vlastimil Babka <vbabka@suse.cz>
>>> Subject: mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
>>>
>>> Jann Horn reported [1] the following theoretically possible race:
>>>
>>>     task A: put_cpu_partial() calls preempt_disable()
>>>     task A: oldpage = this_cpu_read(s->cpu_slab->partial)
>>>     interrupt: kfree() reaches unfreeze_partials() and discards the page
>>>     task B (on another CPU): reallocates page as page cache
>>>     task A: reads page->pages and page->pobjects, which are actually
>>>     halves of the pointer page->lru.prev
>>>     task B (on another CPU): frees page
>>>     interrupt: allocates page as SLUB page and places it on the percpu partial list
>>>     task A: this_cpu_cmpxchg() succeeds
>>>
>>>     which would cause page->pages and page->pobjects to end up containing
>>>     halves of pointers that would then influence when put_cpu_partial()
>>>     happens and show up in root-only sysfs files. Maybe that's acceptable,
>>>     I don't know. But there should probably at least be a comment for now
>>>     to point out that we're reading union fields of a page that might be
>>>     in a completely different state.
>>>
>>> Additionally, the this_cpu_cmpxchg() approach in put_cpu_partial() is only
>>> safe against s->cpu_slab->partial manipulation in ___slab_alloc() if the
>>> latter disables irqs, otherwise a __slab_free() in an irq handler could
>>> call put_cpu_partial() in the middle of ___slab_alloc() manipulating
>>> ->partial and corrupt it.  This becomes an issue on RT after a local_lock
>>> is introduced in later patch.  The fix means taking the local_lock also in
>>> put_cpu_partial() on RT.
>>>
>>> After debugging this issue, Mike Galbraith suggested [2] that to avoid
>>> different locking schemes on RT and !RT, we can just protect
>>> put_cpu_partial() with disabled irqs (to be converted to
>>> local_lock_irqsave() later) everywhere.  This should be acceptable as it's
>>> not a fast path, and moving the actual partial unfreezing outside of the
>>> irq disabled section makes it short, and with the retry loop gone the code
>>> can be also simplified.  In addition, the race reported by Jann should no
>>> longer be possible.
>>
>> Based on my microbench[0] measurement changing preempt_disable to
>> local_irq_save will cost us 11 cycles (TSC).  I'm not against the
>> change, I just want people to keep this in mind.
> 
> OK, but this is not a fast path for every allocation/free, so it gets
> amortized. Also it eliminates a this_cpu_cmpxchg loop, and I'd expect
> cmpxchg to be expensive too?

Added tests for this:
  - this_cpu_cmpxchg cost: 5 cycles(tsc) 1.581 ns
  - cmpxchg          cost: 18 cycles(tsc) 5.006 ns

>> On my E5-1650 v4 @ 3.60GHz:
>>    - preempt_disable(+enable)  cost: 11 cycles(tsc) 3.161 ns
>>    - local_irq_save (+restore) cost: 22 cycles(tsc) 6.331 ns
>>
>> Notice the non-save/restore variant is superfast:
>>    - local_irq_disable(+enable) cost: 6 cycles(tsc) 1.844 ns
> 
> It actually surprises me that it's that cheap, and would have expected
> changing the irq state would be the costly part, not the saving/restoring.
> Incidentally, would you know what's the cost of save+restore when the
> irqs are already disabled, so it's effectively a no-op?

The non-save variant simply translated onto CLI and STI, which seems to 
be very fast.

The cost of save+restore when the irqs are already disabled is the same 
(did a quick test).
Cannot remember who told me, but (apparently) the expensive part is 
reading the CPU FLAGS.

I did a quick test with:

	/** Loop to measure **/
	for (i = 0; i < rec->loops; i++) {
		local_irq_save(flags);
		loops_cnt++;
		barrier();
		//local_irq_restore(flags);
		local_irq_enable();
	}

Doing a save + enable: This cost 21 cycles(tsc) 6.015 ns.
(Cost before was 22 cycles)

This confirms reading the CPU FLAGS seems to be the expensive part.

--Jesper

