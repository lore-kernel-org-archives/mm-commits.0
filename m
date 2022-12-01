Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A33C4708E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiLAALY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiLAAKJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:10:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D49189329
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 070BE61E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B19C43140;
        Thu,  1 Dec 2022 00:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852992;
        bh=UdX1SsicP7ytTMI1VolEHoYLrDOG7+ZwU6UQHDAQPBw=;
        h=Date:To:From:Subject:From;
        b=yZ4Qi8okC/MSLu013TSXXvtqbzEYnmWpAJTc5QKzGO5uXbodGKMDdz0Xbf0oiIbQy
         lWM2gGVuJ/n6oOkAxXgrwgkYuCH51t8fDz9tydoXXM9U1CZfCJKpdqcuj2mvezOaYr
         oLmzG8IkT0bsPgW6MSHzMrT2tO33zup9wV3n+k58=
Date:   Wed, 30 Nov 2022 16:03:11 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        nphamcs@gmail.com, minchan@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zswap-do-not-allocate-from-atomic-pool.patch removed from -mm tree
Message-Id: <20221201000312.31B19C43140@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap: do not allocate from atomic pool
has been removed from the -mm tree.  Its filename was
     zswap-do-not-allocate-from-atomic-pool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zswap: do not allocate from atomic pool
Date: Tue, 22 Nov 2022 12:30:22 +0900

zswap_frontswap_load() should be called from preemptible context (we even
call mutex_lock() there) and it does not look like we need to do
GFP_ATOMIC allocaion for temp buffer.  The same applies to
zswap_writeback_entry().

Use GFP_KERNEL for temporary buffer allocation in both cases.

Link: https://lkml.kernel.org/r/Y3xCTr6ikbtcUr/y@google.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    7 +++++++
 mm/zswap.c |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/mm/zpool.c~zswap-do-not-allocate-from-atomic-pool
+++ a/mm/zpool.c
@@ -387,6 +387,13 @@ bool zpool_evictable(struct zpool *zpool
  * zpool_can_sleep_mapped - Test if zpool can sleep when do mapped.
  * @zpool:	The zpool to test
  *
+ * Some allocators enter non-preemptible context in ->map() callback (e.g.
+ * disable pagefaults) and exit that context in ->unmap(), which limits what
+ * we can do with the mapped object. For instance, we cannot wait for
+ * asynchronous crypto API to decompress such an object or take mutexes
+ * since those will call into the scheduler. This function tells us whether
+ * we use such an allocator.
+ *
  * Returns: true if zpool can sleep; false otherwise.
  */
 bool zpool_can_sleep_mapped(struct zpool *zpool)
--- a/mm/zswap.c~zswap-do-not-allocate-from-atomic-pool
+++ a/mm/zswap.c
@@ -958,7 +958,7 @@ static int zswap_writeback_entry(struct
 	};
 
 	if (!zpool_can_sleep_mapped(pool)) {
-		tmp = kmalloc(PAGE_SIZE, GFP_ATOMIC);
+		tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!tmp)
 			return -ENOMEM;
 	}
@@ -1311,7 +1311,7 @@ static int zswap_frontswap_load(unsigned
 	}
 
 	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
-		tmp = kmalloc(entry->length, GFP_ATOMIC);
+		tmp = kmalloc(entry->length, GFP_KERNEL);
 		if (!tmp) {
 			ret = -ENOMEM;
 			goto freeentry;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


