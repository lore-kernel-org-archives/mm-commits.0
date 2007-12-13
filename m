From: akpm@linux-foundation.org
Subject: - apanel-detach-on-shutdown.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:59:34 -0800
Message-ID: <200712132359.lBDNxY68025325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934675AbXLMX7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     apanel: detach on shutdown
has been removed from the -mm tree.  Its filename was
     apanel-detach-on-shutdown.patch

This patch was dropped because it was folded into fujitsu-application-panel-driver.patch

------------------------------------------------------
Subject: apanel: detach on shutdown
From: Stephen Hemminger <shemminger@linux-foundation.org>

Need to stop any device polling on shutdown.  Without this, the laptop can
sometimes not turn off.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/apanel.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/input/misc/apanel.c~apanel-detach-on-shutdown drivers/input/misc/apanel.c
--- a/drivers/input/misc/apanel.c~apanel-detach-on-shutdown
+++ a/drivers/input/misc/apanel.c
@@ -193,12 +193,18 @@ static int apanel_attach_adapter(struct 
 	return i2c_probe(adap, &addr_data, apanel_probe);
 }
 
+static void apanel_shutdown(struct i2c_client *client)
+{
+	apanel_detach_client(client);
+}
+
 static struct i2c_driver apanel_driver = {
 	.driver = {
 		.name = APANEL,
 	},
 	.attach_adapter = &apanel_attach_adapter,
 	.detach_client  = &apanel_detach_client,
+	.shutdown	= &apanel_shutdown,
 };
 
 static struct apanel apanel = {
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-input.patch
fujitsu-application-panel-driver.patch
apanel-detach-on-shutdown.patch
apanel-use-generic-keycode-routines.patch
fujitsu-application-panel-led-value.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
bonding-locking-fix.patch
bridge-assign-random-address.patch
