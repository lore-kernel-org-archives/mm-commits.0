Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE50C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD24522525
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgLODIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbgLODID (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:08:03 -0500
Date:   Mon, 14 Dec 2020 19:07:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001635;
        bh=295n/PzX5Z1O990yJk+Q43xJMKK6gW96/whNsl9P8KM=;
        h=From:To:Subject:In-Reply-To:From;
        b=Qm9HngV+OBoFfeuiZKGJLNLs5GWSZaHsd+i1G0x1Wq18EJ5S4LHYj7hGsoH0hjMdR
         xs+Iw8EGhNx/K8Swh0JPaEhNXG31x/DdK+kqxXDWWqiPgcDdnoqUMPn9ynO/xdrnCQ
         MU8+gffYpPkARYPHFesbXsejUTmjO9eYLquuCQeo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 071/200] mm: move lruvec stats update functions to
 vmstat.h
Message-ID: <20201215030714.sY4TR2x6z%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: mm: move lruvec stats update functions to vmstat.h

Patch series "memcg: add pagetable comsumption to memory.stat", v2.

Many workloads consumes significant amount of memory in pagetables.  One
specific use-case is the user space network driver which mmaps the
application memory to provide zero copy transfer.  This driver can consume
a large amount memory in page tables.  This patch series exposes the
pagetable comsumption for each memory cgroup.


This patch (of 2):

This does not change any functionality and only move the functions which
update the lruvec stats to vmstat.h from memcontrol.h.  The main reason
for this patch is to be able to use these functions in the page table
contructor function which is defined in mm.h and we can not include the
memcontrol.h in that file.  Also this is a better place for this interface
in general.  The lruvec abstraction, while invented for memcg, isn't
specific to memcg at all.

Link: https://lkml.kernel.org/r/20201130212541.2781790-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  111 -----------------------------------
 include/linux/vmstat.h     |  104 ++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |   17 +++++
 3 files changed, 121 insertions(+), 111 deletions(-)

--- a/include/linux/memcontrol.h~mm-move-lruvec-stats-update-functions-to-vmstath
+++ a/include/linux/memcontrol.h
@@ -786,8 +786,6 @@ static inline unsigned long lruvec_page_
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
@@ -810,43 +808,6 @@ static inline void mod_memcg_lruvec_stat
 	local_irq_restore(flags);
 }
 
-static inline void mod_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_lruvec_state(lruvec, idx, val);
-	local_irq_restore(flags);
-}
-
-static inline void __mod_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx, int val)
-{
-	struct page *head = compound_head(page); /* rmap on tail pages */
-	pg_data_t *pgdat = page_pgdat(page);
-	struct lruvec *lruvec;
-
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!head->mem_cgroup) {
-		__mod_node_page_state(pgdat, idx, val);
-		return;
-	}
-
-	lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
-	__mod_lruvec_state(lruvec, idx, val);
-}
-
-static inline void mod_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_lruvec_page_state(page, idx, val);
-	local_irq_restore(flags);
-}
-
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
@@ -1205,30 +1166,6 @@ static inline void __mod_memcg_lruvec_st
 {
 }
 
-static inline void __mod_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx, int val)
-{
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-}
-
-static inline void mod_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx, int val)
-{
-	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-}
-
-static inline void __mod_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx, int val)
-{
-	__mod_node_page_state(page_pgdat(page), idx, val);
-}
-
-static inline void mod_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx, int val)
-{
-	mod_node_page_state(page_pgdat(page), idx, val);
-}
-
 static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					   int val)
 {
@@ -1308,30 +1245,6 @@ static inline void __dec_memcg_page_stat
 	__mod_memcg_page_state(page, idx, -1);
 }
 
-static inline void __inc_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
-{
-	__mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void __dec_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
-{
-	__mod_lruvec_state(lruvec, idx, -1);
-}
-
-static inline void __inc_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void __dec_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, -1);
-}
-
 static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
 	__mod_lruvec_kmem_state(p, idx, 1);
@@ -1370,30 +1283,6 @@ static inline void dec_memcg_page_state(
 	mod_memcg_page_state(page, idx, -1);
 }
 
-static inline void inc_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void dec_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, -1);
-}
-
-static inline void inc_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void dec_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, -1);
-}
-
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
--- a/include/linux/vmstat.h~mm-move-lruvec-stats-update-functions-to-vmstath
+++ a/include/linux/vmstat.h
@@ -450,4 +450,108 @@ static inline const char *vm_event_name(
 }
 #endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
 
+#ifdef CONFIG_MEMCG
+
+void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			int val);
+
+static inline void mod_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx, int val)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__mod_lruvec_state(lruvec, idx, val);
+	local_irq_restore(flags);
+}
+
+void __mod_lruvec_page_state(struct page *page,
+			     enum node_stat_item idx, int val);
+
+static inline void mod_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx, int val)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__mod_lruvec_page_state(page, idx, val);
+	local_irq_restore(flags);
+}
+
+#else
+
+static inline void __mod_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx, int val)
+{
+	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+}
+
+static inline void mod_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx, int val)
+{
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+}
+
+static inline void __mod_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx, int val)
+{
+	__mod_node_page_state(page_pgdat(page), idx, val);
+}
+
+static inline void mod_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx, int val)
+{
+	mod_node_page_state(page_pgdat(page), idx, val);
+}
+
+#endif /* CONFIG_MEMCG */
+
+static inline void __inc_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	__mod_lruvec_state(lruvec, idx, 1);
+}
+
+static inline void __dec_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	__mod_lruvec_state(lruvec, idx, -1);
+}
+
+static inline void __inc_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx)
+{
+	__mod_lruvec_page_state(page, idx, 1);
+}
+
+static inline void __dec_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx)
+{
+	__mod_lruvec_page_state(page, idx, -1);
+}
+
+static inline void inc_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	mod_lruvec_state(lruvec, idx, 1);
+}
+
+static inline void dec_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	mod_lruvec_state(lruvec, idx, -1);
+}
+
+static inline void inc_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx)
+{
+	mod_lruvec_page_state(page, idx, 1);
+}
+
+static inline void dec_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx)
+{
+	mod_lruvec_page_state(page, idx, -1);
+}
+
 #endif /* _LINUX_VMSTAT_H */
--- a/mm/memcontrol.c~mm-move-lruvec-stats-update-functions-to-vmstath
+++ a/mm/memcontrol.c
@@ -853,6 +853,23 @@ void __mod_lruvec_state(struct lruvec *l
 		__mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
+void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
+			     int val)
+{
+	struct page *head = compound_head(page); /* rmap on tail pages */
+	pg_data_t *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
+
+	/* Untracked pages have no memcg, no lruvec. Update only the node */
+	if (!head->mem_cgroup) {
+		__mod_node_page_state(pgdat, idx, val);
+		return;
+	}
+
+	lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
+	__mod_lruvec_state(lruvec, idx, val);
+}
+
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
_
