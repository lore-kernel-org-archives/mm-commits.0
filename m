From: akpm@linux-foundation.org
Subject: + s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1.patch added to -mm tree
Date: Tue, 02 Mar 2010 12:37:39 -0800
Message-ID: <201003022037.o22KbefM028210__25137.3953339227$1267562324$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917Ab0CBUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 15:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, ben-linux@fluff.org, linux-mmc@vger.kernel.org, stable@kernel.org


The patch titled
     s3cmci: initialize default platform data no_wprotect and no_detect with 1
has been added to the -mm tree.  Its filename is
     s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1.patch

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
Subject: s3cmci: initialize default platform data no_wprotect and no_detect with 1
From: Lars-Peter Clausen <lars@metafoo.de>

If no platform_data was givin to the device it's going to use it's default
platform data struct which has all fields initialized to zero.  As a
result the driver is going to try to request gpio0 both as write protect
and card detect pin.  Which of course will fail and makes the driver
unusable

Previously to the introduction of no_wprotect and no_detect the behavior
was to assume that if no platform data was given there is no write protect
or card detect pin.  This patch restores that behavior.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1 drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1
+++ a/drivers/mmc/host/s3cmci.c
@@ -1360,6 +1360,8 @@ static struct mmc_host_ops s3cmci_ops = 
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
 	 * checks. Any zero fields to ensure reasonable defaults are picked. */
+	 .no_wprotect = 1,
+	 .no_detect = 1,
 };
 
 #ifdef CONFIG_CPU_FREQ
_

Patches currently in -mm which might be from lars@metafoo.de are

linux-next.patch
s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1.patch
s3cmci-s3cmci_card_present-use-no_detect-to-decide-whether-there-is-a-card-detect-pin.patch

