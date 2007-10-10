From: akpm@linux-foundation.org
Subject: - fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:11:01 -0700
Message-ID: <200710102111.l9ALB1x9025984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431AbXJJVVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.korty@ccur.com, James.Bottomley@steeleye.com, aacraid@adaptec.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     Fix section mismatch in the Adaptec DPT SCSI Raid driver
has been removed from the -mm tree.  Its filename was
     fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix section mismatch in the Adaptec DPT SCSI Raid driver
From: Joe Korty <joe.korty@ccur.com>

Fix section mismatch in the Adaptec DPT SCSI Raid driver.

WARNING: vmlinux.o(.init.text+0x1fcd2): Section mismatch:
	reference to .exit.text:adpt_exit (between 'adpt_init' and 'ahc_linux_init')

This warning is due to adaptec device detection calling the exit routine on
failure to properly register the adaptec device.

The exit routine + call was added on July 30 by

	Commit: 55d9fcf57ba5ec427544fca7abc335cf3da78160
	Author: Matthew Wilcox
	Subject: [SCSI] dpt_i2o: convert to SCSI hotplug model.

Mathew: isn't a module exit routine a little too strong to be calling on the
failure of a single device?  Module exit implies that other, non-failing
adaptec raid devices will also get shut down.  

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dpt_i2o.c~fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver
+++ a/drivers/scsi/dpt_i2o.c
@@ -3346,7 +3346,7 @@ static int __init adpt_init(void)
 	return count > 0 ? 0 : -ENODEV;
 }
 
-static void __exit adpt_exit(void)
+static void adpt_exit(void)
 {
 	while (hba_chain)
 		adpt_release(hba_chain);
_

Patches currently in -mm which might be from joe.korty@ccur.com are

git-scsi-misc.patch
