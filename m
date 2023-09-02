Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056A6C83F33
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbjIBWid (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjIBWic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:38:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5AB1A7
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88CF60EE9
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FDCC433C7;
        Sat,  2 Sep 2023 22:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693694308;
        bh=RqiwTttwK7e+MJI1/3BRJaItVanGYUhoJ8/wlksSetE=;
        h=Date:To:From:Subject:From;
        b=v2DBos9tEiJ9WAuidR1Op7plIlMq7012NwnwCC2iSa3/ZVvOLx3sVgsAdCzDVB0WY
         q53pcpQ++RxsGkqorUSA4PMcxa8d0R/cumWNFQ8EWnOzWodBxJdFihiVwTmsy65UGI
         GY2CzjIXoNXclVYTCXSlysvF+6RfYHbL61PC3f30=
Date:   Sat, 02 Sep 2023 15:38:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch added to mm-unstable branch
Message-Id: <20230902223828.22FDCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: call list_is_{first}/{last} more intuitively in move_freelist_{head}/{tail}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch

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

mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

