From: akpm@linux-foundation.org
Subject: - x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:47:53 -0700
Message-ID: <200710190347.l9J3lriY013419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756614AbXJSDzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_64: check and enable MMCONFIG for AMD Family 10h Opteron
has been removed from the -mm tree.  Its filename was
     x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: check and enable MMCONFIG for AMD Family 10h Opteron
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

[akpm@linux-foundation.org: section fix]
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_64.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN arch/x86/kernel/setup_64.c~x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron
+++ a/arch/x86/kernel/setup_64.c
@@ -486,6 +486,32 @@ static int nearby_node(int apicid)
 }
 #endif
 
+/*[39:8] */
+/* why not using 0xfe000000 ? */
+#define FAM10H_PCI_MMIO_BASE 0xc0000000
+static void __cpuinit fam10h_check_enable_mmcfg(struct cpuinfo_x86 *c)
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
+	 * If it is not enabled, enable it and assume only one segment
+	 * with 256 busses.
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
@@ -673,6 +699,9 @@ static void __cpuinit init_amd(struct cp
 	    !rdmsr_safe(MSR_VM_CR, &flags, &dummy) &&
 	    (flags & 0x18))
 		set_bit(X86_FEATURE_VIRT_DISABLED, &c->x86_capability);
+
+	if (c->x86 == 0x10)
+		fam10h_check_enable_mmcfg(c);
 }
 
 static int enable_svm_lock(char *s)
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
git-kbuild.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
kernel-printkc-concerns-about-the-console-handover.patch
