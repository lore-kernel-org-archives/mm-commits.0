From: akpm@google.com
Subject: [merged] drivers-mfd-tps65912-corec-dont-leak-init_data-in-tps65912_device_init.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:11:38 -0700
Message-ID: <201109271911.p8RJBcc9025044@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:45599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1I0TLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, magi@slimlogic.co.uk, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/mfd/tps65912-core.c: don't leak init_data in tps65912_device_init()
has been removed from the -mm tree.  Its filename was
     drivers-mfd-tps65912-corec-dont-leak-init_data-in-tps65912_device_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jesper Juhl <jj@chaosbits.net>
Subject: drivers/mfd/tps65912-core.c: don't leak init_data in tps65912_device_init()

We neglect to free init_data on successful exit.  I also moved two
assignments to just before they are needed.  This avoids doing them in
case we hit an earlier error exit from the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/tps65912-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/tps65912-core.c~drivers-mfd-tps65912-corec-dont-leak-init_data-in-tps65912_device_init drivers/mfd/tps65912-core.c
--- a/drivers/mfd/tps65912-core.c~drivers-mfd-tps65912-corec-dont-leak-init_data-in-tps65912_device_init
+++ a/drivers/mfd/tps65912-core.c
@@ -131,9 +131,6 @@ int tps65912_device_init(struct tps65912
 	if (init_data == NULL)
 		return -ENOMEM;
 
-	init_data->irq = pmic_plat_data->irq;
-	init_data->irq_base = pmic_plat_data->irq;
-
 	mutex_init(&tps65912->io_mutex);
 	dev_set_drvdata(tps65912->dev, tps65912);
 
@@ -153,10 +150,13 @@ int tps65912_device_init(struct tps65912
 	if (ret < 0)
 		goto err;
 
+	init_data->irq = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq;
 	ret = tps65912_irq_init(tps65912, init_data->irq, init_data);
 	if (ret < 0)
 		goto err;
 
+	kfree(init_data);
 	return ret;
 
 err:
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch
audit-always-follow-va_copy-with-va_end.patch
drivers-gpu-vga-vgaarbc-add-missing-kfree.patch
drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb.patch

