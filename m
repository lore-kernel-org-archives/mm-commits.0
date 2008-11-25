From: akpm@linux-foundation.org
Subject: + i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:54:08 -0800
Message-ID: <200811252254.mAPMs8Oj026260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbYKYWyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:54:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     i2c: trivial endian casting fixes in i2c-highlander.c
has been added to the -mm tree.  Its filename is
     i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch

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
unaligned-introduce-common-header.patch
unaligned-introduce-common-header-fix.patch
unaligned-introduce-common-header-fix-2.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

