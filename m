From: akpm@linux-foundation.org
Subject: + s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin.patch added to -mm tree
Date: Tue, 02 Mar 2010 12:37:43 -0800
Message-ID: <201003022037.o22Kbhb5028235__30463.100228417$1267562323$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab0CBUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 15:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, ben-linux@fluff.org, linux-mmc@vger.kernel.org, stable@kernel.org


The patch titled
     s3cmci: s3cmci_card_present: Use no_detect to decide whether there is a card detect pin
has been added to the -mm tree.  Its filename is
     s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin.patch

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

linux-next.patch
s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1.patch
s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin.patch

