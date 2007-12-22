From: akpm@linux-foundation.org
Subject: + mm-fix-pageuptodate-memory-ordering-bug.patch added to -mm tree
Date: Sat, 22 Dec 2007 00:57:58 -0800
Message-ID: <200712220857.lBM8vwwg025610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbXLVI6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: fix PageUptodate memory ordering bug
has been added to the -mm tree.  Its filename is
     mm-fix-pageuptodate-memory-ordering-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix PageUptodate memory ordering bug
From: Nick Piggin <npiggin@suse.de>

After running SetPageUptodate, preceding stores to the page contents to
actually bring it uptodate may not be ordered with the store to set the
page uptodate.

Therefore, another CPU which checks PageUptodate is true, then reads the
page contents can get stale data.

Fix this by having an smp_wmb before SetPageUptodate, and smp_rmb after
PageUptodate.

Many places that test PageUptodate, do so with the page locked, and this
would be enough to ensure memory ordering in those places if
SetPageUptodate were only called while the page is locked.  Unfortunately
that is not always the case for some filesystems, but it could be an idea
for the future.

One thing I like about it is that it brings the handling of anonymous page
uptodateness in line with that of file backed page management, by marking
anon pages as uptodate when they _are_ uptodate, rather than when our
implementation requires that they be marked as such.  Doing this allows us
to get rid of the smp_wmb's in the page copying functions, which were
especially added for anonymous pages for an analogous memory ordering
problem, and are now handled with the same code as the PageUptodate memory
ordering problem.

Introduce a SetNewPageUptodate for these anonymous pages: it contains non
atomic bitops so as not to introduce too much overhead into these paths.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h    |    4 ---
 include/linux/page-flags.h |   42 ++++++++++++++++++++++++++++++++---
 mm/hugetlb.c               |    2 +
 mm/memory.c                |    9 ++++---
 mm/page_io.c               |    2 -
 mm/swap_state.c            |    2 -
 6 files changed, 48 insertions(+), 13 deletions(-)

diff -puN include/linux/highmem.h~mm-fix-pageuptodate-memory-ordering-bug include/linux/highmem.h
--- a/include/linux/highmem.h~mm-fix-pageuptodate-memory-ordering-bug
+++ a/include/linux/highmem.h
@@ -68,8 +68,6 @@ static inline void clear_user_highpage(s
 	void *addr = kmap_atomic(page, KM_USER0);
 	clear_user_page(addr, vaddr, page);
 	kunmap_atomic(addr, KM_USER0);
-	/* Make sure this page is cleared on other CPU's too before using it */
-	smp_wmb();
 }
 
 #ifndef __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
@@ -160,8 +158,6 @@ static inline void copy_user_highpage(st
 	copy_user_page(vto, vfrom, vaddr, to);
 	kunmap_atomic(vfrom, KM_USER0);
 	kunmap_atomic(vto, KM_USER1);
-	/* Make sure this page is cleared on other CPU's too before using it */
-	smp_wmb();
 }
 
 #endif
diff -puN include/linux/page-flags.h~mm-fix-pageuptodate-memory-ordering-bug include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-fix-pageuptodate-memory-ordering-bug
+++ a/include/linux/page-flags.h
@@ -131,16 +131,52 @@
 #define ClearPageReferenced(page)	clear_bit(PG_referenced, &(page)->flags)
 #define TestClearPageReferenced(page) test_and_clear_bit(PG_referenced, &(page)->flags)
 
-#define PageUptodate(page)	test_bit(PG_uptodate, &(page)->flags)
+static inline int PageUptodate(struct page *page)
+{
+	int ret = test_bit(PG_uptodate, &(page)->flags);
+
+	/*
+	 * Must ensure that the data we read out of the page is loaded
+	 * _after_ we've loaded page->flags to check for PageUptodate.
+	 * We can skip the barrier if the page is not uptodate, because
+	 * we wouldn't be reading anything from it.
+	 *
+	 * See SetPageUptodate() for the other side of the story.
+	 */
+	if (ret)
+		smp_rmb();
+
+	return ret;
+}
+
+static inline void SetNewPageUptodate(struct page *page)
+{
+	smp_wmb();
+	__set_bit(PG_uptodate, &(page)->flags);
 #ifdef CONFIG_S390
+	page_clear_dirty(page);
+#endif
+}
+
 static inline void SetPageUptodate(struct page *page)
 {
+#ifdef CONFIG_S390
 	if (!test_and_set_bit(PG_uptodate, &page->flags))
 		page_clear_dirty(page);
-}
 #else
-#define SetPageUptodate(page)	set_bit(PG_uptodate, &(page)->flags)
+	/*
+	 * Memory barrier must be issued before setting the PG_uptodate bit,
+	 * so that all previous stores issued in order to bring the page
+	 * uptodate are actually visible before PageUptodate becomes true.
+	 *
+	 * s390 doesn't need an explicit smp_wmb here because the test and
+	 * set bit already provides full barriers.
+	 */
+	smp_wmb();
+	set_bit(PG_uptodate, &(page)->flags);
 #endif
+}
+
 #define ClearPageUptodate(page)	clear_bit(PG_uptodate, &(page)->flags)
 
 #define PageDirty(page)		test_bit(PG_dirty, &(page)->flags)
diff -puN mm/hugetlb.c~mm-fix-pageuptodate-memory-ordering-bug mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-pageuptodate-memory-ordering-bug
+++ a/mm/hugetlb.c
@@ -803,6 +803,7 @@ static int hugetlb_cow(struct mm_struct 
 
 	spin_unlock(&mm->page_table_lock);
 	copy_huge_page(new_page, old_page, address, vma);
+	SetNewPageUptodate(new_page);
 	spin_lock(&mm->page_table_lock);
 
 	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
@@ -848,6 +849,7 @@ retry:
 			goto out;
 		}
 		clear_huge_page(page, address);
+		SetNewPageUptodate(page);
 
 		if (vma->vm_flags & VM_SHARED) {
 			int err;
diff -puN mm/memory.c~mm-fix-pageuptodate-memory-ordering-bug mm/memory.c
--- a/mm/memory.c~mm-fix-pageuptodate-memory-ordering-bug
+++ a/mm/memory.c
@@ -1515,10 +1515,8 @@ static inline void cow_user_page(struct 
 			memset(kaddr, 0, PAGE_SIZE);
 		kunmap_atomic(kaddr, KM_USER0);
 		flush_dcache_page(dst);
-		return;
-
-	}
-	copy_user_highpage(dst, src, va, vma);
+	} else
+		copy_user_highpage(dst, src, va, vma);
 }
 
 /*
@@ -1627,6 +1625,7 @@ gotten:
 	if (!new_page)
 		goto oom;
 	cow_user_page(new_page, old_page, address, vma);
+	SetNewPageUptodate(new_page);
 
 	/*
 	 * Re-check the pte - we dropped the lock
@@ -2158,6 +2157,7 @@ static int do_anonymous_page(struct mm_s
 	page = alloc_zeroed_user_highpage_movable(vma, address);
 	if (!page)
 		goto oom;
+	SetNewPageUptodate(page);
 
 	entry = mk_pte(page, vma->vm_page_prot);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -2258,6 +2258,7 @@ static int __do_fault(struct mm_struct *
 				goto out;
 			}
 			copy_user_highpage(page, vmf.page, address, vma);
+			SetNewPageUptodate(page);
 		} else {
 			/*
 			 * If the page will be shareable, see if the backing
diff -puN mm/page_io.c~mm-fix-pageuptodate-memory-ordering-bug mm/page_io.c
--- a/mm/page_io.c~mm-fix-pageuptodate-memory-ordering-bug
+++ a/mm/page_io.c
@@ -126,7 +126,7 @@ int swap_readpage(struct file *file, str
 	int ret = 0;
 
 	BUG_ON(!PageLocked(page));
-	ClearPageUptodate(page);
+	BUG_ON(PageUptodate(page));
 	bio = get_swap_bio(GFP_KERNEL, page_private(page), page,
 				end_swap_bio_read);
 	if (bio == NULL) {
diff -puN mm/swap_state.c~mm-fix-pageuptodate-memory-ordering-bug mm/swap_state.c
--- a/mm/swap_state.c~mm-fix-pageuptodate-memory-ordering-bug
+++ a/mm/swap_state.c
@@ -152,6 +152,7 @@ int add_to_swap(struct page * page, gfp_
 	int err;
 
 	BUG_ON(!PageLocked(page));
+	BUG_ON(!PageUptodate(page));
 
 	for (;;) {
 		entry = get_swap_page();
@@ -174,7 +175,6 @@ int add_to_swap(struct page * page, gfp_
 
 		switch (err) {
 		case 0:				/* Success */
-			SetPageUptodate(page);
 			SetPageDirty(page);
 			INC_CACHE_INFO(add_total);
 			return 1;
_

Patches currently in -mm which might be from npiggin@suse.de are

git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-sched.patch
sg-nopage.patch
git-x86.patch
mm-fix-pageuptodate-memory-ordering-bug.patch
slub-use-non-atomic-bit-unlock.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-radix_tree_preloading.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
