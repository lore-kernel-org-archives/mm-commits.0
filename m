From: akpm@linux-foundation.org
Subject: [merged] mm-always-enable-thp-for-dax-mappings.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:40 -0700
Message-ID: <20170711192340.xKABJEsEx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933694AbdGKTXl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com


The patch titled
     Subject: mm: always enable thp for dax mappings
has been removed from the -mm tree.  Its filename was
     mm-always-enable-thp-for-dax-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: always enable thp for dax mappings

The madvise policy for transparent huge pages is meant to avoid unwanted
allocations of transparent huge pages.  It allows a policy of disabling
the extra memory pressure and effort to arrange for a huge page when it is
not needed.

DAX by definition never incurs this overhead since it is statically
allocated.  The policy choice makes even less sense for device-dax which
tries to guarantee a given tlb-fault size.  Specifically, the following
setting:

	echo never > /sys/kernel/mm/transparent_hugepage/enabled

...violates that guarantee and silently disables all device-dax instances
with a 2M or 1G alignment.  So, let's avoid that non-obvious side effect
by force enabling thp for dax mappings in all cases.

It is worth noting that the reason this uses vma_is_dax(), and the
resulting header include changes, is that previous attempts to add a
VM_DAX flag were NAKd.

Link: http://lkml.kernel.org/r/149739531127.20686.15813586620597484283.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dax.h     |    5 -----
 include/linux/fs.h      |    6 ++++++
 include/linux/huge_mm.h |    5 +++++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff -puN include/linux/dax.h~mm-always-enable-thp-for-dax-mappings include/linux/dax.h
--- a/include/linux/dax.h~mm-always-enable-thp-for-dax-mappings
+++ a/include/linux/dax.h
@@ -154,11 +154,6 @@ static inline unsigned int dax_radix_ord
 #endif
 int dax_pfn_mkwrite(struct vm_fault *vmf);
 
-static inline bool vma_is_dax(struct vm_area_struct *vma)
-{
-	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
-}
-
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
diff -puN include/linux/fs.h~mm-always-enable-thp-for-dax-mappings include/linux/fs.h
--- a/include/linux/fs.h~mm-always-enable-thp-for-dax-mappings
+++ a/include/linux/fs.h
@@ -18,6 +18,7 @@
 #include <linux/bug.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/mm_types.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fcntl.h>
@@ -3127,6 +3128,11 @@ static inline bool io_is_direct(struct f
 	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
 }
 
+static inline bool vma_is_dax(struct vm_area_struct *vma)
+{
+	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
+}
+
 static inline int iocb_flags(struct file *file)
 {
 	int res = 0;
diff -puN include/linux/huge_mm.h~mm-always-enable-thp-for-dax-mappings include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-always-enable-thp-for-dax-mappings
+++ a/include/linux/huge_mm.h
@@ -3,6 +3,8 @@
 
 #include <linux/sched/coredump.h>
 
+#include <linux/fs.h> /* only for vma_is_dax() */
+
 extern int do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
@@ -103,6 +105,9 @@ static inline bool transparent_hugepage_
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
 		return true;
 
+	if (vma_is_dax(vma))
+		return true;
+
 	if (transparent_hugepage_flags &
 				(1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
 		return !!(vma->vm_flags & VM_HUGEPAGE);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


