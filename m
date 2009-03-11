From: akpm@linux-foundation.org
Subject: + regulator-dont-warn-on-omitted-voltage-constraints.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:36:57 -0700
Message-ID: <200903112036.n2BKawf7001271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbZCKUsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk


The patch titled
     regulator: don't warn on omitted voltage constraints
has been added to the -mm tree.  Its filename is
     regulator-dont-warn-on-omitted-voltage-constraints.patch

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
Subject: regulator: don't warn on omitted voltage constraints
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Specifying voltage constraints is optional (and only needed if the
consumer is allowed to change the voltage) so don't complain unless a
voltage has been specified.

Also avoid surprises with a dangling else while we're here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/regulator/core.c~regulator-dont-warn-on-omitted-voltage-constraints drivers/regulator/core.c
--- a/drivers/regulator/core.c~regulator-dont-warn-on-omitted-voltage-constraints
+++ a/drivers/regulator/core.c
@@ -709,8 +709,12 @@ static int set_machine_constraints(struc
 			cmax = INT_MAX;
 		}
 
+		/* voltage constraints are optional */
+		if ((cmin == 0) && (cmax == 0))
+			goto out;
+
 		/* else require explicit machine-level constraints */
-		else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
+		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
 			pr_err("%s: %s '%s' voltage constraints\n",
 				       __func__, "invalid", name);
 			ret = -EINVAL;
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
regulator-implement-list_voltage-for-wm8400-dcdcs-and-ldos.patch
regulator-dont-warn-on-omitted-voltage-constraints.patch
mfd-add-support-for-wm8351-revision-b.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

