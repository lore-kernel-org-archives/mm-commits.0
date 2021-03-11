Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8634C43331
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B33D64FA8
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCKUhq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhCKUhc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 15:37:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C0A564F85;
        Thu, 11 Mar 2021 20:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615495052;
        bh=qz8+II7rkmiWktsFcfov+fdtU04s4Z/5GVaK/mkt/GI=;
        h=Date:From:To:Subject:From;
        b=S+FC+5DSyVYGDwL1DfGUauTPs5l7/3RZR5FfoC2zMbKTMvMXrRkta0uI/p1tIaVWm
         AW+r+hg/6EObNB+2LDf6ZSo3mD+yNXAZozkyP744SOpri025xEVMDNhK+O+ZKC4aoo
         OM43+lCSBzWV7xO3k5h2ThfM3dWhlzj+K06Ef6yE=
Date:   Thu, 11 Mar 2021 12:37:30 -0800
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, guro@fb.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, vbabka@suse.cz
Subject:  + mm-vmscan-add-shrinker_info_protected-helper.patch
 added to -mm tree
Message-ID: <20210311203730.d_elW3han%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: add shrinker_info_protected() helper
has been added to the -mm tree.  Its filename is
     mm-vmscan-add-shrinker_info_protected-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-add-shrinker_info_protected-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-add-shrinker_info_protected-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: add shrinker_info_protected() helper

The shrinker_info is dereferenced in a couple of places via
rcu_dereference_protected with different calling conventions, for example,
using mem_cgroup_nodeinfo helper or dereferencing
memcg->nodeinfo[nid]->shrinker_info.  And the later patch will add more
dereference places.

So extract the dereference into a helper to make the code more readable. 
No functional change.

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

 mm/vmscan.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

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
@@ -232,7 +239,7 @@ void free_shrinker_info(struct mem_cgrou
 
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
-		info = rcu_dereference_protected(pn->shrinker_info, true);
+		info = shrinker_info_protected(memcg, nid);
 		kvfree(info);
 		rcu_assign_pointer(pn->shrinker_info, NULL);
 	}
@@ -675,8 +682,7 @@ static unsigned long shrink_slab_memcg(g
 	if (!down_read_trylock(&shrinker_rwsem))
 		return 0;
 
-	info = rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 true);
+	info = shrinker_info_protected(memcg, nid);
 	if (unlikely(!info))
 		goto unlock;
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch
mm-vmscan-consolidate-shrinker_maps-handling-code.patch
mm-vmscan-use-shrinker_rwsem-to-protect-shrinker_maps-allocation.patch
mm-vmscan-remove-memcg_shrinker_map_size.patch
mm-vmscan-use-kvfree_rcu-instead-of-call_rcu.patch
mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch
mm-vmscan-add-shrinker_info_protected-helper.patch
mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered.patch
mm-vmscan-add-per-memcg-shrinker-nr_deferred.patch
mm-vmscan-use-per-memcg-nr_deferred-of-shrinker.patch
mm-vmscan-dont-need-allocate-shrinker-nr_deferred-for-memcg-aware-shrinkers.patch
mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch
mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch

