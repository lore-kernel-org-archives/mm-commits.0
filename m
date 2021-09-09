Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579ADC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C2E61186
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345722AbhIIVCI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVCG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC4886103D;
        Thu,  9 Sep 2021 21:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221257;
        bh=RCyJ8yEf+RomXW/zENrBSoz/J6CXoKOQ3+bSFDXI1CY=;
        h=Date:From:To:Subject:From;
        b=AGmR+RJ3VzMXMlDhlS7QxX15VwdULj1Tq50lLuyJV7B3E0hPFSAXY+QCyCsjciOYM
         i2qIjnUjZnJctb0VMGoUdUZe5pPK3VonPLwEMzsDDgkqdnXg2TnUgKp4CaENhCoeav
         HsOBsgyg8Z0bGRiBl8bRYuoAxk3Wo3DVD8TGoGHU=
Date:   Thu, 09 Sep 2021 14:00:56 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
 removed from -mm tree
Message-ID: <20210909210056.IVGCvPlZo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: discard slabs in unfreeze_partials() without irqs disabled
has been removed from the -mm tree.  Its filename was
     mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vbabka@suse.cz are


