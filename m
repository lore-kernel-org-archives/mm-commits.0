From: akpm@linux-foundation.org
Subject: + unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch added to -mm tree
Date: Tue, 18 Nov 2008 22:15:12 -0800
Message-ID: <200811190615.mAJ6FCIo007522__18492.8072886125$1227075486$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbYKSGQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 01:16:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, rmk@arm.linux.org.uk, takata@linux-m32r.org, ysato@users.sourceforge.jp


The patch titled
     unaligned: move ARM, M32R, H8300 to the asm-generic version
has been added to the -mm tree.  Its filename is
     unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch
v4l-s2255drv-fix-firmware-test-on-big-endian.patch
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
unaligned-introduce-common-header.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

