From: akpm@linux-foundation.org
Subject: [merged]
 hpsa-return-0-from-driver-probe-function-on-success-not-1.patch removed
 from -mm tree
Date: Tue, 03 Dec 2013 12:22:08 -0800
Message-ID: <529e3d70.Z00Zh23hDklXdsdr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab3LCUWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 15:22:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, scameron@beardog.cce.hp.com

Subject: [merged] hpsa-return-0-from-driver-probe-function-on-success-not-1.patch removed from -mm tree
To: scameron@beardog.cce.hp.com,axboe@kernel.dk,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 12:22:08 -0800


The patch titled
     Subject: hpsa: return 0 from driver probe function on success, not 1
has been removed from the -mm tree.  Its filename was
     hpsa-return-0-from-driver-probe-function-on-success-not-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Subject: hpsa: return 0 from driver probe function on success, not 1

A return value of 1 is interpreted as an error.  See pci_driver.  in
local_pci_probe().  If you're wondering how this ever could have worked,
it's because it used to be the case that only return values less than zero
were interpreted as failure.  But even in the current kernel if the driver
registers its various entry points with the kernel, and then returns a
value which is interpreted as failure, those registrations aren't undone,
so the driver still mostly works.  However, the driver's remove function
wouldn't be called on rmmod, and pci power management functions wouldn't
work.  In the case of Smart Array, since it has a battery backed cache (or
else no cache) even if the driver is not shut down properly as long as
there is no outstanding i/o, nothing too bad happens, which is why it took
so long to notice.

Requesting backport to stable because the change to pci-driver.c which
requires driver probe functions to return 0 occurred between 2.6.35 and
2.6.36 (the pci power management breakage) and again between 3.7 and 3.8
(pci_dev->driver getting set to NULL in local_pci_probe() preventing
driver remove function from being called on rmmod.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-return-0-from-driver-probe-function-on-success-not-1 drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-return-0-from-driver-probe-function-on-success-not-1
+++ a/drivers/scsi/hpsa.c
@@ -4925,7 +4925,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	start_controller_lockup_detector(h);
-	return 1;
+	return 0;
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
linux-next.patch

