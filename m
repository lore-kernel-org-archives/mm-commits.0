Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C3AC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE01610E7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347564AbhIBVvy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhIBVvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A23E7610C8;
        Thu,  2 Sep 2021 21:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619454;
        bh=6D2Vby7df+De7ChvYdf5ch0Uo4FevG33hypazx7dsk0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fEwuxMG8btoHIwoAanJcIBmewKWn/JP3wp95Sxgo1k+MfTiOnM94EzezkSTzO0Iex
         dF0LBWpso86OI1b5bJQzzI/fUXS4KNpVOshL+lhI8hNzEkSAKPvfUAGH7QgYP+XCxk
         bnNmJ3nH+b+wl0BH//7NkRVtw1jvGt5nMMORMFaw=
Date:   Thu, 02 Sep 2021 14:50:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 018/212] mm, slub: restructure new page checks in
 ___slab_alloc()
Message-ID: <20210902215053.Y6IhqUU8K%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20210805152000.12817-11-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-restructure-new-page-checks-in-___slab_alloc
+++ a/mm/slub.c
@@ -2768,13 +2768,29 @@ new_slab:
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
