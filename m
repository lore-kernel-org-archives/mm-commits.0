From: akpm@linux-foundation.org
Subject: - adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch removed from -mm tree
Date: Mon, 05 May 2008 14:39:42 -0700
Message-ID: <200805052139.m45LdgML006424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020AbYEEVkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 17:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, benh@kernel.crashing.org, colin@colino.net, djwong@us.ibm.com, khali@linux-fr.org, mhoffman@lightlink.com, segher@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
has been removed from the -mm tree.  Its filename was
     adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
From: Roel Kluin <12o3l@tiscali.nl>

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Acked-by: Colin Leroy <colin@colino.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Acked-by: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7473.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/adt7473.c~adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit drivers/hwmon/adt7473.c
--- a/drivers/hwmon/adt7473.c~adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit
+++ a/drivers/hwmon/adt7473.c
@@ -565,11 +565,11 @@ static ssize_t set_max_duty_at_crit(stru
 				    const char *buf,
 				    size_t count)
 {
-	u8 reg;
+	u8 reg, temp;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
-	temp = temp && 0xFF;
+
+	temp = simple_strtol(buf, NULL, 10);
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = temp;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

linux-next.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
spi_mpc83xx-much-improved-driver.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

