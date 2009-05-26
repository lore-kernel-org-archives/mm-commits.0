From: akpm@linux-foundation.org
Subject: [merged] isdn-get_free_devid-failure-ignored.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:30 -0700
Message-ID: <200905261935.n4QJZUik006352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755939AbZEZToD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, Karsten-Keil@t-online.de, mm-commits@vger.kernel.org


The patch titled
     isdn: get_free_devid() failure ignored
has been removed from the -mm tree.  Its filename was
     isdn-get_free_devid-failure-ignored.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

