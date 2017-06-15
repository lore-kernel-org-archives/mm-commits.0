From: akpm@linux-foundation.org
Subject: + mm-improve-readability-of-transparent_hugepage_enabled.patch
 added to -mm tree
Date: Thu, 15 Jun 2017 13:10:26 -0700
Message-ID: <5942e9b2.IBVAoG6L8iMAbknD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFOUK1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve readability of transparent_hugepage_enabled()
has been added to the -mm tree.  Its filename is
     mm-improve-readability-of-transparent_hugepage_enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-improve-readability-of-transparent_hugepage_enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-readability-of-transparent_hugepage_enabled.patch

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
Subject: mm: improve readability of transparent_hugepage_enabled()

Turn the macro into a static inline and rewrite the condition checks for
better readability in preparation for adding another condition.

[ross.zwisler@linux.intel.com: fix logic to make conversion equivalent]
Link: http://lkml.kernel.org/r/149739530612.20686.14760671150202647861.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff -puN include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled
+++ a/include/linux/huge_mm.h
@@ -85,15 +85,23 @@ extern struct kobj_attribute shmem_enabl
 
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
+	if ((vma->vm_flags & VM_NOHUGEPAGE) || is_vma_temporary_stack(vma))
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
@@ -105,8 +113,6 @@ extern bool is_vma_temporary_stack(struc
 #define transparent_hugepage_debug_cow() 0
 #endif /* CONFIG_DEBUG_VM */
 
-extern unsigned long transparent_hugepage_flags;
