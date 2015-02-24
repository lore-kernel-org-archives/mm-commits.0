From: akpm@linux-foundation.org
Subject: +
 mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch added
 to -mm tree
Date: Mon, 23 Feb 2015 16:20:28 -0800
Message-ID: <54ebc3cc.gAPXGgqavpw2vR/L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbBXAUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 19:20:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raindel@mellanox.com, aarcange@redhat.com, ak@linux.intel.com, dave.hansen@intel.com, haggaie@mellanox.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, pfeiner@google.com, riel@redhat.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor do_wp_page handling of shared vma into a function
has been added to the -mm tree.  Its filename is
     mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shachar Raindel <raindel@mellanox.com>
Subject: mm: refactor do_wp_page handling of shared vma into a function

The do_wp_page function is extremely long.  Extract the logic for handling
a page belonging to a shared vma into a function of its own.

This helps the readability of the code, without doing any functional
change in it.

Signed-off-by: Shachar Raindel <raindel@mellanox.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Haggai Eran <haggaie@mellanox.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   86 +++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 38 deletions(-)

diff -puN mm/memory.c~mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function mm/memory.c
--- a/mm/memory.c~mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function
+++ a/mm/memory.c
@@ -2181,6 +2181,52 @@ oom:
 	return VM_FAULT_OOM;
 }
 
+static int wp_page_shared(struct mm_struct *mm, struct vm_area_struct *vma,
+			  unsigned long address, pte_t *page_table,
+			  pmd_t *pmd, spinlock_t *ptl, pte_t orig_pte,
+			  struct page *old_page)
+	__releases(ptl)
+{
+	int page_mkwrite = 0;
+
+	page_cache_get(old_page);
+
+	/*
+	 * Only catch write-faults on shared writable pages,
+	 * read-only shared pages can get COWed by
+	 * get_user_pages(.write=1, .force=1).
+	 */
+	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
+		int tmp;
+
+		pte_unmap_unlock(page_table, ptl);
+		tmp = do_page_mkwrite(vma, old_page, address);
+		if (unlikely(!tmp || (tmp &
+				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
+			page_cache_release(old_page);
+			return tmp;
+		}
+		/*
+		 * Since we dropped the lock we need to revalidate
+		 * the PTE as someone else may have changed it.  If
+		 * they did, we just return, as we can count on the
+		 * MMU to tell us if they didn't also make it writable.
+		 */
+		page_table = pte_offset_map_lock(mm, pmd, address,
+						 &ptl);
+		if (!pte_same(*page_table, orig_pte)) {
+			unlock_page(old_page);
+			pte_unmap_unlock(page_table, ptl);
+			page_cache_release(old_page);
+			return 0;
+		}
+		page_mkwrite = 1;
+	}
+
+	return wp_page_reuse(mm, vma, address, page_table, ptl,
+			     orig_pte, old_page, page_mkwrite, 1);
+}
+
 /*
  * This routine handles present pages, when users try to write
  * to a shared page. It is done by copying the page to a new address
@@ -2259,44 +2305,8 @@ static int do_wp_page(struct mm_struct *
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
-		int page_mkwrite = 0;
-
-		page_cache_get(old_page);
-
-		/*
-		 * Only catch write-faults on shared writable pages,
-		 * read-only shared pages can get COWed by
-		 * get_user_pages(.write=1, .force=1).
-		 */
-		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
-			int tmp;
-
-			pte_unmap_unlock(page_table, ptl);
-			tmp = do_page_mkwrite(vma, old_page, address);
-			if (unlikely(!tmp || (tmp &
-					(VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
-				page_cache_release(old_page);
-				return tmp;
-			}
-			/*
-			 * Since we dropped the lock we need to revalidate
-			 * the PTE as someone else may have changed it.  If
-			 * they did, we just return, as we can count on the
-			 * MMU to tell us if they didn't also make it writable.
-			 */
-			page_table = pte_offset_map_lock(mm, pmd, address,
-							 &ptl);
-			if (!pte_same(*page_table, orig_pte)) {
-				unlock_page(old_page);
-				pte_unmap_unlock(page_table, ptl);
-				page_cache_release(old_page);
-				return 0;
-			}
-			page_mkwrite = 1;
-		}
