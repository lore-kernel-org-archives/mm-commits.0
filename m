Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A21C4321E
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKIBl4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKIBkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD49668295
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97796B81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4010EC433D6;
        Wed,  9 Nov 2022 01:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957972;
        bh=1d90bU8OcVyCmKTUPCf99sMUMjK6CUn53C10AxSEXVI=;
        h=Date:To:From:Subject:From;
        b=jD3K40e+fh7cWkISxNYn7057cx5XgGWiwf6D607779W6MnyFydJx+MBtoHuswkz3T
         h+iwICX76fwURTRJE8LZm4m0mjR122rdUkb14pbxnGCET09YKuUKFCEncd2asE23Ty
         dtzH2AL5tNP++nvDXzLBlNmUzCSjcyBRbHNrA66s=
Date:   Tue, 08 Nov 2022 17:39:31 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch removed from -mm tree
Message-Id: <20221109013932.4010EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: move definitions of num_poisoned_pages_* to memory-failure.c
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3279,12 +3279,17 @@ extern int soft_offline_page(unsigned lo
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


