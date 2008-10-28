From: akpm@linux-foundation.org
Subject: + m68knommu-use-the-new-byteorder-headers.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:27:28 -0700
Message-ID: <200810280627.m9S6RS4D023994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbYJ1G1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, gerg@uclinux.org


The patch titled
     m68knommu: use the new byteorder headers
has been added to the -mm tree.  Its filename is
     m68knommu-use-the-new-byteorder-headers.patch

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
Subject: m68knommu: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/include/asm/byteorder.h |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/m68knommu/include/asm/byteorder.h~m68knommu-use-the-new-byteorder-headers arch/m68knommu/include/asm/byteorder.h
--- a/arch/m68knommu/include/asm/byteorder.h~m68knommu-use-the-new-byteorder-headers
+++ a/arch/m68knommu/include/asm/byteorder.h
@@ -3,13 +3,11 @@
 
 #include <linux/types.h>
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
 #if defined (__mcfisaaplus__) || defined (__mcfisac__)
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 	asm(
 			"byterev %0"
@@ -18,10 +16,9 @@ static inline __attribute_const__ __u32 
 	   );
 	return val;
 }
-
-#define __arch__swab32(x) ___arch__swab32(x)
+#define __arch_swab32 __arch_swab32
 #endif
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
gfs2-sparse-annotation-of-gl-gl_spin.patch
input-ads7846c-sparse-lock-annotation.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
sparc-use-the-new-byteorder-headers.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
m68knommu-use-the-new-byteorder-headers.patch
cris-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
memstick-annotate-endianness-of-attribute-structs.patch

