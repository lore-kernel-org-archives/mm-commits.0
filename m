From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch removed from -mm tree
Date: Tue, 15 Mar 2016 14:36:04 -0700
Message-ID: <56e88044.lEPbEZA4fAIIjnrX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbcCOVgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-clean-up-debug_pagealloc-processing-code-fix
has been removed from the -mm tree.  Its filename was
     mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch

This patch was dropped because it was folded into mm-slab-clean-up-debug_pagealloc-processing-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slab-clean-up-debug_pagealloc-processing-code-fix

fix build with CONFIG_DEBUG_PAGEALLOC=n

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-slab-clean-up-debug_pagealloc-processing-code-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-slab-clean-up-debug_pagealloc-processing-code-fix
+++ a/include/linux/mm.h
@@ -2194,14 +2194,18 @@ kernel_map_pages(struct page *page, int
 }
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
-#endif /* CONFIG_HIBERNATION */
-#else
+#endif	/* CONFIG_HIBERNATION */
+#else	/* CONFIG_DEBUG_PAGEALLOC */
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
-#endif /* CONFIG_HIBERNATION */
-#endif
+#endif	/* CONFIG_HIBERNATION */
+static inline bool debug_pagealloc_enabled(void)
+{
+	return false;
+}
+#endif	/* CONFIG_DEBUG_PAGEALLOC */
 
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

