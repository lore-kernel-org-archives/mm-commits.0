From: akpm@linux-foundation.org
Subject: [merged] regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch removed from -mm tree
Date: Wed, 05 Jan 2011 11:28:25 -0800
Message-ID: <201101051930.p05JU06F014061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab1AETaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 14:30:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, mm-commits@vger.kernel.org


The patch titled
     regulator: missing index in PTR_ERR() in isl6271a_probe()
has been removed from the -mm tree.  Its filename was
     regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: missing index in PTR_ERR() in isl6271a_probe()
From: roel kluin <roel.kluin@gmail.com>

The index is missing so the return is wrong.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/isl6271a-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/regulator/isl6271a-regulator.c~regulator-missing-index-in-ptr_err-in-isl6271a_probe drivers/regulator/isl6271a-regulator.c
--- a/drivers/regulator/isl6271a-regulator.c~regulator-missing-index-in-ptr_err-in-isl6271a_probe
+++ a/drivers/regulator/isl6271a-regulator.c
@@ -173,7 +173,7 @@ static int __devinit isl6271a_probe(stru
 						init_data, pmic);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&i2c->dev, "failed to register %s\n", id->name);
-			err = PTR_ERR(pmic->rdev);
+			err = PTR_ERR(pmic->rdev[i]);
 			goto error;
 		}
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
macintosh-wrong-test-in-fan_readwrite_reg.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

