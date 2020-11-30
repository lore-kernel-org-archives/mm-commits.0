Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C9C63777
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 22:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DADC52085B
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 22:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y7zdSB+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgK3WJo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730190AbgK3WJo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 17:09:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4930620709;
        Mon, 30 Nov 2020 22:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606774136;
        bh=+LG/8fnv2j4yxqvWfH6Plb8yvwYriRogQTygmnN8nsU=;
        h=Date:From:To:Subject:From;
        b=y7zdSB+5EkVHHTQHK0ZBMnssMj29k/5/F+zkkLh3bFGzYO7qg+RtgZ2NoG6t2aLau
         k+W/vEAJvKcKFBHMcDOnyyO4jt8P6zNdGjtcHxrkf6+W97RUuwGAopvPsACQpF0Jcd
         UyGUErua+bHZrYBuNPJdcC/2j8AJuN8eJEdYMT+Q=
Date:   Mon, 30 Nov 2020 14:08:55 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-move-lruvec-stats-update-functions-to-vmstath.patch
 added to -mm tree
Message-ID: <20201130220855.3r_eSCUi0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move lruvec stats update functions to vmstat.h
has been added to the -mm tree.  Its filename is
     mm-move-lruvec-stats-update-functions-to-vmstath.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-lruvec-stats-update-functions-to-vmstath.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-lruvec-stats-update-functions-to-vmstath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -815,8 +815,6 @@ static inline unsigned long lruvec_page_
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
@@ -839,43 +837,6 @@ static inline void mod_memcg_lruvec_stat
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
@@ -1267,30 +1228,6 @@ static inline void __mod_memcg_lruvec_st
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
@@ -1374,30 +1311,6 @@ static inline void __dec_memcg_page_stat
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
@@ -1436,30 +1349,6 @@ static inline void dec_memcg_page_state(
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
@@ -856,6 +856,23 @@ void __mod_lruvec_state(struct lruvec *l
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

Patches currently in -mm which might be from shakeelb@google.com are

mm-rmap-always-do-ttu_ignore_access.patch
mm-move-lruvec-stats-update-functions-to-vmstath.patch
mm-memcontrol-account-pagetables-per-node.patch
mm-kvm-account-kvm_vcpu_mmap-to-kmemcg.patch

