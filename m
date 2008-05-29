From: akpm@linux-foundation.org
Subject: - scsi-remove-cdrom-not-ready-printk.patch removed from -mm tree
Date: Thu, 29 May 2008 08:59:53 -0700
Message-ID: <200805291559.m4TFxr12009915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357AbYE2P76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 11:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerb.stralko@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: remove CDROM not ready printk
has been removed from the -mm tree.  Its filename was
     scsi-remove-cdrom-not-ready-printk.patch

This patch was dropped because it is obsolete

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

