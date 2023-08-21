Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98C4EE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjHUUl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjHUUki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6781BC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 148AD64B06
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEAEC433C7;
        Mon, 21 Aug 2023 20:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650419;
        bh=Y8YZqiTpW/s+yGsGqk2xXgAIwF87PZn8w1tP7fjIOyY=;
        h=Date:To:From:Subject:From;
        b=oztlBoVOtyt3D5bqmBCZegoiwZbfB+gu660AVKjXnNxFviqRBhRPPhZttdfOx4MeG
         rh58Lc8Bl5xkUTwTCUa5JL5I5CH1f/0WFbMB/C+OVJslSozbbF3STaV5Em+TJyGVo9
         1+/MJ4sxtEvXrXWSDnh4ickCYQs3p/dR+2Zba3Ro=
Date:   Mon, 21 Aug 2023 13:40:18 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-correct-comment-of-cached-migrate-pfn-update.patch removed from -mm tree
Message-Id: <20230821204019.6DEAEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: correct comment of cached migrate pfn update
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-comment-of-cached-migrate-pfn-update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: correct comment of cached migrate pfn update
Date: Fri, 4 Aug 2023 19:04:51 +0800

Commit e380bebe47715 ("mm, compaction: keep migration source private to a
single compaction instance") moved update of async and sync
compact_cached_migrate_pfn from update_pageblock_skip to
update_cached_migrate but left the comment behind.  Move the relevant
comment to correct this.

Link: https://lkml.kernel.org/r/20230804110454.2935878-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-correct-comment-of-cached-migrate-pfn-update
+++ a/mm/compaction.c
@@ -469,6 +469,7 @@ static void update_cached_migrate(struct
 
 	pfn = pageblock_end_pfn(pfn);
 
+	/* Update where async and sync compaction should restart */
 	if (pfn > zone->compact_cached_migrate_pfn[0])
 		zone->compact_cached_migrate_pfn[0] = pfn;
 	if (cc->mode != MIGRATE_ASYNC &&
@@ -490,7 +491,6 @@ static void update_pageblock_skip(struct
 
 	set_pageblock_skip(page);
 
-	/* Update where async and sync compaction should restart */
 	if (pfn < zone->compact_cached_free_pfn)
 		zone->compact_cached_free_pfn = pfn;
 }
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


