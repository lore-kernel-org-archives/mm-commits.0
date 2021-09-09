Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36ADC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1C961026
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbhIIVBx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVBx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B208C6103D;
        Thu,  9 Sep 2021 21:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221243;
        bh=RjFDlQkrNCwAPnO2egVYWRu7q2YTcor57viMd5zx4iE=;
        h=Date:From:To:Subject:From;
        b=hvRrQ6VLy00/cSxBVpPF64uuTV7MBFU/AxpQFbu6IL6dotd5BA+yjCKIb0bW42qjF
         HYBIyGliw9iDsg7ArIbHB0GHlfWkhZAyLSRrn0UgCIp8bzQ/CPYU1x0sKL7Ct+k5AK
         EPTvAx4XRwCCG3J24uSvjWCCXtEHUDgUhMdjgGyE=
Date:   Thu, 09 Sep 2021 14:00:42 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-slub-validate-slab-from-partial-list-or-page-allocator?=
 =?US-ASCII?Q?-before-making-it-cpu-slab.patch?= removed from -mm tree
Message-ID: <20210909210042.D-bNn8k8N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: validate slab from partial list or page allocator before making it cpu slab
has been removed from the -mm tree.  Its filename was
     mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: validate slab from partial list or page allocator before making it cpu slab

When we obtain a new slab page from node partial list or page allocator,
we assign it to kmem_cache_cpu, perform some checks, and if they fail, we
undo the assignment.

In order to allow doing the checks without irq disabled, restructure the
code so that the checks are done first, and kmem_cache_cpu.page assignment
only after they pass.

Link: https://lkml.kernel.org/r/20210904105003.11688-16-vbabka@suse.cz
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

 mm/slub.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/slub.c~mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab
+++ a/mm/slub.c
@@ -2802,10 +2802,8 @@ new_objects:
 	lockdep_assert_irqs_disabled();
 
 	freelist = get_partial(s, gfpflags, node, &page);
-	if (freelist) {
-		c->page = page;
+	if (freelist)
 		goto check_new_page;
-	}
 
 	local_irq_restore(flags);
 	put_cpu_ptr(s->cpu_slab);
@@ -2818,9 +2816,6 @@ new_objects:
 	}
 
 	local_irq_save(flags);
-	if (c->page)
-		flush_slab(s, c);
-
 	/*
 	 * No other reference to the page yet so we can
 	 * muck around with it freely without cmpxchg
@@ -2829,14 +2824,12 @@ new_objects:
 	page->freelist = NULL;
 
 	stat(s, ALLOC_SLAB);
-	c->page = page;
 
 check_new_page:
 
 	if (kmem_cache_debug(s)) {
 		if (!alloc_debug_processing(s, page, freelist, addr)) {
 			/* Slab failed checks. Next slab needed */
-			c->page = NULL;
 			local_irq_restore(flags);
 			goto new_slab;
 		} else {
@@ -2855,10 +2848,18 @@ check_new_page:
 		 */
 		goto return_single;
 
+	if (unlikely(c->page))
+		flush_slab(s, c);
+	c->page = page;
+
 	goto load_freelist;
 
 return_single:
 
+	if (unlikely(c->page))
+		flush_slab(s, c);
+	c->page = page;
+
 	deactivate_slab(s, page, get_freepointer(s, freelist), c);
 	local_irq_restore(flags);
 	return freelist;
_

Patches currently in -mm which might be from vbabka@suse.cz are


