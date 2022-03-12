Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F449C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Mar 2022 20:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiCLUfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Mar 2022 15:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiCLUf3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Mar 2022 15:35:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6C91DDFF7
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 12:34:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21E51B80B03
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 20:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB64FC340EB;
        Sat, 12 Mar 2022 20:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647117260;
        bh=jVJY7lhbGkLJyNXxnpHPMF6Nd7GdxJYy3tUwEOnOZO0=;
        h=Date:To:From:Subject:From;
        b=qSRJXUHuyv2yReAw7W153O0PT75kDSZz8etaNs3gSCOwXvHK5/PtnuYAAHGbkqY+G
         VdZ4s521siNEVImEOWtzIOFd2Z9FDN8YYHaKKrwE8611EQ6quxvKA1A3qKPZLHOf//
         587WCfPrUDBbaNf3Qa4tVFFajCq/OVgR5/pMmDlU=
Date:   Sat, 12 Mar 2022 12:34:20 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch added to -mm tree
Message-Id: <20220312203420.AB64FC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: __mem_cgroup_remove_exceeded could handle a !on-tree mz properly
has been added to the -mm tree.  Its filename is
     mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: __mem_cgroup_remove_exceeded could handle a !on-tree mz properly

There is no tree operation if mz is not on-tree.

Let's remove the extra check.

Link: https://lkml.kernel.org/r/20220312071623.19050-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly
+++ a/mm/memcontrol.c
@@ -503,9 +503,11 @@ static void mem_cgroup_update_tree(struc
 			unsigned long flags;
 
 			spin_lock_irqsave(&mctz->lock, flags);
-			/* if on-tree, remove it */
-			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(mz, mctz);
+			/*
+			 * remove it first
+			 * If not on-tree, no tree ops.
+			 */
+			__mem_cgroup_remove_exceeded(mz, mctz);
 			/*
 			 * Insert again. mz->usage_in_excess will be updated.
 			 * If excess is 0, no tree ops.
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-to-prev-unconditionally.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-memcg-mz-already-removed-from-rb_tree-in-mem_cgroup_largest_soft_limit_node.patch
mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch
mm-memcg-add-next_mz-back-to-soft-limit-tree-if-not-reclaimed-yet.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

