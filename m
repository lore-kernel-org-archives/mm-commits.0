From: akpm@linux-foundation.org
Subject: [merged] mm-disable-numa-migration-faults-for-dax-vmas.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:25:01 -0800
Message-ID: <58519c8d.WxUaONEQiLJYYmKY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable numa migration faults for dax vmas
has been removed from the -mm tree.  Its filename was
     mm-disable-numa-migration-faults-for-dax-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: disable numa migration faults for dax vmas

Mark dax vmas as not migratable to exclude them from task_numa_work(). 
This is especially relevant for device-dax which wants to ensure
predictable access latency and not incur periodic faults.

[akpm@linux-foundation.org: add comment]
Link: http://lkml.kernel.org/r/147892450132.22062.16875659431109209179.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/mempolicy.h~mm-disable-numa-migration-faults-for-dax-vmas include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-disable-numa-migration-faults-for-dax-vmas
+++ a/include/linux/mempolicy.h
@@ -7,6 +7,7 @@
 
 
 #include <linux/mmzone.h>
+#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
@@ -177,6 +178,13 @@ static inline bool vma_migratable(struct
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return false;
 
+	/*
+	 * DAX device mappings require predictable access latency, so avoid
+	 * incurring periodic faults.
+	 */
+	if (vma_is_dax(vma))
+		return false;
+
 #ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	if (vma->vm_flags & VM_HUGETLB)
 		return false;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


