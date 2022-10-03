Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F632C43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiJCVFd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiJCVEu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C767EB7CE
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CD56610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654E7C433D6;
        Mon,  3 Oct 2022 21:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831086;
        bh=tMjeVmX5e1zNuNeJMotCPLODA/LaMPNgkeqGg5+GOXI=;
        h=Date:To:From:Subject:From;
        b=d9FC5IB2E4iFqt18JU9zmtDlPQ7HeWpjjWkX7Vg9XEeZNqjDI8TDK8wE2Kstke4HI
         N+ShOwQheMmGEeG0xDrG1Cv5UI53ybz44B1fovkf3U5wsyk83+XVc8HQftdRX1l5zr
         xbw/SePC68AYbPrxGCC/BjGuPV2fV8KP43qJ/NVM=
Date:   Mon, 03 Oct 2022 14:04:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-remove-page_swapcount.patch removed from -mm tree
Message-Id: <20221003210446.654E7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: remove page_swapcount()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-remove-page_swapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swapfile: remove page_swapcount()
Date: Fri, 2 Sep 2022 20:46:05 +0100

By restructuring folio_swapped(), it can use swap_swapcount() instead of
page_swapcount().  It's even a little more efficient.

Link: https://lkml.kernel.org/r/20220902194653.1739778-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   46 +++++++++++++---------------------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-remove-page_swapcount
+++ a/mm/swapfile.c
@@ -1431,30 +1431,6 @@ void swapcache_free_entries(swp_entry_t
 		spin_unlock(&p->lock);
 }
 
-/*
- * How many references to page are currently swapped out?
- * This does not give an exact answer when swap count is continued,
- * but does include the high COUNT_CONTINUED flag to allow for that.
- */
-static int page_swapcount(struct page *page)
-{
-	int count = 0;
-	struct swap_info_struct *p;
-	struct swap_cluster_info *ci;
-	swp_entry_t entry;
-	unsigned long offset;
-
-	entry.val = page_private(page);
-	p = _swap_info_get(entry);
-	if (p) {
-		offset = swp_offset(entry);
-		ci = lock_cluster_or_swap_info(p, offset);
-		count = swap_count(p->swap_map[offset]);
-		unlock_cluster_or_swap_info(p, ci);
-	}
-	return count;
-}
-
 int __swap_count(swp_entry_t entry)
 {
 	struct swap_info_struct *si;
@@ -1469,11 +1445,16 @@ int __swap_count(swp_entry_t entry)
 	return count;
 }
 
+/*
+ * How many references to @entry are currently swapped out?
+ * This does not give an exact answer when swap count is continued,
+ * but does include the high COUNT_CONTINUED flag to allow for that.
+ */
 static int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
 {
-	int count = 0;
 	pgoff_t offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
+	int count;
 
 	ci = lock_cluster_or_swap_info(si, offset);
 	count = swap_count(si->swap_map[offset]);
@@ -1574,17 +1555,16 @@ unlock_out:
 
 static bool folio_swapped(struct folio *folio)
 {
-	swp_entry_t entry;
-	struct swap_info_struct *si;
+	swp_entry_t entry = folio_swap_entry(folio);
+	struct swap_info_struct *si = _swap_info_get(entry);
+
+	if (!si)
+		return false;
 
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return page_swapcount(&folio->page) != 0;
+		return swap_swapcount(si, entry) != 0;
 
-	entry = folio_swap_entry(folio);
-	si = _swap_info_get(entry);
-	if (si)
-		return swap_page_trans_huge_swapped(si, entry);
-	return false;
+	return swap_page_trans_huge_swapped(si, entry);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are


