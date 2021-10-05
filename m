Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5ACC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 20:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7492A61423
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 20:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhJEU7J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 16:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236593AbhJEU7I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 16:59:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D2BC613A9;
        Tue,  5 Oct 2021 20:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633467437;
        bh=tu/+9pt5Fr5SgFfFYg3wagTwGA+WL1FtHmWyealUYZ4=;
        h=Date:From:To:Subject:From;
        b=1fo2TTBelKr+Az4WipWhdHawjzPVIKsSgv5GaZoJv48YuYiwx2YS7/aQSefNFGYSg
         AVUL/4eEPpvKBWP2zrzws8+aYf1SifSFAc+oCmRnvGhja9jJEB7eS/7/W8JqhUy3dT
         PekUdYP+O6mmB4aomCaA66J5LUGjB1JRuvJwwLGY=
Date:   Tue, 05 Oct 2021 13:57:17 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, longman@redhat.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  + mm-memcg-remove-obsolete-memcg_free_kmem.patch added to
 -mm tree
Message-ID: <20211005205717.LvcpsrUwx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove obsolete memcg_free_kmem()
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-obsolete-memcg_free_kmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-remove-obsolete-memcg_free_kmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-remove-obsolete-memcg_free_kmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: remove obsolete memcg_free_kmem()

Since commit d648bcc7fe65 ("mm: kmem: make memcg_kmem_enabled()
irreversible"), the only thing memcg_free_kmem() does is to call
memcg_offline_kmem() when the memcg is still online which can happen when
online_css() fails due to -ENOMEM.  However, the name memcg_free_kmem() is
confusing and it is more clear and straight forward to call
memcg_offline_kmem() directly from mem_cgroup_css_free().

Link: https://lkml.kernel.org/r/20211005202450.11775-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-remove-obsolete-memcg_free_kmem
+++ a/mm/memcontrol.c
@@ -3704,13 +3704,6 @@ static void memcg_offline_kmem(struct me
 
 	memcg_free_cache_id(kmemcg_id);
 }
-
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-	/* css_alloc() failed, offlining didn't happen */
-	if (unlikely(memcg->kmem_state == KMEM_ONLINE))
-		memcg_offline_kmem(memcg);
-}
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -3719,9 +3712,6 @@ static int memcg_online_kmem(struct mem_
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 }
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 static int memcg_update_kmem_max(struct mem_cgroup *memcg,
@@ -5356,7 +5346,9 @@ static void mem_cgroup_css_free(struct c
 	cancel_work_sync(&memcg->high_work);
 	mem_cgroup_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
-	memcg_free_kmem(memcg);
+
+	/* Need to offline kmem if online_css() fails */
+	memcg_offline_kmem(memcg);
 	mem_cgroup_free(memcg);
 }
 
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-remove-obsolete-memcg_free_kmem.patch

