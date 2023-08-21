Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA79EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjHUUl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjHUUki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE0C1BB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C555A64B32
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257BAC433C9;
        Mon, 21 Aug 2023 20:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650418;
        bh=u1rrU/UL2lqbBp9jk5ZF2hXw0hTUU+iAaHP+uLlTAAA=;
        h=Date:To:From:Subject:From;
        b=Cv3BgB2hegyV9C9m9t6F27KvH0eYSXuJveyDvWzUJoHxEKhnfZlbt3G+Hbqnh8HwO
         3BFR2Kayf9u9bdlSPY8LKYHBs69I0gvixZFz8WBMvULBeKUV2IXxn5Ut9FN3fEuR3e
         8NNqNRmaZ8aBbGZcWHvTmmtovfPGtrY8eQEQJhW4=
Date:   Mon, 21 Aug 2023 13:40:17 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages.patch removed from -mm tree
Message-Id: <20230821204018.257BAC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: correct comment of fast_find_migrateblock in isolate_migratepages
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: correct comment of fast_find_migrateblock in isolate_migratepages
Date: Fri, 4 Aug 2023 19:04:50 +0800

After 90ed667c03fe5 ("Revert "Revert "mm/compaction: fix set skip in
fast_find_migrateblock"""), we remove skip set in fast_find_migrateblock. 
Correct comment that fast_find_block is used to avoid isolation_suitable
check for pageblock returned from fast_find_migrateblock because
fast_find_migrateblock will mark found pageblock skipped.

Instead, comment that fast_find_block is used to avoid a redundant check
of fast found pageblock which is already checked skip flag inside
fast_find_migrateblock.

Link: https://lkml.kernel.org/r/20230804110454.2935878-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages
+++ a/mm/compaction.c
@@ -1987,9 +1987,9 @@ static isolate_migrate_t isolate_migrate
 		block_start_pfn = cc->zone->zone_start_pfn;
 
 	/*
-	 * fast_find_migrateblock marks a pageblock skipped so to avoid
-	 * the isolation_suitable check below, check whether the fast
-	 * search was successful.
+	 * fast_find_migrateblock() has already ensured the pageblock is not
+	 * set with a skipped flag, so to avoid the isolation_suitable check
+	 * below again, check whether the fast search was successful.
 	 */
 	fast_find_block = low_pfn != cc->migrate_pfn && !cc->fast_search_fail;
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


