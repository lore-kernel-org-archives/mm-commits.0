From: akpm@linux-foundation.org
Subject: [merged] mmc-during-unsafe-resume-select-the-right-volatge-for-the-card.patch removed from -mm tree
Date: Tue, 10 Mar 2009 11:26:49 -0700
Message-ID: <200903101826.n2AIQnhb022679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbZCJS3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 14:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@openmoko.org, andy@openmoko.com, drzeus-mmc@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: during unsafe resume, select the right volatge for the card
has been removed from the -mm tree.  Its filename was
     mmc-during-unsafe-resume-select-the-right-volatge-for-the-card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch

