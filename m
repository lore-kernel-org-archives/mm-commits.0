From: akpm@linux-foundation.org
Subject: - char-rocket-switch-long-delay-to-sleep.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:25 -0800
Message-ID: <200802080809.m188967S014797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371AbYBHIS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:18:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: rocket, switch long delay to sleep
has been removed from the -mm tree.  Its filename was
     char-rocket-switch-long-delay-to-sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: rocket, switch long delay to sleep
From: Jiri Slaby <jirislaby@gmail.com>

Don't busy wait for whole 1s when registering some rocket modems. Sleep
instead since we are not in atomic.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/rocket.c~char-rocket-switch-long-delay-to-sleep drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-switch-long-delay-to-sleep
+++ a/drivers/char/rocket.c
@@ -2191,10 +2191,10 @@ static __init int register_PCI(int i, st
 		num_chan = ports_per_aiop;
 		for (chan = 0; chan < num_chan; chan++)
 			sPCIModemReset(ctlp, chan, 1);
-		mdelay(500);
+		msleep(500);
 		for (chan = 0; chan < num_chan; chan++)
 			sPCIModemReset(ctlp, chan, 0);
-		mdelay(500);
+		msleep(500);
 		rmSpeakerReset(ctlp, rocketModel[i].model);
 	}
 	return (1);
@@ -2309,10 +2309,10 @@ static int __init init_ISA(int i)
 		total_num_chan = num_chan;
 		for (chan = 0; chan < num_chan; chan++)
 			sModemReset(ctlp, chan, 1);
-		mdelay(500);
+		msleep(500);
 		for (chan = 0; chan < num_chan; chan++)
 			sModemReset(ctlp, chan, 0);
-		mdelay(500);
+		msleep(500);
 		strcpy(rocketModel[i].modelString, "RocketModem ISA");
 	} else {
 		strcpy(rocketModel[i].modelString, "RocketPort ISA");
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
