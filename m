Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BB4C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D346D611BF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbhIIVBh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241083AbhIIVBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA5161026;
        Thu,  9 Sep 2021 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221223;
        bh=uN2rcfQEMekEqeEiE5uijF3XZ2HI7p929uKv5cWK6Bg=;
        h=Date:From:To:Subject:From;
        b=mGy+4lF40a/HsA7I5U+6ENHomTAHsaqlWgBP0TIkbGwhyhSrOyUcPIcNHZAPqyqEt
         6NnOzgQs5ONEblAam7sisQ3bqb3ItyaXb3GJ/699HFv7cEIsmvk3ISQOLq268Ozxkj
         jzZDFGHEZo/OZaL85LuoGgolK6hIiMi+AdUx8wn4=
Date:   Thu, 09 Sep 2021 14:00:22 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
 removed from -mm tree
Message-ID: <20210909210022.xctGJqwJM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: remove redundant unfreeze_partials() from put_cpu_partial()
has been removed from the -mm tree.  Its filename was
     mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: remove redundant unfreeze_partials() from put_cpu_partial()

Commit d6e0b7fa1186 ("slub: make dead caches discard free slabs
immediately") introduced cpu partial flushing for kmemcg caches, based on
setting the target cpu_partial to 0 and adding a flushing check in
put_cpu_partial().  This code that sets cpu_partial to 0 was later moved
by c9fc586403e7 ("slab: introduce __kmemcg_cache_deactivate()") and
ultimately removed by 9855609bde03 ("mm: memcg/slab: use a single set of
kmem_caches for all accounted allocations").  However the check and flush
in put_cpu_partial() was never removed, although it's effectively a dead
code.  So this patch removes it.

Note that d6e0b7fa1186 also added preempt_disable()/enable() to
unfreeze_partials() which could be thus also considered unnecessary.  But
further patches will rely on it, so keep it.

Link: https://lkml.kernel.org/r/20210904105003.11688-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/slub.c~mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial
+++ a/mm/slub.c
@@ -2466,13 +2466,6 @@ static void put_cpu_partial(struct kmem_
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
-	if (unlikely(!slub_cpu_partial(s))) {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
-		local_irq_restore(flags);
-	}
 	preempt_enable();
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are


