From: akpm@linux-foundation.org
Subject: [merged] edac-test-correct-variable-in-store-function.patch removed from -mm tree
Date: Wed, 30 Jan 2013 12:31:24 -0800
Message-ID: <20130130203125.2639A5A420A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:49277 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3A3Ub0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jan 2013 15:31:26 -0500
Received: by mail-ve0-f201.google.com with SMTP id 15so157077vea.4
        for <mm-commits@vger.kernel.org>; Wed, 30 Jan 2013 12:31:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: edac: test correct variable in ->store function
has been removed from the -mm tree.  Its filename was
     edac-test-correct-variable-in-store-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: edac: test correct variable in ->store function

We're testing for ->show but calling ->store().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_pci_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/edac_pci_sysfs.c~edac-test-correct-variable-in-store-function drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~edac-test-correct-variable-in-store-function
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -256,7 +256,7 @@ static ssize_t edac_pci_dev_store(struct
 	struct edac_pci_dev_attribute *edac_pci_dev;
 	edac_pci_dev = (struct edac_pci_dev_attribute *)attr;
 
-	if (edac_pci_dev->show)
+	if (edac_pci_dev->store)
 		return edac_pci_dev->store(edac_pci_dev->value, buffer, count);
 	return -EIO;
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
compat-return-efault-on-error-in-waitid.patch
backlight-s6e63m0-report-gamma_table_count-correctly.patch
rtc-add-support-for-spi-rtc-rx4581-fix.patch

