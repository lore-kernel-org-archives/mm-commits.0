From: akpm@linux-foundation.org
Subject: + isl29003-fix-resume-functionality.patch added to -mm tree
Date: Tue, 05 May 2009 13:40:26 -0700
Message-ID: <200905052040.n45KeQAA021032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691AbZEEUng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, khali@linux-fr.org, rjw@sisk.pl


The patch titled
     isl29003: fix resume functionality
has been added to the -mm tree.  Its filename is
     isl29003-fix-resume-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isl29003: fix resume functionality
From: Daniel Mack <daniel@caiaq.de>

The isl29003 does not interpret the return value of
i2c_smbus_write_byte_data() correctly and hence causes an error on system
resume.

Also introduce power_state_before_suspend and restore the chip's power
state upon wakeup.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/isl29003.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/misc/isl29003.c~isl29003-fix-resume-functionality drivers/misc/isl29003.c
--- a/drivers/misc/isl29003.c~isl29003-fix-resume-functionality
+++ a/drivers/misc/isl29003.c
@@ -64,6 +64,7 @@ struct isl29003_data {
 	struct i2c_client *client;
 	struct mutex lock;
 	u8 reg_cache[ISL29003_NUM_CACHABLE_REGS];
+	u8 power_state_before_suspend;
 };
 
 static int gain_range[] = {
@@ -411,6 +412,9 @@ static int __devexit isl29003_remove(str
 #ifdef CONFIG_PM
 static int isl29003_suspend(struct i2c_client *client, pm_message_t mesg)
 {
+	struct isl29003_data *data = i2c_get_clientdata(client);
+
+	data->power_state_before_suspend = isl29003_get_power_state(client);
 	return isl29003_set_power_state(client, 0);
 }
 
@@ -421,10 +425,11 @@ static int isl29003_resume(struct i2c_cl
 
 	/* restore registers from cache */
 	for (i = 0; i < ARRAY_SIZE(data->reg_cache); i++)
-		if (!i2c_smbus_write_byte_data(client, i, data->reg_cache[i]))
+		if (i2c_smbus_write_byte_data(client, i, data->reg_cache[i]))
 			return -EIO;
 
-	return 0;
+	return isl29003_set_power_state(client,
+		data->power_state_before_suspend);
 }
 
 #else
_

Patches currently in -mm which might be from daniel@caiaq.de are

linux-next.patch
usb-imx_udc-fix-leak-in-imx_ep_alloc_request.patch
isl29003-fix-resume-functionality.patch

