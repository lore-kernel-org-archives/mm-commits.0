From: akpm@linux-foundation.org
Subject: [merged] thp-compound_lock.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:22 -0800
Message-ID: <201101142249.p0EMnCOf005275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776Ab1ANWtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: compound_lock
has been removed from the -mm tree.  Its filename was
     thp-compound_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: compound_lock
From: Andrea Arcangeli <aarcange@redhat.com>

Add a new compound_lock() needed to serialize put_page against
__split_huge_page_refcount().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |   34 ++++++++++++++++++++++++++++++++++
 include/linux/page-flags.h |   12 +++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~thp-compound_lock include/linux/mm.h
--- a/include/linux/mm.h~thp-compound_lock
+++ a/include/linux/mm.h
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/range.h>
 #include <linux/pfn.h>
+#include <linux/bit_spinlock.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -305,6 +306,39 @@ static inline int is_vmalloc_or_module_a
 }
 #endif
 
+static inline void compound_lock(struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bit_spin_lock(PG_compound_lock, &page->flags);
+#endif
+}
+
+static inline void compound_unlock(struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bit_spin_unlock(PG_compound_lock, &page->flags);
+#endif
+}
+
+static inline unsigned long compound_lock_irqsave(struct page *page)
+{
+	unsigned long uninitialized_var(flags);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	local_irq_save(flags);
+	compound_lock(page);
+#endif
+	return flags;
+}
+
+static inline void compound_unlock_irqrestore(struct page *page,
+					      unsigned long flags)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	compound_unlock(page);
+	local_irq_restore(flags);
+#endif
+}
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
diff -puN include/linux/page-flags.h~thp-compound_lock include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-compound_lock
+++ a/include/linux/page-flags.h
@@ -108,6 +108,9 @@ enum pageflags {
 #ifdef CONFIG_MEMORY_FAILURE
 	PG_hwpoison,		/* hardware poisoned page. Don't touch */
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	PG_compound_lock,
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -397,6 +400,12 @@ static inline void __ClearPageTail(struc
 #define __PG_MLOCKED		0
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define __PG_COMPOUND_LOCK		(1 << PG_compound_lock)
+#else
+#define __PG_COMPOUND_LOCK		0
+#endif
+
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
  * these flags set.  It they are, there is a problem.
@@ -406,7 +415,8 @@ static inline void __ClearPageTail(struc
 	 1 << PG_private | 1 << PG_private_2 | \
 	 1 << PG_buddy	 | 1 << PG_writeback | 1 << PG_reserved | \
 	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
-	 1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON)
+	 1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON | \
+	 __PG_COMPOUND_LOCK)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

