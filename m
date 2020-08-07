Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE61C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF57A2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781327;
	bh=Xl/qgk7bGxv2hcZoa4sFHFFj+X2a7VZedKrg964YjGE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xgI3Tl+6mvR0kqv1MXjwTaUou9pdG7OZ9F0oVww4Q7YHFNsYutMrXSW7s1JM6pDZm
	 z3M7Q4G2xxWxQ0Bkb3eibHuU3hMKhhmclv/5MqMbVRvwUlPdXMMQbF9fHN83G2lJXN
	 bOAcqp4ftRyoYdNfJDYG29FG3+YLzuZ05auEB/ac=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHGGWH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGWH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A5222C9F;
        Fri,  7 Aug 2020 06:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781326;
        bh=Xl/qgk7bGxv2hcZoa4sFHFFj+X2a7VZedKrg964YjGE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e9RBW9WT1ghvckN2BajGS8KneVQzJB4LGYhOdc+NwvXObJ9ULy1ncWb08osRd2nSl
         PL9HpwhmxwuU+Jb7cdVkJEffb344NxeT5LFoElQl2/0sMfM1mESie1geMQ4mwo+spF
         eybwk6i5aEawIxC7qRU1b1nei1gH9T/jvmzlyWi4=
Date:   Thu, 06 Aug 2020 23:22:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 089/163] mm, memcg: decouple e{low,min} state
 mutations from protection checks
Message-ID: <20200807062205.giFveKsjG%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: decouple e{low,min} state mutations from protection checks

mem_cgroup_protected currently is both used to set effective low and min
and return a mem_cgroup_protection based on the result.  As a user, this
can be a little unexpected: it appears to be a simple predicate function,
if not for the big warning in the comment above about the order in which
it must be executed.

This change makes it so that we separate the state mutations from the
actual protection checks, which makes it more obvious where we need to be
careful mutating internal state, and where we are simply checking and
don't need to worry about that.

[mhocko@suse.com - don't check protection on root memcgs]
Link: http://lkml.kernel.org/r/ff3f915097fcee9f6d7041c084ef92d16aaeb56a.1594638158.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   53 +++++++++++++++++++++++++++--------
 mm/memcontrol.c            |   28 ++++--------------
 mm/vmscan.c                |   17 ++---------
 3 files changed, 53 insertions(+), 45 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks
+++ a/include/linux/memcontrol.h
@@ -47,12 +47,6 @@ enum memcg_memory_event {
 	MEMCG_NR_MEMORY_EVENTS,
 };
 
-enum mem_cgroup_protection {
-	MEMCG_PROT_NONE,
-	MEMCG_PROT_LOW,
-	MEMCG_PROT_MIN,
-};
-
 struct mem_cgroup_reclaim_cookie {
 	pg_data_t *pgdat;
 	unsigned int generation;
@@ -405,8 +399,36 @@ static inline unsigned long mem_cgroup_p
 		   READ_ONCE(memcg->memory.elow));
 }
 
-enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
-						struct mem_cgroup *memcg);
+void mem_cgroup_calculate_protection(struct mem_cgroup *root,
+				     struct mem_cgroup *memcg);
+
+static inline bool mem_cgroup_supports_protection(struct mem_cgroup *memcg)
+{
+	/*
+	 * The root memcg doesn't account charges, and doesn't support
+	 * protection.
+	 */
+	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg);
+
+}
+
+static inline bool mem_cgroup_below_low(struct mem_cgroup *memcg)
+{
+	if (!mem_cgroup_supports_protection(memcg))
+		return false;
+
+	return READ_ONCE(memcg->memory.elow) >=
+		page_counter_read(&memcg->memory);
+}
+
+static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
+{
+	if (!mem_cgroup_supports_protection(memcg))
+		return false;
+
+	return READ_ONCE(memcg->memory.emin) >=
+		page_counter_read(&memcg->memory);
+}
 
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
 
@@ -935,10 +957,19 @@ static inline unsigned long mem_cgroup_p
 	return 0;
 }
 
-static inline enum mem_cgroup_protection mem_cgroup_protected(
-	struct mem_cgroup *root, struct mem_cgroup *memcg)
+static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
+						   struct mem_cgroup *memcg)
+{
+}
+
+static inline bool mem_cgroup_below_low(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
+static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
 {
-	return MEMCG_PROT_NONE;
+	return false;
 }
 
 static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
--- a/mm/memcontrol.c~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks
+++ a/mm/memcontrol.c
@@ -6587,21 +6587,15 @@ static unsigned long effective_protectio
  *
  * WARNING: This function is not stateless! It can only be used as part
  *          of a top-down tree iteration, not for isolated queries.
- *
- * Returns one of the following:
- *   MEMCG_PROT_NONE: cgroup memory is not protected
- *   MEMCG_PROT_LOW: cgroup memory is protected as long there is
- *     an unprotected supply of reclaimable memory from other cgroups.
- *   MEMCG_PROT_MIN: cgroup memory is protected
  */
-enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
-						struct mem_cgroup *memcg)
+void mem_cgroup_calculate_protection(struct mem_cgroup *root,
+				     struct mem_cgroup *memcg)
 {
 	unsigned long usage, parent_usage;
 	struct mem_cgroup *parent;
 
 	if (mem_cgroup_disabled())
-		return MEMCG_PROT_NONE;
+		return;
 
 	if (!root)
 		root = root_mem_cgroup;
@@ -6614,21 +6608,21 @@ enum mem_cgroup_protection mem_cgroup_pr
 	 * that special casing.
 	 */
 	if (memcg == root)
-		return MEMCG_PROT_NONE;
+		return;
 
 	usage = page_counter_read(&memcg->memory);
 	if (!usage)
-		return MEMCG_PROT_NONE;
+		return;
 
 	parent = parent_mem_cgroup(memcg);
 	/* No parent means a non-hierarchical mode on v1 memcg */
 	if (!parent)
-		return MEMCG_PROT_NONE;
+		return;
 
 	if (parent == root) {
 		memcg->memory.emin = READ_ONCE(memcg->memory.min);
 		memcg->memory.elow = READ_ONCE(memcg->memory.low);
-		goto out;
+		return;
 	}
 
 	parent_usage = page_counter_read(&parent->memory);
@@ -6642,14 +6636,6 @@ enum mem_cgroup_protection mem_cgroup_pr
 			READ_ONCE(memcg->memory.low),
 			READ_ONCE(parent->memory.elow),
 			atomic_long_read(&parent->memory.children_low_usage)));
-
-out:
-	if (usage <= memcg->memory.emin)
-		return MEMCG_PROT_MIN;
-	else if (usage <= memcg->memory.elow)
-		return MEMCG_PROT_LOW;
-	else
-		return MEMCG_PROT_NONE;
 }
 
 /**
--- a/mm/vmscan.c~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks
+++ a/mm/vmscan.c
@@ -2620,14 +2620,15 @@ static void shrink_node_memcgs(pg_data_t
 		unsigned long reclaimed;
 		unsigned long scanned;
 
-		switch (mem_cgroup_protected(target_memcg, memcg)) {
-		case MEMCG_PROT_MIN:
+		mem_cgroup_calculate_protection(target_memcg, memcg);
+
+		if (mem_cgroup_below_min(memcg)) {
 			/*
 			 * Hard protection.
 			 * If there is no reclaimable memory, OOM.
 			 */
 			continue;
-		case MEMCG_PROT_LOW:
+		} else if (mem_cgroup_below_low(memcg)) {
 			/*
 			 * Soft protection.
 			 * Respect the protection only as long as
@@ -2639,16 +2640,6 @@ static void shrink_node_memcgs(pg_data_t
 				continue;
 			}
 			memcg_memory_event(memcg, MEMCG_LOW);
-			break;
-		case MEMCG_PROT_NONE:
-			/*
-			 * All protection thresholds breached. We may
-			 * still choose to vary the scan pressure
-			 * applied based on by how much the cgroup in
-			 * question has exceeded its protection
-			 * thresholds (see get_scan_count).
-			 */
-			break;
 		}
 
 		reclaimed = sc->nr_reclaimed;
_
