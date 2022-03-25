Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD489C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353788AbiCYBe1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357596AbiCYBdb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5759A3DA66
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D426460A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371FFC340EC;
        Fri, 25 Mar 2022 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171917;
        bh=Mlvw2z8wrY3I4Y8PaS3GcFCioR8cG3WyDREzcdtl8as=;
        h=Date:To:From:Subject:From;
        b=1A5+7VkGpihjoVpstwyB0T18leg4EV0uCcofGM8CgKgfYXxVlzfgS0QOx5o3FIPlZ
         SUSKn+pPQ+Y8unRi1CyydwPuE5PzjqioCiC0ZpSBGILuoCIzB5AVd46uq3i3773ugm
         rwEsNuyk1GqqsXSgGxWIbZwkp98xqwTowhlXBqzA=
Date:   Thu, 24 Mar 2022 18:31:56 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, song.bao.hua@hisilicon.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mhocko@suse.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com, corbet@lwn.net,
        chenhuang5@huawei.com, bodeddub@amazon.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch removed from -mm tree
Message-Id: <20220325013157.371FFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key

The page_fixed_fake_head() is used throughout memory management and the
conditional check requires checking a global variable, although the
overhead of this check may be small, it increases when the memory cache
comes under pressure.  Also, the global variable will not be modified
after system boot, so it is very appropriate to use static key machanism.

Link: https://lkml.kernel.org/r/20211101031651.75851-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    6 ------
 include/linux/page-flags.h |   16 ++++++++++++++--
 mm/hugetlb_vmemmap.c       |   12 ++++++------
 mm/memory_hotplug.c        |    2 +-
 4 files changed, 21 insertions(+), 15 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key
+++ a/include/linux/hugetlb.h
@@ -1075,12 +1075,6 @@ static inline void set_huge_swap_pte_at(
 }
 #endif	/* CONFIG_HUGETLB_PAGE */
 
-#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
-extern bool hugetlb_free_vmemmap_enabled;
-#else
-#define hugetlb_free_vmemmap_enabled	false
-#endif
-
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
 					struct mm_struct *mm, pte_t *pte)
 {
--- a/include/linux/page-flags.h~mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key
+++ a/include/linux/page-flags.h
@@ -191,7 +191,14 @@ enum pageflags {
 #ifndef __GENERATING_BOUNDS_H
 
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
-extern bool hugetlb_free_vmemmap_enabled;
+DECLARE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
+			 hugetlb_free_vmemmap_enabled_key);
+
+static __always_inline bool hugetlb_free_vmemmap_enabled(void)
+{
+	return static_branch_maybe(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
+				   &hugetlb_free_vmemmap_enabled_key);
+}
 
 /*
  * If the feature of freeing some vmemmap pages associated with each HugeTLB
@@ -211,7 +218,7 @@ extern bool hugetlb_free_vmemmap_enabled
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
-	if (!hugetlb_free_vmemmap_enabled)
+	if (!hugetlb_free_vmemmap_enabled())
 		return page;
 
 	/*
@@ -239,6 +246,11 @@ static inline const struct page *page_fi
 {
 	return page;
 }
+
+static inline bool hugetlb_free_vmemmap_enabled(void)
+{
+	return false;
+}
 #endif
 
 static __always_inline int page_is_fake_head(struct page *page)
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key
+++ a/mm/hugetlb_vmemmap.c
@@ -188,9 +188,9 @@
 #define RESERVE_VMEMMAP_NR		1U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
-bool hugetlb_free_vmemmap_enabled __read_mostly =
-	IS_ENABLED(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON);
-EXPORT_SYMBOL(hugetlb_free_vmemmap_enabled);
+DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
+			hugetlb_free_vmemmap_enabled_key);
+EXPORT_SYMBOL(hugetlb_free_vmemmap_enabled_key);
 
 static int __init early_hugetlb_free_vmemmap_param(char *buf)
 {
@@ -204,9 +204,9 @@ static int __init early_hugetlb_free_vme
 		return -EINVAL;
 
 	if (!strcmp(buf, "on"))
-		hugetlb_free_vmemmap_enabled = true;
+		static_branch_enable(&hugetlb_free_vmemmap_enabled_key);
 	else if (!strcmp(buf, "off"))
-		hugetlb_free_vmemmap_enabled = false;
+		static_branch_disable(&hugetlb_free_vmemmap_enabled_key);
 	else
 		return -EINVAL;
 
@@ -284,7 +284,7 @@ void __init hugetlb_vmemmap_init(struct
 	BUILD_BUG_ON(__NR_USED_SUBPAGE >=
 		     RESERVE_VMEMMAP_SIZE / sizeof(struct page));
 
-	if (!hugetlb_free_vmemmap_enabled)
+	if (!hugetlb_free_vmemmap_enabled())
 		return;
 
 	vmemmap_pages = (nr_pages * sizeof(struct page)) >> PAGE_SHIFT;
--- a/mm/memory_hotplug.c~mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key
+++ a/mm/memory_hotplug.c
@@ -1327,7 +1327,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	 *       populate a single PMD.
 	 */
 	return memmap_on_memory &&
-	       !hugetlb_free_vmemmap_enabled &&
+	       !hugetlb_free_vmemmap_enabled() &&
 	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
 	       size == memory_block_size_bytes() &&
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


