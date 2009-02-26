From: akpm@linux-foundation.org
Subject: + mmc-during-unsafe-resume-select-the-right-volatge-for-the-card.patch added to -mm tree
Date: Thu, 26 Feb 2009 13:45:21 -0800
Message-ID: <200902262145.n1QLjLA9025350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758007AbZBZVqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 16:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@openmoko.org, andy@openmoko.com, drzeus-mmc@drzeus.cx


The patch titled
     mmc: during unsafe resume, select the right volatge for the card
has been added to the -mm tree.  Its filename is
     mmc-during-unsafe-resume-select-the-right-volatge-for-the-card.patch

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
Subject: mmc: during unsafe resume, select the right volatge for the card
From: Balaji Rao <balajirrao@openmoko.org>

During mmc unsafe resume, choose the right voltage for the card after
powerup.

Although this has not seen to cause trouble, it's the wrong behaviour.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/core/core.c~mmc-during-unsafe-resume-select-the-right-volatge-for-the-card drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-during-unsafe-resume-select-the-right-volatge-for-the-card
+++ a/drivers/mmc/core/core.c
@@ -877,6 +877,7 @@ int mmc_resume_host(struct mmc_host *hos
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
 		mmc_power_up(host);
+		mmc_select_voltage(host, host->ocr);
 		BUG_ON(!host->bus_ops->resume);
 		host->bus_ops->resume(host);
 	}
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

linux-next.patch
mmc-during-unsafe-resume-select-the-right-volatge-for-the-card.patch
mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch

