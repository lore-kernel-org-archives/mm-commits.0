From: akpm@linux-foundation.org
Subject: - m32r-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 06 Jan 2009 15:58:11 -0800
Message-ID: <200901062358.n06NwBTh001704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbZAFX6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 18:58:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     m32r-use-the-new-byteorder-headers.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m32r/byteorder.h |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN include/asm-m32r/byteorder.h~m32r-use-the-new-byteorder-headers include/asm-m32r/byteorder.h
--- a/include/asm-m32r/byteorder.h~m32r-use-the-new-byteorder-headers
+++ a/include/asm-m32r/byteorder.h
@@ -1,17 +1,14 @@
 #ifndef _ASM_M32R_BYTEORDER_H
 #define _ASM_M32R_BYTEORDER_H
 
-#include <asm/types.h>
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
 #if defined(__LITTLE_ENDIAN__)
-#  include <linux/byteorder/little_endian.h>
+# define __LITTLE_ENDIAN
 #else
-#  include <linux/byteorder/big_endian.h>
+# define __BIG_ENDIAN
 #endif
 
+#define __SWAB_64_THRU_32__
+
+#include <linux/byteorder.h>
+
 #endif /* _ASM_M32R_BYTEORDER_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
m68knommu-use-the-new-byteorder-headers.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch

