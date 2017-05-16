From: akpm@linux-foundation.org
Subject: [merged]
 dax-fix-data-corruption-when-fault-races-with-write.patch removed from -mm
 tree
Date: Tue, 16 May 2017 10:50:14 -0700
Message-ID: <20170516175014.--V0tCydp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752745AbdEPRuP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.cz, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, stable@vger.kernel.org


The patch titled
     Subject: dax: fix data corruption when fault races with write
has been removed from the -mm tree.  Its filename was
     dax-fix-data-corruption-when-fault-races-with-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: dax: fix data corruption when fault races with write

Currently DAX read fault can race with write(2) in the following way:

CPU1 - write(2)			CPU2 - read fault
				dax_iomap_pte_fault()
				  ->iomap_begin() - sees hole
dax_iomap_rw()
  iomap_apply()
    ->iomap_begin - allocates blocks
    dax_iomap_actor()
      invalidate_inode_pages2_range()
        - there's nothing to invalidate
				  grab_mapping_entry()
				  - we add zero page in the radix tree
				    and map it to page tables

The result is that hole page is mapped into page tables (and thus zeros
are seen in mmap) while file has data written in that place.

Fix the problem by locking exception entry before mapping blocks for the
fault.  That way we are sure invalidate_inode_pages2_range() call for
racing write will either block on entry lock waiting for the fault to
finish (and unmap stale page tables after that) or read fault will see
already allocated blocks by write(2).

Fixes: 9f141d6ef6258a3a37a045842d9ba7e68f368956
Link: http://lkml.kernel.org/r/20170510085419.27601-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/dax.c~dax-fix-data-corruption-when-fault-races-with-write fs/dax.c
--- a/fs/dax.c~dax-fix-data-corruption-when-fault-races-with-write
+++ a/fs/dax.c
@@ -1148,6 +1148,12 @@ static int dax_iomap_pte_fault(struct vm
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
 		flags |= IOMAP_WRITE;
 
+	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
+	if (IS_ERR(entry)) {
+		vmf_ret = dax_fault_return(PTR_ERR(entry));
+		goto out;
+	}
+
 	/*
 	 * Note that we don't bother to use iomap_apply here: DAX required
 	 * the file system block size to be equal the page size, which means
@@ -1156,17 +1162,11 @@ static int dax_iomap_pte_fault(struct vm
 	error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
 	if (error) {
 		vmf_ret = dax_fault_return(error);
-		goto out;
+		goto unlock_entry;
 	}
 	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
-		vmf_ret = dax_fault_return(-EIO);	/* fs corruption? */
-		goto finish_iomap;
-	}
-
-	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
-	if (IS_ERR(entry)) {
-		vmf_ret = dax_fault_return(PTR_ERR(entry));
-		goto finish_iomap;
+		error = -EIO;	/* fs corruption? */
+		goto error_finish_iomap;
 	}
 
 	sector = dax_iomap_sector(&iomap, pos);
@@ -1188,13 +1188,13 @@ static int dax_iomap_pte_fault(struct vm
 		}
 
 		if (error)
-			goto error_unlock_entry;
+			goto error_finish_iomap;
 
 		__SetPageUptodate(vmf->cow_page);
 		vmf_ret = finish_fault(vmf);
 		if (!vmf_ret)
 			vmf_ret = VM_FAULT_DONE_COW;
-		goto unlock_entry;
+		goto finish_iomap;
 	}
 
 	switch (iomap.type) {
@@ -1214,7 +1214,7 @@ static int dax_iomap_pte_fault(struct vm
 	case IOMAP_HOLE:
 		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
 			vmf_ret = dax_load_hole(mapping, &entry, vmf);
-			goto unlock_entry;
+			goto finish_iomap;
 		}
 		/*FALLTHRU*/
 	default:
@@ -1223,10 +1223,8 @@ static int dax_iomap_pte_fault(struct vm
 		break;
 	}
 
- error_unlock_entry:
+ error_finish_iomap:
 	vmf_ret = dax_fault_return(error) | major;
- unlock_entry:
-	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PAGE_SIZE;
@@ -1241,7 +1239,9 @@ static int dax_iomap_pte_fault(struct vm
 		 */
 		ops->iomap_end(inode, pos, PAGE_SIZE, copied, flags, &iomap);
 	}
-out:
+ unlock_entry:
+	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
+ out:
 	trace_dax_pte_fault_done(inode, vmf, vmf_ret);
 	return vmf_ret;
 }
_

Patches currently in -mm which might be from jack@suse.cz are


