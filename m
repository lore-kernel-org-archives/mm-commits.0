Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E50C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJCVHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJCVFs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F280A18E20
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 904B16118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BC2C433D6;
        Mon,  3 Oct 2022 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831122;
        bh=cfS9pnO0yIwATBJ3VQa2fkKlOB1TN+LmXL7xeT0Sa4w=;
        h=Date:To:From:Subject:From;
        b=aMTQDPrJjcXwXVj3kJbLtdqXHvzSlsX0AicGsjg15OankdsRbAnD8g6HTIa4/EZ2E
         dhF8IP8sqaM/TtEF1baurKjCYrbOpDr+h5+7FA5MOrgxB7zmkcRwFi2NWifiO/s9AU
         /ZcEmPpByz9dNaOiVtNRlF99WcLolaeVgLm1xRM8=
Date:   Mon, 03 Oct 2022 14:05:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-convert-swap_writepage-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210521.E3BC2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: convert swap_writepage() to use a folio
has been removed from the -mm tree.  Its filename was
     swap-convert-swap_writepage-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: convert swap_writepage() to use a folio
Date: Fri, 2 Sep 2022 20:46:36 +0100

Removes many calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-41-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/page_io.c~swap-convert-swap_writepage-to-use-a-folio
+++ a/mm/page_io.c
@@ -180,29 +180,30 @@ bad_bmap:
  */
 int swap_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct folio *folio = page_folio(page);
 	int ret = 0;
 
-	if (try_to_free_swap(page)) {
-		unlock_page(page);
+	if (folio_free_swap(folio)) {
+		folio_unlock(folio);
 		goto out;
 	}
 	/*
 	 * Arch code may have to preserve more data than just the page
 	 * contents, e.g. memory tags.
 	 */
-	ret = arch_prepare_to_swap(page);
+	ret = arch_prepare_to_swap(&folio->page);
 	if (ret) {
-		set_page_dirty(page);
-		unlock_page(page);
+		folio_mark_dirty(folio);
+		folio_unlock(folio);
 		goto out;
 	}
-	if (frontswap_store(page) == 0) {
-		set_page_writeback(page);
-		unlock_page(page);
-		end_page_writeback(page);
+	if (frontswap_store(&folio->page) == 0) {
+		folio_start_writeback(folio);
+		folio_unlock(folio);
+		folio_end_writeback(folio);
 		goto out;
 	}
-	ret = __swap_writepage(page, wbc);
+	ret = __swap_writepage(&folio->page, wbc);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from willy@infradead.org are


