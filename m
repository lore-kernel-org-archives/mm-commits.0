Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8BEC6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 18:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiIUScA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 14:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIUSb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 14:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9939F76C
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 11:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA09F627EA
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 18:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC7AC433D6;
        Wed, 21 Sep 2022 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663785116;
        bh=2PwEG3wgeBu336WfcJJpIfHkAjCpaQ7Ivxxsb6oWx0g=;
        h=Date:To:From:Subject:From;
        b=fHveLyL+3Abl5PJ8OcNg66dedgnKMXyFrmFbxyhUUa4SajrhlxZNVwCsuMX8aFZuU
         N7gQmU9RSaLogCA24TUIF4r6g57qEhVP/rcFgqByCPGEkbelrNPN6KArmOWDaZ3fH1
         259aETGtFG2mWB5SaInDFWGzopny4UzwDBzWBors=
Date:   Wed, 21 Sep 2022 11:31:54 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch added to mm-unstable branch
Message-Id: <20220921183155.DDC7AC433D6@smtp.kernel.org>
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
Date: Wed, 21 Sep 2022 18:13:56 +0900

Patch series " mm, hwpoison: improve handling workload related to hugetlb
and memory_hotplug", v3.

This patchset tries to solve the issue among memory_hotplug, hugetlb and
hwpoison.  Based on the review over v2 by Miaohe (thank you!), 1/4 takes
another approach to prevent hwpoisoned hugepages to be migrated (i.e.
the corrupted data is accessed) in memory hotremove.

In this patchset, memory hotplug handles hwpoison pages like below:

  - hwpoison pages should not prevent memory hotremove,
  - memory block with hwpoison pages should not be onlined.


This patch (of 4):

HWPoisoned page is not supposed to be accessed once marked, but currently
such accesses can happen during memory hotremove because do_migrate_range()
can be called before dissolve_free_huge_pages() is called.

Clear HPageMigratable for hwpoisoned hugepages to prevent them from being
migrated.  This should be done in hugetlb_lock to avoid race against
isolate_hugetlb().

get_hwpoison_huge_page() needs to have a flag to show it's called from
unpoison to take refcount of hwpoisoned hugepages, so add it.

Link: https://lkml.kernel.org/r/20220921091359.25889-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20220921091359.25889-2-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage
+++ a/include/linux/hugetlb.h
@@ -183,7 +183,7 @@ bool hugetlb_reserve_pages(struct inode
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 int isolate_hugetlb(struct page *page, struct list_head *list);
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
@@ -391,7 +391,7 @@ static inline int isolate_hugetlb(struct
 	return -EBUSY;
 }
 
-static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
+static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage
+++ a/mm/hugetlb.c
@@ -7207,7 +7207,7 @@ unlock:
 	return ret;
 }
 
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
 {
 	int ret = 0;
 
@@ -7217,7 +7217,7 @@ int get_hwpoison_huge_page(struct page *
 		*hugetlb = true;
 		if (HPageFreed(page))
 			ret = 0;
-		else if (HPageMigratable(page))
+		else if (HPageMigratable(page) || unpoison)
 			ret = get_page_unless_zero(page);
 		else
 			ret = -EBUSY;
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
 
@@ -1815,6 +1815,13 @@ int __get_huge_page_for_hwpoison(unsigne
 		goto out;
 	}
 
+	/*
+	 * Clearing HPageMigratable for hwpoisoned hugepages to prevent them
+	 * from being migrated by memory hotremove.
+	 */
+	if (count_increased)
+		ClearHPageMigratable(head);
+
 	return ret;
 out:
 	if (count_increased)
@@ -1862,6 +1869,7 @@ retry:
 
 	if (hwpoison_filter(p)) {
 		hugetlb_clear_page_hwpoison(head);
+		SetHPageMigratable(head);
 		unlock_page(head);
 		if (res == 1)
 			put_page(head);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-huge_memory-use-pfn_to_online_page-in-split_huge_pages_all.patch
mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

