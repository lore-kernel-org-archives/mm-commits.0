Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E1AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 05:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B9C760FC0
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 05:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhICF1u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 01:27:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36796 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbhICF1u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 01:27:50 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D2BC51FD71;
        Fri,  3 Sep 2021 05:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630646809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GF/nflfmQ/5bocpoY6D5FROgSupVBFc/AXJNEOSO2Ow=;
        b=Q2TeNxAP9uoXj4QPIVSTzd+VMwJTSJdKE7oB86l+kQ0fDVHQuyUkQdMZYjMUovvkuWetCz
        f1BD30mxrNfYIsU+vQ6WtKOyTrDazF+BSCYHaAEZcNX5r/n3cpTTEUpFfLg2KBuQE7Ot5A
        jqWisDDpI664O2UuICpvGdQnWowFORU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630646809;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GF/nflfmQ/5bocpoY6D5FROgSupVBFc/AXJNEOSO2Ow=;
        b=wU6m5iVw9DjeZMN2sACT0DKU5uhF7HvUkjbrZDJSoCvTnHkOmric6Rxf87BSjtU5BBA9Lo
        2Bc8aAw7ujVgAbBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C1E2A13B1D;
        Fri,  3 Sep 2021 05:26:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id H/bfLRiyMWFQIgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 03 Sep 2021 05:26:48 +0000
Subject: Re: [patch 036/212] mm, slab: make flush_slab() possible to call with
 irqs enabled
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Mike Galbraith <efault@gmx.de>,
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
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <ec75906a-bf4d-cad0-dd66-cdf2b7d35b1e@suse.cz>
Date:   Fri, 3 Sep 2021 07:26:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiX77e3G-cOP+OLPzf8krQXgyiz7PikurJYa0fsDhS34Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On 9/3/21 1:51 AM, Linus Torvalds wrote:
> [ Talking to myself while mulling this series over ... ]
> 
> On Thu, Sep 2, 2021 at 4:34 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Instead of having it lock/unlock halfway through the function (and
>> have magic "Oh, the caller already holds the lock, so don't lock"
>> semantics except with misleading names) I really think that function
>> should just have been split in two, and then the locked region can be
>> minimized in the caller only taking it for the first part.

Normally I would have done that, similarly to " [patch 033/212] mm,
slub: separate detaching of partial list in unfreeze_partials() from
unfreezing"

> If there's some reason why it can't sanely be split into two (too many
> common variables or some odd control flow or whatever), at least the
> locking logic should be changed from

I think what discouraged me was that the second part is to call
deactivate_slab() and to that we need to return two values
from the first part (page and freelist), so one of them has to be a
return parameter. On the other hand the second part does so little
it can be opencoded. See below.

> 
>       if (lock)
>                local_irq_save(flags);
> 
> to something along the lines of
> 
>       if (!caller_already_locked)
>                local_irq_save(flags);
> 
> so that when you read that function on its own, it's clear that the
> lock is always held over that critical section - and the issue is that
> perhaps the lock was already taken by the caller.

Actually that "already taken" becomes "caller does not need it/can't
even take the local lock as it's not local" (it's a cpu hot remove
handler on behalf of another, dead cpu).

So would it work with something like the following cleanup on top later
after proper testing? (now just compile tested).
---8<---
diff --git a/mm/slub.c b/mm/slub.c
index df1ac8aff86f..0d9e63e918f1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2566,38 +2566,33 @@ static inline void unfreeze_partials_cpu(struct kmem_cache *s,
 
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 
-static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
-			      bool lock)
+static inline struct page *
+__detach_cpu_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
+		  void **freelist)
 {
-	unsigned long flags;
-	void *freelist;
 	struct page *page;
 
-	if (lock)
-		local_lock_irqsave(&s->cpu_slab->lock, flags);
-
-	freelist = c->freelist;
 	page = c->page;
+	*freelist = c->freelist;
 
 	c->page = NULL;
 	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
 
-	if (lock)
-		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
-
-	if (page)
-		deactivate_slab(s, page, freelist);
-
-	stat(s, CPUSLAB_FLUSH);
+	return page;
 }
 
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+	struct page *page;
+	void *freelist;
 
-	if (c->page)
-		flush_slab(s, c, false);
+	if (c->page) {
+		page = __detach_cpu_slab(s, c, &freelist);
+		deactivate_slab(s, page, freelist);
+		stat(s, CPUSLAB_FLUSH);
+	}
 
 	unfreeze_partials_cpu(s, c);
 }
@@ -2618,14 +2613,24 @@ static void flush_cpu_slab(struct work_struct *w)
 	struct kmem_cache *s;
 	struct kmem_cache_cpu *c;
 	struct slub_flush_work *sfw;
+	struct page *page;
+	void *freelist;
+	unsigned long flags;
 
 	sfw = container_of(w, struct slub_flush_work, work);
 
 	s = sfw->s;
 	c = this_cpu_ptr(s->cpu_slab);
 
-	if (c->page)
-		flush_slab(s, c, true);
+	if (c->page) {
+		local_lock_irqsave(&s->cpu_slab->lock, flags);
+		page = __detach_cpu_slab(s, c, &freelist);
+		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
+
+		if (page)
+			deactivate_slab(s, page, freelist);
+		stat(s, CPUSLAB_FLUSH);
+	}
 
 	unfreeze_partials(s);
 }
