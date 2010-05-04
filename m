From: akpm@linux-foundation.org
Subject: + ipmi-change-device-discovery-order.patch added to -mm tree
Date: Tue, 04 May 2010 15:54:13 -0700
Message-ID: <201005042254.o44MsDuQ023806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934524Ab0EDWy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     ipmi: change device discovery order
has been added to the -mm tree.  Its filename is
     ipmi-change-device-discovery-order.patch

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
Subject: ipmi: change device discovery order
From: Matthew Garrett <mjg@redhat.com>

The ipmi spec provides an ordering for si discovery.  Change the driver to
match, with the exception of preferring smbios to SPMI as HPs (at least)
contain accurate information in the former but not the latter.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-change-device-discovery-order drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-change-device-discovery-order
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -3307,17 +3307,6 @@ static __devinit int init_ipmi_si(void)
 	}
 	mutex_unlock(&smi_infos_lock);
 
-#ifdef CONFIG_DMI
-	dmi_find_bmc();
-#endif
-
-#ifdef CONFIG_ACPI
-	spmi_find_bmc();
-#endif
-#ifdef CONFIG_ACPI
-	pnp_register_driver(&ipmi_pnp_driver);
-#endif
-
 #ifdef CONFIG_PCI
 	rv = pci_register_driver(&ipmi_pci_driver);
 	if (rv)
@@ -3326,6 +3315,18 @@ static __devinit int init_ipmi_si(void)
 		       rv);
 #endif
 
+#ifdef CONFIG_ACPI
+	pnp_register_driver(&ipmi_pnp_driver);
+#endif
+
+#ifdef CONFIG_DMI
+	dmi_find_bmc();
+#endif
+
+#ifdef CONFIG_ACPI
+	spmi_find_bmc();
+#endif
+
 #ifdef CONFIG_PPC_OF
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61.patch
ipmi-change-addr_source-to-an-enum-rather-than-strings.patch
ipmi-split-device-discovery-and-registration.patch
ipmi-only-register-one-si-per-bmc.patch
ipmi-change-device-discovery-order.patch
ipmi-reduce-polling-when-interrupts-are-available.patch
ipmi-reduce-polling.patch
ipmi-attempt-to-register-multiple-sis-of-the-same-type.patch

