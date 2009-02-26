From: akpm@linux-foundation.org
Subject: + hpilo-new-pci-device.patch added to -mm tree
Date: Thu, 26 Feb 2009 15:54:20 -0800
Message-ID: <200902262354.n1QNsKiF003404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858AbZBZXy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 18:54:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.altobelli@hp.com


The patch titled
     hpilo: new pci device
has been added to the -mm tree.  Its filename is
     hpilo-new-pci-device.patch

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
Subject: hpilo: new pci device
From: David Altobelli <david.altobelli@hp.com>

Future iLO devices will have an HP vendor id.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/hpilo.c~hpilo-new-pci-device drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-new-pci-device
+++ a/drivers/misc/hpilo.c
@@ -710,6 +710,7 @@ out:
 
 static struct pci_device_id ilo_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ilo_devices);
@@ -758,7 +759,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("0.06");
+MODULE_VERSION("1.0");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
_

Patches currently in -mm which might be from david.altobelli@hp.com are

hpilo-new-pci-device.patch

