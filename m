From: akpm@linux-foundation.org
Subject: + mm-use-kbasename.patch added to -mm tree
Date: Tue, 16 Oct 2012 14:35:25 -0700
Message-ID: <20121016213526.10CD61E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:63605 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2JPVf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Oct 2012 17:35:26 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so847166yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 16 Oct 2012 14:35:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com


The patch titled
     Subject: mm: use kbasename()
has been added to the -mm tree.  Its filename is
     mm-use-kbasename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4034,15 +4035,12 @@ void print_vma_addr(char *prefix, unsign
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

linux-next.patch
string-introduce-helper-to-get-base-file-name-from-given-path.patch
lib-dynamic_debug-use-kbasename.patch
staging-rts_pstor-use-kbasename.patch
mm-use-kbasename.patch
procfs-use-kbasename.patch
trace-use-kbasename.patch

