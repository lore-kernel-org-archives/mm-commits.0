From: akpm@linux-foundation.org
Subject: + mm-neaten-warn_alloc_failed.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:18:51 -0700
Message-ID: <201108260018.p7Q0IpY4022081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab1HZASz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:18:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     mm: neaten warn_alloc_failed
has been added to the -mm tree.  Its filename is
     mm-neaten-warn_alloc_failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: neaten warn_alloc_failed
From: Joe Perches <joe@perches.com>

Add __attribute__((format (printf...) to the function to validate format
and arguments.  Use vsprintf extension %pV to avoid any possible message
interleaving.  Coalesce format string.  Convert printks/pr_warning to
pr_warn.

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
@@ -1335,7 +1335,8 @@ extern void si_meminfo(struct sysinfo * 
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
 
-extern void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
+extern __attribute__((format (printf, 3, 4)))
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

scripts-get_maintainerpl-update-linuss-git-repository.patch
checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests.patch
linux-next.patch
mm-neaten-warn_alloc_failed.patch
mm-neaten-warn_alloc_failed-fix.patch

