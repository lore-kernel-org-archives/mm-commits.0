From: akpm@linux-foundation.org
Subject: [to-be-updated] hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch removed from -mm tree
Date: Fri, 07 Dec 2012 14:27:39 -0800
Message-ID: <20121207222740.C1E3520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:52040 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2LGW1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 17:27:43 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so61128wey.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 14:27:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison, hugetlbfs: fix warning on freeing hwpoisoned hugepage
has been removed from the -mm tree.  Its filename was
     hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hwpoison, hugetlbfs: fix warning on freeing hwpoisoned hugepage

Fix the warning from __list_del_entry() which is triggered when a process
tries to do free_huge_page() for a hwpoisoned hugepage.

Originally, page->lru of hugetlbfs head page was dangling when the
hugepage was in use.  This behavior has changed by commit 0edaecfab218d7
("hugetlb: add a list for tracking in-use HugeTLB pages"), where hugepages
in use are linked to hugepage_activelist.  HWpoisoned hugepages should not
be charged to any process, so we introduce another list to link hwpoisoned
hugepages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage
+++ a/include/linux/hugetlb.h
@@ -237,6 +237,9 @@ struct hstate {
 	unsigned long nr_overcommit_huge_pages;
 	struct list_head hugepage_activelist;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
+#ifdef CONFIG_MEMORY_FAILURE
+	struct list_head hugepage_hwpoisonedlist;
+#endif
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
diff -puN mm/hugetlb.c~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage
+++ a/mm/hugetlb.c
@@ -1939,6 +1939,7 @@ void __init hugetlb_add_hstate(unsigned 
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
+	INIT_LIST_HEAD(&h->hugepage_hwpoisonedlist);
 	h->next_nid_to_alloc = first_node(node_states[N_MEMORY]);
 	h->next_nid_to_free = first_node(node_states[N_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
@@ -3176,7 +3177,7 @@ int dequeue_hwpoisoned_huge_page(struct 
 
 	spin_lock(&hugetlb_lock);
 	if (is_hugepage_on_freelist(hpage)) {
-		list_del(&hpage->lru);
+		list_move(&hpage->lru, &h->hugepage_hwpoisonedlist);
 		set_page_refcounted(hpage);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch

