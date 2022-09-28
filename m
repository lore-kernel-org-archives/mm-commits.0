Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19078C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 14:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiI1OmS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiI1OmR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 10:42:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33C0AE239
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 07:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 321EDB820EA
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 14:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7456C433C1;
        Wed, 28 Sep 2022 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664376133;
        bh=G2CYPDwCdfK+xBh6NGrsNVjwDrKOwkLsjHW1VwU471w=;
        h=Date:To:From:Subject:From;
        b=Rd2HH4cW+fHkrImZ/MBm7QbYQfQV1ibj80wNLhZME/xl31EjeMU2d74L5KLQTVQp3
         G0A/jiO7W9mS/OSfhj/enEj2lXv1olNPtBIRD52S8lWMgN2CNY08nQ3rkc6/7WKimS
         nU5oguIREDW8q4ASj0Gjcf8SXGJZWpfvtfhzdbPE=
Date:   Wed, 28 Sep 2022 07:42:06 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch removed from -mm tree
Message-Id: <20220928144213.A7456C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: move definitions of num_poisoned_pages_* to memory-failure.c
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: move definitions of num_poisoned_pages_* to memory-failure.c
Date: Wed, 21 Sep 2022 18:13:57 +0900

These interfaces will be used by drivers/base/core.c by later patch, so as
a preparatory work move them to more common header file visible to the
file.

Link: https://lkml.kernel.org/r/20220921091359.25889-3-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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
@@ -3279,11 +3279,16 @@ extern atomic_long_t num_poisoned_pages
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags);
+extern void num_poisoned_pages_inc(void);
 #else
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
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
 
+static inline void num_poisoned_pages_inc(void)
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

mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

