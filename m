From: akpm@linux-foundation.org
Subject: + scsi-fix-miscalculation-of-sg_io-timeout-in-cdrom_send_packet-handler.patch added to -mm tree
Date: Wed, 30 Jul 2008 01:02:40 -0700
Message-ID: <200807300802.m6U82efl015208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYG3IDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 04:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: timw@splhi.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     scsi: fix miscalculation of sg_io timeout in CDROM_SEND_PACKET handler
has been added to the -mm tree.  Its filename is
     scsi-fix-miscalculation-of-sg_io-timeout-in-cdrom_send_packet-handler.patch

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
Subject: scsi: fix miscalculation of sg_io timeout in CDROM_SEND_PACKET handler
From: Tim Wright <timw@splhi.com>

It seems cdrwtool in the udftools has been unusable on "modern" kernels
for some time.  A Google search reveals many people with the same issue
but no solution (cdrwtool fails to format the disk).  After spending some
time tracking down the issue, it comes down to the following:

The udftools still use the older CDROM_SEND_PACKET interface to send
things like FORMAT_UNIT through to the drive.  They should really be
updated, but that's another story

Since most distros are using libata now, the cd or dvd burner appears as a
SCSI device, and we wind up in block/scsi_ioctl.c.  Here, the code tries
to take the "struct cdrom_generic_command" and translate it and stuff it
into a "struct sg_io_hdr" structure so it can pass it to the modern
sg_io() routine instead.

Unfortunately, there is one error, or rather an omission in the
translation.  The timeout that is passed in in the "struct
cdrom_generic_command" is in HZ=100 units, and this is modified and
correctly converted to jiffies by use of clock_t_to_jiffies()

However, a little further down, this cgc.timeout value in jiffies is
simply copied into the sg_io_hdr timeout, which should be in milliseconds.
 Since most modern x86 kernels seems to be getting build with HZ=250, the
timeout that is passed to sg_io and eventually converted to the
timeout_per_command member of the scsi_cmnd structure is now four times
too small.

Since cdrwtool tries to set the timeout to one hour for the FORMAT_UNIT
command, and it takes about 20 minutes to format a 4x CDRW, the SCSI
error-handler kicks in after the FORMAT_UNIT completes because it took
longer than the incorrectly-calculated timeout.

Patch to correct this follows. It fixes the problem on my test system.

Signed-off-by: Tim Wright <timw@splhi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/scsi_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/scsi_ioctl.c~scsi-fix-miscalculation-of-sg_io-timeout-in-cdrom_send_packet-handler block/scsi_ioctl.c
--- a/block/scsi_ioctl.c~scsi-fix-miscalculation-of-sg_io-timeout-in-cdrom_send_packet-handler
+++ a/block/scsi_ioctl.c
@@ -518,7 +518,7 @@ int scsi_cmd_ioctl(struct file *file, st
 			hdr.sbp = cgc.sense;
 			if (hdr.sbp)
 				hdr.mx_sb_len = sizeof(struct request_sense);
-			hdr.timeout = cgc.timeout;
+			hdr.timeout = jiffies_to_msecs(cgc.timeout);
 			hdr.cmdp = ((struct cdrom_generic_command __user*) arg)->cmd;
 			hdr.cmd_len = sizeof(cgc.cmd);
 
_

Patches currently in -mm which might be from timw@splhi.com are

scsi-fix-miscalculation-of-sg_io-timeout-in-cdrom_send_packet-handler.patch

