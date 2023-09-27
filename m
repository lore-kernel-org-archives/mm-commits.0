Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F95DE82CA5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 15:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjI0Pyr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjI0Pyh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 11:54:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6391F10EF
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 08:51:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5DAC433CA;
        Wed, 27 Sep 2023 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695829864;
        bh=X6eTUywcOq/6kb0lV3H4SwRu0AIQOvDOQNf5XaienEU=;
        h=Date:To:From:Subject:From;
        b=2TbJj7H0hiwej57BRTsKoYk54FJlt9D8lrg8x9qxC+SE2p+ODU0k2tvKvPVwJL+aF
         jAaDzGcdjJ/ZjSWBonoNNhm54eBwZJHVOmeHxEGYy/sMELc06IkCEYZ7ndOAyGh/ZL
         fHVV0dcBhYx6RV+x7tkjQIEs8VgDi0MTeILNJd1w=
Date:   Wed, 27 Sep 2023 08:51:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        naoya.horiguchi@nec.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch added to mm-unstable branch
Message-Id: <20230927155103.ED5DAC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove unnecessary check in break_down_buddy_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch

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
@@ -6696,10 +6696,8 @@ static void break_down_buddy_pages(struc
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

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch
mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

