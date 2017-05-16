From: akpm@linux-foundation.org
Subject: [merged]
 dax-fix-pmd-data-corruption-when-fault-races-with-write.patch removed from
 -mm tree
Date: Tue, 16 May 2017 10:50:17 -0700
Message-ID: <20170516175017.U3FTGwHMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752796AbdEPRuX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.cz, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, stable@vger.kernel.org


The patch titled
     Subject: dax: fix PMD data corruption when fault races with write
has been removed from the -mm tree.  Its filename was
     dax-fix-pmd-data-corruption-when-fault-races-with-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix PMD data corruption when fault races with write

This is based on a patch from Jan Kara that fixed the equivalent race in
the DAX PTE fault path.

Currently DAX PMD read fault can race with write(2) in the following way:

CPU1 - write(2)                 CPU2 - read fault
                                dax_iomap_pmd_fault()
                                  ->iomap_begin() - sees hole

dax_iomap_rw()
  iomap_apply()
    ->iomap_begin - allocates blocks
    dax_iomap_actor()
      invalidate_inode_pages2_range()
        - there's nothing to invalidate

                                  grab_mapping_entry()
				  - we add huge zero page to the radix tree
				    and map it to page tables

The result is that hole page is mapped into page tables (and thus zeros
are seen in mmap) while file has data written in that place.

Fix the problem by locking exception entry before mapping blocks for the
fault.  That way we are sure invalidate_inode_pages2_range() call for
racing write will either block on entry lock waiting for the fault to
finish (and unmap stale page tables after that) or read fault will see
already allocated blocks by write(2).

Fixes: 9f141d6ef6258 ("dax: Call ->iomap_begin without entry lock during dax fault")
Link: http://lkml.kernel.org/r/20170510172700.18991-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/dax.c~dax-fix-pmd-data-corruption-when-fault-races-with-write fs/dax.c
--- a/fs/dax.c~dax-fix-pmd-data-corruption-when-fault-races-with-write
+++ a/fs/dax.c
@@ -1388,6 +1388,16 @@ static int dax_iomap_pmd_fault(struct vm
 		goto fallback;
 
 	/*
+	 * grab_mapping_entry() will make sure we get a 2M empty entry, a DAX
+	 * PMD or a HZP entry.  If it can't (because a 4k page is already in
+	 * the tree, for instance), it will return -EEXIST and we just fall
+	 * back to 4k entries.
+	 */
+	entry = grab_mapping_entry(mapping, pgoff, RADIX_DAX_PMD);
+	if (IS_ERR(entry))
+		goto fallback;
+
+	/*
 	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
 	 * setting up a mapping, so really we're using iomap_begin() as a way
 	 * to look up our filesystem block.
@@ -1395,21 +1405,11 @@ static int dax_iomap_pmd_fault(struct vm
 	pos = (loff_t)pgoff << PAGE_SHIFT;
 	error = ops->iomap_begin(inode, pos, PMD_SIZE, iomap_flags, &iomap);
 	if (error)
-		goto fallback;
+		goto unlock_entry;
 
 	if (iomap.offset + iomap.length < pos + PMD_SIZE)
 		goto finish_iomap;
 
-	/*
-	 * grab_mapping_entry() will make sure we get a 2M empty entry, a DAX
-	 * PMD or a HZP entry.  If it can't (because a 4k page is already in
-	 * the tree, for instance), it will return -EEXIST and we just fall
-	 * back to 4k entries.
-	 */
-	entry = grab_mapping_entry(mapping, pgoff, RADIX_DAX_PMD);
-	if (IS_ERR(entry))
-		goto finish_iomap;
-
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
 		result = dax_pmd_insert_mapping(vmf, &iomap, pos, &entry);
@@ -1417,7 +1417,7 @@ static int dax_iomap_pmd_fault(struct vm
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
 		if (WARN_ON_ONCE(write))
-			goto unlock_entry;
+			break;
 		result = dax_pmd_load_hole(vmf, &iomap, &entry);
 		break;
 	default:
@@ -1425,8 +1425,6 @@ static int dax_iomap_pmd_fault(struct vm
 		break;
 	}
 
- unlock_entry:
-	put_locked_mapping_entry(mapping, pgoff, entry);
  finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PMD_SIZE;
@@ -1442,6 +1440,8 @@ static int dax_iomap_pmd_fault(struct vm
 		ops->iomap_end(inode, pos, PMD_SIZE, copied, iomap_flags,
 				&iomap);
 	}
+ unlock_entry:
+	put_locked_mapping_entry(mapping, pgoff, entry);
  fallback:
 	if (result == VM_FAULT_FALLBACK) {
 		split_huge_pmd(vma, vmf->pmd, vmf->address);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


