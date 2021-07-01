Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E72AC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883E461468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbhGABts (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABts (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:49:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B7A6120C;
        Thu,  1 Jul 2021 01:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104038;
        bh=FeUs2sFZLoSEwglpzrWDBHcLyHqfPjSOJ8xCVIMK774=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iv5mpYCJqLAeylJ8W0++ZbPhimHAzh/A3AdlznqVy52OZjFdC6vPq3o2FIzijEUQl
         q5O0tD0MFkoVaCSRbdEWu16hF6Ppmxhed4wJBY6FxTOOgXdMSFpS9i9us7glDYP0I3
         j0p8/yAptuwImxag1EgYXWYqMaDhzvK9xgmv4iuY=
Date:   Wed, 30 Jun 2021 18:47:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        anshuman.khandual@arm.com, bodeddub@amazon.com, bp@alien8.de,
        bsingharora@gmail.com, chenhuang5@huawei.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        duanxiongchun@bytedance.com, hpa@zytor.com,
        joao.m.martins@oracle.com, jroedel@suse.de, linmiaohe@huawei.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        oneukum@suse.com, osalvador@suse.de, paulmck@kernel.org,
        pawan.kumar.gupta@linux.intel.com, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 005/192] mm: hugetlb: defer freeing of HugeTLB
 pages
Message-ID: <20210701014717.qZklIT1OD%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: defer freeing of HugeTLB pages

In the subsequent patch, we should allocate the vmemmap pages when freeing
a HugeTLB page.  But update_and_free_page() can be called under any
context, so we cannot use GFP_KERNEL to allocate vmemmap pages.  However,
we can defer the actual freeing in a kworker to prevent from using
GFP_ATOMIC to allocate the vmemmap pages.

The __update_and_free_page() is where the call to allocate vmemmmap pages
will be inserted.

Link: https://lkml.kernel.org/r/20210510030027.56044-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   83 +++++++++++++++++++++++++++++++++++++----
 mm/hugetlb_vmemmap.c |   12 -----
 mm/hugetlb_vmemmap.h |   17 ++++++++
 3 files changed, 93 insertions(+), 19 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-defer-freeing-of-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -1376,7 +1376,7 @@ static void remove_hugetlb_page(struct h
 	h->nr_huge_pages_node[nid]--;
 }
 
-static void update_and_free_page(struct hstate *h, struct page *page)
+static void __update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
 	struct page *subpage = page;
@@ -1399,12 +1399,79 @@ static void update_and_free_page(struct
 	}
 }
 
+/*
+ * As update_and_free_page() can be called under any context, so we cannot
+ * use GFP_KERNEL to allocate vmemmap pages. However, we can defer the
+ * actual freeing in a workqueue to prevent from using GFP_ATOMIC to allocate
+ * the vmemmap pages.
+ *
+ * free_hpage_workfn() locklessly retrieves the linked list of pages to be
+ * freed and frees them one-by-one. As the page->mapping pointer is going
+ * to be cleared in free_hpage_workfn() anyway, it is reused as the llist_node
+ * structure of a lockless linked list of huge pages to be freed.
+ */
+static LLIST_HEAD(hpage_freelist);
+
+static void free_hpage_workfn(struct work_struct *work)
+{
+	struct llist_node *node;
+
+	node = llist_del_all(&hpage_freelist);
+
+	while (node) {
+		struct page *page;
+		struct hstate *h;
+
+		page = container_of((struct address_space **)node,
+				     struct page, mapping);
+		node = node->next;
+		page->mapping = NULL;
+		/*
+		 * The VM_BUG_ON_PAGE(!PageHuge(page), page) in page_hstate()
+		 * is going to trigger because a previous call to
+		 * remove_hugetlb_page() will set_compound_page_dtor(page,
+		 * NULL_COMPOUND_DTOR), so do not use page_hstate() directly.
+		 */
+		h = size_to_hstate(page_size(page));
+
+		__update_and_free_page(h, page);
+
+		cond_resched();
+	}
+}
+static DECLARE_WORK(free_hpage_work, free_hpage_workfn);
+
+static inline void flush_free_hpage_work(struct hstate *h)
+{
+	if (free_vmemmap_pages_per_hpage(h))
+		flush_work(&free_hpage_work);
+}
+
+static void update_and_free_page(struct hstate *h, struct page *page,
+				 bool atomic)
+{
+	if (!free_vmemmap_pages_per_hpage(h) || !atomic) {
+		__update_and_free_page(h, page);
+		return;
+	}
+
+	/*
+	 * Defer freeing to avoid using GFP_ATOMIC to allocate vmemmap pages.
+	 *
+	 * Only call schedule_work() if hpage_freelist is previously
+	 * empty. Otherwise, schedule_work() had been called but the workfn
+	 * hasn't retrieved the list yet.
+	 */
+	if (llist_add((struct llist_node *)&page->mapping, &hpage_freelist))
+		schedule_work(&free_hpage_work);
+}
+
 static void update_and_free_pages_bulk(struct hstate *h, struct list_head *list)
 {
 	struct page *page, *t_page;
 
 	list_for_each_entry_safe(page, t_page, list, lru) {
-		update_and_free_page(h, page);
+		update_and_free_page(h, page, false);
 		cond_resched();
 	}
 }
@@ -1471,12 +1538,12 @@ void free_huge_page(struct page *page)
 	if (HPageTemporary(page)) {
 		remove_hugetlb_page(h, page, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_page(h, page);
+		update_and_free_page(h, page, true);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		remove_hugetlb_page(h, page, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_page(h, page);
+		update_and_free_page(h, page, true);
 	} else {
 		arch_clear_hugepage_flags(page);
 		enqueue_huge_page(h, page);
@@ -1795,7 +1862,7 @@ retry:
 		remove_hugetlb_page(h, head, false);
 		h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
-		update_and_free_page(h, head);
+		update_and_free_page(h, head, false);
 		return 0;
 	}
 out:
@@ -2411,14 +2478,14 @@ retry:
 		 * Pages have been replaced, we can safely free the old one.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		update_and_free_page(h, old_page);
+		update_and_free_page(h, old_page, false);
 	}
 
 	return ret;
 
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
-	update_and_free_page(h, new_page);
+	update_and_free_page(h, new_page, false);
 
 	return ret;
 }
@@ -2832,6 +2899,7 @@ static int set_max_huge_pages(struct hst
 	 * pages in hstate via the proc/sysfs interfaces.
 	 */
 	mutex_lock(&h->resize_lock);
+	flush_free_hpage_work(h);
 	spin_lock_irq(&hugetlb_lock);
 
 	/*
@@ -2941,6 +3009,7 @@ static int set_max_huge_pages(struct hst
 	/* free the pages after dropping lock */
 	spin_unlock_irq(&hugetlb_lock);
 	update_and_free_pages_bulk(h, &page_list);
+	flush_free_hpage_work(h);
 	spin_lock_irq(&hugetlb_lock);
 
 	while (count < persistent_huge_pages(h)) {
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-defer-freeing-of-hugetlb-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -180,18 +180,6 @@
 #define RESERVE_VMEMMAP_NR		2U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
-/*
- * How many vmemmap pages associated with a HugeTLB page that can be freed
- * to the buddy allocator.
- *
- * Todo: Returns zero for now, which means the feature is disabled. We will
- * enable it once all the infrastructure is there.
- */
-static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
-{
-	return 0;
-}
-
 static inline unsigned long free_vmemmap_pages_size_per_hpage(struct hstate *h)
 {
 	return (unsigned long)free_vmemmap_pages_per_hpage(h) << PAGE_SHIFT;
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-defer-freeing-of-hugetlb-pages
+++ a/mm/hugetlb_vmemmap.h
@@ -12,9 +12,26 @@
 
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
 void free_huge_page_vmemmap(struct hstate *h, struct page *head);
+
+/*
+ * How many vmemmap pages associated with a HugeTLB page that can be freed
+ * to the buddy allocator.
+ *
+ * Todo: Returns zero for now, which means the feature is disabled. We will
+ * enable it once all the infrastructure is there.
+ */
+static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
+{
+	return 0;
+}
 #else
 static inline void free_huge_page_vmemmap(struct hstate *h, struct page *head)
 {
 }
+
+static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
+{
+	return 0;
+}
 #endif /* CONFIG_HUGETLB_PAGE_FREE_VMEMMAP */
 #endif /* _LINUX_HUGETLB_VMEMMAP_H */
_
