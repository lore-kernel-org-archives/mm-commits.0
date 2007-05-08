From: akpm@linux-foundation.org
Subject: - xtensa-strlcpy-is-smart-enough.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:50 -0700
Message-ID: <200705080007.l4807ovp009323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967391AbXEHAI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: strlcpy is smart enough
has been removed from the -mm tree.  Its filename was
     xtensa-strlcpy-is-smart-enough.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xtensa: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platform-iss/network.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/platform-iss/network.c~xtensa-strlcpy-is-smart-enough arch/xtensa/platform-iss/network.c
--- a/arch/xtensa/platform-iss/network.c~xtensa-strlcpy-is-smart-enough
+++ a/arch/xtensa/platform-iss/network.c
@@ -251,7 +251,7 @@ static int tuntap_open(struct iss_net_pr
 
 	memset(&ifr, 0, sizeof ifr);
 	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
-	strlcpy(ifr.ifr_name, dev_name, sizeof ifr.ifr_name - 1);
+	strlcpy(ifr.ifr_name, dev_name, sizeof ifr.ifr_name);
 
 	if ((err = simc_ioctl(fd, TUNSETIFF, (void*) &ifr)) < 0) {
 		printk("Failed to set interface, returned %d "
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-alsa.patch
scx200-use-mutex-instead-of-semaphore.patch
git-r8169.patch
x86-msr-add-support-for-safe-variants.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix-names.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
clean-up-mutex_trylock-noise.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
