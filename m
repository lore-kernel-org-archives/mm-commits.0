Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A61C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjJYXuq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbjJYXtc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769B610F2
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FA1C433CB;
        Wed, 25 Oct 2023 23:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277749;
        bh=Wchvnm6LdPxgVsFPFvQaa2SA9BExTOFBgCS1DOiyyFg=;
        h=Date:To:From:Subject:From;
        b=rBI4b3U2lClqbEUzOwMaF4+cXuXn8Pa8RCC/J9EmpQh8+5TuzqsJHcomL/HapEG7H
         QesnMB/Yl7MiDWDsMstK7FtPtjRvIgkfqXrnnbegw1lb2vXSzHkHWL4dOkc5NiXBgt
         7t409z15N3aHIv25+EEesMsD15MICxnis0UN9zx0=
Date:   Wed, 25 Oct 2023 16:49:08 -0700
To:     mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        hyesoo.yu@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-check-the-order-of-compound-page-even-when-the-order-is-zero.patch removed from -mm tree
Message-Id: <20231025234909.43FA1C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: check the order of compound page even when the order is zero
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-check-the-order-of-compound-page-even-when-the-order-is-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyesoo Yu <hyesoo.yu@samsung.com>
Subject: mm: page_alloc: check the order of compound page even when the order is zero
Date: Mon, 23 Oct 2023 17:32:16 +0900

For compound pages, the head sets the PG_head flag and the tail sets the
compound_head to indicate the head page.  If a user allocates a compound
page and frees it with a different order, the compound page information
will not be properly initialized.  To detect this problem,
compound_order(page) and the order argument are compared, but this is not
checked when the order argument is zero.  That error should be checked
regardless of the order.

Link: https://lkml.kernel.org/r/20231023083217.1866451-1-hyesoo.yu@samsung.com
Signed-off-by: Hyesoo Yu <hyesoo.yu@samsung.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-check-the-order-of-compound-page-even-when-the-order-is-zero
+++ a/mm/page_alloc.c
@@ -1079,6 +1079,7 @@ static __always_inline bool free_pages_p
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 	bool init = want_init_on_free();
+	bool compound = PageCompound(page);
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -1097,16 +1098,15 @@ static __always_inline bool free_pages_p
 		return false;
 	}
 
+	VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
+
 	/*
 	 * Check tail pages before head page information is cleared to
 	 * avoid checking PageCompound for order-0 pages.
 	 */
 	if (unlikely(order)) {
-		bool compound = PageCompound(page);
 		int i;
 
-		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
-
 		if (compound)
 			page[1].flags &= ~PAGE_FLAGS_SECOND;
 		for (i = 1; i < (1 << order); i++) {
_

Patches currently in -mm which might be from hyesoo.yu@samsung.com are


