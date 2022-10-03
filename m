Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E140CC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJCVHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiJCVFs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFD51A390
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B67A610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9098C433D7;
        Mon,  3 Oct 2022 21:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831120;
        bh=6oMbCoTDoC6eT8i2kouOjVavoSR0vGmpvOUf4bRwvc0=;
        h=Date:To:From:Subject:From;
        b=M4vDK+lNYjwJSDVj0MkL0B9BM8Ue6PVtyGxSrAWV4eqEgIDDNJJfiJznEkHeDU9TL
         NI5pVHyuJZgcRLqzZ65PluBJ1MGsIlu63GNhB+0fCKKmUOtauwM8YY+LiEMZ8bAqQo
         ApNJMh9B62Qde2U1lKWWq8PhB+LXnbLGon9Thqvo=
Date:   Mon, 03 Oct 2022 14:05:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap_state-convert-free_swap_cache-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210520.C9098C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap_state: convert free_swap_cache() to use a folio
has been removed from the -mm tree.  Its filename was
     swap_state-convert-free_swap_cache-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap_state: convert free_swap_cache() to use a folio
Date: Fri, 2 Sep 2022 20:46:35 +0100

Saves several calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-40-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/swap_state.c~swap_state-convert-free_swap_cache-to-use-a-folio
+++ a/mm/swap_state.c
@@ -272,16 +272,19 @@ void clear_shadow_from_swap_cache(int ty
 /* 
  * If we are the only user, then try to free up the swap cache. 
  * 
- * Its ok to check for PageSwapCache without the page lock
+ * Its ok to check the swapcache flag without the folio lock
  * here because we are going to recheck again inside
- * try_to_free_swap() _with_ the lock.
+ * folio_free_swap() _with_ the lock.
  * 					- Marcelo
  */
 void free_swap_cache(struct page *page)
 {
-	if (PageSwapCache(page) && !page_mapped(page) && trylock_page(page)) {
-		try_to_free_swap(page);
-		unlock_page(page);
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_swapcache(folio) && !folio_mapped(folio) &&
+	    folio_trylock(folio)) {
+		folio_free_swap(folio);
+		folio_unlock(folio);
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


