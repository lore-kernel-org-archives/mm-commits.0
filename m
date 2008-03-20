From: akpm@linux-foundation.org
Subject: + get-rid-of-__zone_count.patch added to -mm tree
Date: Thu, 20 Mar 2008 13:28:47 -0700
Message-ID: <200803202028.m2KKSmd7022676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760311AbYCTUa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 16:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, apw@shadowen.org, jeremy@goop.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     mm: get rid of __ZONE_COUNT
has been added to the -mm tree.  Its filename is
     get-rid-of-__zone_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: get rid of __ZONE_COUNT
From: Christoph Lameter <clameter@sgi.com>

It was used to compensate because MAX_NR_ZONES was not available to the
#ifdefs.  Export MAX_NR_ZONES via the new mechanism and get rid of
__ZONE_COUNT.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   28 +++++++++++-----------------
 kernel/bounds.c        |    2 ++
 2 files changed, 13 insertions(+), 17 deletions(-)

diff -puN include/linux/mmzone.h~get-rid-of-__zone_count include/linux/mmzone.h
--- a/include/linux/mmzone.h~get-rid-of-__zone_count
+++ a/include/linux/mmzone.h
@@ -3,6 +3,7 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
+#ifndef __GENERATING_BOUNDS_H
 
 #include <linux/spinlock.h>
 #include <linux/list.h>
@@ -15,6 +16,7 @@
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
+#include <linux/bounds.h>
 #include <asm/atomic.h>
 #include <asm/page.h>
 
@@ -129,6 +131,8 @@ struct per_cpu_pageset {
 #define zone_pcp(__z, __cpu) (&(__z)->pageset[(__cpu)])
 #endif
 
+#endif /* !__GENERATING_BOUNDS.H */
+
 enum zone_type {
 #ifdef CONFIG_ZONE_DMA
 	/*
@@ -177,9 +181,11 @@ enum zone_type {
 	ZONE_HIGHMEM,
 #endif
 	ZONE_MOVABLE,
-	MAX_NR_ZONES
+	__MAX_NR_ZONES
 };
 
+#ifndef __GENERATING_BOUNDS_H
+
 /*
  * When a memory allocation must conform to specific limitations (such
  * as being suitable for DMA) the caller will pass in hints to the
@@ -188,28 +194,15 @@ enum zone_type {
  * match the requested limits. See gfp_zone() in include/linux/gfp.h
  */
 
-/*
- * Count the active zones.  Note that the use of defined(X) outside
- * #if and family is not necessarily defined so ensure we cannot use
- * it later.  Use __ZONE_COUNT to work out how many shift bits we need.
- */
-#define __ZONE_COUNT (			\
-	  defined(CONFIG_ZONE_DMA)	\
-	+ defined(CONFIG_ZONE_DMA32)	\
-	+ 1				\
-	+ defined(CONFIG_HIGHMEM)	\
-	+ 1				\
-)
-#if __ZONE_COUNT < 2
+#if MAX_NR_ZONES < 2
 #define ZONES_SHIFT 0
-#elif __ZONE_COUNT <= 2
+#elif MAX_NR_ZONES <= 2
 #define ZONES_SHIFT 1
-#elif __ZONE_COUNT <= 4
+#elif MAX_NR_ZONES <= 4
 #define ZONES_SHIFT 2
 #else
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
-#undef __ZONE_COUNT
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */
@@ -1027,6 +1020,7 @@ unsigned long __init node_memmap_size_by
 #define pfn_valid_within(pfn) (1)
 #endif
 
+#endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MMZONE_H */
diff -puN kernel/bounds.c~get-rid-of-__zone_count kernel/bounds.c
--- a/kernel/bounds.c~get-rid-of-__zone_count
+++ a/kernel/bounds.c
@@ -7,6 +7,7 @@
 #define __GENERATING_BOUNDS_H
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
+#include <linux/mmzone.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -17,5 +18,6 @@ void foo(void)
 {
 	/* The enum constants to put into include/linux/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
+	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 	/* End of constants */
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

mm-fix-boundary-checking-in-free_bootmem_core.patch
mm-fix-boundary-checking-in-free_bootmem_core-fix.patch
x86_64-free_bootmem-should-take-phy.patch
git-unionfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mm-make-mem_map-allocation-continuous.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
get-rid-of-__zone_count.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

