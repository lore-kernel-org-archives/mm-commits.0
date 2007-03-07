From: akpm@linux-foundation.org
Subject: + drivers-macintosh-mac_hidc-make-code-static.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:58:48 -0800
Message-ID: <200703072258.l27Mwm4W011995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291AbXCGXCF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     drivers/macintosh/mac_hid.c: make code static
has been added to the -mm tree.  Its filename is
     drivers-macintosh-mac_hidc-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/macintosh/mac_hid.c: make code static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/mac_hid.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/macintosh/mac_hid.c~drivers-macintosh-mac_hidc-make-code-static drivers/macintosh/mac_hid.c
--- a/drivers/macintosh/mac_hid.c~drivers-macintosh-mac_hidc-make-code-static
+++ a/drivers/macintosh/mac_hid.c
@@ -24,7 +24,7 @@ static int mouse_last_keycode;
 
 #if defined(CONFIG_SYSCTL)
 /* file(s) in /proc/sys/dev/mac_hid */
-ctl_table mac_hid_files[] = {
+static ctl_table mac_hid_files[] = {
 	{
 		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON_EMULATION,
 		.procname	= "mouse_button_emulation",
@@ -53,7 +53,7 @@ ctl_table mac_hid_files[] = {
 };
 
 /* dir in /proc/sys/dev */
-ctl_table mac_hid_dir[] = {
+static ctl_table mac_hid_dir[] = {
 	{
 		.ctl_name	= DEV_MAC_HID,
 		.procname	= "mac_hid",
@@ -65,7 +65,7 @@ ctl_table mac_hid_dir[] = {
 };
 
 /* /proc/sys/dev itself, in case that is not there yet */
-ctl_table mac_hid_root_dir[] = {
+static ctl_table mac_hid_root_dir[] = {
 	{
 		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
@@ -129,7 +129,7 @@ static int emumousebtn_input_register(vo
 	return ret;
 }
 
-int __init mac_hid_init(void)
+static int __init mac_hid_init(void)
 {
 	int err;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
