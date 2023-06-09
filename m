Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA2DC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjFIXeH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFIXcy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26D49D7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCB7A61782
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC98C433EF;
        Fri,  9 Jun 2023 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353404;
        bh=+FXAAVI1zpbN8L9CkJ7Bu+qY7VC70m/EnEoignfc7dI=;
        h=Date:To:From:Subject:From;
        b=bFVFwYAzuXNke8f5k2wP1Q/oUN480oh6Zp6Funq35Pkpqt7JLn5SgSZUYbxjca37w
         WOSugkKoUdB2E8L/M+7eksUgqo3oJxoIvbDUbVsDiek9X/YOp9o8xdtzI2ObpajXbz
         3SMCPvV7nIyGyxqoZVYh8ZNpoASv/VsGtBH5DjEU=
Date:   Fri, 09 Jun 2023 16:30:03 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-shrink-until-can-accept.patch removed from -mm tree
Message-Id: <20230609233004.3CC98C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: shrink until can accept
has been removed from the -mm tree.  Its filename was
     mm-zswap-shrink-until-can-accept.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: shrink until can accept
Date: Fri, 26 May 2023 20:32:27 +0200

This update addresses an issue with the zswap reclaim mechanism, which
hinders the efficient offloading of cold pages to disk, thereby
compromising the preservation of the LRU order and consequently
diminishing, if not inverting, its performance benefits.

The functioning of the zswap shrink worker was found to be inadequate, as
shown by basic benchmark test.  For the test, a kernel build was utilized
as a reference, with its memory confined to 1G via a cgroup and a 5G swap
file provided.  The results are presented below, these are averages of
three runs without the use of zswap:

real 46m26s
user 35m4s
sys 7m37s

With zswap (zbud) enabled and max_pool_percent set to 1 (in a 32G
system), the results changed to:

real 56m4s
user 35m13s
sys 8m43s

written_back_pages: 18
reject_reclaim_fail: 0
pool_limit_hit:1478

Besides the evident regression, one thing to notice from this data is the
extremely low number of written_back_pages and pool_limit_hit.

The pool_limit_hit counter, which is increased in zswap_frontswap_store
when zswap is completely full, doesn't account for a particular scenario:
once zswap hits his limit, zswap_pool_reached_full is set to true; with
this flag on, zswap_frontswap_store rejects pages if zswap is still above
the acceptance threshold.  Once we include the rejections due to
zswap_pool_reached_full && !zswap_can_accept(), the number goes from 1478
to a significant 21578266.

Zswap is stuck in an undesirable state where it rejects pages because it's
above the acceptance threshold, yet fails to attempt memory reclaimation. 
This happens because the shrink work is only queued when
zswap_frontswap_store detects that it's full and the work itself only
reclaims one page per run.

This state results in hot pages getting written directly to disk, while
cold ones remain memory, waiting only to be invalidated.  The LRU order is
completely broken and zswap ends up being just an overhead without
providing any benefits.

This commit applies 2 changes: a) the shrink worker is set to reclaim
pages until the acceptance threshold is met and b) the task is also
enqueued when zswap is not full but still above the threshold.

Testing this suggested update showed much better numbers:

real 36m37s
user 35m8s
sys 9m32s

written_back_pages: 10459423
reject_reclaim_fail: 12896
pool_limit_hit: 75653

Link: https://lkml.kernel.org/r/20230526183227.793977-1-cerasuolodomenico@gmail.com
Fixes: 45190f01dd40 ("mm/zswap.c: add allocation hysteresis if pool limit is hit")
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-shrink-until-can-accept
+++ a/mm/zswap.c
@@ -37,6 +37,7 @@
 #include <linux/workqueue.h>
 
 #include "swap.h"
+#include "internal.h"
 
 /*********************************
 * statistics
@@ -587,9 +588,19 @@ static void shrink_worker(struct work_st
 {
 	struct zswap_pool *pool = container_of(w, typeof(*pool),
 						shrink_work);
+	int ret, failures = 0;
 
-	if (zpool_shrink(pool->zpool, 1, NULL))
-		zswap_reject_reclaim_fail++;
+	do {
+		ret = zpool_shrink(pool->zpool, 1, NULL);
+		if (ret) {
+			zswap_reject_reclaim_fail++;
+			if (ret != -EAGAIN)
+				break;
+			if (++failures == MAX_RECLAIM_RETRIES)
+				break;
+		}
+		cond_resched();
+	} while (!zswap_can_accept());
 	zswap_pool_put(pool);
 }
 
@@ -1188,7 +1199,7 @@ static int zswap_frontswap_store(unsigne
 	if (zswap_pool_reached_full) {
 	       if (!zswap_can_accept()) {
 			ret = -ENOMEM;
-			goto reject;
+			goto shrink;
 		} else
 			zswap_pool_reached_full = false;
 	}
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are


