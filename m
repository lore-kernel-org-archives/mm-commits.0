From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:14:07 -0800
Message-ID: <58af509f.fJ1xSPBt++jz6KS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdBWVOs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: add userfaultfd hugetlb hook
has been removed from the -mm tree.  Its filename was
     userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: add userfaultfd hugetlb hook

When processing a hugetlb fault for no page present, check the vma to
determine if faults are to be handled via userfaultfd.  If so, drop the
hugetlb_fault_mutex and call handle_userfault().

Link: http://lkml.kernel.org/r/20161216144821.5183-21-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook
+++ a/mm/hugetlb.c
@@ -32,6 +32,7 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
+#include <linux/userfaultfd_k.h>
 #include "internal.h"
 
 int hugepages_treat_as_movable;
@@ -3680,6 +3681,38 @@ retry:
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		if (idx >= size)
 			goto out;
+
+		/*
+		 * Check for page in userfault range
+		 */
+		if (userfaultfd_missing(vma)) {
+			u32 hash;
+			struct vm_fault vmf = {
+				.vma = vma,
+				.address = address,
+				.flags = flags,
+				/*
+				 * Hard to debug if it ends up being
+				 * used by a callee that assumes
+				 * something about the other
+				 * uninitialized fields... same as in
+				 * memory.c
+				 */
+			};
+
+			/*
+			 * hugetlb_fault_mutex must be dropped before
+			 * handling userfault.  Reacquire after handling
+			 * fault to make calling code simpler.
+			 */
+			hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping,
+							idx, address);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+			goto out;
+		}
+
 		page = alloc_huge_page(vma, address, 0);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


