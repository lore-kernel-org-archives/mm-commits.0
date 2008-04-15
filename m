From: akpm@linux-foundation.org
Subject: - git-acpi-revert-suspend-wakeup-code-in-c.patch removed from -mm tree
Date: Tue, 15 Apr 2008 01:44:32 -0700
Message-ID: <200804150844.m3F8iWdW019690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755440AbYDOIq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 04:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, len.brown@intel.com, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-acpi: revert "Suspend: Wakeup code in C"
has been removed from the -mm tree.  Its filename was
     git-acpi-revert-suspend-wakeup-code-in-c.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-acpi: revert "Suspend: Wakeup code in C"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 3e49869cd72da85666808f201154b03cb2014678
Author: Pavel Machek <pavel@suse.cz>
Date:   Wed Feb 20 01:48:39 2008 +0100

    Suspend: Wakeup code in C

Because of largeish conflicts with git-x86.

Cc: Pavel Machek <pavel@suse.cz>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                           |    2 
 arch/x86/boot/Makefile                     |    2 
 arch/x86/boot/boot.h                       |    5 
 arch/x86/boot/video-bios.c                 |    6 
 arch/x86/boot/video-mode.c                 |  173 ----------
 arch/x86/boot/video-vesa.c                 |    8 
 arch/x86/boot/video-vga.c                  |   12 
 arch/x86/boot/video.c                      |  157 +++++++++
 arch/x86/kernel/acpi/Makefile              |    8 
 arch/x86/kernel/acpi/realmode/Makefile     |   57 ---
 arch/x86/kernel/acpi/realmode/copy.S       |    1 
 arch/x86/kernel/acpi/realmode/video-bios.c |    1 
 arch/x86/kernel/acpi/realmode/video-mode.c |    1 
 arch/x86/kernel/acpi/realmode/video-vesa.c |    1 
 arch/x86/kernel/acpi/realmode/video-vga.c  |    1 
 arch/x86/kernel/acpi/realmode/wakemain.c   |   81 ----
 arch/x86/kernel/acpi/realmode/wakeup.S     |  113 ------
 arch/x86/kernel/acpi/realmode/wakeup.h     |   36 --
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |   61 ---
 arch/x86/kernel/acpi/sleep.c               |   73 ----
 arch/x86/kernel/acpi/sleep.h               |   18 -
 arch/x86/kernel/acpi/sleep_32.c            |   40 ++
 arch/x86/kernel/acpi/wakeup_32.S           |  245 +++++++++++++-
 arch/x86/kernel/acpi/wakeup_64.S           |  313 ++++++++++++++++++-
 arch/x86/kernel/acpi/wakeup_rm.S           |   10 
 arch/x86/kernel/e820_64.c                  |    5 
 arch/x86/kernel/head_64.S                  |    4 
 arch/x86/kernel/setup_32.c                 |    4 
 arch/x86/kernel/setup_64.c                 |   16 
 arch/x86/kernel/smpboot_64.c               |   26 +
 include/asm-x86/smp_64.h                   |    2 
 include/asm-x86/trampoline.h               |   18 -
 32 files changed, 775 insertions(+), 725 deletions(-)

diff -puN arch/x86/Kconfig~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/Kconfig
--- a/arch/x86/Kconfig~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/Kconfig
@@ -181,7 +181,7 @@ config X86_BIOS_REBOOT
 
 config X86_TRAMPOLINE
 	bool
-	depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
+	depends on X86_SMP || (X86_VOYAGER && SMP)
 	default y
 
 config KTIME_SCALAR
diff -puN arch/x86/boot/Makefile~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/boot/Makefile
@@ -30,7 +30,7 @@ subdir-		:= compressed
 
 setup-y		+= a20.o cmdline.o copy.o cpu.o cpucheck.o edd.o
 setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
-setup-y		+= printf.o string.o tty.o video.o video-mode.o version.o
+setup-y		+= printf.o string.o tty.o video.o version.o
 setup-$(CONFIG_X86_APM_BOOT) += apm.o
 setup-$(CONFIG_X86_VOYAGER) += voyager.o
 
diff -puN arch/x86/boot/boot.h~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/boot/boot.h
--- a/arch/x86/boot/boot.h~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/boot/boot.h
@@ -286,11 +286,6 @@ int getchar_timeout(void);
 /* video.c */
 void set_video(void);
 
-/* video-mode.c */
-int set_mode(u16 mode);
-int mode_defined(u16 mode);
-void probe_cards(int unsafe);
-
 /* video-vesa.c */
 void vesa_store_edid(void);
 
diff -puN arch/x86/boot/video-bios.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/boot/video-bios.c
--- a/arch/x86/boot/video-bios.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/boot/video-bios.c
@@ -50,7 +50,6 @@ static int set_bios_mode(u8 mode)
 	if (new_mode == mode)
 		return 0;	/* Mode change OK */
 
-#ifndef _WAKEUP
 	if (new_mode != boot_params.screen_info.orig_video_mode) {
 		/* Mode setting failed, but we didn't end up where we
 		   started.  That's bad.  Try to revert to the original
@@ -60,18 +59,13 @@ static int set_bios_mode(u8 mode)
 			     : "+a" (ax)
 			     : : "ebx", "ecx", "edx", "esi", "edi");
 	}
-#endif
 	return -1;
 }
 
 static int bios_probe(void)
 {
 	u8 mode;
-#ifdef _WAKEUP
-	u8 saved_mode = 0x03;
-#else
 	u8 saved_mode = boot_params.screen_info.orig_video_mode;
-#endif
 	u16 crtc;
 	struct mode_info *mi;
 	int nmodes = 0;
diff -puN arch/x86/boot/video-mode.c~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/boot/video-mode.c
+++ /dev/null
@@ -1,173 +0,0 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *
- *   Copyright (C) 1991, 1992 Linus Torvalds
- *   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
- *
- *   This file is part of the Linux kernel, and is made available under
- *   the terms of the GNU General Public License version 2.
- *
- * ----------------------------------------------------------------------- */
-
-/*
- * arch/i386/boot/video-mode.c
- *
- * Set the video mode.  This is separated out into a different
- * file in order to be shared with the ACPI wakeup code.
- */
-
-#include "boot.h"
-#include "video.h"
-#include "vesa.h"
-
-/*
- * Common variables
- */
-int adapter;			/* 0=CGA/MDA/HGC, 1=EGA, 2=VGA+ */
-u16 video_segment;
-int force_x, force_y;	/* Don't query the BIOS for cols/rows */
-
-int do_restore;		/* Screen contents changed during mode flip */
-int graphic_mode;	/* Graphic mode with linear frame buffer */
-
-/* Probe the video drivers and have them generate their mode lists. */
-void probe_cards(int unsafe)
-{
-	struct card_info *card;
-	static u8 probed[2];
-
-	if (probed[unsafe])
-		return;
-
-	probed[unsafe] = 1;
-
-	for (card = video_cards; card < video_cards_end; card++) {
-		if (card->unsafe == unsafe) {
-			if (card->probe)
-				card->nmodes = card->probe();
-			else
-				card->nmodes = 0;
-		}
-	}
-}
-
-/* Test if a mode is defined */
-int mode_defined(u16 mode)
-{
-	struct card_info *card;
-	struct mode_info *mi;
-	int i;
-
-	for (card = video_cards; card < video_cards_end; card++) {
-		mi = card->modes;
-		for (i = 0; i < card->nmodes; i++, mi++) {
-			if (mi->mode == mode)
-				return 1;
-		}
-	}
-
-	return 0;
-}
-
-/* Set mode (without recalc) */
-static int raw_set_mode(u16 mode, u16 *real_mode)
-{
-	int nmode, i;
-	struct card_info *card;
-	struct mode_info *mi;
-
-	/* Drop the recalc bit if set */
-	mode &= ~VIDEO_RECALC;
-
-	/* Scan for mode based on fixed ID, position, or resolution */
-	nmode = 0;
-	for (card = video_cards; card < video_cards_end; card++) {
-		mi = card->modes;
-		for (i = 0; i < card->nmodes; i++, mi++) {
-			int visible = mi->x || mi->y;
-
-			if ((mode == nmode && visible) ||
-			    mode == mi->mode ||
-			    mode == (mi->y << 8)+mi->x) {
-				*real_mode = mi->mode;
-				return card->set_mode(mi);
-			}
-
-			if (visible)
-				nmode++;
-		}
-	}
-
-	/* Nothing found?  Is it an "exceptional" (unprobed) mode? */
-	for (card = video_cards; card < video_cards_end; card++) {
-		if (mode >= card->xmode_first &&
-		    mode < card->xmode_first+card->xmode_n) {
-			struct mode_info mix;
-			*real_mode = mix.mode = mode;
-			mix.x = mix.y = 0;
-			return card->set_mode(&mix);
-		}
-	}
-
-	/* Otherwise, failure... */
-	return -1;
-}
-
-/*
- * Recalculate the vertical video cutoff (hack!)
- */
-static void vga_recalc_vertical(void)
-{
-	unsigned int font_size, rows;
-	u16 crtc;
-	u8 pt, ov;
-
-	set_fs(0);
-	font_size = rdfs8(0x485); /* BIOS: font size (pixels) */
-	rows = force_y ? force_y : rdfs8(0x484)+1; /* Text rows */
-
-	rows *= font_size;	/* Visible scan lines */
-	rows--;			/* ... minus one */
-
-	crtc = vga_crtc();
-
-	pt = in_idx(crtc, 0x11);
-	pt &= ~0x80;		/* Unlock CR0-7 */
-	out_idx(pt, crtc, 0x11);
-
-	out_idx((u8)rows, crtc, 0x12); /* Lower height register */
-
-	ov = in_idx(crtc, 0x07); /* Overflow register */
-	ov &= 0xbd;
-	ov |= (rows >> (8-1)) & 0x02;
-	ov |= (rows >> (9-6)) & 0x40;
-	out_idx(ov, crtc, 0x07);
-}
-
-/* Set mode (with recalc if specified) */
-int set_mode(u16 mode)
-{
-	int rv;
-	u16 real_mode;
-
-	/* Very special mode numbers... */
-	if (mode == VIDEO_CURRENT_MODE)
-		return 0;	/* Nothing to do... */
-	else if (mode == NORMAL_VGA)
-		mode = VIDEO_80x25;
-	else if (mode == EXTENDED_VGA)
-		mode = VIDEO_8POINT;
-
-	rv = raw_set_mode(mode, &real_mode);
-	if (rv)
-		return rv;
-
-	if (mode & VIDEO_RECALC)
-		vga_recalc_vertical();
-
-	/* Save the canonical mode number for the kernel, not
-	   an alias, size specification or menu position */
-#ifndef _WAKEUP
-	boot_params.hdr.vid_mode = real_mode;
-#endif
-	return 0;
-}
diff -puN arch/x86/boot/video-vesa.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/boot/video-vesa.c
--- a/arch/x86/boot/video-vesa.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/boot/video-vesa.c
@@ -24,11 +24,7 @@ static struct vesa_mode_info vminfo;
 
 __videocard video_vesa;
 
-#ifndef _WAKEUP
 static void vesa_store_mode_params_graphics(void);
-#else /* _WAKEUP */
-static inline void vesa_store_mode_params_graphics(void) {}
-#endif /* _WAKEUP */
 
 static int vesa_probe(void)
 {
@@ -169,8 +165,6 @@ static int vesa_set_mode(struct mode_inf
 }
 
 
-#ifndef _WAKEUP
-
 /* Switch DAC to 8-bit mode */
 static void vesa_dac_set_8bits(void)
 {
@@ -294,8 +288,6 @@ void vesa_store_edid(void)
 #endif /* CONFIG_FIRMWARE_EDID */
 }
 
-#endif /* not _WAKEUP */
-
 __videocard video_vesa =
 {
 	.card_name	= "VESA",
diff -puN arch/x86/boot/video-vga.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/boot/video-vga.c
--- a/arch/x86/boot/video-vga.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/boot/video-vga.c
@@ -210,8 +210,6 @@ static int vga_set_mode(struct mode_info
  */
 static int vga_probe(void)
 {
-	u16 ega_bx;
-
 	static const char *card_name[] = {
 		"CGA/MDA/HGC", "EGA", "VGA"
 	};
@@ -228,16 +226,12 @@ static int vga_probe(void)
 	u8 vga_flag;
 
 	asm(INT10
-	    : "=b" (ega_bx)
+	    : "=b" (boot_params.screen_info.orig_video_ega_bx)
 	    : "a" (0x1200), "b" (0x10) /* Check EGA/VGA */
 	    : "ecx", "edx", "esi", "edi");
 
-#ifndef _WAKEUP
-	boot_params.screen_info.orig_video_ega_bx = ega_bx;
-#endif
-
 	/* If we have MDA/CGA/HGC then BL will be unchanged at 0x10 */
-	if ((u8)ega_bx != 0x10) {
+	if ((u8)boot_params.screen_info.orig_video_ega_bx != 0x10) {
 		/* EGA/VGA */
 		asm(INT10
 		    : "=a" (vga_flag)
@@ -246,9 +240,7 @@ static int vga_probe(void)
 
 		if (vga_flag == 0x1a) {
 			adapter = ADAPTER_VGA;
-#ifndef _WAKEUP
 			boot_params.screen_info.orig_video_isVGA = 1;
-#endif
 		} else {
 			adapter = ADAPTER_EGA;
 		}
diff -puN arch/x86/boot/video.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/boot/video.c
--- a/arch/x86/boot/video.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/boot/video.c
@@ -18,6 +18,21 @@
 #include "video.h"
 #include "vesa.h"
 
+/*
+ * Mode list variables
+ */
+static struct card_info cards[];    /* List of cards to probe for */
+
+/*
+ * Common variables
+ */
+int adapter;			/* 0=CGA/MDA/HGC, 1=EGA, 2=VGA+ */
+u16 video_segment;
+int force_x, force_y;	/* Don't query the BIOS for cols/rows */
+
+int do_restore = 0;	/* Screen contents changed during mode flip */
+int graphic_mode;	/* Graphic mode with linear frame buffer */
+
 static void store_cursor_position(void)
 {
 	u16 curpos;
@@ -92,6 +107,147 @@ static void store_mode_params(void)
 	boot_params.screen_info.orig_video_lines = y;
 }
 
+/* Probe the video drivers and have them generate their mode lists. */
+static void probe_cards(int unsafe)
+{
+	struct card_info *card;
+	static u8 probed[2];
+
+	if (probed[unsafe])
+		return;
+
+	probed[unsafe] = 1;
+
+	for (card = video_cards; card < video_cards_end; card++) {
+		if (card->unsafe == unsafe) {
+			if (card->probe)
+				card->nmodes = card->probe();
+			else
+				card->nmodes = 0;
+		}
+	}
+}
+
+/* Test if a mode is defined */
+int mode_defined(u16 mode)
+{
+	struct card_info *card;
+	struct mode_info *mi;
+	int i;
+
+	for (card = video_cards; card < video_cards_end; card++) {
+		mi = card->modes;
+		for (i = 0; i < card->nmodes; i++, mi++) {
+			if (mi->mode == mode)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+/* Set mode (without recalc) */
+static int raw_set_mode(u16 mode, u16 *real_mode)
+{
+	int nmode, i;
+	struct card_info *card;
+	struct mode_info *mi;
+
+	/* Drop the recalc bit if set */
+	mode &= ~VIDEO_RECALC;
+
+	/* Scan for mode based on fixed ID, position, or resolution */
+	nmode = 0;
+	for (card = video_cards; card < video_cards_end; card++) {
+		mi = card->modes;
+		for (i = 0; i < card->nmodes; i++, mi++) {
+			int visible = mi->x || mi->y;
+
+			if ((mode == nmode && visible) ||
+			    mode == mi->mode ||
+			    mode == (mi->y << 8)+mi->x) {
+				*real_mode = mi->mode;
+				return card->set_mode(mi);
+			}
+
+			if (visible)
+				nmode++;
+		}
+	}
+
+	/* Nothing found?  Is it an "exceptional" (unprobed) mode? */
+	for (card = video_cards; card < video_cards_end; card++) {
+		if (mode >= card->xmode_first &&
+		    mode < card->xmode_first+card->xmode_n) {
+			struct mode_info mix;
+			*real_mode = mix.mode = mode;
+			mix.x = mix.y = 0;
+			return card->set_mode(&mix);
+		}
+	}
+
+	/* Otherwise, failure... */
+	return -1;
+}
+
+/*
+ * Recalculate the vertical video cutoff (hack!)
+ */
+static void vga_recalc_vertical(void)
+{
+	unsigned int font_size, rows;
+	u16 crtc;
+	u8 pt, ov;
+
+	set_fs(0);
+	font_size = rdfs8(0x485); /* BIOS: font size (pixels) */
+	rows = force_y ? force_y : rdfs8(0x484)+1; /* Text rows */
+
+	rows *= font_size;	/* Visible scan lines */
+	rows--;			/* ... minus one */
+
+	crtc = vga_crtc();
+
+	pt = in_idx(crtc, 0x11);
+	pt &= ~0x80;		/* Unlock CR0-7 */
+	out_idx(pt, crtc, 0x11);
+
+	out_idx((u8)rows, crtc, 0x12); /* Lower height register */
+
+	ov = in_idx(crtc, 0x07); /* Overflow register */
+	ov &= 0xbd;
+	ov |= (rows >> (8-1)) & 0x02;
+	ov |= (rows >> (9-6)) & 0x40;
+	out_idx(ov, crtc, 0x07);
+}
+
+/* Set mode (with recalc if specified) */
+static int set_mode(u16 mode)
+{
+	int rv;
+	u16 real_mode;
+
+	/* Very special mode numbers... */
+	if (mode == VIDEO_CURRENT_MODE)
+		return 0;	/* Nothing to do... */
+	else if (mode == NORMAL_VGA)
+		mode = VIDEO_80x25;
+	else if (mode == EXTENDED_VGA)
+		mode = VIDEO_8POINT;
+
+	rv = raw_set_mode(mode, &real_mode);
+	if (rv)
+		return rv;
+
+	if (mode & VIDEO_RECALC)
+		vga_recalc_vertical();
+
+	/* Save the canonical mode number for the kernel, not
+	   an alias, size specification or menu position */
+	boot_params.hdr.vid_mode = real_mode;
+	return 0;
+}
+
 static unsigned int get_entry(void)
 {
 	char entry_buf[4];
@@ -330,7 +486,6 @@ void set_video(void)
 		printf("Undefined video mode number: %x\n", mode);
 		mode = ASK_VGA;
 	}
-	boot_params.hdr.vid_mode = mode;
 	vesa_store_edid();
 	store_mode_params();
 
diff -puN arch/x86/kernel/acpi/Makefile~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/acpi/Makefile
--- a/arch/x86/kernel/acpi/Makefile~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/acpi/Makefile
@@ -1,13 +1,7 @@
-subdir-				:= realmode
-
 obj-$(CONFIG_ACPI)		+= boot.o
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_rm.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o processor.o
 endif
 
-$(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin
-
-$(obj)/realmode/wakeup.bin: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/realmode $@
diff -puN arch/x86/kernel/acpi/realmode/Makefile~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ /dev/null
@@ -1,57 +0,0 @@
-#
-# arch/x86/kernel/acpi/realmode/Makefile
-#
-# This file is subject to the terms and conditions of the GNU General Public
-# License.  See the file "COPYING" in the main directory of this archive
-# for more details.
-#
-
-targets		:= wakeup.bin wakeup.elf
-
-wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o
-
-# The link order of the video-*.o modules can matter.  In particular,
-# video-vga.o *must* be listed first, followed by video-vesa.o.
-# Hardware-specific drivers should follow in the order they should be
-# probed, and video-bios.o should typically be last.
-wakeup-y	+= video-vga.o
-wakeup-y	+= video-vesa.o
-wakeup-y	+= video-bios.o
-
-targets		+= $(wakeup-y)
-
-bootsrc		:= $(src)/../../../boot
-
-# ---------------------------------------------------------------------------
-
-# How to compile the 16-bit code.  Note we always compile for -march=i386,
-# that way we can complain to the user if the CPU is insufficient.
-# Compile with _SETUP since this is similar to the boot-time setup code.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
-		   -I$(srctree)/$(bootsrc) \
-		   $(cflags-y) \
-		   -Wall -Wstrict-prototypes \
-		   -march=i386 -mregparm=3 \
-		   -include $(srctree)/$(bootsrc)/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer \
-		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-			$(call cc-option, -fno-unit-at-a-time)) \
-		   $(call cc-option, -fno-stack-protector) \
-		   $(call cc-option, -mpreferred-stack-boundary=2)
-KBUILD_CFLAGS	+= $(call cc-option, -m32)
-KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
-
-WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
-
-LDFLAGS_wakeup.elf	:= -T
-
-CPPFLAGS_wakeup.lds += -P -C
-
-$(obj)/wakeup.elf: $(src)/wakeup.lds $(WAKEUP_OBJS) FORCE
-	$(call if_changed,ld)
-
-OBJCOPYFLAGS_wakeup.bin	:= -O binary
-
-$(obj)/wakeup.bin: $(obj)/wakeup.elf FORCE
-	$(call if_changed,objcopy)
diff -puN arch/x86/kernel/acpi/realmode/copy.S~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/copy.S
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/copy.S"
diff -puN arch/x86/kernel/acpi/realmode/video-bios.c~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/video-bios.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-bios.c"
diff -puN arch/x86/kernel/acpi/realmode/video-mode.c~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/video-mode.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-mode.c"
diff -puN arch/x86/kernel/acpi/realmode/video-vesa.c~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/video-vesa.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-vesa.c"
diff -puN arch/x86/kernel/acpi/realmode/video-vga.c~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/video-vga.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-vga.c"
diff -puN arch/x86/kernel/acpi/realmode/wakemain.c~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/wakemain.c
+++ /dev/null
@@ -1,81 +0,0 @@
-#include "wakeup.h"
-#include "boot.h"
-
-static void udelay(int loops)
-{
-	while (loops--)
-		io_delay();	/* Approximately 1 us */
-}
-
-static void beep(unsigned int hz)
-{
-	u8 enable;
-
-	if (!hz) {
-		enable = 0x00;		/* Turn off speaker */
-	} else {
-		u16 div = 1193181/hz;
-
-		outb(0xb6, 0x43);	/* Ctr 2, squarewave, load, binary */
-		io_delay();
-		outb(div, 0x42);	/* LSB of counter */
-		io_delay();
-		outb(div >> 8, 0x42);	/* MSB of counter */
-		io_delay();
-
-		enable = 0x03;		/* Turn on speaker */
-	}
-	inb(0x61);		/* Dummy read of System Control Port B */
-	io_delay();
-	outb(enable, 0x61);	/* Enable timer 2 output to speaker */
-	io_delay();
-}
-
-#define DOT_HZ		880
-#define DASH_HZ		587
-#define US_PER_DOT	125000
-
-/* Okay, this is totally silly, but it's kind of fun. */
-static void send_morse(const char *pattern)
-{
-	char s;
-
-	while ((s = *pattern++)) {
-		switch (s) {
-		case '.':
-			beep(DOT_HZ);
-			udelay(US_PER_DOT);
-			beep(0);
-			udelay(US_PER_DOT);
-			break;
-		case '-':
-			beep(DASH_HZ);
-			udelay(US_PER_DOT * 3);
-			beep(0);
-			udelay(US_PER_DOT);
-			break;
-		default:	/* Assume it's a space */
-			udelay(US_PER_DOT * 3);
-			break;
-		}
-	}
-}
-
-void main(void)
-{
-	/* Kill machine if structures are wrong */
-	if (wakeup_header.real_magic != 0x12345678)
-		while (1);
-
-	if (wakeup_header.realmode_flags & 4)
-		send_morse("...-");
-
-	if (wakeup_header.realmode_flags & 1)
-		asm volatile("lcallw   $0xc000,$3");
-
-	if (wakeup_header.realmode_flags & 2) {
-		/* Need to call BIOS */
-		probe_cards(0);
-		set_mode(wakeup_header.video_mode);
-	}
-}
diff -puN arch/x86/kernel/acpi/realmode/wakeup.S~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- * ACPI wakeup real mode startup stub
- */
-#include <asm/segment.h>
-#include <asm/msr-index.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-
-	.code16
-	.section ".header", "a"
-
-/* This should match the structure in wakeup.h */
-		.globl	wakeup_header
-wakeup_header:
-video_mode:	.short	0	/* Video mode number */
-pmode_return:	.byte	0x66, 0xea	/* ljmpl */
-		.long	0	/* offset goes here */
-		.short	__KERNEL_CS
-pmode_cr0:	.long	0	/* Saved %cr0 */
-pmode_cr3:	.long	0	/* Saved %cr3 */
-pmode_cr4:	.long	0	/* Saved %cr4 */
-pmode_efer:	.quad	0	/* Saved EFER */
-pmode_gdt:	.quad	0
-realmode_flags:	.long	0
-real_magic:	.long	0
-trampoline_segment:	.word 0
-signature:	.long	0x51ee1111
-
-	.text
-	.globl	_start
-	.code16
-wakeup_code:
-_start:
-	cli
-	cld
-
-	/* Set up segments */
-	movw	%cs, %ax
-	movw	%ax, %ds
-	movw	%ax, %es
-	movw	%ax, %ss
-
-	movl	$wakeup_stack_end, %esp
-
-	/* Clear the EFLAGS */
-	pushl	$0
-	popfl
-
-	/* Check header signature... */
-	movl	signature, %eax
-	cmpl	$0x51ee1111, %eax
-	jne	bogus_real_magic
-
-	/* Check we really have everything... */
-	movl	end_signature, %eax
-	cmpl	$0x65a22c82, %eax
-	jne	bogus_real_magic
-
-	/* Call the C code */
-	calll	main
-
-	/* Do any other stuff... */
-
-#ifndef CONFIG_64BIT
-	/* This could also be done in C code... */
-	movl	pmode_cr3, %eax
-	movl	%eax, %cr3
-
-	movl	pmode_cr4, %ecx
-	jecxz	1f
-	movl	%ecx, %cr4
-1:
-	movl	pmode_efer, %eax
-	movl	pmode_efer + 4, %edx
-	movl	%eax, %ecx
-	orl	%edx, %ecx
-	jz	1f
-	movl	$0xc0000080, %ecx
-	wrmsr
-1:
-
-	lgdtl	pmode_gdt
-
-	/* This really couldn't... */
-	movl	pmode_cr0, %eax
-	movl	%eax, %cr0
-	jmp	pmode_return
-#else
-	pushw	$0
-	pushw	trampoline_segment
-	pushw	$0
-	lret
-#endif
-
-bogus_real_magic:
-1:
-	hlt
-	jmp	1b
-
-	.data
-	.balign	4
-	.globl	HEAP, heap_end
-HEAP:
-	.long	wakeup_heap
-heap_end:
-	.long	wakeup_stack
-
-	.bss
-wakeup_heap:
-	.space	2048
-wakeup_stack:
-	.space	2048
-wakeup_stack_end:
diff -puN arch/x86/kernel/acpi/realmode/wakeup.h~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Definitions for the wakeup data structure at the head of the
- * wakeup code.
- */
-
-#ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
-#define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
-
-#ifndef __ASSEMBLY__
-#include <linux/types.h>
-
-/* This must match data at wakeup.S */
-struct wakeup_header {
-	u16 video_mode;		/* Video mode number */
-	u16 _jmp1;		/* ljmpl opcode, 32-bit only */
-	u32 pmode_entry;	/* Protected mode resume point, 32-bit only */
-	u16 _jmp2;		/* CS value, 32-bit only */
-	u32 pmode_cr0;		/* Protected mode cr0 */
-	u32 pmode_cr3;		/* Protected mode cr3 */
-	u32 pmode_cr4;		/* Protected mode cr4 */
-	u32 pmode_efer_low;	/* Protected mode EFER */
-	u32 pmode_efer_high;
-	u64 pmode_gdt;
-	u32 realmode_flags;
-	u32 real_magic;
-	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
-	u32 signature;		/* To check we have correct structure */
-} __attribute__((__packed__));
-
-extern struct wakeup_header wakeup_header;
-#endif
-
-#define HEADER_OFFSET 0x3f00
-#define WAKEUP_SIZE   0x4000
-
-#endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff -puN arch/x86/kernel/acpi/realmode/wakeup.lds.S~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * wakeup.ld
- *
- * Linker script for the real-mode wakeup code
- */
-#undef i386
-#include "wakeup.h"
-
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(_start)
-
-SECTIONS
-{
-	. = HEADER_OFFSET;
-	.header : {
-		 *(.header)
-	}
-
-	. = 0;
-	.text : {
-		 *(.text*)
-	}
-
-	. = ALIGN(16);
-	.rodata : {
-		*(.rodata*)
-	}
-
-	.videocards : {
-		video_cards = .;
-		*(.videocards)
-		video_cards_end = .;
-	}
-
-	. = ALIGN(16);
-	.data : {
-		 *(.data*)
-	}
-
-	.signature : {
-		end_signature = .;
-		LONG(0x65a22c82)
-	}
-
-	. = ALIGN(16);
-	.bss :	{
-		__bss_start = .;
-		*(.bss)
-		__bss_end = .;
-	}
-
-	. = ALIGN(16);
-	_end = .;
-
-	/DISCARD/ : {
-		*(.note*)
-	}
-
-	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
-}
diff -puN arch/x86/kernel/acpi/sleep.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/acpi/sleep.c
--- a/arch/x86/kernel/acpi/sleep.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -10,72 +10,30 @@
 #include <linux/dmi.h>
 #include <linux/cpumask.h>
 
-#include "realmode/wakeup.h"
-#include "sleep.h"
-
-unsigned long acpi_wakeup_address;
-unsigned long acpi_realmode_flags;
+#include <asm/smp.h>
 
 /* address in low memory of the wakeup routine. */
-static unsigned long acpi_realmode;
+unsigned long acpi_wakeup_address = 0;
+unsigned long acpi_realmode_flags;
+extern char wakeup_start, wakeup_end;
 
-#ifdef CONFIG_64BIT
-static char temp_stack[10240];
-#endif
+extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 
 /**
  * acpi_save_state_mem - save kernel state
  *
  * Create an identity mapped page table and copy the wakeup routine to
  * low memory.
- *
- * Note that this is too late to change acpi_wakeup_address.
  */
 int acpi_save_state_mem(void)
 {
-	struct wakeup_header *header;
-
-	if (!acpi_realmode) {
-		printk(KERN_ERR "Could not allocate memory during boot, "
-		       "S3 disabled\n");
+	if (!acpi_wakeup_address) {
+		printk(KERN_ERR "Could not allocate memory during boot, S3 disabled\n");
 		return -ENOMEM;
 	}
-	memcpy((void *)acpi_realmode, &wakeup_code_start, WAKEUP_SIZE);
-
-	header = (struct wakeup_header *)(acpi_realmode + HEADER_OFFSET);
-	if (header->signature != 0x51ee1111) {
-		printk(KERN_ERR "wakeup header does not match\n");
-		return -EINVAL;
-	}
-
-	header->video_mode = saved_video_mode;
-
-#ifndef CONFIG_64BIT
-	store_gdt((struct desc_ptr *)&header->pmode_gdt);
-
-	header->pmode_efer_low = nx_enabled;
-	if (header->pmode_efer_low & 1) {
-		/* This is strange, why not save efer, always? */
-		rdmsr(MSR_EFER, header->pmode_efer_low,
-			header->pmode_efer_high);
-	}
-#endif /* !CONFIG_64BIT */
-
-	header->pmode_cr0 = read_cr0();
-	header->pmode_cr4 = read_cr4();
-	header->realmode_flags = acpi_realmode_flags;
-	header->real_magic = 0x12345678;
-
-#ifndef CONFIG_64BIT
-	header->pmode_entry = (u32)&wakeup_pmode_return;
-	header->pmode_cr3 = (u32)(swsusp_pg_dir - __PAGE_OFFSET);
-	saved_magic = 0x12345678;
-#else /* CONFIG_64BIT */
-	header->trampoline_segment = setup_trampoline() >> 4;
-	init_rsp = (unsigned long)temp_stack + 4096;
-	initial_code = wakeup_long64;
-	saved_magic = 0x123456789abcdef0;
-#endif /* CONFIG_64BIT */
+	memcpy((void *)acpi_wakeup_address, &wakeup_start,
+	       &wakeup_end - &wakeup_start);
+	acpi_copy_wakeup_routine(acpi_wakeup_address);
 
 	return 0;
 }
@@ -98,20 +56,15 @@ void acpi_restore_state_mem(void)
  */
 void __init acpi_reserve_bootmem(void)
 {
-	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
+	if ((&wakeup_end - &wakeup_start) > PAGE_SIZE*2) {
 		printk(KERN_ERR
 		       "ACPI: Wakeup code way too big, S3 disabled.\n");
 		return;
 	}
 
-	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
-
-	if (!acpi_realmode) {
+	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE*2);
+	if (!acpi_wakeup_address)
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
-		return;
-	}
-
-	acpi_wakeup_address = acpi_realmode;
 }
 
 
diff -puN arch/x86/kernel/acpi/sleep.h~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/sleep.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- *	Variables and functions used by the code in sleep.c
- */
-
-#include <asm/trampoline.h>
-
-extern char wakeup_code_start, wakeup_code_end;
-
-extern unsigned long saved_video_mode;
-extern long saved_magic;
-extern unsigned long init_rsp;
-extern void (*initial_code)(void);
-
-extern int wakeup_pmode_return;
-extern char swsusp_pg_dir[PAGE_SIZE];
-
-extern unsigned long acpi_copy_wakeup_routine(unsigned long);
-extern void wakeup_long64(void);
diff -puN /dev/null arch/x86/kernel/acpi/sleep_32.c
--- /dev/null
+++ a/arch/x86/kernel/acpi/sleep_32.c
@@ -0,0 +1,40 @@
+/*
+ * sleep.c - x86-specific ACPI sleep support.
+ *
+ *  Copyright (C) 2001-2003 Patrick Mochel
+ *  Copyright (C) 2001-2003 Pavel Machek <pavel@suse.cz>
+ */
+
+#include <linux/acpi.h>
+#include <linux/bootmem.h>
+#include <linux/dmi.h>
+#include <linux/cpumask.h>
+
+#include <asm/smp.h>
+
+/* Ouch, we want to delete this. We already have better version in userspace, in
+   s2ram from suspend.sf.net project */
+static __init int reset_videomode_after_s3(const struct dmi_system_id *d)
+{
+	acpi_realmode_flags |= 2;
+	return 0;
+}
+
+static __initdata struct dmi_system_id acpisleep_dmi_table[] = {
+	{			/* Reset video mode after returning from ACPI S3 sleep */
+	 .callback = reset_videomode_after_s3,
+	 .ident = "Toshiba Satellite 4030cdt",
+	 .matches = {
+		     DMI_MATCH(DMI_PRODUCT_NAME, "S4030CDT/4.3"),
+		     },
+	 },
+	{}
+};
+
+static int __init acpisleep_dmi_init(void)
+{
+	dmi_check_system(acpisleep_dmi_table);
+	return 0;
+}
+
+core_initcall(acpisleep_dmi_init);
diff -puN arch/x86/kernel/acpi/wakeup_32.S~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/acpi/wakeup_32.S
--- a/arch/x86/kernel/acpi/wakeup_32.S~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/acpi/wakeup_32.S
@@ -3,12 +3,178 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 
-# Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
+#
+# wakeup_code runs in real mode, and at unknown address (determined at run-time).
+# Therefore it must only use relative jumps/calls. 
+#
+# Do we need to deal with A20? It is okay: ACPI specs says A20 must be enabled
+#
+# If physical address of wakeup_code is 0x12345, BIOS should call us with
+# cs = 0x1234, eip = 0x05
+#
+
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
+ALIGN
+	.align	4096
+ENTRY(wakeup_start)
+wakeup_code:
+	wakeup_code_start = .
+	.code16
+
+	cli
+	cld
+
+	# setup data segment
+	movw	%cs, %ax
+	movw	%ax, %ds					# Make ds:0 point to wakeup_start
+	movw	%ax, %ss
+
+	testl   $4, realmode_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
+	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
+
+	pushl	$0						# Kill any dangerous flags
+	popfl
+
+	movl	real_magic - wakeup_code, %eax
+	cmpl	$0x12345678, %eax
+	jne	bogus_real_magic
+
+	testl	$1, realmode_flags - wakeup_code
+	jz	1f
+	lcall   $0xc000,$3
+	movw	%cs, %ax
+	movw	%ax, %ds					# Bios might have played with that
+	movw	%ax, %ss
+1:
+
+	testl	$2, realmode_flags - wakeup_code
+	jz	1f
+	mov	video_mode - wakeup_code, %ax
+	call	mode_set
+1:
+
+	# set up page table
+	movl	$swsusp_pg_dir-__PAGE_OFFSET, %eax
+	movl	%eax, %cr3
+
+	testl	$1, real_efer_save_restore - wakeup_code
+	jz	4f
+	# restore efer setting
+	movl	real_save_efer_edx - wakeup_code, %edx
+	movl	real_save_efer_eax - wakeup_code, %eax
+	mov     $0xc0000080, %ecx
+	wrmsr
+4:
+	# make sure %cr4 is set correctly (features, etc)
+	movl	real_save_cr4 - wakeup_code, %eax
+	movl	%eax, %cr4
+	
+	# need a gdt -- use lgdtl to force 32-bit operands, in case
+	# the GDT is located past 16 megabytes.
+	lgdtl	real_save_gdt - wakeup_code
+
+	movl	real_save_cr0 - wakeup_code, %eax
+	movl	%eax, %cr0
+	jmp 1f
+1:
+	movl	real_magic - wakeup_code, %eax
+	cmpl	$0x12345678, %eax
+	jne	bogus_real_magic
+
+	testl   $8, realmode_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
+	ljmpl	$__KERNEL_CS, $wakeup_pmode_return
+
+real_save_gdt:	.word 0
+		.long 0
+real_save_cr0:	.long 0
+real_save_cr3:	.long 0
+real_save_cr4:	.long 0
+real_magic:	.long 0
+video_mode:	.long 0
+realmode_flags:	.long 0
+real_efer_save_restore:	.long 0
+real_save_efer_edx: 	.long 0
+real_save_efer_eax: 	.long 0
+
+bogus_real_magic:
+	jmp bogus_real_magic
+
+/* This code uses an extended set of video mode numbers. These include:
+ * Aliases for standard modes
+ *	NORMAL_VGA (-1)
+ *	EXTENDED_VGA (-2)
+ *	ASK_VGA (-3)
+ * Video modes numbered by menu position -- NOT RECOMMENDED because of lack
+ * of compatibility when extending the table. These are between 0x00 and 0xff.
+ */
+#define VIDEO_FIRST_MENU 0x0000
+
+/* Standard BIOS video modes (BIOS number + 0x0100) */
+#define VIDEO_FIRST_BIOS 0x0100
+
+/* VESA BIOS video modes (VESA number + 0x0200) */
+#define VIDEO_FIRST_VESA 0x0200
+
+/* Video7 special modes (BIOS number + 0x0900) */
+#define VIDEO_FIRST_V7 0x0900
+
+# Setting of user mode (AX=mode ID) => CF=success
+
+# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
+# modes, we should probably compile in the video code from the boot
+# directory.
+mode_set:
+	movw	%ax, %bx
+	subb	$VIDEO_FIRST_VESA>>8, %bh
+	cmpb	$2, %bh
+	jb	check_vesa
+
+setbad:
+	clc
+	ret
+
+check_vesa:
+	orw	$0x4000, %bx			# Use linear frame buffer
+	movw	$0x4f02, %ax			# VESA BIOS mode set call
+	int	$0x10
+	cmpw	$0x004f, %ax			# AL=4f if implemented
+	jnz	setbad				# AH=0 if OK
+
+	stc
+	ret
 
 	.code32
 	ALIGN
 
-ENTRY(wakeup_pmode_return)
+.org	0x800
+wakeup_stack_begin:	# Stack grows down
+
+.org	0xff0		# Just below end of page
+wakeup_stack:
+ENTRY(wakeup_end)
+	
+.org	0x1000
+
 wakeup_pmode_return:
 	movw	$__KERNEL_DS, %ax
 	movw	%ax, %ss
@@ -21,7 +187,7 @@ wakeup_pmode_return:
 	lgdt	saved_gdt
 	lidt	saved_idt
 	lldt	saved_ldt
-	ljmp	$(__KERNEL_CS), $1f
+	ljmp	$(__KERNEL_CS),$1f
 1:
 	movl	%cr3, %eax
 	movl	%eax, %cr3
@@ -35,41 +201,82 @@ wakeup_pmode_return:
 	jne	bogus_magic
 
 	# jump to place where we left off
-	movl	saved_eip, %eax
+	movl	saved_eip,%eax
 	jmp	*%eax
 
 bogus_magic:
 	jmp	bogus_magic
 
 
+##
+# acpi_copy_wakeup_routine
+#
+# Copy the above routine to low memory.
+#
+# Parameters:
+# %eax:	place to copy wakeup routine to
+#
+# Returned address is location of code in low memory (past data and stack)
+#
+ENTRY(acpi_copy_wakeup_routine)
 
-save_registers:
+	pushl	%ebx
 	sgdt	saved_gdt
 	sidt	saved_idt
 	sldt	saved_ldt
 	str	saved_tss
 
+	movl	nx_enabled, %edx
+	movl	%edx, real_efer_save_restore - wakeup_start (%eax)
+	testl	$1, real_efer_save_restore - wakeup_start (%eax)
+	jz	2f
+	# save efer setting
+	pushl	%eax
+	movl	%eax, %ebx
+	mov     $0xc0000080, %ecx
+	rdmsr
+	movl	%edx, real_save_efer_edx - wakeup_start (%ebx)
+	movl	%eax, real_save_efer_eax - wakeup_start (%ebx)
+	popl	%eax
+2:
+
+	movl    %cr3, %edx
+	movl    %edx, real_save_cr3 - wakeup_start (%eax)
+	movl    %cr4, %edx
+	movl    %edx, real_save_cr4 - wakeup_start (%eax)
+	movl	%cr0, %edx
+	movl	%edx, real_save_cr0 - wakeup_start (%eax)
+	sgdt    real_save_gdt - wakeup_start (%eax)
+
+	movl	saved_videomode, %edx
+	movl	%edx, video_mode - wakeup_start (%eax)
+	movl	acpi_realmode_flags, %edx
+	movl	%edx, realmode_flags - wakeup_start (%eax)
+	movl	$0x12345678, real_magic - wakeup_start (%eax)
+	movl	$0x12345678, saved_magic
+	popl	%ebx
+	ret
+
+save_registers:
 	leal	4(%esp), %eax
 	movl	%eax, saved_context_esp
-	movl	%ebx, saved_context_ebx
-	movl	%ebp, saved_context_ebp
-	movl	%esi, saved_context_esi
-	movl	%edi, saved_context_edi
-	pushfl
-	popl	saved_context_eflags
+	movl %ebx, saved_context_ebx
+	movl %ebp, saved_context_ebp
+	movl %esi, saved_context_esi
+	movl %edi, saved_context_edi
+	pushfl ; popl saved_context_eflags
 
-	movl	$ret_point, saved_eip
+	movl $ret_point, saved_eip
 	ret
 
 
 restore_registers:
-	movl	saved_context_ebp, %ebp
-	movl	saved_context_ebx, %ebx
-	movl	saved_context_esi, %esi
-	movl	saved_context_edi, %edi
-	pushl	saved_context_eflags
-	popfl
-	ret
+	movl saved_context_ebp, %ebp
+	movl saved_context_ebx, %ebx
+	movl saved_context_esi, %esi
+	movl saved_context_edi, %edi
+	pushl saved_context_eflags ; popfl
+	ret	
 
 ENTRY(do_suspend_lowlevel)
 	call	save_processor_state
diff -puN arch/x86/kernel/acpi/wakeup_64.S~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/acpi/wakeup_64.S
--- a/arch/x86/kernel/acpi/wakeup_64.S~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/acpi/wakeup_64.S
@@ -7,18 +7,191 @@
 #include <asm/asm-offsets.h>
 
 # Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
+#
+# wakeup_code runs in real mode, and at unknown address (determined at run-time).
+# Therefore it must only use relative jumps/calls. 
+#
+# Do we need to deal with A20? It is okay: ACPI specs says A20 must be enabled
+#
+# If physical address of wakeup_code is 0x12345, BIOS should call us with
+# cs = 0x1234, eip = 0x05
+#
+
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
+
+ALIGN
+	.align	16
+ENTRY(wakeup_start)
+wakeup_code:
+	wakeup_code_start = .
+	.code16
+
+# Running in *copy* of this code, somewhere in low 1MB.
+
+	cli
+	cld
+	# setup data segment
+	movw	%cs, %ax
+	movw	%ax, %ds		# Make ds:0 point to wakeup_start
+	movw	%ax, %ss
+
+	# Data segment must be set up before we can see whether to beep.
+	testl   $4, realmode_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
+
+					# Private stack is needed for ASUS board
+	mov	$(wakeup_stack - wakeup_code), %sp
+
+	pushl	$0			# Kill any dangerous flags
+	popfl
+
+	movl	real_magic - wakeup_code, %eax
+	cmpl	$0x12345678, %eax
+	jne	bogus_real_magic
+
+	testl	$1, realmode_flags - wakeup_code
+	jz	1f
+	lcall   $0xc000,$3
+	movw	%cs, %ax
+	movw	%ax, %ds		# Bios might have played with that
+	movw	%ax, %ss
+1:
+
+	testl	$2, realmode_flags - wakeup_code
+	jz	1f
+	mov	video_mode - wakeup_code, %ax
+	call	mode_set
+1:
+
+	mov	%ds, %ax			# Find 32bit wakeup_code addr
+	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
+	shll    $4, %esi
+						# Fix up the vectors
+	addl    %esi, wakeup_32_vector - wakeup_code
+	addl    %esi, wakeup_long64_vector - wakeup_code
+	addl    %esi, gdt_48a + 2 - wakeup_code # Fixup the gdt pointer
+
+	lidtl	%ds:idt_48a - wakeup_code
+	lgdtl	%ds:gdt_48a - wakeup_code	# load gdt with whatever is
+						# appropriate
+
+	movl	$1, %eax			# protected mode (PE) bit
+	lmsw	%ax				# This is it!
+	jmp	1f
+1:
+
+	ljmpl   *(wakeup_32_vector - wakeup_code)
+
+	.balign 4
+wakeup_32_vector:
+	.long   wakeup_32 - wakeup_code
+	.word   __KERNEL32_CS, 0
+
+	.code32
+wakeup_32:
+# Running in this code, but at low address; paging is not yet turned on.
+
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
 
-.code64
 	/*
-	 * Hooray, we are in Long 64-bit mode (but still running in low memory)
+	 * Prepare for entering 64bits mode
+	 */
+
+	/* Enable PAE */
+	xorl	%eax, %eax
+	btsl	$5, %eax
+	movl	%eax, %cr4
+
+	/* Setup early boot stage 4 level pagetables */
+	leal    (wakeup_level4_pgt - wakeup_code)(%esi), %eax
+	movl	%eax, %cr3
+
+        /* Check if nx is implemented */
+        movl    $0x80000001, %eax
+        cpuid
+        movl    %edx,%edi
+
+	/* Enable Long Mode */
+	xorl    %eax, %eax
+	btsl	$_EFER_LME, %eax
+
+	/* No Execute supported? */
+	btl	$20,%edi
+	jnc     1f
+	btsl	$_EFER_NX, %eax
+				
+	/* Make changes effective */
+1:	movl    $MSR_EFER, %ecx
+	xorl    %edx, %edx
+	wrmsr
+
+	xorl	%eax, %eax
+	btsl	$31, %eax			/* Enable paging and in turn activate Long Mode */
+	btsl	$0, %eax			/* Enable protected mode */
+
+	/* Make changes effective */
+	movl	%eax, %cr0
+
+	/* At this point:
+		CR4.PAE must be 1
+		CS.L must be 0
+		CR3 must point to PML4
+		Next instruction must be a branch
+		This must be on identity-mapped page
+	*/
+	/*
+	 * At this point we're in long mode but in 32bit compatibility mode
+	 * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
+	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we load
+	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
+	 */
+
+	/* Finally jump in 64bit mode */
+        ljmp    *(wakeup_long64_vector - wakeup_code)(%esi)
+
+	.balign 4
+wakeup_long64_vector:
+	.long   wakeup_long64 - wakeup_code
+	.word   __KERNEL_CS, 0
+
+.code64
+
+	/* Hooray, we are in Long 64-bit mode (but still running in
+	 * low memory)
 	 */
-ENTRY(wakeup_long64)
 wakeup_long64:
-	movq	saved_magic, %rax
-	movq	$0x123456789abcdef0, %rdx
-	cmpq	%rdx, %rax
-	jne	bogus_64_magic
+	/*
+	 * We must switch to a new descriptor in kernel space for the GDT
+	 * because soon the kernel won't have access anymore to the userspace
+	 * addresses where we're currently running on. We have to do that here
+	 * because in 32bit we couldn't load a 64bit linear address.
+	 */
+	lgdt	cpu_gdt_descr
 
+	movq    saved_magic, %rax
+	movq    $0x123456789abcdef0, %rdx
+	cmpq    %rdx, %rax
+	jne     bogus_64_magic
+
+	nop
+	nop
 	movw	$__KERNEL_DS, %ax
 	movw	%ax, %ss	
 	movw	%ax, %ds
@@ -35,8 +208,130 @@ wakeup_long64:
 	movq	saved_rip, %rax
 	jmp	*%rax
 
+.code32
+
+	.align	64	
+gdta:
+	/* Its good to keep gdt in sync with one in trampoline.S */
+	.word	0, 0, 0, 0			# dummy
+	/* ??? Why I need the accessed bit set in order for this to work? */
+	.quad   0x00cf9b000000ffff              # __KERNEL32_CS
+	.quad   0x00af9b000000ffff              # __KERNEL_CS
+	.quad   0x00cf93000000ffff              # __KERNEL_DS
+
+idt_48a:
+	.word	0				# idt limit = 0
+	.word	0, 0				# idt base = 0L
+
+gdt_48a:
+	.word	0x800				# gdt limit=2048,
+						#  256 GDT entries
+	.long   gdta - wakeup_code              # gdt base (relocated in later)
+	
+real_magic:	.quad 0
+video_mode:	.quad 0
+realmode_flags:	.quad 0
+
+.code16
+bogus_real_magic:
+	jmp bogus_real_magic
+
+.code64
 bogus_64_magic:
-	jmp	bogus_64_magic
+	jmp bogus_64_magic
+
+/* This code uses an extended set of video mode numbers. These include:
+ * Aliases for standard modes
+ *	NORMAL_VGA (-1)
+ *	EXTENDED_VGA (-2)
+ *	ASK_VGA (-3)
+ * Video modes numbered by menu position -- NOT RECOMMENDED because of lack
+ * of compatibility when extending the table. These are between 0x00 and 0xff.
+ */
+#define VIDEO_FIRST_MENU 0x0000
+
+/* Standard BIOS video modes (BIOS number + 0x0100) */
+#define VIDEO_FIRST_BIOS 0x0100
+
+/* VESA BIOS video modes (VESA number + 0x0200) */
+#define VIDEO_FIRST_VESA 0x0200
+
+/* Video7 special modes (BIOS number + 0x0900) */
+#define VIDEO_FIRST_V7 0x0900
+
+# Setting of user mode (AX=mode ID) => CF=success
+
+# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
+# modes, we should probably compile in the video code from the boot
+# directory.
+.code16
+mode_set:
+	movw	%ax, %bx
+	subb	$VIDEO_FIRST_VESA>>8, %bh
+	cmpb	$2, %bh
+	jb	check_vesa
+
+setbad:
+	clc
+	ret
+
+check_vesa:
+	orw	$0x4000, %bx			# Use linear frame buffer
+	movw	$0x4f02, %ax			# VESA BIOS mode set call
+	int	$0x10
+	cmpw	$0x004f, %ax			# AL=4f if implemented
+	jnz	setbad				# AH=0 if OK
+
+	stc
+	ret
+
+wakeup_stack_begin:	# Stack grows down
+
+.org	0xff0
+wakeup_stack:		# Just below end of page
+
+.org   0x1000
+ENTRY(wakeup_level4_pgt)
+	.quad   level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.fill   510,8,0
+	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
+	.quad   level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
+
+ENTRY(wakeup_end)
+	
+##
+# acpi_copy_wakeup_routine
+#
+# Copy the above routine to low memory.
+#
+# Parameters:
+# %rdi:	place to copy wakeup routine to
+#
+# Returned address is location of code in low memory (past data and stack)
+#
+	.code64
+ENTRY(acpi_copy_wakeup_routine)
+	pushq	%rax
+	pushq	%rdx
+
+	movl	saved_video_mode, %edx
+	movl	%edx, video_mode - wakeup_start (,%rdi)
+	movl	acpi_realmode_flags, %edx
+	movl	%edx, realmode_flags - wakeup_start (,%rdi)
+	movq	$0x12345678, real_magic - wakeup_start (,%rdi)
+	movq	$0x123456789abcdef0, %rdx
+	movq	%rdx, saved_magic
+
+	movq    saved_magic, %rax
+	movq    $0x123456789abcdef0, %rdx
+	cmpq    %rdx, %rax
+	jne     bogus_64_magic
+
+	# restore the regs we used
+	popq	%rdx
+	popq	%rax
+ENTRY(do_suspend_lowlevel_s4bios)
+	ret
 
 	.align 2
 	.p2align 4,,15
@@ -119,7 +414,7 @@ do_suspend_lowlevel:
 	jmp	restore_processor_state
 .LFE5:
 .Lfe5:
-	.size	do_suspend_lowlevel, .Lfe5-do_suspend_lowlevel
+	.size	do_suspend_lowlevel,.Lfe5-do_suspend_lowlevel
 	
 .data
 ALIGN
diff -puN arch/x86/kernel/acpi/wakeup_rm.S~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/arch/x86/kernel/acpi/wakeup_rm.S
+++ /dev/null
@@ -1,10 +0,0 @@
-/*
- * Wrapper script for the realmode binary as a transport object
- * before copying to low memory.
- */
-	.section ".rodata","a"
-	.globl	wakeup_code_start, wakeup_code_end
-wakeup_code_start:
-	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
-wakeup_code_end:
-	.size	wakeup_code_start, .-wakeup_code_start
diff -puN arch/x86/kernel/e820_64.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/e820_64.c
--- a/arch/x86/kernel/e820_64.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/e820_64.c
@@ -27,7 +27,6 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/kdebug.h>
-#include <asm/trampoline.h>
 
 struct e820map e820;
 
@@ -59,8 +58,8 @@ struct early_res {
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
 	{ 0, PAGE_SIZE, "BIOS data page" },			/* BIOS data page */
-#ifdef CONFIG_X86_TRAMPOLINE
-	{ TRAMPOLINE_BASE, TRAMPOLINE_BASE + 2 * PAGE_SIZE, "TRAMPOLINE" },
+#ifdef CONFIG_SMP
+	{ SMP_TRAMPOLINE_BASE, SMP_TRAMPOLINE_BASE + 2*PAGE_SIZE, "SMP_TRAMPOLINE" },
 #endif
 	{}
 };
diff -puN arch/x86/kernel/head_64.S~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/head_64.S
@@ -132,6 +132,10 @@ ident_complete:
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
 #endif
+#ifdef CONFIG_ACPI_SLEEP
+	addq	%rbp, wakeup_level4_pgt + 0(%rip)
+	addq	%rbp, wakeup_level4_pgt + (511*8)(%rip)
+#endif
 
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
diff -puN arch/x86/kernel/setup_32.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/setup_32.c
@@ -189,7 +189,7 @@ EXPORT_SYMBOL(ist_info);
 extern void early_cpu_init(void);
 extern int root_mountflags;
 
-unsigned long saved_video_mode;
+unsigned long saved_videomode;
 
 #define RAMDISK_IMAGE_START_MASK	0x07FF
 #define RAMDISK_PROMPT_FLAG		0x8000
@@ -714,7 +714,7 @@ void __init setup_arch(char **cmdline_p)
 	edid_info = boot_params.edid_info;
 	apm_info.bios = boot_params.apm_bios_info;
 	ist_info = boot_params.ist_info;
-	saved_video_mode = boot_params.hdr.vid_mode;
+	saved_videomode = boot_params.hdr.vid_mode;
 	if( boot_params.sys_desc_table.length != 0 ) {
 		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
 		machine_id = boot_params.sys_desc_table.table[0];
diff -puN arch/x86/kernel/setup_64.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/setup_64.c
@@ -66,7 +66,6 @@
 #include <asm/mce.h>
 #include <asm/ds.h>
 #include <asm/topology.h>
-#include <asm/trampoline.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
@@ -1185,18 +1184,3 @@ const struct seq_operations cpuinfo_op =
 	.stop =	c_stop,
 	.show =	show_cpuinfo,
 };
-
-#ifdef CONFIG_X86_TRAMPOLINE
-/*
- * Currently trivial. Write the real->protected mode
- * bootstrap into the page concerned. The caller
- * has made sure it's suitably aligned.
- */
-
-unsigned long setup_trampoline(void)
-{
-	void *tramp = __va(TRAMPOLINE_BASE);
-	memcpy(tramp, trampoline_data, trampoline_end - trampoline_data);
-	return virt_to_phys(tramp);
-}
-#endif /* CONFIG_X86_TRAMPOLINE */
diff -puN arch/x86/kernel/smpboot_64.c~git-acpi-revert-suspend-wakeup-code-in-c arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/arch/x86/kernel/smpboot_64.c
@@ -59,7 +59,6 @@
 #include <asm/irq.h>
 #include <asm/hw_irq.h>
 #include <asm/numa.h>
-#include <asm/trampoline.h>
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -97,6 +96,13 @@ EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 DEFINE_PER_CPU(cpumask_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
+/*
+ * Trampoline 80x86 program as an array.
+ */
+
+extern const unsigned char trampoline_data[];
+extern const unsigned char trampoline_end[];
+
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
@@ -121,6 +127,19 @@ struct task_struct *idle_thread_array[NR
 
 
 /*
+ * Currently trivial. Write the real->protected mode
+ * bootstrap into the page concerned. The caller
+ * has made sure it's suitably aligned.
+ */
+
+static unsigned long __cpuinit setup_trampoline(void)
+{
+	void *tramp = __va(SMP_TRAMPOLINE_BASE); 
+	memcpy(tramp, trampoline_data, trampoline_end - trampoline_data);
+	return virt_to_phys(tramp);
+}
+
+/*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
  */
@@ -630,9 +649,6 @@ do_rest:
 	*((volatile unsigned short *) phys_to_virt(0x467)) = start_rip & 0xf;
 	Dprintk("3.\n");
 
-	/* Trampoline assumes it is at beggining of segment */
-	BUG_ON(start_rip & 0xf);
-
 	/*
 	 * Be paranoid about clearing APIC errors.
 	 */
@@ -671,7 +687,7 @@ do_rest:
 			Dprintk("CPU has booted.\n");
 		} else {
 			boot_error = 1;
-			if (*((unsigned char *)phys_to_virt(TRAMPOLINE_BASE))
+			if (*((volatile unsigned char *)phys_to_virt(SMP_TRAMPOLINE_BASE))
 					== 0xA5)
 				/* trampoline started but...? */
 				printk("Stuck ??\n");
diff -puN include/asm-x86/smp_64.h~git-acpi-revert-suspend-wakeup-code-in-c include/asm-x86/smp_64.h
--- a/include/asm-x86/smp_64.h~git-acpi-revert-suspend-wakeup-code-in-c
+++ a/include/asm-x86/smp_64.h
@@ -47,6 +47,8 @@ static inline int cpu_present_to_apicid(
 
 #ifdef CONFIG_SMP
 
+#define SMP_TRAMPOLINE_BASE 0x6000
+
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void prefill_possible_map(void);
diff -puN include/asm-x86/trampoline.h~git-acpi-revert-suspend-wakeup-code-in-c /dev/null
--- a/include/asm-x86/trampoline.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef __TRAMPOLINE_HEADER
-#define __TRAMPOLINE_HEADER
-
-#ifndef __ASSEMBLY__
-
-#define TRAMPOLINE_BASE 0x6000
-
-/*
- * Trampoline 80x86 program as an array.
- */
-extern const unsigned char trampoline_data[];
-extern const unsigned char trampoline_end[];
-
-extern unsigned long setup_trampoline(void);
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __TRAMPOLINE_HEADER */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hotplug-memory-make-online_page-common-fix.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
git-acpi-revert-suspend-wakeup-code-in-c.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
arch-x86-mm-ioremapc-fix-printk-warnings.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
git-kgdb-light.patch
git-x86-hack-around-to-make-git-kgdb-build.patch
git-x86-vs-git-kgdb-lite.patch
git-alsa-tiwai.patch
es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
git-drm.patch
revert-git-drm.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch
git-input.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-kvm.patch
git-leds.patch
git-libata-all.patch
pata_atiixp-simplex-clear-fix.patch
git-async-tx.patch
git-mips.patch
git-net.patch
git-net-git-rejects.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-sched.patch
add-rcu_assign_index-if-ever-needed.patch
git-sh.patch
sh-arch-sh-kernel-traps_32c-needs-asm-fpuh.patch
sh-export-empty_zero_page.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

