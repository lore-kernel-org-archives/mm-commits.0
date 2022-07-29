Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B06CC00144
	for <mm-commits@archiver.kernel.org>; Fri, 29 Jul 2022 18:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiG2SsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 14:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiG2SsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 14:48:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F201065821
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 11:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A62761F74
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6123C433C1;
        Fri, 29 Jul 2022 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659120502;
        bh=WwkX3lZSFc82PG8hpagO8rPmqnZczH9ZqVPy7Ax0sek=;
        h=Date:To:From:Subject:From;
        b=A2S0HdwGVUB4Hlw1I1uKPPeukGs/blOGj/1obbTAyor96UurVWzKfbKFvOJJhxIie
         U9K794ZOMAzC+Ev61Wt7QfTvxeJlbIl0qLaXqrc9vDVr+nXNDGzCMB0+Fw0E3OdECK
         k+i2XkSv6gymfWKQyiAjNivqpbKHwF8BsuzZyJM0=
Date:   Fri, 29 Jul 2022 11:48:22 -0700
To:     mm-commits@vger.kernel.org, ytk.lee@samsung.com, vbabka@suse.cz,
        stable@vger.kerenl.org, minchan@kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        gh21.hong@samsung.com, bhe@redhat.com, jaewon31.kim@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] page_alloc-fix-invalid-watemark-check-on-a-negative-value.patch removed from -mm tree
Message-Id: <20220729184822.D6123C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page_alloc: fix invalid watermark check on a negative value
has been removed from the -mm tree.  Its filename was
     page_alloc-fix-invalid-watemark-check-on-a-negative-value.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: page_alloc: fix invalid watermark check on a negative value
Date: Mon, 25 Jul 2022 18:52:12 +0900

There was a report that a task is waiting at the
throttle_direct_reclaim. The pgscan_direct_throttle in vmstat was
increasing.

This is a bug where zone_watermark_fast returns true even when the free
is very low. The commit f27ce0e14088 ("page_alloc: consider highatomic
reserve in watermark fast") changed the watermark fast to consider
highatomic reserve. But it did not handle a negative value case which
can be happened when reserved_highatomic pageblock is bigger than the
actual free.

If watermark is considered as ok for the negative value, allocating
contexts for order-0 will consume all free pages without direct reclaim,
and finally free page may become depleted except highatomic free.

Then allocating contexts may fall into throttle_direct_reclaim. This
symptom may easily happen in a system where wmark min is low and other
reclaimers like kswapd does not make free pages quickly.

Handle the negative case by using MIN.

Link: https://lkml.kernel.org/r/20220725095212.25388-1-jaewon31.kim@samsung.com
Fixes: f27ce0e14088 ("page_alloc: consider highatomic reserve in watermark fast")
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reported-by: GyeongHwan Hong <gh21.hong@samsung.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: <stable@vger.kerenl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~page_alloc-fix-invalid-watemark-check-on-a-negative-value
+++ a/mm/page_alloc.c
@@ -3968,11 +3968,15 @@ static inline bool zone_watermark_fast(s
 	 * need to be calculated.
 	 */
 	if (!order) {
-		long fast_free;
+		long usable_free;
+		long reserved;
 
-		fast_free = free_pages;
-		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
-		if (fast_free > mark + z->lowmem_reserve[highest_zoneidx])
+		usable_free = free_pages;
+		reserved = __zone_watermark_unusable_free(z, 0, alloc_flags);
+
+		/* reserved may over estimate high-atomic reserves. */
+		usable_free -= min(usable_free, reserved);
+		if (usable_free > mark + z->lowmem_reserve[highest_zoneidx])
 			return true;
 	}
 
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are


