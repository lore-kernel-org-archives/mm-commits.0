Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53597382380
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783998650; cv=none; b=mohwEZtPWz6HJkDa71TuNOkXI79Bhu38NUnmb3JD+Z1+EB8DpjCwnixQvJFxhkOstWi4x6BZ42RA1jeB/ueMVSZTdEY1ef9Q68VOaDcnTOaH+3fEi65ejOXWYy/7a7P3iNLvjMd3uSTILnFEvRs3H5eAvaGeGVUmeWEjMlJFMX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783998650; c=relaxed/simple;
	bh=Luccw8jd6Nam6MpGIVPB2479B8A29pXLUCrcku3VAKk=;
	h=Date:To:From:Subject:Message-Id; b=FFzVo6BFiEyNLehpRI4TeQ6P15BCjK2jXszAF+ssh5Hu4mRaMIHDzvznGXk/p6hiZQFaHAfPvwSefo2RwdIE9i3RzVxuSDb35ICnyI4qgBhU2y67o8Efrw/YeGMR6NV018VOpG6/p2abXUnhlqtohyS1F6PoKqfnqNIsaZ/HrWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WrwOLHiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WrwOLHiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECECE1F000E9;
	Tue, 14 Jul 2026 03:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783998649;
	bh=39bQLswn8KzlMzrjbAkAgGIyQ8fsujl14w2aekko6Js=;
	h=Date:To:From:Subject;
	b=WrwOLHiqrA0ccpEiw1/ig1jMuloLM530Nnp2H6/dZ7aS35MXq39pmzLO+rESXpRdZ
	 IZfxrDUuJMKW8Mnb07DAq4AM3wlQRcdm2jyI+I9EO2cOZzVK9I2aBr70VOMIWAxk1q
	 r9yZyh/dINMQrMFpIV3QQEMY7+MA5x9P48eBCK8s=
Date: Mon, 13 Jul 2026 20:10:48 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch removed from -mm tree
Message-Id: <20260714031048.ECECE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
has been removed from the -mm tree.  Its filename was
     mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Wed, 1 Jul 2026 14:10:44 +0800

Patch series "mm/page_owner: misc cleanups", v5.

This series collects a few cleanups for mm/page_owner.c that have been
accumulated while reading through the file.  There is no functional change
-- the goal is to make the code easier to read and maintain.

Patch 1 consolidates three identical PageBuddy skip blocks into a single
skip_buddy_pages() helper, eliminating the duplication and keeping the
lockless-read comment in one place.

Patch 2 replaces the -1 magic number used for "never migrated" with a
proper MR_NEVER member in enum migrate_reason, adds the corresponding
"never_migrated" string in the MIGRATE_REASON trace macro, and updates the
GDB page_owner script to use MR_NEVER so that lx-dump-page-owner correctly
detects unmigrated pages.

Patch 3 follows up by converting the remaining 'int reason' parameters
throughout the migration and hugetlb callchains to 'enum migrate_reason',
making the type explicit and gaining compiler checking.  The 'short
last_migrate_reason' struct field in page_owner is intentionally left as
'short' since it is per-page metadata where size matters.

Patch 4 hoists the CONFIG_MEMCG guard out of print_page_owner_memcg()'s
body so that the real implementation and the empty stub are two clearly
separate definitions, the common kernel idiom.

Patch 5 adds a missing \n to the count_threshold debugfs attribute format
string so that cat(1) output is properly terminated.

Patch 6 moves free_ts_nsec from the allocation summary line to the free
section in __dump_page_owner(), grouping it with free_pid and free_tgid
where it logically belongs.  This also makes the dump output consistent
with print_page_owner().

Patch 7 drops the redundant page_owner_ prefix from file-scoped static
symbols (stack_fops, threshold_fops, etc.).  Since they cannot collide
across translation units, the prefix carries no information.

Patch 8 clamps the PFN advance in skip_buddy_pages() at the next
MAX_ORDER_NR_PAGES boundary.  The lockless buddy_order_unsafe() read can
return a garbage order value if the page is concurrently allocated between
the PageBuddy check and the private read, potentially causing the PFN to
advance past the next bounadry whose pfn_valid() check would have caught
an offline memory section.  In read_page_owner(), which relies solely on
boundary-aligned pfn_valid() to guard pfn_to_page(), this could lead to an
unmapped mem_section access.

Patch 9 avoids a TOCTOU VM_BUG_ON in print_page_owner_memcg() by reusing
the page->memcg_data snapshot already taken via READ_ONCE at the top of
the function, instead of calling PageMemcgKmem() which re-reads
folio->memcg_data and page->compound_head locklessly with VM_BUG_ON
assertions.  If the page is concurrently freed and reallocated as a THP
tail or slab page between the initial guards and this final call, those
assertions can fire on CONFIG_DEBUG_VM=y builds.


This patch (of 9)

Three places in page_owner.c duplicate the same pattern: check if a page
is PageBuddy, read its order via buddy_order_unsafe(), advance the pfn
past the buddy block if the order is valid, and continue.

Consolidate them into a single inline helper skip_buddy_pages().  The
function returns true (skip) for any buddy page and advances @pfn past the
block when the order is valid; returns false if the page is not a buddy
page and should be processed normally.

The old init_pages_in_zone() variant used "order > 0" as an extra guard
before advancing pfn, but the continue was unconditional and (1UL << 0) -
1 == 0, so the behaviour is identical.  The comment about zone->lock is
preserved in the helper's kernel-doc.

No functional change.

Link: https://lore.kernel.org/20260701061101.344679-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260701061101.344679-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   52 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping
+++ a/mm/page_owner.c
@@ -422,6 +422,29 @@ void __folio_copy_owner(struct folio *ne
 	rcu_read_unlock();
 }
 
+/*
+ * Check if a page is a buddy page and advance @pfn past the entire buddy block.
+ * This safely reads the buddy order without the zone lock, which may cause us
+ * to skip less than the full buddy block, but that is acceptable for page owner
+ * iteration purposes.
+ *
+ * Return: true if the page was skipped (caller should continue its loop),
+ *         false if the page is not a buddy page and should be processed normally.
+ */
+static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
+{
+	unsigned long order;
+
+	if (!PageBuddy(page))
+		return false;
+
+	order = buddy_order_unsafe(page);
+	if (order <= MAX_PAGE_ORDER)
+		*pfn += (1UL << order) - 1;
+
+	return true;
+}
+
 void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 				       pg_data_t *pgdat, struct zone *zone)
 {
@@ -461,14 +484,8 @@ void pagetypeinfo_showmixedcount_print(s
 			if (page_zone(page) != zone)
 				continue;
 
-			if (PageBuddy(page)) {
-				unsigned long freepage_order;
-
-				freepage_order = buddy_order_unsafe(page);
-				if (freepage_order <= MAX_PAGE_ORDER)
-					pfn += (1UL << freepage_order) - 1;
+			if (skip_buddy_pages(&pfn, page))
 				continue;
-			}
 
 			if (PageReserved(page))
 				continue;
@@ -697,13 +714,8 @@ read_page_owner(struct file *file, char
 		}
 
 		page = pfn_to_page(pfn);
-		if (PageBuddy(page)) {
-			unsigned long freepage_order = buddy_order_unsafe(page);
-
-			if (freepage_order <= MAX_PAGE_ORDER)
-				pfn += (1UL << freepage_order) - 1;
+		if (skip_buddy_pages(&pfn, page))
 			continue;
-		}
 
 		page_ext = page_ext_get(page);
 		if (unlikely(!page_ext))
@@ -798,20 +810,8 @@ static void init_pages_in_zone(struct zo
 			if (page_zone(page) != zone)
 				continue;
 
-			/*
-			 * To avoid having to grab zone->lock, be a little
-			 * careful when reading buddy page order. The only
-			 * danger is that we skip too much and potentially miss
-			 * some early allocated pages, which is better than
-			 * heavy lock contention.
-			 */
-			if (PageBuddy(page)) {
-				unsigned long order = buddy_order_unsafe(page);
-
-				if (order > 0 && order <= MAX_PAGE_ORDER)
-					pfn += (1UL << order) - 1;
+			if (skip_buddy_pages(&pfn, page))
 				continue;
-			}
 
 			if (PageReserved(page))
 				continue;
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

