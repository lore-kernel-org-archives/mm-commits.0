Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B3DC77B73
	for <mm-commits@archiver.kernel.org>; Mon, 22 May 2023 20:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjEVUsL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 16:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjEVUsK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 16:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D087CC1
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 13:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C80162214
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 20:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE46C4339B;
        Mon, 22 May 2023 20:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684788488;
        bh=wQ84F+F6JAWzKIfsGpqef6Wh+xhsNlZlP/KRrv3I3lk=;
        h=Date:To:From:Subject:From;
        b=xVUW9O3OREdK5NRPp2G8QQmJIR65ivNW5+MICOJBvpUaDXxj/YujKWAoXFgZJ7hm1
         d/zUk+SnjLen4yiQ9H9He9NQhA4YBtHF6Bie1GlbyMKH/G1P/cFTy0I6HoktHeb3s2
         tr9yif+ItodcbCSAifIgU5C4HoLtcoHXi6A5nwRs=
Date:   Mon, 22 May 2023 13:48:08 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
        david@redhat.com, talumbau@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch added to mm-unstable branch
Message-Id: <20230522204808.BCE46C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: cleanup lru_gen_soft_reclaim()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch

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
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: cleanup lru_gen_soft_reclaim()
Date: Mon, 22 May 2023 11:20:56 +0000

lru_gen_soft_reclaim() gets the lruvec from the memcg and node ID to keep a
cleaner interface on the caller side.

Link: https://lkml.kernel.org/r/20230522112058.2965866-2-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yuanchu Xie <yuanchu@google.com>
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

mm-multi-gen-lru-use-macro-for-bitmap.patch
mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch
mm-multi-gen-lru-add-helpers-in-page-table-walks.patch
mm-multi-gen-lru-cleanup-lru_gen_test_recent.patch

