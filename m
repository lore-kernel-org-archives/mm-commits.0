From: akpm@linux-foundation.org
Subject: + uml-no-locking-needed-in-tlsc.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:46:19 -0700
Message-ID: <200704022146.l32LkJjZ010297@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48355 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965967AbXDBVqZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: no locking needed in tls.c
has been added to the -mm tree.  Its filename is
     uml-no-locking-needed-in-tlsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: no locking needed in tls.c
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking on a couple of globals.

Also fix the formatting of __setup_host_supports_tls.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/tls.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/um/sys-i386/tls.c~uml-no-locking-needed-in-tlsc arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-no-locking-needed-in-tlsc
+++ a/arch/um/sys-i386/tls.c
@@ -23,9 +23,13 @@
 #include "skas.h"
 #endif
 
-/* If needed we can detect when it's uninitialized. */
+/*
+ * If needed we can detect when it's uninitialized.
+ *
+ * These are initialized in an initcall and unchanged thereafter.
+ */
 static int host_supports_tls = -1;
-int host_gdt_entry_tls_min = -1;
+int host_gdt_entry_tls_min;
 
 #ifdef CONFIG_MODE_SKAS
 int do_set_thread_area_skas(struct user_desc *info)
@@ -361,7 +365,8 @@ out:
 
 /* XXX: This part is probably common to i386 and x86-64. Don't create a common
  * file for now, do that when implementing x86-64 support.*/
-static int __init __setup_host_supports_tls(void) {
+static int __init __setup_host_supports_tls(void)
+{
 	check_host_supports_tls(&host_supports_tls, &host_gdt_entry_tls_min);
 	if (host_supports_tls) {
 		printk(KERN_INFO "Host TLS support detected\n");
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
