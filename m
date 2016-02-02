From: akpm@linux-foundation.org
Subject: + dax-use-page_cache_size-where-appropriate.patch added to -mm
 tree
Date: Tue, 02 Feb 2016 14:57:43 -0800
Message-ID: <56b13467.lZUPeLWK/bfQYxVm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbcBBW5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: use PAGE_CACHE_SIZE where appropriate
has been added to the -mm tree.  Its filename is
     dax-use-page_cache_size-where-appropriate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-use-page_cache_size-where-appropriate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-use-page_cache_size-where-appropriate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: dax: use PAGE_CACHE_SIZE where appropriate

We were a little sloppy about using PAGE_SIZE instead of PAGE_CACHE_SIZE. 
The important thing to remember is that the VM is gicing us a pgoff_t and
asking us to populate that.  If PAGE_CACHE_SIZE were larger than
PAGE_SIZE, then we would not successfully fill in the PTEs for faults that
occurred in the upper portions of PAGE_CACHE_SIZE.

Of course, we actually only fill in one PTE, so this still doesn't solve
the problem.  I have my doubts we will ever increase PAGE_CACHE_SIZE now
that we have map_pages.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/dax.c~dax-use-page_cache_size-where-appropriate fs/dax.c
--- a/fs/dax.c~dax-use-page_cache_size-where-appropriate
+++ a/fs/dax.c
@@ -578,14 +578,14 @@ static int dax_pte_fault(struct vm_area_
 	int error;
 	int major = 0;
 
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 
 	memset(&bh, 0, sizeof(bh));
-	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_CACHE_SHIFT - blkbits);
 	bh.b_bdev = inode->i_sb->s_bdev;
-	bh.b_size = PAGE_SIZE;
+	bh.b_size = PAGE_CACHE_SIZE;
 
  repeat:
 	page = find_get_page(mapping, vmf->pgoff);
@@ -602,7 +602,7 @@ static int dax_pte_fault(struct vm_area_
 	}
 
 	error = get_block(inode, block, &bh, 0);
-	if (!error && (bh.b_size < PAGE_SIZE))
+	if (!error && (bh.b_size < PAGE_CACHE_SIZE))
 		error = -EIO;		/* fs corruption? */
 	if (error)
 		goto unlock_page;
@@ -613,7 +613,7 @@ static int dax_pte_fault(struct vm_area_
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
-			if (!error && (bh.b_size < PAGE_SIZE))
+			if (!error && (bh.b_size < PAGE_CACHE_SIZE))
 				error = -EIO;
 			if (error)
 				goto unlock_page;
@@ -650,7 +650,7 @@ static int dax_pte_fault(struct vm_area_
 		page = find_lock_page(mapping, vmf->pgoff);
 
 	if (page) {
-		unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
+		unmap_mapping_range(mapping, vmf->pgoff << PAGE_CACHE_SHIFT,
 							PAGE_CACHE_SIZE, 0);
 		delete_from_page_cache(page);
 		unlock_page(page);
@@ -697,7 +697,7 @@ static int dax_pte_fault(struct vm_area_
  * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
  * more often than one might expect in the below function.
  */
-#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
+#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_CACHE_SHIFT) - 1)
 
 static void __dax_dbg(struct buffer_head *bh, unsigned long address,
 		const char *reason, const char *fn)
@@ -754,7 +754,7 @@ static int dax_pmd_fault(struct vm_area_
 		return VM_FAULT_FALLBACK;
 	}
 
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PMD would cover blocks out of the file */
@@ -766,7 +766,7 @@ static int dax_pmd_fault(struct vm_area_
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_CACHE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
 
@@ -796,7 +796,7 @@ static int dax_pmd_fault(struct vm_area_
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_CACHE_SHIFT;
 		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
 
 		truncate_pagecache_range(inode, lstart, lend);
@@ -924,7 +924,7 @@ static int dax_pmd_fault(struct vm_area_
  * The 'colour' (ie low bits) within a PUD of a page offset.  This comes up
  * more often than one might expect in the below function.
  */
-#define PG_PUD_COLOUR	((PUD_SIZE >> PAGE_SHIFT) - 1)
+#define PG_PUD_COLOUR	((PUD_SIZE >> PAGE_CACHE_SHIFT) - 1)
 
 #define dax_pud_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pud")
 
@@ -965,7 +965,7 @@ static int dax_pud_fault(struct vm_area_
 		return VM_FAULT_FALLBACK;
 	}
 
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PUD would cover blocks out of the file */
@@ -977,7 +977,7 @@ static int dax_pud_fault(struct vm_area_
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_CACHE_SHIFT - blkbits);
 
 	bh.b_size = PUD_SIZE;
 
@@ -1007,7 +1007,7 @@ static int dax_pud_fault(struct vm_area_
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_CACHE_SHIFT;
 		loff_t lend = lstart + PUD_SIZE - 1; /* inclusive */
 
 		truncate_pagecache_range(inode, lstart, lend);
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

mm-fix-memory-leak-in-copy_huge_pmd.patch
mm-use-linear_page_index-in-do_fault.patch
dax-use-vmf-gfp_mask.patch
dax-remove-unnecessary-rechecking-of-i_size.patch
dax-use-vmf-pgoff-in-fault-handlers.patch
dax-use-page_cache_size-where-appropriate.patch
dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault.patch
dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault.patch

