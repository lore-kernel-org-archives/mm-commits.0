From: akpm@linux-foundation.org
Subject: + drivers-video-fsl-diu-fbc-fix-broken-fix.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:36:39 -0700
Message-ID: <200807111842.m6BIgKY4030669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746AbYGKSra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, avorontsov@ru.mvista.com


The patch titled
     drivers/video/fsl-diu-fb.c: fix broken fix
has been added to the -mm tree.  Its filename is
     drivers-video-fsl-diu-fbc-fix-broken-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/fsl-diu-fb.c: fix broken fix
From: Takashi Iwai <tiwai@suse.de>

On 2.6.26-rc9, the commit 05946bce839b4fed5442dbfab77060fb75e051f3
    fsl_diu_fb: fix build with CONFIG_PM=y, plus fix some warnings
breaks its previous fix f969c5672b16b857e5231ad3c78f08d8ef3305aa
    fsl-diu-db: compile fix

This patch reverts the broken part.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/fsl-diu-fb.c~drivers-video-fsl-diu-fbc-fix-broken-fix drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~drivers-video-fsl-diu-fbc-fix-broken-fix
+++ a/drivers/video/fsl-diu-fb.c
@@ -1324,7 +1324,7 @@ static int fsl_diu_suspend(struct of_dev
 {
 	struct fsl_diu_data *machine_data;
 
-	machine_data = dev_get_drvdata(&dev->dev);
+	machine_data = dev_get_drvdata(&ofdev->dev);
 	disable_lcdc(machine_data->fsl_diu_info[0]);
 
 	return 0;
@@ -1334,7 +1334,7 @@ static int fsl_diu_resume(struct of_devi
 {
 	struct fsl_diu_data *machine_data;
 
-	machine_data = dev_get_drvdata(&dev->dev);
+	machine_data = dev_get_drvdata(&ofdev->dev);
 	enable_lcdc(machine_data->fsl_diu_info[0]);
 
 	return 0;
_

Patches currently in -mm which might be from tiwai@suse.de are

drivers-video-fsl-diu-fbc-fix-broken-fix.patch
linux-next.patch
alsa-correct-kcalloc-usage.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-mixart-soundcard-driver.patch
kernel-schedc-add-missing-attr-parameter.patch
kcalloc-remove-runtime-division.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch

