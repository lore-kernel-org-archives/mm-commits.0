Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1807CC4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 19:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379411AbjLFTvk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 14:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379438AbjLFTvi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 14:51:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98078D4E
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 11:51:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0887AC433C8;
        Wed,  6 Dec 2023 19:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701892304;
        bh=pyX+VNK1bUN+IwLQnu06u2aot/3S2ylkfdd5FJgPilk=;
        h=Date:To:From:Subject:From;
        b=OjMchy6zxseTvhIU+YddHtNEQ4g18OnV2wSLCdxX5JyI3JlTLeo2CmdM3yKhongcH
         CrMmP+GHMeSVbwDvTZv07dNbkx+BU8czae4MaelNgUrwaGE3vZzAhuS+9riD+3ANxu
         HCzNw5Vk/n06adOszp2Cud5/ty1PjsjONcLbZ40Q=
Date:   Wed, 06 Dec 2023 11:51:43 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, chengming.zhou@linux.dev,
        cerasuolodomenico@gmail.com, bagasdotme@gmail.com,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch added to mm-unstable branch
Message-Id: <20231206195144.0887AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: shrinks zswap pool based on memory pressure (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: shrinks zswap pool based on memory pressure (fix)
Date: Wed, 6 Dec 2023 11:44:56 -0800

Check shrinker enablement early, and use a less costly stat flushing.

Link: https://lkml.kernel.org/r/20231206194456.3234203-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~zswap-shrinks-zswap-pool-based-on-memory-pressure-fix
+++ a/mm/zswap.c
@@ -596,13 +596,17 @@ static unsigned long zswap_shrinker_scan
 	struct zswap_pool *pool = shrinker->private_data;
 	bool encountered_page_in_swapcache = false;
 
+	if (!zswap_shrinker_enabled) {
+		sc->nr_scanned = 0;
+		return SHRINK_STOP;
+	}
+
 	nr_protected =
 		atomic_long_read(&lruvec->zswap_lruvec_state.nr_zswap_protected);
 	lru_size = list_lru_shrink_count(&pool->list_lru, sc);
 
 	/*
-	 * Abort if the shrinker is disabled or if we are shrinking into the
-	 * protected region.
+	 * Abort if we are shrinking into the protected region.
 	 *
 	 * This short-circuiting is necessary because if we have too many multiple
 	 * concurrent reclaimers getting the freeable zswap object counts at the
@@ -611,7 +615,7 @@ static unsigned long zswap_shrinker_scan
 	 * objects (i.e the reclaimers will reclaim into the protected area of the
 	 * zswap LRU).
 	 */
-	if (!zswap_shrinker_enabled || nr_protected >= lru_size - sc->nr_to_scan) {
+	if (nr_protected >= lru_size - sc->nr_to_scan) {
 		sc->nr_scanned = 0;
 		return SHRINK_STOP;
 	}
@@ -633,8 +637,11 @@ static unsigned long zswap_shrinker_coun
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(sc->nid));
 	unsigned long nr_backing, nr_stored, nr_freeable, nr_protected;
 
+	if (!zswap_shrinker_enabled)
+		return 0;
+
 #ifdef CONFIG_MEMCG_KMEM
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 #else
@@ -643,7 +650,7 @@ static unsigned long zswap_shrinker_coun
 	nr_stored = atomic_read(&pool->nr_stored);
 #endif
 
-	if (!zswap_shrinker_enabled || !nr_stored)
+	if (!nr_stored)
 		return 0;
 
 	nr_protected =
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
zswap-make-shrinking-memcg-aware-fix.patch
zswap-make-shrinking-memcg-aware-fix-2.patch
mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch

