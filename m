Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CE1C35294
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383146AbiDDVla (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380151AbiDDTFC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 15:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8433F33E02
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 12:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DB61B8191F
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 19:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F7CC340F3;
        Mon,  4 Apr 2022 19:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649098982;
        bh=RIrve2va1ZeJRyTvF/Xjdhj1HIVx2ssb+6DaD+/j+YY=;
        h=Date:To:From:Subject:From;
        b=Wj8k2xw/r8xrCIaOhdC2x9yGNEa+UrbtpU16o9gxTIY+FYgPr2VWRXJHZ8Ng0MNgE
         iPW0gosoEzKWPLDy/j0h8DnS/WhfKspeOq0SGVxWf6xSNfaPxvEqfCoTeHqWVDOI3l
         90fsQuRpJgkyJ2FBlCJU5lgYjHCAniuWjWTqR1yM=
Date:   Mon, 04 Apr 2022 12:03:02 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch added to -mm tree
Message-Id: <20220404190302.D6F7CC340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: cleanup hugetlb_free_vmemmap_enabled*
has been added to the -mm tree.  Its filename is
     mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: cleanup hugetlb_free_vmemmap_enabled*

The word of "free" is not expressive enough to express the feature of
optimizing vmemmap pages associated with each HugeTLB, rename this keywork
to "optimize".  In this patch , cheanup the static key and
hugetlb_free_vmemmap_enabled() to make code more expressive.

Link: https://lkml.kernel.org/r/20220404074652.68024-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/flush.c      |    2 +-
 include/linux/page-flags.h |   12 ++++++------
 mm/hugetlb_vmemmap.c       |   10 +++++-----
 mm/memory_hotplug.c        |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/arm64/mm/flush.c~mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled
+++ a/arch/arm64/mm/flush.c
@@ -85,7 +85,7 @@ void flush_dcache_page(struct page *page
 	 * set since the head vmemmap page frame is reused (more details can
 	 * refer to the comments above page_fixed_fake_head()).
 	 */
-	if (hugetlb_free_vmemmap_enabled() && PageHuge(page))
+	if (hugetlb_optimize_vmemmap_enabled() && PageHuge(page))
 		page = compound_head(page);
 
 	if (test_bit(PG_dcache_clean, &page->flags))
--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled
+++ a/include/linux/page-flags.h
@@ -201,16 +201,16 @@ enum pageflags {
 
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
 DECLARE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
-			 hugetlb_free_vmemmap_enabled_key);
+			 hugetlb_optimize_vmemmap_key);
 
-static __always_inline bool hugetlb_free_vmemmap_enabled(void)
+static __always_inline bool hugetlb_optimize_vmemmap_enabled(void)
 {
 	return static_branch_maybe(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
-				   &hugetlb_free_vmemmap_enabled_key);
+				   &hugetlb_optimize_vmemmap_key);
 }
 
 /*
- * If the feature of freeing some vmemmap pages associated with each HugeTLB
+ * If the feature of optimizing vmemmap pages associated with each HugeTLB
  * page is enabled, the head vmemmap page frame is reused and all of the tail
  * vmemmap addresses map to the head vmemmap page frame (furture details can
  * refer to the figure at the head of the mm/hugetlb_vmemmap.c).  In other
@@ -227,7 +227,7 @@ static __always_inline bool hugetlb_free
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
-	if (!hugetlb_free_vmemmap_enabled())
+	if (!hugetlb_optimize_vmemmap_enabled())
 		return page;
 
 	/*
@@ -256,7 +256,7 @@ static inline const struct page *page_fi
 	return page;
 }
 
-static inline bool hugetlb_free_vmemmap_enabled(void)
+static inline bool hugetlb_optimize_vmemmap_enabled(void)
 {
 	return false;
 }
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled
+++ a/mm/hugetlb_vmemmap.c
@@ -189,8 +189,8 @@
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
-			hugetlb_free_vmemmap_enabled_key);
-EXPORT_SYMBOL(hugetlb_free_vmemmap_enabled_key);
+			hugetlb_optimize_vmemmap_key);
+EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
 static int __init hugetlb_vmemmap_early_param(char *buf)
 {
@@ -204,9 +204,9 @@ static int __init hugetlb_vmemmap_early_
 		return -EINVAL;
 
 	if (!strcmp(buf, "on"))
-		static_branch_enable(&hugetlb_free_vmemmap_enabled_key);
+		static_branch_enable(&hugetlb_optimize_vmemmap_key);
 	else if (!strcmp(buf, "off"))
-		static_branch_disable(&hugetlb_free_vmemmap_enabled_key);
+		static_branch_disable(&hugetlb_optimize_vmemmap_key);
 	else
 		return -EINVAL;
 
@@ -282,7 +282,7 @@ void __init hugetlb_vmemmap_init(struct
 	BUILD_BUG_ON(__NR_USED_SUBPAGE >=
 		     RESERVE_VMEMMAP_SIZE / sizeof(struct page));
 
-	if (!hugetlb_free_vmemmap_enabled())
+	if (!hugetlb_optimize_vmemmap_enabled())
 		return;
 
 	vmemmap_pages = (nr_pages * sizeof(struct page)) >> PAGE_SHIFT;
--- a/mm/memory_hotplug.c~mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled
+++ a/mm/memory_hotplug.c
@@ -1289,7 +1289,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	 *       populate a single PMD.
 	 */
 	return memmap_on_memory &&
-	       !hugetlb_free_vmemmap_enabled() &&
+	       !hugetlb_optimize_vmemmap_enabled() &&
 	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
 	       size == memory_block_size_bytes() &&
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch
arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch
mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap.patch

