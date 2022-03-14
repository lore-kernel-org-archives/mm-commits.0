Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C2DC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Mar 2022 21:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbiCNVSe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Mar 2022 17:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiCNVSe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2022 17:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D0B3DDD6
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 14:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 800536130C
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 21:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB8DC340E9;
        Mon, 14 Mar 2022 21:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647292641;
        bh=DR6WAca1LPCCuqKjqO77LAYmpUzgHd3/FhaKQ9g2+AI=;
        h=Date:To:From:Subject:From;
        b=v8bNHtNLV2b4ta8/fiKKitYVJ4578i+P/KCcvSeJifDRk7lezTOP9lsYMpVPVOiit
         1LOuam+nnpqP94CBn59WqKXLq9OGKQgn8910norSSKn32od3jloM26AqVVWM/9AgR+
         pXUZZ/uMbBAEy5aX771obgXU++sxxFfzi2U0hyPY=
Date:   Mon, 14 Mar 2022 14:17:21 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-mz-already-removed-from-rb_tree-in-mem_cgroup_largest_soft_limit_node.patch removed from -mm tree
Message-Id: <20220314211721.CAB8DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: mz already removed from rb_tree in mem_cgroup_largest_soft_limit_node()
has been removed from the -mm tree.  Its filename was
     mm-memcg-mz-already-removed-from-rb_tree-in-mem_cgroup_largest_soft_limit_node.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: mz already removed from rb_tree in mem_cgroup_largest_soft_limit_node()

When mz is not NULL, mem_cgroup_largest_soft_limit_node() has removed it
from rb_tree.

Not necessary to call __mem_cgroup_remove_exceeded() again.

Link: https://lkml.kernel.org/r/20220312071623.19050-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-mz-already-removed-from-rb_tree-in-mem_cgroup_largest_soft_limit_node
+++ a/mm/memcontrol.c
@@ -3418,7 +3418,6 @@ unsigned long mem_cgroup_soft_limit_recl
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
-		__mem_cgroup_remove_exceeded(mz, mctz);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-to-prev-unconditionally.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

