Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC38DC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiB1Fic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiB1Fib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:38:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DF4220F0
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:37:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEB98B80E1D
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84868C340E7;
        Mon, 28 Feb 2022 05:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646026668;
        bh=sSDpZWm/ob5mDzsUSHhsthE+E0eSNDNeEc/rPakL4zQ=;
        h=Date:To:From:Subject:From;
        b=p8wnpcLuFIuRqCAh30IYT70RB3o1qxvacFMMfDPiie92HI+buZX8NBaM0IwqZzvGZ
         TfeK35aeqC2q3WbwULe0mZbtNAeX8Jq/41eifFdYWj4mUW3j7y6rhEK3dj5+fNVp4m
         v61DMZigMgJ8qlwMkhmVmotv3ZFfb5JYJlWLKmmE=
Date:   Sun, 27 Feb 2022 21:37:47 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-move-generation-assignment-and-comparison-together.patch added to -mm tree
Message-Id: <20220228053748.84868C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: move generation assignment and comparison together
has been added to the -mm tree.  Its filename is
     mm-memcg-move-generation-assignment-and-comparison-together.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-move-generation-assignment-and-comparison-together.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-move-generation-assignment-and-comparison-together.patch

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
Subject: mm/memcg: move generation assignment and comparison together

For each round-trip, we assign generation on first invocation and compare
it on subsequent invocations.

Let's move them together to make it more self-explaining.  Also this
reduces a check on prev.

Link: https://lkml.kernel.org/r/20220225003437.12620-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-generation-assignment-and-comparison-together
+++ a/mm/memcontrol.c
@@ -996,7 +996,14 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
 
-		if (prev && reclaim->generation != iter->generation)
+		/*
+		 * On first invocation, assign iter->generation to
+		 * reclaim->generation.
+		 * On subsequent invocations, make sure no one else jump in.
+		 */
+		if (!prev)
+			reclaim->generation = iter->generation;
+		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
 		while (1) {
@@ -1056,8 +1063,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 		if (!memcg)
 			iter->generation++;
-		else if (!prev)
-			reclaim->generation = iter->generation;
 	}
 
 out_unlock:
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

