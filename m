Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C27EC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0E0223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgLODFP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbgLODE7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:59 -0500
Date:   Mon, 14 Dec 2020 19:04:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001470;
        bh=9ej7JElaDKUJZHi/5dD02j+rD504k3GXe+CKFcuPUdY=;
        h=From:To:Subject:In-Reply-To:From;
        b=tQtOHq1oLG6usona9eJjqNhixGeDotsmChQHQAATbBXg3FmdviNtyPq+8xcRfgnuS
         Zt7i6zXKh5vA4bHUCEpF00gfyUROdZaPoKviEnM+gferbBoBJuORd1AsN0HbE+06oB
         PQnDTbicqpCZ16JlJJCB7Jc+mLwHwojbCoSCIDpk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 021/200] mm, slab, slub: clear the slab_cache
 field when freeing page
Message-ID: <20201215030429.hNWu7c3Vt%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab, slub: clear the slab_cache field when freeing page

The page allocator expects that page->mapping is NULL for a page being
freed.  SLAB and SLUB use the slab_cache field which is in union with
mapping, but before freeing the page, the field is referenced with the
"mapping" name when set to NULL.

It's IMHO more correct (albeit functionally the same) to use the
slab_cache name as that's the field we use in SL*B, and document why we
clear it in a comment (we don't clear fields such as s_mem or freelist, as
page allocator doesn't care about those).  While using the 'mapping' name
would automagically keep the code correct if the unions in struct page
changed, such changes should be done consciously and needed changes
evaluated - the comment should help with that.

Link: https://lkml.kernel.org/r/20201210160020.21562-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 mm/slub.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slab.c~mm-slab-slub-clear-the-slab_cache-field-when-freeing-page
+++ a/mm/slab.c
@@ -1399,7 +1399,8 @@ static void kmem_freepages(struct kmem_c
 	__ClearPageSlabPfmemalloc(page);
 	__ClearPageSlab(page);
 	page_mapcount_reset(page);
-	page->mapping = NULL;
+	/* In union with page->mapping where page allocator expects NULL */
+	page->slab_cache = NULL;
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
--- a/mm/slub.c~mm-slab-slub-clear-the-slab_cache-field-when-freeing-page
+++ a/mm/slub.c
@@ -1836,8 +1836,8 @@ static void __free_slab(struct kmem_cach
 
 	__ClearPageSlabPfmemalloc(page);
 	__ClearPageSlab(page);
-
-	page->mapping = NULL;
+	/* In union with page->mapping where page allocator expects NULL */
+	page->slab_cache = NULL;
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
 	unaccount_slab_page(page, order, s);
_
