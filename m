From: akpm@linux-foundation.org
Subject: [merged] s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:28 -0800
Message-ID: <201003091908.o29J8SJZ031444__29601.6713757583$1268162582$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0CITW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, ben-linux@fluff.org, linux-mmc@vger.kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     s3cmci: s3cmci_card_present: Use no_detect to decide whether there is a card detect pin
has been removed from the -mm tree.  Its filename was
     s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: s3cmci_card_present: Use no_detect to decide whether there is a card detect pin
From: Lars-Peter Clausen <lars@metafoo.de>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin
+++ a/drivers/mmc/host/s3cmci.c
@@ -1179,7 +1179,7 @@ static int s3cmci_card_present(struct mm
 	struct s3c24xx_mci_pdata *pdata = host->pdata;
 	int ret;
 
-	if (pdata->gpio_detect == 0)
+	if (pdata->no_detect)
 		return -ENOSYS;
 
 	ret = gpio_get_value(pdata->gpio_detect) ? 0 : 1;
_

Patches currently in -mm which might be from lars@metafoo.de are


