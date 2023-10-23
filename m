Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A64C25B46
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjJWSJ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjJWSJ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:09:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFA01A4
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 11:09:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D9C433C7;
        Mon, 23 Oct 2023 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698084564;
        bh=vvsOKeeOyaDg+QPLBNctEW7CaznmqneuvR3koRv9e8c=;
        h=Date:To:From:Subject:From;
        b=J/x5WfK8DBcfnHdeMgCSGDBeOIh90UL4Wtko4teezFhX1SEk7jxwDtBnPY9Q3t625
         UPck/kOA7ed1PPx/Or2UlBgN/WaHkjvrWchd7wUmN+5wq/JPSU2JbiB5gIL4FbzlNJ
         p3vwYbi4yby1XuRmobfEj6JTRAT7TI9CUQ9MphUA=
Date:   Mon, 23 Oct 2023 11:09:23 -0700
To:     mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        hyesoo.yu@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-check-the-order-of-compound-page-even-when-the-order-is-zero.patch added to mm-unstable branch
Message-Id: <20231023180924.525D9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: check the order of compound page even when the order is zero
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-check-the-order-of-compound-page-even-when-the-order-is-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-check-the-order-of-compound-page-even-when-the-order-is-zero.patch

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

mm-page_alloc-check-the-order-of-compound-page-even-when-the-order-is-zero.patch

