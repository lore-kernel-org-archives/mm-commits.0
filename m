Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F70EC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjFIXcI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjFIXbW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2385C44B9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03D6560FCA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584F5C433D2;
        Fri,  9 Jun 2023 23:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353347;
        bh=OFavPQ97yLJMCLAvk5+2DJNGucre7Sl0ppta8SmEbOk=;
        h=Date:To:From:Subject:From;
        b=r1I2tBjWBbENchB/fZZ7WcZSakeT3AWe39N8piASnYKSzDmajkFof218hNg+DBWYl
         XjAWqzfOxW5/cNbn6XY6shdfgvICLQDygNsAHCa7gn3dJdetu6jwPQ3LZXRgkq3FDa
         jQ4CnXREx7Bl/qWyoJinkZQwd0/vRiaPqdjdzn74=
Date:   Fri, 09 Jun 2023 16:29:06 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
        david@redhat.com, talumbau@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch removed from -mm tree
Message-Id: <20230609232907.584F5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: cleanup lru_gen_soft_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: cleanup lru_gen_soft_reclaim()
Date: Mon, 22 May 2023 11:20:56 +0000

lru_gen_soft_reclaim() gets the lruvec from the memcg and node ID to keep a
cleaner interface on the caller side.

Link: https://lkml.kernel.org/r/20230522112058.2965866-2-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Reviewed-by: Yuanchu Xie <yuanchu@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 mm/memcontrol.c        |    2 +-
 mm/vmscan.c            |    4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h~mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim
+++ a/include/linux/mmzone.h
@@ -534,7 +534,7 @@ void lru_gen_exit_memcg(struct mem_cgrou
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
-void lru_gen_soft_reclaim(struct lruvec *lruvec);
+void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
 
 #else /* !CONFIG_MEMCG */
 
@@ -585,7 +585,7 @@ static inline void lru_gen_release_memcg
 {
 }
 
-static inline void lru_gen_soft_reclaim(struct lruvec *lruvec)
+static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 {
 }
 
--- a/mm/memcontrol.c~mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim
+++ a/mm/memcontrol.c
@@ -485,7 +485,7 @@ static void mem_cgroup_update_tree(struc
 
 	if (lru_gen_enabled()) {
 		if (soft_limit_excess(memcg))
-			lru_gen_soft_reclaim(&memcg->nodeinfo[nid]->lruvec);
+			lru_gen_soft_reclaim(memcg, nid);
 		return;
 	}
 
--- a/mm/vmscan.c~mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim
+++ a/mm/vmscan.c
@@ -4846,8 +4846,10 @@ void lru_gen_release_memcg(struct mem_cg
 	}
 }
 
-void lru_gen_soft_reclaim(struct lruvec *lruvec)
+void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 {
+	struct lruvec *lruvec = get_lruvec(memcg, nid);
+
 	/* see the comment on MEMCG_NR_GENS */
 	if (lru_gen_memcg_seg(lruvec) != MEMCG_LRU_HEAD)
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
_

Patches currently in -mm which might be from talumbau@google.com are


