Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE12C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 11:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71C9610CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 11:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhICLPv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 07:15:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43252 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhICLPv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 07:15:51 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 95B93203AE;
        Fri,  3 Sep 2021 11:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630667690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brtKzLBstuG13MxOxaz7PQWNBzMLCagnSeIfMXtZEa0=;
        b=j3ZjJ47jtrIN0lvF6KKegMAJAeNxz73L+EPcUwZ0oLkFObXhbko9ah8pQP39w3XPrd7sGt
        JzkgJWk/L+UTvIeOpcBGRHI/8BZKtZnq0JqJrfUPSRg5Mh8Vkl0nwi5uy0HsN3s9eCdwwE
        r/duXdegS845jf5MGqP9FEMU2XjxAWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630667690;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brtKzLBstuG13MxOxaz7PQWNBzMLCagnSeIfMXtZEa0=;
        b=CSLtqjkoEQQqUPwvD7UkjqDcwgbgKU2vpsMHC5oCzwu+rBKOrLEI8J/PCWqGP4ztEzZY+C
        MsGF7nl5dhs0BuDw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 5AB7313736;
        Fri,  3 Sep 2021 11:14:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id ZbviFKoDMmHrGQAAGKfGzw
        (envelope-from <vbabka@suse.cz>); Fri, 03 Sep 2021 11:14:50 +0000
Message-ID: <1ae902f7-c500-f9e8-1b4f-077beade0f42@suse.cz>
Date:   Fri, 3 Sep 2021 13:14:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [patch 036/212] mm, slab: make flush_slab() possible to call with
 irqs enabled
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
 <20210902215152.ibWfL_bvd%akpm@linux-foundation.org>
 <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
 <CAHk-=wiz+vp1k1Ag+fD57P4ehOpTAc=A9zT7YbGENUu57azeuQ@mail.gmail.com>
 <CAHk-=wiX77e3G-cOP+OLPzf8krQXgyiz7PikurJYa0fsDhS34Q@mail.gmail.com>
 <ec75906a-bf4d-cad0-dd66-cdf2b7d35b1e@suse.cz>
 <d406ebb42fb9914d1a6f2fe9f26bf083612ec796.camel@gmx.de>
 <4d2bdf47-618e-40cd-d7c2-4a06a4b28335@suse.cz>
In-Reply-To: <4d2bdf47-618e-40cd-d7c2-4a06a4b28335@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/3/21 09:03, Vlastimil Babka wrote:
> On 9/3/21 08:22, Mike Galbraith wrote:
>>> > so that when you read that function on its own, it's clear that the
>>> > lock is always held over that critical section - and the issue is that
>>> > perhaps the lock was already taken by the caller.
>>> 
>>> Actually that "already taken" becomes "caller does not need it/can't
> 
> Meant to say "... later in the series becomes ...".
> 
>>> even take the local lock as it's not local" (it's a cpu hot remove
>>> handler on behalf of another, dead cpu).
>>> 
>>> So would it work with something like the following cleanup on top later
>>> after proper testing? (now just compile tested).
>> 
>> To my eyeballs, below duplication of a couple lines of initialization
>> needed by the lockless function is less icky than the double return.
> 
> Yeah, that's better, thanks Mike.

Formal patch below, also added to my git branch:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slub-local-lock-v5r1

----8<----
From b67952ce67528f3ebeaae58e0eae22a6dbae64b5 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 3 Sep 2021 12:59:25 +0200
Subject: [PATCH] mm, slub: remove conditional locking parameter from
 flush_slab()

flush_slab() is called either as part of work scheduled on given live cpu, or
called as a cleanup for another cpu that went offline. In the first case it
needs to hold the cpu_slab->lock local lock when updating the protected
kmem_cache_cpu fields. This is now achieved by a "bool lock" parameter.

To avoid the conditional locking, we can instead lock unconditionally in
flush_slab() for live cpus, and opencode the variant without locking in
__flush_cpu_slab() for the dead cpus.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index df1ac8aff86f..77fe3d6d2065 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2566,15 +2566,13 @@ static inline void unfreeze_partials_cpu(struct kmem_cache *s,
 
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 
-static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
-			      bool lock)
+static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	unsigned long flags;
 	void *freelist;
 	struct page *page;
 
-	if (lock)
-		local_lock_irqsave(&s->cpu_slab->lock, flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 
 	freelist = c->freelist;
 	page = c->page;
@@ -2583,8 +2581,7 @@ static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
 	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
 
-	if (lock)
-		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
+	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
 	if (page)
 		deactivate_slab(s, page, freelist);
@@ -2595,9 +2592,17 @@ static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+	struct page *page = c->page;
+	void *freelist = c->freelist;
 
-	if (c->page)
-		flush_slab(s, c, false);
+	c->page = NULL;
+	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
+
+	if (page) {
+		deactivate_slab(s, page, freelist);
+		stat(s, CPUSLAB_FLUSH);
+	}
 
 	unfreeze_partials_cpu(s, c);
 }
@@ -2625,7 +2630,7 @@ static void flush_cpu_slab(struct work_struct *w)
 	c = this_cpu_ptr(s->cpu_slab);
 
 	if (c->page)
-		flush_slab(s, c, true);
+		flush_slab(s, c);
 
 	unfreeze_partials(s);
 }
-- 
2.33.0


 

