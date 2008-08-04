From: akpm@linux-foundation.org
Subject: - cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:37 -0700
Message-ID: <200808042006.m74K6blU027703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762728AbYHDUHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com, petkovbb@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     cdrom: don't check CDC_PLAY_AUDIO in cdrom_count_tracks()
has been removed from the -mm tree.  Its filename was
     cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cdrom: don't check CDC_PLAY_AUDIO in cdrom_count_tracks()
From: Tejun Heo <tj@kernel.org>

According to MMC-3 (or any later versions) READ TOCs are mandatory
commands and have nothing to do with CDC_PLAY_AUDIO.  I have no idea why
the check was put there in the first place but it now only breaks
automatic actions on certain drives.

Note that this test was only effective when ide-cdrom was being used
as sr didn't mask CDC_PLAY_AUDIO according to the capabilities.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/cdrom/cdrom.c~cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks
+++ a/drivers/cdrom/cdrom.c
@@ -1436,10 +1436,6 @@ static void cdrom_count_tracks(struct cd
 	tracks->xa=0;
 	tracks->error=0;
 	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n"); 
-        if (!CDROM_CAN(CDC_PLAY_AUDIO)) { 
-                tracks->error=CDS_NO_INFO;
-                return;
-        }        
 	/* Grab the TOC header so we can see how many tracks there are */
 	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
 		if (ret == -ENOMEDIUM)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch
sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch

