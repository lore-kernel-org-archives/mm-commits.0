Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93381C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79ECB61402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWuX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhEHWuW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F506100C;
        Sat,  8 May 2021 22:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514160;
        bh=wL80BQ1oMZDv7B2lKQaQHVdy+GA/NjrkzlMDvKjsdzs=;
        h=Date:From:To:Subject:From;
        b=KJ1yFe/3Opi0xOLksNtJvE1842+MZPaMZZx6x7BBuV8lG9eW/Xs7i+w8DUG1v+q/s
         cT8hVMdqpZ9GCeFXLx4njHFEwpNrXwmiSjNnJQ6fGVKGiHTi+b/mQYw45m7BYWqdKr
         CX21zVN5u2ZGh1twx/hrlQld/SUbSTBv+IQd6p44=
Date:   Sat, 08 May 2021 15:49:20 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com
Subject:  [merged] mm-vmstat-add-cma-statistics.patch removed from
 -mm tree
Message-ID: <20210508224920.Vf8cFHQXt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: add cma statistics
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-cma-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from minchan@kernel.org are


