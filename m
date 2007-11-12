From: akpm@linux-foundation.org
Subject: + char-rocket-switch-long-delay-to-sleep.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:51:06 -0800
Message-ID: <200711122151.lACLp65J010592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325AbXKLVvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:51:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: rocket, switch long delay to sleep
has been added to the -mm tree.  Its filename is
     char-rocket-switch-long-delay-to-sleep.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
