From: akpm@linux-foundation.org
Subject: + drivers-mfd-tps65912-corec-dont-leak-init_data-in-tps65912_device_init.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:43:38 -0700
Message-ID: <201109142043.p8EKhds6022200@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:14828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1INUnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, magi@slimlogic.co.uk, sameo@linux.intel.com


The patch titled
     drivers/mfd/tps65912-core.c: don't leak init_data in tps65912_device_init()
has been added to the -mm tree.  Its filename is
     drivers-mfd-tps65912-corec-dont-leak-init_data-in-tps65912_device_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mfd/tps65912-core.c: don't leak init_data in tps65912_device_init()
From: Jesper Juhl <jj@chaosbits.net>

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
drivers-misc-ptic-give-comm-function-scope-in-pti_control_frame_built_and_sent.patch
linux-next.patch
audit-always-follow-va_copy-with-va_end.patch
drivers-gpu-vga-vgaarbc-add-missing-kfree.patch
drivers-mfd-tps65912-corec-dont-leak-init_data-in-tps65912_device_init.patch
drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb.patch

