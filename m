Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279DFC3526E
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB31923BB5
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgLTC6R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbgLTC6R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:17 -0500
Date:   Sat, 19 Dec 2020 18:57:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433057;
        bh=GDJ5Q9A0863F9THLRzmmmut+YK5pYeHkRNKWuSZ0Q30=;
        h=From:To:Subject:From;
        b=pBdT9nAhswB3PWyvk1PDUDZkgCDjWyqBT0tw9CHzRRAEzy0+VK/naJP3BuF1NhN+b
         Vcbl+kX1GKl29zNNtArPiMOtyRy+jYMtBZ6IIC/SvYsuMQhedpPyFcqcNdfSQxrdJy
         LsSHd+wCatuBEOatHttAazzJUnkRlOdriFXjMjXY=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, laoar.shao@gmail.com, lstoakes@gmail.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, sh_def@163.com,
        shakeelb@google.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch removed from -mm tree
Message-ID: <20201220025736.0U_5GSpNx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol:rewrite mem_cgroup_page_lruvec()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/memcontrol:rewrite mem_cgroup_page_lruvec()

mem_cgroup_page_lruvec() in memcontrol.c and mem_cgroup_lruvec() in
memcontrol.h is very similar except for the param(page and memcg) which
also can be convert to each other.

So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().

[alex.shi@linux.alibaba.com: add missed warning in mem_cgroup_lruvec]
  Link: https://lkml.kernel.org/r/94f17bb7-ec61-5b72-3555-fabeb5a4d73b@linux.alibaba.com
[lstoakes@gmail.com: warn on missing memcg on mem_cgroup_page_lruvec()]
  Link: https://lkml.kernel.org/r/20201125112202.387009-1-lstoakes@gmail.com
Link: https://lkml.kernel.org/r/20201108143731.GA74138@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   19 ++++++++++++++++-
 mm/memcontrol.c            |   37 -----------------------------------
 2 files changed, 17 insertions(+), 39 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rewrite-mem_cgroup_page_lruvec
+++ a/include/linux/memcontrol.h
@@ -620,9 +620,10 @@ mem_cgroup_nodeinfo(struct mem_cgroup *m
 /**
  * mem_cgroup_lruvec - get the lru list vector for a memcg & node
  * @memcg: memcg of the wanted lruvec
+ * @pgdat: pglist_data
  *
  * Returns the lru list vector holding pages for a given @memcg &
- * @node combination. This can be the node lruvec, if the memory
+ * @pgdat combination. This can be the node lruvec, if the memory
  * controller is disabled.
  */
 static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
@@ -652,7 +653,21 @@ out:
 	return lruvec;
 }
 
-struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
+/**
+ * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
+ * @page: the page
+ * @pgdat: pgdat of the page
+ *
+ * This function relies on page->mem_cgroup being stable.
+ */
+static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
+						struct pglist_data *pgdat)
+{
+	struct mem_cgroup *memcg = page_memcg(page);
+
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
+	return mem_cgroup_lruvec(memcg, pgdat);
+}
 
 static inline bool lruvec_holds_page_lru_lock(struct page *page,
 					      struct lruvec *lruvec)
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-mem_cgroup_page_lruvec
+++ a/mm/memcontrol.c
@@ -1343,43 +1343,6 @@ void lruvec_memcg_debug(struct lruvec *l
 #endif
 
 /**
- * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
- * @page: the page
- * @pgdat: pgdat of the page
- *
- * This function relies on page's memcg being stable - see the
- * access rules in commit_charge().
- */
-struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
-{
-	struct mem_cgroup_per_node *mz;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	if (mem_cgroup_disabled()) {
-		lruvec = &pgdat->__lruvec;
-		goto out;
-	}
-
-	memcg = page_memcg(page);
-	VM_WARN_ON_ONCE_PAGE(!memcg, page);
-	if (!memcg)
-		memcg = root_mem_cgroup;
-
-	mz = mem_cgroup_page_nodeinfo(memcg, page);
-	lruvec = &mz->lruvec;
-out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->pgdat != pgdat))
-		lruvec->pgdat = pgdat;
-	return lruvec;
-}
-
-/**
  * lock_page_lruvec - lock and return lruvec for a given page.
  * @page: the page
  *
_

Patches currently in -mm which might be from sh_def@163.com are


