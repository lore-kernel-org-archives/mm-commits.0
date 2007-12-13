From: akpm@linux-foundation.org
Subject: - apanel-free-input-device-on-close.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:59:28 -0800
Message-ID: <200712132359.lBDNxSDT025318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934668AbXLMX7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:59:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     apanel: free input device on close
has been removed from the -mm tree.  Its filename was
     apanel-free-input-device-on-close.patch

This patch was dropped because it was folded into fujitsu-application-panel-driver.patch

------------------------------------------------------
Subject: apanel: free input device on close
From: Stephen Hemminger <shemminger@linux-foundation.org>

Fix memory leak.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/apanel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/misc/apanel.c~apanel-free-input-device-on-close drivers/input/misc/apanel.c
--- a/drivers/input/misc/apanel.c~apanel-free-input-device-on-close
+++ a/drivers/input/misc/apanel.c
@@ -176,6 +176,7 @@ static int apanel_detach_client(struct i
 
 	input_unregister_polled_device(ap->ipdev);
 	i2c_detach_client(&ap->client);
+	input_free_polled_device(ap->ipdev);
 
 	return 0;
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
