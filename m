Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C06C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 13:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0BC26113E
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 13:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhIHN7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 09:59:10 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39108 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbhIHN7K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 09:59:10 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AA2CA2229B;
        Wed,  8 Sep 2021 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631109481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VwLMtH1a4NnketWGtljvSroSdzZN2fj/OwwtfB/1YUs=;
        b=hmhuFhvuJ17CgO5j3Fej5eRyrk6p+AFhoEfVTWD2rMxQqrIt6pQxkAGr05FhaHGaIcvsWQ
        Pin1p2cvVssCD23gNGGS5Xi7vH/HNJ3QrKBZnQq4YYA3Bg0I4I5E/zBsa5B0VKTbiLQyHt
        oo5MPGTgviVoC3KjgIScY84gZxIWhMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631109481;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VwLMtH1a4NnketWGtljvSroSdzZN2fj/OwwtfB/1YUs=;
        b=vw64L98eormfgdg2lDBcxjd8hi1bB5bN7e3NViAhMTY5GxyBkt8H70GFhbSSd7vCcjq2wy
        4MpmfS5rKzlI0MBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7BE5F13A1E;
        Wed,  8 Sep 2021 13:58:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id j1WzHWnBOGHGCwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 08 Sep 2021 13:58:01 +0000
Message-ID: <c29dc2e4-df74-c5cc-9580-9cdff7e2a309@suse.cz>
Date:   Wed, 8 Sep 2021 15:58:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [patch 031/147] mm, slub: protect put_cpu_partial() with disabled
 irqs instead of cmpxchg
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        bigeasy@linutronix.de, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Cc:     brouer@redhat.com
References: <20210908025436.dvsgeCXAh%akpm@linux-foundation.org>
 <d35ad130-c72a-c47b-9d00-5c7bb5196421@redhat.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <d35ad130-c72a-c47b-9d00-5c7bb5196421@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/8/21 15:05, Jesper Dangaard Brouer wrote:
> 
> 
> On 08/09/2021 04.54, Andrew Morton wrote:
>> From: Vlastimil Babka <vbabka@suse.cz>
>> Subject: mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
>>
>> Jann Horn reported [1] the following theoretically possible race:
>>
>>    task A: put_cpu_partial() calls preempt_disable()
>>    task A: oldpage = this_cpu_read(s->cpu_slab->partial)
>>    interrupt: kfree() reaches unfreeze_partials() and discards the page
>>    task B (on another CPU): reallocates page as page cache
>>    task A: reads page->pages and page->pobjects, which are actually
>>    halves of the pointer page->lru.prev
>>    task B (on another CPU): frees page
>>    interrupt: allocates page as SLUB page and places it on the percpu partial list
>>    task A: this_cpu_cmpxchg() succeeds
>>
>>    which would cause page->pages and page->pobjects to end up containing
>>    halves of pointers that would then influence when put_cpu_partial()
>>    happens and show up in root-only sysfs files. Maybe that's acceptable,
>>    I don't know. But there should probably at least be a comment for now
>>    to point out that we're reading union fields of a page that might be
>>    in a completely different state.
>>
>> Additionally, the this_cpu_cmpxchg() approach in put_cpu_partial() is only
>> safe against s->cpu_slab->partial manipulation in ___slab_alloc() if the
>> latter disables irqs, otherwise a __slab_free() in an irq handler could
>> call put_cpu_partial() in the middle of ___slab_alloc() manipulating
>> ->partial and corrupt it.  This becomes an issue on RT after a local_lock
>> is introduced in later patch.  The fix means taking the local_lock also in
>> put_cpu_partial() on RT.
>>
>> After debugging this issue, Mike Galbraith suggested [2] that to avoid
>> different locking schemes on RT and !RT, we can just protect
>> put_cpu_partial() with disabled irqs (to be converted to
>> local_lock_irqsave() later) everywhere.  This should be acceptable as it's
>> not a fast path, and moving the actual partial unfreezing outside of the
>> irq disabled section makes it short, and with the retry loop gone the code
>> can be also simplified.  In addition, the race reported by Jann should no
>> longer be possible.
> 
> Based on my microbench[0] measurement changing preempt_disable to 
> local_irq_save will cost us 11 cycles (TSC).  I'm not against the 
> change, I just want people to keep this in mind.

OK, but this is not a fast path for every allocation/free, so it gets
amortized. Also it eliminates a this_cpu_cmpxchg loop, and I'd expect
cmpxchg to be expensive too?

> On my E5-1650 v4 @ 3.60GHz:
>   - preempt_disable(+enable)  cost: 11 cycles(tsc) 3.161 ns
>   - local_irq_save (+restore) cost: 22 cycles(tsc) 6.331 ns
> 
> Notice the non-save/restore variant is superfast:
>   - local_irq_disable(+enable) cost: 6 cycles(tsc) 1.844 ns

It actually surprises me that it's that cheap, and would have expected
changing the irq state would be the costly part, not the saving/restoring.
Incidentally, would you know what's the cost of save+restore when the
irqs are already disabled, so it's effectively a no-op?

Thanks,
Vlastimil
