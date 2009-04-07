From: akpm@linux-foundation.org
Subject: [merged] spi-limit-reaches-1-tested-0.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:03 -0700
Message-ID: <200904071907.n37J73K8011121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746AbZDGTKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dbrownell@users.sourceforge.net, mceier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     spi: limit reaches -1, tested 0
has been removed from the -mm tree.  Its filename was
     spi-limit-reaches-1-tested-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: limit reaches -1, tested 0
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement limit will reach -1 rather than 0, so the warning
will not be issued.

Also, add a cpu_relax() into the busy-wait loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mariusz Ceier <mceier@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi-limit-reaches-1-tested-0 drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-limit-reaches-1-tested-0
+++ a/drivers/spi/spi_imx.c
@@ -779,7 +779,8 @@ static irqreturn_t interrupt_transfer(st
 
 			/* Read trailing bytes */
 			limit = loops_per_jiffy << 1;
-			while ((read(drv_data) == 0) && limit--);
+			while ((read(drv_data) == 0) && --limit)
+				cpu_relax();
 
 			if (limit == 0)
 				dev_err(&drv_data->pdev->dev,
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
ufs-sector_t-cannot-be-negative.patch

