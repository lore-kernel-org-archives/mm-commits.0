Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE56BC6FA8B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 18:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiIUScF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 14:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiIUScE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 14:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5347E9F77C
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 11:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC456612E4
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 18:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092F5C433C1;
        Wed, 21 Sep 2022 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663785122;
        bh=oTe6MBLyHmuUgYuED8Cn3q5wz7aanPpLw5jfX8iTdX4=;
        h=Date:To:From:Subject:From;
        b=huCEG2zjtKzmPsQgDXsO6bXXEXyofBquGEDFWv9Q024IxF14E407pKk+qY99GgN4t
         3ebTUgf/4vCxJRK1ahdpA2Zmlw+UU8zOYtznO1ARoL2049BuHbZhQRpX0pWcMlRdwz
         w0ye1Vyk6KhTGcmidvAfBI5KuXoORh0PyEHhM0rQ=
Date:   Wed, 21 Sep 2022 11:32:00 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch added to mm-unstable branch
Message-Id: <20220921183202.092F5C433C1@smtp.kernel.org>
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
Date: Wed, 21 Sep 2022 18:13:58 +0900

No functional change.

Link: https://lkml.kernel.org/r/20220921091359.25889-4-naoya.horiguchi@linux.dev
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
@@ -3279,14 +3279,14 @@ extern atomic_long_t num_poisoned_pages
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags);
-extern void num_poisoned_pages_inc(void);
+extern void num_poisoned_pages_inc(unsigned long pfn);
 #else
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
 {
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
 
-static inline void num_poisoned_pages_inc(void)
+static inline void num_poisoned_pages_inc(unsigned long pfn)
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
@@ -1194,7 +1194,7 @@ static void action_result(unsigned long
 {
 	trace_memory_failure_event(pfn, type, result);
 
-	num_poisoned_pages_inc();
+	num_poisoned_pages_inc(pfn);
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 }
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
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-huge_memory-use-pfn_to_online_page-in-split_huge_pages_all.patch
mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

