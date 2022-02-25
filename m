Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33411C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 02:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiBYCcM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiBYCcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Feb 2022 21:32:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7942193F8
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 18:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 744C7B82A89
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 02:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EDFC340EB;
        Fri, 25 Feb 2022 02:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645756293;
        bh=Pc0O4UzYUz78h5AijONyKoKpwNfdhQVN7wMEqle1dMA=;
        h=Date:To:From:Subject:From;
        b=tyF7Fe1jmps3sbVPfzYOqqnjYTbkaDsouvdyQ/wUQAN0KxqUge5t1v8KYfyUEz/yn
         /rqH4X6Mr3rqGqlm2QNFPb6a67R1ppJ0zCXBBApQVcn9+3FdsIkXfWCRFrl8QqSxNC
         6LNXIFS46/vkprUUIM49h9Hi6G4vetztxIL9/S+U=
Date:   Thu, 24 Feb 2022 18:31:32 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-set-pos-to-prev-unconditionally.patch added to -mm tree
Message-Id: <20220225023133.15EDFC340EB@smtp.kernel.org>
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
@@ -1029,7 +1029,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct mem_cgroup *pos = NULL;
+	struct mem_cgroup *pos = prev;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1037,9 +1037,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
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

