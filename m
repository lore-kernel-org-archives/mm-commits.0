Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02193C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF9561104
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbhIHCy6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347534AbhIHCyd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85857610C9;
        Wed,  8 Sep 2021 02:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069606;
        bh=G/z5bEvPuCO7hnfAhsdV0j33MBX5Ma9gmixAcbwIzF8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H/7PRxb6bKViNiUFhlEpYycFB3EkkYoTLS7U+VC5+5IZXUt+jePmfwhduiSDATxjI
         hmjmssyUVRUMTnOQXrsVfSwFjRVc2j48tdO5g7N47HEOfxxk3bMOi/V8NdC0EcaYZe
         SNcrs5ev+Eah2giyTSinf7If+Wg03UPCIJUdCL1g=
Date:   Tue, 07 Sep 2021 19:53:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 009/147] mm, slub: restructure new page checks in
 ___slab_alloc()
Message-ID: <20210908025325.k8MQE96j7%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: restructure new page checks in ___slab_alloc()

When we allocate slab object from a newly acquired page (from node's
partial list or page allocator), we usually also retain the page as a new
percpu slab.  There are two exceptions - when pfmemalloc status of the
page doesn't match our gfp flags, or when the cache has debugging enabled.

The current code for these decisions is not easy to follow, so restructure
it and add comments.  The new structure will also help with the following
changes.  No functional change.

Link: https://lkml.kernel.org/r/20210904105003.11688-10-vbabka@suse.cz
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

 mm/slub.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-restructure-new-page-checks-in-___slab_alloc
+++ a/mm/slub.c
@@ -2782,13 +2782,29 @@ new_slab:
 	c->page = page;
 
 check_new_page:
-	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(page, gfpflags)))
-		goto load_freelist;
 
-	/* Only entered in the debug case */
-	if (kmem_cache_debug(s) &&
-			!alloc_debug_processing(s, page, freelist, addr))
-		goto new_slab;	/* Slab failed checks. Next slab needed */
+	if (kmem_cache_debug(s)) {
+		if (!alloc_debug_processing(s, page, freelist, addr))
+			/* Slab failed checks. Next slab needed */
+			goto new_slab;
+		else
+			/*
+			 * For debug case, we don't load freelist so that all
+			 * allocations go through alloc_debug_processing()
+			 */
+			goto return_single;
+	}
+
+	if (unlikely(!pfmemalloc_match(page, gfpflags)))
+		/*
+		 * For !pfmemalloc_match() case we don't load freelist so that
+		 * we don't make further mismatched allocations easier.
+		 */
+		goto return_single;
+
+	goto load_freelist;
+
+return_single:
 
 	deactivate_slab(s, page, get_freepointer(s, freelist), c);
 	return freelist;
_
