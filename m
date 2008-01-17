From: akpm@linux-foundation.org
Subject: - rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch removed from -mm tree
Date: Thu, 17 Jan 2008 11:05:27 -0800
Message-ID: <200801171905.m0HJ57rv007889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905AbYAQTFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 14:05:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byron.bbradley@gmail.com, david-b@pacbell.net, khali@linux-fr.org, tim@ngndg.com, mm-commits@vger.kernel.org


The patch titled
     rtc-add-support-for-the-s-35390a-rtc-chip-update2
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-add-support-for-the-s-35390a-rtc-chip-update2
From: Byron Bradley <byron.bbradley@gmail.com>

Print i2c address in hex and replace ENOCSI with EBUSY

Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Tim Ellis <tim@ngndg.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s35390a.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s35390a.c~rtc-add-support-for-the-s-35390a-rtc-chip-update2 drivers/rtc/rtc-s35390a.c
--- a/drivers/rtc/rtc-s35390a.c~rtc-add-support-for-the-s-35390a-rtc-chip-update2
+++ a/drivers/rtc/rtc-s35390a.c
@@ -222,9 +222,9 @@ static int s35390a_probe(struct i2c_clie
 		s35390a->client[i] = i2c_new_dummy(client->adapter,
 					client->addr + i, "rtc-s35390a");
 		if (!s35390a->client[i]) {
-			dev_err(&client->dev, "Address %d unavailable\n",
+			dev_err(&client->dev, "Address %02x unavailable\n",
 						client->addr + i);
-			err = -ENOCSI;
+			err = -EBUSY;
 			goto exit_dummy;
 		}
 	}
_

Patches currently in -mm which might be from byron.bbradley@gmail.com are

git-arm.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch
