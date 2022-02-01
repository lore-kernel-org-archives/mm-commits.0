Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8900FC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 21:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiBAVdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:33:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40436 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiBAVdY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 16:33:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90F6FB82F8C
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 21:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5C2C340EB;
        Tue,  1 Feb 2022 21:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643751202;
        bh=Vvp9odLsYTobh1ncLjmUXzBTf2jcmHt7eQEb9ZAVmiQ=;
        h=Date:To:From:Subject:From;
        b=rPzFBXuYtVNtmFU9mKyiaJYdbNprsC/livzBOCPqAbzwuWXz2r2aJecdqCQKp9gSt
         EwyWS63SFCTWoeTOwjnnmppAZeb0U4Vkwj0T3wa48XagUWqxyPfQjJznls+YHBn+C1
         NvFERbfP6DX5BIsBMLLHIIHA66Njb5E+Je814+q4=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 13:33:20 -0800
Date:   Tue, 01 Feb 2022 13:33:20 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        surenb@google.com, songmuchun@bytedance.com, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, mhocko@suse.com,
        hannes@cmpxchg.org, guro@fb.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch added to -mm tree
Message-Id: <20220201213320.DE5C2C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
has been added to the -mm tree.  Its filename is
     mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch

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
Subject: mm/memcg: mem_cgroup_per_node is already set to 0 on allocation

kzalloc_node() would set data to 0, so it's not necessary to set it
again.

Link: https://lkml.kernel.org/r/20220201004643.8391-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation
+++ a/mm/memcontrol.c
@@ -5102,8 +5102,6 @@ static int alloc_mem_cgroup_per_node_inf
 	}
 
 	lruvec_init(&pn->lruvec);
-	pn->usage_in_excess = 0;
-	pn->on_tree = false;
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

