Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E135C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16BF2611AD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345556AbhIIVBz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABECB61026;
        Thu,  9 Sep 2021 21:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221245;
        bh=XoXEpoee+WjKf3paPgv293bcnnqYk8sO/g51L4cnyWs=;
        h=Date:From:To:Subject:From;
        b=ZlX/bC4RCsKtrz+t9/y7kR+Z3Kbsq8ZoHnVJMLUOoWe6ON3MvrUz2mc0p3VRgdFX6
         73/5+MYdrEPviGYzLUBS1L9lq91IjXQ3mIO5bkOV4E6MoXJsVfsSGqM+2i8F6T1T7Z
         luvzcqLUJgQBvqJpojbZljsAkd6d1kbvQ1Z51EWk=
Date:   Thu, 09 Sep 2021 14:00:44 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged] mm-slub-check-new-pages-with-restored-irqs.patch
 removed from -mm tree
Message-ID: <20210909210044.X9Bo0XIbk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: check new pages with restored irqs
has been removed from the -mm tree.  Its filename was
     mm-slub-check-new-pages-with-restored-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: check new pages with restored irqs

Building on top of the previous patch, re-enable irqs before checking new
pages.  alloc_debug_processing() is now called with enabled irqs so we
need to remove VM_BUG_ON(!irqs_disabled()); in check_slab() - there
doesn't seem to be a need for it anyway.

Link: https://lkml.kernel.org/r/20210904105003.11688-17-vbabka@suse.cz
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

 mm/slub.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-check-new-pages-with-restored-irqs
+++ a/mm/slub.c
@@ -1009,8 +1009,6 @@ static int check_slab(struct kmem_cache
 {
 	int maxobj;
 
-	VM_BUG_ON(!irqs_disabled());
-
 	if (!PageSlab(page)) {
 		slab_err(s, page, "Not a valid slab page");
 		return 0;
@@ -2802,10 +2800,10 @@ new_objects:
 	lockdep_assert_irqs_disabled();
 
 	freelist = get_partial(s, gfpflags, node, &page);
+	local_irq_restore(flags);
 	if (freelist)
 		goto check_new_page;
 
-	local_irq_restore(flags);
 	put_cpu_ptr(s->cpu_slab);
 	page = new_slab(s, gfpflags, node);
 	c = get_cpu_ptr(s->cpu_slab);
@@ -2815,7 +2813,6 @@ new_objects:
 		return NULL;
 	}
 
-	local_irq_save(flags);
 	/*
 	 * No other reference to the page yet so we can
 	 * muck around with it freely without cmpxchg
@@ -2830,7 +2827,6 @@ check_new_page:
 	if (kmem_cache_debug(s)) {
 		if (!alloc_debug_processing(s, page, freelist, addr)) {
 			/* Slab failed checks. Next slab needed */
-			local_irq_restore(flags);
 			goto new_slab;
 		} else {
 			/*
@@ -2848,6 +2844,7 @@ check_new_page:
 		 */
 		goto return_single;
 
+	local_irq_save(flags);
 	if (unlikely(c->page))
 		flush_slab(s, c);
 	c->page = page;
@@ -2856,6 +2853,7 @@ check_new_page:
 
 return_single:
 
+	local_irq_save(flags);
 	if (unlikely(c->page))
 		flush_slab(s, c);
 	c->page = page;
_

Patches currently in -mm which might be from vbabka@suse.cz are


