From: akpm@linux-foundation.org
Subject: + drivers-scsi-mvsasc-fix-printk-warnings.patch added to -mm tree
Date: Thu, 01 May 2008 04:30:37 -0700
Message-ID: <200805011130.m41BUbJ2002851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbYEALbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 07:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, kewei@marvell.com


The patch titled
     drivers/scsi/mvsas.c: fix printk warnings
has been added to the -mm tree.  Its filename is
     drivers-scsi-mvsasc-fix-printk-warnings.patch

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
Subject: drivers/scsi/mvsas.c: fix printk warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/mvsas.c: In function `mvs_update_phyinfo':
drivers/scsi/mvsas.c:2822: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/mvsas.c:2822: warning: long long unsigned int format, u64 arg (arg 6)

We do not know what type the arch uses to implement u64

Cc: Ke Wei <kewei@marvell.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mvsas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-printk-warnings drivers/scsi/mvsas.c
--- a/drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-printk-warnings
+++ a/drivers/scsi/mvsas.c
@@ -2822,7 +2822,9 @@ static void mvs_update_phyinfo(struct mv
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"phy[%d] Get Attached Address 0x%llX ,"
 			" SAS Address 0x%llX\n",
-			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
+			i,
+			(unsigned long long)phy->att_dev_sas_addr,
+			(unsigned long long)phy->dev_sas_addr);
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"Rate = %x , type = %d\n",
 			sas_phy->linkrate, phy->phy_type);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pnp-fix-printk-format-warnings.patch
drivers-char-synclinkc-inbreak-mgsl_put_char.patch
drivers-char-synclinkc-inbreak-mgsl_put_char-fix.patch
drivers-scsi-ncr53c8xxc-fix-warning.patch
drivers-scsi-mvsasc-fix-printk-warnings.patch

