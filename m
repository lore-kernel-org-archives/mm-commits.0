From: akpm@linux-foundation.org
Subject: + add-kvasprintf.patch added to -mm tree
Date: Fri, 27 Apr 2007 23:18:12 -0700
Message-ID: <200704280618.l3S6ICWd016197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbXD1GS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 02:18:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, akpm@linux-foundation.org, jeremy@xensource.com, keir@xensource.com


The patch titled
     Add kvasprintf()
has been added to the -mm tree.  Its filename is
     add-kvasprintf.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add kvasprintf()
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add a kvasprintf() function to complement kasprintf().

No in-tree users yet, but I have some coming up.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Keir Fraser <keir@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 lib/vsprintf.c         |   24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff -puN include/linux/kernel.h~add-kvasprintf include/linux/kernel.h
--- a/include/linux/kernel.h~add-kvasprintf
+++ a/include/linux/kernel.h
@@ -134,6 +134,7 @@ extern int vscnprintf(char *buf, size_t 
 	__attribute__ ((format (printf, 3, 0)));
 extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
+extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
 extern int sscanf(const char *, const char *, ...)
 	__attribute__ ((format (scanf, 2, 3)));
diff -puN lib/vsprintf.c~add-kvasprintf lib/vsprintf.c
--- a/lib/vsprintf.c~add-kvasprintf
+++ a/lib/vsprintf.c
@@ -862,22 +862,34 @@ EXPORT_SYMBOL(sscanf);
 
 
 /* Simplified asprintf. */
-char *kasprintf(gfp_t gfp, const char *fmt, ...)
+char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
 {
-	va_list ap;
 	unsigned int len;
 	char *p;
+	va_list aq;
 
-	va_start(ap, fmt);
-	len = vsnprintf(NULL, 0, fmt, ap);
-	va_end(ap);
+	va_copy(aq, ap);
+	len = vsnprintf(NULL, 0, fmt, aq);
+	va_end(aq);
 
 	p = kmalloc(len+1, gfp);
 	if (!p)
 		return NULL;
-	va_start(ap, fmt);
+
 	vsnprintf(p, len+1, fmt, ap);
+
+	return p;
+}
+
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	p = kvasprintf(gfp, fmt, ap);
 	va_end(ap);
+
 	return p;
 }
 
_

Patches currently in -mm which might be from jeremy@goop.org are

add-kvasprintf.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
add-touch_all_softlockup_watchdogs.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
add-kvasprintf-fix.patch
