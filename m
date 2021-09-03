Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A18C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0039F60E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhICU6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350418AbhICU6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE21601FD;
        Fri,  3 Sep 2021 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702639;
        bh=T4pLQxYnGXoNEgaytMEbLSTiGqFMiRjYpvwrExZADvQ=;
        h=Date:From:To:Subject:From;
        b=YUdBGSTMMBc7MHsX3/dW+SFI1du3UHla/imCey7Qd5UHxryTBCQjjM5k7Zmja7iq9
         FL4qjAf/czudh9++PAxW+310K3ZxWXRBGnRY7zLXIlhHugsHJaYkC3w6xOCyWEisY/
         aS1+44vpUvAXyZiLbCcDJN6CfGvsCNrN4qpE+o/k=
Date:   Fri, 03 Sep 2021 13:57:18 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, apopple@nvidia.com, axboe@kernel.dk,
        david@redhat.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com, surenb@google.com,
        tj@kernel.org, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memcg-inline-mem=5Fcgroup=5Fcharge-uncharge-to-improve?=
 =?US-ASCII?Q?-disabled-memcg-config.patch?= removed from -mm tree
Message-ID: <20210903205718.8jTnydPR3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config
has been removed from the -mm tree.  Its filename was
     mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from surenb@google.com are


