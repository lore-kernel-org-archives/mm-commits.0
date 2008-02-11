From: akpm@linux-foundation.org
Subject: + parport-section-fixup.patch added to -mm tree
Date: Mon, 11 Feb 2008 14:58:56 -0800
Message-ID: <200802112258.m1BMwvVT005517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbYBKW7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     parport: section fixup
has been added to the -mm tree.  Its filename is
     parport-section-fixup.patch

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
Subject: parport: section fixup
From: David Brownell <david-b@pacbell.net>

Fix section warning for parport_ECP_supported(); it's called from a routine
exported to modules, so it can't be removed with __devinit section pruning.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/parport/parport_pc.c~parport-section-fixup drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport-section-fixup
+++ a/drivers/parport/parport_pc.c
@@ -1768,7 +1768,7 @@ static int parport_PS2_supported(struct 
 }
 
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb)
+static int parport_ECP_supported(struct parport *pb)
 {
 	int i;
 	int config, configb;
@@ -1992,7 +1992,7 @@ static int parport_ECPEPP_supported(stru
 /* Don't bother probing for modes we know we won't use. */
 static int __devinit parport_PS2_supported(struct parport *pb) { return 0; }
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb) { return 0; }
+static int parport_ECP_supported(struct parport *pb) { return 0; }
 #endif
 static int __devinit parport_EPP_supported(struct parport *pb) { return 0; }
 static int __devinit parport_ECPEPP_supported(struct parport *pb){return 0;}
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
parport-section-fixup.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-mmc.patch
usb-ehci-tolerates-some-buggy-devices.patch
rtc-cmos-display-hpet-emulation-mode.patch
