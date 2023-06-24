Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502B5EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjFXAAp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjFXAAX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122E270D
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3383B615E3
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE27C433C8;
        Sat, 24 Jun 2023 00:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564821;
        bh=AMVg2nBx/94H72Wj+caVszg75gQu3UjrHvjuzvodsxY=;
        h=Date:To:From:Subject:From;
        b=2v9rOIhybZvh6/UW/ncwbFVYUtjF1Rjb+akqFqKkv4mU9VYrUENaR6z5/gwCbl9jc
         zkOAF/cmswfORd/R6FZmW7KoFjYksAUTJVGJkg4rTxF8xyIPezfyXRM6sU8DBtvMdn
         DD2wFs/vcCo9xs+MhBm0HsT4vbON84Ok7+w7C1gY=
Date:   Fri, 23 Jun 2023 17:00:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-check_move_unevictable_pages.patch removed from -mm tree
Message-Id: <20230624000021.8BE27C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove check_move_unevictable_pages()
has been removed from the -mm tree.  Its filename was
     mm-remove-check_move_unevictable_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


