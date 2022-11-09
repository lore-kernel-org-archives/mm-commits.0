Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07588C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiKIBlz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiKIBkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2804B68294
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B09EDB81CD9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DE2C433D6;
        Wed,  9 Nov 2022 01:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957970;
        bh=w+V7gp+hAHD0yTwhrEs4igoLJQOt2yYJhTN5R0vfvUE=;
        h=Date:To:From:Subject:From;
        b=2FPbd9fOCfNMRh/F0kQ5aNeC6gVM4nCgsionDM02fbNKabRGlAZhDs6woggcz6ym1
         EvfsUkyVAll9a2S21p4GAS9NVAyhazdR81Igatz9Q5M5MpZBhUv1BAefJ4mOrQReYn
         YJ0DMxBj1HUNEK9kOUrrGZymrnOwFHb+XNGQ0fD0=
Date:   Tue, 08 Nov 2022 17:39:29 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch removed from -mm tree
Message-Id: <20221109013930.57DE2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm,hwpoison,hugetlb,memory_hotplug: hotremove memory section with hwpoisoned hugepage
has been removed from the -mm tree.  Its filename was
     mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[naoya.horiguchi@linux.dev: remove TestClearHPageMigratable and reduce to test and clear separately]
  Link: https://lkml.kernel.org/r/20221025053559.GA2104800@ik1-406-35019.vs.sakura.ne.jp
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

 include/linux/hugetlb.h |   10 ++++++----
 include/linux/mm.h      |    6 ++++--
 mm/hugetlb.c            |    9 +++++----
 mm/memory-failure.c     |   21 +++++++++++++++++----
 4 files changed, 32 insertions(+), 14 deletions(-)

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
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
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
--- a/include/linux/mm.h~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage
+++ a/include/linux/mm.h
@@ -3277,9 +3277,11 @@ extern void shake_page(struct page *p);
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
@@ -7265,7 +7265,7 @@ unlock:
 	return ret;
 }
 
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
 {
 	int ret = 0;
 
@@ -7275,7 +7275,7 @@ int get_hwpoison_huge_page(struct page *
 		*hugetlb = true;
 		if (HPageFreed(page))
 			ret = 0;
-		else if (HPageMigratable(page))
+		else if (HPageMigratable(page) || unpoison)
 			ret = get_page_unless_zero(page);
 		else
 			ret = -EBUSY;
@@ -7284,12 +7284,13 @@ int get_hwpoison_huge_page(struct page *
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
@@ -1244,7 +1244,7 @@ static int __get_hwpoison_page(struct pa
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb);
+	ret = get_hwpoison_huge_page(head, &hugetlb, false);
 	if (hugetlb)
 		return ret;
 
@@ -1334,7 +1334,7 @@ static int __get_unpoison_page(struct pa
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb);
+	ret = get_hwpoison_huge_page(head, &hugetlb, true);
 	if (hugetlb)
 		return ret;
 
@@ -1785,7 +1785,8 @@ void hugetlb_clear_page_hwpoison(struct
  *   -EBUSY        - the hugepage is busy (try to retry)
  *   -EHWPOISON    - the hugepage is already hwpoisoned
  */
-int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
 	struct page *head = compound_head(page);
@@ -1815,6 +1816,15 @@ int __get_huge_page_for_hwpoison(unsigne
 		goto out;
 	}
 
+	/*
+	 * Clearing HPageMigratable for hwpoisoned hugepages to prevent them
+	 * from being migrated by memory hotremove.
+	 */
+	if (count_increased && HPageMigratable(head)) {
+		ClearHPageMigratable(head);
+		*migratable_cleared = true;
+	}
+
 	return ret;
 out:
 	if (count_increased)
@@ -1834,10 +1844,11 @@ static int try_memory_failure_hugetlb(un
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
@@ -1861,6 +1872,8 @@ retry:
 
 	if (hwpoison_filter(p)) {
 		hugetlb_clear_page_hwpoison(head);
+		if (migratable_cleared)
+			SetHPageMigratable(head);
 		unlock_page(head);
 		if (res == 1)
 			put_page(head);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


