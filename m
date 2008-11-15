From: akpm@linux-foundation.org
Subject: + v4l-s2255drv-fix-firmware-test-on-big-endian.patch added to -mm tree
Date: Fri, 14 Nov 2008 17:10:14 -0800
Message-ID: <200811150110.mAF1AEBA008390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbYKOBKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 20:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dean@sensoray.com, hverkuil@xs4all.nl, mchehab@infradead.org


The patch titled
     v4l: s2255drv fix firmware test on big-endian
has been added to the -mm tree.  Its filename is
     v4l-s2255drv-fix-firmware-test-on-big-endian.patch

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

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch
v4l-s2255drv-fix-firmware-test-on-big-endian.patch
dlm-trivial-annotation-of-be16-value.patch
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

