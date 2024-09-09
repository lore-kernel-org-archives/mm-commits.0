Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55EA73440
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925702; cv=none; b=RiOXfhF2mdasRU/lj+j4frvI2gO8QgzC98k9K7ZZVnlp9LAP6kVoYsaI6qAJDf/uYnhCbT+e5N8hQ+nqNBoJSlHqbdATDA28aoe53kRTi/jgmS+0v9F4l2Mju9yfZuCM4Qzvr76uDRf+RMSPVKIeOzehzJOTPcMPzvHHwXsv5vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925702; c=relaxed/simple;
	bh=cF4ODNpWZlS3lVkQg5WGbEni9aYRdSAOOXIb5leOUXk=;
	h=Date:To:From:Subject:Message-Id; b=fifLgA2gSUiIAwhXripxNB69zntCghxx7/KIQOd5SgJIItIFBzNpXWDj5fZ+atUgtX7J2A1KT9S7r5u7LVhDMDWgWq7jfWngktykJP9tfcpFYHZqOw3WLMukzCjrQRSQfif9eDVBqwt9VQ8sHlDooqI4MY2Pu2cmDQv3GqeHCaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ItrcEPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ItrcEPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75747C4CEC5;
	Mon,  9 Sep 2024 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925701;
	bh=cF4ODNpWZlS3lVkQg5WGbEni9aYRdSAOOXIb5leOUXk=;
	h=Date:To:From:Subject:From;
	b=1ItrcEPjRVoCn0VlCegzemjYBnjpLVTWUpDJoFVZs+8uztBinW0iGNIKBtmqlc5af
	 s+7XRP1xd+U1ZVpKOsnjMAP+b9yjcZd+AiLWZKE0zU/N1BW37xk8Pv2oDVU2FHx3n2
	 QXXYBOMm4bYXz1pgtBXM2LC+Iz/LMt9uqXoBBd3c=
Date: Mon, 09 Sep 2024 16:48:20 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] treewide-correct-the-typo-retun.patch removed from -mm tree
Message-Id: <20240909234821.75747C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: correct the typo 'retun'
has been removed from the -mm tree.  Its filename was
     treewide-correct-the-typo-retun.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: treewide: correct the typo 'retun'
Date: Fri, 6 Sep 2024 13:40:08 +0800

There are some spelling mistakes of 'retun' in comments which
should be instead of 'return'.

Link: https://lkml.kernel.org/r/63D0F870EE8E87A0+20240906054008.390188-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/omap-mpuss-lowpower.c |    2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.h  |    2 +-
 drivers/infiniband/core/sa_query.c        |    2 +-
 drivers/input/misc/wistron_btns.c         |    2 +-
 drivers/mtd/nand/raw/nandsim.c            |    2 +-
 drivers/scsi/bfa/bfa_fcs.c                |    2 +-
 drivers/scsi/pmcraid.c                    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c~treewide-correct-the-typo-retun
+++ a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -333,7 +333,7 @@ int omap4_hotplug_cpu(unsigned int cpu,
 	omap_pm_ops.scu_prepare(cpu, power_state);
 
 	/*
-	 * CPU never retuns back if targeted power state is OFF mode.
+	 * CPU never returns back if targeted power state is OFF mode.
 	 * CPU ONLINE follows normal CPU ONLINE ptah via
 	 * omap4_secondary_startup().
 	 */
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.h~treewide-correct-the-typo-retun
+++ a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.h
@@ -231,7 +231,7 @@ struct dpu_crtc_state {
 	container_of(x, struct dpu_crtc_state, base)
 
 /**
- * dpu_crtc_frame_pending - retun the number of pending frames
+ * dpu_crtc_frame_pending - return the number of pending frames
  * @crtc: Pointer to drm crtc object
  */
 static inline int dpu_crtc_frame_pending(struct drm_crtc *crtc)
--- a/drivers/infiniband/core/sa_query.c~treewide-correct-the-typo-retun
+++ a/drivers/infiniband/core/sa_query.c
@@ -1420,7 +1420,7 @@ enum opa_pr_supported {
 /*
  * opa_pr_query_possible - Check if current PR query can be an OPA query.
  *
- * Retuns PR_NOT_SUPPORTED if a path record query is not
+ * Returns PR_NOT_SUPPORTED if a path record query is not
  * possible, PR_OPA_SUPPORTED if an OPA path record query
  * is possible and PR_IB_SUPPORTED if an IB path record
  * query is possible.
--- a/drivers/input/misc/wistron_btns.c~treewide-correct-the-typo-retun
+++ a/drivers/input/misc/wistron_btns.c
@@ -1075,7 +1075,7 @@ static void wistron_led_init(struct devi
 	}
 
 	if (leds_present & FE_MAIL_LED) {
-		/* bios_get_default_setting(MAIL) always retuns 0, so just turn the led off */
+		/* bios_get_default_setting(MAIL) always returns 0, so just turn the led off */
 		wistron_mail_led.brightness = LED_OFF;
 		if (led_classdev_register(parent, &wistron_mail_led))
 			leds_present &= ~FE_MAIL_LED;
--- a/drivers/mtd/nand/raw/nandsim.c~treewide-correct-the-typo-retun
+++ a/drivers/mtd/nand/raw/nandsim.c
@@ -1381,7 +1381,7 @@ static inline union ns_mem *NS_GET_PAGE(
 }
 
 /*
- * Retuns a pointer to the current byte, within the current page.
+ * Returns a pointer to the current byte, within the current page.
  */
 static inline u_char *NS_PAGE_BYTE_OFF(struct nandsim *ns)
 {
--- a/drivers/scsi/bfa/bfa_fcs.c~treewide-correct-the-typo-retun
+++ a/drivers/scsi/bfa/bfa_fcs.c
@@ -1431,7 +1431,7 @@ bfa_cb_lps_flogo_comp(void *bfad, void *
  *	param[in]	vf_id - VF_ID
  *
  *	return
- *	If lookup succeeds, retuns fcs vf object, otherwise returns NULL
+ *	If lookup succeeds, returns fcs vf object, otherwise returns NULL
  */
 bfa_fcs_vf_t   *
 bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id)
--- a/drivers/scsi/pmcraid.c~treewide-correct-the-typo-retun
+++ a/drivers/scsi/pmcraid.c
@@ -4009,7 +4009,7 @@ static void pmcraid_tasklet_function(uns
  * This routine un-registers registered interrupt handler and
  * also frees irqs/vectors.
  *
- * Retun Value
+ * Return Value
  *	None
  */
 static
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


