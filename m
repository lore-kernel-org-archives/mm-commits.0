Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21334C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074FA61421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhEEBhh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBhg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA9B661029;
        Wed,  5 May 2021 01:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178600;
        bh=eGFXdW984VlbspGGB3ahtI20bCqkiC3nJOYik2NDNXc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C+SHQqjT929zZpcy0pS9ru69foCNJeYdcKzsXbAAbm0ijLfyJ7aRUrwsyoXUEQmI3
         9XocBCnIMlT9PAhNeOENr7EqnqqHF9w1bAInDPR9M7xK7EfJhr2lnJU2N7tchFDeqx
         flCb5+PDp3ro9a1IP7TdbUTr0z/T6P8uY0QQzjJA=
Date:   Tue, 04 May 2021 18:36:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 072/143] mm: vmscan: don't need allocate
 shrinker->nr_deferred for memcg aware shrinkers
Message-ID: <20210505013639.aAAblJEiX%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: don't need allocate shrinker->nr_deferred for memcg aware shrinkers

Now nr_deferred is available on per memcg level for memcg aware shrinkers,
so don't need allocate shrinker->nr_deferred for such shrinkers anymore.

The prealloc_memcg_shrinker() would return -ENOSYS if !CONFIG_MEMCG or
memcg is disabled by kernel command line, then shrinker's
SHRINKER_MEMCG_AWARE flag would be cleared.  This makes the implementation
of this patch simpler.

Link: https://lkml.kernel.org/r/20210311190845.9708-12-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-dont-need-allocate-shrinker-nr_deferred-for-memcg-aware-shrinkers
+++ a/mm/vmscan.c
@@ -346,6 +346,9 @@ static int prealloc_memcg_shrinker(struc
 {
 	int id, ret = -ENOMEM;
 
+	if (mem_cgroup_disabled())
+		return -ENOSYS;
+
 	down_write(&shrinker_rwsem);
 	/* This may call shrinker, so it must use down_read_trylock() */
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
@@ -425,7 +428,7 @@ static bool writeback_throttling_sane(st
 #else
 static int prealloc_memcg_shrinker(struct shrinker *shrinker)
 {
-	return 0;
+	return -ENOSYS;
 }
 
 static void unregister_memcg_shrinker(struct shrinker *shrinker)
@@ -537,8 +540,18 @@ static unsigned long lruvec_lru_size(str
  */
 int prealloc_shrinker(struct shrinker *shrinker)
 {
-	unsigned int size = sizeof(*shrinker->nr_deferred);
+	unsigned int size;
+	int err;
+
+	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
+		err = prealloc_memcg_shrinker(shrinker);
+		if (err != -ENOSYS)
+			return err;
 
+		shrinker->flags &= ~SHRINKER_MEMCG_AWARE;
+	}
+
+	size = sizeof(*shrinker->nr_deferred);
 	if (shrinker->flags & SHRINKER_NUMA_AWARE)
 		size *= nr_node_ids;
 
@@ -546,28 +559,16 @@ int prealloc_shrinker(struct shrinker *s
 	if (!shrinker->nr_deferred)
 		return -ENOMEM;
 
-	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
-		if (prealloc_memcg_shrinker(shrinker))
-			goto free_deferred;
-	}
-
 	return 0;
-
-free_deferred:
-	kfree(shrinker->nr_deferred);
-	shrinker->nr_deferred = NULL;
-	return -ENOMEM;
 }
 
 void free_prealloced_shrinker(struct shrinker *shrinker)
 {
-	if (!shrinker->nr_deferred)
-		return;
-
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
 		down_write(&shrinker_rwsem);
 		unregister_memcg_shrinker(shrinker);
 		up_write(&shrinker_rwsem);
+		return;
 	}
 
 	kfree(shrinker->nr_deferred);
_
