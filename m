From: akpm@linux-foundation.org
Subject: + unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch added to -mm tree
Date: Tue, 02 Dec 2008 14:57:40 -0800
Message-ID: <200812022257.mB2MveFf022299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbYLBW5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 17:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, rmk@arm.linux.org.uk


The patch titled
     unaligned: wire up ARM arch overrides for unaligned access
has been added to the -mm tree.  Its filename is
     unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch

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
Subject: unaligned: wire up ARM arch overrides for unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>

Add byteshifting arch overrides to avoid any functional changes when using
the new common header.  At a later time this arch should be able to use
the common header directly, but this has not been proven yet.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/unaligned.h |   81 ++++++++++++++++++++++++-----
 1 file changed, 69 insertions(+), 12 deletions(-)

diff -puN arch/arm/include/asm/unaligned.h~unaligned-wire-up-arm-arch-overrides-for-unaligned-access arch/arm/include/asm/unaligned.h
--- a/arch/arm/include/asm/unaligned.h~unaligned-wire-up-arm-arch-overrides-for-unaligned-access
+++ a/arch/arm/include/asm/unaligned.h
@@ -1,19 +1,76 @@
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
+#include <linux/kernel.h>
+#include <asm/byteorder.h>
+
+static inline u16 __arch_load_cpu16_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return p[0] | p[1] << 8;
+#else
+	return p[0] << 8 | p[1];
+#endif
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+static inline u32 __arch_load_cpu32_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+#else
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+#endif
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u64 __arch_load_cpu64_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((u64)__arch_load_cpu32_noalign(p + 4) << 32) |
+	        __arch_load_cpu32_noalign(p);
+#else
+	return ((u64)__arch_load_cpu32_noalign(p) << 32) |
+	       __arch_load_cpu32_noalign(p + 4);
+#endif
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+static inline void __arch_store_cpu16_noalign(u8 *p, u16 val)
+{
+#ifdef __LITTLE_ENDIAN
+	*p++ = val;
+	*p++ = val >> 8;
+#else
+	*p++ = val >> 8;
+	*p++ = val;
+#endif
+}
+#define __arch_store_cpu16_noalign __arch_store_cpu16_noalign
+
+static inline void __arch_store_cpu32_noalign(u8 *p, u32 val)
+{
+#ifdef __LITTLE_ENDIAN
+	__arch_store_cpu16_noalign(p, val);
+	__arch_store_cpu16_noalign(p + 2, val >> 16);
+#else
+	__arch_store_cpu16_noalign(p, val >> 16);
+	__arch_store_cpu16_noalign(p + 2, val);
+#endif
+}
+#define __arch_store_cpu32_noalign __arch_store_cpu32_noalign
+
+static inline void __arch_store_cpu64_noalign(u8 *p, u64 val)
+{
+#ifdef __LITTLE_ENDIAN
+	__arch_store_cpu32_noalign(p, val);
+	__arch_store_cpu32_noalign(p + 4, val >> 32);
 #else
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+	__arch_store_cpu32_noalign(p, val >> 32);
+	__arch_store_cpu32_noalign(p + 4, val);
 #endif
+}
+#define __arch_store_cpu64_noalign __arch_store_cpu64_noalign
 
+#include <linux/unaligned.h>
 #endif /* _ASM_ARM_UNALIGNED_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
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
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch

