Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58E5C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFEA611B0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345850AbhIIVCN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345763AbhIIVCM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B1A61026;
        Thu,  9 Sep 2021 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221263;
        bh=yDyPpKteTlIju/YtRHu3hN+TgQxMtgNpQEpv8ZrJnJk=;
        h=Date:From:To:Subject:From;
        b=HZ1efX2O0TIkSiGWYHnFXo3Rd4Ix4s0NVliHXoFnu4kPsuadMbdzTuAqGlhbsc2oc
         1vKDLpyEwyxSoFBXe/ROnkBGuuJpzrAplmDV3fZhoIfEByRhVGjuA4mTE8P7U38nh1
         pDhYf5cUmuMQWpFw9525RKHuJHX6yqwnZf75WUXk=
Date:   Thu, 09 Sep 2021 14:01:02 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
 removed from -mm tree
Message-ID: <20210909210102.I664iH7tE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: only disable irq with spin_lock in __unfreeze_partials()
has been removed from the -mm tree.  Its filename was
     mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: only disable irq with spin_lock in __unfreeze_partials()

__unfreeze_partials() no longer needs to have irqs disabled, except for
making the spin_lock operations irq-safe, so convert the spin_locks
operations and remove the separate irq handling.

Link: https://lkml.kernel.org/r/20210904105003.11688-26-vbabka@suse.cz
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

 mm/slub.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/slub.c~mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials
+++ a/mm/slub.c
@@ -2352,9 +2352,7 @@ static void __unfreeze_partials(struct k
 {
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
 	struct page *page, *discard_page = NULL;
-	unsigned long flags;
-
-	local_irq_save(flags);
+	unsigned long flags = 0;
 
 	while (partial_page) {
 		struct page new;
@@ -2366,10 +2364,10 @@ static void __unfreeze_partials(struct k
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
@@ -2398,9 +2396,7 @@ static void __unfreeze_partials(struct k
 	}
 
 	if (n)
-		spin_unlock(&n->list_lock);
-
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&n->list_lock, flags);
 
 	while (discard_page) {
 		page = discard_page;
_

Patches currently in -mm which might be from vbabka@suse.cz are


