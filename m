From: akpm@linux-foundation.org
Subject: + drivers-video-sis-remove-more-kernel-24-code.patch added to -mm tree
Date: Thu, 03 May 2007 22:22:56 -0700
Message-ID: <200705040522.l445MuDv029716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161441AbXEDFXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 01:23:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, adaplas@pol.net, thomas@winischhofer.net


The patch titled
     drivers/video/sis/: remove more kernel 2.4 code
has been added to the -mm tree.  Its filename is
     drivers-video-sis-remove-more-kernel-24-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/sis/: remove more kernel 2.4 code
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/osdef.h    |    5 -
 drivers/video/sis/sis.h      |   50 ---------------
 drivers/video/sis/sis_main.c |  105 ++++++---------------------------
 3 files changed, 22 insertions(+), 138 deletions(-)

diff -puN drivers/video/sis/osdef.h~drivers-video-sis-remove-more-kernel-24-code drivers/video/sis/osdef.h
--- a/drivers/video/sis/osdef.h~drivers-video-sis-remove-more-kernel-24-code
+++ a/drivers/video/sis/osdef.h
@@ -58,9 +58,6 @@
 #define SIS_LINUX_KERNEL		/* Linux kernel framebuffer */
 #undef  SIS_XORG_XF86			/* XFree86/X.org */
 
-#undef SIS_LINUX_KERNEL_24
-#undef SIS_LINUX_KERNEL_26
-
 #ifdef OutPortByte
 #undef OutPortByte
 #endif
@@ -100,8 +97,6 @@
 #define SIS315H
 #endif
 
-#define SIS_LINUX_KERNEL_26
-
 #if !defined(SIS300) && !defined(SIS315H)
 #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set
 #warning sisfb will not work!
diff -puN drivers/video/sis/sis.h~drivers-video-sis-remove-more-kernel-24-code drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~drivers-video-sis-remove-more-kernel-24-code
+++ a/drivers/video/sis/sis.h
@@ -27,11 +27,7 @@
 #include <linux/version.h>
 
 #include "osdef.h"
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #include <video/sisfb.h>
-#else
-#include <linux/sisfb.h>
-#endif
 
 #include "vgatypes.h"
 #include "vstruct.h"
@@ -40,12 +36,8 @@
 #define VER_MINOR		8
 #define VER_LEVEL		9
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #include <linux/spinlock.h>
-#define SIS_PCI_GET_CLASS(a, b) pci_get_class(a, b)
-#define SIS_PCI_GET_DEVICE(a,b,c) pci_get_device(a,b,c)
-#define SIS_PCI_GET_SLOT(a,b) pci_get_slot(a,b)
-#define SIS_PCI_PUT_DEVICE(a) pci_dev_put(a)
+
 #ifdef CONFIG_COMPAT
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,10)
 #include <linux/ioctl32.h>
@@ -54,18 +46,7 @@
 #define SIS_NEW_CONFIG_COMPAT
 #endif
 #endif	/* CONFIG_COMPAT */
-#else  /* 2.4 */
-#define SIS_PCI_GET_CLASS(a, b) pci_find_class(a, b)
-#define SIS_PCI_GET_DEVICE(a,b,c) pci_find_device(a,b,c)
-#define SIS_PCI_GET_SLOT(a,b) pci_find_slot(a,b)
-#define SIS_PCI_PUT_DEVICE(a)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,19)
-#ifdef __x86_64__	/* Shouldn't we check for CONFIG_IA32_EMULATION here? */
-#include <asm/ioctl32.h>
-#define SIS_OLD_CONFIG_COMPAT
-#endif
-#endif
-#endif /* 2.4 */
+
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
 #define SIS_IOTYPE1 void __iomem
 #define SIS_IOTYPE2 __iomem
@@ -497,26 +478,8 @@ struct sis_video_info {
 
 	struct fb_var_screeninfo default_var;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	struct fb_fix_screeninfo sisfb_fix;
 	u32		pseudo_palette[17];
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	struct display		 sis_disp;
-	struct display_switch 	 sisfb_sw;
-	struct {
-		u16 red, green, blue, pad;
-	}		sis_palette[256];
-	union {
-#ifdef FBCON_HAS_CFB16
-		u16 cfb16[16];
-#endif
-#ifdef FBCON_HAS_CFB32
-		u32 cfb32[16];
-#endif
-	}		sis_fbcon_cmap;
-#endif
 
 	struct sisfb_monitor {
 		u16 hmin;
@@ -537,10 +500,6 @@ struct sis_video_info {
 
 	int		mni;	/* Mode number index */
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	int		currcon;
-#endif
-
 	unsigned long	video_size;
 	unsigned long	video_base;
 	unsigned long	mmio_size;
@@ -577,9 +536,6 @@ struct sis_video_info {
 	int		sisfb_tvplug;
 	int		sisfb_tvstd;
 	int		sisfb_nocrt2rate;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	int		sisfb_inverse;
-#endif
 
 	u32		heapstart;		/* offset  */
 	SIS_IOTYPE1	*sisfb_heap_start;	/* address */
@@ -645,9 +601,7 @@ struct sis_video_info {
 	int		modechanged;
 	unsigned char	modeprechange;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	u8		sisfb_lastrates[128];
-#endif
 
 	int		newrom;
 	int		haveXGIROM;
diff -puN drivers/video/sis/sis_main.c~drivers-video-sis-remove-more-kernel-24-code drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~drivers-video-sis-remove-more-kernel-24-code
+++ a/drivers/video/sis/sis_main.c
@@ -1947,7 +1947,7 @@ sisfb_get_northbridge(int basechipid)
 	default:	return NULL;
 	}
 	for(i = 0; i < nbridgenum; i++) {
-		if((pdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI,
+		if((pdev = pci_get_device(PCI_VENDOR_ID_SI,
 				nbridgeids[nbridgeidx+i], NULL)))
 			break;
 	}
@@ -4612,9 +4612,9 @@ sisfb_find_host_bridge(struct sis_video_
 	unsigned short temp;
 	int ret = 0;
 
-	while((pdev = SIS_PCI_GET_CLASS(PCI_CLASS_BRIDGE_HOST, pdev))) {
+	while((pdev = pci_get_class(PCI_CLASS_BRIDGE_HOST, pdev))) {
 		temp = pdev->vendor;
-		SIS_PCI_PUT_DEVICE(pdev);
+		pci_dev_put(pdev);
 		if(temp == pcivendor) {
 			ret = 1;
 			break;
@@ -5153,24 +5153,24 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			if(reg & 0x80) v2 |= 0x80;
 			v2 |= 0x01;
 
-			if((mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0730, NULL))) {
-				SIS_PCI_PUT_DEVICE(mypdev);
+			if((mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0730, NULL))) {
+				pci_dev_put(mypdev);
 				if(((v2 & 0x06) == 2) || ((v2 & 0x06) == 4))
 					v2 &= 0xf9;
 				v2 |= 0x08;
 				v1 &= 0xfe;
 			} else {
-				mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0735, NULL);
+				mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0735, NULL);
 				if(!mypdev)
-					mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0645, NULL);
+					mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0645, NULL);
 				if(!mypdev)
-					mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0650, NULL);
+					mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0650, NULL);
 				if(mypdev) {
 					pci_read_config_dword(mypdev, 0x94, &regd);
 					regd &= 0xfffffeff;
 					pci_write_config_dword(mypdev, 0x94, regd);
 					v1 &= 0xfe;
-					SIS_PCI_PUT_DEVICE(mypdev);
+					pci_dev_put(mypdev);
 				} else if(sisfb_find_host_bridge(ivideo, pdev, PCI_VENDOR_ID_SI)) {
 					v1 &= 0xfe;
 				} else if(sisfb_find_host_bridge(ivideo, pdev, 0x1106) ||
@@ -5193,13 +5193,13 @@ sisfb_post_xgi(struct pci_dev *pdev)
 			if( (!(v1 & 0x02)) && (v2 & 0x30) && (regd < 0xcf) )
 				setSISIDXREG(SISCR, 0x5f, 0xf1, 0x01);
 
-			if((mypdev = SIS_PCI_GET_DEVICE(0x10de, 0x01e0, NULL))) {
+			if((mypdev = pci_get_device(0x10de, 0x01e0, NULL))) {
 				/* TODO: set CR5f &0xf1 | 0x01 for version 6570
 				 * of nforce 2 ROM
 				 */
 				if(0)
 					setSISIDXREG(SISCR, 0x5f, 0xf1, 0x01);
-				SIS_PCI_PUT_DEVICE(mypdev);
+				pci_dev_put(mypdev);
 			}
 		}
 
@@ -5235,9 +5235,9 @@ sisfb_post_xgi(struct pci_dev *pdev)
 		setSISIDXREG(SISCR, 0x75, 0xe0, bios[0x4ff] & 0x1f);
 		setSISIDXREG(SISCR, 0x76, 0xe0, bios[0x500] & 0x1f);
 		v1 = bios[0x501];
-		if((mypdev = SIS_PCI_GET_DEVICE(0x8086, 0x2530, NULL))) {
+		if((mypdev = pci_get_device(0x8086, 0x2530, NULL))) {
 			v1 = 0xf0;
-			SIS_PCI_PUT_DEVICE(mypdev);
+			pci_dev_put(mypdev);
 		}
 		outSISIDXREG(SISCR, 0x77, v1);
 	}
@@ -5946,7 +5946,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 
 	if(!ivideo->sisvga_enabled) {
 		if(pci_enable_device(pdev)) {
-			if(ivideo->nbridge) SIS_PCI_PUT_DEVICE(ivideo->nbridge);
+			if(ivideo->nbridge) pci_dev_put(ivideo->nbridge);
 			pci_set_drvdata(pdev, NULL);
 			kfree(sis_fb_info);
 			return -EIO;
@@ -5973,7 +5973,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 					"requiring Chrontel/GPIO setup\n",
 					mychswtable[i].vendorName,
 					mychswtable[i].cardName);
-				ivideo->lpcdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0008, NULL);
+				ivideo->lpcdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0008, NULL);
 				break;
 			}
 			i++;
@@ -5983,7 +5983,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 
 #ifdef CONFIG_FB_SIS_315
 	if((ivideo->chip == SIS_760) && (ivideo->nbridge)) {
-		ivideo->lpcdev = SIS_PCI_GET_SLOT(ivideo->nbridge->bus, (2 << 3));
+		ivideo->lpcdev = pci_get_slot(ivideo->nbridge->bus, (2 << 3));
 	}
 #endif
 
@@ -6148,9 +6148,9 @@ error_1:	release_mem_region(ivideo->vide
 error_2:	release_mem_region(ivideo->mmio_base, ivideo->mmio_size);
 error_3:	vfree(ivideo->bios_abase);
 		if(ivideo->lpcdev)
-			SIS_PCI_PUT_DEVICE(ivideo->lpcdev);
+			pci_dev_put(ivideo->lpcdev);
 		if(ivideo->nbridge)
-			SIS_PCI_PUT_DEVICE(ivideo->nbridge);
+			pci_dev_put(ivideo->nbridge);
 		pci_set_drvdata(pdev, NULL);
 		if(!ivideo->sisvga_enabled)
 			pci_disable_device(pdev);
@@ -6330,70 +6330,6 @@ error_3:	vfree(ivideo->bios_abase);
 
 		sisfb_set_vparms(ivideo);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-
-		/* ---------------- For 2.4: Now switch the mode ------------------ */
-
-		printk(KERN_INFO "sisfb: Setting mode %dx%dx%d (%dHz)\n",
-			ivideo->video_width, ivideo->video_height, ivideo->video_bpp,
-			ivideo->refresh_rate);
-
-		/* Determine whether or not acceleration is to be
-		 * used. Need to know before pre/post_set_mode()
-		 */
-		ivideo->accel = 0;
-		ivideo->default_var.accel_flags &= ~FB_ACCELF_TEXT;
-		if(ivideo->sisfb_accel) {
-			ivideo->accel = -1;
-			ivideo->default_var.accel_flags |= FB_ACCELF_TEXT;
-		}
-
-		/* Now switch the mode */
-		sisfb_pre_setmode(ivideo);
-
-		if(SiSSetMode(&ivideo->SiS_Pr, ivideo->mode_no) == 0) {
-			printk(KERN_ERR "sisfb: Fatal error: Setting mode[0x%x] failed\n",
-									ivideo->mode_no);
-			ret = -EINVAL;
-			iounmap(ivideo->mmio_vbase);
-			goto error_0;
-		}
-
-		outSISIDXREG(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
-
-		sisfb_post_setmode(ivideo);
-
-		/* Maximize regardless of sisfb_max at startup */
-		ivideo->default_var.yres_virtual = 32767;
-
-		/* Force reset of x virtual in crtc_to_var */
-		ivideo->default_var.xres_virtual = 0;
-
-		/* Copy mode timing to var */
-		sisfb_crtc_to_var(ivideo, &ivideo->default_var);
-
-		/* Find out about screen pitch */
-		sisfb_calc_pitch(ivideo, &ivideo->default_var);
-		sisfb_set_pitch(ivideo);
-
-		/* Init the accelerator (does nothing currently) */
-		sisfb_initaccel(ivideo);
-
-		/* Init some fbinfo entries */
-		sis_fb_info->node  = -1;
-		sis_fb_info->flags = FBINFO_FLAG_DEFAULT;
-		sis_fb_info->fbops = &sisfb_ops;
-		sis_fb_info->disp  = &ivideo->sis_disp;
-		sis_fb_info->blank = &sisfb_blank;
-		sis_fb_info->switch_con = &sisfb_switch;
-		sis_fb_info->updatevar  = &sisfb_update_var;
-		sis_fb_info->changevar  = NULL;
-		strcpy(sis_fb_info->fontname, sisfb_fontname);
-
-		sisfb_set_disp(-1, &ivideo->default_var, sis_fb_info);
-
-#else		/* --------- For 2.6: Setup a somewhat sane default var ------------ */
-
 		printk(KERN_INFO "sisfb: Default mode is %dx%dx%d (%dHz)\n",
 			ivideo->video_width, ivideo->video_height, ivideo->video_bpp,
 			ivideo->refresh_rate);
@@ -6453,7 +6389,6 @@ error_3:	vfree(ivideo->bios_abase);
 		sis_fb_info->pseudo_palette = ivideo->pseudo_palette;
 
 		fb_alloc_cmap(&sis_fb_info->cmap, 256 , 0);
-#endif		/* 2.6 */
 
 		printk(KERN_DEBUG "sisfb: Initial vbflags 0x%x\n", (int)ivideo->vbflags);
 
@@ -6563,10 +6498,10 @@ static void __devexit sisfb_remove(struc
 	vfree(ivideo->bios_abase);
 
 	if(ivideo->lpcdev)
-		SIS_PCI_PUT_DEVICE(ivideo->lpcdev);
+		pci_dev_put(ivideo->lpcdev);
 
 	if(ivideo->nbridge)
-		SIS_PCI_PUT_DEVICE(ivideo->nbridge);
+		pci_dev_put(ivideo->nbridge);
 
 #ifdef CONFIG_MTRR
 	/* Release MTRR region */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
git-acpi.patch
git-alsa.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
ibmtr_cs-fix-hang-on-eject.patch
git-ocfs2.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
apple-smc-driver-hardware-monitoring-and-control-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
add-file-position-info-to-proc.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
rtc-remove-sys-class-rtc-dev-fix.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
drivers-video-sis-remove-more-kernel-24-code.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
