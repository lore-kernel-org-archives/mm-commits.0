From: akpm@linux-foundation.org
Subject: - v4l-s2255drv-fix-firmware-test-on-big-endian.patch removed from -mm tree
Date: Mon, 24 Nov 2008 11:29:36 -0800
Message-ID: <200811241929.mAOJTaKL027771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYKXTaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 14:30:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dean@sensoray.com, hverkuil@xs4all.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: s2255drv fix firmware test on big-endian
has been removed from the -mm tree.  Its filename was
     v4l-s2255drv-fix-firmware-test-on-big-endian.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l: s2255drv fix firmware test on big-endian
From: Harvey Harrison <harvey.harrison@gmail.com>

Noticed by sparse:
drivers/media/video/s2255drv.c:2531:6: warning: restricted __le32 degrades to integer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dean Anderson <dean@sensoray.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/s2255drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/s2255drv.c~v4l-s2255drv-fix-firmware-test-on-big-endian drivers/media/video/s2255drv.c
--- a/drivers/media/video/s2255drv.c~v4l-s2255drv-fix-firmware-test-on-big-endian
+++ a/drivers/media/video/s2255drv.c
@@ -192,7 +192,7 @@ struct s2255_dmaqueue {
 #define S2255_FW_FAILED		3
 #define S2255_FW_DISCONNECTING  4
 
-#define S2255_FW_MARKER         0x22552f2f
+#define S2255_FW_MARKER		cpu_to_le32(0x22552f2f)
 /* 2255 read states */
 #define S2255_READ_IDLE         0
 #define S2255_READ_FRAME        1
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
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

