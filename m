From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-spurious-bad-pmd-warning-messages.patch
 removed from -mm tree
Date: Mon, 05 Jun 2017 12:02:57 -0700
Message-ID: <20170605190257.SpdgpDYMA%akpm__38969.0411197536$1496689383$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdFETC6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 15:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, darrick.wong@oracle.com, dave.hansen@intel.com, dave.jiang@intel.com, eguan@redhat.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org, pawel.lebioda@intel.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, xzhou@redhat.com


The patch titled
     Subject: mm: avoid spurious 'bad pmd' warning messages
has been removed from the -mm tree.  Its filename was
     mm-avoid-spurious-bad-pmd-warning-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: mm: avoid spurious 'bad pmd' warning messages

When the pmd_devmap() checks were added by 5c7fb56e5e3f ("mm, dax: dax-pmd
vs thp-pmd vs hugetlbfs-pmd") to add better support for DAX huge pages,
they were all added to the end of if() statements after existing
pmd_trans_huge() checks.  So, things like:

-       if (pmd_trans_huge(*pmd))
+       if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))

When further checks were added after pmd_trans_unstable() checks by
7267ec008b5c ("mm: postpone page table allocation until we have page to
map") they were also added at the end of the conditional:

+       if (pmd_trans_unstable(fe->pmd) || pmd_devmap(*fe->pmd))

This ordering is fine for pmd_trans_huge(), but doesn't work for
pmd_trans_unstable().  This is because DAX huge pages trip the bad_pmd()
check inside of pmd_none_or_trans_huge_or_clear_bad() (called by
pmd_trans_unstable()), which prints out a warning and returns 1.  So, we
do end up doing the right thing, but only after spamming dmesg with
suspicious looking messages:

mm/pgtable-generic.c:39: bad pmd ffff8808daa49b88(84000001006000a5)

Reorder these checks in a helper so that pmd_devmap() is checked first,
avoiding the error messages, and add a comment explaining why the ordering
is important.

Fixes: commit 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
Link: http://lkml.kernel.org/r/20170522215749.23516-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Pawel Lebioda <pawel.lebioda@intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Xiong Zhou <xzhou@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff -puN mm/memory.c~mm-avoid-spurious-bad-pmd-warning-messages mm/memory.c
--- a/mm/memory.c~mm-avoid-spurious-bad-pmd-warning-messages
+++ a/mm/memory.c
@@ -3029,6 +3029,17 @@ static int __do_fault(struct vm_fault *v
 	return ret;
 }
 
+/*
+ * The ordering of these checks is important for pmds with _PAGE_DEVMAP set.
+ * If we check pmd_trans_unstable() first we will trip the bad_pmd() check
+ * inside of pmd_none_or_trans_huge_or_clear_bad(). This will end up correctly
+ * returning 1 but not before it spams dmesg with the pmd_clear_bad() output.
+ */
+static int pmd_devmap_trans_unstable(pmd_t *pmd)
+{
+	return pmd_devmap(*pmd) || pmd_trans_unstable(pmd);
+}
+
 static int pte_alloc_one_map(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -3052,18 +3063,27 @@ static int pte_alloc_one_map(struct vm_f
 map_pte:
 	/*
 	 * If a huge pmd materialized under us just retry later.  Use
-	 * pmd_trans_unstable() instead of pmd_trans_huge() to ensure the pmd
-	 * didn't become pmd_trans_huge under us and then back to pmd_none, as
-	 * a result of MADV_DONTNEED running immediately after a huge pmd fault
-	 * in a different thread of this mm, in turn leading to a misleading
-	 * pmd_trans_huge() retval.  All we have to ensure is that it is a
-	 * regular pmd that we can walk with pte_offset_map() and we can do that
-	 * through an atomic read in C, which is what pmd_trans_unstable()
-	 * provides.
+	 * pmd_trans_unstable() via pmd_devmap_trans_unstable() instead of
+	 * pmd_trans_huge() to ensure the pmd didn't become pmd_trans_huge
+	 * under us and then back to pmd_none, as a result of MADV_DONTNEED
+	 * running immediately after a huge pmd fault in a different thread of
+	 * this mm, in turn leading to a misleading pmd_trans_huge() retval.
+	 * All we have to ensure is that it is a regular pmd that we can walk
+	 * with pte_offset_map() and we can do that through an atomic read in
+	 * C, which is what pmd_trans_unstable() provides.
 	 */
-	if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
+	if (pmd_devmap_trans_unstable(vmf->pmd))
 		return VM_FAULT_NOPAGE;
 
+	/*
+	 * At this point we know that our vmf->pmd points to a page of ptes
+	 * and it cannot become pmd_none(), pmd_devmap() or pmd_trans_huge()
+	 * for the duration of the fault.  If a racing MADV_DONTNEED runs and
+	 * we zap the ptes pointed to by our vmf->pmd, the vmf->ptl will still
+	 * be valid and we will re-check to make sure the vmf->pte isn't
+	 * pte_none() under vmf->ptl protection when we return to
+	 * alloc_set_pte().
+	 */
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
 	return 0;
@@ -3690,7 +3710,7 @@ static int handle_pte_fault(struct vm_fa
 		vmf->pte = NULL;
 	} else {
 		/* See comment in pte_alloc_one_map() */
-		if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
+		if (pmd_devmap_trans_unstable(vmf->pmd))
 			return 0;
 		/*
 		 * A regular pmd is established and it can't morph into a huge
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


