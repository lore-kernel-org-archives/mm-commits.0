From: akpm@linux-foundation.org
Subject: + rmap-introduce-rmap_walk_locked.patch added to -mm tree
Date: Mon, 07 Mar 2016 14:43:21 -0800
Message-ID: <56de0409.q9tvlLNuAkMk30LQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbcCGWnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2016 17:43:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: introduce rmap_walk_locked()
has been added to the -mm tree.  Its filename is
     rmap-introduce-rmap_walk_locked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rmap-introduce-rmap_walk_locked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rmap-introduce-rmap_walk_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: rmap: introduce rmap_walk_locked()

This patchset rewrites freeze_page() and unfreeze_page() using
try_to_unmap() and remove_migration_ptes().  Result is much simpler, but
somewhat slower.

Migration 8GiB worth of PMD-mapped THP:

Baseline	20.21 +/- 0.393
Patched		20.73 +/- 0.082
Slowdown	1.03x

It's 3% slower, comparing to 14% in v1. I don't it should be a stopper.

Splitting of PTE-mapped pages slowed more.  But this is not a common case.

Migration 8GiB worth of PMD-mapped THP:

Baseline	20.39 +/- 0.225
Patched		22.43 +/- 0.496
Slowdown	1.10x



rmap_walk_locked() is the same as rmap_walk(), but the caller takes care
of the relevant rmap lock.

This is preparation for switching THP splitting from custom rmap walk in
freeze_page()/unfreeze_page() to the generic one.

There is no support for KSM pages for now: not clear which lock is implied.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 +
 mm/rmap.c            |   41 ++++++++++++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 9 deletions(-)

diff -puN include/linux/rmap.h~rmap-introduce-rmap_walk_locked include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-introduce-rmap_walk_locked
+++ a/include/linux/rmap.h
@@ -266,6 +266,7 @@ struct rmap_walk_control {
 };
 
 int rmap_walk(struct page *page, struct rmap_walk_control *rwc);
+int rmap_walk_locked(struct page *page, struct rmap_walk_control *rwc);
 
 #else	/* !CONFIG_MMU */
 
diff -puN mm/rmap.c~rmap-introduce-rmap_walk_locked mm/rmap.c
--- a/mm/rmap.c~rmap-introduce-rmap_walk_locked
+++ a/mm/rmap.c
@@ -1715,14 +1715,21 @@ static struct anon_vma *rmap_walk_anon_l
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
  */
-static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
+static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc,
+		bool locked)
 {
 	struct anon_vma *anon_vma;
 	pgoff_t pgoff;
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
-	anon_vma = rmap_walk_anon_lock(page, rwc);
+	if (locked) {
+		anon_vma = page_anon_vma(page);
+		/* anon_vma disappear under us? */
+		VM_BUG_ON_PAGE(!anon_vma, page);
+	} else {
+		anon_vma = rmap_walk_anon_lock(page, rwc);
+	}
 	if (!anon_vma)
 		return ret;
 
@@ -1742,7 +1749,9 @@ static int rmap_walk_anon(struct page *p
 		if (rwc->done && rwc->done(page))
 			break;
 	}
-	anon_vma_unlock_read(anon_vma);
+
+	if (!locked)
+		anon_vma_unlock_read(anon_vma);
 	return ret;
 }
 
@@ -1759,9 +1768,10 @@ static int rmap_walk_anon(struct page *p
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
  */
-static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
+static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc,
+		bool locked)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping(page);
 	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
@@ -1778,7 +1788,8 @@ static int rmap_walk_file(struct page *p
 		return ret;
 
 	pgoff = page_to_pgoff(page);
-	i_mmap_lock_read(mapping);
+	if (!locked)
+		i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 
@@ -1795,7 +1806,8 @@ static int rmap_walk_file(struct page *p
 	}
 
 done:
-	i_mmap_unlock_read(mapping);
+	if (!locked)
+		i_mmap_unlock_read(mapping);
 	return ret;
 }
 
@@ -1804,9 +1816,20 @@ int rmap_walk(struct page *page, struct
 	if (unlikely(PageKsm(page)))
 		return rmap_walk_ksm(page, rwc);
 	else if (PageAnon(page))
-		return rmap_walk_anon(page, rwc);
+		return rmap_walk_anon(page, rwc, false);
+	else
+		return rmap_walk_file(page, rwc, false);
+}
+
+/* Like rmap_walk, but caller holds relevant rmap lock */
+int rmap_walk_locked(struct page *page, struct rmap_walk_control *rwc)
+{
+	/* no ksm support for now */
+	VM_BUG_ON_PAGE(PageKsm(page), page);
+	if (PageAnon(page))
+		return rmap_walk_anon(page, rwc, true);
 	else
-		return rmap_walk_file(page, rwc);
+		return rmap_walk_file(page, rwc, true);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-thp-fix-migration-of-pte-mapped-transparent-huge-pages.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-cleanup-pte_alloc-interfaces.patch
rmap-introduce-rmap_walk_locked.patch
rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page.patch
mm-make-remove_migration_ptes-beyond-mm-migrationc.patch
thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

