Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092DEC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Oct 2022 21:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiJGV3V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJGV3U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2022 17:29:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD4D8F25C
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 14:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09BF7B82477
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 21:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A42C433D7;
        Fri,  7 Oct 2022 21:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665178156;
        bh=b/nGIBQR7E0xZyGaTn4iPaNuYyrZxjyzg6QHnuxZ2Wc=;
        h=Date:To:From:Subject:From;
        b=OzbabRtHuqMw38f5Sj1s/fZcADu4vxLRI5l2hjyuUr9tEXNEt4FPX+els1T8iXaE2
         grm7jBBG+TxPFKSJyKDS1Tn1gS1ubL6u3PuZocGTtW1iQGEZk5tZyv1ZZRZj7mbSwH
         VGfCzg+snS6NkAIrcDBCtDjRI1Ml/UCndJycuA54=
Date:   Fri, 07 Oct 2022 14:29:15 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mglru-mm-vmscanc-fix-imprecise-comments.patch removed from -mm tree
Message-Id: <20221007212916.B3A42C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mglru: mm/vmscan.c: fix imprecise comments
has been removed from the -mm tree.  Its filename was
     mglru-mm-vmscanc-fix-imprecise-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mglru: mm/vmscan.c: fix imprecise comments
Date: Wed, 28 Sep 2022 12:46:20 -0600

Link: https://lkml.kernel.org/r/YzSWfFI+MOeb1ils@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mglru-mm-vmscanc-fix-imprecise-comments
+++ a/mm/vmscan.c
@@ -5076,7 +5076,7 @@ static bool should_abort_scan(struct lru
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (!current_is_kswapd()) {
-		/* age each memcg once to ensure fairness */
+		/* age each memcg at most once to ensure fairness */
 		if (max_seq - seq > 1)
 			return true;
 
@@ -5101,10 +5101,9 @@ static bool should_abort_scan(struct lru
 
 	/*
 	 * A minimum amount of work was done under global memory pressure. For
-	 * kswapd, it may be overshooting. For direct reclaim, the target isn't
-	 * met, and yet the allocation may still succeed, since kswapd may have
-	 * caught up. In either case, it's better to stop now, and restart if
-	 * necessary.
+	 * kswapd, it may be overshooting. For direct reclaim, the allocation
+	 * may succeed if all suitable zones are somewhat safe. In either case,
+	 * it's better to stop now, and restart later if necessary.
 	 */
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		unsigned long wmark;
_

Patches currently in -mm which might be from yuzhao@google.com are


