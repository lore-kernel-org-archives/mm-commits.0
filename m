Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CB7C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B5361104
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347323AbhIHCzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347363AbhIHCzS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C27D261100;
        Wed,  8 Sep 2021 02:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069651;
        bh=hr9fzbYD081UCVuMWGjTvV9pjeGcCRBB4NgaYjQyxQM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JX6ZVTOw61/UQJYF+KsXbHEk74dFSd+PLLCGXFk817aVfznPRxPFrmVrQg9Y3iytZ
         9M+qwgF0L/yKM3nmep2TLeDVk2AJ8g/id2BP3dhl8oVgk/Z5JVAko0kS4re2/jNLS2
         mxxC+L5DqjM886FE3Pw9F74FIESRsB7oqRZIhlKw=
Date:   Tue, 07 Sep 2021 19:54:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 023/147] mm, slub: detach whole partial list at
 once in unfreeze_partials()
Message-ID: <20210908025410.MY3NvgQwv%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: detach whole partial list at once in unfreeze_partials()

Instead of iterating through the live percpu partial list, detach it from
the kmem_cache_cpu at once.  This is simpler and will allow further
optimization.

Link: https://lkml.kernel.org/r/20210904105003.11688-24-vbabka@suse.cz
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

 mm/slub.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials
+++ a/mm/slub.c
@@ -2358,16 +2358,20 @@ static void unfreeze_partials(struct kme
 {
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
-	struct page *page, *discard_page = NULL;
+	struct page *page, *partial_page, *discard_page = NULL;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	while ((page = slub_percpu_partial(c))) {
+	partial_page = slub_percpu_partial(c);
+	c->partial = NULL;
+
+	while (partial_page) {
 		struct page new;
 		struct page old;
 
-		slub_set_percpu_partial(c, page);
+		page = partial_page;
+		partial_page = page->next;
 
 		n2 = get_node(s, page_to_nid(page));
 		if (n != n2) {
_
