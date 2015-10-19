From: akpm@linux-foundation.org
Subject: + mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
 added to -mm tree
Date: Mon, 19 Oct 2015 15:03:22 -0700
Message-ID: <562568aa.KRUkjPDU7HI62RoS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbJSWDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap use pte lock not mmap_sem to set PageMlocked
has been added to the -mm tree.  Its filename is
     mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: rmap use pte lock not mmap_sem to set PageMlocked

KernelThreadSanitizer (ktsan) has shown that the down_read_trylock() of
mmap_sem in try_to_unmap_one() (when going to set PageMlocked on a page
found mapped in a VM_LOCKED vma) is ineffective against races with
exit_mmap()'s munlock_vma_pages_all(), because mmap_sem is not held when
tearing down an mm.

But that's okay, those races are benign; and although we've believed for
years in that ugly down_read_trylock(), it's unsuitable for the job, and
frustrates the good intention of setting PageMlocked when it fails.

It just doesn't matter if here we read vm_flags an instant before or after
a racing mlock() or munlock() or exit_mmap() sets or clears VM_LOCKED: the
syscalls (or exit) work their way up the address space (taking pt locks
after updating vm_flags) to establish the final state.

We do still need to be careful never to mark a page Mlocked (hence
unevictable) by any race that will not be corrected shortly after.  The
page lock protects from many of the races, but not all (a page is not
necessarily locked when it's unmapped).  But the pte lock we just dropped
is good to cover the rest (and serializes even with
munlock_vma_pages_all(), so no special barriers required): now hold on to
the pte lock while calling mlock_vma_page().  Is that lock ordering safe? 
Yes, that's how follow_page_pte() calls it, and how page_remove_rmap()
calls the complementary clear_page_mlock().

This fixes the following case (though not a case which anyone has
complained of), which mmap_sem did not: truncation's preliminary
unmap_mapping_range() is supposed to remove even the anonymous COWs of
filecache pages, and that might race with try_to_unmap_one() on a
VM_LOCKED vma, so that mlock_vma_page() sets PageMlocked just after
zap_pte_range() unmaps the page, causing "Bad page state (mlocked)" when
freed.  The pte lock protects against this.

You could say that it also protects against the more ordinary case, racing
with the preliminary unmapping of a filecache page itself: but in our
current tree, that's independently protected by i_mmap_rwsem; and that
race would be why "Bad page state (mlocked)" was seen before commit
48ec833b7851 ("Revert mm/memory.c: share the i_mmap_rwsem").

While we're here, make a related optimization in try_to_munmap_one(): if
it's doing TTU_MUNLOCK, then there's no point at all in descending the
page tables and getting the pt lock, unless the vma is VM_LOCKED.  Yes,
that can change racily, but it can change racily even without the
optimization: it's not critical.  Far better not to waste time here.

Stopped short of separating try_to_munlock_one() from try_to_munmap_one()
on this occasion, but that's probably the sensible next step - with a
rename, given that try_to_munlock()'s business is to try to set Mlocked.

Updated the unevictable-lru Documentation, to remove its reference to mmap
semaphore, but found a few more updates needed in just that area.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   65 ++++++-------------------
 mm/rmap.c                            |   36 ++++---------
 2 files changed, 29 insertions(+), 72 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked
+++ a/Documentation/vm/unevictable-lru.txt
@@ -531,37 +531,20 @@ map.
 
 try_to_unmap() is always called, by either vmscan for reclaim or for page
 migration, with the argument page locked and isolated from the LRU.  Separate
-functions handle anonymous and mapped file pages, as these types of pages have
-different reverse map mechanisms.
-
- (*) try_to_unmap_anon()
-
-     To unmap anonymous pages, each VMA in the list anchored in the anon_vma
-     must be visited - at least until a VM_LOCKED VMA is encountered.  If the
-     page is being unmapped for migration, VM_LOCKED VMAs do not stop the
-     process because mlocked pages are migratable.  However, for reclaim, if
-     the page is mapped into a VM_LOCKED VMA, the scan stops.
-
-     try_to_unmap_anon() attempts to acquire in read mode the mmap semaphore of
-     the mm_struct to which the VMA belongs.  If this is successful, it will
-     mlock the page via mlock_vma_page() - we wouldn't have gotten to
-     try_to_unmap_anon() if the page were already mlocked - and will return
-     SWAP_MLOCK, indicating that the page is unevictable.
-
-     If the mmap semaphore cannot be acquired, we are not sure whether the page
-     is really unevictable or not.  In this case, try_to_unmap_anon() will
-     return SWAP_AGAIN.
-
- (*) try_to_unmap_file()
-
-     Unmapping of a mapped file page works the same as for anonymous mappings,
-     except that the scan visits all VMAs that map the page's index/page offset
-     in the page's mapping's reverse map interval search tree.
-
-     As for anonymous pages, on encountering a VM_LOCKED VMA for a mapped file
-     page, try_to_unmap_file() will attempt to acquire the associated
-     mm_struct's mmap semaphore to mlock the page, returning SWAP_MLOCK if this
-     is successful, and SWAP_AGAIN, if not.
+functions handle anonymous and mapped file and KSM pages, as these types of
+pages have different reverse map lookup mechanisms, with different locking.
+In each case, whether rmap_walk_anon() or rmap_walk_file() or rmap_walk_ksm(),
+it will call try_to_unmap_one() for every VMA which might contain the page.
+
+When trying to reclaim, if try_to_unmap_one() finds the page in a VM_LOCKED
+VMA, it will then mlock the page via mlock_vma_page() instead of unmapping it,
+and return SWAP_MLOCK to indicate that the page is unevictable: and the scan
+stops there.
+
+mlock_vma_page() is called while holding the page table's lock (in addition
+to the page lock, and the rmap lock): to serialize against concurrent mlock or
+munlock or munmap system calls, mm teardown (munlock_vma_pages_all), reclaim,
+holepunching, and truncation of file pages and their anonymous COWed pages.
 
 
 try_to_munlock() REVERSE MAP SCAN
@@ -577,22 +560,15 @@ all PTEs from the page.  For this purpos
 introduced a variant of try_to_unmap() called try_to_munlock().
 
 try_to_munlock() calls the same functions as try_to_unmap() for anonymous and
-mapped file pages with an additional argument specifying unlock versus unmap
+mapped file and KSM pages with a flag argument specifying unlock versus unmap
 processing.  Again, these functions walk the respective reverse maps looking
 for VM_LOCKED VMAs.  When such a VMA is found, as in the try_to_unmap() case,
-the functions attempt to acquire the associated mmap semaphore, mlock the page
-via mlock_vma_page() and return SWAP_MLOCK.  This effectively undoes the
-pre-clearing of the page's PG_mlocked done by munlock_vma_page.
-
-If try_to_unmap() is unable to acquire a VM_LOCKED VMA's associated mmap
-semaphore, it will return SWAP_AGAIN.  This will allow shrink_page_list() to
-recycle the page on the inactive list and hope that it has better luck with the
-page next time.
+the functions mlock the page via mlock_vma_page() and return SWAP_MLOCK.  This
+undoes the pre-clearing of the page's PG_mlocked done by munlock_vma_page.
 
 Note that try_to_munlock()'s reverse map walk must visit every VMA in a page's
 reverse map to determine that a page is NOT mapped into any VM_LOCKED VMA.
-However, the scan can terminate when it encounters a VM_LOCKED VMA and can
-successfully acquire the VMA's mmap semaphore for read and mlock the page.
+However, the scan can terminate when it encounters a VM_LOCKED VMA.
 Although try_to_munlock() might be called a great many times when munlocking a
 large region or tearing down a large address space that has been mlocked via
 mlockall(), overall this is a fairly rare event.
@@ -620,11 +596,6 @@ Some examples of these unevictable pages
  (3) mlocked pages that could not be isolated from the LRU and moved to the
      unevictable list in mlock_vma_page().
 
- (4) Pages mapped into multiple VM_LOCKED VMAs, but try_to_munlock() couldn't
-     acquire the VMA's mmap semaphore to test the flags and set PageMlocked.
-     munlock_vma_page() was forced to let the page back on to the normal LRU
-     list for vmscan to handle.
-
 shrink_inactive_list() also diverts any unevictable pages that it finds on the
 inactive lists to the appropriate zone's unevictable list.
 
diff -puN mm/rmap.c~mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked mm/rmap.c
--- a/mm/rmap.c~mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked
+++ a/mm/rmap.c
@@ -1304,6 +1304,10 @@ static int try_to_unmap_one(struct page
 	int ret = SWAP_AGAIN;
 	enum ttu_flags flags = (enum ttu_flags)arg;
 
+	/* munlock has nothing to gain from examining un-locked vmas */
+	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
+		goto out;
+
 	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
@@ -1314,9 +1318,12 @@ static int try_to_unmap_one(struct page
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!(flags & TTU_IGNORE_MLOCK)) {
-		if (vma->vm_flags & VM_LOCKED)
-			goto out_mlock;
-
+		if (vma->vm_flags & VM_LOCKED) {
+			/* Holding pte lock, we do *not* need mmap_sem here */
+			mlock_vma_page(page);
+			ret = SWAP_MLOCK;
+			goto out_unmap;
+		}
 		if (flags & TTU_MUNLOCK)
 			goto out_unmap;
 	}
@@ -1421,31 +1428,10 @@ static int try_to_unmap_one(struct page
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret != SWAP_FAIL && !(flags & TTU_MUNLOCK))
+	if (ret != SWAP_FAIL && ret != SWAP_MLOCK && !(flags & TTU_MUNLOCK))
 		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;
-
-out_mlock:
-	pte_unmap_unlock(pte, ptl);
-
-
-	/*
-	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
-	 * unstable result and race. Plus, We can't wait here because
-	 * we now hold anon_vma->rwsem or mapping->i_mmap_rwsem.
-	 * if trylock failed, the page remain in evictable lru and later
-	 * vmscan could retry to move the page to unevictable lru if the
-	 * page is actually mlocked.
-	 */
-	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
-		if (vma->vm_flags & VM_LOCKED) {
-			mlock_vma_page(page);
-			ret = SWAP_MLOCK;
-		}
-		up_read(&vma->vm_mm->mmap_sem);
-	}
-	return ret;
 }
 
 bool is_vma_temporary_stack(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

