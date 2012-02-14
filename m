From: akpm@linux-foundation.org
Subject: [merged] video-support-dp-controller-driver.patch removed from -mm tree
Date: Tue, 14 Feb 2012 12:21:09 -0800
Message-ID: <20120214202109.6424BA04FD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:63574 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab2BNUVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 15:21:10 -0500
Received: by mail-qy0-f202.google.com with SMTP id p5so44712qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 12:21:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, FlorianSchandinat@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: video: support DP controller driver
has been removed from the -mm tree.  Its filename was
     video-support-dp-controller-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: video: support DP controller driver

Samsung EXYNOS SoC such Exynos5 has DP controller and embedded DP panel
can be used.  This patch supports DP driver based on Samsung EXYNOS SoC
chip.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_dp_core.c | 1058 +++++++++++++++++++++
 drivers/video/exynos/exynos_dp_core.h |  206 ++++
 drivers/video/exynos/exynos_dp_reg.c  | 1173 ++++++++++++++++++++++++
 drivers/video/exynos/exynos_dp_reg.h  |  335 ++++++
 include/video/exynos_dp.h             |  131 ++
 5 files changed, 2903 insertions(+)

diff -puN drivers/video/exynos/Kconfig~video-support-dp-controller-driver drivers/video/exynos/Kconfig
diff -puN drivers/video/exynos/Makefile~video-support-dp-controller-driver drivers/video/exynos/Makefile
diff -puN /dev/null drivers/video/exynos/exynos_dp_core.c
--- /dev/null
+++ a/drivers/video/exynos/exynos_dp_core.c
@@ -0,0 +1,1058 @@
+/*
+ * Samsung SoC DP (Display Port) interface driver.
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+
+#include <video/exynos_dp.h>
+
+#include <plat/cpu.h>
+
+#include "exynos_dp_core.h"
+
+static int exynos_dp_init_dp(struct exynos_dp_device *dp)
+{
+	exynos_dp_reset(dp);
+
+	/* SW defined function Normal operation */
+	exynos_dp_enable_sw_function(dp);
+
+	exynos_dp_config_interrupt(dp);
+	exynos_dp_init_analog_func(dp);
+
+	exynos_dp_init_hpd(dp);
+	exynos_dp_init_aux(dp);
+
+	return 0;
+}
+
+static int exynos_dp_detect_hpd(struct exynos_dp_device *dp)
+{
+	int timeout_loop = 0;
+
+	exynos_dp_init_hpd(dp);
+
+	udelay(200);
+
+	while (exynos_dp_get_plug_in_status(dp) != 0) {
+		timeout_loop++;
+		if (DP_TIMEOUT_LOOP_COUNT < timeout_loop) {
+			dev_err(dp->dev, "failed to get hpd plug status\n");
+			return -ETIMEDOUT;
+		}
+		udelay(10);
+	}
+
+	return 0;
+}
+
+static unsigned char exynos_dp_calc_edid_check_sum(unsigned char *edid_data)
+{
+	int i;
+	unsigned char sum = 0;
+
+	for (i = 0; i < EDID_BLOCK_LENGTH; i++)
+		sum = sum + edid_data[i];
+
+	return sum;
+}
+
+static int exynos_dp_read_edid(struct exynos_dp_device *dp)
+{
+	unsigned char edid[EDID_BLOCK_LENGTH * 2];
+	unsigned int extend_block = 0;
+	unsigned char sum;
+	unsigned char test_vector;
+	int retval;
+
+	/*
+	 * EDID device address is 0x50.
+	 * However, if necessary, you must have set upper address
+	 * into E-EDID in I2C device, 0x30.
+	 */
+
+	/* Read Extension Flag, Number of 128-byte EDID extension blocks */
+	exynos_dp_read_byte_from_i2c(dp, I2C_EDID_DEVICE_ADDR,
+				EDID_EXTENSION_FLAG,
+				&extend_block);
+
+	if (extend_block > 0) {
+		dev_dbg(dp->dev, "EDID data includes a single extension!\n");
+
+		/* Read EDID data */
+		retval = exynos_dp_read_bytes_from_i2c(dp, I2C_EDID_DEVICE_ADDR,
+						EDID_HEADER_PATTERN,
+						EDID_BLOCK_LENGTH,
+						&edid[EDID_HEADER_PATTERN]);
+		if (retval != 0) {
+			dev_err(dp->dev, "EDID Read failed!\n");
+			return -EIO;
+		}
+		sum = exynos_dp_calc_edid_check_sum(edid);
+		if (sum != 0) {
+			dev_err(dp->dev, "EDID bad checksum!\n");
+			return -EIO;
+		}
+
+		/* Read additional EDID data */
+		retval = exynos_dp_read_bytes_from_i2c(dp,
+				I2C_EDID_DEVICE_ADDR,
+				EDID_BLOCK_LENGTH,
+				EDID_BLOCK_LENGTH,
+				&edid[EDID_BLOCK_LENGTH]);
+		if (retval != 0) {
+			dev_err(dp->dev, "EDID Read failed!\n");
+			return -EIO;
+		}
+		sum = exynos_dp_calc_edid_check_sum(&edid[EDID_BLOCK_LENGTH]);
+		if (sum != 0) {
+			dev_err(dp->dev, "EDID bad checksum!\n");
+			return -EIO;
+		}
+
+		exynos_dp_read_byte_from_dpcd(dp, DPCD_ADDR_TEST_REQUEST,
+					&test_vector);
+		if (test_vector & DPCD_TEST_EDID_READ) {
+			exynos_dp_write_byte_to_dpcd(dp,
+				DPCD_ADDR_TEST_EDID_CHECKSUM,
+				edid[EDID_BLOCK_LENGTH + EDID_CHECKSUM]);
+			exynos_dp_write_byte_to_dpcd(dp,
+				DPCD_ADDR_TEST_RESPONSE,
+				DPCD_TEST_EDID_CHECKSUM_WRITE);
+		}
+	} else {
+		dev_info(dp->dev, "EDID data does not include any extensions.\n");
+
+		/* Read EDID data */
+		retval = exynos_dp_read_bytes_from_i2c(dp,
+				I2C_EDID_DEVICE_ADDR,
+				EDID_HEADER_PATTERN,
+				EDID_BLOCK_LENGTH,
+				&edid[EDID_HEADER_PATTERN]);
+		if (retval != 0) {
+			dev_err(dp->dev, "EDID Read failed!\n");
+			return -EIO;
+		}
+		sum = exynos_dp_calc_edid_check_sum(edid);
+		if (sum != 0) {
+			dev_err(dp->dev, "EDID bad checksum!\n");
+			return -EIO;
+		}
+
+		exynos_dp_read_byte_from_dpcd(dp,
+			DPCD_ADDR_TEST_REQUEST,
+			&test_vector);
+		if (test_vector & DPCD_TEST_EDID_READ) {
+			exynos_dp_write_byte_to_dpcd(dp,
+				DPCD_ADDR_TEST_EDID_CHECKSUM,
+				edid[EDID_CHECKSUM]);
+			exynos_dp_write_byte_to_dpcd(dp,
+				DPCD_ADDR_TEST_RESPONSE,
+				DPCD_TEST_EDID_CHECKSUM_WRITE);
+		}
+	}
+
+	dev_err(dp->dev, "EDID Read success!\n");
+	return 0;
+}
+
+static int exynos_dp_handle_edid(struct exynos_dp_device *dp)
+{
+	u8 buf[12];
+	int i;
+	int retval;
+
+	/* Read DPCD DPCD_ADDR_DPCD_REV~RECEIVE_PORT1_CAP_1 */
+	exynos_dp_read_bytes_from_dpcd(dp,
+		DPCD_ADDR_DPCD_REV,
+		12, buf);
+
+	/* Read EDID */
+	for (i = 0; i < 3; i++) {
+		retval = exynos_dp_read_edid(dp);
+		if (retval == 0)
+			break;
+	}
+
+	return retval;
+}
+
+static void exynos_dp_enable_rx_to_enhanced_mode(struct exynos_dp_device *dp,
+						bool enable)
+{
+	u8 data;
+
+	exynos_dp_read_byte_from_dpcd(dp, DPCD_ADDR_LANE_COUNT_SET, &data);
+
+	if (enable)
+		exynos_dp_write_byte_to_dpcd(dp, DPCD_ADDR_LANE_COUNT_SET,
+			DPCD_ENHANCED_FRAME_EN |
+			DPCD_LANE_COUNT_SET(data));
+	else
+		exynos_dp_write_byte_to_dpcd(dp, DPCD_ADDR_LANE_COUNT_SET,
+			DPCD_LANE_COUNT_SET(data));
+}
+
+static int exynos_dp_is_enhanced_mode_available(struct exynos_dp_device *dp)
+{
+	u8 data;
+	int retval;
+
+	exynos_dp_read_byte_from_dpcd(dp, DPCD_ADDR_MAX_LANE_COUNT, &data);
+	retval = DPCD_ENHANCED_FRAME_CAP(data);
+
+	return retval;
+}
+
+static void exynos_dp_set_enhanced_mode(struct exynos_dp_device *dp)
+{
+	u8 data;
+
+	data = exynos_dp_is_enhanced_mode_available(dp);
+	exynos_dp_enable_rx_to_enhanced_mode(dp, data);
+	exynos_dp_enable_enhanced_mode(dp, data);
+}
+
+static void exynos_dp_training_pattern_dis(struct exynos_dp_device *dp)
+{
+	exynos_dp_set_training_pattern(dp, DP_NONE);
+
+	exynos_dp_write_byte_to_dpcd(dp,
+		DPCD_ADDR_TRAINING_PATTERN_SET,
+		DPCD_TRAINING_PATTERN_DISABLED);
+}
+
+static void exynos_dp_set_lane_lane_pre_emphasis(struct exynos_dp_device *dp,
+					int pre_emphasis, int lane)
+{
+	switch (lane) {
+	case 0:
+		exynos_dp_set_lane0_pre_emphasis(dp, pre_emphasis);
+		break;
+	case 1:
+		exynos_dp_set_lane1_pre_emphasis(dp, pre_emphasis);
+		break;
+
+	case 2:
+		exynos_dp_set_lane2_pre_emphasis(dp, pre_emphasis);
+		break;
+
+	case 3:
+		exynos_dp_set_lane3_pre_emphasis(dp, pre_emphasis);
+		break;
+	}
+}
+
+static void exynos_dp_link_start(struct exynos_dp_device *dp)
+{
+	u8 buf[5];
+	int lane;
+	int lane_count;
+
+	lane_count = dp->link_train.lane_count;
+
+	dp->link_train.lt_state = CLOCK_RECOVERY;
+	dp->link_train.eq_loop = 0;
+
+	for (lane = 0; lane < lane_count; lane++)
+		dp->link_train.cr_loop[lane] = 0;
+
+	/* Set sink to D0 (Sink Not Ready) mode. */
+	exynos_dp_write_byte_to_dpcd(dp, DPCD_ADDR_SINK_POWER_STATE,
+				DPCD_SET_POWER_STATE_D0);
+
+	/* Set link rate and count as you want to establish*/
+	exynos_dp_set_link_bandwidth(dp, dp->link_train.link_rate);
+	exynos_dp_set_lane_count(dp, dp->link_train.lane_count);
+
+	/* Setup RX configuration */
+	buf[0] = dp->link_train.link_rate;
+	buf[1] = dp->link_train.lane_count;
+	exynos_dp_write_bytes_to_dpcd(dp, DPCD_ADDR_LINK_BW_SET,
+				2, buf);
+
+	/* Set TX pre-emphasis to minimum */
+	for (lane = 0; lane < lane_count; lane++)
+		exynos_dp_set_lane_lane_pre_emphasis(dp,
+			PRE_EMPHASIS_LEVEL_0, lane);
+
+	/* Set training pattern 1 */
+	exynos_dp_set_training_pattern(dp, TRAINING_PTN1);
+
+	/* Set RX training pattern */
+	buf[0] = DPCD_SCRAMBLING_DISABLED |
+		 DPCD_TRAINING_PATTERN_1;
+	exynos_dp_write_byte_to_dpcd(dp,
+		DPCD_ADDR_TRAINING_PATTERN_SET, buf[0]);
+
+	for (lane = 0; lane < lane_count; lane++)
+		buf[lane] = DPCD_PRE_EMPHASIS_PATTERN2_LEVEL0 |
+			    DPCD_VOLTAGE_SWING_PATTERN1_LEVEL0;
+	exynos_dp_write_bytes_to_dpcd(dp,
+		DPCD_ADDR_TRAINING_PATTERN_SET,
+		lane_count, buf);
+}
+
+static unsigned char exynos_dp_get_lane_status(u8 link_status[6], int lane)
+{
+	int shift = (lane & 1) * 4;
+	u8 link_value = link_status[lane>>1];
+
+	return (link_value >> shift) & 0xf;
+}
+
+static int exynos_dp_clock_recovery_ok(u8 link_status[6], int lane_count)
+{
+	int lane;
+	u8 lane_status;
+
+	for (lane = 0; lane < lane_count; lane++) {
+		lane_status = exynos_dp_get_lane_status(link_status, lane);
+		if ((lane_status & DPCD_LANE_CR_DONE) == 0)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int exynos_dp_channel_eq_ok(u8 link_status[6], int lane_count)
+{
+	int lane;
+	u8 lane_align;
+	u8 lane_status;
+
+	lane_align = link_status[2];
+	if ((lane_align == DPCD_INTERLANE_ALIGN_DONE) == 0)
+		return -EINVAL;
+
+	for (lane = 0; lane < lane_count; lane++) {
+		lane_status = exynos_dp_get_lane_status(link_status, lane);
+		lane_status &= DPCD_CHANNEL_EQ_BITS;
+		if (lane_status != DPCD_CHANNEL_EQ_BITS)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static unsigned char exynos_dp_get_adjust_request_voltage(u8 adjust_request[2],
+							int lane)
+{
+	int shift = (lane & 1) * 4;
+	u8 link_value = adjust_request[lane>>1];
+
+	return (link_value >> shift) & 0x3;
+}
+
+static unsigned char exynos_dp_get_adjust_request_pre_emphasis(
+					u8 adjust_request[2],
+					int lane)
+{
+	int shift = (lane & 1) * 4;
+	u8 link_value = adjust_request[lane>>1];
+
+	return ((link_value >> shift) & 0xc) >> 2;
+}
+
+static void exynos_dp_set_lane_link_training(struct exynos_dp_device *dp,
+					u8 training_lane_set, int lane)
+{
+	switch (lane) {
+	case 0:
+		exynos_dp_set_lane0_link_training(dp, training_lane_set);
+		break;
+	case 1:
+		exynos_dp_set_lane1_link_training(dp, training_lane_set);
+		break;
+
+	case 2:
+		exynos_dp_set_lane2_link_training(dp, training_lane_set);
+		break;
+
+	case 3:
+		exynos_dp_set_lane3_link_training(dp, training_lane_set);
+		break;
+	}
+}
+
+static unsigned int exynos_dp_get_lane_link_training(
+				struct exynos_dp_device *dp,
+				int lane)
+{
+	u32 reg;
+
+	switch (lane) {
+	case 0:
+		reg = exynos_dp_get_lane0_link_training(dp);
+		break;
+	case 1:
+		reg = exynos_dp_get_lane1_link_training(dp);
+		break;
+	case 2:
+		reg = exynos_dp_get_lane2_link_training(dp);
+		break;
+	case 3:
+		reg = exynos_dp_get_lane3_link_training(dp);
+		break;
+	}
+
+	return reg;
+}
+
+static void exynos_dp_reduce_link_rate(struct exynos_dp_device *dp)
+{
+	if (dp->link_train.link_rate == LINK_RATE_2_70GBPS) {
+		/* set to reduced bit rate */
+		dp->link_train.link_rate = LINK_RATE_1_62GBPS;
+		dev_err(dp->dev, "set to bandwidth %.2x\n",
+			dp->link_train.link_rate);
+		dp->link_train.lt_state = START;
+	} else {
+		exynos_dp_training_pattern_dis(dp);
+		/* set enhanced mode if available */
+		exynos_dp_set_enhanced_mode(dp);
+		dp->link_train.lt_state = FAILED;
+	}
+}
+
+static void exynos_dp_get_adjust_train(struct exynos_dp_device *dp,
+				u8 adjust_request[2])
+{
+	int lane;
+	int lane_count;
+	u8 voltage_swing;
+	u8 pre_emphasis;
+	u8 training_lane;
+
+	lane_count = dp->link_train.lane_count;
+	for (lane = 0; lane < lane_count; lane++) {
+		voltage_swing = exynos_dp_get_adjust_request_voltage(
+						adjust_request, lane);
+		pre_emphasis = exynos_dp_get_adjust_request_pre_emphasis(
+						adjust_request, lane);
+		training_lane = DPCD_VOLTAGE_SWING_SET(voltage_swing) |
+				DPCD_PRE_EMPHASIS_SET(pre_emphasis);
+
+		if (voltage_swing == VOLTAGE_LEVEL_3 ||
+		   pre_emphasis == PRE_EMPHASIS_LEVEL_3) {
+			training_lane |= DPCD_MAX_SWING_REACHED;
+			training_lane |= DPCD_MAX_PRE_EMPHASIS_REACHED;
+		}
+		dp->link_train.training_lane[lane] = training_lane;
+	}
+}
+
+static int exynos_dp_check_max_cr_loop(struct exynos_dp_device *dp,
+					u8 voltage_swing)
+{
+	int lane;
+	int lane_count;
+
+	lane_count = dp->link_train.lane_count;
+	for (lane = 0; lane < lane_count; lane++) {
+		if (voltage_swing == VOLTAGE_LEVEL_3 ||
+			dp->link_train.cr_loop[lane] == MAX_CR_LOOP)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int exynos_dp_process_clock_recovery(struct exynos_dp_device *dp)
+{
+	u8 data;
+	u8 link_status[6];
+	int lane;
+	int lane_count;
+	u8 buf[5];
+
+	u8 *adjust_request;
+	u8 voltage_swing;
+	u8 pre_emphasis;
+	u8 training_lane;
+
+	udelay(100);
+
+	exynos_dp_read_bytes_from_dpcd(dp, DPCD_ADDR_LANE0_1_STATUS,
+				6, link_status);
+	lane_count = dp->link_train.lane_count;
+
+	if (exynos_dp_clock_recovery_ok(link_status, lane_count) == 0) {
+		/* set training pattern 2 for EQ */
+		exynos_dp_set_training_pattern(dp, TRAINING_PTN2);
+
+		adjust_request = link_status + (DPCD_ADDR_ADJUST_REQUEST_LANE0_1
+						- DPCD_ADDR_LANE0_1_STATUS);
+
+		exynos_dp_get_adjust_train(dp, adjust_request);
+
+		buf[0] = DPCD_SCRAMBLING_DISABLED |
+			 DPCD_TRAINING_PATTERN_2;
+		exynos_dp_write_byte_to_dpcd(dp,
+			DPCD_ADDR_TRAINING_LANE0_SET,
+			buf[0]);
+
+		for (lane = 0; lane < lane_count; lane++) {
+			exynos_dp_set_lane_link_training(dp,
+				dp->link_train.training_lane[lane],
+				lane);
+			buf[lane] = dp->link_train.training_lane[lane];
+			exynos_dp_write_byte_to_dpcd(dp,
+				DPCD_ADDR_TRAINING_LANE0_SET + lane,
+				buf[lane]);
+		}
+		dp->link_train.lt_state = EQUALIZER_TRAINING;
+	} else {
+		exynos_dp_read_byte_from_dpcd(dp,
+			DPCD_ADDR_ADJUST_REQUEST_LANE0_1,
+			&data);
+		adjust_request[0] = data;
+
+		exynos_dp_read_byte_from_dpcd(dp,
+			DPCD_ADDR_ADJUST_REQUEST_LANE2_3,
+			&data);
+		adjust_request[1] = data;
+
+		for (lane = 0; lane < lane_count; lane++) {
+			training_lane = exynos_dp_get_lane_link_training(
+							dp, lane);
+			voltage_swing = exynos_dp_get_adjust_request_voltage(
+							adjust_request, lane);
+			pre_emphasis = exynos_dp_get_adjust_request_pre_emphasis(
+							adjust_request, lane);
+			if ((DPCD_VOLTAGE_SWING_GET(training_lane) == voltage_swing) &&
+			    (DPCD_PRE_EMPHASIS_GET(training_lane) == pre_emphasis))
+				dp->link_train.cr_loop[lane]++;
+			dp->link_train.training_lane[lane] = training_lane;
+		}
+
+		if (exynos_dp_check_max_cr_loop(dp, voltage_swing) != 0) {
+			exynos_dp_reduce_link_rate(dp);
+		} else {
+			exynos_dp_get_adjust_train(dp, adjust_request);
+
+			for (lane = 0; lane < lane_count; lane++) {
+				exynos_dp_set_lane_link_training(dp,
+					dp->link_train.training_lane[lane],
+					lane);
+				buf[lane] = dp->link_train.training_lane[lane];
+				exynos_dp_write_byte_to_dpcd(dp,
+					DPCD_ADDR_TRAINING_LANE0_SET + lane,
+					buf[lane]);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int exynos_dp_process_equalizer_training(struct exynos_dp_device *dp)
+{
+	u8 link_status[6];
+	int lane;
+	int lane_count;
+	u8 buf[5];
+	u32 reg;
+
+	u8 *adjust_request;
+
+	udelay(400);
+
+	exynos_dp_read_bytes_from_dpcd(dp, DPCD_ADDR_LANE0_1_STATUS,
+				6, link_status);
+	lane_count = dp->link_train.lane_count;
+
+	if (exynos_dp_clock_recovery_ok(link_status, lane_count) == 0) {
+		adjust_request = link_status + (DPCD_ADDR_ADJUST_REQUEST_LANE0_1
+						- DPCD_ADDR_LANE0_1_STATUS);
+
+		if (exynos_dp_channel_eq_ok(link_status, lane_count) == 0) {
+			/* traing pattern Set to Normal */
+			exynos_dp_training_pattern_dis(dp);
+
+			dev_info(dp->dev, "Link Training success!\n");
+
+			exynos_dp_get_link_bandwidth(dp, &reg);
+			dp->link_train.link_rate = reg;
+			dev_dbg(dp->dev, "final bandwidth = %.2x\n",
+				dp->link_train.link_rate);
+
+			exynos_dp_get_lane_count(dp, &reg);
+			dp->link_train.lane_count = reg;
+			dev_dbg(dp->dev, "final lane count = %.2x\n",
+				dp->link_train.lane_count);
+			/* set enhanced mode if available */
+			exynos_dp_set_enhanced_mode(dp);
+
+			dp->link_train.lt_state = FINISHED;
+		} else {
+			/* not all locked */
+			dp->link_train.eq_loop++;
+
+			if (dp->link_train.eq_loop > MAX_EQ_LOOP) {
+				exynos_dp_reduce_link_rate(dp);
+			} else {
+				exynos_dp_get_adjust_train(dp, adjust_request);
+
+				for (lane = 0; lane < lane_count; lane++) {
+					exynos_dp_set_lane_link_training(dp,
+						dp->link_train.training_lane[lane],
+						lane);
+					buf[lane] = dp->link_train.training_lane[lane];
+					exynos_dp_write_byte_to_dpcd(dp,
+						DPCD_ADDR_TRAINING_LANE0_SET + lane,
+						buf[lane]);
+				}
+			}
+		}
+	} else {
+		exynos_dp_reduce_link_rate(dp);
+	}
+
+	return 0;
+}
+
+static void exynos_dp_get_max_rx_bandwidth(struct exynos_dp_device *dp,
+			u8 *bandwidth)
+{
+	u8 data;
+
+	/*
+	 * For DP rev.1.1, Maximum link rate of Main Link lanes
+	 * 0x06 = 1.62 Gbps, 0x0a = 2.7 Gbps
+	 */
+	exynos_dp_read_byte_from_dpcd(dp, DPCD_ADDR_MAX_LINK_RATE, &data);
+	*bandwidth = data;
+}
+
+static void exynos_dp_get_max_rx_lane_count(struct exynos_dp_device *dp,
+			u8 *lane_count)
+{
+	u8 data;
+
+	/*
+	 * For DP rev.1.1, Maximum number of Main Link lanes
+	 * 0x01 = 1 lane, 0x02 = 2 lanes, 0x04 = 4 lanes
+	 */
+	exynos_dp_read_byte_from_dpcd(dp, DPCD_ADDR_MAX_LANE_COUNT, &data);
+	*lane_count = DPCD_MAX_LANE_COUNT(data);
+}
+
+static void exynos_dp_init_training(struct exynos_dp_device *dp,
+			enum link_lane_count_type max_lane,
+			enum link_rate_type max_rate)
+{
+	/*
+	 * MACRO_RST must be applied after the PLL_LOCK to avoid
+	 * the DP inter pair skew issue for at least 10 us
+	 */
+	exynos_dp_reset_macro(dp);
+
+	/* Initialize by reading RX's DPCD */
+	exynos_dp_get_max_rx_bandwidth(dp, &dp->link_train.link_rate);
+	exynos_dp_get_max_rx_lane_count(dp, &dp->link_train.lane_count);
+
+	if ((dp->link_train.link_rate != LINK_RATE_1_62GBPS) &&
+	   (dp->link_train.link_rate != LINK_RATE_2_70GBPS)) {
+		dev_err(dp->dev, "Rx Max Link Rate is abnormal :%x !\n",
+			dp->link_train.link_rate);
+		dp->link_train.link_rate = LINK_RATE_1_62GBPS;
+	}
+
+	if (dp->link_train.lane_count == 0) {
+		dev_err(dp->dev, "Rx Max Lane count is abnormal :%x !\n",
+			dp->link_train.lane_count);
+		dp->link_train.lane_count = (u8)LANE_COUNT1;
+	}
+
+	/* Setup TX lane count & rate */
+	if (dp->link_train.lane_count > max_lane)
+		dp->link_train.lane_count = max_lane;
+	if (dp->link_train.link_rate > max_rate)
+		dp->link_train.link_rate = max_rate;
+
+	/* All DP analog module power up */
+	exynos_dp_set_analog_power_down(dp, POWER_ALL, 0);
+}
+
+static int exynos_dp_sw_link_training(struct exynos_dp_device *dp)
+{
+	int retval = 0;
+	int training_finished;
+
+	/* Turn off unnecessary lane */
+	if (dp->link_train.lane_count == 1)
+		exynos_dp_set_analog_power_down(dp, CH1_BLOCK, 1);
+
+	training_finished = 0;
+
+	dp->link_train.lt_state = START;
+
+	/* Process here */
+	while (!training_finished) {
+		switch (dp->link_train.lt_state) {
+		case START:
+			exynos_dp_link_start(dp);
+			break;
+		case CLOCK_RECOVERY:
+			exynos_dp_process_clock_recovery(dp);
+			break;
+		case EQUALIZER_TRAINING:
+			exynos_dp_process_equalizer_training(dp);
+			break;
+		case FINISHED:
+			training_finished = 1;
+			break;
+		case FAILED:
+			return -EREMOTEIO;
+		}
+	}
+
+	return retval;
+}
+
+static int exynos_dp_set_link_train(struct exynos_dp_device *dp,
+				u32 count,
+				u32 bwtype)
+{
+	int i;
+	int retval;
+
+	for (i = 0; i < DP_TIMEOUT_LOOP_COUNT; i++) {
+		exynos_dp_init_training(dp, count, bwtype);
+		retval = exynos_dp_sw_link_training(dp);
+		if (retval == 0)
+			break;
+
+		udelay(100);
+	}
+
+	return retval;
+}
+
+static int exynos_dp_config_video(struct exynos_dp_device *dp,
+			struct video_info *video_info)
+{
+	int retval = 0;
+	int timeout_loop = 0;
+	int done_count = 0;
+
+	exynos_dp_config_video_slave_mode(dp, video_info);
+
+	exynos_dp_set_video_color_format(dp, video_info->color_depth,
+			video_info->color_space,
+			video_info->dynamic_range,
+			video_info->ycbcr_coeff);
+
+	if (exynos_dp_get_pll_lock_status(dp) == PLL_UNLOCKED) {
+		dev_err(dp->dev, "PLL is not locked yet.\n");
+		return -EINVAL;
+	}
+
+	for (;;) {
+		timeout_loop++;
+		if (exynos_dp_is_slave_video_stream_clock_on(dp) == 0)
+			break;
+		if (DP_TIMEOUT_LOOP_COUNT < timeout_loop) {
+			dev_err(dp->dev, "Timeout of video streamclk ok\n");
+			return -ETIMEDOUT;
+		}
+
+		mdelay(100);
+	}
+
+	/* Set to use the register calculated M/N video */
+	exynos_dp_set_video_cr_mn(dp, CALCULATED_M, 0, 0);
+
+	/* For video bist, Video timing must be generated by register */
+	exynos_dp_set_video_timing_mode(dp, VIDEO_TIMING_FROM_CAPTURE);
+
+	/* Disable video mute */
+	exynos_dp_enable_video_mute(dp, 0);
+
+	/* Configure video slave mode */
+	exynos_dp_enable_video_master(dp, 0);
+
+	/* Enable video */
+	exynos_dp_start_video(dp);
+
+	timeout_loop = 0;
+
+	for (;;) {
+		timeout_loop++;
+		if (exynos_dp_is_video_stream_on(dp) == 0) {
+			done_count++;
+			if (done_count > 10)
+				break;
+		} else if (done_count) {
+			done_count = 0;
+		}
+		if (DP_TIMEOUT_LOOP_COUNT < timeout_loop) {
+			dev_err(dp->dev, "Timeout of video streamclk ok\n");
+			return -ETIMEDOUT;
+		}
+
+		mdelay(100);
+	}
+
+	if (retval != 0)
+		dev_err(dp->dev, "Video stream is not detected!\n");
+
+	return retval;
+}
+
+static void exynos_dp_enable_scramble(struct exynos_dp_device *dp, bool enable)
+{
+	u8 data;
+
+	if (enable) {
+		exynos_dp_enable_scrambling(dp);
+
+		exynos_dp_read_byte_from_dpcd(dp,
+			DPCD_ADDR_TRAINING_PATTERN_SET,
+			&data);
+		exynos_dp_write_byte_to_dpcd(dp,
+			DPCD_ADDR_TRAINING_PATTERN_SET,
+			(u8)(data & ~DPCD_SCRAMBLING_DISABLED));
+	} else {
+		exynos_dp_disable_scrambling(dp);
+
+		exynos_dp_read_byte_from_dpcd(dp,
+			DPCD_ADDR_TRAINING_PATTERN_SET,
+			&data);
+		exynos_dp_write_byte_to_dpcd(dp,
+			DPCD_ADDR_TRAINING_PATTERN_SET,
+			(u8)(data | DPCD_SCRAMBLING_DISABLED));
+	}
+}
+
+static irqreturn_t exynos_dp_irq_handler(int irq, void *arg)
+{
+	struct exynos_dp_device *dp = arg;
+
+	dev_err(dp->dev, "exynos_dp_irq_handler\n");
+	return IRQ_HANDLED;
+}
+
+static int __devinit exynos_dp_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct exynos_dp_device *dp;
+	struct exynos_dp_platdata *pdata;
+
+	int ret = 0;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	dp = kzalloc(sizeof(struct exynos_dp_device), GFP_KERNEL);
+	if (!dp) {
+		dev_err(&pdev->dev, "no memory for device data\n");
+		return -ENOMEM;
+	}
+
+	dp->dev = &pdev->dev;
+
+	dp->clock = clk_get(&pdev->dev, "dp");
+	if (IS_ERR(dp->clock)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		ret = PTR_ERR(dp->clock);
+		goto err_dp;
+	}
+
+	clk_enable(dp->clock);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get registers\n");
+		ret = -EINVAL;
+		goto err_clock;
+	}
+
+	res = request_mem_region(res->start, resource_size(res),
+				dev_name(&pdev->dev));
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request registers region\n");
+		ret = -EINVAL;
+		goto err_clock;
+	}
+
+	dp->res = res;
+
+	dp->reg_base = ioremap(res->start, resource_size(res));
+	if (!dp->reg_base) {
+		dev_err(&pdev->dev, "failed to ioremap\n");
+		ret = -ENOMEM;
+		goto err_req_region;
+	}
+
+	dp->irq = platform_get_irq(pdev, 0);
+	if (!dp->irq) {
+		dev_err(&pdev->dev, "failed to get irq\n");
+		ret = -ENODEV;
+		goto err_ioremap;
+	}
+
+	ret = request_irq(dp->irq, exynos_dp_irq_handler, 0,
+			"exynos-dp", dp);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		goto err_ioremap;
+	}
+
+	dp->video_info = pdata->video_info;
+	if (pdata->phy_init)
+		pdata->phy_init();
+
+	exynos_dp_init_dp(dp);
+
+	ret = exynos_dp_detect_hpd(dp);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to detect hpd\n");
+		goto err_irq;
+	}
+
+	exynos_dp_handle_edid(dp);
+
+	ret = exynos_dp_set_link_train(dp, dp->video_info->lane_count,
+				dp->video_info->link_rate);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to do link train\n");
+		goto err_irq;
+	}
+
+	exynos_dp_enable_scramble(dp, 1);
+	exynos_dp_enable_rx_to_enhanced_mode(dp, 1);
+	exynos_dp_enable_enhanced_mode(dp, 1);
+
+	exynos_dp_set_lane_count(dp, dp->video_info->lane_count);
+	exynos_dp_set_link_bandwidth(dp, dp->video_info->link_rate);
+
+	exynos_dp_init_video(dp);
+	ret = exynos_dp_config_video(dp, dp->video_info);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to config video\n");
+		goto err_irq;
+	}
+
+	platform_set_drvdata(pdev, dp);
+
+	return 0;
+
+err_irq:
+	free_irq(dp->irq, dp);
+err_ioremap:
+	iounmap(dp->reg_base);
+err_req_region:
+	release_mem_region(res->start, resource_size(res));
+err_clock:
+	clk_put(dp->clock);
+err_dp:
+	kfree(dp);
+
+	return ret;
+}
+
+static int __devexit exynos_dp_remove(struct platform_device *pdev)
+{
+	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
+	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
+
+	if (pdata && pdata->phy_exit)
+		pdata->phy_exit();
+
+	free_irq(dp->irq, dp);
+	iounmap(dp->reg_base);
+
+	clk_disable(dp->clock);
+	clk_put(dp->clock);
+
+	release_mem_region(dp->res->start, resource_size(dp->res));
+
+	kfree(dp);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int exynos_dp_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
+	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
+
+	if (pdata && pdata->phy_exit)
+		pdata->phy_exit();
+
+	clk_disable(dp->clock);
+
+	return 0;
+}
+
+static int exynos_dp_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
+	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
+
+	if (pdata && pdata->phy_init)
+		pdata->phy_init();
+
+	clk_enable(dp->clock);
+
+	exynos_dp_init_dp(dp);
+
+	exynos_dp_detect_hpd(dp);
+	exynos_dp_handle_edid(dp);
+
+	exynos_dp_set_link_train(dp, dp->video_info->lane_count,
+				dp->video_info->link_rate);
+
+	exynos_dp_enable_scramble(dp, 1);
+	exynos_dp_enable_rx_to_enhanced_mode(dp, 1);
+	exynos_dp_enable_enhanced_mode(dp, 1);
+
+	exynos_dp_set_lane_count(dp, dp->video_info->lane_count);
+	exynos_dp_set_link_bandwidth(dp, dp->video_info->link_rate);
+
+	exynos_dp_init_video(dp);
+	exynos_dp_config_video(dp, dp->video_info);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops exynos_dp_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(exynos_dp_suspend, exynos_dp_resume)
+};
+
+static struct platform_driver exynos_dp_driver = {
+	.probe		= exynos_dp_probe,
+	.remove		= __devexit_p(exynos_dp_remove),
+	.driver		= {
+		.name	= "exynos-dp",
+		.owner	= THIS_MODULE,
+		.pm	= &exynos_dp_pm_ops,
+	},
+};
+
+module_platform_driver(exynos_dp_driver);
+
+MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DP Driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/exynos/exynos_dp_core.h
--- /dev/null
+++ a/drivers/video/exynos/exynos_dp_core.h
@@ -0,0 +1,206 @@
+/*
+ * Header file for Samsung DP (Display Port) interface driver.
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#ifndef _EXYNOS_DP_CORE_H
+#define _EXYNOS_DP_CORE_H
+
+struct link_train {
+	int eq_loop;
+	int cr_loop[4];
+
+	u8 link_rate;
+	u8 lane_count;
+	u8 training_lane[4];
+
+	enum link_training_state lt_state;
+};
+
+struct exynos_dp_device {
+	struct device		*dev;
+	struct resource		*res;
+	struct clk		*clock;
+	unsigned int		irq;
+	void __iomem		*reg_base;
+
+	struct video_info	*video_info;
+	struct link_train	link_train;
+};
+
+/* exynos_dp_reg.c */
+void exynos_dp_enable_video_mute(struct exynos_dp_device *dp, bool enable);
+void exynos_dp_stop_video(struct exynos_dp_device *dp);
+void exynos_dp_lane_swap(struct exynos_dp_device *dp, bool enable);
+void exynos_dp_init_interrupt(struct exynos_dp_device *dp);
+void exynos_dp_reset(struct exynos_dp_device *dp);
+void exynos_dp_config_interrupt(struct exynos_dp_device *dp);
+u32 exynos_dp_get_pll_lock_status(struct exynos_dp_device *dp);
+void exynos_dp_set_pll_power_down(struct exynos_dp_device *dp, bool enable);
+void exynos_dp_set_analog_power_down(struct exynos_dp_device *dp,
+				enum analog_power_block block,
+				bool enable);
+void exynos_dp_init_analog_func(struct exynos_dp_device *dp);
+void exynos_dp_init_hpd(struct exynos_dp_device *dp);
+void exynos_dp_reset_aux(struct exynos_dp_device *dp);
+void exynos_dp_init_aux(struct exynos_dp_device *dp);
+int exynos_dp_get_plug_in_status(struct exynos_dp_device *dp);
+void exynos_dp_enable_sw_function(struct exynos_dp_device *dp);
+int exynos_dp_start_aux_transaction(struct exynos_dp_device *dp);
+int exynos_dp_write_byte_to_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned char data);
+int exynos_dp_read_byte_from_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned char *data);
+int exynos_dp_write_bytes_to_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned int count,
+				unsigned char data[]);
+int exynos_dp_read_bytes_from_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned int count,
+				unsigned char data[]);
+int exynos_dp_select_i2c_device(struct exynos_dp_device *dp,
+				unsigned int device_addr,
+				unsigned int reg_addr);
+int exynos_dp_read_byte_from_i2c(struct exynos_dp_device *dp,
+				unsigned int device_addr,
+				unsigned int reg_addr,
+				unsigned int *data);
+int exynos_dp_read_bytes_from_i2c(struct exynos_dp_device *dp,
+				unsigned int device_addr,
+				unsigned int reg_addr,
+				unsigned int count,
+				unsigned char edid[]);
+void exynos_dp_set_link_bandwidth(struct exynos_dp_device *dp, u32 bwtype);
+void exynos_dp_get_link_bandwidth(struct exynos_dp_device *dp, u32 *bwtype);
+void exynos_dp_set_lane_count(struct exynos_dp_device *dp, u32 count);
+void exynos_dp_get_lane_count(struct exynos_dp_device *dp, u32 *count);
+void exynos_dp_set_link_bandwidth(struct exynos_dp_device *dp, u32 bwtype);
+void exynos_dp_get_link_bandwidth(struct exynos_dp_device *dp, u32 *bwtype);
+void exynos_dp_set_lane_count(struct exynos_dp_device *dp, u32 count);
+void exynos_dp_get_lane_count(struct exynos_dp_device *dp, u32 *count);
+void exynos_dp_enable_enhanced_mode(struct exynos_dp_device *dp, bool enable);
+void exynos_dp_set_training_pattern(struct exynos_dp_device *dp,
+				 enum pattern_set pattern);
+void exynos_dp_set_lane0_pre_emphasis(struct exynos_dp_device *dp, u32 level);
+void exynos_dp_set_lane1_pre_emphasis(struct exynos_dp_device *dp, u32 level);
+void exynos_dp_set_lane2_pre_emphasis(struct exynos_dp_device *dp, u32 level);
+void exynos_dp_set_lane3_pre_emphasis(struct exynos_dp_device *dp, u32 level);
+void exynos_dp_set_lane0_link_training(struct exynos_dp_device *dp,
+				u32 training_lane);
+void exynos_dp_set_lane1_link_training(struct exynos_dp_device *dp,
+				u32 training_lane);
+void exynos_dp_set_lane2_link_training(struct exynos_dp_device *dp,
+				u32 training_lane);
+void exynos_dp_set_lane3_link_training(struct exynos_dp_device *dp,
+				u32 training_lane);
+u32 exynos_dp_get_lane0_link_training(struct exynos_dp_device *dp);
+u32 exynos_dp_get_lane1_link_training(struct exynos_dp_device *dp);
+u32 exynos_dp_get_lane2_link_training(struct exynos_dp_device *dp);
+u32 exynos_dp_get_lane3_link_training(struct exynos_dp_device *dp);
+void exynos_dp_reset_macro(struct exynos_dp_device *dp);
+int exynos_dp_init_video(struct exynos_dp_device *dp);
+
+void exynos_dp_set_video_color_format(struct exynos_dp_device *dp,
+				u32 color_depth,
+				u32 color_space,
+				u32 dynamic_range,
+				u32 ycbcr_coeff);
+int exynos_dp_is_slave_video_stream_clock_on(struct exynos_dp_device *dp);
+void exynos_dp_set_video_cr_mn(struct exynos_dp_device *dp,
+			enum clock_recovery_m_value_type type,
+			u32 m_value,
+			u32 n_value);
+void exynos_dp_set_video_timing_mode(struct exynos_dp_device *dp, u32 type);
+void exynos_dp_enable_video_master(struct exynos_dp_device *dp, bool enable);
+void exynos_dp_start_video(struct exynos_dp_device *dp);
+int exynos_dp_is_video_stream_on(struct exynos_dp_device *dp);
+void exynos_dp_config_video_slave_mode(struct exynos_dp_device *dp,
+			struct video_info *video_info);
+void exynos_dp_enable_scrambling(struct exynos_dp_device *dp);
+void exynos_dp_disable_scrambling(struct exynos_dp_device *dp);
+
+/* I2C EDID Chip ID, Slave Address */
+#define I2C_EDID_DEVICE_ADDR			0x50
+#define I2C_E_EDID_DEVICE_ADDR			0x30
+
+#define EDID_BLOCK_LENGTH			0x80
+#define EDID_HEADER_PATTERN			0x00
+#define EDID_EXTENSION_FLAG			0x7e
+#define EDID_CHECKSUM				0x7f
+
+/* Definition for DPCD Register */
+#define DPCD_ADDR_DPCD_REV			0x0000
+#define DPCD_ADDR_MAX_LINK_RATE			0x0001
+#define DPCD_ADDR_MAX_LANE_COUNT		0x0002
+#define DPCD_ADDR_LINK_BW_SET			0x0100
+#define DPCD_ADDR_LANE_COUNT_SET		0x0101
+#define DPCD_ADDR_TRAINING_PATTERN_SET		0x0102
+#define DPCD_ADDR_TRAINING_LANE0_SET		0x0103
+#define DPCD_ADDR_LANE0_1_STATUS		0x0202
+#define DPCD_ADDR_LANE_ALIGN__STATUS_UPDATED	0x0204
+#define DPCD_ADDR_ADJUST_REQUEST_LANE0_1	0x0206
+#define DPCD_ADDR_ADJUST_REQUEST_LANE2_3	0x0207
+#define DPCD_ADDR_TEST_REQUEST			0x0218
+#define DPCD_ADDR_TEST_RESPONSE			0x0260
+#define DPCD_ADDR_TEST_EDID_CHECKSUM		0x0261
+#define DPCD_ADDR_SINK_POWER_STATE		0x0600
+
+/* DPCD_ADDR_MAX_LANE_COUNT */
+#define DPCD_ENHANCED_FRAME_CAP(x)		(((x) >> 7) & 0x1)
+#define DPCD_MAX_LANE_COUNT(x)			((x) & 0x1f)
+
+/* DPCD_ADDR_LANE_COUNT_SET */
+#define DPCD_ENHANCED_FRAME_EN			(0x1 << 7)
+#define DPCD_LANE_COUNT_SET(x)			((x) & 0x1f)
+
+/* DPCD_ADDR_TRAINING_PATTERN_SET */
+#define DPCD_SCRAMBLING_DISABLED		(0x1 << 5)
+#define DPCD_SCRAMBLING_ENABLED			(0x0 << 5)
+#define DPCD_TRAINING_PATTERN_2			(0x2 << 0)
+#define DPCD_TRAINING_PATTERN_1			(0x1 << 0)
+#define DPCD_TRAINING_PATTERN_DISABLED		(0x0 << 0)
+
+/* DPCD_ADDR_TRAINING_LANE0_SET */
+#define DPCD_MAX_PRE_EMPHASIS_REACHED		(0x1 << 5)
+#define DPCD_PRE_EMPHASIS_SET(x)		(((x) & 0x3) << 3)
+#define DPCD_PRE_EMPHASIS_GET(x)		(((x) >> 3) & 0x3)
+#define DPCD_PRE_EMPHASIS_PATTERN2_LEVEL0	(0x0 << 3)
+#define DPCD_MAX_SWING_REACHED			(0x1 << 2)
+#define DPCD_VOLTAGE_SWING_SET(x)		(((x) & 0x3) << 0)
+#define DPCD_VOLTAGE_SWING_GET(x)		(((x) >> 0) & 0x3)
+#define DPCD_VOLTAGE_SWING_PATTERN1_LEVEL0	(0x0 << 0)
+
+/* DPCD_ADDR_LANE0_1_STATUS */
+#define DPCD_LANE_SYMBOL_LOCKED			(0x1 << 2)
+#define DPCD_LANE_CHANNEL_EQ_DONE		(0x1 << 1)
+#define DPCD_LANE_CR_DONE			(0x1 << 0)
+#define DPCD_CHANNEL_EQ_BITS			(DPCD_LANE_CR_DONE|	\
+						 DPCD_LANE_CHANNEL_EQ_DONE|\
+						 DPCD_LANE_SYMBOL_LOCKED)
+
+/* DPCD_ADDR_LANE_ALIGN__STATUS_UPDATED */
+#define DPCD_LINK_STATUS_UPDATED		(0x1 << 7)
+#define DPCD_DOWNSTREAM_PORT_STATUS_CHANGED	(0x1 << 6)
+#define DPCD_INTERLANE_ALIGN_DONE		(0x1 << 0)
+
+/* DPCD_ADDR_TEST_REQUEST */
+#define DPCD_TEST_EDID_READ			(0x1 << 2)
+
+/* DPCD_ADDR_TEST_RESPONSE */
+#define DPCD_TEST_EDID_CHECKSUM_WRITE		(0x1 << 2)
+
+/* DPCD_ADDR_SINK_POWER_STATE */
+#define DPCD_SET_POWER_STATE_D0			(0x1 << 0)
+#define DPCD_SET_POWER_STATE_D4			(0x2 << 0)
+
+#endif /* _EXYNOS_DP_CORE_H */
diff -puN /dev/null drivers/video/exynos/exynos_dp_reg.c
--- /dev/null
+++ a/drivers/video/exynos/exynos_dp_reg.c
@@ -0,0 +1,1173 @@
+/*
+ * Samsung DP (Display port) register interface driver.
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <video/exynos_dp.h>
+
+#include <plat/cpu.h>
+
+#include "exynos_dp_core.h"
+#include "exynos_dp_reg.h"
+
+#define COMMON_INT_MASK_1 (0)
+#define COMMON_INT_MASK_2 (0)
+#define COMMON_INT_MASK_3 (0)
+#define COMMON_INT_MASK_4 (0)
+#define INT_STA_MASK (0)
+
+void exynos_dp_enable_video_mute(struct exynos_dp_device *dp, bool enable)
+{
+	u32 reg;
+
+	if (enable) {
+		reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+		reg |= HDCP_VIDEO_MUTE;
+		writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+	} else {
+		reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+		reg &= ~HDCP_VIDEO_MUTE;
+		writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+	}
+}
+
+void exynos_dp_stop_video(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+	reg &= ~VIDEO_EN;
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+}
+
+void exynos_dp_lane_swap(struct exynos_dp_device *dp, bool enable)
+{
+	u32 reg;
+
+	if (enable)
+		reg = LANE3_MAP_LOGIC_LANE_0 | LANE2_MAP_LOGIC_LANE_1 |
+			LANE1_MAP_LOGIC_LANE_2 | LANE0_MAP_LOGIC_LANE_3;
+	else
+		reg = LANE3_MAP_LOGIC_LANE_3 | LANE2_MAP_LOGIC_LANE_2 |
+			LANE1_MAP_LOGIC_LANE_1 | LANE0_MAP_LOGIC_LANE_0;
+
+	writel(reg, dp->reg_base + EXYNOS_DP_LANE_MAP);
+}
+
+void exynos_dp_init_interrupt(struct exynos_dp_device *dp)
+{
+	/* Set interrupt pin assertion polarity as high */
+	writel(INT_POL, dp->reg_base + EXYNOS_DP_INT_CTL);
+
+	/* Clear pending regisers */
+	writel(0xff, dp->reg_base + EXYNOS_DP_COMMON_INT_STA_1);
+	writel(0x4f, dp->reg_base + EXYNOS_DP_COMMON_INT_STA_2);
+	writel(0xe0, dp->reg_base + EXYNOS_DP_COMMON_INT_STA_3);
+	writel(0xe7, dp->reg_base + EXYNOS_DP_COMMON_INT_STA_4);
+	writel(0x63, dp->reg_base + EXYNOS_DP_INT_STA);
+
+	/* 0:mask,1: unmask */
+	writel(0x00, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_1);
+	writel(0x00, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_2);
+	writel(0x00, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_3);
+	writel(0x00, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_4);
+	writel(0x00, dp->reg_base + EXYNOS_DP_INT_STA_MASK);
+}
+
+void exynos_dp_reset(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	writel(RESET_DP_TX, dp->reg_base + EXYNOS_DP_TX_SW_RESET);
+
+	exynos_dp_stop_video(dp);
+	exynos_dp_enable_video_mute(dp, 0);
+
+	reg = MASTER_VID_FUNC_EN_N | SLAVE_VID_FUNC_EN_N |
+		AUD_FIFO_FUNC_EN_N | AUD_FUNC_EN_N |
+		HDCP_FUNC_EN_N | SW_FUNC_EN_N;
+	writel(reg, dp->reg_base + EXYNOS_DP_FUNC_EN_1);
+
+	reg = SSC_FUNC_EN_N | AUX_FUNC_EN_N |
+		SERDES_FIFO_FUNC_EN_N |
+		LS_CLK_DOMAIN_FUNC_EN_N;
+	writel(reg, dp->reg_base + EXYNOS_DP_FUNC_EN_2);
+
+	udelay(20);
+
+	exynos_dp_lane_swap(dp, 0);
+
+	writel(0x0, dp->reg_base + EXYNOS_DP_SYS_CTL_1);
+	writel(0x40, dp->reg_base + EXYNOS_DP_SYS_CTL_2);
+	writel(0x0, dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+	writel(0x0, dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+
+	writel(0x0, dp->reg_base + EXYNOS_DP_PKT_SEND_CTL);
+	writel(0x0, dp->reg_base + EXYNOS_DP_HDCP_CTL);
+
+	writel(0x5e, dp->reg_base + EXYNOS_DP_HPD_DEGLITCH_L);
+	writel(0x1a, dp->reg_base + EXYNOS_DP_HPD_DEGLITCH_H);
+
+	writel(0x10, dp->reg_base + EXYNOS_DP_LINK_DEBUG_CTL);
+
+	writel(0x0, dp->reg_base + EXYNOS_DP_PHY_TEST);
+
+	writel(0x0, dp->reg_base + EXYNOS_DP_VIDEO_FIFO_THRD);
+	writel(0x20, dp->reg_base + EXYNOS_DP_AUDIO_MARGIN);
+
+	writel(0x4, dp->reg_base + EXYNOS_DP_M_VID_GEN_FILTER_TH);
+	writel(0x2, dp->reg_base + EXYNOS_DP_M_AUD_GEN_FILTER_TH);
+
+	writel(0x00000101, dp->reg_base + EXYNOS_DP_SOC_GENERAL_CTL);
+
+	exynos_dp_init_interrupt(dp);
+}
+
+void exynos_dp_config_interrupt(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	/* 0: mask, 1: unmask */
+	reg = COMMON_INT_MASK_1;
+	writel(reg, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_1);
+
+	reg = COMMON_INT_MASK_2;
+	writel(reg, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_2);
+
+	reg = COMMON_INT_MASK_3;
+	writel(reg, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_3);
+
+	reg = COMMON_INT_MASK_4;
+	writel(reg, dp->reg_base + EXYNOS_DP_COMMON_INT_MASK_4);
+
+	reg = INT_STA_MASK;
+	writel(reg, dp->reg_base + EXYNOS_DP_INT_STA_MASK);
+}
+
+u32 exynos_dp_get_pll_lock_status(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_DEBUG_CTL);
+	if (reg & PLL_LOCK)
+		return PLL_LOCKED;
+	else
+		return PLL_UNLOCKED;
+}
+
+void exynos_dp_set_pll_power_down(struct exynos_dp_device *dp, bool enable)
+{
+	u32 reg;
+
+	if (enable) {
+		reg = readl(dp->reg_base + EXYNOS_DP_PLL_CTL);
+		reg |= DP_PLL_PD;
+		writel(reg, dp->reg_base + EXYNOS_DP_PLL_CTL);
+	} else {
+		reg = readl(dp->reg_base + EXYNOS_DP_PLL_CTL);
+		reg &= ~DP_PLL_PD;
+		writel(reg, dp->reg_base + EXYNOS_DP_PLL_CTL);
+	}
+}
+
+void exynos_dp_set_analog_power_down(struct exynos_dp_device *dp,
+				enum analog_power_block block,
+				bool enable)
+{
+	u32 reg;
+
+	switch (block) {
+	case AUX_BLOCK:
+		if (enable) {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg |= AUX_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		} else {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg &= ~AUX_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		}
+		break;
+	case CH0_BLOCK:
+		if (enable) {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg |= CH0_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		} else {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg &= ~CH0_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		}
+		break;
+	case CH1_BLOCK:
+		if (enable) {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg |= CH1_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		} else {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg &= ~CH1_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		}
+		break;
+	case CH2_BLOCK:
+		if (enable) {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg |= CH2_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		} else {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg &= ~CH2_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		}
+		break;
+	case CH3_BLOCK:
+		if (enable) {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg |= CH3_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		} else {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg &= ~CH3_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		}
+		break;
+	case ANALOG_TOTAL:
+		if (enable) {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg |= DP_PHY_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		} else {
+			reg = readl(dp->reg_base + EXYNOS_DP_PHY_PD);
+			reg &= ~DP_PHY_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		}
+		break;
+	case POWER_ALL:
+		if (enable) {
+			reg = DP_PHY_PD | AUX_PD | CH3_PD | CH2_PD |
+				CH1_PD | CH0_PD;
+			writel(reg, dp->reg_base + EXYNOS_DP_PHY_PD);
+		} else {
+			writel(0x00, dp->reg_base + EXYNOS_DP_PHY_PD);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+void exynos_dp_init_analog_func(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	exynos_dp_set_analog_power_down(dp, POWER_ALL, 0);
+
+	reg = PLL_LOCK_CHG;
+	writel(reg, dp->reg_base + EXYNOS_DP_COMMON_INT_STA_1);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_DEBUG_CTL);
+	reg &= ~(F_PLL_LOCK | PLL_LOCK_CTRL);
+	writel(reg, dp->reg_base + EXYNOS_DP_DEBUG_CTL);
+
+	/* Power up PLL */
+	if (exynos_dp_get_pll_lock_status(dp) == PLL_UNLOCKED)
+		exynos_dp_set_pll_power_down(dp, 0);
+
+	/* Enable Serdes FIFO function and Link symbol clock domain module */
+	reg = readl(dp->reg_base + EXYNOS_DP_FUNC_EN_2);
+	reg &= ~(SERDES_FIFO_FUNC_EN_N | LS_CLK_DOMAIN_FUNC_EN_N
+		| AUX_FUNC_EN_N);
+	writel(reg, dp->reg_base + EXYNOS_DP_FUNC_EN_2);
+}
+
+void exynos_dp_init_hpd(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = HOTPLUG_CHG | HPD_LOST | PLUG;
+	writel(reg, dp->reg_base + EXYNOS_DP_COMMON_INT_STA_4);
+
+	reg = INT_HPD;
+	writel(reg, dp->reg_base + EXYNOS_DP_INT_STA);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+	reg &= ~(F_HPD | HPD_CTRL);
+	writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+}
+
+void exynos_dp_reset_aux(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	/* Disable AUX channel module */
+	reg = readl(dp->reg_base + EXYNOS_DP_FUNC_EN_2);
+	reg |= AUX_FUNC_EN_N;
+	writel(reg, dp->reg_base + EXYNOS_DP_FUNC_EN_2);
+}
+
+void exynos_dp_init_aux(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	/* Clear inerrupts related to AUX channel */
+	reg = RPLY_RECEIV | AUX_ERR;
+	writel(reg, dp->reg_base + EXYNOS_DP_INT_STA);
+
+	exynos_dp_reset_aux(dp);
+
+	/* Disable AUX transaction H/W retry */
+	reg = AUX_BIT_PERIOD_EXPECTED_DELAY(3) | AUX_HW_RETRY_COUNT_SEL(0)|
+		AUX_HW_RETRY_INTERVAL_600_MICROSECONDS;
+	writel(reg, dp->reg_base + EXYNOS_DP_AUX_HW_RETRY_CTL) ;
+
+	/* Receive AUX Channel DEFER commands equal to DEFFER_COUNT*64 */
+	reg = DEFER_CTRL_EN | DEFER_COUNT(1);
+	writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_DEFER_CTL);
+
+	/* Enable AUX channel module */
+	reg = readl(dp->reg_base + EXYNOS_DP_FUNC_EN_2);
+	reg &= ~AUX_FUNC_EN_N;
+	writel(reg, dp->reg_base + EXYNOS_DP_FUNC_EN_2);
+}
+
+int exynos_dp_get_plug_in_status(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+	if (reg & HPD_STATUS)
+		return 0;
+
+	return -EINVAL;
+}
+
+void exynos_dp_enable_sw_function(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_FUNC_EN_1);
+	reg &= ~SW_FUNC_EN_N;
+	writel(reg, dp->reg_base + EXYNOS_DP_FUNC_EN_1);
+}
+
+int exynos_dp_start_aux_transaction(struct exynos_dp_device *dp)
+{
+	int reg;
+	int retval = 0;
+
+	/* Enable AUX CH operation */
+	reg = readl(dp->reg_base + EXYNOS_DP_AUX_CH_CTL_2);
+	reg |= AUX_EN;
+	writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_2);
+
+	/* Is AUX CH command reply received? */
+	reg = readl(dp->reg_base + EXYNOS_DP_INT_STA);
+	while (!(reg & RPLY_RECEIV))
+		reg = readl(dp->reg_base + EXYNOS_DP_INT_STA);
+
+	/* Clear interrupt source for AUX CH command reply */
+	writel(RPLY_RECEIV, dp->reg_base + EXYNOS_DP_INT_STA);
+
+	/* Clear interrupt source for AUX CH access error */
+	reg = readl(dp->reg_base + EXYNOS_DP_INT_STA);
+	if (reg & AUX_ERR) {
+		writel(AUX_ERR, dp->reg_base + EXYNOS_DP_INT_STA);
+		return -EREMOTEIO;
+	}
+
+	/* Check AUX CH error access status */
+	reg = readl(dp->reg_base + EXYNOS_DP_AUX_CH_STA);
+	if ((reg & AUX_STATUS_MASK) != 0) {
+		dev_err(dp->dev, "AUX CH error happens: %d\n\n",
+			reg & AUX_STATUS_MASK);
+		return -EREMOTEIO;
+	}
+
+	return retval;
+}
+
+int exynos_dp_write_byte_to_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned char data)
+{
+	u32 reg;
+	int i;
+	int retval;
+
+	for (i = 0; i < 3; i++) {
+		/* Clear AUX CH data buffer */
+		reg = BUF_CLR;
+		writel(reg, dp->reg_base + EXYNOS_DP_BUFFER_DATA_CTL);
+
+		/* Select DPCD device address */
+		reg = AUX_ADDR_7_0(reg_addr);
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_7_0);
+		reg = AUX_ADDR_15_8(reg_addr);
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_15_8);
+		reg = AUX_ADDR_19_16(reg_addr);
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_19_16);
+
+		/* Write data buffer */
+		reg = (unsigned int)data;
+		writel(reg, dp->reg_base + EXYNOS_DP_BUF_DATA_0);
+
+		/*
+		 * Set DisplayPort transaction and write 1 byte
+		 * If bit 3 is 1, DisplayPort transaction.
+		 * If Bit 3 is 0, I2C transaction.
+		 */
+		reg = AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_WRITE;
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_1);
+
+		/* Start AUX transaction */
+		retval = exynos_dp_start_aux_transaction(dp);
+		if (retval == 0)
+			break;
+		else
+			dev_err(dp->dev, "Aux Transaction fail!\n");
+	}
+
+	return retval;
+}
+
+int exynos_dp_read_byte_from_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned char *data)
+{
+	u32 reg;
+	int i;
+	int retval;
+
+	for (i = 0; i < 10; i++) {
+		/* Clear AUX CH data buffer */
+		reg = BUF_CLR;
+		writel(reg, dp->reg_base + EXYNOS_DP_BUFFER_DATA_CTL);
+
+		/* Select DPCD device address */
+		reg = AUX_ADDR_7_0(reg_addr);
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_7_0);
+		reg = AUX_ADDR_15_8(reg_addr);
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_15_8);
+		reg = AUX_ADDR_19_16(reg_addr);
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_19_16);
+
+		/*
+		 * Set DisplayPort transaction and read 1 byte
+		 * If bit 3 is 1, DisplayPort transaction.
+		 * If Bit 3 is 0, I2C transaction.
+		 */
+		reg = AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_READ;
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_1);
+
+		/* Start AUX transaction */
+		retval = exynos_dp_start_aux_transaction(dp);
+		if (retval == 0)
+			break;
+		else
+			dev_err(dp->dev, "Aux Transaction fail!\n");
+	}
+
+	/* Read data buffer */
+	reg = readl(dp->reg_base + EXYNOS_DP_BUF_DATA_0);
+	*data = (unsigned char)(reg & 0xff);
+
+	return retval;
+}
+
+int exynos_dp_write_bytes_to_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned int count,
+				unsigned char data[])
+{
+	u32 reg;
+	unsigned int start_offset;
+	unsigned int cur_data_count;
+	unsigned int cur_data_idx;
+	int i;
+	int retval = 0;
+
+	/* Clear AUX CH data buffer */
+	reg = BUF_CLR;
+	writel(reg, dp->reg_base + EXYNOS_DP_BUFFER_DATA_CTL);
+
+	start_offset = 0;
+	while (start_offset < count) {
+		/* Buffer size of AUX CH is 16 * 4bytes */
+		if ((count - start_offset) > 16)
+			cur_data_count = 16;
+		else
+			cur_data_count = count - start_offset;
+
+		for (i = 0; i < 10; i++) {
+			/* Select DPCD device address */
+			reg = AUX_ADDR_7_0(reg_addr + start_offset);
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_7_0);
+			reg = AUX_ADDR_15_8(reg_addr + start_offset);
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_15_8);
+			reg = AUX_ADDR_19_16(reg_addr + start_offset);
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_19_16);
+
+			for (cur_data_idx = 0; cur_data_idx < cur_data_count;
+			     cur_data_idx++) {
+				reg = data[start_offset + cur_data_idx];
+				writel(reg, dp->reg_base + EXYNOS_DP_BUF_DATA_0
+							  + 4 * cur_data_idx);
+			}
+
+			/*
+			 * Set DisplayPort transaction and write
+			 * If bit 3 is 1, DisplayPort transaction.
+			 * If Bit 3 is 0, I2C transaction.
+			 */
+			reg = AUX_LENGTH(cur_data_count) |
+				AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_WRITE;
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_1);
+
+			/* Start AUX transaction */
+			retval = exynos_dp_start_aux_transaction(dp);
+			if (retval == 0)
+				break;
+			else
+				dev_err(dp->dev, "Aux Transaction fail!\n");
+		}
+
+		start_offset += cur_data_count;
+	}
+
+	return retval;
+}
+
+int exynos_dp_read_bytes_from_dpcd(struct exynos_dp_device *dp,
+				unsigned int reg_addr,
+				unsigned int count,
+				unsigned char data[])
+{
+	u32 reg;
+	unsigned int start_offset;
+	unsigned int cur_data_count;
+	unsigned int cur_data_idx;
+	int i;
+	int retval = 0;
+
+	/* Clear AUX CH data buffer */
+	reg = BUF_CLR;
+	writel(reg, dp->reg_base + EXYNOS_DP_BUFFER_DATA_CTL);
+
+	start_offset = 0;
+	while (start_offset < count) {
+		/* Buffer size of AUX CH is 16 * 4bytes */
+		if ((count - start_offset) > 16)
+			cur_data_count = 16;
+		else
+			cur_data_count = count - start_offset;
+
+		/* AUX CH Request Transaction process */
+		for (i = 0; i < 10; i++) {
+			/* Select DPCD device address */
+			reg = AUX_ADDR_7_0(reg_addr + start_offset);
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_7_0);
+			reg = AUX_ADDR_15_8(reg_addr + start_offset);
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_15_8);
+			reg = AUX_ADDR_19_16(reg_addr + start_offset);
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_19_16);
+
+			/*
+			 * Set DisplayPort transaction and read
+			 * If bit 3 is 1, DisplayPort transaction.
+			 * If Bit 3 is 0, I2C transaction.
+			 */
+			reg = AUX_LENGTH(cur_data_count) |
+				AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_READ;
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_1);
+
+			/* Start AUX transaction */
+			retval = exynos_dp_start_aux_transaction(dp);
+			if (retval == 0)
+				break;
+			else
+				dev_err(dp->dev, "Aux Transaction fail!\n");
+		}
+
+		for (cur_data_idx = 0; cur_data_idx < cur_data_count;
+		    cur_data_idx++) {
+			reg = readl(dp->reg_base + EXYNOS_DP_BUF_DATA_0
+						 + 4 * cur_data_idx);
+			data[start_offset + cur_data_idx] =
+				(unsigned char)reg;
+		}
+
+		start_offset += cur_data_count;
+	}
+
+	return retval;
+}
+
+int exynos_dp_select_i2c_device(struct exynos_dp_device *dp,
+				unsigned int device_addr,
+				unsigned int reg_addr)
+{
+	u32 reg;
+	int retval;
+
+	/* Set EDID device address */
+	reg = device_addr;
+	writel(reg, dp->reg_base + EXYNOS_DP_AUX_ADDR_7_0);
+	writel(0x0, dp->reg_base + EXYNOS_DP_AUX_ADDR_15_8);
+	writel(0x0, dp->reg_base + EXYNOS_DP_AUX_ADDR_19_16);
+
+	/* Set offset from base address of EDID device */
+	writel(reg_addr, dp->reg_base + EXYNOS_DP_BUF_DATA_0);
+
+	/*
+	 * Set I2C transaction and write address
+	 * If bit 3 is 1, DisplayPort transaction.
+	 * If Bit 3 is 0, I2C transaction.
+	 */
+	reg = AUX_TX_COMM_I2C_TRANSACTION | AUX_TX_COMM_MOT |
+		AUX_TX_COMM_WRITE;
+	writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_1);
+
+	/* Start AUX transaction */
+	retval = exynos_dp_start_aux_transaction(dp);
+	if (retval != 0)
+		dev_err(dp->dev, "Aux Transaction fail!\n");
+
+	return retval;
+}
+
+int exynos_dp_read_byte_from_i2c(struct exynos_dp_device *dp,
+				unsigned int device_addr,
+				unsigned int reg_addr,
+				unsigned int *data)
+{
+	u32 reg;
+	int i;
+	int retval;
+
+	for (i = 0; i < 10; i++) {
+		/* Clear AUX CH data buffer */
+		reg = BUF_CLR;
+		writel(reg, dp->reg_base + EXYNOS_DP_BUFFER_DATA_CTL);
+
+		/* Select EDID device */
+		retval = exynos_dp_select_i2c_device(dp, device_addr, reg_addr);
+		if (retval != 0) {
+			dev_err(dp->dev, "Select EDID device fail!\n");
+			continue;
+		}
+
+		/*
+		 * Set I2C transaction and read data
+		 * If bit 3 is 1, DisplayPort transaction.
+		 * If Bit 3 is 0, I2C transaction.
+		 */
+		reg = AUX_TX_COMM_I2C_TRANSACTION |
+			AUX_TX_COMM_READ;
+		writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_1);
+
+		/* Start AUX transaction */
+		retval = exynos_dp_start_aux_transaction(dp);
+		if (retval == 0)
+			break;
+		else
+			dev_err(dp->dev, "Aux Transaction fail!\n");
+	}
+
+	/* Read data */
+	if (retval == 0)
+		*data = readl(dp->reg_base + EXYNOS_DP_BUF_DATA_0);
+
+	return retval;
+}
+
+int exynos_dp_read_bytes_from_i2c(struct exynos_dp_device *dp,
+				unsigned int device_addr,
+				unsigned int reg_addr,
+				unsigned int count,
+				unsigned char edid[])
+{
+	u32 reg;
+	unsigned int i, j;
+	unsigned int cur_data_idx;
+	unsigned int defer = 0;
+	int retval = 0;
+
+	for (i = 0; i < count; i += 16) {
+		for (j = 0; j < 100; j++) {
+			/* Clear AUX CH data buffer */
+			reg = BUF_CLR;
+			writel(reg, dp->reg_base + EXYNOS_DP_BUFFER_DATA_CTL);
+
+			/* Set normal AUX CH command */
+			reg = readl(dp->reg_base + EXYNOS_DP_AUX_CH_CTL_2);
+			reg &= ~ADDR_ONLY;
+			writel(reg, dp->reg_base + EXYNOS_DP_AUX_CH_CTL_2);
+
+			/*
+			 * If Rx sends defer, Tx sends only reads
+			 * request without sending addres
+			 */
+			if (!defer)
+				retval = exynos_dp_select_i2c_device(dp,
+						device_addr, reg_addr + i);
+			else
+				defer = 0;
+
+			if (retval == 0) {
+				/*
+				 * Set I2C transaction and write data
+				 * If bit 3 is 1, DisplayPort transaction.
+				 * If Bit 3 is 0, I2C transaction.
+				 */
+				reg = AUX_LENGTH(16) |
+					AUX_TX_COMM_I2C_TRANSACTION |
+					AUX_TX_COMM_READ;
+				writel(reg, dp->reg_base +
+					EXYNOS_DP_AUX_CH_CTL_1);
+
+				/* Start AUX transaction */
+				retval = exynos_dp_start_aux_transaction(dp);
+				if (retval == 0)
+					break;
+				else
+					dev_err(dp->dev, "Aux Transaction fail!\n");
+			}
+			/* Check if Rx sends defer */
+			reg = readl(dp->reg_base + EXYNOS_DP_AUX_RX_COMM);
+			if (reg == AUX_RX_COMM_AUX_DEFER ||
+				reg == AUX_RX_COMM_I2C_DEFER) {
+				dev_err(dp->dev, "Defer: %d\n\n", reg);
+				defer = 1;
+			}
+		}
+
+		for (cur_data_idx = 0; cur_data_idx < 16; cur_data_idx++) {
+			reg = readl(dp->reg_base + EXYNOS_DP_BUF_DATA_0
+						 + 4 * cur_data_idx);
+			edid[i + cur_data_idx] = (unsigned char)reg;
+		}
+	}
+
+	return retval;
+}
+
+void exynos_dp_set_link_bandwidth(struct exynos_dp_device *dp, u32 bwtype)
+{
+	u32 reg;
+
+	reg = bwtype;
+	if ((bwtype == LINK_RATE_2_70GBPS) || (bwtype == LINK_RATE_1_62GBPS))
+		writel(reg, dp->reg_base + EXYNOS_DP_LINK_BW_SET);
+}
+
+void exynos_dp_get_link_bandwidth(struct exynos_dp_device *dp, u32 *bwtype)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_LINK_BW_SET);
+	*bwtype = reg;
+}
+
+void exynos_dp_set_lane_count(struct exynos_dp_device *dp, u32 count)
+{
+	u32 reg;
+
+	reg = count;
+	writel(reg, dp->reg_base + EXYNOS_DP_LANE_COUNT_SET);
+}
+
+void exynos_dp_get_lane_count(struct exynos_dp_device *dp, u32 *count)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_LANE_COUNT_SET);
+	*count = reg;
+}
+
+void exynos_dp_enable_enhanced_mode(struct exynos_dp_device *dp, bool enable)
+{
+	u32 reg;
+
+	if (enable) {
+		reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+		reg |= ENHANCED;
+		writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+	} else {
+		reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+		reg &= ~ENHANCED;
+		writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+	}
+}
+
+void exynos_dp_set_training_pattern(struct exynos_dp_device *dp,
+				 enum pattern_set pattern)
+{
+	u32 reg;
+
+	switch (pattern) {
+	case PRBS7:
+		reg = SCRAMBLING_ENABLE | LINK_QUAL_PATTERN_SET_PRBS7;
+		writel(reg, dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+		break;
+	case D10_2:
+		reg = SCRAMBLING_ENABLE | LINK_QUAL_PATTERN_SET_D10_2;
+		writel(reg, dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+		break;
+	case TRAINING_PTN1:
+		reg = SCRAMBLING_DISABLE | SW_TRAINING_PATTERN_SET_PTN1;
+		writel(reg, dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+		break;
+	case TRAINING_PTN2:
+		reg = SCRAMBLING_DISABLE | SW_TRAINING_PATTERN_SET_PTN2;
+		writel(reg, dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+		break;
+	case DP_NONE:
+		reg = SCRAMBLING_ENABLE |
+			LINK_QUAL_PATTERN_SET_DISABLE |
+			SW_TRAINING_PATTERN_SET_NORMAL;
+		writel(reg, dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+		break;
+	default:
+		break;
+	}
+}
+
+void exynos_dp_set_lane0_pre_emphasis(struct exynos_dp_device *dp, u32 level)
+{
+	u32 reg;
+
+	reg = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN0_LINK_TRAINING_CTL);
+}
+
+void exynos_dp_set_lane1_pre_emphasis(struct exynos_dp_device *dp, u32 level)
+{
+	u32 reg;
+
+	reg = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN1_LINK_TRAINING_CTL);
+}
+
+void exynos_dp_set_lane2_pre_emphasis(struct exynos_dp_device *dp, u32 level)
+{
+	u32 reg;
+
+	reg = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN2_LINK_TRAINING_CTL);
+}
+
+void exynos_dp_set_lane3_pre_emphasis(struct exynos_dp_device *dp, u32 level)
+{
+	u32 reg;
+
+	reg = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN3_LINK_TRAINING_CTL);
+}
+
+void exynos_dp_set_lane0_link_training(struct exynos_dp_device *dp,
+					u32 training_lane)
+{
+	u32 reg;
+
+	reg = training_lane;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN0_LINK_TRAINING_CTL);
+}
+
+void exynos_dp_set_lane1_link_training(struct exynos_dp_device *dp,
+					u32 training_lane)
+{
+	u32 reg;
+
+	reg = training_lane;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN1_LINK_TRAINING_CTL);
+}
+
+void exynos_dp_set_lane2_link_training(struct exynos_dp_device *dp,
+					u32 training_lane)
+{
+	u32 reg;
+
+	reg = training_lane;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN2_LINK_TRAINING_CTL);
+}
+
+void exynos_dp_set_lane3_link_training(struct exynos_dp_device *dp,
+					u32 training_lane)
+{
+	u32 reg;
+
+	reg = training_lane;
+	writel(reg, dp->reg_base + EXYNOS_DP_LN3_LINK_TRAINING_CTL);
+}
+
+u32 exynos_dp_get_lane0_link_training(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_LN0_LINK_TRAINING_CTL);
+	return reg;
+}
+
+u32 exynos_dp_get_lane1_link_training(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_LN1_LINK_TRAINING_CTL);
+	return reg;
+}
+
+u32 exynos_dp_get_lane2_link_training(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_LN2_LINK_TRAINING_CTL);
+	return reg;
+}
+
+u32 exynos_dp_get_lane3_link_training(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_LN3_LINK_TRAINING_CTL);
+	return reg;
+}
+
+void exynos_dp_reset_macro(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_PHY_TEST);
+	reg |= MACRO_RST;
+	writel(reg, dp->reg_base + EXYNOS_DP_PHY_TEST);
+
+	/* 10 us is the minimum reset time. */
+	udelay(10);
+
+	reg &= ~MACRO_RST;
+	writel(reg, dp->reg_base + EXYNOS_DP_PHY_TEST);
+}
+
+int exynos_dp_init_video(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = VSYNC_DET | VID_FORMAT_CHG | VID_CLK_CHG;
+	writel(reg, dp->reg_base + EXYNOS_DP_COMMON_INT_STA_1);
+
+	reg = 0x0;
+	writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_1);
+
+	reg = CHA_CRI(4) | CHA_CTRL;
+	writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_2);
+
+	reg = 0x0;
+	writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+
+	reg = VID_HRES_TH(2) | VID_VRES_TH(0);
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_8);
+
+	return 0;
+}
+
+void exynos_dp_set_video_color_format(struct exynos_dp_device *dp,
+			u32 color_depth,
+			u32 color_space,
+			u32 dynamic_range,
+			u32 ycbcr_coeff)
+{
+	u32 reg;
+
+	/* Configure the input color depth, color space, dynamic range */
+	reg = (dynamic_range << IN_D_RANGE_SHIFT) |
+		(color_depth << IN_BPC_SHIFT) |
+		(color_space << IN_COLOR_F_SHIFT);
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_2);
+
+	/* Set Input Color YCbCr Coefficients to ITU601 or ITU709 */
+	reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_3);
+	reg &= ~IN_YC_COEFFI_MASK;
+	if (ycbcr_coeff)
+		reg |= IN_YC_COEFFI_ITU709;
+	else
+		reg |= IN_YC_COEFFI_ITU601;
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_3);
+}
+
+int exynos_dp_is_slave_video_stream_clock_on(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_1);
+	writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_1);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_1);
+
+	if (!(reg & DET_STA)) {
+		dev_dbg(dp->dev, "Input stream clock not detected.\n");
+		return -EINVAL;
+	}
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_2);
+	writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_2);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_2);
+	dev_dbg(dp->dev, "wait SYS_CTL_2.\n");
+
+	if (reg & CHA_STA) {
+		dev_dbg(dp->dev, "Input stream clk is changing\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void exynos_dp_set_video_cr_mn(struct exynos_dp_device *dp,
+		enum clock_recovery_m_value_type type,
+		u32 m_value,
+		u32 n_value)
+{
+	u32 reg;
+
+	if (type == REGISTER_M) {
+		reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+		reg |= FIX_M_VID;
+		writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+		reg = m_value & 0xff;
+		writel(reg, dp->reg_base + EXYNOS_DP_M_VID_0);
+		reg = (m_value >> 8) & 0xff;
+		writel(reg, dp->reg_base + EXYNOS_DP_M_VID_1);
+		reg = (m_value >> 16) & 0xff;
+		writel(reg, dp->reg_base + EXYNOS_DP_M_VID_2);
+
+		reg = n_value & 0xff;
+		writel(reg, dp->reg_base + EXYNOS_DP_N_VID_0);
+		reg = (n_value >> 8) & 0xff;
+		writel(reg, dp->reg_base + EXYNOS_DP_N_VID_1);
+		reg = (n_value >> 16) & 0xff;
+		writel(reg, dp->reg_base + EXYNOS_DP_N_VID_2);
+	} else  {
+		reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+		reg &= ~FIX_M_VID;
+		writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_4);
+
+		writel(0x00, dp->reg_base + EXYNOS_DP_N_VID_0);
+		writel(0x80, dp->reg_base + EXYNOS_DP_N_VID_1);
+		writel(0x00, dp->reg_base + EXYNOS_DP_N_VID_2);
+	}
+}
+
+void exynos_dp_set_video_timing_mode(struct exynos_dp_device *dp, u32 type)
+{
+	u32 reg;
+
+	if (type == VIDEO_TIMING_FROM_CAPTURE) {
+		reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+		reg &= ~FORMAT_SEL;
+		writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+	} else {
+		reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+		reg |= FORMAT_SEL;
+		writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+	}
+}
+
+void exynos_dp_enable_video_master(struct exynos_dp_device *dp, bool enable)
+{
+	u32 reg;
+
+	if (enable) {
+		reg = readl(dp->reg_base + EXYNOS_DP_SOC_GENERAL_CTL);
+		reg &= ~VIDEO_MODE_MASK;
+		reg |= VIDEO_MASTER_MODE_EN | VIDEO_MODE_MASTER_MODE;
+		writel(reg, dp->reg_base + EXYNOS_DP_SOC_GENERAL_CTL);
+	} else {
+		reg = readl(dp->reg_base + EXYNOS_DP_SOC_GENERAL_CTL);
+		reg &= ~VIDEO_MODE_MASK;
+		reg |= VIDEO_MODE_SLAVE_MODE;
+		writel(reg, dp->reg_base + EXYNOS_DP_SOC_GENERAL_CTL);
+	}
+}
+
+void exynos_dp_start_video(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+	reg |= VIDEO_EN;
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_1);
+}
+
+int exynos_dp_is_video_stream_on(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+	writel(reg, dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_SYS_CTL_3);
+	if (!(reg & STRM_VALID)) {
+		dev_dbg(dp->dev, "Input video stream is not detected.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void exynos_dp_config_video_slave_mode(struct exynos_dp_device *dp,
+			struct video_info *video_info)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_FUNC_EN_1);
+	reg &= ~(MASTER_VID_FUNC_EN_N|SLAVE_VID_FUNC_EN_N);
+	reg |= MASTER_VID_FUNC_EN_N;
+	writel(reg, dp->reg_base + EXYNOS_DP_FUNC_EN_1);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+	reg &= ~INTERACE_SCAN_CFG;
+	reg |= (video_info->interlaced << 2);
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+	reg &= ~VSYNC_POLARITY_CFG;
+	reg |= (video_info->v_sync_polarity << 1);
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+
+	reg = readl(dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+	reg &= ~HSYNC_POLARITY_CFG;
+	reg |= (video_info->h_sync_polarity << 0);
+	writel(reg, dp->reg_base + EXYNOS_DP_VIDEO_CTL_10);
+
+	reg = AUDIO_MODE_SPDIF_MODE | VIDEO_MODE_SLAVE_MODE;
+	writel(reg, dp->reg_base + EXYNOS_DP_SOC_GENERAL_CTL);
+}
+
+void exynos_dp_enable_scrambling(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+	reg &= ~SCRAMBLING_DISABLE;
+	writel(reg, dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+}
+
+void exynos_dp_disable_scrambling(struct exynos_dp_device *dp)
+{
+	u32 reg;
+
+	reg = readl(dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+	reg |= SCRAMBLING_DISABLE;
+	writel(reg, dp->reg_base + EXYNOS_DP_TRAINING_PTN_SET);
+}
diff -puN /dev/null drivers/video/exynos/exynos_dp_reg.h
--- /dev/null
+++ a/drivers/video/exynos/exynos_dp_reg.h
@@ -0,0 +1,335 @@
+/*
+ * Register definition file for Samsung DP driver
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _EXYNOS_DP_REG_H
+#define _EXYNOS_DP_REG_H
+
+#define EXYNOS_DP_TX_SW_RESET			0x14
+#define EXYNOS_DP_FUNC_EN_1			0x18
+#define EXYNOS_DP_FUNC_EN_2			0x1C
+#define EXYNOS_DP_VIDEO_CTL_1			0x20
+#define EXYNOS_DP_VIDEO_CTL_2			0x24
+#define EXYNOS_DP_VIDEO_CTL_3			0x28
+
+#define EXYNOS_DP_VIDEO_CTL_8			0x3C
+#define EXYNOS_DP_VIDEO_CTL_10			0x44
+
+#define EXYNOS_DP_LANE_MAP			0x35C
+
+#define EXYNOS_DP_AUX_HW_RETRY_CTL		0x390
+
+#define EXYNOS_DP_COMMON_INT_STA_1		0x3C4
+#define EXYNOS_DP_COMMON_INT_STA_2		0x3C8
+#define EXYNOS_DP_COMMON_INT_STA_3		0x3CC
+#define EXYNOS_DP_COMMON_INT_STA_4		0x3D0
+#define EXYNOS_DP_INT_STA			0x3DC
+#define EXYNOS_DP_COMMON_INT_MASK_1		0x3E0
+#define EXYNOS_DP_COMMON_INT_MASK_2		0x3E4
+#define EXYNOS_DP_COMMON_INT_MASK_3		0x3E8
+#define EXYNOS_DP_COMMON_INT_MASK_4		0x3EC
+#define EXYNOS_DP_INT_STA_MASK			0x3F8
+#define EXYNOS_DP_INT_CTL			0x3FC
+
+#define EXYNOS_DP_SYS_CTL_1			0x600
+#define EXYNOS_DP_SYS_CTL_2			0x604
+#define EXYNOS_DP_SYS_CTL_3			0x608
+#define EXYNOS_DP_SYS_CTL_4			0x60C
+
+#define EXYNOS_DP_PKT_SEND_CTL			0x640
+#define EXYNOS_DP_HDCP_CTL			0x648
+
+#define EXYNOS_DP_LINK_BW_SET			0x680
+#define EXYNOS_DP_LANE_COUNT_SET		0x684
+#define EXYNOS_DP_TRAINING_PTN_SET		0x688
+#define EXYNOS_DP_LN0_LINK_TRAINING_CTL		0x68C
+#define EXYNOS_DP_LN1_LINK_TRAINING_CTL		0x690
+#define EXYNOS_DP_LN2_LINK_TRAINING_CTL		0x694
+#define EXYNOS_DP_LN3_LINK_TRAINING_CTL		0x698
+
+#define EXYNOS_DP_DEBUG_CTL			0x6C0
+#define EXYNOS_DP_HPD_DEGLITCH_L		0x6C4
+#define EXYNOS_DP_HPD_DEGLITCH_H		0x6C8
+#define EXYNOS_DP_LINK_DEBUG_CTL		0x6E0
+
+#define EXYNOS_DP_M_VID_0			0x700
+#define EXYNOS_DP_M_VID_1			0x704
+#define EXYNOS_DP_M_VID_2			0x708
+#define EXYNOS_DP_N_VID_0			0x70C
+#define EXYNOS_DP_N_VID_1			0x710
+#define EXYNOS_DP_N_VID_2			0x714
+
+#define EXYNOS_DP_PLL_CTL			0x71C
+#define EXYNOS_DP_PHY_PD			0x720
+#define EXYNOS_DP_PHY_TEST			0x724
+
+#define EXYNOS_DP_VIDEO_FIFO_THRD		0x730
+#define EXYNOS_DP_AUDIO_MARGIN			0x73C
+
+#define EXYNOS_DP_M_VID_GEN_FILTER_TH		0x764
+#define EXYNOS_DP_M_AUD_GEN_FILTER_TH		0x778
+#define EXYNOS_DP_AUX_CH_STA			0x780
+#define EXYNOS_DP_AUX_CH_DEFER_CTL		0x788
+#define EXYNOS_DP_AUX_RX_COMM			0x78C
+#define EXYNOS_DP_BUFFER_DATA_CTL		0x790
+#define EXYNOS_DP_AUX_CH_CTL_1			0x794
+#define EXYNOS_DP_AUX_ADDR_7_0			0x798
+#define EXYNOS_DP_AUX_ADDR_15_8			0x79C
+#define EXYNOS_DP_AUX_ADDR_19_16		0x7A0
+#define EXYNOS_DP_AUX_CH_CTL_2			0x7A4
+
+#define EXYNOS_DP_BUF_DATA_0			0x7C0
+
+#define EXYNOS_DP_SOC_GENERAL_CTL		0x800
+
+/* EXYNOS_DP_TX_SW_RESET */
+#define RESET_DP_TX				(0x1 << 0)
+
+/* EXYNOS_DP_FUNC_EN_1 */
+#define MASTER_VID_FUNC_EN_N			(0x1 << 7)
+#define SLAVE_VID_FUNC_EN_N			(0x1 << 5)
+#define AUD_FIFO_FUNC_EN_N			(0x1 << 4)
+#define AUD_FUNC_EN_N				(0x1 << 3)
+#define HDCP_FUNC_EN_N				(0x1 << 2)
+#define CRC_FUNC_EN_N				(0x1 << 1)
+#define SW_FUNC_EN_N				(0x1 << 0)
+
+/* EXYNOS_DP_FUNC_EN_2 */
+#define SSC_FUNC_EN_N				(0x1 << 7)
+#define AUX_FUNC_EN_N				(0x1 << 2)
+#define SERDES_FIFO_FUNC_EN_N			(0x1 << 1)
+#define LS_CLK_DOMAIN_FUNC_EN_N			(0x1 << 0)
+
+/* EXYNOS_DP_VIDEO_CTL_1 */
+#define VIDEO_EN				(0x1 << 7)
+#define HDCP_VIDEO_MUTE				(0x1 << 6)
+
+/* EXYNOS_DP_VIDEO_CTL_1 */
+#define IN_D_RANGE_MASK				(0x1 << 7)
+#define IN_D_RANGE_SHIFT			(7)
+#define IN_D_RANGE_CEA				(0x1 << 7)
+#define IN_D_RANGE_VESA				(0x0 << 7)
+#define IN_BPC_MASK				(0x7 << 4)
+#define IN_BPC_SHIFT				(4)
+#define IN_BPC_12_BITS				(0x3 << 4)
+#define IN_BPC_10_BITS				(0x2 << 4)
+#define IN_BPC_8_BITS				(0x1 << 4)
+#define IN_BPC_6_BITS				(0x0 << 4)
+#define IN_COLOR_F_MASK				(0x3 << 0)
+#define IN_COLOR_F_SHIFT			(0)
+#define IN_COLOR_F_YCBCR444			(0x2 << 0)
+#define IN_COLOR_F_YCBCR422			(0x1 << 0)
+#define IN_COLOR_F_RGB				(0x0 << 0)
+
+/* EXYNOS_DP_VIDEO_CTL_3 */
+#define IN_YC_COEFFI_MASK			(0x1 << 7)
+#define IN_YC_COEFFI_SHIFT			(7)
+#define IN_YC_COEFFI_ITU709			(0x1 << 7)
+#define IN_YC_COEFFI_ITU601			(0x0 << 7)
+#define VID_CHK_UPDATE_TYPE_MASK		(0x1 << 4)
+#define VID_CHK_UPDATE_TYPE_SHIFT		(4)
+#define VID_CHK_UPDATE_TYPE_1			(0x1 << 4)
+#define VID_CHK_UPDATE_TYPE_0			(0x0 << 4)
+
+/* EXYNOS_DP_VIDEO_CTL_8 */
+#define VID_HRES_TH(x)				(((x) & 0xf) << 4)
+#define VID_VRES_TH(x)				(((x) & 0xf) << 0)
+
+/* EXYNOS_DP_VIDEO_CTL_10 */
+#define FORMAT_SEL				(0x1 << 4)
+#define INTERACE_SCAN_CFG			(0x1 << 2)
+#define VSYNC_POLARITY_CFG			(0x1 << 1)
+#define HSYNC_POLARITY_CFG			(0x1 << 0)
+
+/* EXYNOS_DP_LANE_MAP */
+#define LANE3_MAP_LOGIC_LANE_0			(0x0 << 6)
+#define LANE3_MAP_LOGIC_LANE_1			(0x1 << 6)
+#define LANE3_MAP_LOGIC_LANE_2			(0x2 << 6)
+#define LANE3_MAP_LOGIC_LANE_3			(0x3 << 6)
+#define LANE2_MAP_LOGIC_LANE_0			(0x0 << 4)
+#define LANE2_MAP_LOGIC_LANE_1			(0x1 << 4)
+#define LANE2_MAP_LOGIC_LANE_2			(0x2 << 4)
+#define LANE2_MAP_LOGIC_LANE_3			(0x3 << 4)
+#define LANE1_MAP_LOGIC_LANE_0			(0x0 << 2)
+#define LANE1_MAP_LOGIC_LANE_1			(0x1 << 2)
+#define LANE1_MAP_LOGIC_LANE_2			(0x2 << 2)
+#define LANE1_MAP_LOGIC_LANE_3			(0x3 << 2)
+#define LANE0_MAP_LOGIC_LANE_0			(0x0 << 0)
+#define LANE0_MAP_LOGIC_LANE_1			(0x1 << 0)
+#define LANE0_MAP_LOGIC_LANE_2			(0x2 << 0)
+#define LANE0_MAP_LOGIC_LANE_3			(0x3 << 0)
+
+/* EXYNOS_DP_AUX_HW_RETRY_CTL */
+#define AUX_BIT_PERIOD_EXPECTED_DELAY(x)	(((x) & 0x7) << 8)
+#define AUX_HW_RETRY_INTERVAL_MASK		(0x3 << 3)
+#define AUX_HW_RETRY_INTERVAL_600_MICROSECONDS	(0x0 << 3)
+#define AUX_HW_RETRY_INTERVAL_800_MICROSECONDS	(0x1 << 3)
+#define AUX_HW_RETRY_INTERVAL_1000_MICROSECONDS	(0x2 << 3)
+#define AUX_HW_RETRY_INTERVAL_1800_MICROSECONDS	(0x3 << 3)
+#define AUX_HW_RETRY_COUNT_SEL(x)		(((x) & 0x7) << 0)
+
+/* EXYNOS_DP_COMMON_INT_STA_1 */
+#define VSYNC_DET				(0x1 << 7)
+#define PLL_LOCK_CHG				(0x1 << 6)
+#define SPDIF_ERR				(0x1 << 5)
+#define SPDIF_UNSTBL				(0x1 << 4)
+#define VID_FORMAT_CHG				(0x1 << 3)
+#define AUD_CLK_CHG				(0x1 << 2)
+#define VID_CLK_CHG				(0x1 << 1)
+#define SW_INT					(0x1 << 0)
+
+/* EXYNOS_DP_COMMON_INT_STA_2 */
+#define ENC_EN_CHG				(0x1 << 6)
+#define HW_BKSV_RDY				(0x1 << 3)
+#define HW_SHA_DONE				(0x1 << 2)
+#define HW_AUTH_STATE_CHG			(0x1 << 1)
+#define HW_AUTH_DONE				(0x1 << 0)
+
+/* EXYNOS_DP_COMMON_INT_STA_3 */
+#define AFIFO_UNDER				(0x1 << 7)
+#define AFIFO_OVER				(0x1 << 6)
+#define R0_CHK_FLAG				(0x1 << 5)
+
+/* EXYNOS_DP_COMMON_INT_STA_4 */
+#define PSR_ACTIVE				(0x1 << 7)
+#define PSR_INACTIVE				(0x1 << 6)
+#define SPDIF_BI_PHASE_ERR			(0x1 << 5)
+#define HOTPLUG_CHG				(0x1 << 2)
+#define HPD_LOST				(0x1 << 1)
+#define PLUG					(0x1 << 0)
+
+/* EXYNOS_DP_INT_STA */
+#define INT_HPD					(0x1 << 6)
+#define HW_TRAINING_FINISH			(0x1 << 5)
+#define RPLY_RECEIV				(0x1 << 1)
+#define AUX_ERR					(0x1 << 0)
+
+/* EXYNOS_DP_INT_CTL */
+#define SOFT_INT_CTRL				(0x1 << 2)
+#define INT_POL					(0x1 << 0)
+
+/* EXYNOS_DP_SYS_CTL_1 */
+#define DET_STA					(0x1 << 2)
+#define FORCE_DET				(0x1 << 1)
+#define DET_CTRL				(0x1 << 0)
+
+/* EXYNOS_DP_SYS_CTL_2 */
+#define CHA_CRI(x)				(((x) & 0xf) << 4)
+#define CHA_STA					(0x1 << 2)
+#define FORCE_CHA				(0x1 << 1)
+#define CHA_CTRL				(0x1 << 0)
+
+/* EXYNOS_DP_SYS_CTL_3 */
+#define HPD_STATUS				(0x1 << 6)
+#define F_HPD					(0x1 << 5)
+#define HPD_CTRL				(0x1 << 4)
+#define HDCP_RDY				(0x1 << 3)
+#define STRM_VALID				(0x1 << 2)
+#define F_VALID					(0x1 << 1)
+#define VALID_CTRL				(0x1 << 0)
+
+/* EXYNOS_DP_SYS_CTL_4 */
+#define FIX_M_AUD				(0x1 << 4)
+#define ENHANCED				(0x1 << 3)
+#define FIX_M_VID				(0x1 << 2)
+#define M_VID_UPDATE_CTRL			(0x3 << 0)
+
+/* EXYNOS_DP_TRAINING_PTN_SET */
+#define SCRAMBLER_TYPE				(0x1 << 9)
+#define HW_LINK_TRAINING_PATTERN		(0x1 << 8)
+#define SCRAMBLING_DISABLE			(0x1 << 5)
+#define SCRAMBLING_ENABLE			(0x0 << 5)
+#define LINK_QUAL_PATTERN_SET_MASK		(0x3 << 2)
+#define LINK_QUAL_PATTERN_SET_PRBS7		(0x3 << 2)
+#define LINK_QUAL_PATTERN_SET_D10_2		(0x1 << 2)
+#define LINK_QUAL_PATTERN_SET_DISABLE		(0x0 << 2)
+#define SW_TRAINING_PATTERN_SET_MASK		(0x3 << 0)
+#define SW_TRAINING_PATTERN_SET_PTN2		(0x2 << 0)
+#define SW_TRAINING_PATTERN_SET_PTN1		(0x1 << 0)
+#define SW_TRAINING_PATTERN_SET_NORMAL		(0x0 << 0)
+
+/* EXYNOS_DP_LN0_LINK_TRAINING_CTL */
+#define PRE_EMPHASIS_SET_SHIFT			(3)
+
+/* EXYNOS_DP_DEBUG_CTL */
+#define PLL_LOCK				(0x1 << 4)
+#define F_PLL_LOCK				(0x1 << 3)
+#define PLL_LOCK_CTRL				(0x1 << 2)
+#define PN_INV					(0x1 << 0)
+
+/* EXYNOS_DP_PLL_CTL */
+#define DP_PLL_PD				(0x1 << 7)
+#define DP_PLL_RESET				(0x1 << 6)
+#define DP_PLL_LOOP_BIT_DEFAULT			(0x1 << 4)
+#define DP_PLL_REF_BIT_1_1250V			(0x5 << 0)
+#define DP_PLL_REF_BIT_1_2500V			(0x7 << 0)
+
+/* EXYNOS_DP_PHY_PD */
+#define DP_PHY_PD				(0x1 << 5)
+#define AUX_PD					(0x1 << 4)
+#define CH3_PD					(0x1 << 3)
+#define CH2_PD					(0x1 << 2)
+#define CH1_PD					(0x1 << 1)
+#define CH0_PD					(0x1 << 0)
+
+/* EXYNOS_DP_PHY_TEST */
+#define MACRO_RST				(0x1 << 5)
+#define CH1_TEST				(0x1 << 1)
+#define CH0_TEST				(0x1 << 0)
+
+/* EXYNOS_DP_AUX_CH_STA */
+#define AUX_BUSY				(0x1 << 4)
+#define AUX_STATUS_MASK				(0xf << 0)
+
+/* EXYNOS_DP_AUX_CH_DEFER_CTL */
+#define DEFER_CTRL_EN				(0x1 << 7)
+#define DEFER_COUNT(x)				(((x) & 0x7f) << 0)
+
+/* EXYNOS_DP_AUX_RX_COMM */
+#define AUX_RX_COMM_I2C_DEFER			(0x2 << 2)
+#define AUX_RX_COMM_AUX_DEFER			(0x2 << 0)
+
+/* EXYNOS_DP_BUFFER_DATA_CTL */
+#define BUF_CLR					(0x1 << 7)
+#define BUF_DATA_COUNT(x)			(((x) & 0x1f) << 0)
+
+/* EXYNOS_DP_AUX_CH_CTL_1 */
+#define AUX_LENGTH(x)				(((x - 1) & 0xf) << 4)
+#define AUX_TX_COMM_MASK			(0xf << 0)
+#define AUX_TX_COMM_DP_TRANSACTION		(0x1 << 3)
+#define AUX_TX_COMM_I2C_TRANSACTION		(0x0 << 3)
+#define AUX_TX_COMM_MOT				(0x1 << 2)
+#define AUX_TX_COMM_WRITE			(0x0 << 0)
+#define AUX_TX_COMM_READ			(0x1 << 0)
+
+/* EXYNOS_DP_AUX_ADDR_7_0 */
+#define AUX_ADDR_7_0(x)				(((x) >> 0) & 0xff)
+
+/* EXYNOS_DP_AUX_ADDR_15_8 */
+#define AUX_ADDR_15_8(x)			(((x) >> 8) & 0xff)
+
+/* EXYNOS_DP_AUX_ADDR_19_16 */
+#define AUX_ADDR_19_16(x)			(((x) >> 16) & 0x0f)
+
+/* EXYNOS_DP_AUX_CH_CTL_2 */
+#define ADDR_ONLY				(0x1 << 1)
+#define AUX_EN					(0x1 << 0)
+
+/* EXYNOS_DP_SOC_GENERAL_CTL */
+#define AUDIO_MODE_SPDIF_MODE			(0x1 << 8)
+#define AUDIO_MODE_MASTER_MODE			(0x0 << 8)
+#define MASTER_VIDEO_INTERLACE_EN		(0x1 << 4)
+#define VIDEO_MASTER_CLK_SEL			(0x1 << 2)
+#define VIDEO_MASTER_MODE_EN			(0x1 << 1)
+#define VIDEO_MODE_MASK				(0x1 << 0)
+#define VIDEO_MODE_SLAVE_MODE			(0x1 << 0)
+#define VIDEO_MODE_MASTER_MODE			(0x0 << 0)
+
+#endif /* _EXYNOS_DP_REG_H */
diff -puN /dev/null include/video/exynos_dp.h
--- /dev/null
+++ a/include/video/exynos_dp.h
@@ -0,0 +1,131 @@
+/*
+ * Samsung SoC DP device support
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _EXYNOS_DP_H
+#define _EXYNOS_DP_H
+
+#define DP_TIMEOUT_LOOP_COUNT 100
+#define MAX_CR_LOOP 5
+#define MAX_EQ_LOOP 4
+
+enum link_rate_type {
+	LINK_RATE_1_62GBPS = 0x06,
+	LINK_RATE_2_70GBPS = 0x0a
+};
+
+enum link_lane_count_type {
+	LANE_COUNT1 = 1,
+	LANE_COUNT2 = 2,
+	LANE_COUNT4 = 4
+};
+
+enum link_training_state {
+	START,
+	CLOCK_RECOVERY,
+	EQUALIZER_TRAINING,
+	FINISHED,
+	FAILED
+};
+
+enum voltage_swing_level {
+	VOLTAGE_LEVEL_0,
+	VOLTAGE_LEVEL_1,
+	VOLTAGE_LEVEL_2,
+	VOLTAGE_LEVEL_3,
+};
+
+enum pre_emphasis_level {
+	PRE_EMPHASIS_LEVEL_0,
+	PRE_EMPHASIS_LEVEL_1,
+	PRE_EMPHASIS_LEVEL_2,
+	PRE_EMPHASIS_LEVEL_3,
+};
+
+enum pattern_set {
+	PRBS7,
+	D10_2,
+	TRAINING_PTN1,
+	TRAINING_PTN2,
+	DP_NONE
+};
+
+enum color_space {
+	COLOR_RGB,
+	COLOR_YCBCR422,
+	COLOR_YCBCR444
+};
+
+enum color_depth {
+	COLOR_6,
+	COLOR_8,
+	COLOR_10,
+	COLOR_12
+};
+
+enum color_coefficient {
+	COLOR_YCBCR601,
+	COLOR_YCBCR709
+};
+
+enum dynamic_range {
+	VESA,
+	CEA
+};
+
+enum pll_status {
+	PLL_UNLOCKED,
+	PLL_LOCKED
+};
+
+enum clock_recovery_m_value_type {
+	CALCULATED_M,
+	REGISTER_M
+};
+
+enum video_timing_recognition_type {
+	VIDEO_TIMING_FROM_CAPTURE,
+	VIDEO_TIMING_FROM_REGISTER
+};
+
+enum analog_power_block {
+	AUX_BLOCK,
+	CH0_BLOCK,
+	CH1_BLOCK,
+	CH2_BLOCK,
+	CH3_BLOCK,
+	ANALOG_TOTAL,
+	POWER_ALL
+};
+
+struct video_info {
+	char *name;
+
+	bool h_sync_polarity;
+	bool v_sync_polarity;
+	bool interlaced;
+
+	enum color_space color_space;
+	enum dynamic_range dynamic_range;
+	enum color_coefficient ycbcr_coeff;
+	enum color_depth color_depth;
+
+	enum link_rate_type link_rate;
+	enum link_lane_count_type lane_count;
+};
+
+struct exynos_dp_platdata {
+	struct video_info *video_info;
+
+	void (*phy_init)(void);
+	void (*phy_exit)(void);
+};
+
+#endif /* _EXYNOS_DP_H */
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch

