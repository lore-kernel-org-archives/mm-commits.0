From: akpm@osdl.org
Subject: - powerpc-fix-sys_pciconfig_iobase-bus-matching.patch removed from -mm tree
Date: Mon, 29 Jan 2007 13:17:06 -0800
Message-ID: <200701292117.l0TLH6dj031156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbXA2VRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 16:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: Fix sys_pciconfig_iobase bus matching
has been removed from the -mm tree.  Its filename was
     powerpc-fix-sys_pciconfig_iobase-bus-matching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: Fix sys_pciconfig_iobase bus matching
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

A stupid bug has been plaguing the sys_pciconfig_iobase on ppc64.  It
wasn't noticed until recently as it seems to not affect G5s but it's been
causing problems running X servers on some other machines recently.  The
bus number matching was bogus.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/pci_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/pci_64.c~powerpc-fix-sys_pciconfig_iobase-bus-matching arch/powerpc/kernel/pci_64.c
--- a/arch/powerpc/kernel/pci_64.c~powerpc-fix-sys_pciconfig_iobase-bus-matching
+++ a/arch/powerpc/kernel/pci_64.c
@@ -1430,7 +1430,7 @@ long sys_pciconfig_iobase(long which, un
 
 	for (ln = pci_root_buses.next; ln != &pci_root_buses; ln = ln->next) {
 		bus = pci_bus_b(ln);
-		if (in_bus >= bus->number && in_bus < (bus->number + bus->subordinate))
+		if (in_bus >= bus->number && in_bus <= bus->subordinate)
 			break;
 		bus = NULL;
 	}
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
x86-fix-vdso-mapping-for-aout-executables.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-powerpc.patch
fix-ppc64s-writing-to-struct-file_operations.patch
fix-apparent-typo-config_serial_cpm_smc.patch
driver-core-per-subsystem-multithreaded-probing.patch
powerpc-make-it-compile.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-powerpc.patch
dynamic-kernel-command-line-ppc.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
