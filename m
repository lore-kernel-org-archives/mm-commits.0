From: akpm@linux-foundation.org
Subject: + m32r-add-__ucmpdi2-to-fix-build-failure.patch added to -mm tree
Date: Thu, 09 Jun 2016 15:07:53 -0700
Message-ID: <5759e8b9.19T0H7/EGwMTq6WQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbcFIWHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2016 18:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: add __ucmpdi2 to fix build failure
has been added to the -mm tree.  Its filename is
     m32r-add-__ucmpdi2-to-fix-build-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-add-__ucmpdi2-to-fix-build-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-add-__ucmpdi2-to-fix-build-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: add __ucmpdi2 to fix build failure

We are having build failure with m32r and the error message being:
ERROR: "__ucmpdi2" [lib/842/842_decompress.ko] undefined!
ERROR: "__ucmpdi2" [fs/btrfs/btrfs.ko] undefined!
ERROR: "__ucmpdi2" [drivers/scsi/sd_mod.ko] undefined!
ERROR: "__ucmpdi2" [drivers/media/i2c/adv7842.ko] undefined!
ERROR: "__ucmpdi2" [drivers/md/bcache/bcache.ko] undefined!
ERROR: "__ucmpdi2" [drivers/iio/imu/inv_mpu6050/inv-mpu6050.ko] undefined!

__ucmpdi2 is introduced to m32r architecture taking example from other
architectures like h8300, microblaze, mips.

Link: http://lkml.kernel.org/r/1465509213-4280-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/m32r_ksyms.c |    3 +++
 arch/m32r/lib/Makefile        |    4 ++--
 arch/m32r/lib/libgcc.h        |   24 ++++++++++++++++++++++++
 arch/m32r/lib/ucmpdi2.c       |   17 +++++++++++++++++
 4 files changed, 46 insertions(+), 2 deletions(-)

diff -puN arch/m32r/kernel/m32r_ksyms.c~m32r-add-__ucmpdi2-to-fix-build-failure arch/m32r/kernel/m32r_ksyms.c
--- a/arch/m32r/kernel/m32r_ksyms.c~m32r-add-__ucmpdi2-to-fix-build-failure
+++ a/arch/m32r/kernel/m32r_ksyms.c
@@ -41,6 +41,9 @@ EXPORT_SYMBOL(cpu_data);
 EXPORT_SYMBOL(smp_flush_tlb_page);
 #endif
 
+extern int __ucmpdi2(unsigned long long a, unsigned long long b);
+EXPORT_SYMBOL(__ucmpdi2);
+
 /* compiler generated symbol */
 extern void __ashldi3(void);
 extern void __ashrdi3(void);
diff -puN arch/m32r/lib/Makefile~m32r-add-__ucmpdi2-to-fix-build-failure arch/m32r/lib/Makefile
--- a/arch/m32r/lib/Makefile~m32r-add-__ucmpdi2-to-fix-build-failure
+++ a/arch/m32r/lib/Makefile
@@ -3,5 +3,5 @@
 #
 
 lib-y  := checksum.o ashxdi3.o memset.o memcpy.o \
-	  delay.o strlen.o usercopy.o csum_partial_copy.o
-
+	  delay.o strlen.o usercopy.o csum_partial_copy.o \
+	  ucmpdi2.o
diff -puN /dev/null arch/m32r/lib/libgcc.h
--- /dev/null
+++ a/arch/m32r/lib/libgcc.h
@@ -0,0 +1,24 @@
+#ifndef __ASM_LIBGCC_H
+#define __ASM_LIBGCC_H
+
+#include <asm/byteorder.h>
+
+#ifdef __BIG_ENDIAN
+struct DWstruct {
+	int high, low;
+};
+#elif defined(__LITTLE_ENDIAN)
+struct DWstruct {
+	int low, high;
+};
+#else
+#error I feel sick.
+#endif
+
+typedef union {
+	struct DWstruct s;
+	long long ll;
+} DWunion;
+
+#endif /* __ASM_LIBGCC_H */
+
diff -puN /dev/null arch/m32r/lib/ucmpdi2.c
--- /dev/null
+++ a/arch/m32r/lib/ucmpdi2.c
@@ -0,0 +1,17 @@
+#include "libgcc.h"
+
+int __ucmpdi2(unsigned long long a, unsigned long long b)
+{
+	const DWunion au = {.ll = a};
+	const DWunion bu = {.ll = b};
+
+	if ((unsigned int)au.s.high < (unsigned int)bu.s.high)
+		return 0;
+	else if ((unsigned int)au.s.high > (unsigned int)bu.s.high)
+		return 2;
+	if ((unsigned int)au.s.low < (unsigned int)bu.s.low)
+		return 0;
+	else if ((unsigned int)au.s.low > (unsigned int)bu.s.low)
+		return 2;
+	return 1;
+}
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-add-__ucmpdi2-to-fix-build-failure.patch
mm-page_owner-use-stackdepot-to-store-stacktrace-fix.patch
fpga-zynq-fpga-fix-build-failure.patch

