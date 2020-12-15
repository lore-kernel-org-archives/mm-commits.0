Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A510BC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 608FA224D4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgLODOd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbgLODOE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:04 -0500
Date:   Mon, 14 Dec 2020 19:13:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002004;
        bh=C8wUdiZt8+oc4sOw6lbo03WHf8sF1zlF678hzJL3YLk=;
        h=From:To:Subject:In-Reply-To:From;
        b=IYLhXT1cly60mpzp5lwxM+fbXvW7MgsjSxM0Ces4L4T/pPzPkoKTl8RQwtxtaCjO3
         grgdffTEMHIIYNOM7XGsdGnN+ZtZyTWn5WvsXuj5aMbIloeXZ9tFkDmUX2XcBwZMaU
         v+1N7ZGatlZ/ye8nxMq/eMxCmJF2/xXhq9XKUCA0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        lecopzer.chen@mediatek.com, linux-mm@kvack.org,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        yj.chiang@mediatek.com
Subject:  [patch 172/200] mm/cma.c: remove redundant cma_mutex lock
Message-ID: <20201215031323.-4QcJQxbF%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lecopzer Chen <lecopzer.chen@mediatek.com>
Subject: mm/cma.c: remove redundant cma_mutex lock

The cma_mutex which protects alloc_contig_range() was first appeared in
commit 7ee793a62fa8c ("cma: Remove potential deadlock situation"), at that
time, there is no guarantee the behavior of concurrency inside
alloc_contig_range().

After commit 2c7452a075d4db2dc ("mm/page_isolation.c: make
start_isolate_page_range() fail if already isolated")

  > However, two subsystems (CMA and gigantic
  > huge pages for example) could attempt operations on the same range.  If
  > this happens, one thread may 'undo' the work another thread is doing.
  > This can result in pageblocks being incorrectly left marked as
  > MIGRATE_ISOLATE and therefore not available for page allocation.

The concurrency inside alloc_contig_range() was clarified.

Now we can find that hugepage and virtio call alloc_contig_range() without
any lock, thus cma_mutex is "redundant" in cma_alloc() now.

Link: https://lkml.kernel.org/r/20201020102241.3729-1-lecopzer.chen@mediatek.com
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: YJ Chiang <yj.chiang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/cma.c~mm-cmac-remove-redundant-cma_mutex-lock
+++ a/mm/cma.c
@@ -38,7 +38,6 @@
 
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned cma_area_count;
-static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(const struct cma *cma)
 {
@@ -454,10 +453,9 @@ struct page *cma_alloc(struct cma *cma,
 		mutex_unlock(&cma->lock);
 
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
-		mutex_lock(&cma_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
 				     GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-		mutex_unlock(&cma_mutex);
+
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
 			break;
_
