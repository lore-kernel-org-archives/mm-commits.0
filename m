From: akpm@linux-foundation.org
Subject: + mm-thp-remove-debug_cow-switch.patch added to -mm tree
Date: Tue, 16 Jun 2020 11:52:10 -0700
Message-ID: <20200616185210.6Lm9-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgFPSwL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 14:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: thp: remove debug_cow switch
has been added to the -mm tree.  Its filename is
     mm-thp-remove-debug_cow-switch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-remove-debug_cow-switch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-remove-debug_cow-switch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: thp: remove debug_cow switch

Since commit 3917c80280c93a7123f ("thp: change CoW semantics for
anon-THP"), the CoW page fault of THP has been rewritten, debug_cow is not
used anymore.  So, just remove it.

Link: http://lkml.kernel.org/r/1592270980-116062-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 -------
 mm/huge_memory.c        |   21 ---------------------
 2 files changed, 28 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-remove-debug_cow-switch
+++ a/include/linux/huge_mm.h
@@ -181,13 +181,6 @@ static inline bool transhuge_vma_suitabl
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
-#ifdef CONFIG_DEBUG_VM
-#define transparent_hugepage_debug_cow()				\
-	(transparent_hugepage_flags &					\
-	 (1<<TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG))
-#else /* CONFIG_DEBUG_VM */
-#define transparent_hugepage_debug_cow() 0
-#endif /* CONFIG_DEBUG_VM */
 
 extern unsigned long thp_get_unmapped_area(struct file *filp,
 		unsigned long addr, unsigned long len, unsigned long pgoff,
--- a/mm/huge_memory.c~mm-thp-remove-debug_cow-switch
+++ a/mm/huge_memory.c
@@ -303,24 +303,6 @@ static ssize_t hpage_pmd_size_show(struc
 static struct kobj_attribute hpage_pmd_size_attr =
 	__ATTR_RO(hpage_pmd_size);
 
-#ifdef CONFIG_DEBUG_VM
-static ssize_t debug_cow_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf)
-{
-	return single_hugepage_flag_show(kobj, attr, buf,
-				TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG);
-}
-static ssize_t debug_cow_store(struct kobject *kobj,
-			       struct kobj_attribute *attr,
-			       const char *buf, size_t count)
-{
-	return single_hugepage_flag_store(kobj, attr, buf, count,
-				 TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG);
-}
-static struct kobj_attribute debug_cow_attr =
-	__ATTR(debug_cow, 0644, debug_cow_show, debug_cow_store);
-#endif /* CONFIG_DEBUG_VM */
