From: akpm@linux-foundation.org
Subject: + power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:56:24 -0700
Message-ID: <200804302156.m3ULuOEj005364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760256AbYD3V4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, cbou@mail.ru, dilinger@debian.org, dwmw2@infradead.org


The patch titled
     power_supply: bump EC version check that we refuse to run with in olpc_battery
has been added to the -mm tree.  Its filename is
     power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

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
Subject: power_supply: bump EC version check that we refuse to run with in olpc_battery
From: Andres Salomon <dilinger@queued.net>

Refuse to run with an EC < 0x44.  We're playing it safe, and this is a pretty
old EC version.

Also, add a comment about why we're checking the EC version.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/power/olpc_battery.c~power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery
+++ a/drivers/power/olpc_battery.c
@@ -398,7 +398,12 @@ static int __init olpc_bat_init(void)
 
 	if (!olpc_platform_info.ecver)
 		return -ENXIO;
-	if (olpc_platform_info.ecver < 0x43) {
+
+	/*
+	 * We've seen a number of EC protocol changes; this driver requires
+	 * the latest EC protocol, supported by 0x44 and above.
+	 */
+	if (olpc_platform_info.ecver < 0x44) {
 		printk(KERN_NOTICE "OLPC EC version 0x%02x too old for battery driver.\n", olpc_platform_info.ecver);
 		return -ENXIO;
 	}
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
x86-ioremap-ram-check-fix.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs.patch
power_supply-cleanup-of-the-olpc-battery-driver.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

