Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4018DC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F65610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347733AbhIBV4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347889AbhIBVzu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18DD260F12;
        Thu,  2 Sep 2021 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619691;
        bh=x1eZoefRVn+iz9Q+aDrhAkZxPr+tZcqLO8HlFBqiKZc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=An2K8Cj1+p2bzuFcKR1IC0FL+4d1ufJD1Ox/Ww/3uF1yY313Nnt5EAV+vQbAGA8wj
         q6+1Th53N6hgv2l/rt5WPt/I4Palsim8SkT/GIChS7g3m07spuCjRGVK2YkNiVXpJ8
         dMOBqNxQIIQlT4Auo+bms4Hwlpc4mntVymjxnm8k=
Date:   Thu, 02 Sep 2021 14:54:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, apopple@nvidia.com,
        axboe@kernel.dk, david@redhat.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com, surenb@google.com,
        tj@kernel.org, torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 093/212] mm, memcg: inline
 mem_cgroup_{charge/uncharge} to improve disabled memcg config
Message-ID: <20210902215450.J2ilaQh75%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>
Subject: mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config

Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
functions to perform mem_cgroup_disabled static key check inline before
calling the main body of the function.  This minimizes the memcg overhead
in the pagefault and exit_mmap paths when memcgs are disabled using
cgroup_disable=memory command-line option.

This change results in ~0.4% overhead reduction when running PFT test [1]
comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
configuration on an 8-core ARM64 Android device.

[1] https://lkml.org/lkml/2006/8/29/294 also used in mmtests suite

Link: https://lkml.kernel.org/r/20210713010934.299876-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   28 +++++++++++++++++++++++++---
 mm/memcontrol.c            |   33 ++++++++++++---------------------
 2 files changed, 37 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config
+++ a/include/linux/memcontrol.h
@@ -693,13 +693,35 @@ static inline bool mem_cgroup_below_min(
 		page_counter_read(&memcg->memory);
 }
 
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
+int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+			gfp_t gfp_mask);
+static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+				    gfp_t gfp_mask)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_charge(page, mm, gfp_mask);
+}
+
 int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
 
-void mem_cgroup_uncharge(struct page *page);
-void mem_cgroup_uncharge_list(struct list_head *page_list);
+void __mem_cgroup_uncharge(struct page *page);
+static inline void mem_cgroup_uncharge(struct page *page)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge(page);
+}
+
+void __mem_cgroup_uncharge_list(struct list_head *page_list);
+static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_list(page_list);
+}
 
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
--- a/mm/memcontrol.c~mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config
+++ a/mm/memcontrol.c
@@ -6693,8 +6693,7 @@ void mem_cgroup_calculate_protection(str
 			atomic_long_read(&parent->memory.children_low_usage)));
 }
 
-static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
-			       gfp_t gfp)
+static int charge_memcg(struct page *page, struct mem_cgroup *memcg, gfp_t gfp)
 {
 	unsigned int nr_pages = thp_nr_pages(page);
 	int ret;
@@ -6715,7 +6714,7 @@ out:
 }
 
 /**
- * mem_cgroup_charge - charge a newly allocated page to a cgroup
+ * __mem_cgroup_charge - charge a newly allocated page to a cgroup
  * @page: page to charge
  * @mm: mm context of the victim
  * @gfp_mask: reclaim mode
@@ -6728,16 +6727,14 @@ out:
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
+int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+			gfp_t gfp_mask)
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
-	if (mem_cgroup_disabled())
-		return 0;
-
 	memcg = get_mem_cgroup_from_mm(mm);
-	ret = __mem_cgroup_charge(page, memcg, gfp_mask);
+	ret = charge_memcg(page, memcg, gfp_mask);
 	css_put(&memcg->css);
 
 	return ret;
@@ -6772,7 +6769,7 @@ int mem_cgroup_swapin_charge_page(struct
 		memcg = get_mem_cgroup_from_mm(mm);
 	rcu_read_unlock();
 
-	ret = __mem_cgroup_charge(page, memcg, gfp);
+	ret = charge_memcg(page, memcg, gfp);
 
 	css_put(&memcg->css);
 	return ret;
@@ -6908,18 +6905,15 @@ static void uncharge_page(struct page *p
 }
 
 /**
- * mem_cgroup_uncharge - uncharge a page
+ * __mem_cgroup_uncharge - uncharge a page
  * @page: page to uncharge
  *
- * Uncharge a page previously charged with mem_cgroup_charge().
+ * Uncharge a page previously charged with __mem_cgroup_charge().
  */
-void mem_cgroup_uncharge(struct page *page)
+void __mem_cgroup_uncharge(struct page *page)
 {
 	struct uncharge_gather ug;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	/* Don't touch page->lru of any random page, pre-check: */
 	if (!page_memcg(page))
 		return;
@@ -6930,20 +6924,17 @@ void mem_cgroup_uncharge(struct page *pa
 }
 
 /**
- * mem_cgroup_uncharge_list - uncharge a list of page
+ * __mem_cgroup_uncharge_list - uncharge a list of page
  * @page_list: list of pages to uncharge
  *
  * Uncharge a list of pages previously charged with
- * mem_cgroup_charge().
+ * __mem_cgroup_charge().
  */
-void mem_cgroup_uncharge_list(struct list_head *page_list)
+void __mem_cgroup_uncharge_list(struct list_head *page_list)
 {
 	struct uncharge_gather ug;
 	struct page *page;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	uncharge_gather_clear(&ug);
 	list_for_each_entry(page, page_list, lru)
 		uncharge_page(page, &ug);
_
