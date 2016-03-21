From: akpm@linux-foundation.org
Subject: [merged] ata-hpt366-convert-to-use-match_string-helper.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:16 -0700
Message-ID: <56f04088.spG5EBc6hXzUOGR1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbcCUTVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, b.zolnierkie@samsung.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ata: hpt366: convert to use match_string() helper
has been removed from the -mm tree.  Its filename was
     ata-hpt366-convert-to-use-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: ata: hpt366: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt366.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/ata/pata_hpt366.c~ata-hpt366-convert-to-use-match_string-helper drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~ata-hpt366-convert-to-use-match_string-helper
+++ a/drivers/ata/pata_hpt366.c
@@ -176,17 +176,14 @@ static int hpt_dma_blacklisted(const str
 			       const char * const list[])
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
-	int i = 0;
+	int i;
 
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
-	while (list[i] != NULL) {
-		if (!strcmp(list[i], model_num)) {
-			pr_warn("%s is not supported for %s\n",
-				modestr, list[i]);
-			return 1;
-		}
-		i++;
+	i = match_string(list, -1, model_num);
+	if (i >= 0) {
+		pr_warn("%s is not supported for %s\n", modestr, list[i]);
+		return 1;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


