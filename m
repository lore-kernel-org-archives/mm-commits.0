From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-track-active-portions-of-a-section-at-boot-fix.patch removed from -mm
 tree
Date: Wed, 15 Feb 2017 13:49:12 -0800
Message-ID: <58a4ccd8.IqpK2H7jSvkj4TK5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752127AbdBOVtO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-track-active-portions-of-a-section-at-boot-fix
has been removed from the -mm tree.  Its filename was
     mm-track-active-portions-of-a-section-at-boot-fix.patch

This patch was dropped because it was folded into mm-track-active-portions-of-a-section-at-boot.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-track-active-portions-of-a-section-at-boot-fix

make section_active_init() init, use static inline for stub

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++++-
 mm/sparse.c            |    8 ++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-track-active-portions-of-a-section-at-boot-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-track-active-portions-of-a-section-at-boot-fix
+++ a/include/linux/mmzone.h
@@ -1087,7 +1087,7 @@ struct mem_section_usage {
 	unsigned long pageblock_flags[0];
 };
 
-void section_active_init(unsigned long pfn, unsigned long nr_pages);
+void __init section_active_init(unsigned long pfn, unsigned long nr_pages);
 
 struct page;
 struct page_ext;
@@ -1230,6 +1230,10 @@ void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
+static inline void section_active_init(unsigned long pfn,
+				       unsigned long nr_pages)
+{
+}
 #define section_active_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
diff -puN mm/sparse.c~mm-track-active-portions-of-a-section-at-boot-fix mm/sparse.c
--- a/mm/sparse.c~mm-track-active-portions-of-a-section-at-boot-fix
+++ a/mm/sparse.c
@@ -168,13 +168,13 @@ void __meminit mminit_validate_memmodel_
 	}
 }
 
-static int section_active_index(phys_addr_t phys)
+static int __init section_active_index(phys_addr_t phys)
 {
 	return (phys & ~(PA_SECTION_MASK)) / SECTION_ACTIVE_SIZE;
 }
 
-static unsigned long section_active_mask(unsigned long pfn,
-		unsigned long nr_pages)
+static unsigned long __init section_active_mask(unsigned long pfn,
+						unsigned long nr_pages)
 {
 	int idx_start, idx_size;
 	phys_addr_t start, size;
@@ -195,7 +195,7 @@ static unsigned long section_active_mask
 	return ((1UL << idx_size) - 1) << idx_start;
 }
 
-void section_active_init(unsigned long pfn, unsigned long nr_pages)
+void __init section_active_init(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
 	int i, start_sec = pfn_to_section_nr(pfn);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
scripts-spellingtxt-fix-incorrect-typo-words-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

