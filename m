Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E8BC83F2C
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbjIBWib (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjIBWia (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:38:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73B61A7
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50CBDB808BB
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C37C433C7;
        Sat,  2 Sep 2023 22:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693694305;
        bh=QAUZNDvAsrtnxig1HJyE8wS4GulQ2tyPgBeqXs2mMTs=;
        h=Date:To:From:Subject:From;
        b=REcBJOGUjWriyDJKUdJn2oGCblcPQ68s/toDdvx3ab/WIQqGCw697NtPuw75LBgJG
         S98ooMxUrL6JUrJ8c0ged/Dku+x5btKeX99RtkCbk6/WTPArcalbox5/yWT3icRzRp
         ZYSsKPZTESMy3Mx6veQcFxqkoKBNWZaMeGP0mT44=
Date:   Sat, 02 Sep 2023 15:38:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-use-correct-list-in-move_freelist_head-tail.patch added to mm-unstable branch
Message-Id: <20230902223824.F0C37C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: use correct list in move_freelist_{head}/{tail}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-use-correct-list-in-move_freelist_head-tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-use-correct-list-in-move_freelist_head-tail.patch

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

mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

