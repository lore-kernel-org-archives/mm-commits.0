Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30F81B7E9
	for <mm-commits@vger.kernel.org>; Sat,  7 Sep 2024 03:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725679338; cv=none; b=tK/MxAQnnDzHQh6tKRjt8B8HiHapd/u6qyOXlwe7pqGZwV8xJOlVcTItC6SgEPMab36qmL0H9g7590r1OC6HdR0jAOmu3oB9M+AtTA3jogRBlXGtvJ96GgDlsbhOF7k+x+ygWNqSUlpVpmIn9sKQD0jI+TwiXlWd9SmOOLb2aws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725679338; c=relaxed/simple;
	bh=uGLnSbpBMqzP26SJDkhPLJCy1qXWS79HpSWc7aS1JSw=;
	h=Date:To:From:Subject:Message-Id; b=hkt/cFjN1eOY5nAkXJtW+TeMwOo9mAL46fi5SewCV6ygpGChRYcls3Y7c7qyBkz6+AL01tHdqCDLiWua7KBr07dMtl/Nb9wxBON2H1Wpcxsr6dPbvhNty1pzAhudSJTf+oCIwKOx/H5UTSMCRPveTaNQyShL7ixqeNN4JgCEc1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JDqOwucr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JDqOwucr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E207C4CEC4;
	Sat,  7 Sep 2024 03:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725679338;
	bh=uGLnSbpBMqzP26SJDkhPLJCy1qXWS79HpSWc7aS1JSw=;
	h=Date:To:From:Subject:From;
	b=JDqOwucrfWX78FJIbK1YBX3v7u/M6sDslOrcXcDmgTkSz1Mmtrtf+vs+JkPs2X/rY
	 QM1FsWjerMyszTLKwZ03pdOIixd/+g3ZAqQUe6aFVZSz2toZ41DSN43mU6Wrj7ecUq
	 LsDfw5CImn2Sgju7HFugNIDQzh5zlVTxwoH7V6JU=
Date: Fri, 06 Sep 2024 20:22:17 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + treewide-correct-the-typo-retun.patch added to mm-nonmm-unstable branch
Message-Id: <20240907032218.3E207C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: treewide: correct the typo 'retun'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     treewide-correct-the-typo-retun.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/treewide-correct-the-typo-retun.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

treewide-correct-the-typo-retun.patch

