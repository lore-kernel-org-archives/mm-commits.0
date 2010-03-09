From: akpm@linux-foundation.org
Subject: [merged] s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:24 -0800
Message-ID: <201003091908.o29J8Oja031441__30566.580387722$1268162583$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756052Ab0CITWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, ben-linux@fluff.org, linux-mmc@vger.kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     s3cmci: initialize default platform data no_wprotect and no_detect with 1
has been removed from the -mm tree.  Its filename was
     s3cmci-initialize-default-platform-data-no_wprotect-and-no_detect-with-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


