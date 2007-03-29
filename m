From: akpm@linux-foundation.org
Subject: + uml-fix-unreasonably-long-udelay.patch added to -mm tree
Date: Wed, 28 Mar 2007 18:37:42 -0700
Message-ID: <200703290137.l2T1bgI3024863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965886AbXC2Bhq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 21:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     uml: fix unreasonably long udelay
has been added to the -mm tree.  Its filename is
     uml-fix-unreasonably-long-udelay.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix unreasonably long udelay
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

Currently we have a confused udelay implementation.

* __const_udelay does not accept usecs but xloops in i386 and x86_64
* our implementation requires usecs as arg
* it gets a xloops count when called by asm/arch/delay.h

Bugs related to this (extremely long shutdown times) where reported by some
x86_64 users, especially using Device Mapper.

To hit this bug, a compile-time constant time parameter must be passed -
that's why UML seems to work most times.  Fix this with a simple udelay
implementation.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/delay.c   |   11 -----------
 arch/um/sys-x86_64/delay.c |   11 -----------
 include/asm-um/delay.h     |   17 ++++++++++++++---
 3 files changed, 14 insertions(+), 25 deletions(-)

diff -puN arch/um/sys-i386/delay.c~uml-fix-unreasonably-long-udelay arch/um/sys-i386/delay.c
--- a/arch/um/sys-i386/delay.c~uml-fix-unreasonably-long-udelay
+++ a/arch/um/sys-i386/delay.c
@@ -27,14 +27,3 @@ void __udelay(unsigned long usecs)
 }
 
 EXPORT_SYMBOL(__udelay);
-
-void __const_udelay(unsigned long usecs)
-{
-	int i, n;
-
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
-}
-
-EXPORT_SYMBOL(__const_udelay);
diff -puN arch/um/sys-x86_64/delay.c~uml-fix-unreasonably-long-udelay arch/um/sys-x86_64/delay.c
--- a/arch/um/sys-x86_64/delay.c~uml-fix-unreasonably-long-udelay
+++ a/arch/um/sys-x86_64/delay.c
@@ -28,14 +28,3 @@ void __udelay(unsigned long usecs)
 }
 
 EXPORT_SYMBOL(__udelay);
-
-void __const_udelay(unsigned long usecs)
-{
-	unsigned long i, n;
-
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
-}
-
-EXPORT_SYMBOL(__const_udelay);
diff -puN include/asm-um/delay.h~uml-fix-unreasonably-long-udelay include/asm-um/delay.h
--- a/include/asm-um/delay.h~uml-fix-unreasonably-long-udelay
+++ a/include/asm-um/delay.h
@@ -1,9 +1,20 @@
 #ifndef __UM_DELAY_H
 #define __UM_DELAY_H
 
-#include "asm/arch/delay.h"
-#include "asm/archparam.h"
-
 #define MILLION 1000000
 
+/* Undefined on purpose */
+extern void __bad_udelay(void);
+
+extern void __udelay(unsigned long usecs);
+extern void __delay(unsigned long loops);
+
+#define udelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
+	__bad_udelay() : __udelay(n))
+
+/* It appears that ndelay is not used at all for UML, and has never been
+ * implemented. */
+extern void __unimplemented_ndelay(void);
+#define ndelay(n) __unimplemented_ndelay()
+
 #endif
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

uml-fix-static-linking.patch
uml-use-correct-register-file-size-everywhere.patch
uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch
uml-fix-device-unplug-crash.patch
uml-fix-pte-bit-collision.patch
uml-irq-locking-fixes.patch
uml-fix-lvm-crash.patch
uml-fix-compilation-problems.patch
uml-hostfs-variable-renaming.patch
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
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
uml-eliminate-temporary-buffer-in-eth_configure.patch
uml-replace-one-element-array-with-zero-element-array.patch
fix-utrace-utrace-tracehook-um.patch
git-gccbug.patch
