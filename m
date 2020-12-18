Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A419BC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 18:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7770A23B6C
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 18:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgLRSKs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgLRSKs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 13:10:48 -0500
Date:   Fri, 18 Dec 2020 10:10:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608315007;
        bh=ArM3dwfvbxzX4gG32s7rIwcY8np+R86TTTHDw4CmtEI=;
        h=From:To:Subject:From;
        b=LxlWSzE0AzQTaBtJVBdX4WFirpCgHlG2tFGcetusAgG2hNgu37qryelhEYU1thJ6y
         MCYBxjwh7UEjPcuZk8Xw97VtouHnNH5EGYi+paPn+FcOmejew4bFNT6BedS/Cc37xF
         0NljAVQ/5I6gxwqSKUfbVOuILlUtSFwPYMsk4E4s=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20201218181006.w0-98fJW6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                           |    3 ---
 drivers/scsi/mpt3sas/mpt3sas_base.c   |    4 ----
 drivers/scsi/ufs/ufs-mediatek-trace.h |    4 ----
 drivers/scsi/ufs/ufs-mediatek.c       |    6 ------
 drivers/scsi/ufs/ufs-mediatek.h       |    3 ---
 drivers/scsi/ufs/ufshcd.c             |    8 --------
 drivers/scsi/ufs/ufshcd.h             |   11 -----------
 include/linux/sunrpc/xdr.h            |    4 ----
 8 files changed, 43 deletions(-)

--- a/include/linux/sunrpc/xdr.h~linux-next-git-rejects
+++ a/include/linux/sunrpc/xdr.h
@@ -183,12 +183,8 @@ xdr_adjust_iovec(struct kvec *iov, __be3
  */
 extern void xdr_shift_buf(struct xdr_buf *, size_t);
 extern void xdr_buf_from_iov(const struct kvec *, struct xdr_buf *);
-<<<<<<< HEAD
-extern int xdr_buf_subsegment(const struct xdr_buf *, struct xdr_buf *, unsigned int, unsigned int);
-=======
 extern int xdr_buf_subsegment(const struct xdr_buf *buf, struct xdr_buf *subbuf,
 			      unsigned int base, unsigned int len);
->>>>>>> linux-next/akpm-base
 extern void xdr_buf_trim(struct xdr_buf *, unsigned int);
 extern int read_bytes_from_xdr_buf(const struct xdr_buf *, unsigned int, void *, unsigned int);
 extern int write_bytes_to_xdr_buf(const struct xdr_buf *, unsigned int, void *, unsigned int);
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c~linux-next-git-rejects
+++ a/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5034,11 +5034,7 @@ _base_check_for_trigger_pages_support(st
 static void
 _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
-<<<<<<< HEAD
-	u16 trigger_flags;
-=======
 	int trigger_flags;
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * Default setting of master trigger.
--- a/drivers/scsi/ufs/ufshcd.c~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -8760,11 +8760,7 @@ set_link_active:
 	 * further below.
 	 */
 	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
-<<<<<<< HEAD
-		ufshcd_vops_device_reset(hba);
-=======
 		ufshcd_device_reset(hba);
->>>>>>> linux-next/akpm-base
 		WARN_ON(!ufshcd_is_link_off(hba));
 	}
 	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
@@ -8774,11 +8770,7 @@ set_link_active:
 set_dev_active:
 	/* Can also get here needing to exit DeepSleep */
 	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
-<<<<<<< HEAD
-		ufshcd_vops_device_reset(hba);
-=======
 		ufshcd_device_reset(hba);
->>>>>>> linux-next/akpm-base
 		ufshcd_host_reset_and_restore(hba);
 	}
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
--- a/drivers/scsi/ufs/ufshcd.h~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufshcd.h
@@ -1220,21 +1220,10 @@ static inline void ufshcd_vops_dbg_regis
 
 static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
 {
-<<<<<<< HEAD
-	if (hba->vops && hba->vops->device_reset) {
-		int err = hba->vops->device_reset(hba);
-
-		if (!err)
-			ufshcd_set_ufs_dev_active(hba);
-		if (err != -EOPNOTSUPP)
-			ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
-	}
-=======
 	if (hba->vops && hba->vops->device_reset)
 		return hba->vops->device_reset(hba);
 
 	return -EOPNOTSUPP;
->>>>>>> linux-next/akpm-base
 }
 
 static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
--- a/drivers/scsi/ufs/ufs-mediatek.c~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufs-mediatek.c
@@ -68,8 +68,6 @@ static bool ufs_mtk_is_va09_supported(st
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
-<<<<<<< HEAD
-=======
 }
 
 static bool ufs_mtk_is_broken_vcc(struct ufs_hba *hba)
@@ -77,7 +75,6 @@ static bool ufs_mtk_is_broken_vcc(struct
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
->>>>>>> linux-next/akpm-base
 }
 
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
@@ -524,12 +521,9 @@ static void ufs_mtk_init_host_caps(struc
 	if (of_property_read_bool(np, "mediatek,ufs-disable-ah8"))
 		host->caps |= UFS_MTK_CAP_DISABLE_AH8;
 
-<<<<<<< HEAD
-=======
 	if (of_property_read_bool(np, "mediatek,ufs-broken-vcc"))
 		host->caps |= UFS_MTK_CAP_BROKEN_VCC;
 
->>>>>>> linux-next/akpm-base
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
--- a/drivers/scsi/ufs/ufs-mediatek.h~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufs-mediatek.h
@@ -81,10 +81,7 @@ enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_BOOST_CRYPT_ENGINE         = 1 << 0,
 	UFS_MTK_CAP_VA09_PWR_CTRL              = 1 << 1,
 	UFS_MTK_CAP_DISABLE_AH8                = 1 << 2,
-<<<<<<< HEAD
-=======
 	UFS_MTK_CAP_BROKEN_VCC                 = 1 << 3,
->>>>>>> linux-next/akpm-base
 };
 
 struct ufs_mtk_crypt_cfg {
--- a/drivers/scsi/ufs/ufs-mediatek-trace.h~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufs-mediatek-trace.h
@@ -31,10 +31,6 @@ TRACE_EVENT(ufs_mtk_event,
 
 #undef TRACE_INCLUDE_PATH
 #undef TRACE_INCLUDE_FILE
-<<<<<<< HEAD
-#define TRACE_INCLUDE_PATH .
-=======
 #define TRACE_INCLUDE_PATH ../../drivers/scsi/ufs/
->>>>>>> linux-next/akpm-base
 #define TRACE_INCLUDE_FILE ufs-mediatek-trace
 #include <trace/define_trace.h>
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -2149,10 +2149,7 @@ F:	Documentation/devicetree/bindings/arm
 F:	Documentation/devicetree/bindings/gpio/mstar,msc313-gpio.yaml
 F:	arch/arm/boot/dts/mstar-*
 F:	arch/arm/mach-mstar/
-<<<<<<< HEAD
-=======
 F:	drivers/gpio/gpio-msc313.c
->>>>>>> linux-next/akpm-base
 F:	include/dt-bindings/gpio/msc313-gpio.h
 
 ARM/NEC MOBILEPRO 900/c MACHINE SUPPORT
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

