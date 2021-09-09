Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E09C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD21A61179
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345533AbhIIVBx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245624AbhIIVBu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA4AB61026;
        Thu,  9 Sep 2021 21:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221241;
        bh=XblWLKRgp7NSpPNFQzaLhF6VE3SqFHVO6q8gpMEBHqU=;
        h=Date:From:To:Subject:From;
        b=xvu/P/bMSoE+2rtAcYOmPk9+Q4P+nvMYKmMkVgkrcFGgW16zWc8H75lUEZHH/blaF
         3MTBHHlhwDcb3EzHA4VfEeWJc+N+9YmP+PX8zWhM37ZuiEm8rK+onUeLdbcOZPpZ0j
         PYXNAc6Q4sU6ge5h/lr7PzzSNvAV4Zte/gh7nYyo=
Date:   Thu, 09 Sep 2021 14:00:40 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-restore-irqs-around-calling-new_slab.patch removed from -mm tree
Message-ID: <20210909210040.g8lmuvU66%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: restore irqs around calling new_slab()
has been removed from the -mm tree.  Its filename was
     mm-slub-restore-irqs-around-calling-new_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: restore irqs around calling new_slab()

allocate_slab() currently re-enables irqs before calling to the page
allocator.  It depends on gfpflags_allow_blocking() to determine if it's
safe to do so.  Now we can instead simply restore irq before calling it
through new_slab().  The other caller early_kmem_cache_node_alloc() is
unaffected by this.

Link: https://lkml.kernel.org/r/20210904105003.11688-15-vbabka@suse.cz
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

 mm/slub.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-restore-irqs-around-calling-new_slab
+++ a/mm/slub.c
@@ -1809,9 +1809,6 @@ static struct page *allocate_slab(struct
 
 	flags &= gfp_allowed_mask;
 
-	if (gfpflags_allow_blocking(flags))
-		local_irq_enable();
-
 	flags |= s->allocflags;
 
 	/*
@@ -1870,8 +1867,6 @@ static struct page *allocate_slab(struct
 	page->frozen = 1;
 
 out:
-	if (gfpflags_allow_blocking(flags))
-		local_irq_disable();
 	if (!page)
 		return NULL;
 
@@ -2812,16 +2807,17 @@ new_objects:
 		goto check_new_page;
 	}
 
+	local_irq_restore(flags);
 	put_cpu_ptr(s->cpu_slab);
 	page = new_slab(s, gfpflags, node);
 	c = get_cpu_ptr(s->cpu_slab);
 
 	if (unlikely(!page)) {
-		local_irq_restore(flags);
 		slab_out_of_memory(s, gfpflags, node);
 		return NULL;
 	}
 
+	local_irq_save(flags);
 	if (c->page)
 		flush_slab(s, c);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


