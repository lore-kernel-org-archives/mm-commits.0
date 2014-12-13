From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
 removed from -mm tree
Date: Fri, 12 Dec 2014 16:40:45 -0800
Message-ID: <548b8b0d.vnVshn+Tj9TOh/MA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:40:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix
has been removed from the -mm tree.  Its filename was
     mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch

This patch was dropped because it was folded into mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix

v4: makes debug-pagealloc disabled in default

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   17 +++++++++--------
 mm/page_alloc.c                     |   12 ++++++++----
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix
+++ a/Documentation/kernel-parameters.txt
@@ -829,6 +829,15 @@ bytes respectively. Such letter suffixes
 			CONFIG_DEBUG_PAGEALLOC, hence this option will not help
 			tracking down these problems.
 
+	debug_pagealloc=
+			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. In
+			default, it is disabled. We can avoid allocating huge
+			chunk of memory for debug pagealloc if we don't enable
+			it at boot time and the system will work mostly same
+			with the kernel built without CONFIG_DEBUG_PAGEALLOC.
+			on: enable the feature
+
 	debugpat	[X86] Enable PAT debugging
 
 	decnet.addr=	[HW,NET]
@@ -858,14 +867,6 @@ bytes respectively. Such letter suffixes
 			causing system reset or hang due to sending
 			INIT from AP to BSP.
 
-	disable_debug_pagealloc
-			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
-			parameter allows user to disable it at boot time.
-			With this parameter, we can avoid allocating huge
-			chunk of memory for debug pagealloc and then
-			the system will work mostly same with the kernel
-			built without CONFIG_DEBUG_PAGEALLOC.
-
 	disable_ddw     [PPC/PSERIES]
 			Disable Dynamic DMA Window support. Use this if
 			to workaround buggy firmware.
diff -puN mm/page_alloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix
+++ a/mm/page_alloc.c
@@ -425,16 +425,20 @@ static inline void prep_zero_page(struct
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
-bool _debug_pagealloc_enabled __read_mostly = true;
+bool _debug_pagealloc_enabled __read_mostly;
 bool _debug_guardpage_enabled __read_mostly;
 
-static int __init early_disable_debug_pagealloc(char *buf)
+static int __init early_debug_pagealloc(char *buf)
 {
-	_debug_pagealloc_enabled = false;
+	if (!buf)
+		return -EINVAL;
+
+	if (strcmp(buf, "on") == 0)
+		_debug_pagealloc_enabled = true;
 
 	return 0;
 }
-early_param("disable_debug_pagealloc", early_disable_debug_pagealloc);
+early_param("debug_pagealloc", early_debug_pagealloc);
 
 static bool need_debug_guardpage(void)
 {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
fix-memory-ordering-bug-in-mm-vmallocc.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

