From: akpm@linux-foundation.org
Subject: + cdrom-handle-toc.patch added to -mm tree
Date: Mon, 11 Aug 2008 15:02:34 -0700
Message-ID: <200808112202.m7BM2YN1023884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYHKWDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 18:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shurick@sectorb.msk.ru, bzolnier@gmail.com, jens.axboe@oracle.com, petkovbb@googlemail.com, tj@kernel.org


The patch titled
     cdrom: handle TOC
has been added to the -mm tree.  Its filename is
     cdrom-handle-toc.patch

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
Subject: cdrom: handle TOC
From: Alexander Inyukhin <shurick@sectorb.msk.ru>

This patch should fix TOC handling for cdroms that can not play audio.  It
extends commit af744e3294d09d706c4eae26cffaaa68a8d40337 ("cdrom: don't
check CDC_PLAY_AUDIO in cdrom_count_tracks()") with a safety check and
non-audio ioctls support.

Since CDC_PLAY_AUDIO flag was used not only to check ability to play audio
but also to ensure that audio_ioctl was not NULL, all TOC-related
operations had to use it.

As far as I understand, now audio_ioctl is never NULL, so a sanity check
during device registration should be sufficient.

It was tested on Optiarc AD7203A device, that has no ability to play
audio.

Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/cdrom/cdrom.c~cdrom-handle-toc drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~cdrom-handle-toc
+++ a/drivers/cdrom/cdrom.c
@@ -394,6 +394,8 @@ int register_cdrom(struct cdrom_device_i
 
 	if (cdo->open == NULL || cdo->release == NULL)
 		return -EINVAL;
+	if (cdo->audio_ioctl == NULL)
+		return -EINVAL;
 	if (!banner_printed) {
 		printk(KERN_INFO "Uniform CD-ROM driver " REVISION "\n");
 		banner_printed = 1;
@@ -408,7 +410,6 @@ int register_cdrom(struct cdrom_device_i
 	ENSURE(get_last_session, CDC_MULTI_SESSION);
 	ENSURE(get_mcn, CDC_MCN);
 	ENSURE(reset, CDC_RESET);
-	ENSURE(audio_ioctl, CDC_PLAY_AUDIO);
 	ENSURE(generic_packet, CDC_GENERIC_PACKET);
 	cdi->mc_flags = 0;
 	cdo->n_minors = 0;
@@ -2506,8 +2507,6 @@ static int cdrom_ioctl_get_subchnl(struc
 
 	/* cdinfo(CD_DO_IOCTL,"entering CDROMSUBCHNL\n");*/
 
-	if (!CDROM_CAN(CDC_PLAY_AUDIO))
-		return -ENOSYS;
 	if (copy_from_user(&q, argp, sizeof(q)))
 		return -EFAULT;
 
@@ -2538,8 +2537,6 @@ static int cdrom_ioctl_read_tochdr(struc
 
 	/* cdinfo(CD_DO_IOCTL, "entering CDROMREADTOCHDR\n"); */
 
-	if (!CDROM_CAN(CDC_PLAY_AUDIO))
-		return -ENOSYS;
 	if (copy_from_user(&header, argp, sizeof(header)))
 		return -EFAULT;
 
@@ -2562,8 +2559,6 @@ static int cdrom_ioctl_read_tocentry(str
 
 	/* cdinfo(CD_DO_IOCTL, "entering CDROMREADTOCENTRY\n"); */
 
-	if (!CDROM_CAN(CDC_PLAY_AUDIO))
-		return -ENOSYS;
 	if (copy_from_user(&entry, argp, sizeof(entry)))
 		return -EFAULT;
 
_

Patches currently in -mm which might be from shurick@sectorb.msk.ru are

cdrom-handle-toc.patch

