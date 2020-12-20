Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD4DC0018C
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0EF423BB5
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgLTC6N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbgLTC6N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:13 -0500
Date:   Sat, 19 Dec 2020 18:57:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433052;
        bh=XyU/brs/9B7MwJA9tE4ybmT/TEE4pO9d851mCcESRpg=;
        h=From:To:Subject:From;
        b=xDcAKMwH/zWs6CrEyULygTELbGEBDqqHEVsruSnyGa51FBNpwH9B2abSwgj1exgGN
         gkDi6KcSei6sa2+DemdvY+KuqpJ0NLzHJ7Q0Nhq+fq/J0DnS8Es1mHK0UsFtbyzAl/
         992og95v/+YE5k7t7L+jGuiCVzmJIhqFFS4sTVzo=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shakeelb@google.com
Subject:  [merged] mm-memcg-remove-unused-definitions.patch removed
 from -mm tree
Message-ID: <20201220025732.fpJVjqLGf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove unused definitions
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-unused-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: remove unused definitions

Some definitions are left unused, just clean them.

Link: https://lkml.kernel.org/r/20201108003834.12669-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  118 -----------------------------------
 1 file changed, 118 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-remove-unused-definitions
+++ a/include/linux/memcontrol.h
@@ -913,41 +913,6 @@ static inline void mod_memcg_state(struc
 	local_irq_restore(flags);
 }
 
-/**
- * mod_memcg_page_state - update page state statistics
- * @page: the page
- * @idx: page state item to account
- * @val: number of pages (positive or negative)
- *
- * The @page must be locked or the caller must use lock_page_memcg()
- * to prevent double accounting when the page is concurrently being
- * moved to another memcg:
- *
- *   lock_page(page) or lock_page_memcg(page)
- *   if (TestClearPageState(page))
- *     mod_memcg_page_state(page, state, -1);
- *   unlock_page(page) or unlock_page_memcg(page)
- *
- * Kernel pages are an exception to this, since they'll never move.
- */
-static inline void __mod_memcg_page_state(struct page *page,
-					  int idx, int val)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (memcg)
-		__mod_memcg_state(memcg, idx, val);
-}
-
-static inline void mod_memcg_page_state(struct page *page,
-					int idx, int val)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-}
-
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
@@ -1395,18 +1360,6 @@ static inline void mod_memcg_state(struc
 {
 }
 
-static inline void __mod_memcg_page_state(struct page *page,
-					  int idx,
-					  int nr)
-{
-}
-
-static inline void mod_memcg_page_state(struct page *page,
-					int idx,
-					int nr)
-{
-}
-
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
@@ -1479,34 +1432,6 @@ static inline void lruvec_memcg_debug(st
 }
 #endif /* CONFIG_MEMCG */
 
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __inc_memcg_state(struct mem_cgroup *memcg,
-				     int idx)
-{
-	__mod_memcg_state(memcg, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __dec_memcg_state(struct mem_cgroup *memcg,
-				     int idx)
-{
-	__mod_memcg_state(memcg, idx, -1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __inc_memcg_page_state(struct page *page,
-					  int idx)
-{
-	__mod_memcg_page_state(page, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __dec_memcg_page_state(struct page *page,
-					  int idx)
-{
-	__mod_memcg_page_state(page, idx, -1);
-}
-
 static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
 	__mod_lruvec_kmem_state(p, idx, 1);
@@ -1517,34 +1442,6 @@ static inline void __dec_lruvec_kmem_sta
 	__mod_lruvec_kmem_state(p, idx, -1);
 }
 
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void inc_memcg_state(struct mem_cgroup *memcg,
-				   int idx)
-{
-	mod_memcg_state(memcg, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void dec_memcg_state(struct mem_cgroup *memcg,
-				   int idx)
-{
-	mod_memcg_state(memcg, idx, -1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void inc_memcg_page_state(struct page *page,
-					int idx)
-{
-	mod_memcg_page_state(page, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void dec_memcg_page_state(struct page *page,
-					int idx)
-{
-	mod_memcg_page_state(page, idx, -1);
-}
-
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
@@ -1733,21 +1630,6 @@ static inline void memcg_kmem_uncharge_p
 		__memcg_kmem_uncharge_page(page, order);
 }
 
-static inline int memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-				    unsigned int nr_pages)
-{
-	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge(memcg, gfp, nr_pages);
-	return 0;
-}
-
-static inline void memcg_kmem_uncharge(struct mem_cgroup *memcg,
-				       unsigned int nr_pages)
-{
-	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge(memcg, nr_pages);
-}
-
 /*
  * A helper for accessing memcg's kmem_id, used for getting
  * corresponding LRU lists.
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


