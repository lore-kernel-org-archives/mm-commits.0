Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52A2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiEJER1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbiEJEQa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B108123AE47
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4666761743
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BA4C385C5;
        Tue, 10 May 2022 04:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155926;
        bh=0gpvL/QqxbUmwWnQWQbNj5UzUVqLbbWQ0dPvmUc+Sng=;
        h=Date:To:From:Subject:From;
        b=q0wS0dFi0V9WYUkQvU5Dnrk1Ca4pF2TwRQ58xbeAbZwBFHlVobGCqup6L3g+HEqZW
         mUFRjcVtM5NFuXNUNmLeSK+3v28p49TwfjtV5QlOu9QPMXWZYzGbnRs6RSklTSal64
         iVBbHq0mBUNnNSRL9b4elIuaymonUp6tNRbwXJG0=
Date:   Mon, 09 May 2022 21:12:06 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch removed from -mm tree
Message-Id: <20220510041206.A0BA4C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: cleanup hugetlb_free_vmemmap_enabled*
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch

This patch was dropped because it was merged into mm-stable

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
@@ -86,7 +86,7 @@ void flush_dcache_page(struct page *page
 	 * is reused (more details can refer to the comments above
 	 * page_fixed_fake_head()).
 	 */
-	if (hugetlb_free_vmemmap_enabled() && PageHuge(page))
+	if (hugetlb_optimize_vmemmap_enabled() && PageHuge(page))
 		page = compound_head(page);
 
 	if (test_bit(PG_dcache_clean, &page->flags))
--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled
+++ a/include/linux/page-flags.h
@@ -192,16 +192,16 @@ enum pageflags {
 
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
@@ -218,7 +218,7 @@ static __always_inline bool hugetlb_free
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
-	if (!hugetlb_free_vmemmap_enabled())
+	if (!hugetlb_optimize_vmemmap_enabled())
 		return page;
 
 	/*
@@ -247,7 +247,7 @@ static inline const struct page *page_fi
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

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

