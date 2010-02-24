From: akpm@linux-foundation.org
Subject: [merged] x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:39:48 -0800
Message-ID: <201002241939.o1OJdmMC016320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356Ab0BXTmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:42:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, holt@sgi.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 UV: update UV arch to target Legacy VGA I/O correctly.
has been removed from the -mm tree.  Its filename was
     x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64 UV: update UV arch to target Legacy VGA I/O correctly.
From: Mike Travis <travis@sgi.com>

Add function to direct Legacy VGA I/O traffic to correct I/O Hub.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/bios.h     |    4 ++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   30 +++++++++++++++++++++++++++
 arch/x86/kernel/bios_uv.c          |   19 +++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/uv/bios.h~x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly arch/x86/include/asm/uv/bios.h
--- a/arch/x86/include/asm/uv/bios.h~x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly
+++ a/arch/x86/include/asm/uv/bios.h
@@ -36,7 +36,8 @@ enum uv_bios_cmd {
 	UV_BIOS_WATCHLIST_ALLOC,
 	UV_BIOS_WATCHLIST_FREE,
 	UV_BIOS_MEMPROTECT,
-	UV_BIOS_GET_PARTITION_ADDR
+	UV_BIOS_GET_PARTITION_ADDR,
+	UV_BIOS_SET_LEGACY_VGA_TARGET
 };
 
 /*
@@ -96,6 +97,7 @@ extern int uv_bios_mq_watchlist_alloc(un
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
+extern int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus);
 
 extern void uv_bios_init(void);
 
diff -puN arch/x86/kernel/apic/x2apic_uv_x.c~x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c~x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly
+++ a/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -20,6 +20,7 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/pci.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -34,6 +35,8 @@
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
+#define PR_DEVEL(fmt, args...)	pr_devel("%s: " fmt, __func__, args)
+
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
 int uv_min_hub_revision_id;
@@ -552,6 +555,30 @@ late_initcall(uv_init_heartbeat);
 
 #endif /* !CONFIG_HOTPLUG_CPU */
 
+/* Direct Legacy VGA I/O traffic to designated IOH */
+int uv_set_vga_state(struct pci_dev *pdev, bool decode,
+		      unsigned int command_bits, bool change_bridge)
+{
+	int domain, bus, rc;
+
+	PR_DEVEL("devfn %x decode %d cmd %x chg_brdg %d\n",
+			pdev->devfn, decode, command_bits, change_bridge);
+
+	if (!change_bridge)
+		return 0;
+
+	if ((command_bits & PCI_COMMAND_IO) == 0)
+		return 0;
+
+	domain = pci_domain_nr(pdev->bus);
+	bus = pdev->bus->number;
+
+	rc = uv_bios_set_legacy_vga_target(decode, domain, bus);
+	PR_DEVEL("vga decode %d %x:%x, rc: %d\n", decode, domain, bus, rc);
+
+	return rc;
+}
+
 /*
  * Called on each cpu to initialize the per_cpu UV data area.
  * FIXME: hotplug not supported yet
@@ -690,4 +717,7 @@ void __init uv_system_init(void)
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
 	proc_mkdir("sgi_uv", NULL);
+
+	/* register Legacy VGA I/O redirection handler */
+	pci_register_set_vga_state(uv_set_vga_state);
 }
diff -puN arch/x86/kernel/bios_uv.c~x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly arch/x86/kernel/bios_uv.c
--- a/arch/x86/kernel/bios_uv.c~x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly
+++ a/arch/x86/kernel/bios_uv.c
@@ -163,6 +163,25 @@ s64 uv_bios_freq_base(u64 clock_type, u6
 }
 EXPORT_SYMBOL_GPL(uv_bios_freq_base);
 
+/*
+ * uv_bios_set_legacy_vga_target - Set Legacy VGA I/O Target
+ * @decode: true to enable target, false to disable target
+ * @domain: PCI domain number
+ * @bus: PCI bus number
+ *
+ * Returns:
+ *    0: Success
+ *    -EINVAL: Invalid domain or bus number
+ *    -ENOSYS: Capability not available
+ *    -EBUSY: Legacy VGA I/O cannot be retargeted at this time
+ */
+int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus)
+{
+	return uv_bios_call(UV_BIOS_SET_LEGACY_VGA_TARGET,
+				(u64)decode, (u64)domain, (u64)bus, 0, 0);
+}
+EXPORT_SYMBOL_GPL(uv_bios_set_legacy_vga_target);
+
 
 #ifdef CONFIG_EFI
 void uv_bios_init(void)
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch

