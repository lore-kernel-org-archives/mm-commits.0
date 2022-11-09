Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C13C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiKIBl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKIBkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699CD68297
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BB1AB81CC7
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9F4C433D7;
        Wed,  9 Nov 2022 01:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957973;
        bh=r+GHDGKoLpXG25SOcSSZUu1ZxaEOeWb4b6R5e7PSZP8=;
        h=Date:To:From:Subject:From;
        b=BBNUJ1x47KgSBEusTaodU9VijLfVdE+bphgsoHvwmSor7Q3vG5bZjyB5oTzZ7iIiw
         iIOzRNFwp9+9xcXCxXfoxRrb1N22ytWckdvE3VoWfI2RQup7kLhVwojtEcNR3NMfAB
         gyNa8IOk2U9fyCei3BwWiu/xCIrkP5wE8Yc8vtBY=
Date:   Tue, 08 Nov 2022 17:39:33 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch removed from -mm tree
Message-Id: <20221109013933.CB9F4C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: pass pfn to num_poisoned_pages_*()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: pass pfn to num_poisoned_pages_*()
Date: Mon, 24 Oct 2022 15:20:11 +0900

No functional change.

Link: https://lkml.kernel.org/r/20221024062012.1520887-4-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/pdt.c |    2 +-
 include/linux/mm.h       |    4 ++--
 mm/memory-failure.c      |   14 +++++++-------
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/parisc/kernel/pdt.c~mm-hwpoison-pass-pfn-to-num_poisoned_pages_
+++ a/arch/parisc/kernel/pdt.c
@@ -231,7 +231,7 @@ void __init pdc_pdt_init(void)
 
 		/* mark memory page bad */
 		memblock_reserve(pdt_entry[i] & PAGE_MASK, PAGE_SIZE);
-		num_poisoned_pages_inc();
+		num_poisoned_pages_inc(addr >> PAGE_SHIFT);
 	}
 }
 
--- a/include/linux/mm.h~mm-hwpoison-pass-pfn-to-num_poisoned_pages_
+++ a/include/linux/mm.h
@@ -3279,7 +3279,7 @@ extern int soft_offline_page(unsigned lo
 #ifdef CONFIG_MEMORY_FAILURE
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared);
-extern void num_poisoned_pages_inc(void);
+extern void num_poisoned_pages_inc(unsigned long pfn);
 #else
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared)
@@ -3287,7 +3287,7 @@ static inline int __get_huge_page_for_hw
 	return 0;
 }
 
-static inline void num_poisoned_pages_inc(void)
+static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
 #endif
--- a/mm/memory-failure.c~mm-hwpoison-pass-pfn-to-num_poisoned_pages_
+++ a/mm/memory-failure.c
@@ -74,12 +74,12 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool hw_memory_failure __read_mostly = false;
 
-inline void num_poisoned_pages_inc(void)
+inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 	atomic_long_inc(&num_poisoned_pages);
 }
 
-static inline void num_poisoned_pages_sub(long i)
+static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 	atomic_long_sub(i, &num_poisoned_pages);
 }
@@ -125,7 +125,7 @@ static bool page_handle_poison(struct pa
 	if (release)
 		put_page(page);
 	page_ref_inc(page);
-	num_poisoned_pages_inc();
+	num_poisoned_pages_inc(page_to_pfn(page));
 
 	return true;
 }
@@ -1194,7 +1194,7 @@ static int action_result(unsigned long p
 {
 	trace_memory_failure_event(pfn, type, result);
 
-	num_poisoned_pages_inc();
+	num_poisoned_pages_inc(pfn);
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
@@ -1741,7 +1741,7 @@ static int hugetlb_set_page_hwpoison(str
 		llist_add(&raw_hwp->node, head);
 		/* the first error event will be counted in action_result(). */
 		if (ret)
-			num_poisoned_pages_inc();
+			num_poisoned_pages_inc(page_to_pfn(page));
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -2414,7 +2414,7 @@ int unpoison_memory(unsigned long pfn)
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
 	if (!ret || freeit) {
-		num_poisoned_pages_sub(count);
+		num_poisoned_pages_sub(pfn, count);
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 page_to_pfn(p), &unpoison_rs);
 	}
@@ -2630,5 +2630,5 @@ void clear_hwpoisoned_pages(struct page
 		}
 	}
 	if (total)
-		num_poisoned_pages_sub(total);
+		num_poisoned_pages_sub(0, total);
 }
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


