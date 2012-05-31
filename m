From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:27 -0700
Message-ID: <20120531191927.5E3A9A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58177 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2EaTT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:28 -0400
Received: by vcbfl13 with SMTP id fl13so135276vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, Milo.Kim@ti.com, bryan.wu@canonical.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling

Gcc 4.6.2 complains that:
drivers/leds/leds-lp5521.c: In function `lp5521_load_program':
drivers/leds/leds-lp5521.c:214:21: warning: `mode' may be used uninitialized in this function [-Wuninitialized]
drivers/leds/leds-lp5521.c: In function `lp5521_probe':
drivers/leds/leds-lp5521.c:788:5: warning: `buf' may be used uninitialized in this function [-Wuninitialized]
drivers/leds/leds-lp5521.c:740:6: warning: `ret' may be used uninitialized in this function [-Wuninitialized]

These are real problems if lp5521_read() returns an error.  When that
happens we should handle it, instead of ignoring it or doing a bitwise OR
with all the other error codes and continuing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Milo <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling
+++ a/drivers/leds/leds-lp5521.c
@@ -193,9 +193,14 @@ static int lp5521_load_program(struct lp
 
 	/* move current engine to direct mode and remember the state */
 	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
+	if (ret)
+		return ret;
+
 	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
 	usleep_range(1000, 2000);
-	ret |= lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	ret = lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	if (ret)
+		return ret;
 
 	/* For loading, all the engines to load mode */
 	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
@@ -211,8 +216,7 @@ static int lp5521_load_program(struct lp
 				LP5521_PROG_MEM_SIZE,
 				pattern);
 
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, mode);
-	return ret;
+	return lp5521_write(client, LP5521_REG_OP_MODE, mode);
 }
 
 static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
@@ -785,7 +789,7 @@ static int __devinit lp5521_probe(struct
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
 	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+	if (ret || buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
fsnotify-remove-unused-parameter-from-send_to_group.patch
hpfs-remove-printk-macro.patch

