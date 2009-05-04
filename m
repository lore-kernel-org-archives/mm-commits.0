From: akpm@linux-foundation.org
Subject: + isdn-get_free_devid-failure-ignored.patch added to -mm tree
Date: Mon, 04 May 2009 15:58:12 -0700
Message-ID: <200905042258.n44MwCPr027658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbZEDW74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 18:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, Karsten-Keil@t-online.de


The patch titled
     isdn: get_free_devid() failure ignored
has been added to the -mm tree.  Its filename is
     isdn-get_free_devid-failure-ignored.patch

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
Subject: isdn: get_free_devid() failure ignored
From: Roel Kluin <roel.kluin@gmail.com>

dev->id is unsigned so a get_free_devid() error is ignored.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Karsten Keil <Karsten-Keil@t-online.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/mISDN/core.c~isdn-get_free_devid-failure-ignored drivers/isdn/mISDN/core.c
--- a/drivers/isdn/mISDN/core.c~isdn-get_free_devid-failure-ignored
+++ a/drivers/isdn/mISDN/core.c
@@ -214,7 +214,7 @@ get_free_devid(void)
 		if (!test_and_set_bit(i, (u_long *)&device_ids))
 			break;
 	if (i > MAX_DEVICE_ID)
-		return -1;
+		return -EBUSY;
 	return i;
 }
 
@@ -224,10 +224,10 @@ mISDN_register_device(struct mISDNdevice
 {
 	int	err;
 
-	dev->id = get_free_devid();
-	err = -EBUSY;
-	if (dev->id < 0)
+	err = get_free_devid();
+	if (err < 0)
 		goto error1;
+	dev->id = err;
 
 	device_initialize(&dev->dev);
 	if (name && name[0])
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

