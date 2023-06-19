Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DA5C001DE
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjFSUU0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjFSUUV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3528DE7E
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 144FB60EB0
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C19BC433C8;
        Mon, 19 Jun 2023 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206016;
        bh=/icd64qkLbqreKJd3BuDyH2okX0wHugcTzM+I54Va2E=;
        h=Date:To:From:Subject:From;
        b=EerlLHu7OY9NXuElwIZYEEVkTN1TGdrrITnS79LmZFnGhnIMq1Sh7ThStUKsDT2cO
         W9M+yGyMQenm7sZDT6y9jmnVlZ0PmyfIriAKaS7GDNibveUMS/l0aCyVvJP9OWlc8x
         ODpf58BSVaiYrU5fpA/fHnGgquN2RrDc4noK6WZ8=
Date:   Mon, 19 Jun 2023 13:20:15 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch removed from -mm tree
Message-Id: <20230619202016.6C19BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: vmscan: remove shrinker_rwsem from synchronize_shrinkers()"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Revert "mm: vmscan: remove shrinker_rwsem from synchronize_shrinkers()"
Date: Fri, 9 Jun 2023 08:15:13 +0000

This reverts commit 1643db98d9b314e0a592d152603094fbf7ab906e.

Kernel test robot reports -88.8% regression in stress-ng.ramfs.ops_per_sec
test case [1], which is caused by commit f95bdb700bc6 ("mm: vmscan: make
global slab shrink lockless").  The root cause is that SRCU has to be
careful to not frequently check for SRCU read-side critical section exits.
Therefore, even if no one is currently in the SRCU read-side critical
section, synchronize_srcu() cannot return quickly.  That's why
unregister_shrinker() has become slower.

We will try to use the refcount+RCU method [2] proposed by Dave Chinner to
continue to re-implement the lockless slab shrink.  So we still need
shrinker_rwsem in synchronize_shrinkers() after reverting the
shrinker_srcu related changes.

[1]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[2]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

Link: https://lkml.kernel.org/r/20230609081518.3039120-3-qi.zheng@linux.dev
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

 mm/vmscan.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers
+++ a/mm/vmscan.c
@@ -831,11 +831,15 @@ EXPORT_SYMBOL(unregister_shrinker);
 /**
  * synchronize_shrinkers - Wait for all running shrinkers to complete.
  *
- * This is useful to guarantee that all shrinker invocations have seen an
- * update, before freeing memory.
+ * This is equivalent to calling unregister_shrink() and register_shrinker(),
+ * but atomically and with less overhead. This is useful to guarantee that all
+ * shrinker invocations have seen an update, before freeing memory, similar to
+ * rcu.
  */
 void synchronize_shrinkers(void)
 {
+	down_write(&shrinker_rwsem);
+	up_write(&shrinker_rwsem);
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


