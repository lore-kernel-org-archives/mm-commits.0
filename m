From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch added to -mm tree
Date: Mon, 14 Jan 2008 15:21:51 -0800
Message-ID: <200801142321.m0ENLpas020508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbYANXWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jan 2008 18:22:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: byron.bbradley@gmail.com, david-b@pacbell.net, khali@linux-fr.org, tim@ngndg.com


The patch titled
     rtc-add-support-for-the-s-35390a-rtc-chip-update2
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch

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
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch
