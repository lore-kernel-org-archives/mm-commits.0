From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:23 -0700
Message-ID: <523219d3.vXBUz0BZPlxZvqvX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3ILTpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:23 -0700


The patch titled
     Subject: mm/hwpoison: don't need to hold compound lock for hugetlbfs page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: don't need to hold compound lock for hugetlbfs page

compound lock is introduced by commit e9da73d67("thp: compound_lock."), it
is used to serialize put_page against __split_huge_page_refcount().  In
addition, transparent hugepages will be splitted in hwpoison handler and
just one subpage will be poisoned.  There is unnecessary to hold compound
lock for hugetlbfs page.  This patch replace compound_trans_order by
compond_order in the place where the page is hugetlbfs page.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   14 --------------
 mm/memory-failure.c |   12 ++++++------
 2 files changed, 6 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page include/linux/mm.h
--- a/include/linux/mm.h~mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page
+++ a/include/linux/mm.h
@@ -495,20 +495,6 @@ static inline int compound_order(struct
 	return (unsigned long)page[1].lru.prev;
 }
 
-static inline int compound_trans_order(struct page *page)
-{
-	int order;
-	unsigned long flags;
-
-	if (!PageHead(page))
-		return 0;
-
-	flags = compound_lock_irqsave(page);
-	order = compound_order(page);
-	compound_unlock_irqrestore(page, flags);
-	return order;
-}
-
 static inline void set_compound_order(struct page *page, unsigned long order)
 {
 	page[1].lru.prev = (void *)order;
diff -puN mm/memory-failure.c~mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page
+++ a/mm/memory-failure.c
@@ -206,7 +206,7 @@ static int kill_proc(struct task_struct
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
-	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
+	si.si_addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
 
 	if ((flags & MF_ACTION_REQUIRED) && t == current) {
 		si.si_code = BUS_MCEERR_AR;
@@ -983,7 +983,7 @@ static int hwpoison_user_mappings(struct
 static void set_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_trans_order(hpage);
+	int nr_pages = 1 << compound_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		SetPageHWPoison(hpage + i);
 }
@@ -991,7 +991,7 @@ static void set_page_hwpoison_huge_page(
 static void clear_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_trans_order(hpage);
+	int nr_pages = 1 << compound_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		ClearPageHWPoison(hpage + i);
 }
@@ -1342,7 +1342,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_trans_order(page);
+	nr_pages = 1 << compound_order(page);
 
 	if (!get_page_unless_zero(page)) {
 		/*
@@ -1506,7 +1506,7 @@ static int soft_offline_huge_page(struct
 	} else {
 		set_page_hwpoison_huge_page(hpage);
 		dequeue_hwpoisoned_huge_page(hpage);
-		atomic_long_add(1 << compound_trans_order(hpage),
+		atomic_long_add(1 << compound_order(hpage),
 				&num_poisoned_pages);
 	}
 	return ret;
@@ -1566,7 +1566,7 @@ int soft_offline_page(struct page *page,
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			dequeue_hwpoisoned_huge_page(hpage);
-			atomic_long_add(1 << compound_trans_order(hpage),
+			atomic_long_add(1 << compound_order(hpage),
 					&num_poisoned_pages);
 		} else {
 			SetPageHWPoison(page);
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

