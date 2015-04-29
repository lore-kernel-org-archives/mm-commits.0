From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch removed from -mm tree
Date: Wed, 29 Apr 2015 13:36:35 -0700
Message-ID: <554140d3.cnnH/NUFy9W9fgcx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbD2Ugg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, holt@sgi.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: make __early_pfn_to_nid SMP-safe and introduce meminit_pfn_in_nid
has been removed from the -mm tree.  Its filename was
     mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: make __early_pfn_to_nid SMP-safe and introduce meminit_pfn_in_nid

__early_pfn_to_nid() in the generic and arch-specific implementations use
static variables to cache recent lookups.  Without the cache boot times
are much higher due to the excessive memblock lookups but it assumes that
memory initialisation is single-threaded.  Parallel initialisation of
struct pages will break that assumption so this patch makes
__early_pfn_to_nid() SMP-safe by requiring the caller to cache recent
search information.  early_pfn_to_nid() keeps the same interface but is
only safe to use early in boot due to the use of a global static variable.
 meminit_pfn_in_nid() is an SMP-safe version that callers must maintain
their own state for.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/numa.c    |   19 ++++++------------
 include/linux/mm.h     |    6 +++--
 include/linux/mmzone.h |   16 ++++++++++++++-
 mm/page_alloc.c        |   40 ++++++++++++++++++++++++---------------
 4 files changed, 51 insertions(+), 30 deletions(-)

diff -puN arch/ia64/mm/numa.c~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid
+++ a/arch/ia64/mm/numa.c
@@ -58,27 +58,22 @@ paddr_to_nid(unsigned long paddr)
  * SPARSEMEM to allocate the SPARSEMEM sectionmap on the NUMA node where
  * the section resides.
  */
-int __meminit __early_pfn_to_nid(unsigned long pfn)
+int __meminit __early_pfn_to_nid(unsigned long pfn,
+					struct mminit_pfnnid_cache *state)
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
-	/*
-	 * NOTE: The following SMP-unsafe globals are only used early in boot
-	 * when the kernel is running single-threaded.
-	 */
-	static int __meminitdata last_ssec, last_esec;
-	static int __meminitdata last_nid;
 
-	if (section >= last_ssec && section < last_esec)
-		return last_nid;
+	if (section >= state->last_start && section < state->last_end)
+		return state->last_nid;
 
 	for (i = 0; i < num_node_memblks; i++) {
 		ssec = node_memblk[i].start_paddr >> PA_SECTION_SHIFT;
 		esec = (node_memblk[i].start_paddr + node_memblk[i].size +
 			((1L << PA_SECTION_SHIFT) - 1)) >> PA_SECTION_SHIFT;
 		if (section >= ssec && section < esec) {
-			last_ssec = ssec;
-			last_esec = esec;
-			last_nid = node_memblk[i].nid;
+			state->last_start = ssec;
+			state->last_end = esec;
+			state->last_nid = node_memblk[i].nid;
 			return node_memblk[i].nid;
 		}
 	}
diff -puN include/linux/mm.h~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid include/linux/mm.h
--- a/include/linux/mm.h~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid
+++ a/include/linux/mm.h
@@ -1722,7 +1722,8 @@ extern void sparse_memory_present_with_a
 
 #if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
     !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
-static inline int __early_pfn_to_nid(unsigned long pfn)
+static inline int __early_pfn_to_nid(unsigned long pfn,
+					struct mminit_pfnnid_cache *state)
 {
 	return 0;
 }
@@ -1730,7 +1731,8 @@ static inline int __early_pfn_to_nid(uns
 /* please see mm/page_alloc.c */
 extern int __meminit early_pfn_to_nid(unsigned long pfn);
 /* there is a per-arch backend function. */
-extern int __meminit __early_pfn_to_nid(unsigned long pfn);
+extern int __meminit __early_pfn_to_nid(unsigned long pfn,
+					struct mminit_pfnnid_cache *state);
 #endif
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
diff -puN include/linux/mmzone.h~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid
+++ a/include/linux/mmzone.h
@@ -1216,10 +1216,24 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
+/*
+ * During memory init memblocks map pfns to nids. The search is expensive and
+ * this caches recent lookups. The implementation of __early_pfn_to_nid
+ * may treat start/end as pfns or sections.
+ */
+struct mminit_pfnnid_cache {
+	unsigned long last_start;
+	unsigned long last_end;
+	int last_nid;
+};
+
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
 bool early_pfn_in_nid(unsigned long pfn, int nid);
+bool meminit_pfn_in_nid(unsigned long pfn, int node,
+			struct mminit_pfnnid_cache *state);
 #else
-#define early_pfn_in_nid(pfn, nid)	(1)
+#define early_pfn_in_nid(pfn, nid)		(1)
+#define meminit_pfn_in_nid(pfn, nid, state)	(1)
 #endif
 
 #ifndef early_pfn_valid
diff -puN mm/page_alloc.c~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid
+++ a/mm/page_alloc.c
@@ -4500,39 +4500,41 @@ int __meminit init_currently_empty_zone(
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
+
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
  */
-int __meminit __early_pfn_to_nid(unsigned long pfn)
+int __meminit __early_pfn_to_nid(unsigned long pfn,
+					struct mminit_pfnnid_cache *state)
 {
 	unsigned long start_pfn, end_pfn;
 	int nid;
-	/*
-	 * NOTE: The following SMP-unsafe globals are only used early in boot
-	 * when the kernel is running single-threaded.
-	 */
-	static unsigned long __meminitdata last_start_pfn, last_end_pfn;
-	static int __meminitdata last_nid;
 
-	if (last_start_pfn <= pfn && pfn < last_end_pfn)
-		return last_nid;
+	if (state->last_start <= pfn && pfn < state->last_end)
+		return state->last_nid;
 
 	nid = memblock_search_pfn_nid(pfn, &start_pfn, &end_pfn);
 	if (nid != -1) {
-		last_start_pfn = start_pfn;
-		last_end_pfn = end_pfn;
-		last_nid = nid;
+		state->last_start = start_pfn;
+		state->last_end = end_pfn;
+		state->last_nid = nid;
 	}
 
 	return nid;
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
+struct __meminitdata mminit_pfnnid_cache global_init_state;
+
+/* Only safe to use early in boot when initialisation is single-threaded */
 int __meminit early_pfn_to_nid(unsigned long pfn)
 {
 	int nid;
 
-	nid = __early_pfn_to_nid(pfn);
+	/* The system will behave unpredictably otherwise */
+	BUG_ON(system_state != SYSTEM_BOOTING);
+
+	nid = __early_pfn_to_nid(pfn, &global_init_state);
 	if (nid >= 0)
 		return nid;
 	/* just returns 0 */
@@ -4540,15 +4542,23 @@ int __meminit early_pfn_to_nid(unsigned
 }
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
-bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
+					struct mminit_pfnnid_cache *state)
 {
 	int nid;
 
-	nid = __early_pfn_to_nid(pfn);
+	nid = __early_pfn_to_nid(pfn, state);
 	if (nid >= 0 && nid != node)
 		return false;
 	return true;
 }
+
+/* Only safe to use early in boot when initialisation is single-threaded */
+bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+{
+	return meminit_pfn_in_nid(pfn, node, &global_init_state);
+}
+
 #endif
 
 /**
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-inline-some-helper-functions-checkpatch-fixes.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

