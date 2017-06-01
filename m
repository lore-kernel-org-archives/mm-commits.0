From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
 added to -mm tree
Date: Thu, 01 Jun 2017 15:38:09 -0700
Message-ID: <59309751.ML1M0uHiO4+F/jmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdFAWiK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error
has been added to the -mm tree.  Its filename is
     mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error

Currently me_huge_page() relies on dequeue_hwpoisoned_huge_page() to keep
the error hugepage away from the system, which is OK but not good enough
because the hugepage still has a refcount and unpoison doesn't work on the
error hugepage (PageHWPoison flags are cleared but pages are still
leaked.) And there's "wasting health subpages" issue too.  This patch
reworks on me_huge_page() to solve these issues.

For hugetlb file, recently we have truncating code so let's use it
in hugetlbfs specific ->error_remove_page().

For anonymous hugepage, it's helpful to dissolve the error page after
freeing it into free hugepage list. Migration entry and PageHWPoison
in the head page prevent the access to it.

TODO: dissolve_free_huge_page() can fail but we don't considered it
yet.  It's not critical (and at least no worse that now) because in
such case the error hugepage just stays in free hugepage list without
being dissolved.  By virtue of PageHWPoison in head page, it's never
allocated to processes.

Fixes: 23a003bfd23ea9ea0b7756b920e51f64b284b468 ("mm/madvise: pass return code of memory_failure() to userspace")
Link: http://lkml.kernel.org/r/20170417055948.GM31394@yexl-desktop
Link: http://lkml.kernel.org/r/1496305019-5493-8-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   11 ++++
 mm/memory-failure.c  |   94 +++++++++++++++++++++++------------------
 2 files changed, 66 insertions(+), 39 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error
+++ a/fs/hugetlbfs/inode.c
@@ -851,6 +851,16 @@ static int hugetlbfs_migrate_page(struct
 	return MIGRATEPAGE_SUCCESS;
 }
 
+static int hugetlbfs_error_remove_page(struct address_space *mapping,
+				struct page *page)
+{
+	struct inode *inode = mapping->host;
+
+	remove_huge_page(page);
+	hugetlb_fix_reserve_counts(inode);
+	return 0;
+}
+
 static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(dentry->d_sb);
@@ -966,6 +976,7 @@ static const struct address_space_operat
 	.write_end	= hugetlbfs_write_end,
 	.set_page_dirty	= hugetlbfs_set_page_dirty,
 	.migratepage    = hugetlbfs_migrate_page,
+	.error_remove_page	= hugetlbfs_error_remove_page,
 };
 
 
diff -puN mm/memory-failure.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error
+++ a/mm/memory-failure.c
@@ -554,6 +554,39 @@ static int delete_from_lru_cache(struct
 	return -EIO;
 }
 
+static int truncate_error_page(struct page *p, unsigned long pfn,
+				struct address_space *mapping)
+{
+	int ret = MF_FAILED;
+
+	if (mapping->a_ops->error_remove_page) {
+		int err = mapping->a_ops->error_remove_page(mapping, p);
+
+		if (err != 0) {
+			pr_info("Memory failure: %#lx: Failed to punch page: %d\n",
+				pfn, err);
+		} else if (page_has_private(p) &&
+			   !try_to_release_page(p, GFP_NOIO)) {
+			pr_info("Memory failure: %#lx: failed to release buffers\n",
+				pfn);
+		} else {
+			ret = MF_RECOVERED;
+		}
+	} else {
+		/*
+		 * If the file system doesn't support it just invalidate
+		 * This fails on dirty or anything with private pages
+		 */
+		if (invalidate_inode_page(p))
+			ret = MF_RECOVERED;
+		else
+			pr_info("Memory failure: %#lx: Failed to invalidate\n",
+				pfn);
+	}
+
+	return ret;
+}
+
 /*
  * Error hit kernel page.
  * Do nothing, try to be lucky and not touch this instead. For a few cases we
@@ -579,7 +612,6 @@ static int me_unknown(struct page *p, un
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
 {
 	int err;
-	int ret = MF_FAILED;
 	struct address_space *mapping;
 
 	delete_from_lru_cache(p);
@@ -611,30 +643,7 @@ static int me_pagecache_clean(struct pag
 	 *
 	 * Open: to take i_mutex or not for this? Right now we don't.
 	 */
-	if (mapping->a_ops->error_remove_page) {
-		err = mapping->a_ops->error_remove_page(mapping, p);
-		if (err != 0) {
-			pr_info("Memory failure: %#lx: Failed to punch page: %d\n",
-				pfn, err);
-		} else if (page_has_private(p) &&
-				!try_to_release_page(p, GFP_NOIO)) {
-			pr_info("Memory failure: %#lx: failed to release buffers\n",
-				pfn);
-		} else {
-			ret = MF_RECOVERED;
-		}
-	} else {
-		/*
-		 * If the file system doesn't support it just invalidate
-		 * This fails on dirty or anything with private pages
-		 */
-		if (invalidate_inode_page(p))
-			ret = MF_RECOVERED;
-		else
-			pr_info("Memory failure: %#lx: Failed to invalidate\n",
-				pfn);
-	}
-	return ret;
+	return truncate_error_page(p, pfn, mapping);
 }
 
 /*
@@ -740,24 +749,31 @@ static int me_huge_page(struct page *p,
 {
 	int res = 0;
 	struct page *hpage = compound_head(p);
+	struct address_space *mapping;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
 
-	/*
-	 * We can safely recover from error on free or reserved (i.e.
-	 * not in-use) hugepage by dequeuing it from freelist.
-	 * To check whether a hugepage is in-use or not, we can't use
-	 * page->lru because it can be used in other hugepage operations,
-	 * such as __unmap_hugepage_range() and gather_surplus_pages().
-	 * So instead we use page_mapping() and PageAnon().
-	 */
-	if (!(page_mapping(hpage) || PageAnon(hpage))) {
-		res = dequeue_hwpoisoned_huge_page(hpage);
-		if (!res)
-			return MF_RECOVERED;
+	mapping = page_mapping(hpage);
+	if (mapping) {
+		res = truncate_error_page(hpage, pfn, mapping);
+	} else {
+		int dissolve_ret;
+
+		unlock_page(hpage);
+		/*
+		 * migration entry prevents later access on error anonymous
+		 * hugepage, so we can free and dissolve it into buddy to
+		 * save healthy subpages.
+		 */
+		if (PageAnon(hpage))
+			put_page(hpage);
+		dissolve_free_huge_page(p);
+		res = MF_RECOVERED;
+		lock_page(hpage);
 	}
-	return MF_DELAYED;
+
+	return res;
 }
 
 /*
@@ -856,7 +872,7 @@ static int page_action(struct page_state
 	count = page_count(p) - 1;
 	if (ps->action == me_swapcache_dirty && result == MF_DELAYED)
 		count--;
-	if (count != 0) {
+	if (count > 0) {
 		pr_err("Memory failure: %#lx: %s still referenced by %d users\n",
 		       pfn, action_page_types[ps->type], count);
 		result = MF_FAILED;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-drop-null-return-check-of-pte_offset_map_lock.patch
mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch
mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch
mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages.patch
mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
mm-hwpoison-introduce-memory_failure_hugetlb.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch
mm-hwpoison-introduce-idenfity_page_state.patch

