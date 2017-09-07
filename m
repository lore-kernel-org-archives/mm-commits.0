From: akpm@linux-foundation.org
Subject: [merged]
 mm-mremap-fail-map-duplication-attempts-for-private-mappings.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:38:28 -0700
Message-ID: <20170907183828.Hj92Qd4_z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754859AbdIGSi3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, aaron.lu@intel.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/mremap: fail map duplication attempts for private mappings
has been removed from the -mm tree.  Its filename was
     mm-mremap-fail-map-duplication-attempts-for-private-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/mremap: fail map duplication attempts for private mappings

mremap will attempt to create a 'duplicate' mapping if old_size == 0 is
specified.  In the case of private mappings, mremap will actually create a
fresh separate private mapping unrelated to the original.  This does not
fit with the design semantics of mremap as the intention is to create a
new mapping based on the original.

Therefore, return EINVAL in the case where an attempt is made to duplicate
a private mapping.  Also, print a warning message (once) if such an
attempt is made.

Link: http://lkml.kernel.org/r/cb9d9f6a-7095-582f-15a5-62643d65c736@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/mremap.c~mm-mremap-fail-map-duplication-attempts-for-private-mappings mm/mremap.c
--- a/mm/mremap.c~mm-mremap-fail-map-duplication-attempts-for-private-mappings
+++ a/mm/mremap.c
@@ -384,6 +384,19 @@ static struct vm_area_struct *vma_to_res
 	if (!vma || vma->vm_start > addr)
 		return ERR_PTR(-EFAULT);
 
+	/*
+	 * !old_len is a special case where an attempt is made to 'duplicate'
+	 * a mapping.  This makes no sense for private mappings as it will
+	 * instead create a fresh/new mapping unrelated to the original.  This
+	 * is contrary to the basic idea of mremap which creates new mappings
+	 * based on the original.  There are no known use cases for this
+	 * behavior.  As a result, fail such attempts.
+	 */
+	if (!old_len && !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE))) {
+		pr_warn_once("%s (%d): attempted to duplicate a private mapping with mremap.  This is not supported.\n", current->comm, current->pid);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (is_vm_hugetlb_page(vma))
 		return ERR_PTR(-EINVAL);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


