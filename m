Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5683C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Mar 2022 21:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiCNVSf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Mar 2022 17:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240243AbiCNVSe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2022 17:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B013DDE5
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 14:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86F216130A
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 21:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8110C340E9;
        Mon, 14 Mar 2022 21:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647292642;
        bh=gZybsEVCQ+a8RgtD8f0jT+6tLWupBOkWllOgj/pa8bU=;
        h=Date:To:From:Subject:From;
        b=XxpEmzBTtYePkmzbChxRuE/g0rXaQKhlvg7fwklFFNvNQ6L8DcJGvHvvdkFy0+dzu
         tDFTbRW/AlhlgN2lnIJGIKnv1W2iDrwmocJzcWaQxQTIDkzRYhXufnnDaIMDA4i0oC
         U5Kws2dHnitymkuaoUvtr1+vz+3PFE2G3/KYd/DU=
Date:   Mon, 14 Mar 2022 14:17:22 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch removed from -mm tree
Message-Id: <20220314211722.D8110C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: __mem_cgroup_remove_exceeded could handle a !on-tree mz properly
has been removed from the -mm tree.  Its filename was
     mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch

This patch was dropped because an updated version will be merged

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
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

