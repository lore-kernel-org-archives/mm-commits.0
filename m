Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D20C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3256664F8D
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhCKUiS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhCKUht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 15:37:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3593364F87;
        Thu, 11 Mar 2021 20:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615495068;
        bh=a491prOBe1j0kzmeng1HjUYnoZzdt+sEB8nl5H9S0LM=;
        h=Date:From:To:Subject:From;
        b=LDzv7hQBxUsSKIhYf9y4D7soT8IVZAzwlp/o52s8AtPp8jQMMQOdqERT7wgXlAqIO
         gK+DcxrsQNrtsPL3beZIOeLqBSl5HGfLqeXQ3R95t5/+lxV8rRycIU0secuFCFYHRX
         k8n2/aHthbXgd+IuTcgkhAgxlFnyZ6ahnst8uFAU=
Date:   Thu, 11 Mar 2021 12:37:47 -0800
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, guro@fb.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, vbabka@suse.cz
Subject:  +
 mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch added to -mm
 tree
Message-ID: <20210311203747.7IJ5gV4S8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: reparent nr_deferred when memcg offline
has been added to the -mm tree.  Its filename is
     mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch

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
Subject: mm: memcontrol: reparent nr_deferred when memcg offline

Now shrinker's nr_deferred is per memcg for memcg aware shrinkers, add to
parent's corresponding nr_deferred when memcg offline.

Link: https://lkml.kernel.org/r/20210311190845.9708-13-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |    1 +
 mm/vmscan.c                |   24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcontrol-reparent-nr_deferred-when-memcg-offline
+++ a/include/linux/memcontrol.h
@@ -1537,6 +1537,7 @@ static inline bool mem_cgroup_under_sock
 int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
+void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
--- a/mm/memcontrol.c~mm-memcontrol-reparent-nr_deferred-when-memcg-offline
+++ a/mm/memcontrol.c
@@ -5167,6 +5167,7 @@ static void mem_cgroup_css_offline(struc
 	page_counter_set_low(&memcg->memory, 0);
 
 	memcg_offline_kmem(memcg);
+	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 
 	drain_all_stock(memcg);
--- a/mm/vmscan.c~mm-memcontrol-reparent-nr_deferred-when-memcg-offline
+++ a/mm/vmscan.c
@@ -397,6 +397,30 @@ static long add_nr_deferred_memcg(long n
 	return atomic_long_add_return(nr, &info->nr_deferred[shrinker->id]);
 }
 
+void reparent_shrinker_deferred(struct mem_cgroup *memcg)
+{
+	int i, nid;
+	long nr;
+	struct mem_cgroup *parent;
+	struct shrinker_info *child_info, *parent_info;
+
+	parent = parent_mem_cgroup(memcg);
+	if (!parent)
+		parent = root_mem_cgroup;
+
+	/* Prevent from concurrent shrinker_info expand */
+	down_read(&shrinker_rwsem);
+	for_each_node(nid) {
+		child_info = shrinker_info_protected(memcg, nid);
+		parent_info = shrinker_info_protected(parent, nid);
+		for (i = 0; i < shrinker_nr_max; i++) {
+			nr = atomic_long_read(&child_info->nr_deferred[i]);
+			atomic_long_add(nr, &parent_info->nr_deferred[i]);
+		}
+	}
+	up_read(&shrinker_rwsem);
+}
+
 static bool cgroup_reclaim(struct scan_control *sc)
 {
 	return sc->target_mem_cgroup;
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

