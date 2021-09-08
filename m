Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2E5C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B444E610C9
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbhIHCzI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347363AbhIHCzF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6B12610C9;
        Wed,  8 Sep 2021 02:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069638;
        bh=qvRCEQBSzC2pVeSWwfu3kW7uRYyi52qtmFtpBzKcEmM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HQUTY/tDrWMBCtyAuGZoL9htbsndyCkf6Jvssp8w4ON81KuTs00hL34m+Y1ihnHdd
         sE8tP230XFSO8keptFMuNbqhzyx3wWjX+5Rrd6hjS3x42SHPneYLZw9J/zvlFRlAVP
         /TVdqdN6/+xx8Sis9KugZtminnQKMW+xkRM+eU2I=
Date:   Tue, 07 Sep 2021 19:53:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 019/147] mm, slub: make locking in
 deactivate_slab() irq-safe
Message-ID: <20210908025357.WfR3N8cVl%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
