Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6D7CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbjJRVg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDD1192
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65777C433C7;
        Wed, 18 Oct 2023 21:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664930;
        bh=NxO7GtzeBDh1vvsGp4xdVC4LUwRkUjZbStFH9SAzoSs=;
        h=Date:To:From:Subject:From;
        b=WIkurS9jChKn1wxdva+RRP66vFXuoPaiKd4r0dycVAPQBdY/E+cUELgNSa3qtVtO+
         ok8DroNypWlEYm4UAjvirAH1jkRS0V2zGm4m2pbbyzy3WAHhYrpG3AfNsJsIwBafj7
         PYAfYmQbNBEU0MMAo20JBwiJk+GVNgwXICznnuPM=
Date:   Wed, 18 Oct 2023 14:35:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        naoya.horiguchi@nec.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch removed from -mm tree
Message-Id: <20231018213530.65777C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove unnecessary check in break_down_buddy_pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: remove unnecessary check in break_down_buddy_pages
Date: Wed, 27 Sep 2023 18:35:13 +0800

Patch series "Two minor cleanups to break_down_buddy_pages", v2.

Two minor cleanups to break_down_buddy_pages.


This patch (of 2):

1. We always have target in range started with next_page and full free
   range started with current_buddy.

2. The last split range size is 1 << low and low should be >= 0, then
   size >= 1.  So page + size != page is always true (because size > 0). 
   As summary, current_page will not equal to target page.

Link: https://lkml.kernel.org/r/20230927103514.98281-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230927103514.98281-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages
+++ a/mm/page_alloc.c
@@ -6480,10 +6480,8 @@ static void break_down_buddy_pages(struc
 		if (set_page_guard(zone, current_buddy, high, migratetype))
 			continue;
 
-		if (current_buddy != target) {
-			add_to_free_list(current_buddy, zone, high, migratetype);
-			set_buddy_order(current_buddy, high);
-		}
+		add_to_free_list(current_buddy, zone, high, migratetype);
+		set_buddy_order(current_buddy, high);
 	}
 }
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


