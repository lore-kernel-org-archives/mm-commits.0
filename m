From: akpm@linux-foundation.org
Subject: [merged] regulator-dont-warn-if-we-failed-to-get-a-regulator.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:48:16 -0700
Message-ID: <200903182248.n2IMmGDw020316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbZCRWtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     regulator: don't warn if we failed to get a regulator
has been removed from the -mm tree.  Its filename was
     regulator-dont-warn-if-we-failed-to-get-a-regulator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

