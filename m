From: akpm@linux-foundation.org
Subject: + x86-only-scan-the-root-bus-in-early-pci-quirks.patch added to -mm tree
Date: Mon, 05 Jan 2009 16:00:09 -0800
Message-ID: <200901060000.n0600Abw003960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbZAFAAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 19:00:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org


The patch titled
     x86: only scan the root bus in early PCI quirks
has been added to the -mm tree.  Its filename is
     x86-only-scan-the-root-bus-in-early-pci-quirks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: only scan the root bus in early PCI quirks
From: Andi Kleen <andi@firstfloor.org>

We found a situation on Linus' machine that the Nvidia timer quirk hit on
a Intel chipset system.  The problem is that the system has a fancy Nvidia
card with an own PCI bridge, and the early-quirks code looking for any
NVidia bridge triggered on it incorrectly.  This didn't lead a boot
failure by luck, but the timer routing code selecting the wrong timer
first and some ugly messages.  It might lead to real problems on other
systems.

I checked all the devices which are currently checked for by early_quirks
and it turns out they are all located in the root bus zero.

So change the early-quirks loop to only scan bus 0.  This incidently also
saves quite some unnecessary scanning work, because early_quirks doesn't
go through all the non root busses.

The graphics card is not on bus 0, so it is not matched anymore.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/early-quirks.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN arch/x86/kernel/early-quirks.c~x86-only-scan-the-root-bus-in-early-pci-quirks arch/x86/kernel/early-quirks.c
--- a/arch/x86/kernel/early-quirks.c~x86-only-scan-the-root-bus-in-early-pci-quirks
+++ a/arch/x86/kernel/early-quirks.c
@@ -201,6 +201,12 @@ struct chipset {
 	void (*f)(int num, int slot, int func);
 };
 
+/*
+ * Only works for devices on the root bus. If you add any devices
+ * not on bus 0 readd another loop level in early_quirks(). But
+ * be careful because at least the Nvidia quirk here relies on
+ * only matching on bus 0.
+ */
 static struct chipset early_qrk[] __initdata = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
@@ -267,17 +273,17 @@ static int __init check_dev_quirk(int nu
 
 void __init early_quirks(void)
 {
-	int num, slot, func;
+	int slot, func;
 
 	if (!early_pci_allowed())
 		return;
 
 	/* Poor man's PCI discovery */
-	for (num = 0; num < 32; num++)
-		for (slot = 0; slot < 32; slot++)
-			for (func = 0; func < 8; func++) {
-				/* Only probe function 0 on single fn devices */
-				if (check_dev_quirk(num, slot, func))
-					break;
-			}
+	/* Only scan the root bus */
+	for (slot = 0; slot < 32; slot++)
+		for (func = 0; func < 8; func++) {
+			/* Only probe function 0 on single fn devices */
+			if (check_dev_quirk(0, slot, func))
+				break;
+		}
 }
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
x86-only-scan-the-root-bus-in-early-pci-quirks.patch
remove-remaining-unwinder-code.patch
elf-implement-at_random-for-glibc-prng-seeding.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
allow-hpet-force-enable-on-ich10-hpet.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
avoid-theoretical-vmalloc-fault-loop.patch

