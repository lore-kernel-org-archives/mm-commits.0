Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90277C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7467C6141D
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhEEBhX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBhX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E7961413;
        Wed,  5 May 2021 01:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178587;
        bh=RH8GCwoa5L8qST8JR6UatsdfdsLj4n/wEEvkS/mnb7w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1CdYn8WVwyhmRUrn1Et+zAaWMgp4VGw/sF0U3jr3xaOVAeURYQJds7iXytHOH1kAf
         8NFTkIASCQiC+2hTt5IuYLO4vhGWVAIvXlDoKXtKMlDnB3nKBUaD1fBlKSnugIT9qN
         PbrIhecv1JVkPbqV8zuhxKE5s0W9gZLPy3hoC7+w=
Date:   Tue, 04 May 2021 18:36:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 068/143] mm: vmscan: add shrinker_info_protected()
 helper
Message-ID: <20210505013626.d8b6W0KtG%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: add shrinker_info_protected() helper

The shrinker_info is dereferenced in a couple of places via
rcu_dereference_protected with different calling conventions, for example,
using mem_cgroup_nodeinfo helper or dereferencing
memcg->nodeinfo[nid]->shrinker_info.  And the later patch will add more
dereference places.

So extract the dereference into a helper to make the code more readable. 
No functional change.

[akpm@linux-foundation.org: retain rcu_dereference_protected() in free_shrinker_info(), per Hugh]
Link: https://lkml.kernel.org/r/20210311190845.9708-8-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-add-shrinker_info_protected-helper
+++ a/mm/vmscan.c
@@ -192,6 +192,13 @@ static inline int shrinker_map_size(int
 	return (DIV_ROUND_UP(nr_items, BITS_PER_LONG) * sizeof(unsigned long));
 }
 
+static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
+						     int nid)
+{
+	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
+					 lockdep_is_held(&shrinker_rwsem));
+}
+
 static int expand_one_shrinker_info(struct mem_cgroup *memcg,
 				    int size, int old_size)
 {
@@ -201,7 +208,7 @@ static int expand_one_shrinker_info(stru
 
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
-		old = rcu_dereference_protected(pn->shrinker_info, true);
+		old = shrinker_info_protected(memcg, nid);
 		/* Not yet online memcg */
 		if (!old)
 			return 0;
@@ -675,8 +682,7 @@ static unsigned long shrink_slab_memcg(g
 	if (!down_read_trylock(&shrinker_rwsem))
 		return 0;
 
-	info = rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 true);
+	info = shrinker_info_protected(memcg, nid);
 	if (unlikely(!info))
 		goto unlock;
 
_
