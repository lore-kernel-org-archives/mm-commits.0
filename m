From: akpm@linux-foundation.org
Subject: + edac-test-correct-variable-in-store-function.patch added to -mm tree
Date: Mon, 28 Jan 2013 14:15:05 -0800
Message-ID: <20130128221505.9233431C266@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:36504 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3A1WPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 17:15:07 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so159246qah.0
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 14:15:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, dougthompson@xmission.com


The patch titled
     Subject: edac: test correct variable in ->store function
has been added to the -mm tree.  Its filename is
     edac-test-correct-variable-in-store-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
edac-test-correct-variable-in-store-function.patch
rtc-add-support-for-spi-rtc-rx4581-fix.patch

