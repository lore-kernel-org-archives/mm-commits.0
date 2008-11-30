From: akpm@linux-foundation.org
Subject: - unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch removed from -mm tree
Date: Sat, 29 Nov 2008 17:24:53 -0800
Message-ID: <200811300124.mAU1Or0L016574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbYK3BZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 20:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, rmk@arm.linux.org.uk, takata@linux-m32r.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     unaligned: move ARM, M32R, H8300 to the asm-generic version
has been removed from the -mm tree.  Its filename was
     unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: move ARM, M32R, H8300 to the asm-generic version
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/unaligned.h   |   15 +--------------
 arch/h8300/include/asm/unaligned.h |    7 +------
 include/asm-m32r/unaligned.h       |   14 +-------------
 3 files changed, 3 insertions(+), 33 deletions(-)

diff -puN arch/arm/include/asm/unaligned.h~unaligned-move-arm-m32r-h8300-to-the-asm-generic-version arch/arm/include/asm/unaligned.h
--- a/arch/arm/include/asm/unaligned.h~unaligned-move-arm-m32r-h8300-to-the-asm-generic-version
+++ a/arch/arm/include/asm/unaligned.h
@@ -1,19 +1,6 @@
 #ifndef _ASM_ARM_UNALIGNED_H
 #define _ASM_ARM_UNALIGNED_H
 
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-/*
- * Select endianness
- */
-#ifndef __ARMEB__
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
-#else
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-#endif
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_ARM_UNALIGNED_H */
diff -puN arch/h8300/include/asm/unaligned.h~unaligned-move-arm-m32r-h8300-to-the-asm-generic-version arch/h8300/include/asm/unaligned.h
--- a/arch/h8300/include/asm/unaligned.h~unaligned-move-arm-m32r-h8300-to-the-asm-generic-version
+++ a/arch/h8300/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_H8300_UNALIGNED_H
 #define _ASM_H8300_UNALIGNED_H
 
-#include <linux/unaligned/be_memmove.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_H8300_UNALIGNED_H */
diff -puN include/asm-m32r/unaligned.h~unaligned-move-arm-m32r-h8300-to-the-asm-generic-version include/asm-m32r/unaligned.h
--- a/include/asm-m32r/unaligned.h~unaligned-move-arm-m32r-h8300-to-the-asm-generic-version
+++ a/include/asm-m32r/unaligned.h
@@ -1,18 +1,6 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-#if defined(__LITTLE_ENDIAN__)
-# include <linux/unaligned/le_memmove.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-# include <linux/unaligned/be_memmove.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#endif
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_M32R_UNALIGNED_H */
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
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

