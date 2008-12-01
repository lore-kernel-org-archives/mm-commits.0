From: akpm@linux-foundation.org
Subject: - input-ads7846c-sparse-lock-annotation.patch removed from -mm tree
Date: Mon, 01 Dec 2008 15:33:21 -0800
Message-ID: <200812012333.mB1NXMIm021319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYLAXd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 18:33:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: ads7846.c sparse lock annotation
has been removed from the -mm tree.  Its filename was
     input-ads7846c-sparse-lock-annotation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: ads7846.c sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/input/touchscreen/ads7846.c~input-ads7846c-sparse-lock-annotation drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~input-ads7846c-sparse-lock-annotation
+++ a/drivers/input/touchscreen/ads7846.c
@@ -761,6 +761,8 @@ static irqreturn_t ads7846_irq(int irq, 
 
 /* Must be called with ts->lock held */
 static void ads7846_disable(struct ads7846 *ts)
+__acquires(&ts->lock)
+__releases(&ts->lock)
 {
 	if (ts->disabled)
 		return;
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

