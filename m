Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97771C38A2D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 23:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJXXGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJXXGV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 19:06:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEC7DFBF
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 14:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F7BEB81154
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 21:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DDEC433D6;
        Mon, 24 Oct 2022 21:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666646771;
        bh=WfRedxsVTevfxnzXX0ydR6cx+yfrhYbM7uIWHOxc4WQ=;
        h=Date:To:From:Subject:From;
        b=nk35YOudpjj0qp9DWSMWS5ZHsK00P4iHMwFp6Or9xcvhDCUYn+BfEsJJF/WO1Pokx
         JL8B6L9eJTuLpdm7xEXLbMCVovebw8Z9q2BOaKYO3kNPw1cXJIPyC368rzKh41HWkF
         d+Iy3rdOl1ZqAItH15U1RMLJ6B6SEDHzczD21AXc=
Date:   Mon, 24 Oct 2022 14:26:10 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch added to mm-unstable branch
Message-Id: <20221024212610.E3DDEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison,hugetlb,memory_hotplug: hotremove memory section with hwpoisoned hugepage
has been added to the -mm mm-unstable branch.  Its filename is
     mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison,hugetlb,memory_hotplug: hotremove memory section with hwpoisoned hugepage
Date: Mon, 24 Oct 2022 15:20:09 +0900

Patch series "mm, hwpoison: improve handling workload related to hugetlb
and memory_hotplug", v7.

This patchset tries to solve the issue among memory_hotplug, hugetlb and hwpoison.
In this patchset, memory hotplug handles hwpoison pages like below:

  - hwpoison pages should not prevent memory hotremove,
  - memory block with hwpoison pages should not be onlined.


This patch (of 4):

HWPoisoned page is not supposed to be accessed once marked, but currently
such accesses can happen during memory hotremove because
do_migrate_range() can be called before dissolve_free_huge_pages() is
called.

Clear HPageMigratable for hwpoisoned hugepages to prevent them from being
migrated.  This should be done in hugetlb_lock to avoid race against
isolate_hugetlb().

get_hwpoison_huge_page() needs to have a flag to show it's called from
unpoison to take refcount of hwpoisoned hugepages, so add it.

Link: https://lkml.kernel.org/r/20221024062012.1520887-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20221024062012.1520887-2-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   19 +++++++++++++++----
 include/linux/mm.h      |    6 ++++--
 mm/hugetlb.c            |    9 +++++----
 mm/memory-failure.c     |   19 +++++++++++++++----
 4 files changed, 39 insertions(+), 14 deletions(-)

--- a/include/linux/hugetlb.h~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage
+++ a/include/linux/hugetlb.h
@@ -183,8 +183,9 @@ bool hugetlb_reserve_pages(struct inode
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 int isolate_hugetlb(struct page *page, struct list_head *list);
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison);
+int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+				bool *migratable_cleared);
 void putback_active_hugepage(struct page *page);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void free_huge_page(struct page *page);
@@ -391,12 +392,13 @@ static inline int isolate_hugetlb(struct
 	return -EBUSY;
 }
 
-static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
+static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
 {
 	return 0;
 }
 
-static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+					bool *migratable_cleared)
 {
 	return 0;
 }
@@ -614,6 +616,10 @@ void folio_clear_hugetlb_##flname(struct
 	}							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ clear_bit(HPG_##flname, &(page->private)); }
+
+#define TESTCLEARHPAGEFLAG(uname, flname)			\
+static inline int TestClearHPage##uname(struct page *page)	\
+	{ return test_and_clear_bit(HPG_##flname, &(page->private)); }
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
@@ -635,6 +641,10 @@ folio_clear_hugetlb_##flname(struct foli
 	{ }							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ }
+
+#define TESTCLEARHPAGEFLAG(uname, flname)			\
+static inline int TestClearHPage##uname(struct page *page)	\
+	{ return 0; }
 #endif
 
 #define HPAGEFLAG(uname, flname)				\
@@ -647,6 +657,7 @@ static inline void ClearHPage##uname(str
  */
 HPAGEFLAG(RestoreReserve, restore_reserve)
 HPAGEFLAG(Migratable, migratable)
+	TESTCLEARHPAGEFLAG(Migratable, migratable)
 HPAGEFLAG(Temporary, temporary)
 HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
--- a/include/linux/mm.h~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage
+++ a/include/linux/mm.h
@@ -3246,9 +3246,11 @@ extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
-extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags);
+extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+					bool *migratable_cleared);
 #else
-static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+					bool *migratable_cleared)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage
+++ a/mm/hugetlb.c
@@ -7288,7 +7288,7 @@ unlock:
 	return ret;
 }
 
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
 {
 	int ret = 0;
 
@@ -7298,7 +7298,7 @@ int get_hwpoison_huge_page(struct page *
 		*hugetlb = true;
 		if (HPageFreed(page))
 			ret = 0;
-		else if (HPageMigratable(page))
+		else if (HPageMigratable(page) || unpoison)
 			ret = get_page_unless_zero(page);
 		else
 			ret = -EBUSY;
@@ -7307,12 +7307,13 @@ int get_hwpoison_huge_page(struct page *
 	return ret;
 }
 
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+				bool *migratable_cleared)
 {
 	int ret;
 
 	spin_lock_irq(&hugetlb_lock);
-	ret = __get_huge_page_for_hwpoison(pfn, flags);
+	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
 }
--- a/mm/memory-failure.c~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage
+++ a/mm/memory-failure.c
@@ -1249,7 +1249,7 @@ static int __get_hwpoison_page(struct pa
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb);
+	ret = get_hwpoison_huge_page(head, &hugetlb, false);
 	if (hugetlb)
 		return ret;
 
@@ -1339,7 +1339,7 @@ static int __get_unpoison_page(struct pa
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb);
+	ret = get_hwpoison_huge_page(head, &hugetlb, true);
 	if (hugetlb)
 		return ret;
 
@@ -1790,7 +1790,8 @@ void hugetlb_clear_page_hwpoison(struct
  *   -EBUSY        - the hugepage is busy (try to retry)
  *   -EHWPOISON    - the hugepage is already hwpoisoned
  */
-int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
 	struct page *head = compound_head(page);
@@ -1820,6 +1821,13 @@ int __get_huge_page_for_hwpoison(unsigne
 		goto out;
 	}
 
+	/*
+	 * Clearing HPageMigratable for hwpoisoned hugepages to prevent them
+	 * from being migrated by memory hotremove.
+	 */
+	if (count_increased)
+		*migratable_cleared = TestClearHPageMigratable(head);
+
 	return ret;
 out:
 	if (count_increased)
@@ -1839,10 +1847,11 @@ static int try_memory_failure_hugetlb(un
 	struct page *p = pfn_to_page(pfn);
 	struct page *head;
 	unsigned long page_flags;
+	bool migratable_cleared = false;
 
 	*hugetlb = 1;
 retry:
-	res = get_huge_page_for_hwpoison(pfn, flags);
+	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
 	if (res == 2) { /* fallback to normal page handling */
 		*hugetlb = 0;
 		return 0;
@@ -1866,6 +1875,8 @@ retry:
 
 	if (hwpoison_filter(p)) {
 		hugetlb_clear_page_hwpoison(head);
+		if (migratable_cleared)
+			SetHPageMigratable(head);
 		unlock_page(head);
 		if (res == 1)
 			put_page(head);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

