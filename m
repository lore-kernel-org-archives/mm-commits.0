From: akpm@linux-foundation.org
Subject: - revert-vt-fix-background-color-on-line-feed.patch removed from -mm tree
Date: Fri, 09 May 2008 15:11:48 -0700
Message-ID: <200805092222.m49MMjL9028584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYEIWX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 18:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, hpa@zytor.com, jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     revert "vt: fix background color on line feed"
has been removed from the -mm tree.  Its filename was
     revert-vt-fix-background-color-on-line-feed.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "vt: fix background color on line feed"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit c9e587abfdec2c2aaa55fab83bcb4972e2f84f9b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Apr 29 00:59:46 2008 -0700

    vt: fix background color on line feed
    
    A command that causes a line feed while a background color is active,
    such as
    
    	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
    and
    	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
    
    causes the line that was started as a result of the line feed to be completely
    filled with the currently active background color instead of the default
    color.
    
    When scrolling, part of the current screen is memcpy'd/memmove'd to the new
    region, and the new line(s) that will appear as a result are cleared using
    memset.  However, the lines are cleared with vc->vc_video_erase_char, causing
    them to be colored with the currently active background color.  This is
    different from X11 terminal emulators which always paint the new lines with
    the default background color (e.g.  `xterm -bg black`).
    
    The clear operation (\e[1J and \e[2J) also use vc_video_erase_char, so a new
    vc->vc_scrl_erase_char is introduced with contains the erase character used
    for scrolling, which is built from vc->vc_def_color instead of vc->vc_color.

Because davem reports that it

Causes garbage characters to appear at the end of lines on my VCs when
scrolling.

They look like lowercase 'c' characters with a '.' above them, and they are
colored light blue.  The rest of the console text is fine.

I think it might be because my VC gets put into a UTF8 mode or something like
that via the init scripts?  It seems to start happening right when the init
scripts print "Setting up console font and keymap", which seems to come from
/etc/init.d/console-setup which runs /bin/setupcon

This is with a stock Ubuntu 7.10 installation.
    
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c              |    7 +++----
 drivers/video/console/fbcon.c  |    8 ++++----
 drivers/video/console/mdacon.c |    2 +-
 drivers/video/console/sticon.c |    4 ++--
 drivers/video/console/vgacon.c |    4 ++--
 include/linux/console_struct.h |    1 -
 6 files changed, 12 insertions(+), 14 deletions(-)

diff -puN drivers/char/vt.c~revert-vt-fix-background-color-on-line-feed drivers/char/vt.c
--- a/drivers/char/vt.c~revert-vt-fix-background-color-on-line-feed
+++ a/drivers/char/vt.c
@@ -301,7 +301,7 @@ static void scrup(struct vc_data *vc, un
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_scrl_erase_char,
+	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
 		    vc->vc_size_row * nr);
 }
 
@@ -319,7 +319,7 @@ static void scrdown(struct vc_data *vc, 
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	step = vc->vc_cols * nr;
 	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(s, vc->vc_scrl_erase_char, 2 * step);
+	scr_memsetw(s, vc->vc_video_erase_char, 2 * step);
 }
 
 static void do_update_region(struct vc_data *vc, unsigned long start, int count)
@@ -400,7 +400,7 @@ static u8 build_attr(struct vc_data *vc,
  *  Bit 7   : blink
  */
 	{
-	u8 a = _color;
+	u8 a = vc->vc_color;
 	if (!vc->vc_can_do_color)
 		return _intensity |
 		       (_italic ? 2 : 0) |
@@ -434,7 +434,6 @@ static void update_attr(struct vc_data *
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
-	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, false, false) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
diff -puN drivers/video/console/fbcon.c~revert-vt-fix-background-color-on-line-feed drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~revert-vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/fbcon.c
@@ -1881,7 +1881,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 			break;
@@ -1953,7 +1953,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 		}
@@ -1972,7 +1972,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 			break;
@@ -2042,7 +2042,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 		}
diff -puN drivers/video/console/mdacon.c~revert-vt-fix-background-color-on-line-feed drivers/video/console/mdacon.c
--- a/drivers/video/console/mdacon.c~revert-vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/mdacon.c
@@ -531,7 +531,7 @@ static void mdacon_cursor(struct vc_data
 
 static int mdacon_scroll(struct vc_data *c, int t, int b, int dir, int lines)
 {
-	u16 eattr = mda_convert_attr(c->vc_scrl_erase_char);
+	u16 eattr = mda_convert_attr(c->vc_video_erase_char);
 
 	if (!lines)
 		return 0;
diff -puN drivers/video/console/sticon.c~revert-vt-fix-background-color-on-line-feed drivers/video/console/sticon.c
--- a/drivers/video/console/sticon.c~revert-vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/sticon.c
@@ -170,12 +170,12 @@ static int sticon_scroll(struct vc_data 
     switch (dir) {
     case SM_UP:
 	sti_bmove(sti, t + count, 0, t, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
+	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_video_erase_char);
 	break;
 
     case SM_DOWN:
 	sti_bmove(sti, t, 0, t + count, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
+	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_video_erase_char);
 	break;
     }
 
diff -puN drivers/video/console/vgacon.c~revert-vt-fix-background-color-on-line-feed drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~revert-vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/vgacon.c
@@ -1350,7 +1350,7 @@ static int vgacon_scroll(struct vc_data 
 		} else
 			c->vc_origin += delta;
 		scr_memsetw((u16 *) (c->vc_origin + c->vc_screenbuf_size -
-				     delta), c->vc_scrl_erase_char,
+				     delta), c->vc_video_erase_char,
 			    delta);
 	} else {
 		if (oldo - delta < vga_vram_base) {
@@ -1363,7 +1363,7 @@ static int vgacon_scroll(struct vc_data 
 		} else
 			c->vc_origin -= delta;
 		c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
-		scr_memsetw((u16 *) (c->vc_origin), c->vc_scrl_erase_char,
+		scr_memsetw((u16 *) (c->vc_origin), c->vc_video_erase_char,
 			    delta);
 	}
 	c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
diff -puN include/linux/console_struct.h~revert-vt-fix-background-color-on-line-feed include/linux/console_struct.h
--- a/include/linux/console_struct.h~revert-vt-fix-background-color-on-line-feed
+++ a/include/linux/console_struct.h
@@ -53,7 +53,6 @@ struct vc_data {
 	unsigned short	vc_hi_font_mask;	/* [#] Attribute set for upper 256 chars of font or 0 if not supported */
 	struct console_font vc_font;		/* Current VC font set */
 	unsigned short	vc_video_erase_char;	/* Background erase character */
-	unsigned short	vc_scrl_erase_char;	/* Erase character for scroll */
 	/* VT terminal data */
 	unsigned int	vc_state;		/* Escape sequence parser state */
 	unsigned int	vc_npar,vc_par[NPAR];	/* Parameters of current escape sequence */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
fix-hfsplus-oops-on-image-without-extents-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-kernel-setupc-printk-warning-fix.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
git-mmc.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model-fix.patch
mm-verify-the-page-links-and-memory-model-fix-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
reiser4-semaphore-fix.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

