From: akpm@linux-foundation.org
Subject: - x86-add-another-pci-id-for-ich6-force-hpet.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:55 -0700
Message-ID: <200806081949.m58JntJG017719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbYFHTux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ole@ans.pl, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: add another PCI ID for ICH6 force hpet
has been removed from the -mm tree.  Its filename was
     x86-add-another-pci-id-for-ich6-force-hpet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: add another PCI ID for ICH6 force hpet
From: Krzysztof Piotr Oledzki <ole@ans.pl>

Tested on Asus P5GDC-V

$ lspci -n -n |grep ISA
00:1f.0 ISA bridge [0601]: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC Interface Bridge [8086:2640] (rev 03)

Force enabled HPET at base address 0xfed00000
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/quirks.c~x86-add-another-pci-id-for-ich6-force-hpet arch/x86/kernel/quirks.c
--- a/arch/x86/kernel/quirks.c~x86-add-another-pci-id-for-ich6-force-hpet
+++ a/arch/x86/kernel/quirks.c
@@ -159,6 +159,8 @@ static void ich_force_enable_hpet(struct
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
 			 ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,
+			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0,
_

Patches currently in -mm which might be from ole@ans.pl are

linux-next.patch

