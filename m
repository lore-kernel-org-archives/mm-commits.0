From: akpm@linux-foundation.org
Subject: - i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:01 -0800
Message-ID: <200812152002.mBFK21gt030645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbYLOUCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ben-linux@fluff.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     i2c: trivial endian casting fixes in i2c-highlander.c
has been removed from the -mm tree.  Its filename was
     i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: trivial endian casting fixes in i2c-highlander.c
From: Harvey Harrison <harvey.harrison@gmail.com>

Fixes sparse warnings:
drivers/i2c/busses/i2c-highlander.c:95:26: warning: incorrect type in argument 1 (different base types)
drivers/i2c/busses/i2c-highlander.c:95:26:    expected restricted __be16 const [usertype] *p
drivers/i2c/busses/i2c-highlander.c:95:26:    got unsigned short [usertype] *<noident>
drivers/i2c/busses/i2c-highlander.c:106:15: warning: incorrect type in assignment (different base types)
drivers/i2c/busses/i2c-highlander.c:106:15:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/i2c/busses/i2c-highlander.c:106:15:    got restricted __be16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-highlander.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/i2c/busses/i2c-highlander.c~i2c-trivial-endian-casting-fixes-in-i2c-highlanderc drivers/i2c/busses/i2c-highlander.c
--- a/drivers/i2c/busses/i2c-highlander.c~i2c-trivial-endian-casting-fixes-in-i2c-highlanderc
+++ a/drivers/i2c/busses/i2c-highlander.c
@@ -92,7 +92,7 @@ static void highlander_i2c_setup(struct 
 static void smbus_write_data(u8 *src, u16 *dst, int len)
 {
 	for (; len > 1; len -= 2) {
-		*dst++ = be16_to_cpup((u16 *)src);
+		*dst++ = be16_to_cpup((__be16 *)src);
 		src += 2;
 	}
 
@@ -103,7 +103,7 @@ static void smbus_write_data(u8 *src, u1
 static void smbus_read_data(u16 *src, u8 *dst, int len)
 {
 	for (; len > 1; len -= 2) {
-		*(u16 *)dst = cpu_to_be16p(src++);
+		*(__be16 *)dst = cpu_to_be16p(src++);
 		dst += 2;
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
input-strict_strtoul-takes-unsigned-long.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-use-the-new-byteorder-headers.patch
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
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch

