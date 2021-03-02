Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F467C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBD2364F3E
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCBXei (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361118AbhCBX2S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:28:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA2C264F34;
        Tue,  2 Mar 2021 23:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614727657;
        bh=bjMzdpj7G/p73a496e3GhudPC5WrGHxe9O09oDQ3occ=;
        h=Date:From:To:Subject:From;
        b=V6pWoK/h3td9xpJHxVpSqM5JRe5zbNYgk1PogP6fSSb7tHUVlBVWSVW7kbL3qj4vb
         SzQOYq2gTkYExUAFfyAWLJouqy6CgvJXwgZRMjuCihrK9LZSKVXwtoYzHKv1U8yxVt
         wep++EcM71Js6Dn4xXE5Chgy7vHTcpNDN3fR8/e8=
Date:   Tue, 02 Mar 2021 15:27:36 -0800
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com
Subject:  + mm-vmstat-add-cma-statistics.patch added to -mm tree
Message-ID: <20210302232736.Dy5dxmWpK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: add cma statistics
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-cma-statistics.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-cma-statistics.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-cma-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 		mutex_lock(&cma->lock);
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

mm-vmstat-add-cma-statistics.patch

