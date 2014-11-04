From: akpm@linux-foundation.org
Subject: [withdrawn] mremap-take-anon_vma-lock-in-shared-mode.patch
 removed from -mm tree
Date: Tue, 04 Nov 2014 14:38:27 -0800
Message-ID: <54595563.ZmaAUfP1niF5Ell/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKDWi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 17:38:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, dbueso@suse.de, hughd@google.com, riel@redhat.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: take anon_vma lock in shared mode
has been removed from the -mm tree.  Its filename was
     mremap-take-anon_vma-lock-in-shared-mode.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mremap: take anon_vma lock in shared mode

There's no modification to anon_vma interval tree.  We only need to
serialize against exclusive rmap walker who wants to catch all ptes the
page is mapped with.  Shared lock is enough for that.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mremap.c~mremap-take-anon_vma-lock-in-shared-mode mm/mremap.c
--- a/mm/mremap.c~mremap-take-anon_vma-lock-in-shared-mode
+++ a/mm/mremap.c
@@ -123,7 +123,7 @@ static void move_ptes(struct vm_area_str
 		}
 		if (vma->anon_vma) {
 			anon_vma = vma->anon_vma;
-			anon_vma_lock_write(anon_vma);
+			anon_vma_lock_read(anon_vma);
 		}
 	}
 
@@ -154,7 +154,7 @@ static void move_ptes(struct vm_area_str
 	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
 	if (anon_vma)
-		anon_vma_unlock_write(anon_vma);
+		anon_vma_unlock_read(anon_vma);
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
 }
@@ -199,12 +199,12 @@ unsigned long move_page_tables(struct vm
 					      vma);
 				/* See comment in move_ptes() */
 				if (need_rmap_locks)
-					anon_vma_lock_write(vma->anon_vma);
+					anon_vma_lock_read(vma->anon_vma);
 				err = move_huge_pmd(vma, new_vma, old_addr,
 						    new_addr, old_end,
 						    old_pmd, new_pmd);
 				if (need_rmap_locks)
-					anon_vma_unlock_write(vma->anon_vma);
+					anon_vma_unlock_read(vma->anon_vma);
 			}
 			if (err > 0) {
 				need_flush = true;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-verify-compound-order-when-freeing-a-page.patch
thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

