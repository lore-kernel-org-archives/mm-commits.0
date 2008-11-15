From: akpm@linux-foundation.org
Subject: + dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch added to -mm tree
Date: Fri, 14 Nov 2008 17:08:45 -0800
Message-ID: <200811150108.mAF18kf4007730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbYKOBJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 20:09:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mchehab@infradead.org, thierry.merle@free.fr, tomimo@ncircle.nullnet.fi


The patch titled
     dvb: cinergyt2 annotate struct endianness, remove unused variable, add static
has been added to the -mm tree.  Its filename is
     dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch

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
Subject: dvb: cinergyt2 annotate struct endianness, remove unused variable, add static
From: Harvey Harrison <harvey.harrison@gmail.com>

All noticed by sparse:
drivers/media/dvb/dvb-usb/cinergyT2-core.c:35:5: warning: symbol 'disable_remote' was not declared. Should it be static?
drivers/media/dvb/dvb-usb/cinergyT2-core.c:48:23: warning: symbol 'cinergyt2_usb_device' was not declared. Should it be static?
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:160:15: warning: cast to restricted __le16
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:190:9: warning: cast to restricted __le32
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:208:9: warning: cast to restricted __le32
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:227:24: warning: cast to restricted __le16
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:275:12: warning: incorrect type in assignment (different base types)
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:275:12:    expected unsigned short [unsigned] [assigned] [usertype] tps
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:275:12:    got restricted __le16 [usertype] <noident>
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:276:13: warning: incorrect type in assignment (different base types)
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:276:13:    expected unsigned int [unsigned] [assigned] [usertype] freq
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:276:13:    got restricted __le32 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tomi Orava <tomimo@ncircle.nullnet.fi>
Cc: Thierry MERLE <thierry.merle@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/cinergyT2-core.c |    3 +--
 drivers/media/dvb/dvb-usb/cinergyT2.h      |   10 +++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/cinergyT2-core.c~dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static drivers/media/dvb/dvb-usb/cinergyT2-core.c
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c~dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static
+++ a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -32,7 +32,6 @@
 
 /* debug */
 int dvb_usb_cinergyt2_debug;
-int disable_remote;
 
 module_param_named(debug, dvb_usb_cinergyt2_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 "
@@ -45,7 +44,7 @@ struct cinergyt2_state {
 };
 
 /* We are missing a release hook with usb_device data */
-struct dvb_usb_device *cinergyt2_usb_device;
+static struct dvb_usb_device *cinergyt2_usb_device;
 
 static struct dvb_usb_device_properties cinergyt2_properties;
 
diff -puN drivers/media/dvb/dvb-usb/cinergyT2.h~dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static drivers/media/dvb/dvb-usb/cinergyT2.h
--- a/drivers/media/dvb/dvb-usb/cinergyT2.h~dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static
+++ a/drivers/media/dvb/dvb-usb/cinergyT2.h
@@ -70,11 +70,11 @@ struct dvbt_get_status_msg {
 	uint8_t bandwidth;
 	uint16_t tps;
 	uint8_t flags;
-	uint16_t gain;
+	__le16 gain;
 	uint8_t snr;
-	uint32_t viterbi_error_rate;
+	__le32 viterbi_error_rate;
 	uint32_t rs_error_rate;
-	uint32_t uncorrected_block_count;
+	__le32 uncorrected_block_count;
 	uint8_t lock_bits;
 	uint8_t prev_lock_bits;
 } __attribute__((packed));
@@ -82,9 +82,9 @@ struct dvbt_get_status_msg {
 
 struct dvbt_set_parameters_msg {
 	uint8_t cmd;
-	uint32_t freq;
+	__le32 freq;
 	uint8_t bandwidth;
-	uint16_t tps;
+	__le16 tps;
 	uint8_t flags;
 } __attribute__((packed));
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch
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

