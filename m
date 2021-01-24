Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9FCC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95CD22D07
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbhAXBde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbhAXBdd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:33:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D2C222D06;
        Sun, 24 Jan 2021 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451972;
        bh=IFNYnRIuScwqNiTrN3h470af883zznZiJQLysXNyEkk=;
        h=Date:From:To:Subject:From;
        b=B1oVDp2vkc2f9v90z8nUTBoTTpFgpHQCiKEG69OgJP2/xMqsNNOk3EE7NBS/XKP9f
         Es2Ych5mBrPqpNz5UbaY3OK+jIoI20dZQXScfxzVJiaina+iJxTtmyLhflqhxzzHWJ
         +ysXQdttNFbLOBEAGVcVDiQStaCksGc7Jz6diTo4=
Date:   Sat, 23 Jan 2021 17:32:50 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  +
 hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch added to -mm
 tree
Message-ID: <20210124013250.CLSbXI6Ay%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: use page.private for hugetlb specific page flags
has been added to the -mm tree.  Its filename is
     hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: use page.private for hugetlb specific page flags

Patch series "create hugetlb flags to consolidate state", v3.

While discussing a series of hugetlb fixes in [1], it became evident that
the hugetlb specific page state information is stored in a somewhat
haphazard manner.  Code dealing with state information would be easier to
read, understand and maintain if this information was stored in a
consistent manner.

This series uses page.private of the hugetlb head page for storing a set
of hugetlb specific page flags.  Routines are priovided for test, set and
clear of the flags.

[1] https://lore.kernel.org/r/20210106084739.63318-1-songmuchun@bytedance.com


This patch (of 5):

As hugetlbfs evolved, state information about hugetlb pages was added. 
One 'convenient' way of doing this was to use available fields in tail
pages.  Over time, it has become difficult to know the meaning or contents
of fields simply by looking at a small bit of code.  Sometimes, the naming
is just confusing.  For example: The PagePrivate flag indicates a huge
page reservation was consumed and needs to be restored if an error is
encountered and the page is freed before it is instantiated.  The
page.private field contains the pointer to a subpool if the page is
associated with one.

In an effort to make the code more readable, use page.private to contain
hugetlb specific page flags.  These flags will have test, set and clear
functions similar to those used for 'normal' page flags.  More
importantly, an enum of flag values will be created with names that
actually reflect their purpose.

In this patch,
- Create infrastructure for hugetlb specific page flag functions
- Move subpool pointer to page[1].private to make way for flags
  Create routines with meaningful names to modify subpool field
- Use new HPageRestoreReserve flag instead of PagePrivate

Conversion of other state information will happen in subsequent patches.

Link: https://lkml.kernel.org/r/20210122195231.324857-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20210122195231.324857-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   12 +-----
 include/linux/hugetlb.h |   68 ++++++++++++++++++++++++++++++++++++++
 mm/hugetlb.c            |   48 +++++++++++++-------------
 3 files changed, 96 insertions(+), 32 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-use-pageprivate-for-hugetlb-specific-page-flags
+++ a/fs/hugetlbfs/inode.c
@@ -966,15 +966,9 @@ static int hugetlbfs_migrate_page(struct
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
-	/*
-	 * page_private is subpool pointer in hugetlb pages.  Transfer to
-	 * new page.  PagePrivate is not associated with page_private for
-	 * hugetlb pages and can not be set here as only page_huge_active
-	 * pages can be migrated.
-	 */
-	if (page_private(page)) {
-		set_page_private(newpage, page_private(page));
-		set_page_private(page, 0);
+	if (hugetlb_page_subpool(page)) {
+		hugetlb_set_page_subpool(newpage, hugetlb_page_subpool(page));
+		hugetlb_set_page_subpool(page, NULL);
 	}
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
--- a/include/linux/hugetlb.h~hugetlb-use-pageprivate-for-hugetlb-specific-page-flags
+++ a/include/linux/hugetlb.h
@@ -472,6 +472,60 @@ unsigned long hugetlb_get_unmapped_area(
 					unsigned long flags);
 #endif /* HAVE_ARCH_HUGETLB_UNMAPPED_AREA */
 
+/*
+ * huegtlb page specific state flags.  These flags are located in page.private
+ * of the hugetlb head page.  Functions created via the below macros should be
+ * used to manipulate these flags.
+ *
+ * HPG_restore_reserve - Set when a hugetlb page consumes a reservation at
+ *	allocation time.  Cleared when page is fully instantiated.  Free
+ *	routine checks flag to restore a reservation on error paths.
+ */
+enum hugetlb_page_flags {
+	HPG_restore_reserve = 0,
+	__NR_HPAGEFLAGS,
+};
+
+/*
+ * Macros to create test, set and clear function definitions for
+ * hugetlb specific page flags.
+ */
+#ifdef CONFIG_HUGETLB_PAGE
+#define TESTHPAGEFLAG(uname, flname)				\
+static inline int HPage##uname(struct page *page)		\
+	{ return test_bit(HPG_##flname, &(page->private)); }
+
+#define SETHPAGEFLAG(uname, flname)				\
+static inline void SetHPage##uname(struct page *page)		\
+	{ set_bit(HPG_##flname, &(page->private)); }
+
+#define CLEARHPAGEFLAG(uname, flname)				\
+static inline void ClearHPage##uname(struct page *page)		\
+	{ clear_bit(HPG_##flname, &(page->private)); }
+#else
+#define TESTHPAGEFLAG(uname, flname)				\
+static inline int HPage##uname(struct page *page)		\
+	{ return 0; }
+
+#define SETHPAGEFLAG(uname, flname)				\
+static inline void SetHPage##uname(struct page *page)		\
+	{ }
+
+#define CLEARHPAGEFLAG(uname, flname)				\
+static inline void ClearHPage##uname(struct page *page)		\
+	{ }
+#endif
+
+#define HPAGEFLAG(uname, flname)				\
+	TESTHPAGEFLAG(uname, flname)				\
+	SETHPAGEFLAG(uname, flname)				\
+	CLEARHPAGEFLAG(uname, flname)				\
+
+/*
+ * Create functions associated with hugetlb page flags
+ */
+HPAGEFLAG(RestoreReserve, restore_reserve)
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #define HSTATE_NAME_LEN 32
@@ -531,6 +585,20 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
+/*
+ * hugetlb page subpool pointer located in hpage[1].private
+ */
+static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
+{
+	return (struct hugepage_subpool *)(hpage+1)->private;
+}
+
+static inline void hugetlb_set_page_subpool(struct page *hpage,
+					struct hugepage_subpool *subpool)
+{
+	set_page_private(hpage+1, (unsigned long)subpool);
+}
+
 static inline struct hstate *hstate_file(struct file *f)
 {
 	return hstate_inode(file_inode(f));
--- a/mm/hugetlb.c~hugetlb-use-pageprivate-for-hugetlb-specific-page-flags
+++ a/mm/hugetlb.c
@@ -1133,7 +1133,7 @@ static struct page *dequeue_huge_page_vm
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
 	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
-		SetPagePrivate(page);
+		SetHPageRestoreReserve(page);
 		h->resv_huge_pages--;
 	}
 
@@ -1407,20 +1407,19 @@ static void __free_huge_page(struct page
 	 */
 	struct hstate *h = page_hstate(page);
 	int nid = page_to_nid(page);
-	struct hugepage_subpool *spool =
-		(struct hugepage_subpool *)page_private(page);
+	struct hugepage_subpool *spool = hugetlb_page_subpool(page);
 	bool restore_reserve;
 
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(page_mapcount(page), page);
 
-	set_page_private(page, 0);
+	hugetlb_set_page_subpool(page, NULL);
 	page->mapping = NULL;
-	restore_reserve = PagePrivate(page);
-	ClearPagePrivate(page);
+	restore_reserve = HPageRestoreReserve(page);
+	ClearHPageRestoreReserve(page);
 
 	/*
-	 * If PagePrivate() was set on page, page allocation consumed a
+	 * If HPageRestoreReserve was set on page, page allocation consumed a
 	 * reservation.  If the page was associated with a subpool, there
 	 * would have been a page reserved in the subpool before allocation
 	 * via hugepage_subpool_get_pages().  Since we are 'restoring' the
@@ -2251,24 +2250,24 @@ static long vma_add_reservation(struct h
  * This routine is called to restore a reservation on error paths.  In the
  * specific error paths, a huge page was allocated (via alloc_huge_page)
  * and is about to be freed.  If a reservation for the page existed,
- * alloc_huge_page would have consumed the reservation and set PagePrivate
- * in the newly allocated page.  When the page is freed via free_huge_page,
- * the global reservation count will be incremented if PagePrivate is set.
- * However, free_huge_page can not adjust the reserve map.  Adjust the
- * reserve map here to be consistent with global reserve count adjustments
- * to be made by free_huge_page.
+ * alloc_huge_page would have consumed the reservation and set
+ * HPageRestoreReserve in the newly allocated page.  When the page is freed
+ * via free_huge_page, the global reservation count will be incremented if
+ * HPageRestoreReserve is set.  However, free_huge_page can not adjust the
+ * reserve map.  Adjust the reserve map here to be consistent with global
+ * reserve count adjustments to be made by free_huge_page.
  */
 static void restore_reserve_on_error(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address,
 			struct page *page)
 {
-	if (unlikely(PagePrivate(page))) {
+	if (unlikely(HPageRestoreReserve(page))) {
 		long rc = vma_needs_reservation(h, vma, address);
 
 		if (unlikely(rc < 0)) {
 			/*
 			 * Rare out of memory condition in reserve map
-			 * manipulation.  Clear PagePrivate so that
+			 * manipulation.  Clear HPageRestoreReserve so that
 			 * global reserve count will not be incremented
 			 * by free_huge_page.  This will make it appear
 			 * as though the reservation for this page was
@@ -2277,7 +2276,7 @@ static void restore_reserve_on_error(str
 			 * is better than inconsistent global huge page
 			 * accounting of reserve counts.
 			 */
-			ClearPagePrivate(page);
+			ClearHPageRestoreReserve(page);
 		} else if (rc) {
 			rc = vma_add_reservation(h, vma, address);
 			if (unlikely(rc < 0))
@@ -2285,7 +2284,7 @@ static void restore_reserve_on_error(str
 				 * See above comment about rare out of
 				 * memory condition.
 				 */
-				ClearPagePrivate(page);
+				ClearHPageRestoreReserve(page);
 		} else
 			vma_end_reservation(h, vma, address);
 	}
@@ -2366,7 +2365,7 @@ struct page *alloc_huge_page(struct vm_a
 		if (!page)
 			goto out_uncharge_cgroup;
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
-			SetPagePrivate(page);
+			SetHPageRestoreReserve(page);
 			h->resv_huge_pages--;
 		}
 		spin_lock(&hugetlb_lock);
@@ -2384,7 +2383,7 @@ struct page *alloc_huge_page(struct vm_a
 
 	spin_unlock(&hugetlb_lock);
 
-	set_page_private(page, (unsigned long)spool);
+	hugetlb_set_page_subpool(page, spool);
 
 	map_commit = vma_commit_reservation(h, vma, addr);
 	if (unlikely(map_chg > map_commit)) {
@@ -3158,6 +3157,9 @@ static int __init hugetlb_init(void)
 {
 	int i;
 
+	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
+			__NR_HPAGEFLAGS);
+
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
 			pr_warn("HugeTLB: huge pages not supported, ignoring associated command-line parameters\n");
@@ -4212,7 +4214,7 @@ retry_avoidcopy:
 	spin_lock(ptl);
 	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
-		ClearPagePrivate(new_page);
+		ClearHPageRestoreReserve(new_page);
 
 		/* Break COW */
 		huge_ptep_clear_flush(vma, haddr, ptep);
@@ -4279,7 +4281,7 @@ int huge_add_to_page_cache(struct page *
 
 	if (err)
 		return err;
-	ClearPagePrivate(page);
+	ClearHPageRestoreReserve(page);
 
 	/*
 	 * set page dirty so that it will not be removed from cache/file
@@ -4441,7 +4443,7 @@ retry:
 		goto backout;
 
 	if (anon_rmap) {
-		ClearPagePrivate(page);
+		ClearHPageRestoreReserve(page);
 		hugepage_add_new_anon_rmap(page, vma, haddr);
 	} else
 		page_dup_rmap(page, true);
@@ -4755,7 +4757,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	if (vm_shared) {
 		page_dup_rmap(page, true);
 	} else {
-		ClearPagePrivate(page);
+		ClearHPageRestoreReserve(page);
 		hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
 	}
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-only-set-hpagemigratable-for-migratable-hstates.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

