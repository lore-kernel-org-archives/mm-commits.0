From: akpm@linux-foundation.org
Subject: + regulator-dont-warn-if-we-failed-to-get-a-regulator.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:15:28 -0700
Message-ID: <200903122215.n2CMFSXQ010827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbZCLWQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com


The patch titled
     regulator: don't warn if we failed to get a regulator
has been added to the -mm tree.  Its filename is
     regulator-dont-warn-if-we-failed-to-get-a-regulator.patch

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
Subject: regulator: don't warn if we failed to get a regulator
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

The consumer can print a message if required, some consumers may have
optional regulators and wish to downgrade the logging for them or ignore
their absence.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/core.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/regulator/core.c~regulator-dont-warn-if-we-failed-to-get-a-regulator drivers/regulator/core.c
--- a/drivers/regulator/core.c~regulator-dont-warn-if-we-failed-to-get-a-regulator
+++ a/drivers/regulator/core.c
@@ -1031,8 +1031,6 @@ struct regulator *regulator_get(struct d
 			goto found;
 		}
 	}
-	printk(KERN_ERR "regulator: Unable to get requested regulator: %s\n",
-	       id);
 	mutex_unlock(&regulator_list_mutex);
 	return regulator;
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

mfd-add-support-for-wm8351-revision-b.patch
linux-next.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
regulator-dont-warn-if-we-failed-to-get-a-regulator.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

