From: akpm@linux-foundation.org
Subject: - frv-enable-the-mb86943-pci-arbiter-correctly.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:52:47 -0700
Message-ID: <200708060752.l767qlSl016263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43022 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbXHFHxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: Enable the MB86943 PCI arbiter correctly
has been removed from the -mm tree.  Its filename was
     frv-enable-the-mb86943-pci-arbiter-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: Enable the MB86943 PCI arbiter correctly
From: David Howells <dhowells@redhat.com>

Enable the MB93090 motherboard's MB86943 PCI arbiter correctly by assigning
to the register rather than comparing against it.  This is required to
support bus mastering.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mb93090-mb00/pci-vdk.c |    3 ++-
 include/asm-frv/mb86943a.h      |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/frv/mb93090-mb00/pci-vdk.c~frv-enable-the-mb86943-pci-arbiter-correctly arch/frv/mb93090-mb00/pci-vdk.c
--- a/arch/frv/mb93090-mb00/pci-vdk.c~frv-enable-the-mb86943-pci-arbiter-correctly
+++ a/arch/frv/mb93090-mb00/pci-vdk.c
@@ -400,7 +400,8 @@ int __init pcibios_init(void)
 	__reg_MB86943_pci_sl_mem_base	= __region_CS2 + 0x08000000;
 	mb();
 
-	*(volatile unsigned long *)(__region_CS2+0x01300014) == 1;
+	/* enable PCI arbitration */
+	__reg_MB86943_pci_arbiter	= MB86943_PCIARB_EN;
 
 	ioport_resource.start	= (__reg_MB86943_sl_pci_io_base << 9) & 0xfffffc00;
 	ioport_resource.end	= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
diff -puN include/asm-frv/mb86943a.h~frv-enable-the-mb86943-pci-arbiter-correctly include/asm-frv/mb86943a.h
--- a/include/asm-frv/mb86943a.h~frv-enable-the-mb86943-pci-arbiter-correctly
+++ a/include/asm-frv/mb86943a.h
@@ -36,4 +36,7 @@
 #define __reg_MB86943_pci_sl_io_base	*(volatile uint32_t *) (__region_CS1 + 0x70)
 #define __reg_MB86943_pci_sl_mem_base	*(volatile uint32_t *) (__region_CS1 + 0x78)
 
+#define __reg_MB86943_pci_arbiter	*(volatile uint32_t *) (__region_CS2 + 0x01300014)
+#define MB86943_PCIARB_EN		0x00000001
+
 #endif /* _ASM_MB86943A_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

frv-connect-up-fallocate.patch
changing-include-asm-generic-pgtableh-for-non-mmu.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
block-hide-the-contents-of-linux-bioh-if-config_block=n.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
fs-afs-possible-cleanups.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
mutex-subsystem-synchro-test-module.patch
