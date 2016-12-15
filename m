From: akpm@linux-foundation.org
Subject: [merged] mm-factor-out-common-parts-of-write-fault-handling.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:40 -0800
Message-ID: <5852e54c.ae1Pv1z+vcKxPmhu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754238AbcLOSrl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out common parts of write fault handling
has been removed from the -mm tree.  Its filename was
     mm-factor-out-common-parts-of-write-fault-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: factor out common parts of write fault handling

Currently we duplicate handling of shared write faults in wp_page_reuse()
and do_shared_fault().  Factor them out into a common function.

Link: http://lkml.kernel.org/r/1479460644-25076-12-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   78 +++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

diff -puN mm/memory.c~mm-factor-out-common-parts-of-write-fault-handling mm/memory.c
--- a/mm/memory.c~mm-factor-out-common-parts-of-write-fault-handling
+++ a/mm/memory.c
@@ -2063,6 +2063,41 @@ static int do_page_mkwrite(struct vm_are
 }
 
 /*
+ * Handle dirtying of a page in shared file mapping on a write fault.
+ *
+ * The function expects the page to be locked and unlocks it.
+ */
+static void fault_dirty_shared_page(struct vm_area_struct *vma,
+				    struct page *page)
+{
+	struct address_space *mapping;
+	bool dirtied;
+	bool page_mkwrite = vma->vm_ops && vma->vm_ops->page_mkwrite;
+
+	dirtied = set_page_dirty(page);
+	VM_BUG_ON_PAGE(PageAnon(page), page);
+	/*
+	 * Take a local copy of the address_space - page.mapping may be zeroed
+	 * by truncate after unlock_page().   The address_space itself remains
+	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
+	 * release semantics to prevent the compiler from undoing this copying.
+	 */
+	mapping = page_rmapping(page);
+	unlock_page(page);
+
+	if ((dirtied || page_mkwrite) && mapping) {
+		/*
+		 * Some device drivers do not set page.mapping
+		 * but still dirty their pages
+		 */
+		balance_dirty_pages_ratelimited(mapping);
+	}
+
+	if (!page_mkwrite)
+		file_update_time(vma->vm_file);
+}
+
+/*
  * Handle write page faults for pages that can be reused in the current vma
  *
  * This can happen either due to the mapping being with the VM_SHARED flag,
@@ -2092,28 +2127,11 @@ static inline int wp_page_reuse(struct v
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
 	if (dirty_shared) {
-		struct address_space *mapping;
-		int dirtied;
-
 		if (!page_mkwrite)
 			lock_page(page);
 
-		dirtied = set_page_dirty(page);
-		VM_BUG_ON_PAGE(PageAnon(page), page);
-		mapping = page->mapping;
-		unlock_page(page);
+		fault_dirty_shared_page(vma, page);
 		put_page(page);
-
-		if ((dirtied || page_mkwrite) && mapping) {
-			/*
-			 * Some device drivers do not set page.mapping
-			 * but still dirty their pages
-			 */
-			balance_dirty_pages_ratelimited(mapping);
-		}
-
-		if (!page_mkwrite)
-			file_update_time(vma->vm_file);
 	}
 
 	return VM_FAULT_WRITE;
@@ -3294,8 +3312,6 @@ uncharge_out:
 static int do_shared_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct address_space *mapping;
-	int dirtied = 0;
 	int ret, tmp;
 
 	ret = __do_fault(vmf);
@@ -3324,27 +3340,7 @@ static int do_shared_fault(struct vm_fau
 		return ret;
 	}
 
-	if (set_page_dirty(vmf->page))
-		dirtied = 1;
-	/*
-	 * Take a local copy of the address_space - page.mapping may be zeroed
-	 * by truncate after unlock_page().   The address_space itself remains
-	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
-	 * release semantics to prevent the compiler from undoing this copying.
-	 */
-	mapping = page_rmapping(vmf->page);
-	unlock_page(vmf->page);
-	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
-		/*
-		 * Some device drivers do not set page.mapping but still
-		 * dirty their pages
-		 */
-		balance_dirty_pages_ratelimited(mapping);
-	}
-
-	if (!vma->vm_ops->page_mkwrite)
-		file_update_time(vma->vm_file);
