From: akpm@linux-foundation.org
Subject: [folded] gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:45:01 -0700
Message-ID: <200906172245.n5HMj1Dv005297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017AbZFQWpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:45:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, ncase@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups
has been removed from the -mm tree.  Its filename was
     gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch

This patch was dropped because it was folded into gpio-pca953x-get-platform_data-from-openfirmware.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups
From: Andrew Morton <akpm@linux-foundation.org>

kfree(NULL) is legal

Cc: Nate Case <ncase@xes-inc.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups
+++ a/drivers/gpio/pca953x.c
@@ -316,8 +316,7 @@ static int __devinit pca953x_probe(struc
 	return 0;
 
 out_failed:
-	if (chip->dyn_pdata != NULL)
-		kfree(chip->dyn_pdata);
+	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return ret;
 }
@@ -345,9 +344,7 @@ static int pca953x_remove(struct i2c_cli
 		return ret;
 	}
 
-	if (chip->dyn_pdata != NULL)
-		kfree(chip->dyn_pdata);
