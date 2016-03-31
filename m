From: akpm@linux-foundation.org
Subject: + mm-uninline-page_mapped.patch added to -mm tree
Date: Thu, 31 Mar 2016 16:07:01 -0700
Message-ID: <56fdad95./IlaS7HiFfpbfD54%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbcCaXHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 19:07:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline page_mapped()
has been added to the -mm tree.  Its filename is
     mm-uninline-page_mapped.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-uninline-page_mapped.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-uninline-page_mapped.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: uninline page_mapped()

It's huge.  Uninlining it saves 206 bytes per callsite.  Shaves 4924 bytes
from the x86_64 allmodconfig vmlinux.

Cc: Steve Capper <steve.capper@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +--------------------
 mm/util.c          |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-page_mapped include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-page_mapped
+++ a/include/linux/mm.h
@@ -1019,26 +1019,7 @@ static inline pgoff_t page_file_index(st
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
@@ -346,6 +346,28 @@ void *page_rmapping(struct page *page)
 	return __page_rmapping(page);
 }
 
+/*
+ * Return true if this page is mapped into pagetables.
+ * For compound page it returns true if any subpage of compound page is mapped.
+ */
+bool page_mapped(struct page *page)
+{
+	int i;
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
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

