From: akpm@linux-foundation.org
Subject: - rivafb-handle-i2c-bus-creation-failure.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:23 -0700
Message-ID: <200705090300.l4930NTZ010555@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032860AbXEIDAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rivafb: handle I2C bus creation failure
has been removed from the -mm tree.  Its filename was
     rivafb-handle-i2c-bus-creation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rivafb: handle I2C bus creation failure
From: Jean Delvare <khali@linux-fr.org>

I2C bus creation may fail, let rivafb handle that case properly.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/riva/fbdev.c~rivafb-handle-i2c-bus-creation-failure drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~rivafb-handle-i2c-bus-creation-failure
+++ a/drivers/video/riva/fbdev.c
@@ -1789,6 +1789,8 @@ static int __devinit riva_get_EDID_i2c(s
 	NVTRACE_ENTER();
 	riva_create_i2c_busses(par);
 	for (i = 0; i < par->bus; i++) {
+		if (!par->chan[i].par)
+			continue;
 		riva_probe_i2c_connector(par, i+1, &par->EDID);
 		if (par->EDID && !fb_parse_edid(par->EDID, &var)) {
 			printk(PFX "Found EDID Block from BUS %i\n", i);
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
applesmc-use-the-address-as-platform-device-id.patch
applesmc-use-standard-sysfs-names-for-labels.patch
git-alsa.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
