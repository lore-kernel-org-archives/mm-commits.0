From: akpm@linux-foundation.org
Subject: + mm-documentation-undoc-non-linear-vmas.patch added to -mm tree
Date: Mon, 19 Oct 2015 15:03:19 -0700
Message-ID: <562568a7.j2en10BB+ClkdCFW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbJSWDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm Documentation: undoc non-linear vmas
has been added to the -mm tree.  Its filename is
     mm-documentation-undoc-non-linear-vmas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-documentation-undoc-non-linear-vmas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-documentation-undoc-non-linear-vmas.patch

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
Subject: mm Documentation: undoc non-linear vmas

While updating some mm Documentation, I came across a few straggling
references to the non-linear vmas which were happily removed in v4.0. 
Delete them.

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

 Documentation/filesystems/proc.txt   |    1 
 Documentation/vm/page_migration      |   10 +--
 Documentation/vm/unevictable-lru.txt |   63 +------------------------
 3 files changed, 9 insertions(+), 65 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-documentation-undoc-non-linear-vmas Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-documentation-undoc-non-linear-vmas
+++ a/Documentation/filesystems/proc.txt
@@ -484,7 +484,6 @@ manner. The codes are the following:
     ac  - area is accountable
     nr  - swap space is not reserved for the area
     ht  - area uses huge tlb pages
-    nl  - non-linear mapping
     ar  - architecture specific flag
     dd  - do not include area into core dump
     sd  - soft-dirty flag
diff -puN Documentation/vm/page_migration~mm-documentation-undoc-non-linear-vmas Documentation/vm/page_migration
--- a/Documentation/vm/page_migration~mm-documentation-undoc-non-linear-vmas
+++ a/Documentation/vm/page_migration
@@ -99,12 +99,10 @@ Steps:
 4. The new page is prepped with some settings from the old page so that
    accesses to the new page will discover a page with the correct settings.
 
-5. All the page table references to the page are converted
-   to migration entries or dropped (nonlinear vmas).
-   This decrease the mapcount of a page. If the resulting
-   mapcount is not zero then we do not migrate the page.
-   All user space processes that attempt to access the page
-   will now wait on the page lock.
+5. All the page table references to the page are converted to migration
+   entries. This decreases the mapcount of a page. If the resulting
+   mapcount is not zero then we do not migrate the page. All user space
+   processes that attempt to access the page will now wait on the page lock.
 
 6. The radix tree lock is taken. This will cause all processes trying
    to access the page via the mapping to block on the radix tree spinlock.
diff -puN Documentation/vm/unevictable-lru.txt~mm-documentation-undoc-non-linear-vmas Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~mm-documentation-undoc-non-linear-vmas
+++ a/Documentation/vm/unevictable-lru.txt
@@ -552,63 +552,17 @@ different reverse map mechanisms.
      is really unevictable or not.  In this case, try_to_unmap_anon() will
      return SWAP_AGAIN.
 
- (*) try_to_unmap_file() - linear mappings
+ (*) try_to_unmap_file()
 
      Unmapping of a mapped file page works the same as for anonymous mappings,
      except that the scan visits all VMAs that map the page's index/page offset
-     in the page's mapping's reverse map priority search tree.  It also visits
-     each VMA in the page's mapping's non-linear list, if the list is
-     non-empty.
+     in the page's mapping's reverse map interval search tree.
 
      As for anonymous pages, on encountering a VM_LOCKED VMA for a mapped file
      page, try_to_unmap_file() will attempt to acquire the associated
      mm_struct's mmap semaphore to mlock the page, returning SWAP_MLOCK if this
      is successful, and SWAP_AGAIN, if not.
 
- (*) try_to_unmap_file() - non-linear mappings
-
-     If a page's mapping contains a non-empty non-linear mapping VMA list, then
-     try_to_un{map|lock}() must also visit each VMA in that list to determine
-     whether the page is mapped in a VM_LOCKED VMA.  Again, the scan must visit
-     all VMAs in the non-linear list to ensure that the pages is not/should not
-     be mlocked.
-
-     If a VM_LOCKED VMA is found in the list, the scan could terminate.
-     However, there is no easy way to determine whether the page is actually
-     mapped in a given VMA - either for unmapping or testing whether the
-     VM_LOCKED VMA actually pins the page.
-
-     try_to_unmap_file() handles non-linear mappings by scanning a certain
-     number of pages - a "cluster" - in each non-linear VMA associated with the
-     page's mapping, for each file mapped page that vmscan tries to unmap.  If
-     this happens to unmap the page we're trying to unmap, try_to_unmap() will
-     notice this on return (page_mapcount(page) will be 0) and return
-     SWAP_SUCCESS.  Otherwise, it will return SWAP_AGAIN, causing vmscan to
-     recirculate this page.  We take advantage of the cluster scan in
-     try_to_unmap_cluster() as follows:
-
-	For each non-linear VMA, try_to_unmap_cluster() attempts to acquire the
-	mmap semaphore of the associated mm_struct for read without blocking.
-
-	If this attempt is successful and the VMA is VM_LOCKED,
-	try_to_unmap_cluster() will retain the mmap semaphore for the scan;
-	otherwise it drops it here.
-
-	Then, for each page in the cluster, if we're holding the mmap semaphore
-	for a locked VMA, try_to_unmap_cluster() calls mlock_vma_page() to
-	mlock the page.  This call is a no-op if the page is already locked,
-	but will mlock any pages in the non-linear mapping that happen to be
-	unlocked.
-
-	If one of the pages so mlocked is the page passed in to try_to_unmap(),
-	try_to_unmap_cluster() will return SWAP_MLOCK, rather than the default
-	SWAP_AGAIN.  This will allow vmscan to cull the page, rather than
-	recirculating it on the inactive list.
-
-	Again, if try_to_unmap_cluster() cannot acquire the VMA's mmap sem, it
-	returns SWAP_AGAIN, indicating that the page is mapped by a VM_LOCKED
-	VMA, but couldn't be mlocked.
-
 
 try_to_munlock() REVERSE MAP SCAN
 ---------------------------------
@@ -625,10 +579,9 @@ introduced a variant of try_to_unmap() c
 try_to_munlock() calls the same functions as try_to_unmap() for anonymous and
 mapped file pages with an additional argument specifying unlock versus unmap
 processing.  Again, these functions walk the respective reverse maps looking
-for VM_LOCKED VMAs.  When such a VMA is found for anonymous pages and file
-pages mapped in linear VMAs, as in the try_to_unmap() case, the functions
-attempt to acquire the associated mmap semaphore, mlock the page via
-mlock_vma_page() and return SWAP_MLOCK.  This effectively undoes the
+for VM_LOCKED VMAs.  When such a VMA is found, as in the try_to_unmap() case,
+the functions attempt to acquire the associated mmap semaphore, mlock the page
+via mlock_vma_page() and return SWAP_MLOCK.  This effectively undoes the
 pre-clearing of the page's PG_mlocked done by munlock_vma_page.
 
 If try_to_unmap() is unable to acquire a VM_LOCKED VMA's associated mmap
@@ -636,12 +589,6 @@ semaphore, it will return SWAP_AGAIN.  T
 recycle the page on the inactive list and hope that it has better luck with the
 page next time.
 
-For file pages mapped into non-linear VMAs, the try_to_munlock() logic works
-slightly differently.  On encountering a VM_LOCKED non-linear VMA that might
-map the page, try_to_munlock() returns SWAP_AGAIN without actually mlocking the
-page.  munlock_vma_page() will just leave the page unlocked and let vmscan deal
-with it - the usual fallback position.
