From: akpm@linux-foundation.org
Subject: + rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:53:22 -0700
Message-ID: <200803242253.m2OMrNS5029481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbYCXWyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:54:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: rtc-rs5c372: fix up NULL name in transfer error path
has been added to the -mm tree.  Its filename is
     rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch

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
Subject: rtc: rtc-rs5c372: fix up NULL name in transfer error path
From: Paul Mundt <lethal@linux-sh.org>

rs5c_get_regs() currently uses rs5c->rtc->name for its debug printk when
i2c_transfer() fails, though it is used several times before the rtc dev
has been registered. The earliest we can get at the symbolic name is via
the i2c client's struct device, which can be handled by moving the first
rs5c_get_regs() until after the client pointer is assigned.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -99,7 +99,7 @@ static int rs5c_get_regs(struct rs5c372 
 	 * least 80219 chips; this works around that bug.
 	 */
 	if ((i2c_transfer(client->adapter, msgs, 1)) != 1) {
-		pr_debug("%s: can't read registers\n", rs5c->rtc->name);
+		dev_warn(&client->dev, "can't read registers\n");
 		return -EIO;
 	}
 
@@ -512,12 +512,12 @@ static int rs5c372_probe(struct i2c_clie
 		goto exit;
 	}
 
-	/* we read registers 0x0f then 0x00-0x0f; skip the first one */
-	rs5c372->regs=&rs5c372->buf[1];
-
 	rs5c372->client = client;
 	i2c_set_clientdata(client, rs5c372);
 
+	/* we read registers 0x0f then 0x00-0x0f; skip the first one */
+	rs5c372->regs = &rs5c372->buf[1];
+
 	err = rs5c_get_regs(rs5c372);
 	if (err < 0)
 		goto exit_kfree;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
input-touchscreen-driver-for-the-superh-migor-board.patch
smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
git-s390.patch
git-sh.patch
smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
asm-futexh-should-include-linux-uaccessh.patch
remove-duplicated-unlikely-in-is_err.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch

