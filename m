From: akpm@linux-foundation.org
Subject: + uml-export-hostfs-symbols.patch added to -mm tree
Date: Fri, 13 Jul 2007 11:54:25 -0700
Message-ID: <200707131854.l6DIsPLn012469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760771AbXGMSzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 14:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: export hostfs symbols
has been added to the -mm tree.  Its filename is
     uml-export-hostfs-symbols.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: export hostfs symbols
From: Jeff Dike <jdike@addtoit.com>

Add some exports for hostfs that are required after Alberto Bertogli's fixes
for accessing unlinked host files.

Also did some style cleanups while I was here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/user_syms.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff -puN arch/um/os-Linux/user_syms.c~uml-export-hostfs-symbols arch/um/os-Linux/user_syms.c
--- a/arch/um/os-Linux/user_syms.c~uml-export-hostfs-symbols
+++ a/arch/um/os-Linux/user_syms.c
@@ -5,7 +5,8 @@
  * so I *must* declare good prototypes for them and then EXPORT them.
  * The kernel code uses the macro defined by include/linux/string.h,
  * so I undef macros; the userspace code does not include that and I
- * add an EXPORT for the glibc one.*/
+ * add an EXPORT for the glibc one.
+ */
 
 #undef strlen
 #undef strstr
@@ -61,12 +62,18 @@ EXPORT_SYMBOL_PROTO(dup2);
 EXPORT_SYMBOL_PROTO(__xstat);
 EXPORT_SYMBOL_PROTO(__lxstat);
 EXPORT_SYMBOL_PROTO(__lxstat64);
+EXPORT_SYMBOL_PROTO(__fxstat64);
 EXPORT_SYMBOL_PROTO(lseek);
 EXPORT_SYMBOL_PROTO(lseek64);
 EXPORT_SYMBOL_PROTO(chown);
+EXPORT_SYMBOL_PROTO(fchown);
 EXPORT_SYMBOL_PROTO(truncate);
+EXPORT_SYMBOL_PROTO(ftruncate64);
 EXPORT_SYMBOL_PROTO(utime);
+EXPORT_SYMBOL_PROTO(utimes);
+EXPORT_SYMBOL_PROTO(futimes);
 EXPORT_SYMBOL_PROTO(chmod);
+EXPORT_SYMBOL_PROTO(fchmod);
 EXPORT_SYMBOL_PROTO(rename);
 EXPORT_SYMBOL_PROTO(__xmknod);
 
@@ -102,14 +109,3 @@ EXPORT_SYMBOL(__stack_smash_handler);
 
 extern long __guard __attribute__((weak));
 EXPORT_SYMBOL(__guard);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
uml-xterm-driver-tidying.patch
uml-pty-channel-tidying.patch
uml-handle-errors-on-opening-host-side-of-consoles.patch
uml-sigio-support-cleanup.patch
uml-simplify-helper-stack-handling.patch
uml-eliminate-kernel-allocator-wrappers.patch
uml-export-hostfs-symbols.patch
uml-limit-request-size-on-cowed-devices.patch
uml-remove-dead-file.patch
