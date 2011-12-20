From: akpm@linux-foundation.org
Subject: [folded] leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix.patch removed from -mm tree
Date: Tue, 20 Dec 2011 14:21:50 -0800
Message-ID: <20111220222151.40DF25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40253 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1LTWVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:21:53 -0500
Received: by eekc1 with SMTP id c1so220639eek.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:21:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix
has been removed from the -mm tree.  Its filename was
     leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix.patch

This patch was dropped because it was folded into leds-add-driver-for-tca6507-led-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix

Argh..

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-tca6507.c~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix
+++ a/drivers/leds/leds-tca6507.c
@@ -352,7 +352,7 @@ static int led_prepare(struct tca6507_le
 			return 0;
 		}
 
-		for (i = MASTER; i >= BANK0; i++) {
+		for (i = MASTER; i >= BANK0; i--) {
 			int d;
 			if (tca->bank[i].level == level ||
 			    tca->bank[i].level_use == 0) {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
leds-add-driver-for-tca6507-led-controller.patch
leds-tca6507-fix-off-by-one-error.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

