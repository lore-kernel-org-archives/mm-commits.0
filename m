From: akpm@linux-foundation.org
Subject: + mn10300-provide-__ucmpdi2-for-mn10300.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:22:03 -0700
Message-ID: <200806302322.m5UNM4lC030796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413AbYF3XWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, bunk@stusta.de


The patch titled
     mn10300: provide __ucmpdi2() for MN10300
has been added to the -mm tree.  Its filename is
     mn10300-provide-__ucmpdi2-for-mn10300.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mn10300-provide-__ucmpdi2-for-mn10300.patch
git-unionfs.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

