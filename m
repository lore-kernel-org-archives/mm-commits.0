From: akpm@linux-foundation.org
Subject: + mm-meminit-inline-some-helper-functions.patch added to -mm tree
Date: Wed, 29 Apr 2015 14:19:35 -0700
Message-ID: <55414ae7.9mTA+S9zOr4NoeEf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbbD2VTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 17:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: inline some helper functions
has been added to the -mm tree.  Its filename is
     mm-meminit-inline-some-helper-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-inline-some-helper-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-inline-some-helper-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: inline some helper functions

early_pfn_in_nid() and meminit_pfn_in_nid() are small functions that are
unnecessarily visible outside memory initialisation.  As well as
unnecessary visibility, it's unnecessary function call overhead when
initialising pages.  This patch moves the helpers inline.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Nate Zimmer <nzimmer@sgi.com>
Tested-by: Waiman Long <waiman.long@hp.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Nate Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 ----
 mm/page_alloc.c        |   76 ++++++++++++++++++++-------------------
 2 files changed, 39 insertions(+), 46 deletions(-)

diff -puN include/linux/mmzone.h~mm-meminit-inline-some-helper-functions include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-meminit-inline-some-helper-functions
+++ a/include/linux/mmzone.h
@@ -1227,15 +1227,6 @@ struct mminit_pfnnid_cache {
 	int last_nid;
 };
 
-#ifdef CONFIG_NODES_SPAN_OTHER_NODES
-bool early_pfn_in_nid(unsigned long pfn, int nid);
-bool meminit_pfn_in_nid(unsigned long pfn, int node,
-			struct mminit_pfnnid_cache *state);
-#else
-#define early_pfn_in_nid(pfn, nid)		(1)
-#define meminit_pfn_in_nid(pfn, nid, state)	(1)
-#endif
-
 #ifndef early_pfn_valid
 #define early_pfn_valid(pfn)	(1)
 #endif
diff -puN mm/page_alloc.c~mm-meminit-inline-some-helper-functions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-inline-some-helper-functions
+++ a/mm/page_alloc.c
@@ -913,6 +913,45 @@ void __init __free_pages_bootmem(struct
 	__free_pages(page, order);
 }
 
+#if defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) || \
+	defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
+/* Only safe to use early in boot when initialisation is single-threaded */
+static struct mminit_pfnnid_cache early_pfnnid_cache __meminitdata;
+
+int __meminit early_pfn_to_nid(unsigned long pfn)
+{
+	int nid;
+
+	/* The system will behave unpredictably otherwise */
+	BUG_ON(system_state != SYSTEM_BOOTING);
+
+	nid = __early_pfn_to_nid(pfn, &early_pfnnid_cache);
+	if (nid >= 0)
+		return nid;
+	/* just returns 0 */
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_NODES_SPAN_OTHER_NODES
+static inline bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
+					struct mminit_pfnnid_cache *state)
+{
+	int nid;
+
+	nid = __early_pfn_to_nid(pfn, state);
+	if (nid >= 0 && nid != node)
+		return false;
+	return true;
+}
+
+/* Only safe to use early in boot when initialisation is single-threaded */
+static inline bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+{
+	return meminit_pfn_in_nid(pfn, node, &early_pfnnid_cache);
+}
+#endif
+
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void __init init_cma_reserved_pageblock(struct page *page)
@@ -4530,43 +4569,6 @@ int __meminit __early_pfn_to_nid(unsigne
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
-static struct mminit_pfnnid_cache early_pfnnid_cache __meminitdata;
-
-/* Only safe to use early in boot when initialisation is single-threaded */
-int __meminit early_pfn_to_nid(unsigned long pfn)
-{
-	int nid;
-
-	/* The system will behave unpredictably otherwise */
-	BUG_ON(system_state != SYSTEM_BOOTING);
-
-	nid = __early_pfn_to_nid(pfn, &early_pfnnid_cache);
-	if (nid >= 0)
-		return nid;
-	/* just returns 0 */
-	return 0;
-}
-
-#ifdef CONFIG_NODES_SPAN_OTHER_NODES
-bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
-					struct mminit_pfnnid_cache *state)
-{
-	int nid;
-
-	nid = __early_pfn_to_nid(pfn, state);
-	if (nid >= 0 && nid != node)
-		return false;
-	return true;
-}
-
-/* Only safe to use early in boot when initialisation is single-threaded */
-bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
-{
-	return meminit_pfn_in_nid(pfn, node, &early_pfnnid_cache);
-}
-
-#endif
-
 /**
  * free_bootmem_with_active_regions - Call memblock_free_early_nid for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
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

