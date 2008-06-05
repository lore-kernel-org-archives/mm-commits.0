From: akpm@linux-foundation.org
Subject: + olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc.patch added to -mm tree
Date: Thu, 05 Jun 2008 12:42:19 -0700
Message-ID: <200806051942.m55JgJKw026509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762604AbYFETnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 15:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     OLPC: pci: fix up PCI stuff so that PCI_GOANY supports OLPC
has been added to the -mm tree.  Its filename is
     olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OLPC: pci: fix up PCI stuff so that PCI_GOANY supports OLPC
From: Andres Salomon <dilinger@queued.net>

Previously, one would have to specifically choose CONFIG_OLPC and
CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really work
for distro kernels, so this patch allows one to choose CONFIG_OLPC and
CONFIG_PCI_GOANY in order to build in OLPC support in a generic kernel (as
requested by Robert Millan).

This also moves GOOLPC before GOANY in the menuconfig list.

Finally, make pci_access_init return early if we detect OLPC hardware. 
There's no need to continue probing stuff, and pci_pcbios_init
specifically trashes our settings (we didn't run into that before because
PCI_GOANY wasn't supported).

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig    |   11 +++++------
 arch/x86/pci/init.c |    3 ++-
 arch/x86/pci/olpc.c |    5 +++--
 arch/x86/pci/pci.h  |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff -puN arch/x86/Kconfig~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc arch/x86/Kconfig
--- a/arch/x86/Kconfig~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc
+++ a/arch/x86/Kconfig
@@ -1556,13 +1556,13 @@ config PCI_GOMMCONFIG
 config PCI_GODIRECT
 	bool "Direct"
 
-config PCI_GOANY
-	bool "Any"
-
 config PCI_GOOLPC
 	bool "OLPC"
 	depends on OLPC
 
+config PCI_GOANY
+	bool "Any"
+
 endchoice
 
 config PCI_BIOS
@@ -1579,9 +1579,8 @@ config PCI_MMCONFIG
 	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
 
 config PCI_OLPC
-	bool
-	depends on PCI && PCI_GOOLPC
-	default y
+	def_bool y
+	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
 
 config PCI_DOMAINS
 	def_bool y
diff -puN arch/x86/pci/init.c~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc arch/x86/pci/init.c
--- a/arch/x86/pci/init.c~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc
+++ a/arch/x86/pci/init.c
@@ -15,7 +15,8 @@ static __init int pci_access_init(void)
 	pci_mmcfg_early_init();
 
 #ifdef CONFIG_PCI_OLPC
-	pci_olpc_init();
+	if (!pci_olpc_init())
+		return 0;	/* skip additional checks if it's an XO */
 #endif
 #ifdef CONFIG_PCI_BIOS
 	pci_pcbios_init();
diff -puN arch/x86/pci/olpc.c~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc arch/x86/pci/olpc.c
--- a/arch/x86/pci/olpc.c~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc
+++ a/arch/x86/pci/olpc.c
@@ -302,12 +302,13 @@ static struct pci_raw_ops pci_olpc_conf 
 	.write = pci_olpc_write,
 };
 
-void __init pci_olpc_init(void)
+int __init pci_olpc_init(void)
 {
 	if (!machine_is_olpc() || olpc_has_vsa())
-		return;
+		return -ENODEV;
 
 	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
 	raw_pci_ops = &pci_olpc_conf;
 	is_lx = is_geode_lx();
+	return 0;
 }
diff -puN arch/x86/pci/pci.h~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc arch/x86/pci/pci.h
--- a/arch/x86/pci/pci.h~olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc
+++ a/arch/x86/pci/pci.h
@@ -102,7 +102,7 @@ extern struct pci_raw_ops pci_direct_con
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern void pci_olpc_init(void);
+extern int pci_olpc_init(void);
 
 /* pci-mmconfig.c */
 
_

Patches currently in -mm which might be from dilinger@queued.net are

linux-next.patch
git-battery.patch
olpc-pci-fix-up-pci-stuff-so-that-pci_goany-supports-olpc.patch

