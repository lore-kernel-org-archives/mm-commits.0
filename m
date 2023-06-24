Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D59C001DF
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjFXAAu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbjFXAA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F65D2720
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E2D261584
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B0FC433C8;
        Sat, 24 Jun 2023 00:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564825;
        bh=+L0voCVOJ7FsS4Pxbg19e1vq3tQPxDfpYMO0Vd+8eYo=;
        h=Date:To:From:Subject:From;
        b=gWHVZkVflGJruoEdKYsVRJAMJ4gCgL+yTZ8xLqhGfTjA3I8vCh+uQHXbrfBrLBclg
         O2zMPeIUKEfN6tN+NdXhkGJ3YYYNqvYnF/+RkAVY+qnWasBxGN8+1jLMmZsjMZstBE
         9k5343HFGHyTa+Aqy2VCIVDc8Bm8Xp4ECe+p6cDo=
Date:   Fri, 23 Jun 2023 17:00:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-struct-pagevec.patch removed from -mm tree
Message-Id: <20230624000025.86B0FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove struct pagevec
has been removed from the -mm tree.  Its filename was
     mm-remove-struct-pagevec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove struct pagevec
Date: Wed, 21 Jun 2023 17:45:54 +0100

All users are now converted to use the folio_batch so we can get rid of
this data structure.

Link: https://lkml.kernel.org/r/20230621164557.3510324-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |   63 ++------------------------------------
 mm/swap.c               |   18 +++++-----
 2 files changed, 13 insertions(+), 68 deletions(-)

--- a/include/linux/pagevec.h~mm-remove-struct-pagevec
+++ a/include/linux/pagevec.h
@@ -3,65 +3,18 @@
  * include/linux/pagevec.h
  *
  * In many places it is efficient to batch an operation up against multiple
- * pages.  A pagevec is a multipage container which is used for that.
+ * folios.  A folio_batch is a container which is used for that.
  */
 
 #ifndef _LINUX_PAGEVEC_H
 #define _LINUX_PAGEVEC_H
 
-#include <linux/xarray.h>
+#include <linux/types.h>
 
-/* 15 pointers + header align the pagevec structure to a power of two */
+/* 15 pointers + header align the folio_batch structure to a power of two */
 #define PAGEVEC_SIZE	15
 
-struct page;
 struct folio;
-struct address_space;
-
-/* Layout must match folio_batch */
-struct pagevec {
-	unsigned char nr;
-	bool percpu_pvec_drained;
-	struct page *pages[PAGEVEC_SIZE];
-};
-
-void __pagevec_release(struct pagevec *pvec);
-
-static inline void pagevec_init(struct pagevec *pvec)
-{
-	pvec->nr = 0;
-	pvec->percpu_pvec_drained = false;
-}
-
-static inline void pagevec_reinit(struct pagevec *pvec)
-{
-	pvec->nr = 0;
-}
-
-static inline unsigned pagevec_count(struct pagevec *pvec)
-{
-	return pvec->nr;
-}
-
-static inline unsigned pagevec_space(struct pagevec *pvec)
-{
-	return PAGEVEC_SIZE - pvec->nr;
-}
-
-/*
- * Add a page to a pagevec.  Returns the number of slots still available.
- */
-static inline unsigned pagevec_add(struct pagevec *pvec, struct page *page)
-{
-	pvec->pages[pvec->nr++] = page;
-	return pagevec_space(pvec);
-}
-
-static inline void pagevec_release(struct pagevec *pvec)
-{
-	if (pagevec_count(pvec))
-		__pagevec_release(pvec);
-}
 
 /**
  * struct folio_batch - A collection of folios.
@@ -78,11 +31,6 @@ struct folio_batch {
 	struct folio *folios[PAGEVEC_SIZE];
 };
 
-/* Layout must match pagevec */
-static_assert(sizeof(struct pagevec) == sizeof(struct folio_batch));
-static_assert(offsetof(struct pagevec, pages) ==
-		offsetof(struct folio_batch, folios));
-
 /**
  * folio_batch_init() - Initialise a batch of folios
  * @fbatch: The folio batch.
@@ -127,10 +75,7 @@ static inline unsigned folio_batch_add(s
 	return folio_batch_space(fbatch);
 }
 
-static inline void __folio_batch_release(struct folio_batch *fbatch)
-{
-	__pagevec_release((struct pagevec *)fbatch);
-}
+void __folio_batch_release(struct folio_batch *pvec);
 
 static inline void folio_batch_release(struct folio_batch *fbatch)
 {
--- a/mm/swap.c~mm-remove-struct-pagevec
+++ a/mm/swap.c
@@ -1044,25 +1044,25 @@ void release_pages(release_pages_arg arg
 EXPORT_SYMBOL(release_pages);
 
 /*
- * The pages which we're about to release may be in the deferred lru-addition
+ * The folios which we're about to release may be in the deferred lru-addition
  * queues.  That would prevent them from really being freed right now.  That's
- * OK from a correctness point of view but is inefficient - those pages may be
+ * OK from a correctness point of view but is inefficient - those folios may be
  * cache-warm and we want to give them back to the page allocator ASAP.
  *
- * So __pagevec_release() will drain those queues here.
+ * So __folio_batch_release() will drain those queues here.
  * folio_batch_move_lru() calls folios_put() directly to avoid
  * mutual recursion.
  */
-void __pagevec_release(struct pagevec *pvec)
+void __folio_batch_release(struct folio_batch *fbatch)
 {
-	if (!pvec->percpu_pvec_drained) {
+	if (!fbatch->percpu_pvec_drained) {
 		lru_add_drain();
-		pvec->percpu_pvec_drained = true;
+		fbatch->percpu_pvec_drained = true;
 	}
-	release_pages(pvec->pages, pagevec_count(pvec));
-	pagevec_reinit(pvec);
+	release_pages(fbatch->folios, folio_batch_count(fbatch));
+	folio_batch_reinit(fbatch);
 }
-EXPORT_SYMBOL(__pagevec_release);
+EXPORT_SYMBOL(__folio_batch_release);
 
 /**
  * folio_batch_remove_exceptionals() - Prune non-folios from a batch.
_

Patches currently in -mm which might be from willy@infradead.org are


