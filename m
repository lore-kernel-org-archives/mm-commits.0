Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5398C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8447261108
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347302AbhIHCzb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347381AbhIHCzb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:55:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB00061104;
        Wed,  8 Sep 2021 02:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069664;
        bh=MMXPuj0AP9WdGq2pJv2Y8OWvxpuw0OrfIxRYs+D9cu8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C+BnqEPJMnT++pZnx7jAIuOfkBrl9tf0kzMb7E/fJvbHxQQ984ZymP+qsusQmrl1Y
         uPEJZmlqwmKtpCAZIhtNQMdlY8VulWAufv4UDeFYntBOqZwfeEpi/x6rNSp3H6bKOg
         AuPrZqxhFn+btODyup9fH6b9n6Hb8iW8bRrkAlbo=
Date:   Tue, 07 Sep 2021 19:54:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 027/147] mm, slab: split out the cpu offline
 variant of flush_slab()
Message-ID: <20210908025423.Cch2XKUmy%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab: split out the cpu offline variant of flush_slab()

flush_slab() is called either as part IPI handler on given live cpu, or as
a cleanup on behalf of another cpu that went offline.  The first case
needs to protect updating the kmem_cache_cpu fields with disabled irqs. 
Currently the whole call happens with irqs disabled by the IPI handler,
but the following patch will change from IPI to workqueue, and
flush_slab() will have to disable irqs (to be replaced with a local lock
later) in the critical part.

To prepare for this change, replace the call to flush_slab() for the dead
cpu handling with an opencoded variant that will not disable irqs nor take
a local lock.

Link: https://lkml.kernel.org/r/20210904105003.11688-28-vbabka@suse.cz
Suggested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slab-split-out-the-cpu-offline-variant-of-flush_slab
+++ a/mm/slub.c
@@ -2511,9 +2511,17 @@ static inline void flush_slab(struct kme
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+	void *freelist = c->freelist;
+	struct page *page = c->page;
 
-	if (c->page)
-		flush_slab(s, c);
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
_
