Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E226E7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbjJDUR3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjJDUR1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB1AC1
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D61C433C7;
        Wed,  4 Oct 2023 20:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450643;
        bh=GhXyOob5tSNEU4WHDKfNWsegaF+IwXdbeL5QXyuRiIQ=;
        h=Date:To:From:Subject:From;
        b=wOUtglxKtyyruXfYix0OB+gSaDbAMR49ukv2VaTxCO85X2/AnnzeMovcW2t9Lu5r2
         aydDXFoptJGeSGLasp3s9Gvq0H1gq1ITlOkwFfiElUicEYH56QtpdR1XZVr8jBTdib
         FmJ1NgHWw9Vl837ysbAH/ELw3/YCzL2OxV7XGMPE=
Date:   Wed, 04 Oct 2023 13:17:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch removed from -mm tree
Message-Id: <20231004201723.75D61C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: call list_is_{first}/{last} more intuitively in move_freelist_{head}/{tail}
has been removed from the -mm tree.  Its filename was
     mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: call list_is_{first}/{last} more intuitively in move_freelist_{head}/{tail}
Date: Fri, 1 Sep 2023 23:51:37 +0800

We use move_freelist_head after list_for_each_entry_reverse to skip recent
pages.  And there is no need to do actual move if all freepages are
searched in list_for_each_entry_reverse, e.g.  freepage point to first
page in freelist.  It's more intuitively to call list_is_first with list
entry as the first argument and list head as the second argument to check
if list entry is the first list entry instead of call list_is_last with
list entry and list head passed in reverse.

Similarly, call list_is_last in move_freelist_tail is more intuitively.

Link: https://lkml.kernel.org/r/20230901155141.249860-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail
+++ a/mm/compaction.c
@@ -1395,7 +1395,7 @@ move_freelist_head(struct list_head *fre
 {
 	LIST_HEAD(sublist);
 
-	if (!list_is_last(freelist, &freepage->buddy_list)) {
+	if (!list_is_first(&freepage->buddy_list, freelist)) {
 		list_cut_before(&sublist, freelist, &freepage->buddy_list);
 		list_splice_tail(&sublist, freelist);
 	}
@@ -1412,7 +1412,7 @@ move_freelist_tail(struct list_head *fre
 {
 	LIST_HEAD(sublist);
 
-	if (!list_is_first(freelist, &freepage->buddy_list)) {
+	if (!list_is_last(&freepage->buddy_list, freelist)) {
 		list_cut_position(&sublist, freelist, &freepage->buddy_list);
 		list_splice_tail(&sublist, freelist);
 	}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

