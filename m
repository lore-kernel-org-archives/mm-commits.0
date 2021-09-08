Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FBAC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 08:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 220A7610E9
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 08:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351225AbhIHI6V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 04:58:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48830 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbhIHI6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 04:58:20 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A74C7221F7;
        Wed,  8 Sep 2021 08:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631091432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rWZ8ZcPRJbXrVzLYNwKLUmb40zyphrFktilRe6nIdcQ=;
        b=ZxRbRkFyf5ftgkHUpVvSWQ+4reCtY1ohE2YVWmOuIj+l8QnyE7xVgmdx3UJGK2Xq+N5KP2
        +V+C+B98wMxofinKDYwiBSP8DpWKK+/AE254ppXXJ44zcAGjMkYjGPumJuS41TQJKxmCyA
        zng7GQxypAiMEsFZjJIwPAwvo27I9yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631091432;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rWZ8ZcPRJbXrVzLYNwKLUmb40zyphrFktilRe6nIdcQ=;
        b=nXURT/JcJJKxVOylxnVLTmS8/Hanmdf5NUKx5UUzPPQpvnGFJwuAM3xQFyhUe0AWjDPVEc
        B/aRBnuwqrYe95CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 81C5C13CC6;
        Wed,  8 Sep 2021 08:57:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Tz8FBuh6OGHhLgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 08 Sep 2021 08:57:12 +0000
Message-ID: <979474b8-540c-ea23-bfa6-ba9d4e8ae28b@suse.cz>
Date:   Wed, 8 Sep 2021 10:57:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: incoming
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@techsingularity.net>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/8/21 04:52, Andrew Morton wrote:
> Subsystem: mm/slub
> 
>     Vlastimil Babka <vbabka@suse.cz>:
>     Patch series "SLUB: reduce irq disabled scope and make it RT compatible", v6:
>       mm, slub: don't call flush_all() from slab_debug_trace_open()
>       mm, slub: allocate private object map for debugfs listings
>       mm, slub: allocate private object map for validate_slab_cache()
>       mm, slub: don't disable irq for debug_check_no_locks_freed()
>       mm, slub: remove redundant unfreeze_partials() from put_cpu_partial()
>       mm, slub: extract get_partial() from new_slab_objects()
>       mm, slub: dissolve new_slab_objects() into ___slab_alloc()
>       mm, slub: return slab page from get_partial() and set c->page afterwards
>       mm, slub: restructure new page checks in ___slab_alloc()
>       mm, slub: simplify kmem_cache_cpu and tid setup
>       mm, slub: move disabling/enabling irqs to ___slab_alloc()
>       mm, slub: do initial checks in ___slab_alloc() with irqs enabled
>       mm, slub: move disabling irqs closer to get_partial() in ___slab_alloc()
>       mm, slub: restore irqs around calling new_slab()
>       mm, slub: validate slab from partial list or page allocator before making it cpu slab
>       mm, slub: check new pages with restored irqs
>       mm, slub: stop disabling irqs around get_partial()
>       mm, slub: move reset of c->page and freelist out of deactivate_slab()
>       mm, slub: make locking in deactivate_slab() irq-safe
>       mm, slub: call deactivate_slab() without disabling irqs
>       mm, slub: move irq control into unfreeze_partials()
>       mm, slub: discard slabs in unfreeze_partials() without irqs disabled
>       mm, slub: detach whole partial list at once in unfreeze_partials()
>       mm, slub: separate detaching of partial list in unfreeze_partials() from unfreezing
>       mm, slub: only disable irq with spin_lock in __unfreeze_partials()
>       mm, slub: don't disable irqs in slub_cpu_dead()
>       mm, slab: split out the cpu offline variant of flush_slab()
> 
>     Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
>       mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context
>       mm: slub: make object_map_lock a raw_spinlock_t
> 
>     Vlastimil Babka <vbabka@suse.cz>:
>       mm, slub: make slab_lock() disable irqs with PREEMPT_RT
>       mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
>       mm, slub: use migrate_disable() on PREEMPT_RT
>       mm, slub: convert kmem_cpu_slab protection to local_lock

For my own piece of mind, I've checked that this part (patches 1 to 33)
are identical to the v6 posting [1] and git version [2] that Mel and
Mike tested (replies to [1]).

[1] https://lore.kernel.org/all/20210904105003.11688-1-vbabka@suse.cz/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git
tags/mm-slub-5.15-rc1
