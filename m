From: akpm@linux-foundation.org
Subject: - fujitsu-application-panel-led-value.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:59:40 -0800
Message-ID: <200712132359.lBDNxe0t025332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934567AbXLMX7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:59:43 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lBDNxeCY021233
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2007 15:59:41 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Fujitsu application panel led value
has been removed from the -mm tree.  Its filename was
     fujitsu-application-panel-led-value.patch

This patch was dropped because it was folded into fujitsu-application-panel-driver.patch

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
fujitsu-application-panel-led-value.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
bonding-locking-fix.patch
bridge-assign-random-address.patch
