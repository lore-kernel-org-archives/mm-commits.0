From: akpm@linux-foundation.org
Subject: - sparc64-fix-section-mismatch-warning-in-pci_sunv4.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:36 -0700
Message-ID: <200707230935.l6N9ZaGZ016503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757924AbXGWJpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sparc64: fix section mismatch warning in pci_sunv4
has been removed from the -mm tree.  Its filename was
     sparc64-fix-section-mismatch-warning-in-pci_sunv4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparc64: fix section mismatch warning in pci_sunv4
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x3cf50): Section mismatch: reference to .init.text:page_in_phys_avail (between 'pci_sun4v_pbm_init' and 'sun4v_pci_init')

pci_sun4v_pbm_init and sun4v_pci_init was only used under __init
context so declare them _init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/pci_sun4v.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc64/kernel/pci_sun4v.c~sparc64-fix-section-mismatch-warning-in-pci_sunv4 arch/sparc64/kernel/pci_sun4v.c
--- a/arch/sparc64/kernel/pci_sun4v.c~sparc64-fix-section-mismatch-warning-in-pci_sunv4
+++ a/arch/sparc64/kernel/pci_sun4v.c
@@ -1129,7 +1129,7 @@ static void pci_sun4v_msi_init(struct pc
 }
 #endif /* !(CONFIG_PCI_MSI) */
 
-static void pci_sun4v_pbm_init(struct pci_controller_info *p, struct device_node *dp, u32 devhandle)
+static void __init pci_sun4v_pbm_init(struct pci_controller_info *p, struct device_node *dp, u32 devhandle)
 {
 	struct pci_pbm_info *pbm;
 
@@ -1163,7 +1163,7 @@ static void pci_sun4v_pbm_init(struct pc
 	pci_sun4v_msi_init(pbm);
 }
 
-void sun4v_pci_init(struct device_node *dp, char *model_name)
+void __init sun4v_pci_init(struct device_node *dp, char *model_name)
 {
 	static int hvapi_negotiated = 0;
 	struct pci_controller_info *p;
_

Patches currently in -mm which might be from sam@ravnborg.org are

powerpc-vdso-install-unstripped-copies-on-disk.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
