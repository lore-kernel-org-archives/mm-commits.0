Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08D6C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiCVVqq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbiCVVqg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D801C5F8E1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FA85B81DB8
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFA1C340EE;
        Tue, 22 Mar 2022 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985503;
        bh=vPONigjaBCfZVM3/BVqTj7wOQmCbFeY346sYpFDejnI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=z2dOorYZQqepQ7OWqyQfMFL0Czmg+Bx0Z5h+nyWcq8zZghYZB1ZKn+i4U+LAYfxBL
         O/Q1+14s55m93Ck8lQ7XUCPpccIA2BFoiAoFJ9r0UFdEBBKIWxMIDDQ3naWBr3QYi0
         jyAFhkTReRcrJTNFHd24a2oyGO/WQX4paHTTlBLU=
Date:   Tue, 22 Mar 2022 14:45:03 -0700
To:     zhengqi.arch@bytedance.com, willy@infradead.org,
        song.bao.hua@hisilicon.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mhocko@suse.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com, corbet@lwn.net,
        chenhuang5@huawei.com, bodeddub@amazon.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 129/227] mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key
Message-Id: <20220322214503.BDFA1C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
