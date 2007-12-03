From: akpm@linux-foundation.org
Subject: + apanel-detach-on-shutdown.patch added to -mm tree
Date: Mon, 03 Dec 2007 14:56:39 -0800
Message-ID: <200712032256.lB3MudEn021819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbXLCW4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 17:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz


The patch titled
     apanel: detach on shutdown
has been added to the -mm tree.  Its filename is
     apanel-detach-on-shutdown.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
apanel-free-input-device-on-close.patch
apanel-change-name-of-led.patch
apanel-detach-on-shutdown.patch
apanel-use-generic-keycode-routines.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
