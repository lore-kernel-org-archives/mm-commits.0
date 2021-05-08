Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7571C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 868B461421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWtn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWtm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C0426101D;
        Sat,  8 May 2021 22:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514120;
        bh=PjcgXyUNWsSu09UgtfQFWrquIs5Y/x8UQGob7vHTfxc=;
        h=Date:From:To:Subject:From;
        b=XMYFK4ob9VAIrl6mTiVvwWH9cgY+rk/DYbk1H1W6Qj5WTFzFhZONiYvjYG6JyP3o6
         JZa5QoVnu+Fy3CYS0Vvmc7kpzl8E4ehGujReFPKKxVq9MVh4YGtpeVVFV5J1PdxsJu
         ylkdYJ7KyH9Bv4Iads8S+MVC66KjZGUGbXg+UQAg=
Date:   Sat, 08 May 2021 15:48:40 -0700
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, guro@fb.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, vbabka@suse.cz
Subject:  [merged]
 mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered.patch removed
 from -mm tree
Message-ID: <20210508224840.ZOkGVvSrb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: use a new flag to indicate shrinker is registered
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: use a new flag to indicate shrinker is registered

Currently registered shrinker is indicated by non-NULL
shrinker->nr_deferred.  This approach is fine with nr_deferred at the
shrinker level, but the following patches will move MEMCG_AWARE shrinkers'
nr_deferred to memcg level, so their shrinker->nr_deferred would always be
NULL.  This would prevent the shrinkers from unregistering correctly.

Remove SHRINKER_REGISTERING since we could check if shrinker is registered
successfully by the new flag.

Link: https://lkml.kernel.org/r/20210311190845.9708-9-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    7 +++---
 mm/vmscan.c              |   40 +++++++++++++------------------------
 2 files changed, 19 insertions(+), 28 deletions(-)

--- a/include/linux/shrinker.h~mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered
+++ a/include/linux/shrinker.h
@@ -79,13 +79,14 @@ struct shrinker {
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 
 /* Flags */
-#define SHRINKER_NUMA_AWARE	(1 << 0)
-#define SHRINKER_MEMCG_AWARE	(1 << 1)
+#define SHRINKER_REGISTERED	(1 << 0)
+#define SHRINKER_NUMA_AWARE	(1 << 1)
+#define SHRINKER_MEMCG_AWARE	(1 << 2)
 /*
  * It just makes sense when the shrinker is also MEMCG_AWARE for now,
  * non-MEMCG_AWARE shrinker should not have this flag set.
  */
-#define SHRINKER_NONSLAB	(1 << 2)
+#define SHRINKER_NONSLAB	(1 << 3)
 
 extern int prealloc_shrinker(struct shrinker *shrinker);
 extern void register_shrinker_prepared(struct shrinker *shrinker);
--- a/mm/vmscan.c~mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered
+++ a/mm/vmscan.c
@@ -316,19 +316,6 @@ void set_shrinker_bit(struct mem_cgroup
 	}
 }
 
-/*
- * We allow subsystems to populate their shrinker-related
- * LRU lists before register_shrinker_prepared() is called
- * for the shrinker, since we don't want to impose
- * restrictions on their internal registration order.
- * In this case shrink_slab_memcg() may find corresponding
- * bit is set in the shrinkers map.
- *
- * This value is used by the function to detect registering
- * shrinkers and to skip do_shrink_slab() calls for them.
- */
-#define SHRINKER_REGISTERING ((struct shrinker *)~0UL)
-
 static DEFINE_IDR(shrinker_idr);
 
 static int prealloc_memcg_shrinker(struct shrinker *shrinker)
@@ -337,7 +324,7 @@ static int prealloc_memcg_shrinker(struc
 
 	down_write(&shrinker_rwsem);
 	/* This may call shrinker, so it must use down_read_trylock() */
-	id = idr_alloc(&shrinker_idr, SHRINKER_REGISTERING, 0, 0, GFP_KERNEL);
+	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
 
@@ -360,9 +347,9 @@ static void unregister_memcg_shrinker(st
 
 	BUG_ON(id < 0);
 
-	down_write(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_rwsem);
+
 	idr_remove(&shrinker_idr, id);
-	up_write(&shrinker_rwsem);
 }
 
 static bool cgroup_reclaim(struct scan_control *sc)
@@ -490,8 +477,11 @@ void free_prealloced_shrinker(struct shr
 	if (!shrinker->nr_deferred)
 		return;
 
-	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
+	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
+		down_write(&shrinker_rwsem);
 		unregister_memcg_shrinker(shrinker);
+		up_write(&shrinker_rwsem);
+	}
 
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
@@ -501,10 +491,7 @@ void register_shrinker_prepared(struct s
 {
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
-#ifdef CONFIG_MEMCG
-	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
-		idr_replace(&shrinker_idr, shrinker, shrinker->id);
-#endif
+	shrinker->flags |= SHRINKER_REGISTERED;
 	up_write(&shrinker_rwsem);
 }
 
@@ -524,13 +511,16 @@ EXPORT_SYMBOL(register_shrinker);
  */
 void unregister_shrinker(struct shrinker *shrinker)
 {
-	if (!shrinker->nr_deferred)
+	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
-	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
-		unregister_memcg_shrinker(shrinker);
+
 	down_write(&shrinker_rwsem);
 	list_del(&shrinker->list);
+	shrinker->flags &= ~SHRINKER_REGISTERED;
+	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
+		unregister_memcg_shrinker(shrinker);
 	up_write(&shrinker_rwsem);
+
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
 }
@@ -695,7 +685,7 @@ static unsigned long shrink_slab_memcg(g
 		struct shrinker *shrinker;
 
 		shrinker = idr_find(&shrinker_idr, i);
-		if (unlikely(!shrinker || shrinker == SHRINKER_REGISTERING)) {
+		if (unlikely(!shrinker || !(shrinker->flags & SHRINKER_REGISTERED))) {
 			if (!shrinker)
 				clear_bit(i, info->map);
 			continue;
_

Patches currently in -mm which might be from shy828301@gmail.com are


