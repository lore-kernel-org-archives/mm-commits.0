From: akpm@linux-foundation.org
Subject: + pnp-remove-module-infrastructure.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:39:18 -0700
Message-ID: <200708171839.l7HIdIak023936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbXHQSk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz


The patch titled
     PNP: remove MODULE infrastructure
has been added to the -mm tree.  Its filename is
     pnp-remove-module-infrastructure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: remove MODULE infrastructure
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We don't support building any part of PNP as a module (*drivers* can be
modules, of course, but the PNP infrastructure itself can not).  Since
MODULE will never be defined, remove the ifdefs and dead code.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/isapnp/proc.c  |   45 -----------------------------------
 drivers/pnp/pnpbios/core.c |   43 ---------------------------------
 2 files changed, 88 deletions(-)

diff -puN drivers/pnp/isapnp/proc.c~pnp-remove-module-infrastructure drivers/pnp/isapnp/proc.c
--- a/drivers/pnp/isapnp/proc.c~pnp-remove-module-infrastructure
+++ a/drivers/pnp/isapnp/proc.c
@@ -112,33 +112,6 @@ static int isapnp_proc_attach_device(str
 	return 0;
 }
 
-#ifdef MODULE
-static int __exit isapnp_proc_detach_device(struct pnp_dev *dev)
-{
-	struct pnp_card *bus = dev->card;
-	struct proc_dir_entry *de;
-	char name[16];
-
-	if (!(de = bus->procdir))
-		return -EINVAL;
-	sprintf(name, "%02x", dev->number);
-	remove_proc_entry(name, de);
-	return 0;
-}
-
-static int __exit isapnp_proc_detach_bus(struct pnp_card *bus)
-{
-	struct proc_dir_entry *de;
-	char name[16];
-
-	if (!(de = bus->procdir))
-		return -EINVAL;
-	sprintf(name, "%02x", bus->number);
-	remove_proc_entry(name, isapnp_proc_bus_dir);
-	return 0;
-}
-#endif				/* MODULE */
-
 int __init isapnp_proc_init(void)
 {
 	struct pnp_dev *dev;
@@ -149,21 +122,3 @@ int __init isapnp_proc_init(void)
 	}
 	return 0;
 }
-
-#ifdef MODULE
-int __exit isapnp_proc_done(void)
-{
-	struct pnp_dev *dev;
-	struct pnp_bus *card;
-
-	isapnp_for_each_dev(dev) {
-		isapnp_proc_detach_device(dev);
-	}
-	isapnp_for_each_card(card) {
-		isapnp_proc_detach_bus(card);
-	}
-	if (isapnp_proc_bus_dir)
-		remove_proc_entry("isapnp", proc_bus);
-	return 0;
-}
-#endif				/* MODULE */
diff -puN drivers/pnp/pnpbios/core.c~pnp-remove-module-infrastructure drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnp-remove-module-infrastructure
+++ a/drivers/pnp/pnpbios/core.c
@@ -419,7 +419,6 @@ static void __init build_devlist(void)
 static int pnpbios_disabled;
 int pnpbios_dont_use_current_config;
 
-#ifndef MODULE
 static int __init pnpbios_setup(char *str)
 {
 	int invert;
@@ -443,7 +442,6 @@ static int __init pnpbios_setup(char *st
 }
 
 __setup("pnpbios=", pnpbios_setup);
-#endif
 
 /* PnP BIOS signature: "$PnP" */
 #define PNP_SIGNATURE   (('$' << 0) + ('P' << 8) + ('n' << 16) + ('P' << 24))
@@ -607,48 +605,7 @@ static int __init pnpbios_thread_init(vo
 	return 0;
 }
 
-#ifndef MODULE
-
-/* init/main.c calls pnpbios_init early */
-
 /* Start the kernel thread later: */
 module_init(pnpbios_thread_init);
 
-#else
-
-/*
- * N.B.: Building pnpbios as a module hasn't been fully implemented
- */
-
-MODULE_LICENSE("GPL");
-
-static int __init pnpbios_init_all(void)
-{
-	int r;
-
-	r = pnpbios_init();
-	if (r)
-		return r;
-	r = pnpbios_thread_init();
-	if (r)
-		return r;
-	return 0;
-}
-
-static void __exit pnpbios_exit(void)
-{
-#ifdef CONFIG_HOTPLUG
-	unloading = 1;
-	wait_for_completion(&unload_sem);
-#endif
-	pnpbios_proc_exit();
-	/* We ought to free resources here */
-	return;
-}
-
-module_init(pnpbios_init_all);
-module_exit(pnpbios_exit);
-
-#endif
-
 EXPORT_SYMBOL(pnpbios_protocol);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-fix-up-after-lindent.patch
pnpacpi-simplify-irq_flags.patch
pnpacpi-remove-unnecessary-casts-of-void.patch
isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch
pnp-remove-module-infrastructure.patch
pnp-remove-null-pointer-checks.patch
