Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73627C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D3FB611B0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345629AbhIIVCB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVCA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B18016103E;
        Thu,  9 Sep 2021 21:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221251;
        bh=/geOHm2/h0Wns6Tz6SjwIcrxV46/jHu+DqOjocBZyKA=;
        h=Date:From:To:Subject:From;
        b=j6tGarC48atvUTwBbp1zmWcpvO3s67NQMu5QYhTczxun96N+NNKHECmsgPaTh6jtv
         R2ZboYY+rUfJnBgH0yX/ncwB/xSrZWxnJWMTn3TaiA8EhXrHp5IoyTbzQ2Vohtb4Za
         2eSab1o6b1LM7RH/wl0P1ANe3Z70mSSwrNuZic/E=
Date:   Thu, 09 Sep 2021 14:00:50 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-make-locking-in-deactivate_slab-irq-safe.patch removed from -mm
 tree
Message-ID: <20210909210050.KuWo_Uvtt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: make locking in deactivate_slab() irq-safe
has been removed from the -mm tree.  Its filename was
     mm-slub-make-locking-in-deactivate_slab-irq-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: make locking in deactivate_slab() irq-safe

deactivate_slab() now no longer touches the kmem_cache_cpu structure, so
it will be possible to call it with irqs enabled.  Just convert the
spin_lock calls to their irq saving/restoring variants to make it
irq-safe.

Note we now have to use cmpxchg_double_slab() for irq-safe slab_lock(),
because in some situations we don't take the list_lock, which would
disable irqs.

Link: https://lkml.kernel.org/r/20210904105003.11688-20-vbabka@suse.cz
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

 mm/slub.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/slub.c~mm-slub-make-locking-in-deactivate_slab-irq-safe
+++ a/mm/slub.c
@@ -2223,6 +2223,7 @@ static void deactivate_slab(struct kmem_
 	enum slab_modes l = M_NONE, m = M_NONE;
 	void *nextfree, *freelist_iter, *freelist_tail;
 	int tail = DEACTIVATE_TO_HEAD;
+	unsigned long flags = 0;
 	struct page new;
 	struct page old;
 
@@ -2298,7 +2299,7 @@ redo:
 			 * that acquire_slab() will see a slab page that
 			 * is frozen
 			 */
-			spin_lock(&n->list_lock);
+			spin_lock_irqsave(&n->list_lock, flags);
 		}
 	} else {
 		m = M_FULL;
@@ -2309,7 +2310,7 @@ redo:
 			 * slabs from diagnostic functions will not see
 			 * any frozen slabs.
 			 */
-			spin_lock(&n->list_lock);
+			spin_lock_irqsave(&n->list_lock, flags);
 		}
 	}
 
@@ -2326,14 +2327,14 @@ redo:
 	}
 
 	l = m;
-	if (!__cmpxchg_double_slab(s, page,
+	if (!cmpxchg_double_slab(s, page,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"))
 		goto redo;
 
 	if (lock)
-		spin_unlock(&n->list_lock);
+		spin_unlock_irqrestore(&n->list_lock, flags);
 
 	if (m == M_PARTIAL)
 		stat(s, tail);
_

Patches currently in -mm which might be from vbabka@suse.cz are


