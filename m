From: akpm@linux-foundation.org
Subject: + scsi-remove-cdrom-not-ready-printk.patch added to -mm tree
Date: Thu, 29 May 2008 00:41:59 -0700
Message-ID: <200805290741.m4T7fxZJ022993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452AbYE2Hmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 03:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerb.stralko@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: remove CDROM not ready printk
has been added to the -mm tree.  Its filename is
     scsi-remove-cdrom-not-ready-printk.patch

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
Subject: scsi: remove CDROM not ready printk
From: Jerry Stralko <gerb.stralko@gmail.com>

This printk was spamming my dmesg and /var/log/message.

Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sr_ioctl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/scsi/sr_ioctl.c~scsi-remove-cdrom-not-ready-printk drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c~scsi-remove-cdrom-not-ready-printk
+++ a/drivers/scsi/sr_ioctl.c
@@ -238,8 +238,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 					break;
 				}
 			}
-			if (!cgc->quiet)
-				printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
 #ifdef DEBUG
 			scsi_print_sense_hdr("sr", &sshdr);
 #endif
_

Patches currently in -mm which might be from gerb.stralko@gmail.com are

scsi-remove-cdrom-not-ready-printk.patch

