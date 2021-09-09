Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BCCC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB87611B0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344885AbhIIVBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245624AbhIIVBm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B00C2611AF;
        Thu,  9 Sep 2021 21:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221233;
        bh=lGBlt6/sdbi7MNEAPv8GMzg6noCOoWV28FR58oB8OV0=;
        h=Date:From:To:Subject:From;
        b=A8tnOGWCt1yXR0faGANnQmFexEhURpyaUcu9C31P4T4Xwu/LU3P5IYaTKXfaqCi4e
         J1ZMWuky80GuNr1Trlba/lVddXtTE7ZdQx4M8wFq+lSDjLdwfQN2BGl2YBNT0fhaWa
         4OIxscT2CxzcWUdhQtBYUCXN1Tpit3NwzMxwdwOE=
Date:   Thu, 09 Sep 2021 14:00:32 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch removed from -mm tree
Message-ID: <20210909210032.ThMJdSqNd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: simplify kmem_cache_cpu and tid setup
has been removed from the -mm tree.  Its filename was
     mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: simplify kmem_cache_cpu and tid setup

In slab_alloc_node() and do_slab_free() fastpaths we need to guarantee
that our kmem_cache_cpu pointer is from the same cpu as the tid value. 
Currently that's done by reading the tid first using this_cpu_read(), then
the kmem_cache_cpu pointer and verifying we read the same tid using the
pointer and plain READ_ONCE().

This can be simplified to just fetching kmem_cache_cpu pointer and then
reading tid using the pointer.  That guarantees they are from the same
cpu.  We don't need to read the tid using this_cpu_read() because the
value will be validated by this_cpu_cmpxchg_double(), making sure we are
on the correct cpu and the freelist didn't change by anyone preempting us
since reading the tid.

Link: https://lkml.kernel.org/r/20210904105003.11688-11-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/mm/slub.c~mm-slub-simplify-kmem_cache_cpu-and-tid-setup
+++ a/mm/slub.c
@@ -2882,15 +2882,14 @@ redo:
 	 * reading from one cpu area. That does not matter as long
 	 * as we end up on the original cpu again when doing the cmpxchg.
 	 *
-	 * We should guarantee that tid and kmem_cache are retrieved on
-	 * the same cpu. It could be different if CONFIG_PREEMPTION so we need
-	 * to check if it is matched or not.
+	 * We must guarantee that tid and kmem_cache_cpu are retrieved on the
+	 * same cpu. We read first the kmem_cache_cpu pointer and use it to read
+	 * the tid. If we are preempted and switched to another cpu between the
+	 * two reads, it's OK as the two are still associated with the same cpu
+	 * and cmpxchg later will validate the cpu.
 	 */
-	do {
-		tid = this_cpu_read(s->cpu_slab->tid);
-		c = raw_cpu_ptr(s->cpu_slab);
-	} while (IS_ENABLED(CONFIG_PREEMPTION) &&
-		 unlikely(tid != READ_ONCE(c->tid)));
+	c = raw_cpu_ptr(s->cpu_slab);
+	tid = READ_ONCE(c->tid);
 
 	/*
 	 * Irqless object alloc/free algorithm used here depends on sequence
@@ -3164,11 +3163,8 @@ redo:
 	 * data is retrieved via this pointer. If we are on the same cpu
 	 * during the cmpxchg then the free will succeed.
 	 */
-	do {
-		tid = this_cpu_read(s->cpu_slab->tid);
-		c = raw_cpu_ptr(s->cpu_slab);
-	} while (IS_ENABLED(CONFIG_PREEMPTION) &&
-		 unlikely(tid != READ_ONCE(c->tid)));
+	c = raw_cpu_ptr(s->cpu_slab);
+	tid = READ_ONCE(c->tid);
 
 	/* Same with comment on barrier() in slab_alloc_node() */
 	barrier();
_

Patches currently in -mm which might be from vbabka@suse.cz are


