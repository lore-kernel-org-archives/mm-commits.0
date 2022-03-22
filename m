Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7761C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiCVVlq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbiCVVlp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D6F5EBC5
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6C860A1B
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B14C340EE;
        Tue, 22 Mar 2022 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985214;
        bh=HxZoLzTj6RCg+j3ovTGgyoE0bXf5C530MJKDVUt8Zm4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=xqVDj6fhSnn0Xf78q0BhffN8zlovUFJSZBbIjFb7NBmC01d0DNciDXPGEK2aOsSKc
         0X/EI/gV63RNlxPo9Z8IokP3nMJS5FJG8yMkPETTbz+QC8Zgbg2lz/PWl9QmmkV5P/
         SMv3Yd4VJ2HgYnVzt4/G8KOuTolMyhOacdgowlLI=
Date:   Tue, 22 Mar 2022 14:40:13 -0700
To:     vdavydov.dev@gmail.com, vbabka@suse.cz, surenb@google.com,
        songmuchun@bytedance.com, shy828301@gmail.com, shakeelb@google.com,
        rppt@linux.ibm.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, guro@fb.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 034/227] mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
Message-Id: <20220322214014.76B14C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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
@@ -5105,8 +5105,6 @@ static int alloc_mem_cgroup_per_node_inf
 	}
 
 	lruvec_init(&pn->lruvec);
-	pn->usage_in_excess = 0;
-	pn->on_tree = false;
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
_
