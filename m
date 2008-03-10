From: akpm@linux-foundation.org
Subject: + get-rid-of-__zone_count.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:01:21 -0700
Message-ID: <200803101901.m2AJ1Lt3000456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYCJTBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     get rid of __ZONE_COUNT
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
Subject: get rid of __ZONE_COUNT
From: Christoph Lameter <clameter@sgi.com>

It was used to compensate because MAX_NR_ZONES was not available to the
#ifdefs.  Export MAX_NR_ZONES via the new mechanism and get rid of
__ZONE_COUNT.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   28 +++++++++++-----------------
 kernel/bounds.c        |    1 +
 2 files changed, 12 insertions(+), 17 deletions(-)

diff -puN include/linux/mmzone.h~get-rid-of-__zone_count include/linux/mmzone.h
--- a/include/linux/mmzone.h~get-rid-of-__zone_count
+++ a/include/linux/mmzone.h
@@ -177,9 +177,16 @@ enum zone_type {
 	ZONE_HIGHMEM,
 #endif
 	ZONE_MOVABLE,
-	MAX_NR_ZONES
+	__MAX_NR_ZONES
 };
 
+#ifndef __GENERATING_BOUNDS_H
+#include <linux/bounds.h>
+#else
+/* Dummy value to allow bounds.h creation to succeed */
+#define MAX_NR_ZONES 1
+#endif
+
 /*
  * When a memory allocation must conform to specific limitations (such
  * as being suitable for DMA) the caller will pass in hints to the
@@ -188,28 +195,15 @@ enum zone_type {
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
diff -puN kernel/bounds.c~get-rid-of-__zone_count kernel/bounds.c
--- a/kernel/bounds.c~get-rid-of-__zone_count
+++ a/kernel/bounds.c
@@ -16,5 +16,6 @@ void foo(void)
 {
 	/* The enum constants to put into include/linux/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
+	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 	/* End of constants */
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-mempolicy-reference-counting-bugs.patch
ntfs-fix-nommu-build.patch
git-unionfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
get-rid-of-__zone_count.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

