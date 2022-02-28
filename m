Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BF6C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiB1Fi1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiB1Fi0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:38:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F224322B2B
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:37:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529CC60FA7
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8413C340F0;
        Mon, 28 Feb 2022 05:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646026666;
        bh=LPRnpmSomBib2Ubh4LBtkJcfQ/LtNBp1G22HDjlRlEk=;
        h=Date:To:From:Subject:From;
        b=AdKM3bGyxBxJcuXW8SgawZbR2Ht3HJXTBYNrgOm792l5KPteSw0h1TuTes0INihl5
         8t9bfMlzRhP1r+ulJbZoktaiz22t5dbeIs9D3l6h9dU3xK/xdNzSYhxP2UXFmptkGK
         gc4vZFbYy+y2Nq+X0M213M74c5I0e17tVkbLkMQs=
Date:   Sun, 27 Feb 2022 21:37:46 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-set-pos-to-prev-unconditionally.patch added to -mm tree
Message-Id: <20220228053746.A8413C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: set pos to prev unconditionally
has been added to the -mm tree.  Its filename is
     mm-memcg-set-pos-to-prev-unconditionally.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-set-pos-to-prev-unconditionally.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-set-pos-to-prev-unconditionally.patch

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
@@ -980,7 +980,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct mem_cgroup *pos = NULL;
+	struct mem_cgroup *pos = prev;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -988,9 +988,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
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
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-to-prev-unconditionally.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

