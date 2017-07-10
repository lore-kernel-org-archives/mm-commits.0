From: akpm@linux-foundation.org
Subject: [patch 024/115] mm: improve readability of
 transparent_hugepage_enabled()
Date: Mon, 10 Jul 2017 15:48:22 -0700
Message-ID: <20170710224822.hqzE3eyDv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42242 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755060AbdGJWsX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:48:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org

From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: improve readability of transparent_hugepage_enabled()

Turn the macro into a static inline and rewrite the condition checks for
better readability in preparation for adding another condition.

[ross.zwisler@linux.intel.com: fix logic to make conversion equivalent]
[akpm@linux-foundation.org: resolve vs mm-make-pr_set_thp_disable-immediately-active.patch]
[akpm@linux-foundation.org: include coredump.h for MMF_DISABLE_THP]
Link: http://lkml.kernel.org/r/149739530612.20686.14760671150202647861.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   41 ++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff -puN include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled
+++ a/include/linux/huge_mm.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
+#include <linux/sched/coredump.h>
+
 extern int do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
@@ -85,15 +87,29 @@ extern struct kobj_attribute shmem_enabl
 
 extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
-#define transparent_hugepage_enabled(__vma)				\
-	((transparent_hugepage_flags &					\
-	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
-	  (transparent_hugepage_flags &					\
-	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
-	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
-	 !((__vma)->vm_flags & VM_NOHUGEPAGE) &&			\
-	 !test_bit(MMF_DISABLE_THP, &(__vma)->vm_mm->flags) &&		\
-	 !is_vma_temporary_stack(__vma))
+extern unsigned long transparent_hugepage_flags;
+
+static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_NOHUGEPAGE)
+		return false;
+
+	if (is_vma_temporary_stack(vma))
+		return false;
+
+	if (test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+		return false;
+
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
+		return true;
+
+	if (transparent_hugepage_flags &
+				(1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
+		return !!(vma->vm_flags & VM_HUGEPAGE);
+
+	return false;
+}
+
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
@@ -105,8 +121,6 @@ extern bool is_vma_temporary_stack(struc
 #define transparent_hugepage_debug_cow() 0
 #endif /* CONFIG_DEBUG_VM */
 
-extern unsigned long transparent_hugepage_flags;
