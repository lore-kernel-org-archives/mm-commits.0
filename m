Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC69C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 13:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCDE06115B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 13:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbhIHNGc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 09:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232870AbhIHNGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 09:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631106324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HoPJtnHGBsOc55e21GJcfBCbLNUNeFidP7o3s2TGU8E=;
        b=CBzaexboen1BofVl5ZVrIWi8R2DjKq04ZVXqdkuAGqIrc6Owmmnh759qGzUM3UkJoFwiss
        rnNFopTkjIvQrZv7JRr84o7OGl2bqZbEKK3wXLBngdCiJkGHhyEeaWuc+d395jAs1mp+Hj
        tHAGnlrNFqMshr2uxcOV6qVfoiLP/6s=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-y1DBh7yIP3GOS_NW9339cw-1; Wed, 08 Sep 2021 09:05:21 -0400
X-MC-Unique: y1DBh7yIP3GOS_NW9339cw-1
Received: by mail-lf1-f69.google.com with SMTP id y4-20020ac255a4000000b003e3d5adca9cso740130lfg.6
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 06:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HoPJtnHGBsOc55e21GJcfBCbLNUNeFidP7o3s2TGU8E=;
        b=R+6HjwfnWQJAH4SpQlVXHPE6Bsz9g1AdF8BBut9nkWZLsauGHsZINP5gkK714kpKrc
         B6fIvFE1I1rFy7xbVLZiPQXq5ZW5/q1D1KiQLi8lxtMD1UFjMRoT8mlUPf3g9Mdmho73
         VxS+L1SAFUVKyRyDP7MCkE3n08zdZ6Cm1dGbZdfO5mSGkryc638fCca+wbUE/upc2Mdc
         l5lbVMYI0Fu45u5BdV3ucN1Vy15NdsULrVcQqrTbf2h+y3HMSXjoGW0+D/nPdcGCWXHb
         1H2CeWjJi2B1LcA2wISDmmPZjFO+hzRbbW+FVtxlqSdfY5FAI+i0ytlMXK2lSSX3gZj5
         VihA==
X-Gm-Message-State: AOAM532bubRZMGcpiGxrEB7Ccz4iS7GOX+MtIGO95DpdczLwm9lWET+R
        R5+zYtDVsSpPLkzhe7MbmW2GOW/K0NxIWWN0BKf6SxKGp+518KTTcZTpTJ3qPBvMS1DGkx5CikD
        CPZoC7qO1GFb8wcHuYh2nXQ==
X-Received: by 2002:a05:651c:1103:: with SMTP id d3mr2648235ljo.445.1631106319467;
        Wed, 08 Sep 2021 06:05:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3MJC5oig2BAkkPz6RVuU0ggFNnkV977DKXhqjKirFuTwUrvqyiH9RYQSCGilEFF1HMkDXrA==
X-Received: by 2002:a05:651c:1103:: with SMTP id d3mr2648195ljo.445.1631106319157;
        Wed, 08 Sep 2021 06:05:19 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id o7sm237233lji.17.2021.09.08.06.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 06:05:18 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com
Subject: Re: [patch 031/147] mm, slub: protect put_cpu_partial() with disabled
 irqs instead of cmpxchg
To:     Andrew Morton <akpm@linux-foundation.org>, bigeasy@linutronix.de,
        cl@linux.com, efault@gmx.de, iamjoonsoo.kim@lge.com,
        jannh@google.com, linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        quic_qiancai@quicinc.com, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
References: <20210908025436.dvsgeCXAh%akpm@linux-foundation.org>
Message-ID: <d35ad130-c72a-c47b-9d00-5c7bb5196421@redhat.com>
Date:   Wed, 8 Sep 2021 15:05:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210908025436.dvsgeCXAh%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 08/09/2021 04.54, Andrew Morton wrote:
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
> 
> Jann Horn reported [1] the following theoretically possible race:
> 
>    task A: put_cpu_partial() calls preempt_disable()
>    task A: oldpage = this_cpu_read(s->cpu_slab->partial)
>    interrupt: kfree() reaches unfreeze_partials() and discards the page
>    task B (on another CPU): reallocates page as page cache
>    task A: reads page->pages and page->pobjects, which are actually
>    halves of the pointer page->lru.prev
>    task B (on another CPU): frees page
>    interrupt: allocates page as SLUB page and places it on the percpu partial list
>    task A: this_cpu_cmpxchg() succeeds
> 
>    which would cause page->pages and page->pobjects to end up containing
>    halves of pointers that would then influence when put_cpu_partial()
>    happens and show up in root-only sysfs files. Maybe that's acceptable,
>    I don't know. But there should probably at least be a comment for now
>    to point out that we're reading union fields of a page that might be
>    in a completely different state.
> 
> Additionally, the this_cpu_cmpxchg() approach in put_cpu_partial() is only
> safe against s->cpu_slab->partial manipulation in ___slab_alloc() if the
> latter disables irqs, otherwise a __slab_free() in an irq handler could
> call put_cpu_partial() in the middle of ___slab_alloc() manipulating
> ->partial and corrupt it.  This becomes an issue on RT after a local_lock
> is introduced in later patch.  The fix means taking the local_lock also in
> put_cpu_partial() on RT.
> 
> After debugging this issue, Mike Galbraith suggested [2] that to avoid
> different locking schemes on RT and !RT, we can just protect
> put_cpu_partial() with disabled irqs (to be converted to
> local_lock_irqsave() later) everywhere.  This should be acceptable as it's
> not a fast path, and moving the actual partial unfreezing outside of the
> irq disabled section makes it short, and with the retry loop gone the code
> can be also simplified.  In addition, the race reported by Jann should no
> longer be possible.

Based on my microbench[0] measurement changing preempt_disable to 
local_irq_save will cost us 11 cycles (TSC).  I'm not against the 
change, I just want people to keep this in mind.

On my E5-1650 v4 @ 3.60GHz:
  - preempt_disable(+enable)  cost: 11 cycles(tsc) 3.161 ns
  - local_irq_save (+restore) cost: 22 cycles(tsc) 6.331 ns

Notice the non-save/restore variant is superfast:
  - local_irq_disable(+enable) cost: 6 cycles(tsc) 1.844 ns


[0] 
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_sample.c

> [1] https://lore.kernel.org/lkml/CAG48ez1mvUuXwg0YPH5ANzhQLpbphqk-ZS+jbRz+H66fvm4FcA@mail.gmail.com/
> [2] https://lore.kernel.org/linux-rt-users/e3470ab357b48bccfbd1f5133b982178a7d2befb.camel@gmx.de/
> 
> Link: https://lkml.kernel.org/r/20210904105003.11688-32-vbabka@suse.cz
> Reported-by: Jann Horn <jannh@google.com>
> Suggested-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Qian Cai <quic_qiancai@quicinc.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/slub.c |   83 ++++++++++++++++++++++++++++------------------------
>   1 file changed, 45 insertions(+), 38 deletions(-)
> 
> --- a/mm/slub.c~mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg
> +++ a/mm/slub.c
> @@ -2025,7 +2025,12 @@ static inline void *acquire_slab(struct
>   	return freelist;
>   }
>   
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>   static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
> +#else
> +static inline void put_cpu_partial(struct kmem_cache *s, struct page *page,
> +				   int drain) { }
> +#endif
>   static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);
>   
>   /*
> @@ -2459,14 +2464,6 @@ static void unfreeze_partials_cpu(struct
>   		__unfreeze_partials(s, partial_page);
>   }
>   
> -#else	/* CONFIG_SLUB_CPU_PARTIAL */
> -
> -static inline void unfreeze_partials(struct kmem_cache *s) { }
> -static inline void unfreeze_partials_cpu(struct kmem_cache *s,
> -				  struct kmem_cache_cpu *c) { }
> -
> -#endif	/* CONFIG_SLUB_CPU_PARTIAL */
> -
>   /*
>    * Put a page that was just frozen (in __slab_free|get_partial_node) into a
>    * partial page slot if available.
> @@ -2476,46 +2473,56 @@ static inline void unfreeze_partials_cpu
>    */
>   static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
>   {
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
>   	struct page *oldpage;
> -	int pages;
> -	int pobjects;
> +	struct page *page_to_unfreeze = NULL;
> +	unsigned long flags;
> +	int pages = 0;
> +	int pobjects = 0;
>   
> -	preempt_disable();
> -	do {
> -		pages = 0;
> -		pobjects = 0;
> -		oldpage = this_cpu_read(s->cpu_slab->partial);
> +	local_irq_save(flags);
> +
> +	oldpage = this_cpu_read(s->cpu_slab->partial);
>   
> -		if (oldpage) {
> +	if (oldpage) {
> +		if (drain && oldpage->pobjects > slub_cpu_partial(s)) {
> +			/*
> +			 * Partial array is full. Move the existing set to the
> +			 * per node partial list. Postpone the actual unfreezing
> +			 * outside of the critical section.
> +			 */
> +			page_to_unfreeze = oldpage;
> +			oldpage = NULL;
> +		} else {
>   			pobjects = oldpage->pobjects;
>   			pages = oldpage->pages;
> -			if (drain && pobjects > slub_cpu_partial(s)) {
> -				/*
> -				 * partial array is full. Move the existing
> -				 * set to the per node partial list.
> -				 */
> -				unfreeze_partials(s);
> -				oldpage = NULL;
> -				pobjects = 0;
> -				pages = 0;
> -				stat(s, CPU_PARTIAL_DRAIN);
> -			}
>   		}
> +	}
>   
> -		pages++;
> -		pobjects += page->objects - page->inuse;
> +	pages++;
> +	pobjects += page->objects - page->inuse;
>   
> -		page->pages = pages;
> -		page->pobjects = pobjects;
> -		page->next = oldpage;
> -
> -	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
> -								!= oldpage);
> -	preempt_enable();
> -#endif	/* CONFIG_SLUB_CPU_PARTIAL */
> +	page->pages = pages;
> +	page->pobjects = pobjects;
> +	page->next = oldpage;
> +
> +	this_cpu_write(s->cpu_slab->partial, page);
> +
> +	local_irq_restore(flags);
> +
> +	if (page_to_unfreeze) {
> +		__unfreeze_partials(s, page_to_unfreeze);
> +		stat(s, CPU_PARTIAL_DRAIN);
> +	}
>   }
>   
> +#else	/* CONFIG_SLUB_CPU_PARTIAL */
> +
> +static inline void unfreeze_partials(struct kmem_cache *s) { }
> +static inline void unfreeze_partials_cpu(struct kmem_cache *s,
> +				  struct kmem_cache_cpu *c) { }
> +
> +#endif	/* CONFIG_SLUB_CPU_PARTIAL */
> +
>   static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
>   {
>   	unsigned long flags;
> _
> 

$ uname -a
Linux broadwell 5.14.0-net-next+ #612 SMP PREEMPT Wed Sep 8 10:10:04 
CEST 2021 x86_64 x86_64 x86_64 GNU/Linux


My config:

$ zcat /proc/config.gz | grep PREE
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y
CONFIG_PREEMPT_RCU=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set

