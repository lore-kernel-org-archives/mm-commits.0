From: akpm@linux-foundation.org
Subject: + dax-use-vmf-pgoff-in-fault-handlers.patch added to -mm tree
Date: Tue, 02 Feb 2016 14:57:41 -0800
Message-ID: <56b13465.KhtMoJh2vLr7fB/q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbcBBW5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:57:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: use vmf->pgoff in fault handlers
has been added to the -mm tree.  Its filename is
     dax-use-vmf-pgoff-in-fault-handlers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-use-vmf-pgoff-in-fault-handlers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-use-vmf-pgoff-in-fault-handlers.patch

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
Subject: dax: use vmf->pgoff in fault handlers

Now that the PMD and PUD fault handlers are passed pgoff, there's no
need to calculate it themselves.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN fs/dax.c~dax-use-vmf-pgoff-in-fault-handlers fs/dax.c
--- a/fs/dax.c~dax-use-vmf-pgoff-in-fault-handlers
+++ a/fs/dax.c
@@ -729,7 +729,7 @@ static int dax_pmd_fault(struct vm_area_
 	unsigned long pmd_addr = address & PMD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
-	pgoff_t size, pgoff;
+	pgoff_t size;
 	sector_t block;
 	int error, result = 0;
 	bool alloc = false;
@@ -754,12 +754,11 @@ static int dax_pmd_fault(struct vm_area_
 		return VM_FAULT_FALLBACK;
 	}
 
-	pgoff = linear_page_index(vma, pmd_addr);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size)
+	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PMD would cover blocks out of the file */
-	if ((pgoff | PG_PMD_COLOUR) >= size) {
+	if ((vmf->pgoff | PG_PMD_COLOUR) >= size) {
 		dax_pmd_dbg(NULL, address,
 				"offset + huge page size > file size");
 		return VM_FAULT_FALLBACK;
@@ -767,7 +766,7 @@ static int dax_pmd_fault(struct vm_area_
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
 
@@ -797,7 +796,7 @@ static int dax_pmd_fault(struct vm_area_
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
 		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
 
 		truncate_pagecache_range(inode, lstart, lend);
@@ -883,8 +882,8 @@ static int dax_pmd_fault(struct vm_area_
 		 * the write to insert a dirty entry.
 		 */
 		if (write) {
-			error = dax_radix_entry(mapping, pgoff, dax.sector,
-					true, true);
+			error = dax_radix_entry(mapping, vmf->pgoff,
+						dax.sector, true, true);
 			if (error) {
 				dax_pmd_dbg(&bh, address,
 						"PMD radix insertion failed");
@@ -941,7 +940,7 @@ static int dax_pud_fault(struct vm_area_
 	unsigned long pud_addr = address & PUD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
-	pgoff_t size, pgoff;
+	pgoff_t size;
 	sector_t block;
 	int result = 0;
 	bool alloc = false;
@@ -966,12 +965,11 @@ static int dax_pud_fault(struct vm_area_
 		return VM_FAULT_FALLBACK;
 	}
 
-	pgoff = linear_page_index(vma, pud_addr);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size)
+	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PUD would cover blocks out of the file */
-	if ((pgoff | PG_PUD_COLOUR) >= size) {
+	if ((vmf->pgoff | PG_PUD_COLOUR) >= size) {
 		dax_pud_dbg(NULL, address,
 				"offset + huge page size > file size");
 		return VM_FAULT_FALLBACK;
@@ -979,7 +977,7 @@ static int dax_pud_fault(struct vm_area_
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PUD_SIZE;
 
@@ -1009,7 +1007,7 @@ static int dax_pud_fault(struct vm_area_
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
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

