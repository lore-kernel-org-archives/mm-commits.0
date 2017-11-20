From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:22:25 -0800
Message-ID: <20171120212225.uCmcQgC5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752935AbdKTVW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:22:27 -0500
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

 Documentation/devicetree/bindings/mtd/jedec,spi-nor.txt |    3 
 arch/parisc/include/uapi/asm/mman.h                     |    4 -
 drivers/firmware/qcom_scm.c                             |    3 
 drivers/soc/amlogic/meson-gx-pwrc-vpu.c                 |   40 ----------
 include/linux/iomap.h                                   |    4 -
 include/linux/platform_data/mtd-nand-omap2.h            |   20 -----
 6 files changed, 74 deletions(-)

diff -puN arch/parisc/include/uapi/asm/mman.h~linux-next-git-rejects arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~linux-next-git-rejects
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -13,11 +13,7 @@
 #define MAP_SHARED	0x01		/* Share changes */
 #define MAP_PRIVATE	0x02		/* Changes are private */
 #define MAP_SHARED_VALIDATE 0x03	/* share + validate extension flags */
-<<<<<<< HEAD
-#define MAP_TYPE	0x03		/* Mask for type of mapping */
-=======
 #define MAP_TYPE	(MAP_SHARED|MAP_PRIVATE|MAP_RESRVD1|MAP_RESRVD2) /* Mask for type of mapping */
->>>>>>> linux-next/akpm-base
 #define MAP_FIXED	0x04		/* Interpret addr exactly */
 #define MAP_RESRVD1	0x08		/* reserved for 3rd bit of MAP_TYPE */
 #define MAP_ANONYMOUS	0x10		/* don't use a file */
diff -puN Documentation/devicetree/bindings/mtd/jedec,spi-nor.txt~linux-next-git-rejects Documentation/devicetree/bindings/mtd/jedec,spi-nor.txt
--- a/Documentation/devicetree/bindings/mtd/jedec,spi-nor.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/mtd/jedec,spi-nor.txt
@@ -14,10 +14,7 @@ Required properties:
                  at25df641
                  at26df081a
                  en25s64
-<<<<<<< HEAD
-=======
                  mr25h128
->>>>>>> linux-next/akpm-base
                  mr25h256
                  mr25h10
                  mr25h40
diff -puN drivers/firmware/qcom_scm.c~linux-next-git-rejects drivers/firmware/qcom_scm.c
--- a/drivers/firmware/qcom_scm.c~linux-next-git-rejects
+++ a/drivers/firmware/qcom_scm.c
@@ -45,8 +45,6 @@ struct qcom_scm {
 	struct reset_controller_dev reset;
 
 	u64 dload_mode_addr;
-<<<<<<< HEAD
-=======
 };
 
 struct qcom_scm_current_perm_info {
@@ -60,7 +58,6 @@ struct qcom_scm_current_perm_info {
 struct qcom_scm_mem_map_info {
 	__le64 mem_addr;
 	__le64 mem_size;
->>>>>>> linux-next/akpm-base
 };
 
 static struct qcom_scm *__scm;
diff -puN drivers/soc/amlogic/meson-gx-pwrc-vpu.c~linux-next-git-rejects drivers/soc/amlogic/meson-gx-pwrc-vpu.c
--- a/drivers/soc/amlogic/meson-gx-pwrc-vpu.c~linux-next-git-rejects
+++ a/drivers/soc/amlogic/meson-gx-pwrc-vpu.c
@@ -34,10 +34,7 @@ struct meson_gx_pwrc_vpu {
 	struct reset_control *rstc;
 	struct clk *vpu_clk;
 	struct clk *vapb_clk;
-<<<<<<< HEAD
-=======
 	bool powered;
->>>>>>> linux-next/akpm-base
 };
 
 static inline
@@ -81,11 +78,8 @@ static int meson_gx_pwrc_vpu_power_off(s
 	clk_disable_unprepare(pd->vpu_clk);
 	clk_disable_unprepare(pd->vapb_clk);
 
-<<<<<<< HEAD
-=======
 	pd->powered = false;
 
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
@@ -97,15 +91,7 @@ static int meson_gx_pwrc_vpu_setup_clk(s
 	if (ret)
 		return ret;
 
-<<<<<<< HEAD
-	ret = clk_prepare_enable(pd->vapb_clk);
-	if (ret)
-		clk_disable_unprepare(pd->vpu_clk);
-
-	return ret;
-=======
 	return clk_prepare_enable(pd->vapb_clk);
->>>>>>> linux-next/akpm-base
 }
 
 static int meson_gx_pwrc_vpu_power_on(struct generic_pm_domain *genpd)
@@ -153,11 +139,8 @@ static int meson_gx_pwrc_vpu_power_on(st
 	if (ret)
 		return ret;
 
-<<<<<<< HEAD
-=======
 	pd->powered = true;
 
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
@@ -184,11 +167,6 @@ static int meson_gx_pwrc_vpu_probe(struc
 	struct reset_control *rstc;
 	struct clk *vpu_clk;
 	struct clk *vapb_clk;
-<<<<<<< HEAD
-	bool powered_off;
-	int ret;
-=======
->>>>>>> linux-next/akpm-base
 
 	regmap_ao = syscon_node_to_regmap(of_get_parent(pdev->dev.of_node));
 	if (IS_ERR(regmap_ao)) {
@@ -227,22 +205,8 @@ static int meson_gx_pwrc_vpu_probe(struc
 	vpu_hdmi_pd.vpu_clk = vpu_clk;
 	vpu_hdmi_pd.vapb_clk = vapb_clk;
 
-<<<<<<< HEAD
-	powered_off = meson_gx_pwrc_vpu_get_power(&vpu_hdmi_pd);
-
-	/* If already powered, sync the clock states */
-	if (!powered_off) {
-		ret = meson_gx_pwrc_vpu_setup_clk(&vpu_hdmi_pd);
-		if (ret)
-			return ret;
-	}
-
-	pm_genpd_init(&vpu_hdmi_pd.genpd, &pm_domain_always_on_gov,
-		      powered_off);
-=======
 	pm_genpd_init(&vpu_hdmi_pd.genpd, &simple_qos_governor,
 		      meson_gx_pwrc_vpu_get_power(&vpu_hdmi_pd));
->>>>>>> linux-next/akpm-base
 
 	return of_genpd_add_provider_simple(pdev->dev.of_node,
 					    &vpu_hdmi_pd.genpd);
@@ -250,12 +214,8 @@ static int meson_gx_pwrc_vpu_probe(struc
 
 static void meson_gx_pwrc_vpu_shutdown(struct platform_device *pdev)
 {
-<<<<<<< HEAD
-	meson_gx_pwrc_vpu_power_off(&vpu_hdmi_pd.genpd);
-=======
 	if (vpu_hdmi_pd.powered)
 		meson_gx_pwrc_vpu_power_off(&vpu_hdmi_pd.genpd);
->>>>>>> linux-next/akpm-base
 }
 
 static const struct of_device_id meson_gx_pwrc_vpu_match_table[] = {
diff -puN include/linux/iomap.h~linux-next-git-rejects include/linux/iomap.h
--- a/include/linux/iomap.h~linux-next-git-rejects
+++ a/include/linux/iomap.h
@@ -27,15 +27,11 @@ struct vm_fault;
  */
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_BOUNDARY	0x02	/* mapping ends at metadata boundary */
-<<<<<<< HEAD
-#define IOMAP_F_DIRTY		0x04	/* uncommitted metadata */
-=======
 /*
  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata needed to access
  * written data and requires fdatasync to commit them to persistent storage.
  */
 #define IOMAP_F_DIRTY		0x04
->>>>>>> linux-next/akpm-base
 
 /*
  * Flags that only need to be reported for IOMAP_REPORT requests:
diff -puN include/linux/platform_data/mtd-nand-omap2.h~linux-next-git-rejects include/linux/platform_data/mtd-nand-omap2.h
--- a/include/linux/platform_data/mtd-nand-omap2.h~linux-next-git-rejects
+++ a/include/linux/platform_data/mtd-nand-omap2.h
@@ -63,25 +63,5 @@ struct gpmc_nand_regs {
 	void __iomem	*gpmc_bch_result4[GPMC_BCH_NUM_REMAINDER];
 	void __iomem	*gpmc_bch_result5[GPMC_BCH_NUM_REMAINDER];
 	void __iomem	*gpmc_bch_result6[GPMC_BCH_NUM_REMAINDER];
-<<<<<<< HEAD
-};
-
-struct omap_nand_platform_data {
-	int			cs;
-	struct mtd_partition	*parts;
-	int			nr_parts;
-	bool			flash_bbt;
-	enum nand_io		xfer_type;
-	int			devsize;
-	enum omap_ecc           ecc_opt;
-
-	struct device_node	*elm_of_node;
