From: akpm@linux-foundation.org
Subject: + fbdev-hecuba-framebuffer-driver-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:51:29 -0800
Message-ID: <200703060351.l263pTEQ011084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49413 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922AbXCFDyo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:54:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, adaplas@gmail.com, jayakumar.lkml@gmail.com


The patch titled
     drivers/video/hecubafb.c: make 4 functions static
has been added to the -mm tree.  Its filename is
     fbdev-hecuba-framebuffer-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/hecubafb.c: make 4 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the following needlessly global functions static:
- hcb_wait_for_ack()
- hcb_wait_for_ack_clear()
- apollo_send_data()
- apollo_send_command()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hecubafb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/hecubafb.c~fbdev-hecuba-framebuffer-driver-fix drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~fbdev-hecuba-framebuffer-driver-fix
+++ a/drivers/video/hecubafb.c
@@ -145,7 +145,7 @@ static int __devinit apollo_init_control
 	return 0;
 }
 
-void hcb_wait_for_ack(struct hecubafb_par *par)
+static void hcb_wait_for_ack(struct hecubafb_par *par)
 {
 
 	int timeout;
@@ -161,7 +161,7 @@ void hcb_wait_for_ack(struct hecubafb_pa
 	printk(KERN_ERR "timed out waiting for ack\n");
 }
 
-void hcb_wait_for_ack_clear(struct hecubafb_par *par)
+static void hcb_wait_for_ack_clear(struct hecubafb_par *par)
 {
 
 	int timeout;
@@ -177,7 +177,7 @@ void hcb_wait_for_ack_clear(struct hecub
 	printk(KERN_ERR "timed out waiting for clear\n");
 }
 
-void apollo_send_data(struct hecubafb_par *par, unsigned char data)
+static void apollo_send_data(struct hecubafb_par *par, unsigned char data)
 {
 	/* set data */
 	hcb_set_data(par, data);
@@ -195,7 +195,7 @@ void apollo_send_data(struct hecubafb_pa
 	hcb_wait_for_ack_clear(par);
 }
 
-void apollo_send_command(struct hecubafb_par *par, unsigned char data)
+static void apollo_send_command(struct hecubafb_par *par, unsigned char data)
 {
 	/* command so set CD to high */
 	par->ctl &= ~(HCB_NCD_BIT);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-arch-i386-kernel-tscccustom_sched_clock.patch
drivers-cpuidle-make-code-static.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
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
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
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
