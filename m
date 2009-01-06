From: akpm@linux-foundation.org
Subject: - alpha-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 06 Jan 2009 15:58:49 -0800
Message-ID: <200901062358.n06NwnAi002253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756257AbZAFX6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 18:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     alpha-use-the-new-byteorder-headers.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/byteorder.h |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN arch/alpha/include/asm/byteorder.h~alpha-use-the-new-byteorder-headers arch/alpha/include/asm/byteorder.h
--- a/arch/alpha/include/asm/byteorder.h~alpha-use-the-new-byteorder-headers
+++ a/arch/alpha/include/asm/byteorder.h
@@ -5,9 +5,9 @@
 #include <linux/compiler.h>
 #include <asm/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
 
-static inline __attribute_const__ __u32 __arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	/*
 	 * Unfortunately, we can't use the 6 instruction sequence
@@ -35,13 +35,8 @@ static inline __attribute_const__ __u32 
 
 	return t1;
 }
+#define __arch_swab32 __arch_swab32
 
-#define __arch__swab32 __arch__swab32
-
-#endif /* __GNUC__ */
-
-#define __BYTEORDER_HAS_U64__
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ALPHA_BYTEORDER_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
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

