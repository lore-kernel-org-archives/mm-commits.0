Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883593A8D0
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817370; cv=none; b=GZyRmbB3I8tkTw8+TZNh7JGFcjj6EhMV9iOQAzWn1HYmndldWg1YbYWA4xgdnwO+yCNo9DNc5fz2aZ4vbNcVET4VlpAdrsdECAwC1+R53ACLvPjBsR4JDuZfRVpbXWuKf1gPPbv2QG2Pt7FsJw4sItpqlLpSfoDB7gLtp8u94rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817370; c=relaxed/simple;
	bh=hKsFExuPDdrRec/re2R3S/g8x2dpcoGTcGWf0mpxMzY=;
	h=Date:To:From:Subject:Message-Id; b=sW4HyyS1jhEbIVVU+NjRMTHPdsIJfBBVZg0Je1LMTD/UG8RvsfqnIWzRA4uOKHV2nJ5A2VdKPtkyigD+/cCC6Mdxv0rrkf/pTmmsQWIDL8KqX6mr9rQSzkRNc1Ei3rOa7gkMgmMmDMTp50VwudpKXM2UyYbdRyVnn/XLu5rOrDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TvJOr6Xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TvJOr6Xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3946AC4CED6;
	Tue, 14 Jan 2025 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736817370;
	bh=hKsFExuPDdrRec/re2R3S/g8x2dpcoGTcGWf0mpxMzY=;
	h=Date:To:From:Subject:From;
	b=TvJOr6XgJkEIOb7bB8+2YLBarqAdTtYujqEBQ5IDog7YCYvMX1a2bxBT+oRHtfNps
	 lPXogfS/idlrZl1KohB8UcnwoosoLpWUDmaY7GnieD3oQtuMaLLME1SZHrYMQQIqEV
	 eE+CqnOjymPrtyy+HZQoTL4LuNelfhPCPZvQ2TRE=
Date: Mon, 13 Jan 2025 17:16:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch added to mm-unstable branch
Message-Id: <20250114011610.3946AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: rename folio_putback_active_hugetlb() to folio_putback_hugetlb()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch

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
Subject: mm/hugetlb: rename folio_putback_active_hugetlb() to folio_putback_hugetlb()
Date: Mon, 13 Jan 2025 14:16:09 +0100

Now that folio_putback_hugetlb() is only called on folios that were
previously isolated through folio_isolate_hugetlb(), let's rename it to
match folio_putback_lru().

Add some kernel doc to clarify how this function is supposed to be used.

Link: https://lkml.kernel.org/r/20250113131611.2554758-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   15 +++++++++++++--
 mm/migrate.c            |    6 +++---
 3 files changed, 18 insertions(+), 7 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb
+++ a/include/linux/hugetlb.h
@@ -157,7 +157,7 @@ bool folio_isolate_hugetlb(struct folio
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
-void folio_putback_active_hugetlb(struct folio *folio);
+void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
@@ -430,7 +430,7 @@ static inline int get_huge_page_for_hwpo
 	return 0;
 }
 
-static inline void folio_putback_active_hugetlb(struct folio *folio)
+static inline void folio_putback_hugetlb(struct folio *folio)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb
+++ a/mm/hugetlb.c
@@ -7434,7 +7434,7 @@ __weak unsigned long hugetlb_mask_last_p
  * it is already isolated/non-migratable.
  *
  * On success, an additional folio reference is taken that must be dropped
- * using folio_putback_active_hugetlb() to undo the isolation.
+ * using folio_putback_hugetlb() to undo the isolation.
  *
  * Return: True if isolation worked, otherwise False.
  */
@@ -7486,7 +7486,18 @@ int get_huge_page_for_hwpoison(unsigned
 	return ret;
 }
 
-void folio_putback_active_hugetlb(struct folio *folio)
+/**
+ * folio_putback_hugetlb - unisolate a hugetlb folio
+ * @folio: the isolated hugetlb folio
+ *
+ * Putback/un-isolate the hugetlb folio that was previous isolated using
+ * folio_isolate_hugetlb(): marking it non-isolated/migratable and putting it
+ * back onto the active list.
+ *
+ * Will drop the additional folio reference obtained through
+ * folio_isolate_hugetlb().
+ */
+void folio_putback_hugetlb(struct folio *folio)
 {
 	spin_lock_irq(&hugetlb_lock);
 	folio_set_hugetlb_migratable(folio);
--- a/mm/migrate.c~mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb
+++ a/mm/migrate.c
@@ -137,7 +137,7 @@ void putback_movable_pages(struct list_h
 
 	list_for_each_entry_safe(folio, folio2, l, lru) {
 		if (unlikely(folio_test_hugetlb(folio))) {
-			folio_putback_active_hugetlb(folio);
+			folio_putback_hugetlb(folio);
 			continue;
 		}
 		list_del(&folio->lru);
@@ -1451,7 +1451,7 @@ static int unmap_and_move_huge_page(new_
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
-		folio_putback_active_hugetlb(src);
+		folio_putback_hugetlb(src);
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -1534,7 +1534,7 @@ out_unlock:
 	folio_unlock(src);
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
-		folio_putback_active_hugetlb(src);
+		folio_putback_hugetlb(src);
 	else if (rc != -EAGAIN)
 		list_move_tail(&src->lru, ret);
 
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

