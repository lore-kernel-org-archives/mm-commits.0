From: akpm@linux-foundation.org
Subject: + ipmi-make-sure-drivers-were-registered-before-unregistering-them.patch added to -mm tree
Date: Mon, 14 Jun 2010 13:36:16 -0700
Message-ID: <201006142036.o5EKaGJw029627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295Ab0FNUhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 16:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     ipmi: make sure drivers were registered before unregistering them
has been added to the -mm tree.  Its filename is
     ipmi-make-sure-drivers-were-registered-before-unregistering-them.patch

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
Subject: ipmi: make sure drivers were registered before unregistering them
From: Matthew Garrett <mjg@redhat.com>

The ipmi code will never register a PCI or Open Firmware driver if a
hardcoded device is provided by the user.  This can cause us to attempt to
unregister a driver that was never registered, resulting in an oops.  Keep
track of registration in order to avoid this.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-make-sure-drivers-were-registered-before-unregistering-them drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-make-sure-drivers-were-registered-before-unregistering-them
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -302,6 +302,12 @@ struct smi_info {
 
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
+#ifdef CONFIG_PCI
+static int pci_registered;
+#endif
+#ifdef CONFIG_PPC_OF
+static int of_registered;
+#endif
 
 static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
 static int num_max_busy_us;
@@ -3314,6 +3320,8 @@ static __devinit int init_ipmi_si(void)
 	rv = pci_register_driver(&ipmi_pci_driver);
 	if (rv)
 		printk(KERN_ERR PFX "Unable to register PCI driver: %d\n", rv);
+	else
+		pci_registered = 1;
 #endif
 
 #ifdef CONFIG_ACPI
@@ -3330,6 +3338,7 @@ static __devinit int init_ipmi_si(void)
 
 #ifdef CONFIG_PPC_OF
 	of_register_platform_driver(&ipmi_of_platform_driver);
+	of_registered = 1;
 #endif
 
 	/* We prefer devices with interrupts, but in the case of a machine
@@ -3383,11 +3392,13 @@ static __devinit int init_ipmi_si(void)
 	if (unload_when_empty && list_empty(&smi_infos)) {
 		mutex_unlock(&smi_infos_lock);
 #ifdef CONFIG_PCI
-		pci_unregister_driver(&ipmi_pci_driver);
+		if (pci_registered)
+			pci_unregister_driver(&ipmi_pci_driver);
 #endif
 
 #ifdef CONFIG_PPC_OF
-		of_unregister_platform_driver(&ipmi_of_platform_driver);
+		if (of_registered)
+			of_unregister_platform_driver(&ipmi_of_platform_driver);
 #endif
 		driver_unregister(&ipmi_driver.driver);
 		printk(KERN_WARNING PFX
@@ -3478,14 +3489,16 @@ static __exit void cleanup_ipmi_si(void)
 		return;
 
 #ifdef CONFIG_PCI
-	pci_unregister_driver(&ipmi_pci_driver);
+	if (pci_registered)
+		pci_unregister_driver(&ipmi_pci_driver);
 #endif
 #ifdef CONFIG_ACPI
 	pnp_unregister_driver(&ipmi_pnp_driver);
 #endif
 
 #ifdef CONFIG_PPC_OF
-	of_unregister_platform_driver(&ipmi_of_platform_driver);
+	if (of_registered)
+		of_unregister_platform_driver(&ipmi_of_platform_driver);
 #endif
 
 	mutex_lock(&smi_infos_lock);
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
ipmi-make-sure-drivers-were-registered-before-unregistering-them.patch
dell-studio-1555-eject-key-does-not-work-small-patch-to-fix-included.patch
wmi-fix-memory-leak-in-parse_wdg.patch
acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit.patch
hp-wmi-add-error-handling-for-hp_wmi_init.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch

