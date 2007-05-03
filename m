From: akpm@linux-foundation.org
Subject: - add-kvasprintf.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:28 -0700
Message-ID: <200705031930.l43JUSLK018189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767786AbXECTcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:32:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, akpm@linux-foundation.org, jeremy@xensource.com, keir@xensource.com, mm-commits@vger.kernel.org


The patch titled
     Add kvasprintf()
has been removed from the -mm tree.  Its filename was
     add-kvasprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add kvasprintf()
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add a kvasprintf() function to complement kasprintf().

No in-tree users yet, but I have some coming up.

[akpm@linux-foundation.org: EXPORT it]
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Keir Fraser <keir@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 lib/vsprintf.c         |   26 +++++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff -puN include/linux/kernel.h~add-kvasprintf include/linux/kernel.h
--- a/include/linux/kernel.h~add-kvasprintf
+++ a/include/linux/kernel.h
@@ -121,6 +121,7 @@ extern int vscnprintf(char *buf, size_t 
 	__attribute__ ((format (printf, 3, 0)));
 extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
+extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
 extern int sscanf(const char *, const char *, ...)
 	__attribute__ ((format (scanf, 2, 3)));
diff -puN lib/vsprintf.c~add-kvasprintf lib/vsprintf.c
--- a/lib/vsprintf.c~add-kvasprintf
+++ a/lib/vsprintf.c
@@ -851,23 +851,35 @@ EXPORT_SYMBOL(sscanf);
 
 
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
-	va_end(ap);
+
 	return p;
 }
+EXPORT_SYMBOL(kvasprintf);
+
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
 
+	va_start(ap, fmt);
+	p = kvasprintf(gfp, fmt, ap);
+	va_end(ap);
+
+	return p;
+}
 EXPORT_SYMBOL(kasprintf);
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
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
add-touch_all_softlockup_watchdogs.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
