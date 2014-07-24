From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-call-do_fault_around-for-non-linear-fault.patch removed from -mm
 tree
Date: Thu, 24 Jul 2014 13:47:19 -0700
Message-ID: <53d170d7.scnbbBLxODfhFJTf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62005 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651AbaGXUrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:47:20 -0400
Received: by mail-vc0-f201.google.com with SMTP id hu12so583304vcb.0
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:47:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, davej@redhat.com, hughd@google.com, ingo.korb@tu-dortmund.de, kirill.shutemov@linux.intel.com, quning@google.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not call do_fault_around for non-linear fault
has been removed from the -mm tree.  Its filename was
     mm-do-not-call-do_fault_around-for-non-linear-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: do not call do_fault_around for non-linear fault

Ingo Korb reported that "repeated mapping of the same file on tmpfs using
remap_file_pages sometimes triggers a BUG at mm/filemap.c:202 when the
process exits".  He bisected the bug to d7c1755179b82d ("mm: implement
->map_pages for shmem/tmpfs"), although the bug was actually added by
8c6e50b0290c4 ("mm: introduce vm_ops->map_pages()").

Problem is caused by calling do_fault_around for _non-linear_ faiult.  In
this case pgoff is shifted and might become negative during calculation.

Faulting around non-linear page-fault has no sense and breaks logic in
do_fault_around because pgoff is shifted.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: Ingo Korb <ingo.korb@tu-dortmund.de>
Tested-by: Ingo Korb <ingo.korb@tu-dortmund.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-do-not-call-do_fault_around-for-non-linear-fault mm/memory.c
--- a/mm/memory.c~mm-do-not-call-do_fault_around-for-non-linear-fault
+++ a/mm/memory.c
@@ -2882,7 +2882,8 @@ static int do_read_fault(struct mm_struc
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages && fault_around_pages() > 1) {
+	if (vma->vm_ops->map_pages && !(flags & FAULT_FLAG_NONLINEAR) &&
+	    fault_around_pages() > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch
scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch

