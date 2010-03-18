From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-move-dereference-after-null-test.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:08:40 -0400
Message-ID: <201003181809.o2II9L6c007553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab0CRSJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:09:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, m-karicheri2@ti.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video: move dereference after NULL test
has been removed from the -mm tree.  Its filename was
     drivers-media-video-move-dereference-after-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video: move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

In quickcam_messenger.c, if the NULL test on uvd is needed, then the
dereference should be after the NULL test.

In vpif_display.c, std_info is initialized to the address of a structure
field.  This seems unlikely to be NULL.  Test std_info->stdid instead.

In saa7134-alsa.c, the function is only called from one place, where the
chip argument has already been dereferenced.  On the other hand, if it
should be kept, then card should be initialized after it.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/davinci/vpif_display.c        |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c        |    2 --
 drivers/media/video/usbvideo/quickcam_messenger.c |    3 ++-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/davinci/vpif_display.c
--- a/drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test
+++ a/drivers/media/video/davinci/vpif_display.c
@@ -383,7 +383,7 @@ static int vpif_get_std_info(struct chan
 	int index;
 
 	std_info->stdid = vid_ch->stdid;
-	if (!std_info)
+	if (!std_info->stdid)
 		return -1;
 
 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
diff -puN drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/saa7134/saa7134-alsa.c
--- a/drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-move-dereference-after-null-test
+++ a/drivers/media/video/saa7134/saa7134-alsa.c
@@ -1011,8 +1011,6 @@ static int snd_card_saa7134_new_mixer(sn
 	unsigned int idx;
 	int err, addr;
 
-	if (snd_BUG_ON(!chip))
-		return -EINVAL;
 	strcpy(card->mixername, "SAA7134 Mixer");
 
 	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_volume_controls); idx++) {
diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-video-move-dereference-after-null-test
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -692,12 +692,13 @@ static int qcm_start_data(struct uvd *uv
 
 static void qcm_stop_data(struct uvd *uvd)
 {
-	struct qcm *cam = (struct qcm *) uvd->user_data;
+	struct qcm *cam;
 	int i, j;
 	int ret;
 
 	if ((uvd == NULL) || (!uvd->streaming) || (uvd->dev == NULL))
 		return;
+	cam = (struct qcm *) uvd->user_data;
 
 	ret = qcm_camera_off(uvd);
 	if (ret)
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-edac-introduce-missing-kfree.patch

