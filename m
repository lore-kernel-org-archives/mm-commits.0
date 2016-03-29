From: akpm@linux-foundation.org
Subject: + dax-use-vmf-pgoff-in-fault-handlers.patch added to -mm tree
Date: Tue, 29 Mar 2016 14:08:32 -0700
Message-ID: <56faeed0.72wBOjcPrCwr2C0y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbcC2VId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 17:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, kirill@shutemov.name, mingo@elte.hu, rientjes@google.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


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
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: use vmf->pgoff in fault handlers

Now that the PMD and PUD fault handlers are passed pgoff, there's no
need to calculate it themselves.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN fs/dax.c~dax-use-vmf-pgoff-in-fault-handlers fs/dax.c
--- a/fs/dax.c~dax-use-vmf-pgoff-in-fault-handlers
+++ a/fs/dax.c
@@ -736,7 +736,7 @@ static int dax_pmd_fault(struct vm_area_
 	unsigned long pmd_addr = address & PMD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
-	pgoff_t size, pgoff;
+	pgoff_t size;
 	sector_t block;
 	int error, result = 0;
 	bool alloc = false;
@@ -761,12 +761,11 @@ static int dax_pmd_fault(struct vm_area_
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
@@ -774,7 +773,7 @@ static int dax_pmd_fault(struct vm_area_
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
 
@@ -804,7 +803,7 @@ static int dax_pmd_fault(struct vm_area_
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
 		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
 
 		truncate_pagecache_range(inode, lstart, lend);
@@ -890,8 +889,8 @@ static int dax_pmd_fault(struct vm_area_
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
@@ -942,7 +941,7 @@ static int dax_pud_fault(struct vm_area_
 	unsigned long pud_addr = address & PUD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
-	pgoff_t size, pgoff;
+	pgoff_t size;
 	sector_t block;
 	int result = 0;
 	bool alloc = false;
@@ -967,12 +966,11 @@ static int dax_pud_fault(struct vm_area_
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
@@ -980,7 +978,7 @@ static int dax_pud_fault(struct vm_area_
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PUD_SIZE;
 
@@ -1010,7 +1008,7 @@ static int dax_pud_fault(struct vm_area_
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
 		loff_t lend = lstart + PUD_SIZE - 1; /* inclusive */
 
 		truncate_pagecache_range(inode, lstart, lend);
_

Patches currently in -mm which might be from willy@linux.intel.com are

mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-unify-native__get_and_clear-smp-case.patch
x86-fix-whitespace-issues.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
dax-use-vmf-gfp_mask.patch
dax-remove-unnecessary-rechecking-of-i_size.patch
dax-use-vmf-pgoff-in-fault-handlers.patch

