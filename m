From: akpm@osdl.org
Subject: + powerpc-fix-sys_pciconfig_iobase-bus-matching.patch added to -mm tree
Date: Sat, 27 Jan 2007 13:34:28 -0800
Message-ID: <200701272134.l0RLYSs9017083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbXA0Ved (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 16:34:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc: Fix sys_pciconfig_iobase bus matching
has been added to the -mm tree.  Its filename is
     powerpc-fix-sys_pciconfig_iobase-bus-matching.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
powerpc-fix-sys_pciconfig_iobase-bus-matching.patch
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
