Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E048C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiATCJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358212AbiATCJj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E25C061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:09:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1B08615C2
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15621C004E1;
        Thu, 20 Jan 2022 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644578;
        bh=1sakeix1HC6ExCYmAqhDce0Rpnr2fkZrOPjqzGufBFY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iJ0yYjkYUg5hTif5u4Oo1ihsFgeDaAPZwJi8xNzFRk4+oLnlYes6X/5hydoDSp4fz
         Xst0/JrO1i3jOBxG5Dw2h/HHSmPCGNGiGZJ8cDGWxkbXq4DGZEM6cncFMrQRVDzgT8
         +ujgBTvc01mH9sJ8SXd392FBVDpZCVQE2jqVOpxo=
Date:   Wed, 19 Jan 2022 18:09:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 36/55] const_structs.checkpatch: add frequently
 used ops structs
Message-ID: <20220120020937.2_yApths9%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: const_structs.checkpatch: add frequently used ops structs

Add commonly used structs (>50 instances) which are always or almost
always const.

Link: https://lkml.kernel.org/r/20211127101134.33101-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-frequently-used-ops-structs
+++ a/scripts/const_structs.checkpatch
@@ -12,19 +12,27 @@ driver_info
 drm_connector_funcs
 drm_encoder_funcs
 drm_encoder_helper_funcs
+dvb_frontend_ops
+dvb_tuner_ops
 ethtool_ops
 extent_io_ops
+fb_ops
 file_lock_operations
 file_operations
 hv_ops
+hwmon_ops
+ib_device_ops
 ide_dma_ops
 ide_port_ops
+ieee80211_ops
+iio_buffer_setup_ops
 inode_operations
 intel_dvo_dev_ops
 irq_domain_ops
 item_operations
 iwl_cfg
 iwl_ops
+kernel_param_ops
 kgdb_arch
 kgdb_io
 kset_uevent_ops
@@ -32,25 +40,33 @@ lock_manager_operations
 machine_desc
 microcode_ops
 mlxsw_reg_info
+mtd_ooblayout_ops
 mtrr_ops
+nand_controller_ops
 neigh_ops
 net_device_ops
+nft_expr_ops
 nlmsvc_binding
 nvkm_device_chip
 of_device_id
 pci_raw_ops
 phy_ops
+pinconf_ops
 pinctrl_ops
 pinmux_ops
 pipe_buf_operations
 platform_hibernation_ops
 platform_suspend_ops
+proc_ops
 proto_ops
+pwm_ops
 regmap_access_table
 regulator_ops
+reset_control_ops
 rpc_pipe_ops
 rtc_class_ops
 sd_desc
+sdhci_ops
 seq_operations
 sirfsoc_padmux
 snd_ac97_build_ops
@@ -67,6 +83,13 @@ uart_ops
 usb_mon_operations
 v4l2_ctrl_ops
 v4l2_ioctl_ops
+v4l2_subdev_core_ops
+v4l2_subdev_internal_ops
+v4l2_subdev_ops
+v4l2_subdev_pad_ops
+v4l2_subdev_video_ops
+vb2_ops
 vm_operations_struct
 wacom_features
+watchdog_ops
 wd_ops
_
