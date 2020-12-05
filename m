Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A97C4361A
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 00:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0ED522D70
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 00:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgLEAua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 19:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbgLEAua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 19:50:30 -0500
Date:   Fri, 04 Dec 2020 16:49:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607129398;
        bh=GYEvG5HdXH/yIjv8fZZIKSVXd3R+szR2wRyfW9AgXdE=;
        h=From:To:Subject:From;
        b=j8xQBgekZBtj5Bn05DwI26sr+ZKeoLozgimWX3soJxT5DX/g5ckJS3+okOVsTg+n+
         r8nbVE716Ofyhvz4A3GVK93W4GTRCCx71G2Q0rwDnDFAA4kJix+pUFypwxF2udC2B5
         XbKGcYEV8bNAKn/7PwBwoMFSesnqq05a0TY0AWiM=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        vdavydov.dev@gmail.com
Subject:  [to-be-updated]
 mm-memcontrol-make-the-slab-calculation-consistent.patch removed from -mm
 tree
Message-ID: <20201205004957.sQoKNsBmQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: make the slab calculation consistent
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-the-slab-calculation-consistent.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memcontrol: make the slab calculation consistent

Although the ratio of the slab is one, we also should read the ratio from
the related memory_stats instead of hard-coding.  And the local variable
of size is already the value of slab_unreclaimable.  So we do not need to
read again.  Simplify the code here.

Link: https://lkml.kernel.org/r/20201203031111.3187-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-make-the-slab-calculation-consistent
+++ a/mm/memcontrol.c
@@ -1612,12 +1612,22 @@ static int __init memory_stats_init(void
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
+		switch (memory_stats[i].idx) {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_ANON_THPS ||
-		    memory_stats[i].idx == NR_FILE_THPS ||
-		    memory_stats[i].idx == NR_SHMEM_THPS)
+		case NR_ANON_THPS:
+		case NR_FILE_THPS:
+		case NR_SHMEM_THPS:
 			memory_stats[i].ratio = HPAGE_PMD_SIZE;
+			break;
 #endif
+		case NR_SLAB_UNRECLAIMABLE_B:
+			VM_BUG_ON(i < 1);
+			VM_BUG_ON(memory_stats[i - 1].idx != NR_SLAB_RECLAIMABLE_B);
+			break;
+		default:
+			break;
+		}
+
 		VM_BUG_ON(!memory_stats[i].ratio);
 		VM_BUG_ON(memory_stats[i].idx >= MEMCG_NR_STAT);
 	}
@@ -1653,9 +1663,15 @@ static char *memory_stat_format(struct m
 		size *= memory_stats[i].ratio;
 		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
 
+		/*
+		 * We are printing reclaimable, unreclaimable of the slab
+		 * and the sum of both.
+		 */
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
-			size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
-			       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
+			int idx = i - 1;
+
+			size += memcg_page_state(memcg, memory_stats[idx].idx) *
+				memory_stats[idx].ratio;
 			seq_buf_printf(&s, "slab %llu\n", size);
 		}
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch
mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch
mm-page_alloc-speeding-up-the-iteration-of-max_order.patch
mm-page_isolation-do-not-isolate-the-max-order-page.patch

