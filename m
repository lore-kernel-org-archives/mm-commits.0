From: akpm@linux-foundation.org
Subject: [merged] mm-use-kbasename.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:03 -0800
Message-ID: <20121218200604.0E38220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:47408 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:06 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so63294eek.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use kbasename()
has been removed from the -mm tree.  Its filename was
     mm-use-kbasename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm: use kbasename()

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-use-kbasename mm/memory.c
--- a/mm/memory.c~mm-use-kbasename
+++ a/mm/memory.c
@@ -58,6 +58,7 @@
 #include <linux/elf.h>
 #include <linux/gfp.h>
 #include <linux/migrate.h>
+#include <linux/string.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -4118,15 +4119,12 @@ void print_vma_addr(char *prefix, unsign
 		struct file *f = vma->vm_file;
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		if (buf) {
-			char *p, *s;
+			char *p;
 
 			p = d_path(&f->f_path, buf, PAGE_SIZE);
 			if (IS_ERR(p))
 				p = "?";
-			s = strrchr(p, '/');
-			if (s)
-				p = s+1;
-			printk("%s%s[%lx+%lx]", prefix, p,
+			printk("%s%s[%lx+%lx]", prefix, kbasename(p),
 					vma->vm_start,
 					vma->vm_end - vma->vm_start);
 			free_page((unsigned long)buf);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

