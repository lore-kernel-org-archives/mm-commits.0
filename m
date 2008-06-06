From: akpm@linux-foundation.org
Subject: + x86-add-another-pci-id-for-ich6-force-hpet.patch added to -mm tree
Date: Fri, 06 Jun 2008 13:42:57 -0700
Message-ID: <200806062042.m56Kgwl9018421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763868AbYFFUoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 16:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ole@ans.pl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: add another PCI ID for ICH6 force hpet
has been added to the -mm tree.  Its filename is
     x86-add-another-pci-id-for-ich6-force-hpet.patch

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

x86-add-another-pci-id-for-ich6-force-hpet.patch

