Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEFDC41513
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 19:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjJRTNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjJRTNP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 15:13:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E9C11D;
        Wed, 18 Oct 2023 12:13:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74042C433C7;
        Wed, 18 Oct 2023 19:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697656393;
        bh=lweJdFy3QfFbwuPeWxx5QKJW7lo6zTWLXHJ/6xFu/II=;
        h=Date:To:From:Subject:From;
        b=PpjJ/1RpFreH3j0RyC2rhaiQwjsT7M0kbqAtcmtOwaLsLQSxIspaF2qVjBPBK6+Ra
         Y4EUJ2OimNnd9lVmVblBCAdtElGQHFU3PPvdOkxB8vyFswURt+4mmmjn4S+Lo/hl8p
         skQf5eg4BJ1r7sVEGjHFBDAo8Ij50asSTQ1zYt/Q=
Date:   Wed, 18 Oct 2023 12:13:12 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        stable@vger.kernel.org, nphamcs@gmail.com, clm@fb.com,
        cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-pool-refcount-bug-around-shrink_worker.patch removed from -mm tree
Message-Id: <20231018191313.74042C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: fix pool refcount bug around shrink_worker()
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-pool-refcount-bug-around-shrink_worker.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: fix pool refcount bug around shrink_worker()
Date: Fri, 6 Oct 2023 12:00:24 -0400

When a zswap store fails due to the limit, it acquires a pool reference
and queues the shrinker.  When the shrinker runs, it drops the reference. 
However, there can be multiple store attempts before the shrinker wakes up
and runs once.  This results in reference leaks and eventual saturation
warnings for the pool refcount.

Fix this by dropping the reference again when the shrinker is already
queued.  This ensures one reference per shrinker run.

Link: https://lkml.kernel.org/r/20231006160024.170748-1-hannes@cmpxchg.org
Fixes: 45190f01dd40 ("mm/zswap.c: add allocation hysteresis if pool limit is hit")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Chris Mason <clm@fb.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: <stable@vger.kernel.org>	[5.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-pool-refcount-bug-around-shrink_worker
+++ a/mm/zswap.c
@@ -1383,8 +1383,8 @@ reject:
 
 shrink:
 	pool = zswap_pool_last_get();
-	if (pool)
-		queue_work(shrink_wq, &pool->shrink_work);
+	if (pool && !queue_work(shrink_wq, &pool->shrink_work))
+		zswap_pool_put(pool);
 	goto reject;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


