From: akpm@linux-foundation.org
Subject: + fujitsu-application-panel-led-value.patch added to -mm tree
Date: Wed, 12 Dec 2007 14:43:18 -0800
Message-ID: <200712122243.lBCMhIwl000936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbXLLWnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 17:43:50 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lBCMhIAf010800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2007 14:43:19 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     Fujitsu application panel led value
has been added to the -mm tree.  Its filename is
     fujitsu-application-panel-led-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fujitsu application panel led value
From: Stephen Hemminger <shemminger@linux-foundation.org>

Use proper encoding for LED values.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/apanel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/misc/apanel.c~fujitsu-application-panel-led-value drivers/input/misc/apanel.c
--- a/drivers/input/misc/apanel.c~fujitsu-application-panel-led-value
+++ a/drivers/input/misc/apanel.c
@@ -132,11 +132,11 @@ static void mail_led_set(struct led_clas
 			 enum led_brightness value)
 {
 	struct apanel *ap = container_of(led, struct apanel, mail_led);
-	if (value)
+
+	if (value != LED_OFF)
 		ap->led_bits |= 0x8000;
 	else
 		ap->led_bits &= ~0x8000;
-	ap->led_bits = value;
 	schedule_work(&ap->led_work);
 }
 
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-input.patch
fujitsu-application-panel-driver.patch
apanel-free-input-device-on-close.patch
apanel-change-name-of-led.patch
apanel-detach-on-shutdown.patch
apanel-use-generic-keycode-routines.patch
fujitsu-application-panel-led-value.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
bonding-locking-fix.patch
bridge-assign-random-address.patch
