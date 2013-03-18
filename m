From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 18 Mar 2013 12:26:46 -0700
Message-ID: <20130318192646.B5E475A4225@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:63888 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3CRT0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 15:26:47 -0400
Received: by mail-ia0-f201.google.com with SMTP id t4so1311271iag.0
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 12:26:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/exynos4.dtsi    |    9 -----
 arch/arm/boot/dts/exynos5440.dtsi |    6 ---
 drivers/mtd/nand/nand_ids.c       |   48 ----------------------------
 drivers/video/atmel_lcdfb.c       |   15 --------
 include/linux/mtd/nand.h          |   15 --------
 include/video/atmel_lcdc.h        |    4 --
 6 files changed, 97 deletions(-)

diff -puN arch/arm/boot/dts/exynos4.dtsi~linux-next-git-rejects arch/arm/boot/dts/exynos4.dtsi
--- a/arch/arm/boot/dts/exynos4.dtsi~linux-next-git-rejects
+++ a/arch/arm/boot/dts/exynos4.dtsi
@@ -327,11 +327,8 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x12680000 0x1000>;
 			interrupts = <0 35 0>;
-<<<<<<< HEAD
-=======
 			clocks = <&clock 292>;
 			clock-names = "apb_pclk";
->>>>>>> linux-next/akpm-base
 			#dma-cells = <1>;
 			#dma-channels = <8>;
 			#dma-requests = <32>;
@@ -341,11 +338,8 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x12690000 0x1000>;
 			interrupts = <0 36 0>;
-<<<<<<< HEAD
-=======
 			clocks = <&clock 293>;
 			clock-names = "apb_pclk";
->>>>>>> linux-next/akpm-base
 			#dma-cells = <1>;
 			#dma-channels = <8>;
 			#dma-requests = <32>;
@@ -355,11 +349,8 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x12850000 0x1000>;
 			interrupts = <0 34 0>;
-<<<<<<< HEAD
-=======
 			clocks = <&clock 279>;
 			clock-names = "apb_pclk";
->>>>>>> linux-next/akpm-base
 			#dma-cells = <1>;
 			#dma-channels = <8>;
 			#dma-requests = <1>;
diff -puN arch/arm/boot/dts/exynos5440.dtsi~linux-next-git-rejects arch/arm/boot/dts/exynos5440.dtsi
--- a/arch/arm/boot/dts/exynos5440.dtsi~linux-next-git-rejects
+++ a/arch/arm/boot/dts/exynos5440.dtsi
@@ -152,11 +152,8 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x120000 0x1000>;
 			interrupts = <0 34 0>;
-<<<<<<< HEAD
-=======
 			clocks = <&clock 21>;
 			clock-names = "apb_pclk";
->>>>>>> linux-next/akpm-base
 			#dma-cells = <1>;
 			#dma-channels = <8>;
 			#dma-requests = <32>;
@@ -166,11 +163,8 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x121000 0x1000>;
 			interrupts = <0 35 0>;
-<<<<<<< HEAD
-=======
 			clocks = <&clock 21>;
 			clock-names = "apb_pclk";
->>>>>>> linux-next/akpm-base
 			#dma-cells = <1>;
 			#dma-channels = <8>;
 			#dma-requests = <32>;
diff -puN drivers/mtd/nand/nand_ids.c~linux-next-git-rejects drivers/mtd/nand/nand_ids.c
--- a/drivers/mtd/nand/nand_ids.c~linux-next-git-rejects
+++ a/drivers/mtd/nand/nand_ids.c
@@ -25,53 +25,6 @@
  * extended chip ID.
  */
 struct nand_flash_dev nand_flash_ids[] = {
-<<<<<<< HEAD
-#define SP_OPTIONS NAND_NEED_READRDY
-#define SP_OPTIONS16 (SP_OPTIONS | NAND_BUSWIDTH_16)
-
-#ifdef CONFIG_MTD_NAND_MUSEUM_IDS
-	{"NAND 1MiB 5V 8-bit",		0x6e, 256, 1, 0x1000, SP_OPTIONS},
-	{"NAND 2MiB 5V 8-bit",		0x64, 256, 2, 0x1000, SP_OPTIONS},
-	{"NAND 4MiB 5V 8-bit",		0x6b, 512, 4, 0x2000, SP_OPTIONS},
-	{"NAND 1MiB 3,3V 8-bit",	0xe8, 256, 1, 0x1000, SP_OPTIONS},
-	{"NAND 1MiB 3,3V 8-bit",	0xec, 256, 1, 0x1000, SP_OPTIONS},
-	{"NAND 2MiB 3,3V 8-bit",	0xea, 256, 2, 0x1000, SP_OPTIONS},
-	{"NAND 4MiB 3,3V 8-bit",	0xd5, 512, 4, 0x2000, SP_OPTIONS},
-	{"NAND 4MiB 3,3V 8-bit",	0xe3, 512, 4, 0x2000, SP_OPTIONS},
-	{"NAND 4MiB 3,3V 8-bit",	0xe5, 512, 4, 0x2000, SP_OPTIONS},
-	{"NAND 8MiB 3,3V 8-bit",	0xd6, 512, 8, 0x2000, SP_OPTIONS},
-
-	{"NAND 8MiB 1,8V 8-bit",	0x39, 512, 8, 0x2000, SP_OPTIONS},
-	{"NAND 8MiB 3,3V 8-bit",	0xe6, 512, 8, 0x2000, SP_OPTIONS},
-	{"NAND 8MiB 1,8V 16-bit",	0x49, 512, 8, 0x2000, SP_OPTIONS16},
-	{"NAND 8MiB 3,3V 16-bit",	0x59, 512, 8, 0x2000, SP_OPTIONS16},
-#endif
-
-	{"NAND 16MiB 1,8V 8-bit",	0x33, 512, 16, 0x4000, SP_OPTIONS},
-	{"NAND 16MiB 3,3V 8-bit",	0x73, 512, 16, 0x4000, SP_OPTIONS},
-	{"NAND 16MiB 1,8V 16-bit",	0x43, 512, 16, 0x4000, SP_OPTIONS16},
-	{"NAND 16MiB 3,3V 16-bit",	0x53, 512, 16, 0x4000, SP_OPTIONS16},
-
-	{"NAND 32MiB 1,8V 8-bit",	0x35, 512, 32, 0x4000, SP_OPTIONS},
-	{"NAND 32MiB 3,3V 8-bit",	0x75, 512, 32, 0x4000, SP_OPTIONS},
-	{"NAND 32MiB 1,8V 16-bit",	0x45, 512, 32, 0x4000, SP_OPTIONS16},
-	{"NAND 32MiB 3,3V 16-bit",	0x55, 512, 32, 0x4000, SP_OPTIONS16},
-
-	{"NAND 64MiB 1,8V 8-bit",	0x36, 512, 64, 0x4000, SP_OPTIONS},
-	{"NAND 64MiB 3,3V 8-bit",	0x76, 512, 64, 0x4000, SP_OPTIONS},
-	{"NAND 64MiB 1,8V 16-bit",	0x46, 512, 64, 0x4000, SP_OPTIONS16},
-	{"NAND 64MiB 3,3V 16-bit",	0x56, 512, 64, 0x4000, SP_OPTIONS16},
-
-	{"NAND 128MiB 1,8V 8-bit",	0x78, 512, 128, 0x4000, SP_OPTIONS},
-	{"NAND 128MiB 1,8V 8-bit",	0x39, 512, 128, 0x4000, SP_OPTIONS},
-	{"NAND 128MiB 3,3V 8-bit",	0x79, 512, 128, 0x4000, SP_OPTIONS},
-	{"NAND 128MiB 1,8V 16-bit",	0x72, 512, 128, 0x4000, SP_OPTIONS16},
-	{"NAND 128MiB 1,8V 16-bit",	0x49, 512, 128, 0x4000, SP_OPTIONS16},
-	{"NAND 128MiB 3,3V 16-bit",	0x74, 512, 128, 0x4000, SP_OPTIONS16},
-	{"NAND 128MiB 3,3V 16-bit",	0x59, 512, 128, 0x4000, SP_OPTIONS16},
-
-	{"NAND 256MiB 3,3V 8-bit",	0x71, 512, 256, 0x4000, SP_OPTIONS},
-=======
 	LEGACY_ID_NAND("NAND 4MiB 5V 8-bit",   0x6B, 512, 4, 0x2000, SP_OPTIONS),
 	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE3, 512, 4, 0x2000, SP_OPTIONS),
 	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE5, 512, 4, 0x2000, SP_OPTIONS),
@@ -102,7 +55,6 @@ struct nand_flash_dev nand_flash_ids[] =
 	LEGACY_ID_NAND("NAND 128MiB 3,3V 16-bit", 0x59, 512, 128, 0x4000, SP_OPTIONS16),
 
 	LEGACY_ID_NAND("NAND 256MiB 3,3V 8-bit", 0x71, 512, 256, 0x4000, SP_OPTIONS),
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * These are the new chips with large page size. Their page size and
diff -puN drivers/video/atmel_lcdfb.c~linux-next-git-rejects drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~linux-next-git-rejects
+++ a/drivers/video/atmel_lcdfb.c
@@ -496,11 +496,7 @@ static int atmel_lcdfb_check_var(struct
 		break;
 	case 16:
 		/* Older SOCs use IBGR:555 rather than BGR:565. */
-<<<<<<< HEAD
-		if (sinfo->have_intensity_bit)
-=======
 		if (sinfo->config->have_intensity_bit)
->>>>>>> linux-next/akpm-base
 			var->green.length = 5;
 		else
 			var->green.length = 6;
@@ -760,11 +756,7 @@ static int atmel_lcdfb_setcolreg(unsigne
 
 	case FB_VISUAL_PSEUDOCOLOR:
 		if (regno < 256) {
-<<<<<<< HEAD
-			if (sinfo->have_intensity_bit) {
-=======
 			if (sinfo->config->have_intensity_bit) {
->>>>>>> linux-next/akpm-base
 				/* old style I+BGR:555 */
 				val  = ((red   >> 11) & 0x001f);
 				val |= ((green >>  6) & 0x03e0);
@@ -952,16 +944,9 @@ static int __init atmel_lcdfb_probe(stru
 	}
 	sinfo->info = info;
 	sinfo->pdev = pdev;
-<<<<<<< HEAD
-	if (cpu_is_at91sam9261() || cpu_is_at91sam9263() ||
-							cpu_is_at91sam9rl()) {
-		sinfo->have_intensity_bit = true;
-	}
-=======
 	sinfo->config = atmel_lcdfb_get_config(pdev);
 	if (!sinfo->config)
 		goto free_info;
->>>>>>> linux-next/akpm-base
 
 	strcpy(info->fix.id, sinfo->pdev->name);
 	info->flags = ATMEL_LCDFB_FBINFO_DEFAULT;
diff -puN include/linux/mtd/nand.h~linux-next-git-rejects include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~linux-next-git-rejects
+++ a/include/linux/mtd/nand.h
@@ -152,21 +152,6 @@ typedef enum {
  * True only for small page devices; large page devices do not support
  * autoincrement.
  */
-<<<<<<< HEAD
-#define NAND_4PAGE_ARRAY	0x00000040
-/*
- * Chip requires that BBT is periodically rewritten to prevent
- * bits from adjacent blocks from 'leaking' in altering data.
- * This happens with the Renesas AG-AND chips, possibly others.
- */
-#define BBT_AUTO_REFRESH	0x00000080
-/*
- * Chip requires ready check on read (for auto-incremented sequential read).
- * True only for small page devices; large page devices do not support
- * autoincrement.
- */
-=======
->>>>>>> linux-next/akpm-base
 #define NAND_NEED_READRDY	0x00000100
 
 /* Chip does not allow subpage writes */
diff -puN include/video/atmel_lcdc.h~linux-next-git-rejects include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~linux-next-git-rejects
+++ a/include/video/atmel_lcdc.h
@@ -62,12 +62,8 @@ struct atmel_lcdfb_info {
 	void (*atmel_lcdfb_power_control)(int on);
 	struct fb_monspecs	*default_monspecs;
 	u32			pseudo_palette[16];
-<<<<<<< HEAD
 	bool			have_intensity_bit;
-=======
-
 	struct atmel_lcdfb_config *config;
->>>>>>> linux-next/akpm-base
 };
 
 #define ATMEL_LCDC_DMABADDR1	0x00
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

