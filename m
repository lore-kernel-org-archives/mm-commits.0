Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1123207DFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550283; cv=none; b=UvAQvzeHdzOL8UTSv9Y3539u+SGtZiszdF7zN1S4PfMwgd+bWSZYIGk+sjqfJnfS0Hc1rP9l5hN7/Ef92oQA6RY9++x7eFnhDgPpjFlUonaFXuSM/ntuy7xnpwBec52IXqtEgnirzJ24NuGi9vzfuz36WUL00ayg4U2Yhu80HNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550283; c=relaxed/simple;
	bh=064LH+wQVodCG3ClAHXHlCowxLhtFWecOmXz8oIddrI=;
	h=Date:To:From:Subject:Message-Id; b=IQocaz8HONi4WnLKGqXlHmUTGLAtoAZHp95dP+fqN6vlnrJJcZRxYdJ02D0DJm0cAgMbN2mlzxGQ+v7cCn5T74QF3H38IIRsZyHO4BrDUMugHEUkS/q1uEn84OToUa8ve+DiVYhj5tmZRMh+3kDQ8I9LgSRIWRRvqB7nn2AEY30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rF03f8yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rF03f8yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD9FC4CED6;
	Fri, 10 Jan 2025 23:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736550283;
	bh=064LH+wQVodCG3ClAHXHlCowxLhtFWecOmXz8oIddrI=;
	h=Date:To:From:Subject:From;
	b=rF03f8ynxM2/G3w8N+sbolT4JchrIoF0M6UXWdpysgXYFqdQ9fmmZNGJ7hKXHxAOh
	 7e4koSVxkJWYqVKGr8lGMg6uhNgSFTiA3oTEWbkBC6L/QXIuMDzzXkG7/0ircnudtJ
	 kzFbP6Us4XyFO5z1w2UBgmILmRsi2mAHfRdMhGms=
Date: Fri, 10 Jan 2025 15:04:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch added to mm-unstable branch
Message-Id: <20250110230443.5BD9FC4CED6@smtp.kernel.org>
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
Date: Fri, 10 Jan 2025 19:21:47 +0100

Now that folio_putback_hugetlb() is only called on folios that were
previously isolated through folio_isolate_hugetlb(), let's rename it to
match folio_putback_lru().

Add some kernel doc to clarify how this function is supposed to be used.

Link: https://lkml.kernel.org/r/20250110182149.746551-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
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
@@ -7430,7 +7430,7 @@ __weak unsigned long hugetlb_mask_last_p
  * it is already isolated/non-migratable.
  *
  * On success, an additional folio reference is taken that must be dropped
- * using folio_putback_active_hugetlb() to undo the isolation.
+ * using folio_putback_hugetlb() to undo the isolation.
  *
  * Return: True if isolation worked, otherwise False.
  */
@@ -7482,7 +7482,18 @@ int get_huge_page_for_hwpoison(unsigned
 	return ret;
 }
 
-void folio_putback_active_hugetlb(struct folio *folio)
+/**
+ * folio_putback_hugetlb: unisolate a hugetlb folio
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
@@ -1454,7 +1454,7 @@ static int unmap_and_move_huge_page(new_
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
-		folio_putback_active_hugetlb(src);
+		folio_putback_hugetlb(src);
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -1537,7 +1537,7 @@ out_unlock:
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

