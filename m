From: akpm@linux-foundation.org
Subject: + x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch added to -mm tree
Date: Wed, 12 Sep 2007 15:42:39 -0700
Message-ID: <200709122242.l8CMgdn1022886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbXILWmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 18:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM


The patch titled
     x86_64: check and enable MMCONFIG for AMD Family 10h Opteron
has been added to the -mm tree.  Its filename is
     x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: check and enable MMCONFIG for AMD Family 10h Opteron
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/setup.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+)

diff -puN arch/x86_64/kernel/setup.c~x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron
+++ a/arch/x86_64/kernel/setup.c
@@ -491,6 +491,32 @@ static int nearby_node(int apicid)
 }
 #endif
 
+/*[39:8] */
+/* why not using 0xfe000000 ? */
+#define FAM10H_PCI_MMIO_BASE 0xc0000000
+static void fam10h_check_enable_mmcfg(struct cpuinfo_x86 *c)
+{
+	u32 low, high, address;
+
+	address = 0xc0010058;
+	if (rdmsr_safe(address, &low, &high))
+		return;
+
+	if (low & 1)
+		return;
+
+	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
+	/*
+	 * if it is not enable, let enable it and assume only one segement
+	 * with 256 buses
+	 */
+	low &= ~(0xfff00000 | (0xf<<2));
+	low |= (8<<2) | (1<<0);
+	high &= ~(0x0000ffff);
+	high |= (FAM10H_PCI_MMIO_BASE>>(32-8));
+	wrmsr_safe(address, low, high);
+}
+
 /*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
@@ -645,6 +671,9 @@ static void __cpuinit init_amd(struct cp
 	    (flags & 0x18))
 		set_bit(X86_FEATURE_VIRT_DISABLED, &c->x86_capability);
 
+	if (c->x86 == 0x10)
+		fam10h_check_enable_mmcfg(c);
+
 	if (ler_enabled && c->x86 <= 17)
 		__get_cpu_var(ler_msr) = MSR_IA32_LASTINTFROMIP;
 }
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
serial-keep-the-dtr-setting-for-serial-console.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
