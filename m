Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8C7C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJCVGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJCVFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4737193C9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86834610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA19C433D6;
        Mon,  3 Oct 2022 21:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831116;
        bh=4rApQMDh852Sc9tOZbecrvm9mwygHFMKCwmnX2gDDUs=;
        h=Date:To:From:Subject:From;
        b=mgI+cvne+ebdjTLqcduttXy+4bklKW54Si41tSucZbhgqhhZ1YIpni6DJ4cdqB+m8
         Mefnk1R1bpOFs8tVf1e/BauGxHrMIafIQ2//038+nOpW/EVlpj2Z3fH4TMpBRNZiNY
         P5XwM1QLaVddKbOVJQrz9ulq5QQcDsiuuQXepqOU=
Date:   Mon, 03 Oct 2022 14:05:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swapfile-convert-__try_to_reclaim_swap-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210515.DEA19C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swapfile: convert __try_to_reclaim_swap() to use a folio
has been removed from the -mm tree.  Its filename was
     swapfile-convert-__try_to_reclaim_swap-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swapfile: convert __try_to_reclaim_swap() to use a folio
Date: Fri, 2 Sep 2022 20:46:31 +0100

Saves five calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-36-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~swapfile-convert-__try_to_reclaim_swap-to-use-a-folio
+++ a/mm/swapfile.c
@@ -132,27 +132,27 @@ static int __try_to_reclaim_swap(struct
 				 unsigned long offset, unsigned long flags)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
-	struct page *page;
+	struct folio *folio;
 	int ret = 0;
 
-	page = find_get_page(swap_address_space(entry), offset);
-	if (!page)
+	folio = filemap_get_folio(swap_address_space(entry), offset);
+	if (!folio)
 		return 0;
 	/*
 	 * When this function is called from scan_swap_map_slots() and it's
-	 * called by vmscan.c at reclaiming pages. So, we hold a lock on a page,
+	 * called by vmscan.c at reclaiming folios. So we hold a folio lock
 	 * here. We have to use trylock for avoiding deadlock. This is a special
-	 * case and you should use try_to_free_swap() with explicit lock_page()
+	 * case and you should use folio_free_swap() with explicit folio_lock()
 	 * in usual operations.
 	 */
-	if (trylock_page(page)) {
+	if (folio_trylock(folio)) {
 		if ((flags & TTRS_ANYWAY) ||
-		    ((flags & TTRS_UNMAPPED) && !page_mapped(page)) ||
-		    ((flags & TTRS_FULL) && mem_cgroup_swap_full(page)))
-			ret = try_to_free_swap(page);
-		unlock_page(page);
+		    ((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
+		    ((flags & TTRS_FULL) && mem_cgroup_swap_full(&folio->page)))
+			ret = folio_free_swap(folio);
+		folio_unlock(folio);
 	}
-	put_page(page);
+	folio_put(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


