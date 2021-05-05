Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4576C43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA6B161029
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhEEBiP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhEEBiP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A41F3610A1;
        Wed,  5 May 2021 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178639;
        bh=viL7QBwiK3cU7eNDU/Dn+bthqD7TpjoeYWTvAD9OS/0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ofKghIh5ohgHe+BdMVFe3SM11derDDkBW+qSZP5m/ljHmuoeeDOI1jX5nWYvqG9IX
         sLP/eRnESvxKV3VCjj0zXpRWr1H0forIgnHWfZVfDrm71a0dARPkpKB/x0plccDHLT
         z4D3H9jvdVw5dVkGeu6N3Zi7pbnY18jRxFPKOo9c=
Date:   Tue, 04 May 2021 18:37:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        joaodias@google.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 085/143] mm: vmstat: add cma statistics
Message-ID: <20210505013719.yrarMZvA0%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: vmstat: add cma statistics

Since CMA is used more widely, it's worth to have CMA allocation
statistics into vmstat.  With it, we could know how agressively system
uses cma allocation and how often it fails.

Link: https://lkml.kernel.org/r/20210302183346.3707237-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: John Dias <joaodias@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++++
 mm/cma.c                      |   12 +++++++++---
 mm/vmstat.c                   |    4 ++++
 3 files changed, 17 insertions(+), 3 deletions(-)

--- a/include/linux/vm_event_item.h~mm-vmstat-add-cma-statistics
+++ a/include/linux/vm_event_item.h
@@ -71,6 +71,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
+#ifdef CONFIG_CMA
+		CMA_ALLOC_SUCCESS,
+		CMA_ALLOC_FAIL,
+#endif
 		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
 		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
 		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
--- a/mm/cma.c~mm-vmstat-add-cma-statistics
+++ a/mm/cma.c
@@ -435,13 +435,13 @@ struct page *cma_alloc(struct cma *cma,
 	int ret = -ENOMEM;
 
 	if (!cma || !cma->count || !cma->bitmap)
-		return NULL;
+		goto out;
 
 	pr_debug("%s(cma %p, count %zu, align %d)\n", __func__, (void *)cma,
 		 count, align);
 
 	if (!count)
-		return NULL;
+		goto out;
 
 	mask = cma_bitmap_aligned_mask(cma, align);
 	offset = cma_bitmap_aligned_offset(cma, align);
@@ -449,7 +449,7 @@ struct page *cma_alloc(struct cma *cma,
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 
 	if (bitmap_count > bitmap_maxno)
-		return NULL;
+		goto out;
 
 	for (;;) {
 		spin_lock_irq(&cma->lock);
@@ -506,6 +506,12 @@ struct page *cma_alloc(struct cma *cma,
 	}
 
 	pr_debug("%s(): returned %p\n", __func__, page);
+out:
+	if (page)
+		count_vm_event(CMA_ALLOC_SUCCESS);
+	else
+		count_vm_event(CMA_ALLOC_FAIL);
+
 	return page;
 }
 
--- a/mm/vmstat.c~mm-vmstat-add-cma-statistics
+++ a/mm/vmstat.c
@@ -1313,6 +1313,10 @@ const char * const vmstat_text[] = {
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
 #endif
+#ifdef CONFIG_CMA
+	"cma_alloc_success",
+	"cma_alloc_fail",
+#endif
 	"unevictable_pgs_culled",
 	"unevictable_pgs_scanned",
 	"unevictable_pgs_rescued",
_
