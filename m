Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815EBC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 20:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiKQUNd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 15:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiKQUNc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 15:13:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9076CCE6
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 12:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53322B821F3
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 20:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D7FC433C1;
        Thu, 17 Nov 2022 20:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668716004;
        bh=n4nVPRs0TKY7vD263u4d3+NOZNF36hUEdWQt8S0Ptg8=;
        h=Date:To:From:Subject:From;
        b=LLnBaftPJnlFvn8eNXB4MyXXJnackWZ0aRZxwcbernggrisiwngpW8tj9dLLyWAUl
         TNmXWhTvDMRtLgCa2XWO05yNe7KLZRZcC8a6i/zosntuO6oXpalWPkxjOJM/ElN5OM
         fw/uzPuisOK2r6z8ex6kLqCBJHC+rUfKEgKJJ9v4=
Date:   Thu, 17 Nov 2022 12:13:23 -0800
To:     mm-commits@vger.kernel.org, Chao.Xu9@zeekrlife.com,
        amos.xuchao@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan.patch removed from -mm tree
Message-Id: <20221117201324.09D7FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: simplify the nr assignment logic for pages to scan
has been removed from the -mm tree.  Its filename was
     mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Chao Xu <amos.xuchao@gmail.com>
Subject: mm/vmscan: simplify the nr assignment logic for pages to scan
Date: Thu, 10 Nov 2022 19:31:30 +0800

By default the assignment logic of anonymouns or file inactive pages and
active pages to scan using the same duplicated code snippet.  To simplify
the logic, merge the same part.

Link: https://lkml.kernel.org/r/20221110113130.284290-1-Chao.Xu9@zeekrlife.com
Signed-off-by: Chao Xu <Chao.Xu9@zeekrlife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan
+++ a/mm/vmscan.c
@@ -5969,15 +5969,11 @@ static void shrink_lruvec(struct lruvec
 		 * Recalculate the other LRU scan count based on its original
 		 * scan target and the percentage scanning already complete
 		 */
-		lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
-		nr_scanned = targets[lru] - nr[lru];
-		nr[lru] = targets[lru] * (100 - percentage) / 100;
-		nr[lru] -= min(nr[lru], nr_scanned);
-
-		lru += LRU_ACTIVE;
-		nr_scanned = targets[lru] - nr[lru];
-		nr[lru] = targets[lru] * (100 - percentage) / 100;
-		nr[lru] -= min(nr[lru], nr_scanned);
+		for ( ; lru <= lru + LRU_ACTIVE; lru += LRU_ACTIVE) {
+			nr_scanned = targets[lru] - nr[lru];
+			nr[lru] = targets[lru] * (100 - percentage) / 100;
+			nr[lru] -= min(nr[lru], nr_scanned);
+		}
 	}
 	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
_

Patches currently in -mm which might be from amos.xuchao@gmail.com are


