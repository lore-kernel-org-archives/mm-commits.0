Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B8CC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjC1XYP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjC1XWz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894713C01
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 244AA619F9
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3CDC433D2;
        Tue, 28 Mar 2023 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045742;
        bh=v5VRWN1Fr5Lvv0Hg8IBaUvDG6ymyulGGUBK/0625bYQ=;
        h=Date:To:From:Subject:From;
        b=p1PkITHwafaR1wtvM4/soTVuWcrYMGGU8Tlt39oE4V/ZIwOo7EZb1IL8n2uEBhBpI
         Zc8SBZw4xKpBJ/tlc3KgZSpTCGKYfIdlrjypFlrsguZYQ4cWJYA6L27ng9LPJi47TF
         o/pyHTomJeQ8WCBWmLqoMhRfIg4T40nwfqQDsa3I=
Date:   Tue, 28 Mar 2023 16:22:21 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tkhai@ya.ru,
        sultan@kerneltoast.com, shy828301@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, penguin-kernel@i-love.sakura.ne.jp,
        paulmck@kernel.org, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, dave@stgolabs.net,
        christian.koenig@amd.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch removed from -mm tree
Message-Id: <20230328232222.7C3CDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: remove shrinker_rwsem from synchronize_shrinkers()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmscan: remove shrinker_rwsem from synchronize_shrinkers()
Date: Mon, 13 Mar 2023 19:28:18 +0800

Currently, the synchronize_shrinkers() is only used by TTM pool.  It only
requires that no shrinkers run in parallel, and doesn't care about
registering and unregistering of shrinkers.

Since slab shrink is protected by SRCU, synchronize_srcu() is sufficient
to ensure that no shrinker is running in parallel.  So the shrinker_rwsem
in synchronize_shrinkers() is no longer needed, just remove it.

Link: https://lkml.kernel.org/r/20230313112819.38938-8-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill Tkhai <tkhai@ya.ru>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers
+++ a/mm/vmscan.c
@@ -790,15 +790,11 @@ EXPORT_SYMBOL(unregister_shrinker);
 /**
  * synchronize_shrinkers - Wait for all running shrinkers to complete.
  *
- * This is equivalent to calling unregister_shrink() and register_shrinker(),
- * but atomically and with less overhead. This is useful to guarantee that all
- * shrinker invocations have seen an update, before freeing memory, similar to
- * rcu.
+ * This is useful to guarantee that all shrinker invocations have seen an
+ * update, before freeing memory.
  */
 void synchronize_shrinkers(void)
 {
-	down_write(&shrinker_rwsem);
-	up_write(&shrinker_rwsem);
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


