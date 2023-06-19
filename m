Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBD3EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjFSUU0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFSUUV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D3BE7F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A11860C55
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80817C433C8;
        Mon, 19 Jun 2023 20:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206017;
        bh=+jClXEmro9VbB2hnHmOOG6AUq/lne5XGuQYjj1xkdyY=;
        h=Date:To:From:Subject:From;
        b=N4yH1e0QaQhSfrrvFkdBknwnGURNZRQAcc1uuRPZ7tvj2eURhfbRR5l9Sct4yN87C
         NCQcRag2eWE9STh5rN2lizLLQ8/o3J8LWasypRxQsKmSw9qz2WBLHEzeRaCEYLCusL
         TPFhKvpk+gnTSz+hXhNfDN51xL99belvRj2+uDpc=
Date:   Mon, 19 Jun 2023 13:20:16 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch removed from -mm tree
Message-Id: <20230619202017.80817C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: vmscan: hold write lock to reparent shrinker nr_deferred"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Revert "mm: vmscan: hold write lock to reparent shrinker nr_deferred"
Date: Fri, 9 Jun 2023 08:15:14 +0000

This reverts commit b3cabea3c9153fd42fe5cb851ac58b51ea2b32b8.

Kernel test robot reports -88.8% regression in stress-ng.ramfs.ops_per_sec
test case [1], which is caused by commit f95bdb700bc6 ("mm: vmscan: make
global slab shrink lockless"). The root cause is that SRCU has to be careful
to not frequently check for SRCU read-side critical section exits. Therefore,
even if no one is currently in the SRCU read-side critical section,
synchronize_srcu() cannot return quickly. That's why unregister_shrinker()
has become slower.

We will try to use the refcount+RCU method [2] proposed by Dave Chinner
to continue to re-implement the lockless slab shrink. Because there will
be other readers after reverting the shrinker_srcu related changes, so
it is better to restore to hold read lock to reparent shrinker nr_deferred.

[1]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[2]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

Link: https://lkml.kernel.org/r/20230609081518.3039120-4-qi.zheng@linux.dev
Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202305230837.db2c233f-yujie.liu@intel.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~revert-mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred
+++ a/mm/vmscan.c
@@ -433,7 +433,7 @@ void reparent_shrinker_deferred(struct m
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_write(&shrinker_rwsem);
+	down_read(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -442,7 +442,7 @@ void reparent_shrinker_deferred(struct m
 			atomic_long_add(nr, &parent_info->nr_deferred[i]);
 		}
 	}
-	up_write(&shrinker_rwsem);
+	up_read(&shrinker_rwsem);
 }
 
 static bool cgroup_reclaim(struct scan_control *sc)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


