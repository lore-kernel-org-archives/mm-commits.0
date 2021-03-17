Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BFBC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C9864EEE
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCQXnh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhCQXnK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:43:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7B4C64EED;
        Wed, 17 Mar 2021 23:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616024590;
        bh=VSveWCnRoIQ64r4YbPeiuF8FC1BGlMdkHjXyZxADEos=;
        h=Date:From:To:Subject:From;
        b=0E7uAcaxi9JE0FekrqsYq/a3Nd7aNnOpDzadIqAl9AKQYLi7DakJW6er/GZKNrLR0
         TJ3MQz0IkYGvXF8g70i8zVLqPHGSkhgcKoZy9sZwSZfrK2/jG9Cmz2VEyafDxww+OJ
         KLDuwgFrmlUvYiOA2Qu1gxbcMjJk6C1LxlbB5i6g=
Date:   Wed, 17 Mar 2021 16:43:09 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, guro@fb.com, hannes@cmpxchg.org,
        hca@linux.ibm.com, hughd@google.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        shakeelb@google.com
Subject:  [failures]
 memcg-charge-before-adding-to-swapcache-on-swapin.patch removed from -mm
 tree
Message-ID: <20210317234309.NiG8gvXV9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: charge before adding to swapcache on swapin
has been removed from the -mm tree.  Its filename was
     memcg-charge-before-adding-to-swapcache-on-swapin.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: charge before adding to swapcache on swapin

Currently the kernel adds the page, allocated for swapin, to the swapcache
before charging the page.  This is fine but now we want a per-memcg
swapcache stat which is essential for folks who wants to transparently
migrate from cgroup v1's memsw to cgroup v2's memory and swap counters. 
In addition charging a page before exposing it to other parts of the
kernel is a step in the right direction.

To correctly maintain the per-memcg swapcache stat, this patch has adopted
to charge the page before adding it to swapcache.  One challenge in this
option is the failure case of add_to_swap_cache() on which we need to undo
the mem_cgroup_charge().  Specifically undoing mem_cgroup_uncharge_swap()
is not simple.

To resolve the issue, this patch decouples the charging for swapin pages
from mem_cgroup_charge().  Two new functions are introduced,
mem_cgroup_swapin_charge_page() for just charging the swapin page and
mem_cgroup_swapin_uncharge_swap() for uncharging the swap slot once the
page has been successfully added to the swapcache.

Link: https://lkml.kernel.org/r/20210305212639.775498-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++
 mm/memcontrol.c            |  119 ++++++++++++++++++++++-------------
 mm/memory.c                |   12 ---
 mm/swap_state.c            |   13 +--
 4 files changed, 97 insertions(+), 60 deletions(-)

--- a/include/linux/memcontrol.h~memcg-charge-before-adding-to-swapcache-on-swapin
+++ a/include/linux/memcontrol.h
@@ -596,6 +596,9 @@ static inline bool mem_cgroup_below_min(
 }
 
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
+int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
+				  gfp_t gfp, swp_entry_t entry);
+void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
 
 void mem_cgroup_uncharge(struct page *page);
 void mem_cgroup_uncharge_list(struct list_head *page_list);
@@ -1138,6 +1141,16 @@ static inline int mem_cgroup_charge(stru
 	return 0;
 }
 
+static inline int mem_cgroup_swapin_charge_page(struct page *page,
+			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry)
+{
+}
+
 static inline void mem_cgroup_uncharge(struct page *page)
 {
 }
--- a/mm/memcontrol.c~memcg-charge-before-adding-to-swapcache-on-swapin
+++ a/mm/memcontrol.c
@@ -6666,6 +6666,27 @@ void mem_cgroup_calculate_protection(str
 			atomic_long_read(&parent->memory.children_low_usage)));
 }
 
+static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
+			       gfp_t gfp)
+{
+	unsigned int nr_pages = thp_nr_pages(page);
+	int ret;
+
+	ret = try_charge(memcg, gfp, nr_pages);
+	if (ret)
+		goto out;
+
+	css_get(&memcg->css);
+	commit_charge(page, memcg);
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(memcg, page, nr_pages);
+	memcg_check_events(memcg, page);
+	local_irq_enable();
+out:
+	return ret;
+}
+
 /**
  * mem_cgroup_charge - charge a newly allocated page to a cgroup
  * @page: page to charge
@@ -6675,55 +6696,71 @@ void mem_cgroup_calculate_protection(str
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
  * pages according to @gfp_mask if necessary.
  *
+ * Do not use this for pages allocated for swapin.
+ *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
-	unsigned int nr_pages = thp_nr_pages(page);
-	struct mem_cgroup *memcg = NULL;
-	int ret = 0;
+	struct mem_cgroup *memcg;
+	int ret;
 
 	if (mem_cgroup_disabled())
-		goto out;
+		return 0;
 
-	if (PageSwapCache(page)) {
-		swp_entry_t ent = { .val = page_private(page), };
-		unsigned short id;
+	memcg = get_mem_cgroup_from_mm(mm);
+	ret = __mem_cgroup_charge(page, memcg, gfp_mask);
+	css_put(&memcg->css);
 
-		/*
-		 * Every swap fault against a single page tries to charge the
-		 * page, bail as early as possible.  shmem_unuse() encounters
-		 * already charged pages, too.  page and memcg binding is
-		 * protected by the page lock, which serializes swap cache
-		 * removal, which in turn serializes uncharging.
-		 */
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		if (page_memcg(compound_head(page)))
-			goto out;
-
-		id = lookup_swap_cgroup_id(ent);
-		rcu_read_lock();
-		memcg = mem_cgroup_from_id(id);
-		if (memcg && !css_tryget_online(&memcg->css))
-			memcg = NULL;
-		rcu_read_unlock();
-	}
+	return ret;
+}
 
-	if (!memcg)
-		memcg = get_mem_cgroup_from_mm(mm);
+/**
+ * mem_cgroup_swapin_charge_page - charge a newly allocated page for swapin
+ * @page: page to charge
+ * @mm: mm context of the victim
+ * @gfp: reclaim mode
+ * @entry: swap entry for which the page is allocated
+ *
+ * This function charges a page allocated for swapin. Please call this before
+ * adding the page to the swapcache.
+ *
+ * Returns 0 on success. Otherwise, an error code is returned.
+ */
+int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
+				  gfp_t gfp, swp_entry_t entry)
+{
+	struct mem_cgroup *memcg;
+	unsigned short id;
+	int ret;
 
-	ret = try_charge(memcg, gfp_mask, nr_pages);
-	if (ret)
-		goto out_put;
+	if (mem_cgroup_disabled())
+		return 0;
 
-	css_get(&memcg->css);
-	commit_charge(page, memcg);
+	id = lookup_swap_cgroup_id(entry);
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(id);
+	if (!memcg || !css_tryget_online(&memcg->css))
+		memcg = get_mem_cgroup_from_mm(mm);
+	rcu_read_unlock();
 
-	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, page, nr_pages);
-	memcg_check_events(memcg, page);
-	local_irq_enable();
+	ret = __mem_cgroup_charge(page, memcg, gfp);
 
+	css_put(&memcg->css);
+	return ret;
+}
+
+/*
+ * mem_cgroup_swapin_uncharge_swap - uncharge swap slot
+ * @entry: swap entry for which the page is charged
+ *
+ * Call this function after successfully adding the charged page to swapcache.
+ *
+ * Note: This function assumes the page for which swap slot is being uncharged
+ * is order 0 page.
+ */
+void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry)
+{
 	/*
 	 * Cgroup1's unified memory+swap counter has been charged with the
 	 * new swapcache page, finish the transfer by uncharging the swap
@@ -6736,20 +6773,14 @@ int mem_cgroup_charge(struct page *page,
 	 * correspond 1:1 to page and swap slot lifetimes: we charge the
 	 * page to memory here, and uncharge swap when the slot is freed.
 	 */
-	if (do_memsw_account() && PageSwapCache(page)) {
-		swp_entry_t entry = { .val = page_private(page) };
+	if (!mem_cgroup_disabled() && do_memsw_account()) {
 		/*
 		 * The swap entry might not get freed for a long time,
 		 * let's not wait for it.  The page already received a
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
-		mem_cgroup_uncharge_swap(entry, nr_pages);
+		mem_cgroup_uncharge_swap(entry, 1);
 	}
-
-out_put:
-	css_put(&memcg->css);
-out:
-	return ret;
 }
 
 struct uncharge_gather {
--- a/mm/memory.c~memcg-charge-before-adding-to-swapcache-on-swapin
+++ a/mm/memory.c
@@ -3309,21 +3309,15 @@ vm_fault_t do_swap_page(struct vm_fault
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 							vmf->address);
 			if (page) {
-				int err;
-
 				__SetPageLocked(page);
 				__SetPageSwapBacked(page);
-				set_page_private(page, entry.val);
 
-				/* Tell memcg to use swap ownership records */
-				SetPageSwapCache(page);
-				err = mem_cgroup_charge(page, vma->vm_mm,
-							GFP_KERNEL);
-				ClearPageSwapCache(page);
-				if (err) {
+				if (mem_cgroup_swapin_charge_page(page,
+					vma->vm_mm, GFP_KERNEL, entry)) {
 					ret = VM_FAULT_OOM;
 					goto out_page;
 				}
+				mem_cgroup_swapin_uncharge_swap(entry);
 
 				shadow = get_shadow_from_swap_cache(entry);
 				if (shadow)
--- a/mm/swap_state.c~memcg-charge-before-adding-to-swapcache-on-swapin
+++ a/mm/swap_state.c
@@ -493,16 +493,14 @@ struct page *__read_swap_cache_async(swp
 	__SetPageLocked(page);
 	__SetPageSwapBacked(page);
 
-	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow)) {
-		put_swap_page(page, entry);
+	if (mem_cgroup_swapin_charge_page(page, NULL, gfp_mask, entry))
 		goto fail_unlock;
-	}
 
-	if (mem_cgroup_charge(page, NULL, gfp_mask)) {
-		delete_from_swap_cache(page);
+	/* May fail (-ENOMEM) if XArray node allocation failed. */
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
-	}
+
+	mem_cgroup_swapin_uncharge_swap(entry);
 
 	if (shadow)
 		workingset_refault(page, shadow);
@@ -513,6 +511,7 @@ struct page *__read_swap_cache_async(swp
 	return page;
 
 fail_unlock:
+	put_swap_page(page, entry);
 	unlock_page(page);
 	put_page(page);
 	return NULL;
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-cleanup-root-memcg-checks.patch
memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch

