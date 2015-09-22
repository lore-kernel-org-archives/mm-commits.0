From: akpm@linux-foundation.org
Subject: + dax-fix-null-pointer-in-__dax_pmd_fault.patch tentatively added to -mm tree
Date: Tue, 22 Sep 2015 14:14:06 -0700
Message-ID: <5601c49e.UWtXFCfbBSt4oxwb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934652AbbIVVOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 17:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix NULL pointer in __dax_pmd_fault()
has been added to the -mm tree.  Its filename is
     dax-fix-null-pointer-in-__dax_pmd_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-null-pointer-in-__dax_pmd_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-null-pointer-in-__dax_pmd_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dax-fix-null-pointer-in-__dax_pmd_fault.patch

