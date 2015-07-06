From: akpm@linux-foundation.org
Subject: [merged] mm-meminit-inline-some-helper-functions.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:46:16 -0700
Message-ID: <559adb08.MJ56LMYgJxxaJ9XC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbbGFTqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mhocko@suse.cz, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: inline some helper functions
has been removed from the -mm tree.  Its filename was
     mm-meminit-inline-some-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: inline some helper functions

early_pfn_in_nid() and meminit_pfn_in_nid() are small functions that are
unnecessarily visible outside memory initialisation.  As well as
unnecessary visibility, it's unnecessary function call overhead when
initialising pages.  This patch moves the helpers inline.

[akpm@linux-foundation.org: fix build]
[mhocko@suse.cz: fix build]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Nate Zimmer <nzimmer@sgi.com>
Tested-by: Waiman Long <waiman.long@hp.com>
Tested-by: Daniel J Blueman <daniel@numascale.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Nate Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 ---
 mm/page_alloc.c        |   89 ++++++++++++++++++++++-----------------
 2 files changed, 52 insertions(+), 46 deletions(-)

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
@@ -899,6 +899,58 @@ void __init __free_pages_bootmem(struct
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
+
+#else
+
+static inline bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+{
+	return true;
+}
+static inline bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
+					struct mminit_pfnnid_cache *state)
+{
+	return true;
+}
+#endif
+
+
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void __init init_cma_reserved_pageblock(struct page *page)
@@ -4575,43 +4627,6 @@ int __meminit __early_pfn_to_nid(unsigne
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

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
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
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

