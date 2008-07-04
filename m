From: akpm@linux-foundation.org
Subject: - mn10300-provide-__ucmpdi2-for-mn10300.patch removed from -mm tree
Date: Fri, 04 Jul 2008 12:30:33 -0700
Message-ID: <200807041930.m64JUXS0014914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbYGDTb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 15:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     mn10300: provide __ucmpdi2() for MN10300
has been removed from the -mm tree.  Its filename was
     mn10300-provide-__ucmpdi2-for-mn10300.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: provide __ucmpdi2() for MN10300
From: David Howells <dhowells@redhat.com>

Provide __ucmpdi2() for MN10300 so that allmodconfig can be built.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/mn10300_ksyms.c |    2 +
 arch/mn10300/lib/Makefile           |    2 -
 arch/mn10300/lib/__ucmpdi2.S        |   43 ++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff -puN arch/mn10300/kernel/mn10300_ksyms.c~mn10300-provide-__ucmpdi2-for-mn10300 arch/mn10300/kernel/mn10300_ksyms.c
--- a/arch/mn10300/kernel/mn10300_ksyms.c~mn10300-provide-__ucmpdi2-for-mn10300
+++ a/arch/mn10300/kernel/mn10300_ksyms.c
@@ -34,7 +34,9 @@ extern u64 __ashrdi3(u64, unsigned);
 extern u64 __ashldi3(u64, unsigned);
 extern u64 __lshrdi3(u64, unsigned);
 extern s64 __negdi2(s64);
+extern int __ucmpdi2(u64, u64);
 EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__lshrdi3);
 EXPORT_SYMBOL(__negdi2);
+EXPORT_SYMBOL(__ucmpdi2);
diff -puN arch/mn10300/lib/Makefile~mn10300-provide-__ucmpdi2-for-mn10300 arch/mn10300/lib/Makefile
--- a/arch/mn10300/lib/Makefile~mn10300-provide-__ucmpdi2-for-mn10300
+++ a/arch/mn10300/lib/Makefile
@@ -4,4 +4,4 @@
 
 lib-y = delay.o usercopy.o checksum.o bitops.o memcpy.o memmove.o memset.o
 lib-y += do_csum.o
-lib-y += __ashldi3.o __ashrdi3.o __lshrdi3.o negdi2.o
+lib-y += __ashldi3.o __ashrdi3.o __lshrdi3.o negdi2.o __ucmpdi2.o
diff -puN /dev/null arch/mn10300/lib/__ucmpdi2.S
--- /dev/null
+++ a/arch/mn10300/lib/__ucmpdi2.S
@@ -0,0 +1,43 @@
+/* __ucmpdi2.S: 64-bit unsigned compare
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+
+        .text
+        .p2align	4
+
+###############################################################################
+#
+# int __ucmpdi2(unsigned long long a [D0:D1],
+#		unsigned long long b [(SP,12),(SP,16)])
+#
+# - returns 0, 1, or 2 as a <, =, > b respectively.
+#
+###############################################################################
+        .globl		__ucmpdi2
+        .type		__ucmpdi2,@function
+__ucmpdi2:
+	mov		(12,sp),a0		# b.lsw
+	mov		(16,sp),a1		# b.msw
+
+	sub		a0,d0
+	subc		a1,d1			# may clear Z, never sets it
+	bne		__ucmpdi2_differ	# a.msw != b.msw
+	mov		+1,d0
+	rets
+
+__ucmpdi2_differ:
+	# C flag is set if LE, clear if GE
+	subc		d0,d0			# -1 if LE, 0 if GE
+	add		+1,d0			#  0 if LE, 1 if GE
+	add		d0,d0			#  0 if LE, 2 if GE
+	rets
+
+	.size		__ucmpdi2, .-__ucmpdi2
_

Patches currently in -mm which might be from dhowells@redhat.com are

mn10300-export-certain-arch-symbols-required-to-build-allmodconfig.patch
security-filesystem-capabilities-fix-fragile-setuid-fixup-code.patch
security-filesystem-capabilities-fix-cap_setpcap-handling.patch
mn10300-provide-__ucmpdi2-for-mn10300.patch
linux-next.patch
git-unionfs.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

