Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1664FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 21:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiDZVvS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiDZVvS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 17:51:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436AC689A2
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 14:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB93C61773
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 21:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4C0C385A4;
        Tue, 26 Apr 2022 21:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651009687;
        bh=UHdQnZRuFJEAmqrRSkCnJ0RxaREGaFJjpLp8/kUZ8D4=;
        h=Date:To:From:Subject:From;
        b=Jh1FeIEsrgIt1sT4flrFJaTzOMINdNHtLl6riQoLXzB4xd7LG/VQNKmEsiDYz0hBk
         0d+/+m8qTZ4kJ0Mt59W2dkRv/SY91GPSyTCvwAO6qs8NqXbqq8lEwC/ATD8kP2GmLE
         C9xcaWlLaQesEghxiAbRYTmTXvdKp7w1VortUtB8=
Date:   Tue, 26 Apr 2022 14:48:06 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch added to -mm tree
Message-Id: <20220426214807.2C4C0C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: not necessary to re-init the list for each iteration
has been added to the -mm tree.  Its filename is
     mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan: not necessary to re-init the list for each iteration

node_page_list is defined with LIST_HEAD and be cleaned until
list_empty.

So it is not necessary to re-init it again.

Link: https://lkml.kernel.org/r/20220426021743.21007-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration
+++ a/mm/vmscan.c
@@ -2574,7 +2574,6 @@ unsigned long reclaim_pages(struct list_
 		page = lru_to_page(page_list);
 		if (nid == NUMA_NO_NODE) {
 			nid = page_to_nid(page);
-			INIT_LIST_HEAD(&node_page_list);
 		}
 
 		if (nid == page_to_nid(page)) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-memcg-non-hierarchical-mode-is-deprecated.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch

