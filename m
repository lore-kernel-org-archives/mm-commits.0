From: akpm@linux-foundation.org
Subject: + video-console-sticonrec-make-code-static.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:14:42 -0700
Message-ID: <200807010714.m617EgYU014464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbYGAHP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 03:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     video/console/stico{n,re}.c: make code static
has been added to the -mm tree.  Its filename is
     video-console-sticonrec-make-code-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/console/stico{n,re}.c: make code static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global code static:
- sticon.c: sticonsole_init()
- sticore.c: struct default_sti
- sticore.c: sti_init_graph()
- sticore.c: sti_inq_conf()
- sticore.c: sti_rom_copy()
- sticore.c: sti_select_fbfont()
- sticore.c: sti_select_font()
- sticore.c: sti_get_wmode_rom()
- sticore.c: sti_read_rom()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/sticon.c  |    2 -
 drivers/video/console/sticore.c |   33 +++++++++++++-----------------
 drivers/video/sticore.h         |    2 -
 3 files changed, 16 insertions(+), 21 deletions(-)

diff -puN drivers/video/console/sticon.c~video-console-sticonrec-make-code-static drivers/video/console/sticon.c
--- a/drivers/video/console/sticon.c~video-console-sticonrec-make-code-static
+++ a/drivers/video/console/sticon.c
@@ -370,7 +370,7 @@ static const struct consw sti_con = {
 
 
 
-int __init sticonsole_init(void)
+static int __init sticonsole_init(void)
 {
     /* already initialized ? */
     if (sticon_sti)
diff -puN drivers/video/console/sticore.c~video-console-sticonrec-make-code-static drivers/video/console/sticore.c
--- a/drivers/video/console/sticore.c~video-console-sticonrec-make-code-static
+++ a/drivers/video/console/sticore.c
@@ -29,7 +29,7 @@
 
 #define STI_DRIVERVERSION "Version 0.9a"
 
-struct sti_struct *default_sti __read_mostly;
+static struct sti_struct *default_sti __read_mostly;
 
 /* number of STI ROMS found and their ptrs to each struct */
 static int num_sti_roms __read_mostly;
@@ -68,8 +68,7 @@ static const struct sti_init_flags defau
 	.init_cmap_tx = 1,
 };
 
-int
-sti_init_graph(struct sti_struct *sti) 
+static int sti_init_graph(struct sti_struct *sti)
 {
 	struct sti_init_inptr_ext inptr_ext = { 0, };
 	struct sti_init_inptr inptr = {
@@ -100,8 +99,7 @@ static const struct sti_conf_flags defau
 	.wait	= STI_WAIT,
 };
 
-void
-sti_inq_conf(struct sti_struct *sti)
+static void sti_inq_conf(struct sti_struct *sti)
 {
 	struct sti_conf_inptr inptr = { 0, };
 	unsigned long flags;
@@ -237,8 +235,8 @@ static void sti_flush(unsigned long star
 	flush_icache_range(start, end);
 }
 
-void __devinit
-sti_rom_copy(unsigned long base, unsigned long count, void *dest)
+static void __devinit sti_rom_copy(unsigned long base, unsigned long count,
+				   void *dest)
 {
 	unsigned long dest_start = (unsigned long) dest;
 
@@ -478,8 +476,8 @@ sti_init_glob_cfg(struct sti_struct *sti
 }
 
 #ifdef CONFIG_FB
-struct sti_cooked_font * __devinit
-sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
+static struct sti_cooked_font __devinit
+*sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
 {
 	const struct font_desc *fbfont;
 	unsigned int size, bpc;
@@ -534,16 +532,16 @@ sti_select_fbfont(struct sti_cooked_rom 
 	return cooked_font;
 }
 #else
-struct sti_cooked_font * __devinit
-sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
+static struct sti_cooked_font __devinit
+*sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
 {
 	return NULL;
 }
 #endif
 
-struct sti_cooked_font * __devinit
-sti_select_font(struct sti_cooked_rom *rom,
-	    int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )
+static struct sti_cooked_font __devinit
+*sti_select_font(struct sti_cooked_rom *rom,
+		 int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )
 {
 	struct sti_cooked_font *font;
 	int i;
@@ -707,8 +705,7 @@ sti_get_bmode_rom (unsigned long address
 	return raw;
 }
 
-struct sti_rom * __devinit
-sti_get_wmode_rom (unsigned long address)
+static struct sti_rom __devinit *sti_get_wmode_rom(unsigned long address)
 {
 	struct sti_rom *raw;
 	unsigned long size;
@@ -723,8 +720,8 @@ sti_get_wmode_rom (unsigned long address
 	return raw;
 }
 
-int __devinit
-sti_read_rom(int wordmode, struct sti_struct *sti, unsigned long address)
+static int __devinit sti_read_rom(int wordmode, struct sti_struct *sti,
+				  unsigned long address)
 {
 	struct sti_cooked_rom *cooked;
 	struct sti_rom *raw = NULL;
diff -puN drivers/video/sticore.h~video-console-sticonrec-make-code-static drivers/video/sticore.h
--- a/drivers/video/sticore.h~video-console-sticonrec-make-code-static
+++ a/drivers/video/sticore.h
@@ -352,8 +352,6 @@ struct sti_struct *sti_get_rom(unsigned 
 
 /* functions to call the STI ROM directly */
 
-int  sti_init_graph(struct sti_struct *sti);
-void sti_inq_conf(struct sti_struct *sti);
 void sti_putc(struct sti_struct *sti, int c, int y, int x);
 void sti_set(struct sti_struct *sti, int src_y, int src_x,
 	     int height, int width, u8 color);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
firmware-fix-the-request_firmware-dummy.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
scsi-make-struct-scsi_hosttarget_type-static.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
mm-page_allocc-cleanups.patch
mm-make-register_page_bootmem_info_section-static.patch
remove-include-asm-h8300-keyboardh.patch
alpha-remove-the-unused-alpha_core_agp-option.patch
remove-include-linux-pm_legacyh.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
video-sis-remove-compat-code.patch
drivers-video-amifbc-cleanups.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
remove-is_tty.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

