Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1579DC67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 23:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiJXXK7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJXXKg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 19:10:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDC72DAC18
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 14:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70A68B80EE4
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 21:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15645C433C1;
        Mon, 24 Oct 2022 21:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666646774;
        bh=ejAp+GpWYE6JM68jMUFZNehOyvBuph8TOHpWsNBvPxw=;
        h=Date:To:From:Subject:From;
        b=VLNzFSzKoxAZQDWQDDRcqBbsGfSIz5rD4TQ2mEmDtSeLLCN/0BqG+g9P0kn2kzYTb
         Res1PHno0KYZagQkIAr+KLa91rIHY96DoRGoZ7wxvce4oqTrJtwjT5JLYoO6Y2voo9
         R6CU8Wf3V4Cs9TEiubrKUYfhDi6ZBrR6hGNevIQY=
Date:   Mon, 24 Oct 2022 14:26:13 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch added to mm-unstable branch
Message-Id: <20221024212614.15645C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: move definitions of num_poisoned_pages_* to memory-failure.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch

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
Subject: mm/hwpoison: move definitions of num_poisoned_pages_* to memory-failure.c
Date: Mon, 24 Oct 2022 15:20:10 +0900

These interfaces will be used by drivers/base/memory.c by later patch, so
as a preparatory work move them to more common header file visible to the
file.

Link: https://lkml.kernel.org/r/20221024062012.1520887-3-naoya.horiguchi@linux.dev
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

 arch/parisc/kernel/pdt.c |    3 +--
 include/linux/mm.h       |    5 +++++
 include/linux/swapops.h  |   24 ++----------------------
 mm/memory-failure.c      |   10 ++++++++++
 4 files changed, 18 insertions(+), 24 deletions(-)

--- a/arch/parisc/kernel/pdt.c~mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec
+++ a/arch/parisc/kernel/pdt.c
@@ -18,8 +18,7 @@
 #include <linux/kthread.h>
 #include <linux/initrd.h>
 #include <linux/pgtable.h>
-#include <linux/swap.h>
-#include <linux/swapops.h>
+#include <linux/mm.h>
 
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
--- a/include/linux/mm.h~mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec
+++ a/include/linux/mm.h
@@ -3248,12 +3248,17 @@ extern int soft_offline_page(unsigned lo
 #ifdef CONFIG_MEMORY_FAILURE
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared);
+extern void num_poisoned_pages_inc(void);
 #else
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared)
 {
 	return 0;
 }
+
+static inline void num_poisoned_pages_inc(void)
+{
+}
 #endif
 
 #ifndef arch_memory_failure
--- a/include/linux/swapops.h~mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec
+++ a/include/linux/swapops.h
@@ -581,8 +581,6 @@ static inline int is_pmd_migration_entry
 
 #ifdef CONFIG_MEMORY_FAILURE
 
-extern atomic_long_t num_poisoned_pages __read_mostly;
-
 /*
  * Support for hardware poisoned pages
  */
@@ -597,17 +595,7 @@ static inline int is_hwpoison_entry(swp_
 	return swp_type(entry) == SWP_HWPOISON;
 }
 
-static inline void num_poisoned_pages_inc(void)
-{
-	atomic_long_inc(&num_poisoned_pages);
-}
-
-static inline void num_poisoned_pages_sub(long i)
-{
-	atomic_long_sub(i, &num_poisoned_pages);
-}
-
-#else  /* CONFIG_MEMORY_FAILURE */
+#else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
 {
@@ -618,15 +606,7 @@ static inline int is_hwpoison_entry(swp_
 {
 	return 0;
 }
-
-static inline void num_poisoned_pages_inc(void)
-{
-}
-
-static inline void num_poisoned_pages_sub(long i)
-{
-}
-#endif  /* CONFIG_MEMORY_FAILURE */
+#endif
 
 static inline int non_swap_entry(swp_entry_t entry)
 {
--- a/mm/memory-failure.c~mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec
+++ a/mm/memory-failure.c
@@ -74,6 +74,16 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool hw_memory_failure __read_mostly = false;
 
+inline void num_poisoned_pages_inc(void)
+{
+	atomic_long_inc(&num_poisoned_pages);
+}
+
+static inline void num_poisoned_pages_sub(long i)
+{
+	atomic_long_sub(i, &num_poisoned_pages);
+}
+
 /*
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

