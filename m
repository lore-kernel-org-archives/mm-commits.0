Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07946C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiEJEUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbiEJET6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C172AC6CF
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61CF961765
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FC7C385A6;
        Tue, 10 May 2022 04:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156086;
        bh=lgQJfhUZQDE89+EV8CufCGX+Z681kWAP3n7PPqRQ9bk=;
        h=Date:To:From:Subject:From;
        b=Agq4B5i+9/1/qUzdv/Fbbn/doQdd5V95sfBxkc174HR5lws4Wnz5YW8FSvIg+1Hd2
         V3HNu3tDQpcDOmXJ9T2WUYs8cSREijZPEXfbuCpnvEImUetubGLV6kIiqHbangpyci
         dFilRmHMLUp+Yg2sYyBmcOslM506jEyiClhwoLjA=
Date:   Mon, 09 May 2022 21:14:46 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch removed from -mm tree
Message-Id: <20220510041446.A0FC7C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remember exclusively mapped anonymous pages with PG_anon_exclusive
has been removed from the -mm tree.  Its filename was
     mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remember exclusively mapped anonymous pages with PG_anon_exclusive

Let's mark exclusively mapped anonymous pages with PG_anon_exclusive as
exclusive, and use that information to make GUP pins reliable and stay
consistent with the page mapped into the page table even if the page table
entry gets write-protected.

With that information at hand, we can extend our COW logic to always reuse
anonymous pages that are exclusive.  For anonymous pages that might be
shared, the existing logic applies.

As already documented, PG_anon_exclusive is usually only expressive in
combination with a page table entry.  Especially PTE vs.  PMD-mapped
anonymous pages require more thought, some examples: due to mremap() we
can easily have a single compound page PTE-mapped into multiple page
tables exclusively in a single process -- multiple page table locks apply.
Further, due to MADV_WIPEONFORK we might not necessarily write-protect
all PTEs, and only some subpages might be pinned.  Long story short: once
PTE-mapped, we have to track information about exclusivity per sub-page,
but until then, we can just track it for the compound page in the head
page and not having to update a whole bunch of subpages all of the time
for a simple PMD mapping of a THP.

For simplicity, this commit mostly talks about "anonymous pages", while
it's for THP actually "the part of an anonymous folio referenced via a
page table entry".

To not spill PG_anon_exclusive code all over the mm code-base, we let the
anon rmap code to handle all PG_anon_exclusive logic it can easily handle.

If a writable, present page table entry points at an anonymous (sub)page,
that (sub)page must be PG_anon_exclusive.  If GUP wants to take a reliably
pin (FOLL_PIN) on an anonymous page references via a present page table
entry, it must only pin if PG_anon_exclusive is set for the mapped
(sub)page.

This commit doesn't adjust GUP, so this is only implicitly handled for
FOLL_WRITE, follow-up commits will teach GUP to also respect it for
FOLL_PIN without FOLL_WRITE, to make all GUP pins of anonymous pages fully
reliable.

Whenever an anonymous page is to be shared (fork(), KSM), or when
temporarily unmapping an anonymous page (swap, migration), the relevant
PG_anon_exclusive bit has to be cleared to mark the anonymous page
possibly shared.  Clearing will fail if there are GUP pins on the page:

* For fork(), this means having to copy the page and not being able to
  share it.  fork() protects against concurrent GUP using the PT lock and
  the src_mm->write_protect_seq.

* For KSM, this means sharing will fail.  For swap this means, unmapping
  will fail, For migration this means, migration will fail early.  All
  three cases protect against concurrent GUP using the PT lock and a
  proper clear/invalidate+flush of the relevant page table entry.

This fixes memory corruptions reported for FOLL_PIN | FOLL_WRITE, when a
pinned page gets mapped R/O and the successive write fault ends up
replacing the page instead of reusing it.  It improves the situation for
O_DIRECT/vmsplice/...  that still use FOLL_GET instead of FOLL_PIN, if
fork() is *not* involved, however swapout and fork() are still
problematic.  Properly using FOLL_PIN instead of FOLL_GET for these GUP
users will fix the issue for them.

I. Details about basic handling

I.1. Fresh anonymous pages

page_add_new_anon_rmap() and hugepage_add_new_anon_rmap() will mark the
given page exclusive via __page_set_anon_rmap(exclusive=1).  As that is
the mechanism fresh anonymous pages come into life (besides migration code
where we copy the page->mapping), all fresh anonymous pages will start out
as exclusive.

I.2. COW reuse handling of anonymous pages

When a COW handler stumbles over a (sub)page that's marked exclusive, it
simply reuses it.  Otherwise, the handler tries harder under page lock to
detect if the (sub)page is exclusive and can be reused.  If exclusive,
page_move_anon_rmap() will mark the given (sub)page exclusive.

Note that hugetlb code does not yet check for PageAnonExclusive(), as it
still uses the old COW logic that is prone to the COW security issue
because hugetlb code cannot really tolerate unnecessary/wrong COW as huge
pages are a scarce resource.

I.3. Migration handling

try_to_migrate() has to try marking an exclusive anonymous page shared via
page_try_share_anon_rmap().  If it fails because there are GUP pins on the
page, unmap fails.  migrate_vma_collect_pmd() and
__split_huge_pmd_locked() are handled similarly.

Writable migration entries implicitly point at shared anonymous pages. 
For readable migration entries that information is stored via a new
"readable-exclusive" migration entry, specific to anonymous pages.

When restoring a migration entry in remove_migration_pte(), information
about exlusivity is detected via the migration entry type, and
RMAP_EXCLUSIVE is set accordingly for
page_add_anon_rmap()/hugepage_add_anon_rmap() to restore that information.

I.4. Swapout handling

try_to_unmap() has to try marking the mapped page possibly shared via
page_try_share_anon_rmap().  If it fails because there are GUP pins on the
page, unmap fails.  For now, information about exclusivity is lost.  In
the future, we might want to remember that information in the swap entry
in some cases, however, it requires more thought, care, and a way to store
that information in swap entries.

I.5. Swapin handling

do_swap_page() will never stumble over exclusive anonymous pages in the
swap cache, as try_to_migrate() prohibits that.  do_swap_page() always has
to detect manually if an anonymous page is exclusive and has to set
RMAP_EXCLUSIVE for page_add_anon_rmap() accordingly.

I.6. THP handling

__split_huge_pmd_locked() has to move the information about exclusivity
from the PMD to the PTEs.

a) In case we have a readable-exclusive PMD migration entry, simply
   insert readable-exclusive PTE migration entries.

b) In case we have a present PMD entry and we don't want to freeze
   ("convert to migration entries"), simply forward PG_anon_exclusive to
   all sub-pages, no need to temporarily clear the bit.

c) In case we have a present PMD entry and want to freeze, handle it
   similar to try_to_migrate(): try marking the page shared first.  In
   case we fail, we ignore the "freeze" instruction and simply split
   ordinarily.  try_to_migrate() will properly fail because the THP is
   still mapped via PTEs.

When splitting a compound anonymous folio (THP), the information about
exclusivity is implicitly handled via the migration entries: no need to
replicate PG_anon_exclusive manually.

I.7.  fork() handling fork() handling is relatively easy, because
PG_anon_exclusive is only expressive for some page table entry types.

a) Present anonymous pages

page_try_dup_anon_rmap() will mark the given subpage shared -- which will
fail if the page is pinned.  If it failed, we have to copy (or PTE-map a
PMD to handle it on the PTE level).

Note that device exclusive entries are just a pointer at a PageAnon()
page.  fork() will first convert a device exclusive entry to a present
page table and handle it just like present anonymous pages.

b) Device private entry

Device private entries point at PageAnon() pages that cannot be mapped
directly and, therefore, cannot get pinned.

page_try_dup_anon_rmap() will mark the given subpage shared, which cannot
fail because they cannot get pinned.

c) HW poison entries

PG_anon_exclusive will remain untouched and is stale -- the page table
entry is just a placeholder after all.

d) Migration entries

Writable and readable-exclusive entries are converted to readable entries:
possibly shared.

I.8. mprotect() handling

mprotect() only has to properly handle the new readable-exclusive
migration entry:

When write-protecting a migration entry that points at an anonymous page,
remember the information about exclusivity via the "readable-exclusive"
migration entry type.

II. Migration and GUP-fast

Whenever replacing a present page table entry that maps an exclusive
anonymous page by a migration entry, we have to mark the page possibly
shared and synchronize against GUP-fast by a proper clear/invalidate+flush
to make the following scenario impossible:

1. try_to_migrate() places a migration entry after checking for GUP pins
   and marks the page possibly shared.

2. GUP-fast pins the page due to lack of synchronization

3. fork() converts the "writable/readable-exclusive" migration entry into a
   readable migration entry

4. Migration fails due to the GUP pin (failing to freeze the refcount)

5. Migration entries are restored. PG_anon_exclusive is lost

-> We have a pinned page that is not marked exclusive anymore.

Note that we move information about exclusivity from the page to the
migration entry as it otherwise highly overcomplicates fork() and
PTE-mapping a THP.

III. Swapout and GUP-fast

Whenever replacing a present page table entry that maps an exclusive
anonymous page by a swap entry, we have to mark the page possibly shared
and synchronize against GUP-fast by a proper clear/invalidate+flush to
make the following scenario impossible:

1. try_to_unmap() places a swap entry after checking for GUP pins and
   clears exclusivity information on the page.

2. GUP-fast pins the page due to lack of synchronization.

-> We have a pinned page that is not marked exclusive anymore.

If we'd ever store information about exclusivity in the swap entry,
similar to migration handling, the same considerations as in II would
apply.  This is future work.

Link: https://lkml.kernel.org/r/20220428083441.37290-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h    |   40 +++++++++++++++++++
 include/linux/swap.h    |   15 +++++--
 include/linux/swapops.h |   25 ++++++++++++
 mm/huge_memory.c        |   78 ++++++++++++++++++++++++++++++++++----
 mm/hugetlb.c            |   15 +++++--
 mm/ksm.c                |   13 +++++-
 mm/memory.c             |   33 ++++++++++++----
 mm/migrate.c            |   14 +++++-
 mm/migrate_device.c     |   21 +++++++++-
 mm/mprotect.c           |    8 ++-
 mm/rmap.c               |   61 +++++++++++++++++++++++++++--
 11 files changed, 289 insertions(+), 34 deletions(-)

--- a/include/linux/rmap.h~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/include/linux/rmap.h
@@ -229,6 +229,13 @@ static inline int page_try_dup_anon_rmap
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 
 	/*
+	 * No need to check+clear for already shared pages, including KSM
+	 * pages.
+	 */
+	if (!PageAnonExclusive(page))
+		goto dup;
+
+	/*
 	 * If this page may have been pinned by the parent process,
 	 * don't allow to duplicate the mapping but instead require to e.g.,
 	 * copy the page immediately for the child so that we'll always
@@ -239,14 +246,47 @@ static inline int page_try_dup_anon_rmap
 	    unlikely(page_needs_cow_for_dma(vma, page))))
 		return -EBUSY;
 
+	ClearPageAnonExclusive(page);
 	/*
 	 * It's okay to share the anon page between both processes, mapping
 	 * the page R/O into both processes.
 	 */
+dup:
 	__page_dup_rmap(page, compound);
 	return 0;
 }
 
+/**
+ * page_try_share_anon_rmap - try marking an exclusive anonymous page possibly
+ *			      shared to prepare for KSM or temporary unmapping
+ * @page: the exclusive anonymous page to try marking possibly shared
+ *
+ * The caller needs to hold the PT lock and has to have the page table entry
+ * cleared/invalidated+flushed, to properly sync against GUP-fast.
+ *
+ * This is similar to page_try_dup_anon_rmap(), however, not used during fork()
+ * to duplicate a mapping, but instead to prepare for KSM or temporarily
+ * unmapping a page (swap, migration) via page_remove_rmap().
+ *
+ * Marking the page shared can only fail if the page may be pinned; device
+ * private pages cannot get pinned and consequently this function cannot fail.
+ *
+ * Returns 0 if marking the page possibly shared succeeded. Returns -EBUSY
+ * otherwise.
+ */
+static inline int page_try_share_anon_rmap(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageAnon(page) || !PageAnonExclusive(page), page);
+
+	/* See page_try_dup_anon_rmap(). */
+	if (likely(!is_device_private_page(page) &&
+	    unlikely(page_maybe_dma_pinned(page))))
+		return -EBUSY;
+
+	ClearPageAnonExclusive(page);
+	return 0;
+}
+
 /*
  * Called from mm/vmscan.c to handle paging out
  */
--- a/include/linux/swap.h~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/include/linux/swap.h
@@ -78,12 +78,19 @@ static inline int current_is_kswapd(void
 #endif
 
 /*
- * NUMA node memory migration support
+ * Page migration support.
+ *
+ * SWP_MIGRATION_READ_EXCLUSIVE is only applicable to anonymous pages and
+ * indicates that the referenced (part of) an anonymous page is exclusive to
+ * a single process. For SWP_MIGRATION_WRITE, that information is implicit:
+ * (part of) an anonymous page that are mapped writable are exclusive to a
+ * single process.
  */
 #ifdef CONFIG_MIGRATION
-#define SWP_MIGRATION_NUM 2
-#define SWP_MIGRATION_READ	(MAX_SWAPFILES + SWP_HWPOISON_NUM)
-#define SWP_MIGRATION_WRITE	(MAX_SWAPFILES + SWP_HWPOISON_NUM + 1)
+#define SWP_MIGRATION_NUM 3
+#define SWP_MIGRATION_READ (MAX_SWAPFILES + SWP_HWPOISON_NUM)
+#define SWP_MIGRATION_READ_EXCLUSIVE (MAX_SWAPFILES + SWP_HWPOISON_NUM + 1)
+#define SWP_MIGRATION_WRITE (MAX_SWAPFILES + SWP_HWPOISON_NUM + 2)
 #else
 #define SWP_MIGRATION_NUM 0
 #endif
--- a/include/linux/swapops.h~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/include/linux/swapops.h
@@ -194,6 +194,7 @@ static inline bool is_writable_device_ex
 static inline int is_migration_entry(swp_entry_t entry)
 {
 	return unlikely(swp_type(entry) == SWP_MIGRATION_READ ||
+			swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE ||
 			swp_type(entry) == SWP_MIGRATION_WRITE);
 }
 
@@ -202,11 +203,26 @@ static inline int is_writable_migration_
 	return unlikely(swp_type(entry) == SWP_MIGRATION_WRITE);
 }
 
+static inline int is_readable_migration_entry(swp_entry_t entry)
+{
+	return unlikely(swp_type(entry) == SWP_MIGRATION_READ);
+}
+
+static inline int is_readable_exclusive_migration_entry(swp_entry_t entry)
+{
+	return unlikely(swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE);
+}
+
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_MIGRATION_READ, offset);
 }
 
+static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_READ_EXCLUSIVE, offset);
+}
+
 static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_MIGRATION_WRITE, offset);
@@ -224,6 +240,11 @@ static inline swp_entry_t make_readable_
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
@@ -244,6 +265,10 @@ static inline int is_writable_migration_
 {
 	return 0;
 }
+static inline int is_readable_migration_entry(swp_entry_t entry)
+{
+	return 0;
+}
 
 #endif
 
--- a/mm/huge_memory.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/huge_memory.c
@@ -1054,7 +1054,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 
 		VM_BUG_ON(!is_pmd_migration_entry(pmd));
-		if (is_writable_migration_entry(entry)) {
+		if (!is_readable_migration_entry(entry)) {
 			entry = make_readable_migration_entry(
 							swp_offset(entry));
 			pmd = swp_entry_to_pmd(entry);
@@ -1292,6 +1292,10 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	page = pmd_page(orig_pmd);
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
+	/* Early check when only holding the PT lock. */
+	if (PageAnonExclusive(page))
+		goto reuse;
+
 	if (!trylock_page(page)) {
 		get_page(page);
 		spin_unlock(vmf->ptl);
@@ -1306,6 +1310,12 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 		put_page(page);
 	}
 
+	/* Recheck after temporarily dropping the PT lock. */
+	if (PageAnonExclusive(page)) {
+		unlock_page(page);
+		goto reuse;
+	}
+
 	/*
 	 * See do_wp_page(): we can only map the page writable if there are
 	 * no additional references. Note that we always drain the LRU
@@ -1319,11 +1329,12 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 		pmd_t entry;
 
 		page_move_anon_rmap(page, vma);
+		unlock_page(page);
+reuse:
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
 			update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
-		unlock_page(page);
 		spin_unlock(vmf->ptl);
 		return VM_FAULT_WRITE;
 	}
@@ -1708,6 +1719,7 @@ int change_huge_pmd(struct vm_area_struc
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
+		struct page *page = pfn_swap_entry_to_page(entry);
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
@@ -1716,8 +1728,10 @@ int change_huge_pmd(struct vm_area_struc
 			 * A protection check is difficult so
 			 * just be safe and disable write
 			 */
-			entry = make_readable_migration_entry(
-							swp_offset(entry));
+			if (PageAnon(page))
+				entry = make_readable_exclusive_migration_entry(swp_offset(entry));
+			else
+				entry = make_readable_migration_entry(swp_offset(entry));
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
@@ -1937,6 +1951,7 @@ static void __split_huge_pmd_locked(stru
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
 	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
+	bool anon_exclusive = false;
 	unsigned long addr;
 	int i;
 
@@ -2018,6 +2033,8 @@ static void __split_huge_pmd_locked(stru
 		entry = pmd_to_swp_entry(old_pmd);
 		page = pfn_swap_entry_to_page(entry);
 		write = is_writable_migration_entry(entry);
+		if (PageAnon(page))
+			anon_exclusive = is_readable_exclusive_migration_entry(entry);
 		young = false;
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
@@ -2029,8 +2046,26 @@ static void __split_huge_pmd_locked(stru
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
 		uffd_wp = pmd_uffd_wp(old_pmd);
+
 		VM_BUG_ON_PAGE(!page_count(page), page);
 		page_ref_add(page, HPAGE_PMD_NR - 1);
+
+		/*
+		 * Without "freeze", we'll simply split the PMD, propagating the
+		 * PageAnonExclusive() flag for each PTE by setting it for
+		 * each subpage -- no need to (temporarily) clear.
+		 *
+		 * With "freeze" we want to replace mapped pages by
+		 * migration entries right away. This is only possible if we
+		 * managed to clear PageAnonExclusive() -- see
+		 * set_pmd_migration_entry().
+		 *
+		 * In case we cannot clear PageAnonExclusive(), split the PMD
+		 * only and let try_to_migrate_one() fail later.
+		 */
+		anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
+			freeze = false;
 	}
 
 	/*
@@ -2052,6 +2087,9 @@ static void __split_huge_pmd_locked(stru
 			if (write)
 				swp_entry = make_writable_migration_entry(
 							page_to_pfn(page + i));
+			else if (anon_exclusive)
+				swp_entry = make_readable_exclusive_migration_entry(
+							page_to_pfn(page + i));
 			else
 				swp_entry = make_readable_migration_entry(
 							page_to_pfn(page + i));
@@ -2063,6 +2101,8 @@ static void __split_huge_pmd_locked(stru
 		} else {
 			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
 			entry = maybe_mkwrite(entry, vma);
+			if (anon_exclusive)
+				SetPageAnonExclusive(page + i);
 			if (!write)
 				entry = pte_wrprotect(entry);
 			if (!young)
@@ -2294,6 +2334,13 @@ static void __split_huge_page_tail(struc
 	 *
 	 * After successful get_page_unless_zero() might follow flags change,
 	 * for example lock_page() which set PG_waiters.
+	 *
+	 * Note that for mapped sub-pages of an anonymous THP,
+	 * PG_anon_exclusive has been cleared in unmap_page() and is stored in
+	 * the migration entry instead from where remap_page() will restore it.
+	 * We can still have PG_anon_exclusive set on effectively unmapped and
+	 * unreferenced sub-pages of an anonymous THP: we can simply drop
+	 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
 	 */
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
@@ -3030,6 +3077,7 @@ void set_pmd_migration_entry(struct page
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
+	bool anon_exclusive;
 	pmd_t pmdval;
 	swp_entry_t entry;
 	pmd_t pmdswp;
@@ -3039,10 +3087,19 @@ void set_pmd_migration_entry(struct page
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
 	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
+
+	anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+	if (anon_exclusive && page_try_share_anon_rmap(page)) {
+		set_pmd_at(mm, address, pvmw->pmd, pmdval);
+		return;
+	}
+
 	if (pmd_dirty(pmdval))
 		set_page_dirty(page);
 	if (pmd_write(pmdval))
 		entry = make_writable_migration_entry(page_to_pfn(page));
+	else if (anon_exclusive)
+		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
 	else
 		entry = make_readable_migration_entry(page_to_pfn(page));
 	pmdswp = swp_entry_to_pmd(entry);
@@ -3076,10 +3133,17 @@ void remove_migration_pmd(struct page_vm
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
-	if (PageAnon(new))
-		page_add_anon_rmap(new, vma, mmun_start, RMAP_COMPOUND);
-	else
+	if (PageAnon(new)) {
+		rmap_t rmap_flags = RMAP_COMPOUND;
+
+		if (!is_readable_migration_entry(entry))
+			rmap_flags |= RMAP_EXCLUSIVE;
+
+		page_add_anon_rmap(new, vma, mmun_start, rmap_flags);
+	} else {
 		page_add_file_rmap(new, vma, true);
+	}
+	VM_BUG_ON(pmd_write(pmde) && PageAnon(new) && !PageAnonExclusive(new));
 	set_pmd_at(mm, mmun_start, pvmw->pmd, pmde);
 
 	/* No need to invalidate - it was non-present before */
--- a/mm/hugetlb.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/hugetlb.c
@@ -4790,7 +4790,7 @@ again:
 				    is_hugetlb_entry_hwpoisoned(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
 
-			if (is_writable_migration_entry(swp_entry) && cow) {
+			if (!is_readable_migration_entry(swp_entry) && cow) {
 				/*
 				 * COW mappings require pages in both
 				 * parent and child to be set to read.
@@ -5190,6 +5190,8 @@ retry_avoidcopy:
 		set_huge_ptep_writable(vma, haddr, ptep);
 		return 0;
 	}
+	VM_BUG_ON_PAGE(PageAnon(old_page) && PageAnonExclusive(old_page),
+		       old_page);
 
 	/*
 	 * If the process that created a MAP_PRIVATE mapping is about to
@@ -6187,12 +6189,17 @@ unsigned long hugetlb_change_protection(
 		}
 		if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
+			struct page *page = pfn_swap_entry_to_page(entry);
 
-			if (is_writable_migration_entry(entry)) {
+			if (!is_readable_migration_entry(entry)) {
 				pte_t newpte;
 
-				entry = make_readable_migration_entry(
-							swp_offset(entry));
+				if (PageAnon(page))
+					entry = make_readable_exclusive_migration_entry(
+								swp_offset(entry));
+				else
+					entry = make_readable_migration_entry(
+								swp_offset(entry));
 				newpte = swp_entry_to_pte(entry);
 				set_huge_swap_pte_at(mm, address, ptep,
 						     newpte, huge_page_size(h));
--- a/mm/ksm.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/ksm.c
@@ -872,6 +872,7 @@ static inline struct stable_node *page_s
 static inline void set_page_stable_node(struct page *page,
 					struct stable_node *stable_node)
 {
+	VM_BUG_ON_PAGE(PageAnon(page) && PageAnonExclusive(page), page);
 	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
 }
 
@@ -1044,6 +1045,7 @@ static int write_protect_page(struct vm_
 	int swapped;
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
+	bool anon_exclusive;
 
 	pvmw.address = page_address_in_vma(page, vma);
 	if (pvmw.address == -EFAULT)
@@ -1061,9 +1063,10 @@ static int write_protect_page(struct vm_
 	if (WARN_ONCE(!pvmw.pte, "Unexpected PMD mapping?"))
 		goto out_unlock;
 
+	anon_exclusive = PageAnonExclusive(page);
 	if (pte_write(*pvmw.pte) || pte_dirty(*pvmw.pte) ||
 	    (pte_protnone(*pvmw.pte) && pte_savedwrite(*pvmw.pte)) ||
-						mm_tlb_flush_pending(mm)) {
+	    anon_exclusive || mm_tlb_flush_pending(mm)) {
 		pte_t entry;
 
 		swapped = PageSwapCache(page);
@@ -1091,6 +1094,12 @@ static int write_protect_page(struct vm_
 			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
 		}
+
+		if (anon_exclusive && page_try_share_anon_rmap(page)) {
+			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
+			goto out_unlock;
+		}
+
 		if (pte_dirty(entry))
 			set_page_dirty(page);
 
@@ -1149,6 +1158,8 @@ static int replace_page(struct vm_area_s
 		pte_unmap_unlock(ptep, ptl);
 		goto out_mn;
 	}
+	VM_BUG_ON_PAGE(PageAnonExclusive(page), page);
+	VM_BUG_ON_PAGE(PageAnon(kpage) && PageAnonExclusive(kpage), kpage);
 
 	/*
 	 * No need to check ksm_use_zero_pages here: we can only have a
--- a/mm/memory.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/memory.c
@@ -720,6 +720,8 @@ static void restore_exclusive_pte(struct
 	else if (is_writable_device_exclusive_entry(entry))
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 
+	VM_BUG_ON(pte_write(pte) && !(PageAnon(page) && PageAnonExclusive(page)));
+
 	/*
 	 * No need to take a page reference as one was already
 	 * created when the swap entry was made.
@@ -796,11 +798,12 @@ copy_nonpresent_pte(struct mm_struct *ds
 
 		rss[mm_counter(page)]++;
 
-		if (is_writable_migration_entry(entry) &&
+		if (!is_readable_migration_entry(entry) &&
 				is_cow_mapping(vm_flags)) {
 			/*
-			 * COW mappings require pages in both
-			 * parent and child to be set to read.
+			 * COW mappings require pages in both parent and child
+			 * to be set to read. A previously exclusive entry is
+			 * now shared.
 			 */
 			entry = make_readable_migration_entry(
 							swp_offset(entry));
@@ -951,6 +954,7 @@ copy_present_pte(struct vm_area_struct *
 		ptep_set_wrprotect(src_mm, addr, src_pte);
 		pte = pte_wrprotect(pte);
 	}
+	VM_BUG_ON(page && PageAnon(page) && PageAnonExclusive(page));
 
 	/*
 	 * If it's a shared mapping, mark it clean in
@@ -2949,6 +2953,9 @@ static inline void wp_page_reuse(struct
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = vmf->page;
 	pte_t entry;
+
+	VM_BUG_ON(PageAnon(page) && !PageAnonExclusive(page));
+
 	/*
 	 * Clear the pages cpupid information as the existing
 	 * information potentially belongs to a now completely
@@ -3274,6 +3281,13 @@ static vm_fault_t do_wp_page(struct vm_f
 		struct page *page = vmf->page;
 
 		/*
+		 * If the page is exclusive to this process we must reuse the
+		 * page without further checks.
+		 */
+		if (PageAnonExclusive(page))
+			goto reuse;
+
+		/*
 		 * We have to verify under page lock: these early checks are
 		 * just an optimization to avoid locking the page and freeing
 		 * the swapcache if there is little hope that we can reuse.
@@ -3305,6 +3319,7 @@ static vm_fault_t do_wp_page(struct vm_f
 		 */
 		page_move_anon_rmap(page, vma);
 		unlock_page(page);
+reuse:
 		wp_page_reuse(vmf);
 		return VM_FAULT_WRITE;
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
@@ -3696,11 +3711,12 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * that are certainly not shared because we just allocated them without
 	 * exposing them to the swapcache.
 	 */
-	if ((vmf->flags & FAULT_FLAG_WRITE) && !PageKsm(page) &&
-	    (page != swapcache || page_count(page) == 1)) {
-		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
-		vmf->flags &= ~FAULT_FLAG_WRITE;
-		ret |= VM_FAULT_WRITE;
+	if (!PageKsm(page) && (page != swapcache || page_count(page) == 1)) {
+		if (vmf->flags & FAULT_FLAG_WRITE) {
+			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
+			vmf->flags &= ~FAULT_FLAG_WRITE;
+			ret |= VM_FAULT_WRITE;
+		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
 	flush_icache_page(vma, page);
@@ -3720,6 +3736,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
 	}
 
+	VM_BUG_ON(!PageAnon(page) || (pte_write(pte) && !PageAnonExclusive(page)));
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
 
--- a/mm/migrate.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/migrate.c
@@ -177,6 +177,7 @@ static bool remove_migration_pte(struct
 	DEFINE_FOLIO_VMA_WALK(pvmw, old, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		rmap_t rmap_flags = RMAP_NONE;
 		pte_t pte;
 		swp_entry_t entry;
 		struct page *new;
@@ -211,6 +212,9 @@ static bool remove_migration_pte(struct
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
 
+		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
+			rmap_flags |= RMAP_EXCLUSIVE;
+
 		if (unlikely(is_device_private_page(new))) {
 			if (pte_write(pte))
 				entry = make_writable_device_private_entry(
@@ -233,7 +237,7 @@ static bool remove_migration_pte(struct
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
 				hugepage_add_anon_rmap(new, vma, pvmw.address,
-						       RMAP_NONE);
+						       rmap_flags);
 			else
 				page_dup_file_rmap(new, true);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
@@ -242,7 +246,7 @@ static bool remove_migration_pte(struct
 		{
 			if (folio_test_anon(folio))
 				page_add_anon_rmap(new, vma, pvmw.address,
-						   RMAP_NONE);
+						   rmap_flags);
 			else
 				page_add_file_rmap(new, vma, false);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
@@ -514,6 +518,12 @@ void folio_migrate_flags(struct folio *n
 		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
+	/*
+	 * PG_anon_exclusive (-> PG_mappedtodisk) is always migrated via
+	 * migration entries. We can still have PG_anon_exclusive set on an
+	 * effectively unmapped and unreferenced first sub-pages of an
+	 * anonymous THP: we can simply copy it here via PG_mappedtodisk.
+	 */
 	if (folio_test_mappedtodisk(folio))
 		folio_set_mappedtodisk(newfolio);
 
--- a/mm/migrate_device.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/migrate_device.c
@@ -184,15 +184,34 @@ again:
 		 * set up a special migration page table entry now.
 		 */
 		if (trylock_page(page)) {
+			bool anon_exclusive;
 			pte_t swp_pte;
 
+			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+			if (anon_exclusive) {
+				flush_cache_page(vma, addr, pte_pfn(*ptep));
+				ptep_clear_flush(vma, addr, ptep);
+
+				if (page_try_share_anon_rmap(page)) {
+					set_pte_at(mm, addr, ptep, pte);
+					unlock_page(page);
+					put_page(page);
+					mpfn = 0;
+					goto next;
+				}
+			} else {
+				ptep_get_and_clear(mm, addr, ptep);
+			}
+
 			migrate->cpages++;
-			ptep_get_and_clear(mm, addr, ptep);
 
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
 				entry = make_writable_migration_entry(
 							page_to_pfn(page));
+			else if (anon_exclusive)
+				entry = make_readable_exclusive_migration_entry(
+							page_to_pfn(page));
 			else
 				entry = make_readable_migration_entry(
 							page_to_pfn(page));
--- a/mm/mprotect.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/mprotect.c
@@ -152,6 +152,7 @@ static unsigned long change_pte_range(st
 			pages++;
 		} else if (is_swap_pte(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
+			struct page *page = pfn_swap_entry_to_page(entry);
 			pte_t newpte;
 
 			if (is_writable_migration_entry(entry)) {
@@ -159,8 +160,11 @@ static unsigned long change_pte_range(st
 				 * A protection check is difficult so
 				 * just be safe and disable write
 				 */
-				entry = make_readable_migration_entry(
-							swp_offset(entry));
+				if (PageAnon(page))
+					entry = make_readable_exclusive_migration_entry(
+							     swp_offset(entry));
+				else
+					entry = make_readable_migration_entry(swp_offset(entry));
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(oldpte))
 					newpte = pte_swp_mksoft_dirty(newpte);
--- a/mm/rmap.c~mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive
+++ a/mm/rmap.c
@@ -1088,6 +1088,7 @@ int pfn_mkclean_range(unsigned long pfn,
 void page_move_anon_rmap(struct page *page, struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
+	struct page *subpage = page;
 
 	page = compound_head(page);
 
@@ -1101,6 +1102,7 @@ void page_move_anon_rmap(struct page *pa
 	 * folio_test_anon()) will not see one without the other.
 	 */
 	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
+	SetPageAnonExclusive(subpage);
 }
 
 /**
@@ -1118,7 +1120,7 @@ static void __page_set_anon_rmap(struct
 	BUG_ON(!anon_vma);
 
 	if (PageAnon(page))
-		return;
+		goto out;
 
 	/*
 	 * If the page isn't exclusively mapped into this vma,
@@ -1137,6 +1139,9 @@ static void __page_set_anon_rmap(struct
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 	page->index = linear_page_index(vma, address);
+out:
+	if (exclusive)
+		SetPageAnonExclusive(page);
 }
 
 /**
@@ -1198,6 +1203,8 @@ void page_add_anon_rmap(struct page *pag
 	} else {
 		first = atomic_inc_and_test(&page->_mapcount);
 	}
+	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
+	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
 
 	if (first) {
 		int nr = compound ? thp_nr_pages(page) : 1;
@@ -1459,7 +1466,7 @@ static bool try_to_unmap_one(struct foli
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	pte_t pteval;
 	struct page *subpage;
-	bool ret = true;
+	bool anon_exclusive, ret = true;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 
@@ -1515,6 +1522,8 @@ static bool try_to_unmap_one(struct foli
 		subpage = folio_page(folio,
 					pte_pfn(*pvmw.pte) - folio_pfn(folio));
 		address = pvmw.address;
+		anon_exclusive = folio_test_anon(folio) &&
+				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 			/*
@@ -1550,9 +1559,12 @@ static bool try_to_unmap_one(struct foli
 			}
 		}
 
-		/* Nuke the page table entry. */
+		/*
+		 * Nuke the page table entry. When having to clear
+		 * PageAnonExclusive(), we always have to flush.
+		 */
 		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
-		if (should_defer_flush(mm, flags)) {
+		if (should_defer_flush(mm, flags) && !anon_exclusive) {
 			/*
 			 * We clear the PTE but do not flush so potentially
 			 * a remote CPU could still be writing to the folio.
@@ -1677,6 +1689,24 @@ static bool try_to_unmap_one(struct foli
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
+			if (anon_exclusive &&
+			    page_try_share_anon_rmap(subpage)) {
+				swap_free(entry);
+				set_pte_at(mm, address, pvmw.pte, pteval);
+				ret = false;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
+			/*
+			 * Note: We *don't* remember yet if the page was mapped
+			 * exclusively in the swap entry, so swapin code has
+			 * to re-determine that manually and might detect the
+			 * page as possibly shared, for example, if there are
+			 * other references on the page or if the page is under
+			 * writeback. We made sure that there are no GUP pins
+			 * on the page that would rely on it, so for GUP pins
+			 * this is fine.
+			 */
 			if (list_empty(&mm->mmlist)) {
 				spin_lock(&mmlist_lock);
 				if (list_empty(&mm->mmlist))
@@ -1776,7 +1806,7 @@ static bool try_to_migrate_one(struct fo
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	pte_t pteval;
 	struct page *subpage;
-	bool ret = true;
+	bool anon_exclusive, ret = true;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 
@@ -1837,6 +1867,8 @@ static bool try_to_migrate_one(struct fo
 		subpage = folio_page(folio,
 				pte_pfn(*pvmw.pte) - folio_pfn(folio));
 		address = pvmw.address;
+		anon_exclusive = folio_test_anon(folio) &&
+				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 			/*
@@ -1888,6 +1920,9 @@ static bool try_to_migrate_one(struct fo
 			swp_entry_t entry;
 			pte_t swp_pte;
 
+			if (anon_exclusive)
+				BUG_ON(page_try_share_anon_rmap(subpage));
+
 			/*
 			 * Store the pfn of the page in a special migration
 			 * pte. do_swap_page() will wait until the migration
@@ -1896,6 +1931,8 @@ static bool try_to_migrate_one(struct fo
 			entry = pte_to_swp_entry(pteval);
 			if (is_writable_device_private_entry(entry))
 				entry = make_writable_migration_entry(pfn);
+			else if (anon_exclusive)
+				entry = make_readable_exclusive_migration_entry(pfn);
 			else
 				entry = make_readable_migration_entry(pfn);
 			swp_pte = swp_entry_to_pte(entry);
@@ -1960,6 +1997,15 @@ static bool try_to_migrate_one(struct fo
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
+			VM_BUG_ON_PAGE(pte_write(pteval) && folio_test_anon(folio) &&
+				       !anon_exclusive, subpage);
+			if (anon_exclusive &&
+			    page_try_share_anon_rmap(subpage)) {
+				set_pte_at(mm, address, pvmw.pte, pteval);
+				ret = false;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
 
 			/*
 			 * Store the pfn of the page in a special migration
@@ -1969,6 +2015,9 @@ static bool try_to_migrate_one(struct fo
 			if (pte_write(pteval))
 				entry = make_writable_migration_entry(
 							page_to_pfn(subpage));
+			else if (anon_exclusive)
+				entry = make_readable_exclusive_migration_entry(
+							page_to_pfn(subpage));
 			else
 				entry = make_readable_migration_entry(
 							page_to_pfn(subpage));
@@ -2405,6 +2454,8 @@ void hugepage_add_anon_rmap(struct page
 	BUG_ON(!anon_vma);
 	/* address might be in next vma when migration races vma_adjust */
 	first = atomic_inc_and_test(compound_mapcount_ptr(page));
+	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
+	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
 	if (first)
 		__page_set_anon_rmap(page, vma, address,
 				     !!(flags & RMAP_EXCLUSIVE));
_

Patches currently in -mm which might be from david@redhat.com are


