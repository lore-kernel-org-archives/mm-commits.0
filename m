Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2D2C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 19:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjFITZx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 15:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjFITZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 15:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512472D44
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 12:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFD5065B48
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 19:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386F8C433EF;
        Fri,  9 Jun 2023 19:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686338750;
        bh=QPa3riVH6KJPUlJy3f4Jo6gwZiIv748rwmgC0GG0n/M=;
        h=Date:To:From:Subject:From;
        b=10RVRWvp+2BT3umV6BHkSRxsndS3qQgEAfuAtieZDJ28Y5q5dse76v94FoztxvMcb
         UWUeE13eRAgCPJT3paC5WUYoL8CmD8Fb39bnXnwMoCqlnOO5uqfw/c3wzzdHeoK41B
         r6YL2vByjfcox7Tomjpi/VSSXn/yxYmEPSUh06P8=
Date:   Fri, 09 Jun 2023 12:25:49 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch removed from -mm tree
Message-Id: <20230609192550.386F8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: move shrinker_debugfs_remove() before synchronize_srcu()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmscan: move shrinker_debugfs_remove() before synchronize_srcu()
Date: Thu, 1 Jun 2023 13:27:14 +0000

The debugfs_remove_recursive() will wait for debugfs_file_put() to return,
so there is no need to put it after synchronize_srcu() to wait for the rcu
read-side critical section to exit.

Just move it before synchronize_srcu(), which is also convenient to put
the heavy synchronize_srcu() in the delayed work later.

Link: https://lkml.kernel.org/r/20230601132714.2540707-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu
+++ a/mm/vmscan.c
@@ -818,11 +818,11 @@ void unregister_shrinker(struct shrinker
 	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
 	mutex_unlock(&shrinker_mutex);
 
+	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
+
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 
-	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
-
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch
revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
revert-mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
revert-mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
revert-mm-vmscan-add-shrinker_srcu_generation.patch
revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch
revert-mm-vmscan-make-global-slab-shrink-lockless.patch

