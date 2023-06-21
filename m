Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BACEB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjFUUOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjFUUO0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2EC1BE4
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2D4D616C0
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345F0C433C0;
        Wed, 21 Jun 2023 20:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378460;
        bh=g13Q+i70fGycPyQErAXqTiqpBE93lVan0BSnUgFxxpE=;
        h=Date:To:From:Subject:From;
        b=ECsodMFCG/HDk9YrORImIZhbnlPDMlXsC8DoMXdk6k88P15M93+yxBd8ciJpAUaNS
         kmR3LvnjoYGwi18Bwc2wdM7YkNWpX2dbyvhXW6crwk4xJTyb926HA8Y3pXvIC+x+y/
         dV66GphlzIduGZlzfU1iuyhtoyaYnCAUUVZnQCPw=
Date:   Wed, 21 Jun 2023 13:14:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-check_move_unevictable_pages.patch added to mm-unstable branch
Message-Id: <20230621201420.345F0C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove check_move_unevictable_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-check_move_unevictable_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-check_move_unevictable_pages.patch

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
Subject: mm: remove check_move_unevictable_pages()
Date: Wed, 21 Jun 2023 17:45:50 +0100

All callers have now been converted to call
check_move_unevictable_folios().

Link: https://lkml.kernel.org/r/20230621164557.3510324-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/vmscan.c          |   17 -----------------
 2 files changed, 18 deletions(-)

--- a/include/linux/swap.h~mm-remove-check_move_unevictable_pages
+++ a/include/linux/swap.h
@@ -439,7 +439,6 @@ static inline bool node_reclaim_enabled(
 }
 
 void check_move_unevictable_folios(struct folio_batch *fbatch);
-void check_move_unevictable_pages(struct pagevec *pvec);
 
 extern void __meminit kswapd_run(int nid);
 extern void __meminit kswapd_stop(int nid);
--- a/mm/vmscan.c~mm-remove-check_move_unevictable_pages
+++ a/mm/vmscan.c
@@ -8075,23 +8075,6 @@ int node_reclaim(struct pglist_data *pgd
 }
 #endif
 
-void check_move_unevictable_pages(struct pagevec *pvec)
-{
-	struct folio_batch fbatch;
-	unsigned i;
-
-	folio_batch_init(&fbatch);
-	for (i = 0; i < pvec->nr; i++) {
-		struct page *page = pvec->pages[i];
-
-		if (PageTransTail(page))
-			continue;
-		folio_batch_add(&fbatch, page_folio(page));
-	}
-	check_move_unevictable_folios(&fbatch);
-}
-EXPORT_SYMBOL_GPL(check_move_unevictable_pages);
-
 /**
  * check_move_unevictable_folios - Move evictable folios to appropriate zone
  * lru list
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

