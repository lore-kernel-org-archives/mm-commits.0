From: akpm@linux-foundation.org
Subject: + mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch added to -mm tree
Date: Tue, 17 Feb 2009 13:29:27 -0800
Message-ID: <200902172129.n1HLTRto019296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbZBQVaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 16:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@openmoko.org, andy@openmoko.com, drzeus-mmc@drzeus.cx


The patch titled
     mmc: in mmc_power_up(), use previously selected ocr if available
has been added to the -mm tree.  Its filename is
     mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch

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
Subject: mmc: in mmc_power_up(), use previously selected ocr if available
From: Balaji Rao <balajirrao@openmoko.org>

When mmc_power_up is called during unsafe resume, host->ocr should be used
instead of host->ocr_avail.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/core.c~mmc-in-mmc_power_up-use-previously-selected-ocr-if-available drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-in-mmc_power_up-use-previously-selected-ocr-if-available
+++ a/drivers/mmc/core/core.c
@@ -572,7 +572,13 @@ void mmc_set_timing(struct mmc_host *hos
  */
 static void mmc_power_up(struct mmc_host *host)
 {
-	int bit = fls(host->ocr_avail) - 1;
+	int bit;
+
+	/* If ocr is set, we use it */
+	if (host->ocr)
+		bit = ffs(host->ocr) - 1;
+	else
+		bit = fls(host->ocr_avail) - 1;
 
 	host->ios.vdd = bit;
 	if (mmc_host_is_spi(host)) {
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

mfd-pcf50633-terminate-i2c_device_id-list.patch
linux-next.patch
mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch

