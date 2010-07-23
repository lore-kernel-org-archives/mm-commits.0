From: akpm@linux-foundation.org
Subject: + edac-i5400-improve-handling-of-pci_enable_device-return-value.patch added to -mm tree
Date: Fri, 23 Jul 2010 14:44:57 -0700
Message-ID: <201007232144.o6NLivlR009907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033Ab0GWVpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Jul 2010 17:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, dougthompson@xmission.com, jroberson@jroberson.net, mchehab@redhat.com


The patch titled
     edac: i5400: improve handling of pci_enable_device() return value
has been added to the -mm tree.  Its filename is
     edac-i5400-improve-handling-of-pci_enable_device-return-value.patch

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
Subject: edac: i5400: improve handling of pci_enable_device() return value
From: Kulikov Vasiliy <segooon@gmail.com>

-EIO is not the only error code that pci_enable_device() may return, also
the set of errors can be enhanced in future.  We should compare return
code with zero, not with concrete error value.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jeff Roberson <jroberson@jroberson.net>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5400_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i5400_edac.c~edac-i5400-improve-handling-of-pci_enable_device-return-value drivers/edac/i5400_edac.c
--- a/drivers/edac/i5400_edac.c~edac-i5400-improve-handling-of-pci_enable_device-return-value
+++ a/drivers/edac/i5400_edac.c
@@ -1348,7 +1348,7 @@ static int __devinit i5400_init_one(stru
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
-	if (rc == -EIO)
+	if (rc)
 		return rc;
 
 	/* now probe and enable the device */
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch
edac-i5000-improve-handling-of-pci_enable_device-return-value.patch
edac-i5400-improve-handling-of-pci_enable_device-return-value.patch

