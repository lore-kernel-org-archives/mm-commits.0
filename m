Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B3CC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Mar 2022 21:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiCUVGe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Mar 2022 17:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiCUVGd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2022 17:06:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA49D1C8AAE
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 14:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B35460DCC
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 21:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2D8C340ED;
        Mon, 21 Mar 2022 21:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647896705;
        bh=UyzDwtXc/eIvp5+CPDC29siIAvAeoJVU20RG9rLxhow=;
        h=Date:To:From:Subject:From;
        b=tHeBk+UvQViIyrzUVesBJwB8AdEhanRITpTU500mm9bzdRWJ4UD7IU1fjIdHgUdC/
         +717ZYf4pHMGFVfa3wu8crG8XNG+lwgHq8YLiWuDNmbvhlU6X+1h2W8YfWyOCRxUsT
         ezGkap2hCa5MNdKn/zFu50y/Gl2zcY4zCurA5mKU=
Date:   Mon, 21 Mar 2022 14:05:04 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-memcg-set-pos-to-prev-unconditionally.patch removed from -mm tree
Message-Id: <20220321210505.8F2D8C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: set pos to prev unconditionally
has been removed from the -mm tree.  Its filename was
     mm-memcg-set-pos-to-prev-unconditionally.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: set pos to prev unconditionally

Current code sets pos to prev based on condition (prev && !reclaim), while
we can do this unconditionally.

Since:

  * If !reclaim, pos is the same as prev no matter it is NULL or not.
  * If reclaim, pos would be set properly from iter->position.

Link: https://lkml.kernel.org/r/20220225003437.12620-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-set-pos-to-prev-unconditionally
+++ a/mm/memcontrol.c
@@ -990,7 +990,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct mem_cgroup *pos = NULL;
+	struct mem_cgroup *pos = prev;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -998,9 +998,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (!root)
 		root = root_mem_cgroup;
 
-	if (prev && !reclaim)
-		pos = prev;
-
 	rcu_read_lock();
 
 	if (reclaim) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

