From: akpm@linux-foundation.org
Subject: [merged] jsm-fix-the-return-variable-and-remov-the-unused-retval.patch removed from -mm tree
Date: Fri, 27 Feb 2009 10:39:21 -0800
Message-ID: <200902271839.n1RIdLXu022735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbZB0SkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 13:40:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, scottk@digi.com, mm-commits@vger.kernel.org


The patch titled
     jsm: fix the return variable and remov the unused retval
has been removed from the -mm tree.  Its filename was
     jsm-fix-the-return-variable-and-remov-the-unused-retval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jsm: fix the return variable and remov the unused retval
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Fix the return variable and removing the unused retval.

As it was, the retval was never returned, so its assignments were silly. 
Just consolidate everything to rc, and remove the unused retval variable.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <scottk@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_driver.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/serial/jsm/jsm_driver.c~jsm-fix-the-return-variable-and-remov-the-unused-retval drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c~jsm-fix-the-return-variable-and-remov-the-unused-retval
+++ a/drivers/serial/jsm/jsm_driver.c
@@ -57,7 +57,6 @@ static int jsm_probe_one(struct pci_dev 
 	int rc = 0;
 	struct jsm_board *brd;
 	static int adapter_count = 0;
-	int retval;
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
@@ -134,7 +133,7 @@ static int jsm_probe_one(struct pci_dev 
 	rc = jsm_tty_init(brd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Can't init tty devices (%d)\n", rc);
-		retval = -ENXIO;
+		rc = -ENXIO;
 		goto out_free_irq;
 	}
 
@@ -142,7 +141,7 @@ static int jsm_probe_one(struct pci_dev 
 	if (rc < 0) {
 		/* XXX: leaking all resources from jsm_tty_init here! */
 		dev_err(&pdev->dev, "Can't init uart port (%d)\n", rc);
-		retval = -ENXIO;
+		rc = -ENXIO;
 		goto out_free_irq;
 	}
 
@@ -161,7 +160,7 @@ static int jsm_probe_one(struct pci_dev 
 		/* XXX: leaking all resources from jsm_tty_init and
 		 	jsm_uart_port_init here! */
 		dev_err(&pdev->dev, "memory allocation for flipbuf failed\n");
-		retval = -ENOMEM;
+		rc = -ENOMEM;
 		goto out_free_irq;
 	}
 
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com are

linux-next.patch

