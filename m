Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40C8CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjJRVhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbjJRVgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39FB195
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D55C43395;
        Wed, 18 Oct 2023 21:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664931;
        bh=EcEEJrjvl+PAt1L9bRffvwZIHSfdlU09cBzTffChFeM=;
        h=Date:To:From:Subject:From;
        b=2frt/zPANZI3JdX4wAyG5xJ+ncS6uaceYY2/XvvRmnwodJCFK7mn+rv6kXy7O2v/4
         otEfviXQT3H++zOMjNz7TwZreBm8vRJCJUtjqFKYjKA+/eWzYRS3l2OzEPocZzVLFO
         xv0oSTVNIK06AuZdM1ycuKX6Ru9XUyh2YpAGsRQ4=
Date:   Wed, 18 Oct 2023 14:35:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        naoya.horiguchi@nec.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch removed from -mm tree
Message-Id: <20231018213531.56D55C43395@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove unnecessary next_page in break_down_buddy_pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: remove unnecessary next_page in break_down_buddy_pages
Date: Wed, 27 Sep 2023 18:35:14 +0800

The next_page is only used to forward page in case target is in second
half range.  Move forward page directly to remove unnecessary next_page.

Link: https://lkml.kernel.org/r/20230927103514.98281-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages
+++ a/mm/page_alloc.c
@@ -6462,20 +6462,18 @@ static void break_down_buddy_pages(struc
 				   int migratetype)
 {
 	unsigned long size = 1 << high;
-	struct page *current_buddy, *next_page;
+	struct page *current_buddy;
 
 	while (high > low) {
 		high--;
 		size >>= 1;
 
 		if (target >= &page[size]) {
-			next_page = page + size;
 			current_buddy = page;
+			page = page + size;
 		} else {
-			next_page = page;
 			current_buddy = page + size;
 		}
-		page = next_page;
 
 		if (set_page_guard(zone, current_buddy, high, migratetype))
 			continue;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


