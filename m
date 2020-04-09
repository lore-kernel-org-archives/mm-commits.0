From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 08 Apr 2020 17:08:17 -0700
Message-ID: <20200409000817.s7x1Fw7oz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgDIAIS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c |   81 ----------
 drivers/leds/Makefile                               |    3 
 drivers/thermal/imx_sc_thermal.c                    |    6 
 3 files changed, 90 deletions(-)

--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -69,19 +69,6 @@ enum mod_hdcp_status mod_hdcp_remove_dis
 
 	psp_dtm_invoke(psp, dtm_cmd->cmd_id);
 
-<<<<<<< HEAD
-	if (dtm_cmd->dtm_status != TA_DTM_STATUS__SUCCESS)
-		return MOD_HDCP_STATUS_UPDATE_TOPOLOGY_FAILURE;
-
-	display->state = MOD_HDCP_DISPLAY_ACTIVE;
-	HDCP_TOP_REMOVE_DISPLAY_TRACE(hdcp, display->index);
- 
- 	return MOD_HDCP_STATUS_SUCCESS;
- 
-}
-enum mod_hdcp_status mod_hdcp_add_display_to_topology(struct mod_hdcp *hdcp,
-						      uint8_t index)
-=======
 	if (dtm_cmd->dtm_status != TA_DTM_STATUS__SUCCESS) {
 		status = MOD_HDCP_STATUS_UPDATE_TOPOLOGY_FAILURE;
 	} else {
@@ -94,7 +81,6 @@ enum mod_hdcp_status mod_hdcp_add_displa
 }
 enum mod_hdcp_status mod_hdcp_add_display_to_topology(struct mod_hdcp *hdcp,
 					       struct mod_hdcp_display *display)
->>>>>>> linux-next/akpm-base
 {
 	struct psp_context *psp = hdcp->config.psp.handle;
 	struct ta_dtm_shared_memory *dtm_cmd;
@@ -133,15 +119,6 @@ enum mod_hdcp_status mod_hdcp_add_displa
 
 	psp_dtm_invoke(psp, dtm_cmd->cmd_id);
 
-<<<<<<< HEAD
-	if (dtm_cmd->dtm_status != TA_DTM_STATUS__SUCCESS)
-		return MOD_HDCP_STATUS_UPDATE_TOPOLOGY_FAILURE;
-
-	display->state = MOD_HDCP_DISPLAY_ACTIVE_AND_ADDED;
-	HDCP_TOP_ADD_DISPLAY_TRACE(hdcp, display->index);
-
-	return MOD_HDCP_STATUS_SUCCESS;
-=======
 	if (dtm_cmd->dtm_status != TA_DTM_STATUS__SUCCESS) {
 		display->state = MOD_HDCP_DISPLAY_INACTIVE;
 		status = MOD_HDCP_STATUS_UPDATE_TOPOLOGY_FAILURE;
@@ -151,7 +128,6 @@ enum mod_hdcp_status mod_hdcp_add_displa
 
 	mutex_unlock(&psp->dtm_context.mutex);
 	return status;
->>>>>>> linux-next/akpm-base
 }
 
 enum mod_hdcp_status mod_hdcp_hdcp1_create_session(struct mod_hdcp *hdcp)
@@ -210,20 +186,6 @@ enum mod_hdcp_status mod_hdcp_hdcp1_dest
 
 	psp_hdcp_invoke(psp, hdcp_cmd->cmd_id);
 
-<<<<<<< HEAD
-	if (hdcp_cmd->hdcp_status != TA_HDCP_STATUS__SUCCESS)
-		return MOD_HDCP_STATUS_HDCP1_DESTROY_SESSION_FAILURE;
-
-	HDCP_TOP_HDCP1_DESTROY_SESSION_TRACE(hdcp);
-	for (i = 0; i < MAX_NUM_OF_DISPLAYS; i++)
-		if (is_display_encryption_enabled(
-				&hdcp->displays[i])) {
-			hdcp->displays[i].state =
-					MOD_HDCP_DISPLAY_ACTIVE_AND_ADDED;
-			HDCP_HDCP1_DISABLED_TRACE(hdcp,
-					hdcp->displays[i].index);
-		}
-=======
 	if (hdcp_cmd->hdcp_status != TA_HDCP_STATUS__SUCCESS) {
 		status = MOD_HDCP_STATUS_HDCP1_DESTROY_SESSION_FAILURE;
 	} else {
@@ -236,7 +198,6 @@ enum mod_hdcp_status mod_hdcp_hdcp1_dest
 					hdcp, hdcp->displays[i].index);
 			}
 	}
->>>>>>> linux-next/akpm-base
 
 	mutex_unlock(&psp->hdcp_context.mutex);
 	return status;
@@ -287,12 +248,8 @@ enum mod_hdcp_status mod_hdcp_hdcp1_enab
 {
 	struct psp_context *psp = hdcp->config.psp.handle;
 	struct ta_hdcp_shared_memory *hdcp_cmd;
-<<<<<<< HEAD
-	struct mod_hdcp_display *display = get_first_added_display(hdcp);
-=======
 	struct mod_hdcp_display *display = get_first_active_display(hdcp);
 	enum mod_hdcp_status status = MOD_HDCP_STATUS_SUCCESS;
->>>>>>> linux-next/akpm-base
 
 	mutex_lock(&psp->hdcp_context.mutex);
 	hdcp_cmd = (struct ta_hdcp_shared_memory *)psp->hdcp_context.hdcp_shared_buf;
@@ -368,14 +325,8 @@ enum mod_hdcp_status mod_hdcp_hdcp1_enab
 
 	for (i = 0; i < MAX_NUM_OF_DISPLAYS; i++) {
 
-<<<<<<< HEAD
-		if (hdcp->displays[i].state != MOD_HDCP_DISPLAY_ACTIVE_AND_ADDED ||
-		    hdcp->displays[i].adjust.disable)
-			continue;
-=======
 		if (hdcp->displays[i].adjust.disable || hdcp->displays[i].state != MOD_HDCP_DISPLAY_ACTIVE)
 				continue;
->>>>>>> linux-next/akpm-base
 
 		memset(hdcp_cmd, 0, sizeof(struct ta_hdcp_shared_memory));
 
@@ -441,13 +392,9 @@ enum mod_hdcp_status mod_hdcp_hdcp2_crea
 {
 	struct psp_context *psp = hdcp->config.psp.handle;
 	struct ta_hdcp_shared_memory *hdcp_cmd;
-<<<<<<< HEAD
-	struct mod_hdcp_display *display = get_first_added_display(hdcp);
-=======
 	struct mod_hdcp_display *display = get_first_active_display(hdcp);
 	enum mod_hdcp_status status = MOD_HDCP_STATUS_SUCCESS;
 
->>>>>>> linux-next/akpm-base
 
 	if (!psp->hdcp_context.hdcp_initialized) {
 		DRM_ERROR("Failed to create hdcp session, HDCP TA is not initialized");
@@ -504,20 +451,6 @@ enum mod_hdcp_status mod_hdcp_hdcp2_dest
 
 	psp_hdcp_invoke(psp, hdcp_cmd->cmd_id);
 
-<<<<<<< HEAD
-	if (hdcp_cmd->hdcp_status != TA_HDCP_STATUS__SUCCESS)
-		return MOD_HDCP_STATUS_HDCP2_DESTROY_SESSION_FAILURE;
-
-	HDCP_TOP_HDCP2_DESTROY_SESSION_TRACE(hdcp);
-	for (i = 0; i < MAX_NUM_OF_DISPLAYS; i++)
-		if (is_display_encryption_enabled(
-				&hdcp->displays[i])) {
-			hdcp->displays[i].state =
-					MOD_HDCP_DISPLAY_ACTIVE_AND_ADDED;
-			HDCP_HDCP2_DISABLED_TRACE(hdcp,
-					hdcp->displays[i].index);
-		}
-=======
 	if (hdcp_cmd->hdcp_status != TA_HDCP_STATUS__SUCCESS) {
 		status = MOD_HDCP_STATUS_HDCP2_DESTROY_SESSION_FAILURE;
 	} else {
@@ -530,7 +463,6 @@ enum mod_hdcp_status mod_hdcp_hdcp2_dest
 					hdcp, hdcp->displays[i].index);
 			}
 	}
->>>>>>> linux-next/akpm-base
 
 	mutex_unlock(&psp->hdcp_context.mutex);
 	return status;
@@ -789,15 +721,8 @@ enum mod_hdcp_status mod_hdcp_hdcp2_enab
 {
 	struct psp_context *psp = hdcp->config.psp.handle;
 	struct ta_hdcp_shared_memory *hdcp_cmd;
-<<<<<<< HEAD
-	struct mod_hdcp_display *display = get_first_added_display(hdcp);
-
-	hdcp_cmd = (struct ta_hdcp_shared_memory *)psp->hdcp_context.hdcp_shared_buf;
-	memset(hdcp_cmd, 0, sizeof(struct ta_hdcp_shared_memory));
-=======
 	struct mod_hdcp_display *display = get_first_active_display(hdcp);
 	enum mod_hdcp_status status = MOD_HDCP_STATUS_SUCCESS;
->>>>>>> linux-next/akpm-base
 
 	if (!display)
 		return MOD_HDCP_STATUS_DISPLAY_NOT_FOUND;
@@ -892,15 +817,9 @@ enum mod_hdcp_status mod_hdcp_hdcp2_enab
 
 
 	for (i = 0; i < MAX_NUM_OF_DISPLAYS; i++) {
-<<<<<<< HEAD
-		if (hdcp->displays[i].state != MOD_HDCP_DISPLAY_ACTIVE_AND_ADDED ||
-		    hdcp->displays[i].adjust.disable)
-			continue;
-=======
 		if (hdcp->displays[i].adjust.disable || hdcp->displays[i].state != MOD_HDCP_DISPLAY_ACTIVE)
 				continue;
 
->>>>>>> linux-next/akpm-base
 		hdcp_cmd->in_msg.hdcp2_enable_dp_stream_encryption.display_handle = hdcp->displays[i].index;
 		hdcp_cmd->in_msg.hdcp2_enable_dp_stream_encryption.session_handle = hdcp->auth.id;
 
--- a/drivers/leds/Makefile~linux-next-git-rejects
+++ a/drivers/leds/Makefile
@@ -83,10 +83,7 @@ obj-$(CONFIG_LEDS_TCA6507)		+= leds-tca6
 obj-$(CONFIG_LEDS_TI_LMU_COMMON)	+= leds-ti-lmu-common.o
 obj-$(CONFIG_LEDS_TLC591XX)		+= leds-tlc591xx.o
 obj-$(CONFIG_LEDS_TPS6105X)		+= leds-tps6105x.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_LEDS_TURRIS_OMNIA)		+= leds-turris-omnia.o
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
--- a/drivers/thermal/imx_sc_thermal.c~linux-next-git-rejects
+++ a/drivers/thermal/imx_sc_thermal.c
@@ -14,10 +14,7 @@
 #include <linux/thermal.h>
 
 #include "thermal_core.h"
-<<<<<<< HEAD
-=======
 #include "thermal_hwmon.h"
->>>>>>> linux-next/akpm-base
 
 #define IMX_SC_MISC_FUNC_GET_TEMP	13
 
@@ -119,12 +116,9 @@ static int imx_sc_thermal_probe(struct p
 			ret = PTR_ERR(sensor->tzd);
 			break;
 		}
-<<<<<<< HEAD
-=======
 
 		if (devm_thermal_add_hwmon_sysfs(sensor->tzd))
 			dev_warn(&pdev->dev, "failed to add hwmon sysfs attributes\n");
->>>>>>> linux-next/akpm-base
 	}
 
 	of_node_put(sensor_np);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
