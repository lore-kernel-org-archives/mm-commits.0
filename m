From: akpm@linux-foundation.org
Subject: +
 mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7.patch added to -mm tree
Date: Tue, 17 Jan 2017 16:28:22 -0800
Message-ID: <587eb6a6.S0am27JnKCuLma+g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdARAia (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 19:38:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, david@fromorbit.com, jack@suse.cz, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7
has been added to the -mm tree.  Its filename is
     mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jiang <dave.jiang@intel.com>
Subject: mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7

v7:
Xiong found issue with xfs_tests stall when DAX option is turned out. It
seems the issue has to do with dax_iomap_pmd_fault(). The pgoff needs
to be linear_page_index(vma, vmf->address & PMD_MASK) in this funciton.
However, the passed in address is linear_page_index(vma, vmf->address)
and based on the PTE and not the PMD. The vmf->pgoff needs to be what was
passed in when returned. Therefore we go back to having a local variable
of pgoff in the dax_iomap_pmd_fault that is based on address & PMD_MASK.

Link: http://lkml.kernel.org/r/148469861071.195597.3619476895250028518.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/dax.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7 fs/dax.c
--- a/fs/dax.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7
+++ a/fs/dax.c
@@ -1341,7 +1341,7 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	struct inode *inode = mapping->host;
 	int result = VM_FAULT_FALLBACK;
 	struct iomap iomap = { 0 };
-	pgoff_t max_pgoff;
+	pgoff_t max_pgoff, pgoff;
 	void *entry;
 	loff_t pos;
 	int error;
@@ -1351,7 +1351,7 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	 * supposed to hold locks serializing us with truncate / punch hole so
 	 * this is a reliable test.
 	 */
-	vmf->pgoff = linear_page_index(vma, pmd_addr);
+	pgoff = linear_page_index(vma, pmd_addr);
 	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
 	trace_dax_pmd_fault(inode, vma, vmf, max_pgoff, 0);
@@ -1366,13 +1366,13 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
 		goto fallback;
 
-	if (vmf->pgoff > max_pgoff) {
+	if (pgoff > max_pgoff) {
 		result = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
 	/* If the PMD would extend beyond the file size */
-	if ((vmf->pgoff | PG_PMD_COLOUR) > max_pgoff)
+	if ((pgoff | PG_PMD_COLOUR) > max_pgoff)
 		goto fallback;
 
 	/*
@@ -1380,7 +1380,7 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	 * setting up a mapping, so really we're using iomap_begin() as a way
 	 * to look up our filesystem block.
 	 */
-	pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
+	pos = (loff_t)pgoff << PAGE_SHIFT;
 	error = ops->iomap_begin(inode, pos, PMD_SIZE, iomap_flags, &iomap);
 	if (error)
 		goto fallback;
@@ -1394,7 +1394,7 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	 * the tree, for instance), it will return -EEXIST and we just fall
 	 * back to 4k entries.
 	 */
-	entry = grab_mapping_entry(mapping, vmf->pgoff, RADIX_DAX_PMD);
+	entry = grab_mapping_entry(mapping, pgoff, RADIX_DAX_PMD);
 	if (IS_ERR(entry))
 		goto finish_iomap;
 
@@ -1416,7 +1416,7 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	}
 
  unlock_entry:
-	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
+	put_locked_mapping_entry(mapping, pgoff, entry);
  finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PMD_SIZE;
_

Patches currently in -mm which might be from dave.jiang@intel.com are

mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch
mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7.patch
mm-dax-move-pmd_fault-to-take-only-vmf-parameter.patch

