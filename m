Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEA9C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E27F4619CD
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhCaEZX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaEYw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:24:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4D0C619CD;
        Wed, 31 Mar 2021 04:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617164691;
        bh=7t7CVjDlenzoLONiRTXQxCoiU1R6a0hIvvZMNeZjQJM=;
        h=Date:From:To:Subject:From;
        b=BJVKgEMZEFyq2pkB1JT5MPFgFNF0Ss8raPTHuSd1PPVkn9mJ19PjB0/GOOy4GxNKf
         KDiReCUYQCvLiQiWUpCi593KY8+jgqXHNDoeF9KAI+l0/QKnA9E7H1WYVO0iZCGSob
         ut2LD5q8F0Hvwv7JN81QXePo+2vgOsI1XKvULSa8=
Date:   Tue, 30 Mar 2021 21:24:50 -0700
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, ktkhai@virtuozzo.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        shakeelb@google.com, shy828301@gmail.com, vbabka@suse.cz
Subject:  + mm-vmscan-add-per-memcg-shrinker-nr_deferred-fix.patch
 added to -mm tree
Message-ID: <20210331042450.rE7TKprY3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix shrinker_rwsem in free_shrinker_info()
has been added to the -mm tree.  Its filename is
     mm-vmscan-add-per-memcg-shrinker-nr_deferred-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-add-per-memcg-shrinker-nr_deferred-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-add-per-memcg-shrinker-nr_deferred-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: vmscan: fix shrinker_rwsem in free_shrinker_info()

Lockdep warns mm/vmscan.c: suspicious rcu_dereference_protected() usage!
when free_shrinker_info() is called from mem_cgroup_css_free(): there it
is called with no locking, whereas alloc_shrinker_info() calls it with
down_write of shrinker_rwsem - which seems appropriate.  Rearrange that
so free_shrinker_info() can manage the shrinker_rwsem for itself.

Link: https://lkml.kernel.org/r/20210317140615.GB28839@xsang-OptiPlex-9020
Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2103301640240.2584@eggly.anvils
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-add-per-memcg-shrinker-nr_deferred-fix
+++ a/mm/vmscan.c
@@ -249,18 +249,20 @@ void free_shrinker_info(struct mem_cgrou
 	struct shrinker_info *info;
 	int nid;
 
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
 		info = shrinker_info_protected(memcg, nid);
 		kvfree(info);
 		rcu_assign_pointer(pn->shrinker_info, NULL);
 	}
+	up_write(&shrinker_rwsem);
 }
 
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	struct shrinker_info *info;
-	int nid, size, ret = 0;
+	int nid, size;
 	int map_size, defer_size = 0;
 
 	down_write(&shrinker_rwsem);
@@ -270,9 +272,9 @@ int alloc_shrinker_info(struct mem_cgrou
 	for_each_node(nid) {
 		info = kvzalloc_node(sizeof(*info) + size, GFP_KERNEL, nid);
 		if (!info) {
+			up_write(&shrinker_rwsem);
 			free_shrinker_info(memcg);
-			ret = -ENOMEM;
-			break;
+			return -ENOMEM;
 		}
 		info->nr_deferred = (atomic_long_t *)(info + 1);
 		info->map = (void *)info->nr_deferred + defer_size;
@@ -280,7 +282,7 @@ int alloc_shrinker_info(struct mem_cgrou
 	}
 	up_write(&shrinker_rwsem);
 
-	return ret;
+	return 0;
 }
 
 static inline bool need_expand(int nr_max)
_

Patches currently in -mm which might be from hughd@google.com are

mm-vmscan-add-per-memcg-shrinker-nr_deferred-fix.patch
mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

