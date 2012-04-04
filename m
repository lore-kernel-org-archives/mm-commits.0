From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:06:47 -0700
Message-ID: <20120404220647.A59DFA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51859 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2DDWGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:06:49 -0400
Received: by qabg24 with SMTP id g24so102113qab.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:06:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, Milo.Kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/leds/leds-lp5521.c: fix lp5521_read() error handling

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fsnotify-remove-unused-parameter-from-send_to_group.patch
drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
hpfs-remove-printk-macro.patch

