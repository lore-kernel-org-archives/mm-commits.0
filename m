From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-quirksc-hpet-clock-enable-on-nvidia-nforce-430.patch added to -mm tree
Date: Thu, 20 Mar 2008 14:58:05 -0700
Message-ID: <200803202158.m2KLw6T0026126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757014AbYCTV6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 17:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbiggy@o2.pl, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/kernel/quirks.c: hpet clock enable on nVidia nForce 430
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-quirksc-hpet-clock-enable-on-nvidia-nforce-430.patch

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

arch-x86-kernel-quirksc-hpet-clock-enable-on-nvidia-nforce-430.patch

