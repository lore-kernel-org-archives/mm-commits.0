Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7367AC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A4E961102
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbhIHCzT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347442AbhIHCzP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7805E60EE6;
        Wed,  8 Sep 2021 02:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069648;
        bh=ZL3wVVgwB4qjyASH5yJh3/EuGsbqfIa1h+0xujpIqu4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aTC2+tknyl5WcEtgClOdpsPWpSzSNiHFPM5vSOctu6YmjUo8oAQQS7sIT/VX0z1/N
         JPOWynQlEUfi4mIya79avrclKH646MyH9Co0GoNdYaYpO1Pqy7ujU2jWadFkycwjAF
         0VW4w+Zwf9ht5ZUMUiALS6nrqujPqRXBIeJtCwzo=
Date:   Tue, 07 Sep 2021 19:54:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 022/147] mm, slub: discard slabs in
 unfreeze_partials() without irqs disabled
Message-ID: <20210908025407.8c1hfGeXn%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: discard slabs in unfreeze_partials() without irqs disabled

No need for disabled irqs when discarding slabs, so restore them before
discarding.

Link: https://lkml.kernel.org/r/20210904105003.11688-23-vbabka@suse.cz
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

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled
+++ a/mm/slub.c
@@ -2406,6 +2406,8 @@ static void unfreeze_partials(struct kme
 	if (n)
 		spin_unlock(&n->list_lock);
 
+	local_irq_restore(flags);
+
 	while (discard_page) {
 		page = discard_page;
 		discard_page = discard_page->next;
@@ -2415,7 +2417,6 @@ static void unfreeze_partials(struct kme
 		stat(s, FREE_SLAB);
 	}
 
-	local_irq_restore(flags);
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 }
 
_
