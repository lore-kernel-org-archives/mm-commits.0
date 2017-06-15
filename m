From: akpm@linux-foundation.org
Subject: + mm-always-enable-thp-for-dax-mappings.patch added to -mm tree
Date: Thu, 15 Jun 2017 13:10:30 -0700
Message-ID: <5942e9b6.ejuANDQdi1OU9DFL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFOUKb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: always enable thp for dax mappings
has been added to the -mm tree.  Its filename is
     mm-always-enable-thp-for-dax-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-always-enable-thp-for-dax-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-always-enable-thp-for-dax-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -142,11 +142,6 @@ static inline unsigned int dax_radix_ord
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
 #include <linux/fiemap.h>
@@ -3048,6 +3049,11 @@ static inline bool io_is_direct(struct f
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
@@ -1,6 +1,8 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
+#include <linux/fs.h> /* only for vma_is_dax() */
+
 extern int do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
@@ -101,6 +103,9 @@ static inline bool transparent_hugepage_
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

mm-improve-readability-of-transparent_hugepage_enabled.patch
mm-always-enable-thp-for-dax-mappings.patch

