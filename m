From: akpm@linux-foundation.org
Subject: - power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch removed from -mm tree
Date: Mon, 05 May 2008 12:17:01 -0700
Message-ID: <200805051917.m45JH1uT000351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbYEETRu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:17:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, cbou@mail.ru, dilinger@debian.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     power_supply: bump EC version check that we refuse to run with in olpc_battery
has been removed from the -mm tree.  Its filename was
     power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/power/olpc_battery.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/power/olpc_battery.c~power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery
+++ a/drivers/power/olpc_battery.c
@@ -398,8 +398,14 @@ static int __init olpc_bat_init(void)
 
 	if (!olpc_platform_info.ecver)
 		return -ENXIO;
-	if (olpc_platform_info.ecver < 0x43) {
-		printk(KERN_NOTICE "OLPC EC version 0x%02x too old for battery driver.\n", olpc_platform_info.ecver);
+
+	/*
+	 * We've seen a number of EC protocol changes; this driver requires
+	 * the latest EC protocol, supported by 0x44 and above.
+	 */
+	if (olpc_platform_info.ecver < 0x44) {
+		printk(KERN_NOTICE "OLPC EC version 0x%02x too old for "
+			"battery driver.\n", olpc_platform_info.ecver);
 		return -ENXIO;
 	}
 
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
git-battery.patch

