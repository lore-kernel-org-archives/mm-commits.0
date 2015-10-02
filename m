From: akpm@linux-foundation.org
Subject: [merged] dax-fix-null-pointer-in-__dax_pmd_fault.patch removed
 from -mm tree
Date: Fri, 02 Oct 2015 12:36:19 -0700
Message-ID: <560edcb3.FraoaudyKHeH4zk5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbbJBTgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix NULL pointer in __dax_pmd_fault()
has been removed from the -mm tree.  Its filename was
     dax-fix-null-pointer-in-__dax_pmd_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix NULL pointer in __dax_pmd_fault()

46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for DAX")
moved some code in __dax_pmd_fault() that was responsible for zeroing
newly allocated PMD pages.  The new location didn't properly set up
'kaddr', so when run this code resulted in a NULL pointer BUG.

Fix this by getting the correct 'kaddr' via bdev_direct_access().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-fix-null-pointer-in-__dax_pmd_fault fs/dax.c
--- a/fs/dax.c~dax-fix-null-pointer-in-__dax_pmd_fault
+++ a/fs/dax.c
@@ -569,8 +569,20 @@ int __dax_pmd_fault(struct vm_area_struc
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
 		goto fallback;
 
+	sector = bh.b_blocknr << (blkbits - 9);
+
 	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
 		int i;
+
+		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
+						bh.b_size);
+		if (length < 0) {
+			result = VM_FAULT_SIGBUS;
+			goto out;
+		}
+		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
+			goto fallback;
+
 		for (i = 0; i < PTRS_PER_PMD; i++)
 			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
 		wmb_pmem();
@@ -623,7 +635,6 @@ int __dax_pmd_fault(struct vm_area_struc
 		result = VM_FAULT_NOPAGE;
 		spin_unlock(ptl);
 	} else {
-		sector = bh.b_blocknr << (blkbits - 9);
 		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
 						bh.b_size);
 		if (length < 0) {
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


