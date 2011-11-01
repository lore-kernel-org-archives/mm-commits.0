From: akpm@linux-foundation.org
Subject: [merged] mm-neaten-warn_alloc_failed.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:30 -0700
Message-ID: <201111012110.pA1LAUZu007990@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1KAVKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: neaten warn_alloc_failed
has been removed from the -mm tree.  Its filename was
     mm-neaten-warn_alloc_failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: neaten warn_alloc_failed

Add __attribute__((format (printf...) to the function to validate format
and arguments.  Use vsprintf extension %pV to avoid any possible message
interleaving.  Coalesce format string.  Convert printks/pr_warning to
pr_warn.

[akpm@linux-foundation.org: use the __printf() macro]
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 mm/page_alloc.c    |   16 +++++++++++-----
 mm/vmalloc.c       |    4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff -puN include/linux/mm.h~mm-neaten-warn_alloc_failed include/linux/mm.h
--- a/include/linux/mm.h~mm-neaten-warn_alloc_failed
+++ a/include/linux/mm.h
@@ -1334,7 +1334,8 @@ extern void si_meminfo(struct sysinfo * 
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
 
-extern void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
+extern __printf(3, 4)
+void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
diff -puN mm/page_alloc.c~mm-neaten-warn_alloc_failed mm/page_alloc.c
--- a/mm/page_alloc.c~mm-neaten-warn_alloc_failed
+++ a/mm/page_alloc.c
@@ -1754,7 +1754,6 @@ static DEFINE_RATELIMIT_STATE(nopage_rs,
 
 void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
 {
-	va_list args;
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
 
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
@@ -1773,14 +1772,21 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
 	if (fmt) {
-		printk(KERN_WARNING);
+		struct va_format vaf;
+		va_list args;
+
 		va_start(args, fmt);
-		vprintk(fmt, args);
+
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		pr_warn("%pV", &vaf);
+
 		va_end(args);
 	}
 
-	pr_warning("%s: page allocation failure: order:%d, mode:0x%x\n",
-		   current->comm, order, gfp_mask);
+	pr_warn("%s: page allocation failure: order:%d, mode:0x%x\n",
+		current->comm, order, gfp_mask);
 
 	dump_stack();
 	if (!should_suppress_show_mem())
diff -puN mm/vmalloc.c~mm-neaten-warn_alloc_failed mm/vmalloc.c
--- a/mm/vmalloc.c~mm-neaten-warn_alloc_failed
+++ a/mm/vmalloc.c
@@ -1593,8 +1593,8 @@ static void *__vmalloc_area_node(struct 
 	return area->addr;
 
 fail:
-	warn_alloc_failed(gfp_mask, order, "vmalloc: allocation failure, "
-			  "allocated %ld of %ld bytes\n",
+	warn_alloc_failed(gfp_mask, order,
+			  "vmalloc: allocation failure, allocated %ld of %ld bytes\n",
 			  (area->nr_pages*PAGE_SIZE), area->size);
 	vfree(area->addr);
 	return NULL;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

