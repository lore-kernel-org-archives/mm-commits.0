Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AA8EB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjFUUPB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjFUUOj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ACC1FD8
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 791D2616C2
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA524C433C8;
        Wed, 21 Jun 2023 20:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378467;
        bh=gWUUntgij4zKBHO6pcopfK9oo6VhmlRjHU5XYsTUnSI=;
        h=Date:To:From:Subject:From;
        b=VDtlOHcNLUoJaLjrOCodiA4Md231Bnhv5Yj/hvIg0YouJSWnXBcysvl8cUn8eY2wv
         WNsGnkWb0kjzDilnxWcPuTxr+NB2O4Sue0Bse2WPNTyYxMSA1HtTZgD+k9lKG3hT/6
         Zp2emabcTD3/UAdYl05i4aasI52D991yn3eE7Zlo=
Date:   Wed, 21 Jun 2023 13:14:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-struct-pagevec.patch added to mm-unstable branch
Message-Id: <20230621201427.CA524C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove struct pagevec
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-struct-pagevec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-struct-pagevec.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch
mm-add-__folio_batch_release.patch
scatterlist-add-sg_set_folio.patch
i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch
drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch
mm-remove-check_move_unevictable_pages.patch
pagevec-rename-fbatch_count.patch
i915-convert-i915_gpu_error-to-use-a-folio_batch.patch
net-convert-sunrpc-from-pagevec-to-folio_batch.patch
mm-remove-struct-pagevec.patch
mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch
mm-remove-references-to-pagevec.patch
mm-remove-unnecessary-pagevec-includes.patch

