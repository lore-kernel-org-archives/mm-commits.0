From: akpm@linux-foundation.org
Subject: - arch-x86-kernel-quirksc-hpet-clock-enable-on-nvidia-nforce-430.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:32 -0700
Message-ID: <200803212031.m2LKVWT6009079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761211AbYCUUcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zbiggy@o2.pl, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/quirks.c: hpet clock enable on nVidia nForce 430
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-quirksc-hpet-clock-enable-on-nvidia-nforce-430.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/quirks.c: hpet clock enable on nVidia nForce 430
From: Zbigniew Luszpinski <zbiggy@o2.pl>

Allow hpet=force on nVidia nForce 430 southbridge.

This patch was tested by me on my old Asus A8N-VM CSM (where bios does not
support hpet and does not advertise it via acpi entry).  My nForce430 version:

lspci -nn | grep LPC
00:0a.0 ISA bridge [0601]: nVidia Corporation MCP51 LPC Bridge [10de:0260]
(rev a2)

Kernel 2.6.24.3 after patching and using hpet=force reports this:
dmesg | grep -i hpet
Kernel command line: root=/dev/sda8 ro vga=773 video=vesafb:mtrr:4,ywrap
vt.default_utf8=0 hpet=force
Force enabled HPET at base address 0xfed00000
hpet clockevent registered
Time: hpet clocksource has been installed.

grep -i hpet /proc/timer_list
Clock Event Device: hpet
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode

grep Clock /proc/timer_list (before patching)
Clock Event Device: pit
Clock Event Device: lapic

grep Clock /proc/timer_list (after patching)
Clock Event Device: hpet
Clock Event Device: lapic

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/quirks.c~arch-x86-kernel-quirksc-hpet-clock-enable-on-nvidia-nforce-430 arch/x86/kernel/quirks.c
--- a/arch/x86/kernel/quirks.c~arch-x86-kernel-quirksc-hpet-clock-enable-on-nvidia-nforce-430
+++ a/arch/x86/kernel/quirks.c
@@ -363,6 +363,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_N
 			nvidia_force_enable_hpet);
 
 /* LPC bridges */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0260,
+			nvidia_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0360,
 			nvidia_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0361,
_

Patches currently in -mm which might be from zbiggy@o2.pl are

origin.patch

