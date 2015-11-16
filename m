From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 16 Nov 2015 12:24:19 -0800
Message-ID: <564a3b73.JCXxEj6kNJHehaLo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbKPUYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Nov 2015 15:24:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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

 arch/arm/mach-pxa/palm27x.c                |    4 ----
 arch/arm/mach-pxa/palmtc.c                 |    4 ----
 arch/arm64/boot/dts/marvell/berlin4ct.dtsi |    3 ---
 drivers/soc/Kconfig                        |    3 ---
 drivers/soc/Makefile                       |    3 ---
 drivers/soc/ti/knav_qmss_queue.c           |    6 ------
 fs/direct-io.c                             |   10 ----------
 include/linux/fs.h                         |    3 ---
 8 files changed, 36 deletions(-)

diff -puN arch/arm/mach-pxa/palm27x.c~linux-next-git-rejects arch/arm/mach-pxa/palm27x.c
--- a/arch/arm/mach-pxa/palm27x.c~linux-next-git-rejects
+++ a/arch/arm/mach-pxa/palm27x.c
@@ -344,11 +344,7 @@ void __init palm27x_pwm_init(int bl, int
 {
 	palm_bl_power	= bl;
 	palm_lcd_power	= lcd;
-<<<<<<< HEAD
-	pwm_add_lookup(palm27x_pwm_lookup, ARRAY_SIZE(palm27x_pwm_lookup));
-=======
 	pwm_add_table(palm27x_pwm_lookup, ARRAY_SIZE(palm27x_pwm_lookup));
->>>>>>> linux-next/akpm-base
 	platform_device_register(&palm27x_backlight);
 }
 #endif
diff -puN arch/arm/mach-pxa/palmtc.c~linux-next-git-rejects arch/arm/mach-pxa/palmtc.c
--- a/arch/arm/mach-pxa/palmtc.c~linux-next-git-rejects
+++ a/arch/arm/mach-pxa/palmtc.c
@@ -169,11 +169,7 @@ static inline void palmtc_keys_init(void
 #if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM_MODULE)
 static struct pwm_lookup palmtc_pwm_lookup[] = {
 	PWM_LOOKUP("pxa25x-pwm.1", 0, "pwm-backlight.0", NULL, PALMTC_PERIOD_NS,
-<<<<<<< HEAD
-		   PWM_PERIOD_NORMAL),
-=======
 		   PWM_POLARITY_NORMAL),
->>>>>>> linux-next/akpm-base
 };
 
 static struct platform_pwm_backlight_data palmtc_backlight_data = {
diff -puN arch/arm64/boot/dts/marvell/berlin4ct.dtsi~linux-next-git-rejects arch/arm64/boot/dts/marvell/berlin4ct.dtsi
--- a/arch/arm64/boot/dts/marvell/berlin4ct.dtsi~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/marvell/berlin4ct.dtsi
@@ -225,8 +225,6 @@
 			};
 		};
 
-<<<<<<< HEAD
-=======
 		soc_pinctrl: pin-controller@ea8000 {
 			compatible = "marvell,berlin4ct-soc-pinctrl";
 			reg = <0xea8000 0x14>;
@@ -237,7 +235,6 @@
 			reg = <0xea8400 0x8>;
 		};
 
->>>>>>> linux-next/akpm-base
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
diff -puN drivers/soc/Kconfig~linux-next-git-rejects drivers/soc/Kconfig
--- a/drivers/soc/Kconfig~linux-next-git-rejects
+++ a/drivers/soc/Kconfig
@@ -4,10 +4,7 @@ source "drivers/soc/brcmstb/Kconfig"
 source "drivers/soc/mediatek/Kconfig"
 source "drivers/soc/qcom/Kconfig"
 source "drivers/soc/rockchip/Kconfig"
-<<<<<<< HEAD
-=======
 source "drivers/soc/samsung/Kconfig"
->>>>>>> linux-next/akpm-base
 source "drivers/soc/sunxi/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
diff -puN drivers/soc/Makefile~linux-next-git-rejects drivers/soc/Makefile
--- a/drivers/soc/Makefile~linux-next-git-rejects
+++ a/drivers/soc/Makefile
@@ -6,10 +6,7 @@ obj-$(CONFIG_SOC_BRCMSTB)	+= brcmstb/
 obj-$(CONFIG_MACH_DOVE)		+= dove/
 obj-$(CONFIG_ARCH_MEDIATEK)	+= mediatek/
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_SOC_SAMSUNG)	+= samsung/
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
 obj-$(CONFIG_ARCH_SUNXI)	+= sunxi/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
diff -puN drivers/soc/ti/knav_qmss_queue.c~linux-next-git-rejects drivers/soc/ti/knav_qmss_queue.c
--- a/drivers/soc/ti/knav_qmss_queue.c~linux-next-git-rejects
+++ a/drivers/soc/ti/knav_qmss_queue.c
@@ -1519,15 +1519,9 @@ static int knav_queue_load_pdsp(struct k
 
 	for (i = 0; i < ARRAY_SIZE(knav_acc_firmwares); i++) {
 		if (knav_acc_firmwares[i]) {
-<<<<<<< HEAD
-			ret = request_firmware(&fw,
-					       knav_acc_firmwares[i],
-					       kdev->dev);
-=======
 			ret = request_firmware_direct(&fw,
 						      knav_acc_firmwares[i],
 						      kdev->dev);
->>>>>>> linux-next/akpm-base
 			if (!ret) {
 				found = true;
 				break;
diff -puN fs/direct-io.c~linux-next-git-rejects fs/direct-io.c
--- a/fs/direct-io.c~linux-next-git-rejects
+++ a/fs/direct-io.c
@@ -399,24 +399,14 @@ static inline void dio_bio_submit(struct
 	if (dio->is_async && dio->rw == READ && dio->should_dirty)
 		bio_set_pages_dirty(bio);
 
-<<<<<<< HEAD
-	dio->bio_bdev = bio->bi_bdev;
-
-=======
->>>>>>> linux-next/akpm-base
 	if (sdio->submit_io) {
 		sdio->submit_io(dio->rw, bio, dio->inode,
 			       sdio->logical_offset_in_bio);
 		dio->bio_cookie = BLK_QC_T_NONE;
-<<<<<<< HEAD
-	} else
-		dio->bio_cookie = submit_bio(dio->rw, bio);
-=======
 	} else {
 		dio->bio_cookie = submit_bio(dio->rw, bio);
 		dio->bio_bdev = bio->bi_bdev;
 	}
->>>>>>> linux-next/akpm-base
 
 	sdio->bio = NULL;
 	sdio->boundary = 0;
diff -puN include/linux/fs.h~linux-next-git-rejects include/linux/fs.h
--- a/include/linux/fs.h~linux-next-git-rejects
+++ a/include/linux/fs.h
@@ -1682,10 +1682,7 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
-<<<<<<< HEAD
-=======
 	int (*set_richacl)(struct inode *, struct richacl *);
->>>>>>> linux-next/akpm-base
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

