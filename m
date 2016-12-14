From: akpm@linux-foundation.org
Subject: [merged] pcmcia-m32r_pcc-use-common-error-path.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:23:00 -0800
Message-ID: <58519c14.2e2mK+Orwf4fTkkL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756499AbcLNTXB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/pcmcia/m32r_pcc.c: use common error path
has been removed from the -mm tree.  Its filename was
     pcmcia-m32r_pcc-use-common-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: drivers/pcmcia/m32r_pcc.c: use common error path

Use a common error path for the failure.

Link: http://lkml.kernel.org/r/1474237304-897-2-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/m32r_pcc.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/pcmcia/m32r_pcc.c~pcmcia-m32r_pcc-use-common-error-path drivers/pcmcia/m32r_pcc.c
--- a/drivers/pcmcia/m32r_pcc.c~pcmcia-m32r_pcc-use-common-error-path
+++ a/drivers/pcmcia/m32r_pcc.c
@@ -689,10 +689,8 @@ static int __init init_m32r_pcc(void)
 		return ret;
 
 	ret = platform_device_register(&pcc_device);
-	if (ret){
-		platform_driver_unregister(&pcc_driver);
-		return ret;
-	}
+	if (ret)
+		goto unreg_driv;
 
 	printk(KERN_INFO "m32r PCC probe:\n");
 
@@ -706,9 +704,8 @@ static int __init init_m32r_pcc(void)
 
 	if (pcc_sockets == 0) {
 		printk("socket is not found.\n");
-		platform_device_unregister(&pcc_device);
-		platform_driver_unregister(&pcc_driver);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unreg_dev;
 	}
 
 	/* Set up interrupt handler(s) */
@@ -734,6 +731,12 @@ static int __init init_m32r_pcc(void)
 	}
 
 	return 0;
+
+unreg_dev:
+	platform_device_unregister(&pcc_device);
+unreg_driv:
+	platform_driver_unregister(&pcc_driver);
+	return ret;
 } /* init_m32r_pcc */
 
 static void __exit exit_m32r_pcc(void)
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


