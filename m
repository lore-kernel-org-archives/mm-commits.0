From: akpm@linux-foundation.org
Subject: [patch 073/114] mm: move part of wp_page_reuse() into the single
 call site
Date: Wed, 14 Dec 2016 15:07:36 -0800
Message-ID: <5851d0b8.xApH2tz3MaR3wYd6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933483AbcLNXHi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com

From: Jan Kara <jack@suse.cz>
Subject: mm: move part of wp_page_reuse() into the single call site

wp_page_reuse() handles write shared faults which is needed only in
wp_page_shared().  Move the handling only into that location to make
wp_page_reuse() simpler and avoid a strange situation when we sometimes
pass in locked page, sometimes unlocked etc.

Link: http://lkml.kernel.org/r/1479460644-25076-15-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN mm/memory.c~mm-move-part-of-wp_page_reuse-into-the-single-call-site mm/memory.c
--- a/mm/memory.c~mm-move-part-of-wp_page_reuse-into-the-single-call-site
+++ a/mm/memory.c
@@ -2102,8 +2102,7 @@ static void fault_dirty_shared_page(stru
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline int wp_page_reuse(struct vm_fault *vmf,
-				int page_mkwrite, int dirty_shared)
+static inline void wp_page_reuse(struct vm_fault *vmf)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -2123,16 +2122,6 @@ static inline int wp_page_reuse(struct v
 	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
 		update_mmu_cache(vma, vmf->address, vmf->pte);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-
-	if (dirty_shared) {
-		if (!page_mkwrite)
-			lock_page(page);
-
-		fault_dirty_shared_page(vma, page);
-		put_page(page);
-	}
-
-	return VM_FAULT_WRITE;
 }
 
 /*
@@ -2307,7 +2296,8 @@ static int wp_pfn_shared(struct vm_fault
 			return 0;
 		}
 	}
-	return wp_page_reuse(vmf, 0, 0);
+	wp_page_reuse(vmf);
+	return VM_FAULT_WRITE;
 }
 
 static int wp_page_shared(struct vm_fault *vmf)
@@ -2345,7 +2335,13 @@ static int wp_page_shared(struct vm_faul
 		page_mkwrite = 1;
 	}
 
-	return wp_page_reuse(vmf, page_mkwrite, 1);
+	wp_page_reuse(vmf);
+	if (!page_mkwrite)
+		lock_page(vmf->page);
+	fault_dirty_shared_page(vma, vmf->page);
+	put_page(vmf->page);
+
+	return VM_FAULT_WRITE;
 }
 
 /*
@@ -2420,7 +2416,8 @@ static int do_wp_page(struct vm_fault *v
 				page_move_anon_rmap(vmf->page, vma);
 			}
 			unlock_page(vmf->page);
-			return wp_page_reuse(vmf, 0, 0);
+			wp_page_reuse(vmf);
+			return VM_FAULT_WRITE;
 		}
 		unlock_page(vmf->page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
_
