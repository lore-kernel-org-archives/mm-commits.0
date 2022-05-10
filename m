Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22368C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbiEJEPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiEJEOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2BD658D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D537B817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F69C385C7;
        Tue, 10 May 2022 04:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155841;
        bh=mhNrxSzkLAVGTTmORnDiPF7J8lzd+9eX36hfoNnZi/Q=;
        h=Date:To:From:Subject:From;
        b=hrwV3o6Stqcj0rEseDhWg0fq49eoIaY4pWV5fPvjfiXQdeKCRgchAzv4HY+hEPzai
         arWJYe8EEtdnPzx9vsHYHRkh0Oybsexdxe2lwVjUGjaTsY6dldVbscD5n5rJYpy+4g
         iIqgzWuJDYcA0rV3f509E95616fc76VT2jNs9CJ4=
Date:   Mon, 09 May 2022 21:10:40 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        hannes@cmpxchg.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-move-generation-assignment-and-comparison-together.patch removed from -mm tree
Message-Id: <20220510041040.E7F69C385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: move generation assignment and comparison together
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-generation-assignment-and-comparison-together.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: move generation assignment and comparison together

For each round-trip, we assign generation on first invocation and compare
it on subsequent invocations.

Let's move them together to make it more self-explaining. Also this
reduce a check on prev.

[hannes@cmpxchg.org: better comment to explain reclaim model]
Link: https://lkml.kernel.org/r/20220330234719.18340-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-generation-assignment-and-comparison-together
+++ a/mm/memcontrol.c
@@ -1021,7 +1021,13 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
 
-		if (prev && reclaim->generation != iter->generation)
+		/*
+		 * On start, join the current reclaim iteration cycle.
+		 * Exit when a concurrent walker completes it.
+		 */
+		if (!prev)
+			reclaim->generation = iter->generation;
+		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
 		while (1) {
@@ -1083,8 +1089,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 		if (!memcg)
 			iter->generation++;
-		else if (!prev)
-			reclaim->generation = iter->generation;
 	}
 
 out_unlock:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

