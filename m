Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEAAE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbjJDURm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbjJDURk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4B0C6
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BD7C433C8;
        Wed,  4 Oct 2023 20:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450657;
        bh=dZh7b8tlj1lltTNJaMO5ePR9zZR9/E8W6EUIvuKgQyU=;
        h=Date:To:From:Subject:From;
        b=CatiXsT0crSElyG9AWbi7htYKH6H/66UEz+njWjjj19EvIRVM3NignuqDvbW5yXFT
         BipvhYsux4QvCBY372FOLJ5ywJe2FM+Ue/Nk4zN6K4S/25CL11NNKcKQq7dmjphu7X
         QjAtL61DrDOXXmv8QlutaYQcaEIWXA6cNEI+e7Ig=
Date:   Wed, 04 Oct 2023 13:17:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-use-correct-list-in-move_freelist_head-tail.patch removed from -mm tree
Message-Id: <20231004201736.D0BD7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: use correct list in move_freelist_{head}/{tail}
has been removed from the -mm tree.  Its filename was
     mm-compaction-use-correct-list-in-move_freelist_head-tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: use correct list in move_freelist_{head}/{tail}
Date: Fri, 1 Sep 2023 23:51:36 +0800

Patch series "Fixes and cleanups to compaction", v3.

This is a series to do fix and clean up to compaction.
Patch 1-2 fix and clean up freepage list operation.
Patch 3-4 fix and clean up isolation of freepages
Patch 7 factor code to check if compaction is needed for allocation order.

More details can be found in respective patches. 


This patch (of 6):

The freepage is chained with buddy_list in freelist head. Use buddy_list
instead of lru to correct the list operation.

Link: https://lkml.kernel.org/r/20230901155141.249860-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230901155141.249860-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-use-correct-list-in-move_freelist_head-tail
+++ a/mm/compaction.c
@@ -1395,8 +1395,8 @@ move_freelist_head(struct list_head *fre
 {
 	LIST_HEAD(sublist);
 
-	if (!list_is_last(freelist, &freepage->lru)) {
-		list_cut_before(&sublist, freelist, &freepage->lru);
+	if (!list_is_last(freelist, &freepage->buddy_list)) {
+		list_cut_before(&sublist, freelist, &freepage->buddy_list);
 		list_splice_tail(&sublist, freelist);
 	}
 }
@@ -1412,8 +1412,8 @@ move_freelist_tail(struct list_head *fre
 {
 	LIST_HEAD(sublist);
 
-	if (!list_is_first(freelist, &freepage->lru)) {
-		list_cut_position(&sublist, freelist, &freepage->lru);
+	if (!list_is_first(freelist, &freepage->buddy_list)) {
+		list_cut_position(&sublist, freelist, &freepage->buddy_list);
 		list_splice_tail(&sublist, freelist);
 	}
 }
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

