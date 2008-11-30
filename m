From: akpm@linux-foundation.org
Subject: - unaligned-introduce-common-header-fix-2.patch removed from -mm tree
Date: Sat, 29 Nov 2008 17:24:35 -0800
Message-ID: <200811300124.mAU1OZPi016341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbYK3BYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 20:24:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     unaligned: write in increasing memory order
has been removed from the -mm tree.  Its filename was
     unaligned-introduce-common-header-fix-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: write in increasing memory order
From: Harvey Harrison <harvey.harrison@gmail.com>

This ordering seems more logical.

gcc 4.2 seems to be smart enough to figure it out in either order.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/unaligned.h~unaligned-introduce-common-header-fix-2 include/asm-generic/unaligned.h
--- a/include/asm-generic/unaligned.h~unaligned-introduce-common-header-fix-2
+++ a/include/asm-generic/unaligned.h
@@ -164,14 +164,14 @@ static inline void __put_le16_noalign(u8
 
 static inline void __put_le32_noalign(u8 *p, u32 val)
 {
-	__put_le16_noalign(p + 2, val >> 16);
 	__put_le16_noalign(p, val);
+	__put_le16_noalign(p + 2, val >> 16);
 }
 
 static inline void __put_le64_noalign(u8 *p, u64 val)
 {
-	__put_le32_noalign(p + 4, val >> 32);
 	__put_le32_noalign(p, val);
+	__put_le32_noalign(p + 4, val >> 32);
 }
 
 static inline void __put_be16_noalign(u8 *p, u16 val)
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
unaligned-introduce-common-header-fix-2.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

