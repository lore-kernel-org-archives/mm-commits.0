Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB012EB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjFUUOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjFUUOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5871FC9
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE6776167F
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1036EC433C8;
        Wed, 21 Jun 2023 20:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378464;
        bh=MDAYDxvk/vYXUxmaKoAipBsuf9flPZcL2UGmVA63X3U=;
        h=Date:To:From:Subject:From;
        b=2ceM+wKRR3iFFlbRVREuzPATGUKwNQDe3F9wcPt8Pstes+lHXims1D6lVYU1sY/AL
         msM7P/g9vfig9iLPn+LkxuirmzMfLae3ogWyFUBGx2YG/9PiQkwGD9ftHxoGSh0EGs
         BIUyW44qu9Za6PBaBpOXVZV48c+0BvfCB/WCI96Y=
Date:   Wed, 21 Jun 2023 13:14:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + i915-convert-i915_gpu_error-to-use-a-folio_batch.patch added to mm-unstable branch
Message-Id: <20230621201424.1036EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: convert i915_gpu_error to use a folio_batch
has been added to the -mm mm-unstable branch.  Its filename is
     i915-convert-i915_gpu_error-to-use-a-folio_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/i915-convert-i915_gpu_error-to-use-a-folio_batch.patch

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
Subject: i915: convert i915_gpu_error to use a folio_batch
Date: Wed, 21 Jun 2023 17:45:52 +0100

Remove one of the last remaining users of pagevec.

Link: https://lkml.kernel.org/r/20230621164557.3510324-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gpu_error.c |   50 ++++++++++++------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gpu_error.c~i915-convert-i915_gpu_error-to-use-a-folio_batch
+++ a/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -187,64 +187,64 @@ i915_error_printer(struct drm_i915_error
 }
 
 /* single threaded page allocator with a reserved stash for emergencies */
-static void pool_fini(struct pagevec *pv)
+static void pool_fini(struct folio_batch *fbatch)
 {
-	pagevec_release(pv);
+	folio_batch_release(fbatch);
 }
 
-static int pool_refill(struct pagevec *pv, gfp_t gfp)
+static int pool_refill(struct folio_batch *fbatch, gfp_t gfp)
 {
-	while (pagevec_space(pv)) {
-		struct page *p;
+	while (folio_batch_space(fbatch)) {
+		struct folio *folio;
 
-		p = alloc_page(gfp);
-		if (!p)
+		folio = folio_alloc(gfp, 0);
+		if (!folio)
 			return -ENOMEM;
 
-		pagevec_add(pv, p);
+		folio_batch_add(fbatch, folio);
 	}
 
 	return 0;
 }
 
-static int pool_init(struct pagevec *pv, gfp_t gfp)
+static int pool_init(struct folio_batch *fbatch, gfp_t gfp)
 {
 	int err;
 
-	pagevec_init(pv);
+	folio_batch_init(fbatch);
 
-	err = pool_refill(pv, gfp);
+	err = pool_refill(fbatch, gfp);
 	if (err)
-		pool_fini(pv);
+		pool_fini(fbatch);
 
 	return err;
 }
 
-static void *pool_alloc(struct pagevec *pv, gfp_t gfp)
+static void *pool_alloc(struct folio_batch *fbatch, gfp_t gfp)
 {
-	struct page *p;
+	struct folio *folio;
 
-	p = alloc_page(gfp);
-	if (!p && pagevec_count(pv))
-		p = pv->pages[--pv->nr];
+	folio = folio_alloc(gfp, 0);
+	if (!folio && folio_batch_count(fbatch))
+		folio = fbatch->folios[--fbatch->nr];
 
-	return p ? page_address(p) : NULL;
+	return folio ? folio_address(folio) : NULL;
 }
 
-static void pool_free(struct pagevec *pv, void *addr)
+static void pool_free(struct folio_batch *fbatch, void *addr)
 {
-	struct page *p = virt_to_page(addr);
+	struct folio *folio = virt_to_folio(addr);
 
-	if (pagevec_space(pv))
-		pagevec_add(pv, p);
+	if (folio_batch_space(fbatch))
+		folio_batch_add(fbatch, folio);
 	else
-		__free_page(p);
+		folio_put(folio);
 }
 
 #ifdef CONFIG_DRM_I915_COMPRESS_ERROR
 
 struct i915_vma_compress {
-	struct pagevec pool;
+	struct folio_batch pool;
 	struct z_stream_s zstream;
 	void *tmp;
 };
@@ -381,7 +381,7 @@ static void err_compression_marker(struc
 #else
 
 struct i915_vma_compress {
-	struct pagevec pool;
+	struct folio_batch pool;
 };
 
 static bool compress_init(struct i915_vma_compress *c)
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

