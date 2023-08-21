Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B644EE49B2
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjHUUlb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjHUUkj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C78812F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4E5D64B13
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B45C433C7;
        Mon, 21 Aug 2023 20:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650423;
        bh=EkXrFoEtcbDyFzSI9gGvqmPsyMmA0LOfic2BVqsaieM=;
        h=Date:To:From:Subject:From;
        b=P2YnDtCz1sCYXqg98DrAzY7jyJYvMV/P7n3Aj9S8Gy62ag+M/c9DBczAwxaaA9Ikn
         VKUOfgJGY+9ibkT9TlUBbM3aNwQg+IwMgjgdeQ3pwgv952H3Xkp1p3EOit6dftYT5P
         Y23SVtnlhkEWR+rv7OsNJ1D/vcpMmTXXaJ1NoyzY=
Date:   Mon, 21 Aug 2023 13:40:22 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch removed from -mm tree
Message-Id: <20230821204023.15B45C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: only set skip flag if cc->no_set_skip_hint is false
has been removed from the -mm tree.  Its filename was
     mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: only set skip flag if cc->no_set_skip_hint is false
Date: Fri, 4 Aug 2023 19:04:54 +0800

Keep the same logic as update_pageblock_skip, only set skip if
no_set_skip_hint is false which is more reasonable.

Link: https://lkml.kernel.org/r/20230804110454.2935878-9-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false
+++ a/mm/compaction.c
@@ -1442,7 +1442,7 @@ fast_isolate_around(struct compact_contr
 	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
-	if (start_pfn == end_pfn)
+	if (start_pfn == end_pfn && !cc->no_set_skip_hint)
 		set_pageblock_skip(page);
 }
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


