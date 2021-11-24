Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9CBC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 03:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbhKXDiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:38:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhKXDiz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:38:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCCC360F50;
        Wed, 24 Nov 2021 03:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637724946;
        bh=wW+obzSRQOlARrNLakrsegjOAgwFKD4QQ++L/MKya6g=;
        h=Date:From:To:Subject:From;
        b=DYMW/pam/G1nW4j/dsaoeYI3d73hWovI9QWOBELDzEN+/9OSBeKqGvZ9nV/WmTFxr
         zxMbynjLOlAy8rQhntv6OCIYOOofEexvOk0oeMjoakkqIpwOiMuezIv6WaN/KXsR3K
         eMPUFRieLv2TNNXey+TalT6yeXZKYp6ICOGv9xKI=
Date:   Tue, 23 Nov 2021 19:35:45 -0800
From:   akpm@linux-foundation.org
To:     bodeddub@amazon.com, chenhuang5@huawei.com, corbet@lwn.net,
        david@redhat.com, duanxiongchun@bytedance.com,
        fam.zheng@bytedance.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        willy@infradead.org, zhengqi.arch@bytedance.com
Subject:  +
 mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
 added to -mm tree
Message-ID: <20211124033545.aFz-g5Mio%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key
has been added to the -mm tree.  Its filename is
     mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch

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
@@ -194,7 +194,14 @@ enum pageflags {
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
@@ -214,7 +221,7 @@ extern bool hugetlb_free_vmemmap_enabled
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
-	if (!hugetlb_free_vmemmap_enabled)
+	if (!hugetlb_free_vmemmap_enabled())
 		return page;
 
 	/*
@@ -242,6 +249,11 @@ static inline const struct page *page_fi
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
@@ -1326,7 +1326,7 @@ bool mhp_supports_memmap_on_memory(unsig
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

mm-slab-make-slab-iterator-functions-static.patch
mm-memcontrol-make-cgroup_memory_nokmem-static.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
fs-proc-store-pde-data-into-inode-i_private.patch
fs-proc-replace-pde_datainode-with-inode-i_private.patch
fs-proc-remove-pde_data.patch
fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

