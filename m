From: akpm@linux-foundation.org
Subject: + byteorder-m68knommu-use-the-new-byteorder-headers.patch added to -mm tree
Date: Tue, 12 Aug 2008 19:59:03 -0700
Message-ID: <200808130259.m7D2x3LE027460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYHMC7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 22:59:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, gerg@snapgear.com


The patch titled
     byteorder: m68knommu: use the new byteorder headers
has been added to the -mm tree.  Its filename is
     byteorder-m68knommu-use-the-new-byteorder-headers.patch

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
Subject: byteorder: m68knommu: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/include/asm/byteorder.h |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/m68knommu/include/asm/byteorder.h~byteorder-m68knommu-use-the-new-byteorder-headers arch/m68knommu/include/asm/byteorder.h
--- a/arch/m68knommu/include/asm/byteorder.h~byteorder-m68knommu-use-the-new-byteorder-headers
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

byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-alpha-use-the-new-byteorder-headers.patch
byteorder-arm-use-the-new-byteorder-headers.patch
byteorder-avr32-use-the-new-byteorder-headers.patch
byteorder-blackfin-use-the-new-byteorder-headers.patch
byteorder-cris-use-the-new-byteorder-headers.patch
byteorder-frv-use-the-new-byteorder-headers.patch
byteorder-h8300-use-the-new-byteorder-headers.patch
byteorder-ia64-use-the-new-byteorder-headers.patch
byteorder-m32r-use-the-new-byteorder-headers.patch
byteorder-m68k-use-the-new-byteorder-headers.patch
byteorder-m68knommu-use-the-new-byteorder-headers.patch
byteorder-mips-use-the-new-byteorder-headers.patch
byteorder-mn10300-use-the-new-byteorder-headers.patch
byteorder-parisc-use-the-new-byteorder-headers.patch
byteorder-powerpc-use-the-new-byteorder-headers.patch
byteorder-s390-use-the-new-byteorder-headers.patch
byteorder-sh-use-the-new-byteorder-headers.patch
byteorder-sparc-use-the-new-byteorder-headers.patch
byteorder-x86-use-the-new-byteorder-headers.patch
byteorder-xtensa-use-the-new-byteorder-headers.patch
byteorder-fix-direct-byteswap-includes.patch
byteorder-remove-the-old-byteorder-implementation.patch

