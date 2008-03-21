From: akpm@linux-foundation.org
Subject: - ibmpex-correct-power-use-multipliers-for-qs2x-blade.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:16 -0700
Message-ID: <200803212029.m2LKTGPv008853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755225AbYCUUew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     ibmpex: correct power use multipliers for QS2x blade
has been removed from the -mm tree.  Its filename was
     ibmpex-correct-power-use-multipliers-for-qs2x-blade.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmpex: correct power use multipliers for QS2x blade
From: "Darrick J. Wong" <djwong@us.ibm.com>

The QS2x blades ships with v2.54 of the firmware, which use the same
multiplier for all power meters.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmpex.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/ibmpex.c~ibmpex-correct-power-use-multipliers-for-qs2x-blade drivers/hwmon/ibmpex.c
--- a/drivers/hwmon/ibmpex.c~ibmpex-correct-power-use-multipliers-for-qs2x-blade
+++ a/drivers/hwmon/ibmpex.c
@@ -327,10 +327,14 @@ static int is_temp_sensor(const char *se
 	return 0;
 }
 
-static int power_sensor_multiplier(const char *sensor_id, int len)
+static int power_sensor_multiplier(struct ibmpex_bmc_data *data,
+				   const char *sensor_id, int len)
 {
 	int i;
 
+	if (data->sensor_major == 2)
+		return 1000000;
+
 	for (i = PEX_SENSOR_TYPE_LEN; i < len - 1; i++)
 		if (!memcmp(&sensor_id[i], watt_sensor_sig, PEX_MULT_LEN))
 			return 1000000;
@@ -398,8 +402,9 @@ static int ibmpex_find_sensors(struct ib
 			num_power++;
 			sensor_counter = num_power;
 			data->sensors[i].multiplier =
-				power_sensor_multiplier(data->rx_msg_data,
-						     data->rx_msg_len);
+				power_sensor_multiplier(data,
+							data->rx_msg_data,
+							data->rx_msg_len);
 		} else if (is_temp_sensor(data->rx_msg_data,
 					  data->rx_msg_len)) {
 			sensor_type = TEMP_SENSOR;
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
git-hwmon.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
scsi-aic94xx-cleanups.patch

