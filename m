From: akpm@linux-foundation.org
Subject: + agp-fix-sis-5591-5592-wrong-pci-id.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:08:11 -0700
Message-ID: <200808120008.m7C08BxQ029386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbYHLAI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, airlied@linux.ie


The patch titled
     agp: fix SIS 5591/5592 wrong PCI id
has been added to the -mm tree.  Its filename is
     agp-fix-sis-5591-5592-wrong-pci-id.patch

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
Subject: agp: fix SIS 5591/5592 wrong PCI id
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The correct id for the AGP bridge is the id of
the main host (5591) not the id of the PCI-to-PCI
bridge AGP (0001). Output from "lspci -nv" shows
that only the former has AGP capabilities flag set:

00:00.0 0600: 1039:5591 (rev 02)
        Flags: bus master, medium devsel, latency 64
        Memory at ec000000 (32-bit, non-prefetchable) [size=32M]
        Capabilities: [c0] AGP version 1.0

00:02.0 0604: 1039:0001 (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: eb500000-eb5fffff
        Prefetchable memory behind bridge: eb300000-eb3fffff

The AGP bridge is correctly detected with the patch applied.
I have tested it on PC Chips M570 motherboard.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/sis-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/agp/sis-agp.c~agp-fix-sis-5591-5592-wrong-pci-id drivers/char/agp/sis-agp.c
--- a/drivers/char/agp/sis-agp.c~agp-fix-sis-5591-5592-wrong-pci-id
+++ a/drivers/char/agp/sis-agp.c
@@ -241,7 +241,7 @@ static struct pci_device_id agp_sis_pci_
 		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 		.class_mask	= ~0,
 		.vendor		= PCI_VENDOR_ID_SI,
-		.device		= PCI_DEVICE_ID_SI_5591_AGP,
+		.device		= PCI_DEVICE_ID_SI_5591,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 	},
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
sm501-update-debugging-low-information-messages.patch
matrox-maven-fix-a-broken-error-path.patch
matroxfb-i2c-structure-templates-clean-up.patch
matrox-maven-convert-to-a-new-style-i2c-driver.patch
atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91.patch
atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size.patch
fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch
linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
agp-fix-sis-5591-5592-wrong-pci-id.patch
x86-fdiv-bug-detection-fix.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch

