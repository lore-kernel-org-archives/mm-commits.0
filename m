Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BBFC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE8060724
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347609AbhIBVwp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347607AbhIBVwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44ADC610A2;
        Thu,  2 Sep 2021 21:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619506;
        bh=dPLeJUM69PEtne/SmN3qZqIWyiRsFknC1smWPYWYFqA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eQPoRZRs3xSFJsTI9YBB+LqVi4B7Sq0GatJsp6v6DfE5bdeXLbIceiSzAzZc+yzQ6
         i4HOnICrV/dJoGSPy4qyVtNdOpxT/NvTj6IQXzuC1/CSzCk43gjPnjEXQSaYVL5rTN
         UuzMKle1O/c2tjaSHKjhqLZIbFDB1SmBYPtpzUTc=
Date:   Thu, 02 Sep 2021 14:51:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 034/212] mm, slub: only disable irq with spin_lock
 in __unfreeze_partials()
Message-ID: <20210902215145.6unoTO2Ge%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: only disable irq with spin_lock in __unfreeze_partials()

__unfreeze_partials() no longer needs to have irqs disabled, except for
making the spin_lock operations irq-safe, so convert the spin_locks
operations and remove the separate irq handling.

Link: https://lkml.kernel.org/r/20210805152000.12817-27-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/slub.c~mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials
+++ a/mm/slub.c
@@ -2338,9 +2338,7 @@ static void __unfreeze_partials(struct k
 {
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
 	struct page *page, *discard_page = NULL;
-	unsigned long flags;
-
-	local_irq_save(flags);
+	unsigned long flags = 0;
 
 	while (partial_page) {
 		struct page new;
@@ -2352,10 +2350,10 @@ static void __unfreeze_partials(struct k
 		n2 = get_node(s, page_to_nid(page));
 		if (n != n2) {
 			if (n)
-				spin_unlock(&n->list_lock);
+				spin_unlock_irqrestore(&n->list_lock, flags);
 
 			n = n2;
-			spin_lock(&n->list_lock);
+			spin_lock_irqsave(&n->list_lock, flags);
 		}
 
 		do {
@@ -2384,9 +2382,7 @@ static void __unfreeze_partials(struct k
 	}
 
 	if (n)
-		spin_unlock(&n->list_lock);
-
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&n->list_lock, flags);
 
 	while (discard_page) {
 		page = discard_page;
_
