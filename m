Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDAB38F83
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817365; cv=none; b=Gfbu+LdJC7ZH3sCZnkcLdmKz28M68GezFQdSUnUDWW9lDuNpb6suzzSKBKp2hS806OtPawEbE4550c8g7+361npofxMN126gdSFNFmt4EenZDN8rxRy0kIFRVuW1h7F2vZ6lJAhBnxR6ZdoCffo1EVzWlqW7AyABsHeuvR4OVsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817365; c=relaxed/simple;
	bh=24iOCqQ/BnWLn0WDc835xPSSbuhyL0AgQly8WmAUwNo=;
	h=Date:To:From:Subject:Message-Id; b=IOjfWRzMnm7Oz+uqr44TlcVX0qE0y+35QJ73d2lk0u3cSS2Crz64bpHOh5/XBh0VMApZFQ1fGY+ujKyUy3Wqyji7e8CoJabjJs82gTrWwDBUSeSuLX5Z0BNMrzyJ6q2fSM63H4msqJYdOu4L5eyGpjZNCRkjfyig7toSIiTXK54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=USXTyGmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="USXTyGmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D4FC4CED6;
	Tue, 14 Jan 2025 01:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736817364;
	bh=24iOCqQ/BnWLn0WDc835xPSSbuhyL0AgQly8WmAUwNo=;
	h=Date:To:From:Subject:From;
	b=USXTyGmGblCPOkKMZLiw/eJTzbtUWrPZG5DP/2zw6wTYhCUz1HWADUzkgUWPm2COJ
	 KZQsN49SKyijoOk4wT2rQRfvURz1Lsn5cvEXT+1GyDSy87CuPULP4eWt8FXLzah463
	 GnDGc4HuWBXgiYQE32alSk3O3/FjW1lCBkqa7yWI=
Date: Mon, 13 Jan 2025 17:16:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch added to mm-unstable branch
Message-Id: <20250114011604.65D4FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: rename isolate_hugetlb() to folio_isolate_hugetlb()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: rename isolate_hugetlb() to folio_isolate_hugetlb()
Date: Mon, 13 Jan 2025 14:16:07 +0100

Let's make the function name match "folio_isolate_lru()", and add some
kernel doc.

Link: https://lkml.kernel.org/r/20250113131611.2554758-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/gup.c                |    2 +-
 mm/hugetlb.c            |   23 ++++++++++++++++++++---
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    6 +++---
 5 files changed, 27 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb
+++ a/include/linux/hugetlb.h
@@ -153,7 +153,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-bool isolate_hugetlb(struct folio *folio, struct list_head *list);
+bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
@@ -414,7 +414,7 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline bool isolate_hugetlb(struct folio *folio, struct list_head *list)
+static inline bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	return false;
 }
--- a/mm/gup.c~mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb
+++ a/mm/gup.c
@@ -2344,7 +2344,7 @@ static unsigned long collect_longterm_un
 			continue;
 
 		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(folio, movable_folio_list);
+			folio_isolate_hugetlb(folio, movable_folio_list);
 			continue;
 		}
 
--- a/mm/hugetlb.c~mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb
+++ a/mm/hugetlb.c
@@ -2812,7 +2812,7 @@ retry:
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		isolated = isolate_hugetlb(old_folio, list);
+		isolated = folio_isolate_hugetlb(old_folio, list);
 		ret = isolated ? 0 : -EBUSY;
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
@@ -2897,7 +2897,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (folio_ref_count(folio) && isolate_hugetlb(folio, list))
+	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
 		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
@@ -7421,7 +7421,24 @@ __weak unsigned long hugetlb_mask_last_p
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
-bool isolate_hugetlb(struct folio *folio, struct list_head *list)
+/**
+ * folio_isolate_hugetlb - try to isolate an allocated hugetlb folio
+ * @folio: the folio to isolate
+ * @list: the list to add the folio to on success
+ *
+ * Isolate an allocated (refcount > 0) hugetlb folio, marking it as
+ * isolated/non-migratable, and moving it from the active list to the
+ * given list.
+ *
+ * Isolation will fail if @folio is not an allocated hugetlb folio, or if
+ * it is already isolated/non-migratable.
+ *
+ * On success, an additional folio reference is taken that must be dropped
+ * using folio_putback_active_hugetlb() to undo the isolation.
+ *
+ * Return: True if isolation worked, otherwise False.
+ */
+bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	bool ret = true;
 
--- a/mm/mempolicy.c~mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb
+++ a/mm/mempolicy.c
@@ -647,7 +647,7 @@ static int queue_folios_hugetlb(pte_t *p
 	 */
 	if ((flags & MPOL_MF_MOVE_ALL) ||
 	    (!folio_likely_mapped_shared(folio) && !hugetlb_pmd_shared(pte)))
-		if (!isolate_hugetlb(folio, qp->pagelist))
+		if (!folio_isolate_hugetlb(folio, qp->pagelist))
 			qp->nr_failed++;
 unlock:
 	spin_unlock(ptl);
--- a/mm/migrate.c~mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb
+++ a/mm/migrate.c
@@ -128,7 +128,7 @@ static void putback_movable_folio(struct
  *
  * This function shall be used whenever the isolated pageset has been
  * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
- * and isolate_hugetlb().
+ * and folio_isolate_hugetlb().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -169,7 +169,7 @@ bool isolate_folio_to_list(struct folio
 	bool isolated, lru;
 
 	if (folio_test_hugetlb(folio))
-		return isolate_hugetlb(folio, list);
+		return folio_isolate_hugetlb(folio, list);
 
 	lru = !__folio_test_movable(folio);
 	if (lru)
@@ -2200,7 +2200,7 @@ static int __add_folio_for_migration(str
 		return -EACCES;
 
 	if (folio_test_hugetlb(folio)) {
-		if (isolate_hugetlb(folio, pagelist))
+		if (folio_isolate_hugetlb(folio, pagelist))
 			return 1;
 	} else if (folio_isolate_lru(folio)) {
 		list_add_tail(&folio->lru, pagelist);
_

Patches currently in -mm which might be from david@redhat.com are

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch
mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

