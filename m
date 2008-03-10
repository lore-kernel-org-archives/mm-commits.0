From: akpm@linux-foundation.org
Subject: + adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:42:55 -0700
Message-ID: <200803102042.m2AKgtRv004577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbYCJUnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, benh@kernel.crashing.org, colin@colino.net, mhoffman@lightlink.com, segher@kernel.crashing.org


The patch titled
     ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
has been added to the -mm tree.  Its filename is
     adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch

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
Subject: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
From: Roel Kluin <12o3l@tiscali.nl>

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Acked-by: Colin Leroy <colin@colino.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7473.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/adt7473.c~adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit drivers/hwmon/adt7473.c
--- a/drivers/hwmon/adt7473.c~adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit
+++ a/drivers/hwmon/adt7473.c
@@ -570,7 +570,7 @@ static ssize_t set_max_duty_at_crit(stru
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
 	int temp = simple_strtol(buf, NULL, 10);
-	temp = temp && 0xFF;
+	temp &= 0xFF;
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = temp;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-alsa.patch
git-dvb.patch
drivers-media-video-tvp5150c-logical-bitwise-and-confusion.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch

