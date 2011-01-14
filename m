From: akpm@linux-foundation.org
Subject: [merged] thp-compound_trans_order.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:41 -0800
Message-ID: <201101142251.p0EMpVuS005516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1ANWvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     thp: compound_trans_order
has been removed from the -mm tree.  Its filename was
     thp-compound_trans_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: compound_trans_order
From: Andrea Arcangeli <aarcange@redhat.com>

Read compound_trans_order safe. Noop for CONFIG_TRANSPARENT_HUGEPAGE=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   14 ++++++++++++++
 mm/memcontrol.c     |   12 ++++++------
 mm/memory-failure.c |   12 ++++++------
 3 files changed, 26 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~thp-compound_trans_order include/linux/mm.h
--- a/include/linux/mm.h~thp-compound_trans_order
+++ a/include/linux/mm.h
@@ -450,6 +450,20 @@ static inline int compound_order(struct 
 	return (unsigned long)page[1].lru.prev;
 }
 
+static inline int compound_trans_order(struct page *page)
+{
+	int order;
+	unsigned long flags;
+
+	if (!PageHead(page))
+		return 0;
+
+	flags = compound_lock_irqsave(page);
+	order = compound_order(page);
+	compound_unlock_irqrestore(page, flags);
+	return order;
+}
+
 static inline void set_compound_order(struct page *page, unsigned long order)
 {
 	page[1].lru.prev = (void *)order;
diff -puN mm/memcontrol.c~thp-compound_trans_order mm/memcontrol.c
--- a/mm/memcontrol.c~thp-compound_trans_order
+++ a/mm/memcontrol.c
@@ -1027,10 +1027,6 @@ mem_cgroup_get_reclaim_stat_from_page(st
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
-	int page_size = PAGE_SIZE;
-
-	if (PageTransHuge(page))
-		page_size <<= compound_order(page);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2286,8 +2282,10 @@ static int mem_cgroup_charge_common(stru
 	int ret;
 	int page_size = PAGE_SIZE;
 
-	if (PageTransHuge(page))
+	if (PageTransHuge(page)) {
 		page_size <<= compound_order(page);
+		VM_BUG_ON(!PageTransHuge(page));
+	}
 
 	pc = lookup_page_cgroup(page);
 	/* can happen at boot */
@@ -2558,8 +2556,10 @@ __mem_cgroup_uncharge_common(struct page
 	if (PageSwapCache(page))
 		return NULL;
 
-	if (PageTransHuge(page))
+	if (PageTransHuge(page)) {
 		page_size <<= compound_order(page);
+		VM_BUG_ON(!PageTransHuge(page));
+	}
 
 	count = page_size >> PAGE_SHIFT;
 	/*
diff -puN mm/memory-failure.c~thp-compound_trans_order mm/memory-failure.c
--- a/mm/memory-failure.c~thp-compound_trans_order
+++ a/mm/memory-failure.c
@@ -203,7 +203,7 @@ static int kill_proc_ao(struct task_stru
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
-	si.si_addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
+	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
 	/*
 	 * Don't use force here, it's convenient if the signal
 	 * can be temporarily blocked.
@@ -930,7 +930,7 @@ static int hwpoison_user_mappings(struct
 static void set_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_order(hpage);
+	int nr_pages = 1 << compound_trans_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		SetPageHWPoison(hpage + i);
 }
@@ -938,7 +938,7 @@ static void set_page_hwpoison_huge_page(
 static void clear_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_order(hpage);
+	int nr_pages = 1 << compound_trans_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		ClearPageHWPoison(hpage + i);
 }
@@ -968,7 +968,7 @@ int __memory_failure(unsigned long pfn, 
 		return 0;
 	}
 
-	nr_pages = 1 << compound_order(hpage);
+	nr_pages = 1 << compound_trans_order(hpage);
 	atomic_long_add(nr_pages, &mce_bad_pages);
 
 	/*
@@ -1166,7 +1166,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_order(page);
+	nr_pages = 1 << compound_trans_order(page);
 
 	if (!get_page_unless_zero(page)) {
 		/*
@@ -1304,7 +1304,7 @@ static int soft_offline_huge_page(struct
 	}
 done:
 	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_order(hpage), &mce_bad_pages);
+		atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
 	/* keep elevated page count for bad page */
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

