Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE55BC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5296125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhKEUkS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42314611C0;
        Fri,  5 Nov 2021 20:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144658;
        bh=xFZJjqfbB2coAlfjMLpnv1ffrcNXhB2MQsxAUgr8ouk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IxkflBrzC0/Q4D0X7SABuqdZg/FqnT8ahpTqk5NqL/xaTnTaxRexf6nUd5/DSv/Zn
         NT2UvMhpX7HUQ3okYGBb3nmwPrCOiuNNoeiBZwVDcUDdYDVoz4OLh7BYWF0h6Afe0b
         WzRWiWJx2zWGNel0p/enqRgCqOX+/FLjmR2paeOs=
Date:   Fri, 05 Nov 2021 13:37:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, atomlin@redhat.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, longman@redhat.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  [patch 057/262] mm/memcg: remove obsolete
 memcg_free_kmem()
Message-ID: <20211105203737.zbyywaHFG%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
