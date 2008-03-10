From: akpm@linux-foundation.org
Subject: + oz99x-i2c-button-and-led-support-driver-update.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:28:52 -0700
Message-ID: <200803102028.m2AKSqCe004013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbYCJUaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: post@hendrik-sattler.de, khali@linux-fr.org, rpurdie@rpsys.net


The patch titled
     OZ99x I2C button and led support driver update
has been added to the -mm tree.  Its filename is
     oz99x-i2c-button-and-led-support-driver-update.patch

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
Subject: OZ99x I2C button and led support driver update
From: Hendrik Sattler <post@hendrik-sattler.de>

> (akpm: now needs s/simple_strtol/strict_strtol/g)

Below does that change.

Signed-off-by: Hendrik Sattler <post@hendrik-sattler.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/oz99x.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/i2c/chips/oz99x.c~oz99x-i2c-button-and-led-support-driver-update drivers/i2c/chips/oz99x.c
--- a/drivers/i2c/chips/oz99x.c~oz99x-i2c-button-and-led-support-driver-update
+++ a/drivers/i2c/chips/oz99x.c
@@ -63,11 +63,12 @@ ssize_t reg_minmax_store(const char *buf
 			 size_t count,
 			 u8 *minmax)
 {
-	long val = simple_strtol(buf, NULL, 16);
+	unsigned long val;
+	int err = strict_strtoul(buf, 16, &val);
+	if (err)
+		return err;
 	if (val > 0xFF)
-		val = 0xFF;
-	else if (val < 0x00)
-		val = 0x00;
+		return -EINVAL;
 	*minmax = val & 0xFF;
 	return count;
 }
_

Patches currently in -mm which might be from post@hendrik-sattler.de are

oz99x-i2c-button-and-led-support-driver.patch
oz99x-i2c-button-and-led-support-driver-update.patch
fjkeyinf-driver-for-fsc-lifebook-laptops.patch

