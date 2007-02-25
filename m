From: akpm@linux-foundation.org
Subject: + drivers-char-hvc_consolec-cleanups.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:25:17 -0800
Message-ID: <200702251225.l1PCPJOj029221@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34591 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964854AbXBYM2u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:28:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, sfr@canb.auug.org.au


The patch titled
     drivers/char/hvc_console.c: cleanups
has been added to the -mm tree.  Its filename is
     drivers-char-hvc_consolec-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/hvc_console.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

- make needlessly global code static
- remove the unused EXPORT_SYMBOL's

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_console.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/char/hvc_console.c~drivers-char-hvc_consolec-cleanups drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~drivers-char-hvc_consolec-cleanups
+++ a/drivers/char/hvc_console.c
@@ -121,7 +121,7 @@ static int last_hvc = -1;
  * lock held.  If successful, this function increments the kobject reference
  * count against the target hvc_struct so it should be released when finished.
  */
-struct hvc_struct *hvc_get_by_index(int index)
+static struct hvc_struct *hvc_get_by_index(int index)
 {
 	struct hvc_struct *hp;
 	unsigned long flags;
@@ -160,7 +160,8 @@ static uint32_t vtermnos[MAX_NR_HVC_CONS
  * hvc_console_setup() finds adapters.
  */
 
-void hvc_console_print(struct console *co, const char *b, unsigned count)
+static void hvc_console_print(struct console *co, const char *b,
+			      unsigned count)
 {
 	char c[N_OUTBUF] __ALIGNED__;
 	unsigned i = 0, n = 0;
@@ -218,7 +219,7 @@ static int __init hvc_console_setup(stru
 	return 0;
 }
 
-struct console hvc_con_driver = {
+static struct console hvc_con_driver = {
 	.name		= "hvc",
 	.write		= hvc_console_print,
 	.device		= hvc_console_device,
@@ -288,7 +289,6 @@ int hvc_instantiate(uint32_t vtermno, in
 
 	return 0;
 }
-EXPORT_SYMBOL(hvc_instantiate);
 
 /* Wake the sleeping khvcd */
 static void hvc_kick(void)
@@ -781,7 +781,6 @@ struct hvc_struct __devinit *hvc_alloc(u
 
 	return hp;
 }
-EXPORT_SYMBOL(hvc_alloc);
 
 int __devexit hvc_remove(struct hvc_struct *hp)
 {
@@ -817,11 +816,10 @@ int __devexit hvc_remove(struct hvc_stru
 		tty_hangup(tty);
 	return 0;
 }
-EXPORT_SYMBOL(hvc_remove);
 
 /* Driver initialization.  Follow console initialization.  This is where the TTY
  * interfaces start to become available. */
-int __init hvc_init(void)
+static int __init hvc_init(void)
 {
 	struct tty_driver *drv;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
drivers-video-sm501fbc-make-4-functions-static.patch
git-cpufreq.patch
make-kernel-kmodckmod_mk-static.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
mtd_ubi_debug-must-depend-on-sysfs.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
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
make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
