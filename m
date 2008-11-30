From: akpm@linux-foundation.org
Subject: - unaligned-convert-arches-where-unaligned-access-is-ok.patch removed from -mm tree
Date: Sat, 29 Nov 2008 17:24:37 -0800
Message-ID: <200811300124.mAU1ObA3016354__2566.87883888862$1228008420$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbYK3BZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 20:25:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, benh@kernel.crashing.org, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, heiko.carstens@de.ibm.com, linux-arch@vger.kernel.org, mingo@elte.hu


The patch titled
     unaligned: convert arches where unaligned access is OK
has been removed from the -mm tree.  Its filename was
     unaligned-convert-arches-where-unaligned-access-is-ok.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: convert arches where unaligned access is OK
From: Harvey Harrison <harvey.harrison@gmail.com>

No functional changes, just use the asm-generic header.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/unaligned.h      |    7 ++-----
 arch/m68knommu/include/asm/unaligned.h |   22 +++++-----------------
 arch/powerpc/include/asm/unaligned.h   |    7 ++-----
 arch/s390/include/asm/unaligned.h      |    7 ++-----
 arch/x86/include/asm/unaligned.h       |    8 ++------
 include/asm-m68k/unaligned.h           |    7 ++-----
 include/asm-mn10300/unaligned.h        |   10 +++++-----
 7 files changed, 20 insertions(+), 48 deletions(-)

diff -puN arch/cris/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok arch/cris/include/asm/unaligned.h
--- a/arch/cris/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok
+++ a/arch/cris/include/asm/unaligned.h
@@ -4,10 +4,7 @@
 /*
  * CRIS can do unaligned accesses itself. 
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_CRIS_UNALIGNED_H */
diff -puN arch/m68knommu/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok arch/m68knommu/include/asm/unaligned.h
--- a/arch/m68knommu/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok
+++ a/arch/m68knommu/include/asm/unaligned.h
@@ -1,25 +1,13 @@
 #ifndef _ASM_M68KNOMMU_UNALIGNED_H
 #define _ASM_M68KNOMMU_UNALIGNED_H
 
-
-#ifdef CONFIG_COLDFIRE
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
-#else
 /*
- * The m68k can do unaligned accesses itself. 
+ * The m68k can do unaligned accesses itself.  COLDFIRE can not.
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
+#ifndef CONFIG_COLDFIRE
+# define _UNALIGNED_ACCESS_OK
 #endif
 
+#include <asm-generic/unaligned.h>
+
 #endif /* _ASM_M68KNOMMU_UNALIGNED_H */
diff -puN arch/powerpc/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok arch/powerpc/include/asm/unaligned.h
--- a/arch/powerpc/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok
+++ a/arch/powerpc/include/asm/unaligned.h
@@ -6,11 +6,8 @@
 /*
  * The PowerPC can do unaligned accesses itself in big endian mode.
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_UNALIGNED_H */
diff -puN arch/s390/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok arch/s390/include/asm/unaligned.h
--- a/arch/s390/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok
+++ a/arch/s390/include/asm/unaligned.h
@@ -4,10 +4,7 @@
 /*
  * The S390 can do unaligned accesses itself. 
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_S390_UNALIGNED_H */
diff -puN arch/x86/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok arch/x86/include/asm/unaligned.h
--- a/arch/x86/include/asm/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok
+++ a/arch/x86/include/asm/unaligned.h
@@ -4,11 +4,7 @@
 /*
  * The x86 can do unaligned accesses itself.
  */
-
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned __get_unaligned_le
-#define put_unaligned __put_unaligned_le
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_X86_UNALIGNED_H */
diff -puN include/asm-m68k/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok include/asm-m68k/unaligned.h
--- a/include/asm-m68k/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok
+++ a/include/asm-m68k/unaligned.h
@@ -4,10 +4,7 @@
 /*
  * The m68k can do unaligned accesses itself.
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_M68K_UNALIGNED_H */
diff -puN include/asm-mn10300/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok include/asm-mn10300/unaligned.h
--- a/include/asm-mn10300/unaligned.h~unaligned-convert-arches-where-unaligned-access-is-ok
+++ a/include/asm-mn10300/unaligned.h
@@ -11,10 +11,10 @@
 #ifndef _ASM_MN10300_UNALIGNED_H
 #define _ASM_MN10300_UNALIGNED_H
 
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+/*
+ * The MN10300 can do unaligned accesses itself.
+ */
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_MN10300_UNALIGNED_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

