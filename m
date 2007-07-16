From: akpm@linux-foundation.org
Subject: - uml-export-hostfs-symbols.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:31 -0700
Message-ID: <200707162051.l6GKpV8V001402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437AbXGPVdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: export hostfs symbols
has been removed from the -mm tree.  Its filename was
     uml-export-hostfs-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 8 insertions(+), 12 deletions(-)

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

origin.patch
hostfs-convert-to-new-aops.patch
