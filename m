Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0126BC67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 23:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJXXFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiJXXFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 19:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6FD36DF2
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 14:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB45615B0
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 21:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E54C433D6;
        Mon, 24 Oct 2022 21:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666646777;
        bh=lyCxc1To4oQZvRECwOaxDQnKtsUB25W5g/Tp8YSWUak=;
        h=Date:To:From:Subject:From;
        b=il1b0ORrGM5oNH+Jf5oj7jrVvpUkj5oFvJedNEUOJJ0Fl16XtmVYSFrUlTkEA4Pr1
         qLfig7i8hoIGQFlu/S5yqLMcBWQlvh1DA41B+5dpJw3pAHqu+SM/YmADl7m+46WPwe
         eTrR8WEqxtsNrpQZtdgALfiRpRf/j0WxYoi0mRsE=
Date:   Mon, 24 Oct 2022 14:26:16 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch added to mm-unstable branch
Message-Id: <20221024212617.14E54C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: pass pfn to num_poisoned_pages_*()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch

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
@@ -3248,7 +3248,7 @@ extern int soft_offline_page(unsigned lo
 #ifdef CONFIG_MEMORY_FAILURE
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared);
-extern void num_poisoned_pages_inc(void);
+extern void num_poisoned_pages_inc(unsigned long pfn);
 #else
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared)
@@ -3256,7 +3256,7 @@ static inline int __get_huge_page_for_hw
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
@@ -1197,7 +1197,7 @@ static int action_result(unsigned long p
 {
 	trace_memory_failure_event(pfn, type, result);
 
-	num_poisoned_pages_inc();
+	num_poisoned_pages_inc(pfn);
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
@@ -1746,7 +1746,7 @@ static int hugetlb_set_page_hwpoison(str
 		llist_add(&raw_hwp->node, head);
 		/* the first error event will be counted in action_result(). */
 		if (ret)
-			num_poisoned_pages_inc();
+			num_poisoned_pages_inc(page_to_pfn(page));
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -2418,7 +2418,7 @@ int unpoison_memory(unsigned long pfn)
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
 	if (!ret || freeit) {
-		num_poisoned_pages_sub(count);
+		num_poisoned_pages_sub(pfn, count);
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 page_to_pfn(p), &unpoison_rs);
 	}
@@ -2634,5 +2634,5 @@ void clear_hwpoisoned_pages(struct page
 		}
 	}
 	if (total)
-		num_poisoned_pages_sub(total);
+		num_poisoned_pages_sub(0, total);
 }
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

