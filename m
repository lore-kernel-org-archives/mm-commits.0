Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34543C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiF1T0S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiF1TZp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:25:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F1023154
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C7261B86
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D02C3411D;
        Tue, 28 Jun 2022 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656444282;
        bh=0lL1y5JmfD0ENnGu4lxdNvfARU9a7saiDAnwUFtaCLA=;
        h=Date:To:From:Subject:From;
        b=oAAksTPnvLSJ8FWXu0QFUafyQ5sVKxAjYOs/PM4UUt+rJkdxfyFhoyAH0gZHU9wFa
         FzstvQ+5A/mvQNRh9LCOSOFbN7LcC8ippagXWVdFyAJk1BNWeI3COTa8wdPq/M2mIo
         mPm1BRcjxm/PyvA6X1Wq9/YE8AhI3EusERR3Tyns=
Date:   Tue, 28 Jun 2022 12:24:41 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch added to mm-unstable branch
Message-Id: <20220628192442.42D02C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: improve hugetlb_vmemmap code readability
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: improve hugetlb_vmemmap code readability
Date: Tue, 28 Jun 2022 17:22:33 +0800

There is a discussion about the name of hugetlb_vmemmap_alloc/free in
thread [1].  The suggestion suggested by David is rename "alloc/free" to
"optimize/restore" to make functionalities clearer to users, "optimize"
means the function will optimize vmemmap pages, while "restore" means
restoring its vmemmap pages discared before.  This commit does this.

Another discussion is the confusion RESERVE_VMEMMAP_NR isn't used
explicitly for vmemmap_addr but implicitly for vmemmap_end in
hugetlb_vmemmap_alloc/free.  David suggested we can compute what
hugetlb_vmemmap_init() does now at runtime.  We do not need to worry for
the overhead of computing at runtime since the calculation is simple
enough and those functions are not in a hot path.  This commit has the
following improvements:

  1) The function suffixed name ("optimize/restore") is more expressive.
  2) The logic becomes less weird in hugetlb_vmemmap_optimize/restore().
  3) The hugetlb_vmemmap_init() does not need to be exported anymore.
  4) A ->optimize_vmemmap_pages field in struct hstate is killed.
  5) There is only one place where checks is_power_of_2(sizeof(struct
     page)) instead of two places.
  6) Add more comments for hugetlb_vmemmap_optimize/restore().
  7) For external users, hugetlb_optimize_vmemmap_pages() is used for
     detecting if the HugeTLB's vmemmap pages is optimizable originally.
     In this commit, it is killed and we introduce a new helper
     hugetlb_vmemmap_optimizable() to replace it.  The name is more
     expressive.

Link: https://lore.kernel.org/all/20220404074652.68024-2-songmuchun@bytedance.com/ [1]
Link: https://lkml.kernel.org/r/20220628092235.91270-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 -
 include/linux/sysctl.h  |    4 +
 mm/hugetlb.c            |   15 ++--
 mm/hugetlb_vmemmap.c    |  141 +++++++++++++++-----------------------
 mm/hugetlb_vmemmap.h    |   41 +++++++----
 5 files changed, 101 insertions(+), 107 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability
+++ a/include/linux/hugetlb.h
@@ -638,9 +638,6 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	unsigned int optimize_vmemmap_pages;
-#endif
 #ifdef CONFIG_CGROUP_HUGETLB
 	/* cgroup control files */
 	struct cftype cgroup_files_dfl[8];
@@ -716,7 +713,7 @@ static inline struct hstate *hstate_vma(
 	return hstate_file(vma->vm_file);
 }
 
-static inline unsigned long huge_page_size(struct hstate *h)
+static inline unsigned long huge_page_size(const struct hstate *h)
 {
 	return (unsigned long)PAGE_SIZE << h->order;
 }
@@ -745,7 +742,7 @@ static inline bool hstate_is_gigantic(st
 	return huge_page_order(h) >= MAX_ORDER;
 }
 
-static inline unsigned int pages_per_huge_page(struct hstate *h)
+static inline unsigned int pages_per_huge_page(const struct hstate *h)
 {
 	return 1 << h->order;
 }
--- a/include/linux/sysctl.h~mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability
+++ a/include/linux/sysctl.h
@@ -266,6 +266,10 @@ static inline struct ctl_table_header *r
 	return NULL;
 }
 
+static inline void register_sysctl_init(const char *path, struct ctl_table *table)
+{
+}
+
 static inline struct ctl_table_header *register_sysctl_mount_point(const char *path)
 {
 	return NULL;
--- a/mm/hugetlb.c~mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability
+++ a/mm/hugetlb.c
@@ -1535,7 +1535,7 @@ static void __update_and_free_page(struc
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
 
-	if (hugetlb_vmemmap_alloc(h, page)) {
+	if (hugetlb_vmemmap_restore(h, page)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1612,7 +1612,7 @@ static DECLARE_WORK(free_hpage_work, fre
 
 static inline void flush_free_hpage_work(struct hstate *h)
 {
-	if (hugetlb_optimize_vmemmap_pages(h))
+	if (hugetlb_vmemmap_optimizable(h))
 		flush_work(&free_hpage_work);
 }
 
@@ -1734,7 +1734,7 @@ static void __prep_account_new_huge_page
 
 static void __prep_new_huge_page(struct hstate *h, struct page *page)
 {
-	hugetlb_vmemmap_free(h, page);
+	hugetlb_vmemmap_optimize(h, page);
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	hugetlb_set_page_subpool(page, NULL);
@@ -2107,7 +2107,7 @@ retry:
 		 * Attempt to allocate vmemmmap here so that we can take
 		 * appropriate action on failure.
 		 */
-		rc = hugetlb_vmemmap_alloc(h, head);
+		rc = hugetlb_vmemmap_restore(h, head);
 		if (!rc) {
 			/*
 			 * Move PageHWPoison flag from head page to the raw
@@ -3182,8 +3182,10 @@ static void __init report_hugepages(void
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_info("HugeTLB registered %s page size, pre-allocated %ld pages\n",
+		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
 			buf, h->free_huge_pages);
+		pr_info("HugeTLB: %d KiB vmemmap can be freed for a %s page\n",
+			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
 }
 
@@ -3421,7 +3423,7 @@ static int demote_free_huge_page(struct
 	remove_hugetlb_page_for_demote(h, page, false);
 	spin_unlock_irq(&hugetlb_lock);
 
-	rc = hugetlb_vmemmap_alloc(h, page);
+	rc = hugetlb_vmemmap_restore(h, page);
 	if (rc) {
 		/* Allocation of vmemmmap failed, we can not demote page */
 		spin_lock_irq(&hugetlb_lock);
@@ -4111,7 +4113,6 @@ void __init hugetlb_add_hstate(unsigned
 	h->next_nid_to_free = first_memory_node;
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
-	hugetlb_vmemmap_init(h);
 
 	parsed_hstate = h;
 }
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability
+++ a/mm/hugetlb_vmemmap.c
@@ -35,16 +35,6 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 };
 
-/*
- * There are a lot of struct page structures associated with each HugeTLB page.
- * For tail pages, the value of compound_head is the same. So we can reuse first
- * page of head page structures. We map the virtual addresses of all the pages
- * of tail page structures to the head page struct, and then free these page
- * frames. Therefore, we need to reserve one pages as vmemmap areas.
- */
-#define RESERVE_VMEMMAP_NR		1U
-#define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
-
 static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
 {
 	pmd_t __pmd;
@@ -426,32 +416,37 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
 
-/*
- * Previously discarded vmemmap pages will be allocated and remapping
- * after this function returns zero.
+/**
+ * hugetlb_vmemmap_restore - restore previously optimized (by
+ *			     hugetlb_vmemmap_optimize()) vmemmap pages which
+ *			     will be reallocated and remapped.
+ * @h:		struct hstate.
+ * @head:	the head page whose vmemmap pages will be restored.
+ *
+ * Return: %0 if @head's vmemmap pages have been reallocated and remapped,
+ * negative error code otherwise.
  */
-int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head)
+int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
 {
 	int ret;
-	unsigned long vmemmap_addr = (unsigned long)head;
-	unsigned long vmemmap_end, vmemmap_reuse, vmemmap_pages;
+	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_reuse;
 
 	if (!HPageVmemmapOptimized(head))
 		return 0;
 
-	vmemmap_addr	+= RESERVE_VMEMMAP_SIZE;
-	vmemmap_pages	= hugetlb_optimize_vmemmap_pages(h);
-	vmemmap_end	= vmemmap_addr + (vmemmap_pages << PAGE_SHIFT);
-	vmemmap_reuse	= vmemmap_addr - PAGE_SIZE;
+	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
+	vmemmap_reuse	= vmemmap_start;
+	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
-	 * The pages which the vmemmap virtual address range [@vmemmap_addr,
+	 * The pages which the vmemmap virtual address range [@vmemmap_start,
 	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
 	 * the range is mapped to the page which @vmemmap_reuse is mapped to.
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_addr, vmemmap_end, vmemmap_reuse,
+	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse,
 				  GFP_KERNEL | __GFP_NORETRY | __GFP_THISNODE);
 	if (!ret) {
 		ClearHPageVmemmapOptimized(head);
@@ -461,11 +456,14 @@ int hugetlb_vmemmap_alloc(struct hstate
 	return ret;
 }
 
-static unsigned int vmemmap_optimizable_pages(struct hstate *h,
-					      struct page *head)
+/* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
+static bool vmemmap_should_optimize(const struct hstate *h, const struct page *head)
 {
 	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return 0;
+		return false;
+
+	if (!hugetlb_vmemmap_optimizable(h))
+		return false;
 
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG)) {
 		pmd_t *pmdp, pmd;
@@ -508,73 +506,47 @@ static unsigned int vmemmap_optimizable_
 		 *          +-------------------------------------------+
 		 */
 		if (PageVmemmapSelfHosted(vmemmap_page))
-			return 0;
+			return false;
 	}
 
-	return hugetlb_optimize_vmemmap_pages(h);
+	return true;
 }
 
-void hugetlb_vmemmap_free(struct hstate *h, struct page *head)
+/**
+ * hugetlb_vmemmap_optimize - optimize @head page's vmemmap pages.
+ * @h:		struct hstate.
+ * @head:	the head page whose vmemmap pages will be optimized.
+ *
+ * This function only tries to optimize @head's vmemmap pages and does not
+ * guarantee that the optimization will succeed after it returns. The caller
+ * can use HPageVmemmapOptimized(@head) to detect if @head's vmemmap pages
+ * have been optimized.
+ */
+void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
 {
-	unsigned long vmemmap_addr = (unsigned long)head;
-	unsigned long vmemmap_end, vmemmap_reuse, vmemmap_pages;
+	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_reuse;
 
-	vmemmap_pages = vmemmap_optimizable_pages(h, head);
-	if (!vmemmap_pages)
+	if (!vmemmap_should_optimize(h, head))
 		return;
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	vmemmap_addr	+= RESERVE_VMEMMAP_SIZE;
-	vmemmap_end	= vmemmap_addr + (vmemmap_pages << PAGE_SHIFT);
-	vmemmap_reuse	= vmemmap_addr - PAGE_SIZE;
+	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
+	vmemmap_reuse	= vmemmap_start;
+	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
-	 * Remap the vmemmap virtual address range [@vmemmap_addr, @vmemmap_end)
+	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end)
 	 * to the page which @vmemmap_reuse is mapped to, then free the pages
-	 * which the range [@vmemmap_addr, @vmemmap_end] is mapped to.
+	 * which the range [@vmemmap_start, @vmemmap_end] is mapped to.
 	 */
-	if (vmemmap_remap_free(vmemmap_addr, vmemmap_end, vmemmap_reuse))
+	if (vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse))
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 	else
 		SetHPageVmemmapOptimized(head);
 }
 
-void __init hugetlb_vmemmap_init(struct hstate *h)
-{
-	unsigned int nr_pages = pages_per_huge_page(h);
-	unsigned int vmemmap_pages;
-
-	/*
-	 * There are only (RESERVE_VMEMMAP_SIZE / sizeof(struct page)) struct
-	 * page structs that can be used when HVO is enabled, add a BUILD_BUG_ON
-	 * to catch invalid usage of the tail page structs.
-	 */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE >=
-		     RESERVE_VMEMMAP_SIZE / sizeof(struct page));
-
-	if (!is_power_of_2(sizeof(struct page))) {
-		pr_warn_once("cannot optimize vmemmap pages because \"struct page\" crosses page boundaries\n");
-		return;
-	}
-
-	vmemmap_pages = (nr_pages * sizeof(struct page)) >> PAGE_SHIFT;
-	/*
-	 * The head page is not to be freed to buddy allocator, the other tail
-	 * pages will map to the head page, so they can be freed.
-	 *
-	 * Could RESERVE_VMEMMAP_NR be greater than @vmemmap_pages? It is true
-	 * on some architectures (e.g. aarch64). See Documentation/arm64/
-	 * hugetlbpage.rst for more details.
-	 */
-	if (likely(vmemmap_pages > RESERVE_VMEMMAP_NR))
-		h->optimize_vmemmap_pages = vmemmap_pages - RESERVE_VMEMMAP_NR;
-
-	pr_info("can optimize %d vmemmap pages for %s\n",
-		h->optimize_vmemmap_pages, h->name);
-}
-
-#ifdef CONFIG_PROC_SYSCTL
 static struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
 		.procname	= "hugetlb_optimize_vmemmap",
@@ -586,16 +558,21 @@ static struct ctl_table hugetlb_vmemmap_
 	{ }
 };
 
-static __init int hugetlb_vmemmap_sysctls_init(void)
+static int __init hugetlb_vmemmap_init(void)
 {
-	/*
-	 * If "struct page" crosses page boundaries, the vmemmap pages cannot
-	 * be optimized.
-	 */
-	if (is_power_of_2(sizeof(struct page)))
-		register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
+	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE * sizeof(struct page) > HUGETLB_VMEMMAP_RESERVE_SIZE);
+
+	if (IS_ENABLED(CONFIG_PROC_SYSCTL)) {
+		const struct hstate *h;
 
+		for_each_hstate(h) {
+			if (hugetlb_vmemmap_optimizable(h)) {
+				register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
+				break;
+			}
+		}
+	}
 	return 0;
 }
-late_initcall(hugetlb_vmemmap_sysctls_init);
-#endif /* CONFIG_PROC_SYSCTL */
+late_initcall(hugetlb_vmemmap_init);
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability
+++ a/mm/hugetlb_vmemmap.h
@@ -11,35 +11,50 @@
 #include <linux/hugetlb.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head);
-void hugetlb_vmemmap_free(struct hstate *h, struct page *head);
-void hugetlb_vmemmap_init(struct hstate *h);
+int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head);
+void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head);
 
 /*
- * How many vmemmap pages associated with a HugeTLB page that can be
- * optimized and freed to the buddy allocator.
+ * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
+ * Documentation/vm/vmemmap_dedup.rst.
  */
-static inline unsigned int hugetlb_optimize_vmemmap_pages(struct hstate *h)
+#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
+
+static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
-	return h->optimize_vmemmap_pages;
+	return pages_per_huge_page(h) * sizeof(struct page);
+}
+
+/*
+ * Return how many vmemmap size associated with a HugeTLB page that can be
+ * optimized and can be freed to the buddy allocator.
+ */
+static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
+{
+	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return 0;
+	return size > 0 ? size : 0;
 }
 #else
-static inline int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head)
+static inline int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
 {
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_free(struct hstate *h, struct page *head)
+static inline void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
 {
 }
 
-static inline void hugetlb_vmemmap_init(struct hstate *h)
+static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
+	return 0;
 }
+#endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
-static inline unsigned int hugetlb_optimize_vmemmap_pages(struct hstate *h)
+static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
 {
-	return 0;
+	return hugetlb_vmemmap_optimizable_size(h) != 0;
 }
-#endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 #endif /* _LINUX_HUGETLB_VMEMMAP_H */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparsemem-fix-missing-higher-order-allocation-splitting.patch
mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

