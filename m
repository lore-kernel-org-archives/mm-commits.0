From: akpm@linux-foundation.org
Subject: [merged] mm-uninline-page_mapped.patch removed from -mm tree
Date: Fri, 20 May 2016 14:04:55 -0700
Message-ID: <573f7bf7.A44S9r9hdDFbDoAZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcETVE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline page_mapped()
has been removed from the -mm tree.  Its filename was
     mm-uninline-page_mapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: uninline page_mapped()

It's huge.  Uninlining it saves 206 bytes per callsite.  Shaves 4924 bytes
from the x86_64 allmodconfig vmlinux.

[akpm@linux-foundation.org: coding-style fixes]
Cc: Steve Capper <steve.capper@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +--------------------
 mm/util.c          |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-page_mapped include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-page_mapped
+++ a/include/linux/mm.h
@@ -1032,26 +1032,7 @@ static inline pgoff_t page_file_index(st
 	return page->index;
 }
 
-/*
- * Return true if this page is mapped into pagetables.
- * For compound page it returns true if any subpage of compound page is mapped.
- */
-static inline bool page_mapped(struct page *page)
-{
-	int i;
-	if (likely(!PageCompound(page)))
-		return atomic_read(&page->_mapcount) >= 0;
-	page = compound_head(page);
-	if (atomic_read(compound_mapcount_ptr(page)) >= 0)
-		return true;
-	if (PageHuge(page))
-		return false;
-	for (i = 0; i < hpage_nr_pages(page); i++) {
-		if (atomic_read(&page[i]._mapcount) >= 0)
-			return true;
-	}
-	return false;
-}
+bool page_mapped(struct page *page);
 
 /*
  * Return true only if the page has been allocated with
diff -puN mm/util.c~mm-uninline-page_mapped mm/util.c
--- a/mm/util.c~mm-uninline-page_mapped
+++ a/mm/util.c
@@ -346,6 +346,29 @@ void *page_rmapping(struct page *page)
 	return __page_rmapping(page);
 }
 
+/*
+ * Return true if this page is mapped into pagetables.
+ * For compound page it returns true if any subpage of compound page is mapped.
+ */
+bool page_mapped(struct page *page)
+{
+	int i;
+
+	if (likely(!PageCompound(page)))
+		return atomic_read(&page->_mapcount) >= 0;
+	page = compound_head(page);
+	if (atomic_read(compound_mapcount_ptr(page)) >= 0)
+		return true;
+	if (PageHuge(page))
+		return false;
+	for (i = 0; i < hpage_nr_pages(page); i++) {
+		if (atomic_read(&page[i]._mapcount) >= 0)
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(page_mapped);
+
 struct anon_vma *page_anon_vma(struct page *page)
 {
 	unsigned long mapping;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-compact-fix-zoneindex-in-compact-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

