Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97CDEE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjHUUmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjHUUlv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11501183
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EE4464B00
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41C6C433D9;
        Mon, 21 Aug 2023 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650457;
        bh=SxvGhwIO9ISTEgpryu/FH3gJzGphiZ3tY8v5o//paEs=;
        h=Date:To:From:Subject:From;
        b=NyTXGCyWbbAl22LJPmDBxMqGr+gr7wrE3LOOgng0IVttw8aZrWn2zEpAel0MPisRX
         82IW52df+nKNhJnJ5cijkqVxXn/UmA63rl/j05kJ98Og/aOOYiB/48sYw6gats3sQO
         O+vpOIFTVPvRGK7URWKzabP9YZak+jjUbEREc5Uk=
Date:   Mon, 21 Aug 2023 13:40:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch removed from -mm tree
Message-Id: <20230821204056.F41C6C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: remove unused parameter pgdata of fragmentation_score_wmark
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: remove unused parameter pgdata of fragmentation_score_wmark
Date: Wed, 9 Aug 2023 17:49:10 +0800

Parameter pgdat is not used in fragmentation_score_wmark. Just remove it.

Link: https://lkml.kernel.org/r/20230809094910.3092446-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark
+++ a/mm/compaction.c
@@ -2140,7 +2140,7 @@ static unsigned int fragmentation_score_
 	return score;
 }
 
-static unsigned int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
+static unsigned int fragmentation_score_wmark(bool low)
 {
 	unsigned int wmark_low;
 
@@ -2160,7 +2160,7 @@ static bool should_proactive_compact_nod
 	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
 		return false;
 
-	wmark_high = fragmentation_score_wmark(pgdat, false);
+	wmark_high = fragmentation_score_wmark(false);
 	return fragmentation_score_node(pgdat) > wmark_high;
 }
 
@@ -2199,7 +2199,7 @@ static enum compact_result __compact_fin
 			return COMPACT_PARTIAL_SKIPPED;
 
 		score = fragmentation_score_zone(cc->zone);
-		wmark_low = fragmentation_score_wmark(pgdat, true);
+		wmark_low = fragmentation_score_wmark(true);
 
 		if (score > wmark_low)
 			ret = COMPACT_CONTINUE;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


