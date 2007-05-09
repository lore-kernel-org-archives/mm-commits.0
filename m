From: akpm@linux-foundation.org
Subject: - drivers-char-hvc_consolec-cleanups.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:43 -0700
Message-ID: <200705090244.l492ihH6008619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969725AbXEICpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     drivers/char/hvc_console.c: cleanups
has been removed from the -mm tree.  Its filename was
     drivers-char-hvc_consolec-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -111,7 +111,7 @@ static int last_hvc = -1;
  * lock held.  If successful, this function increments the kobject reference
  * count against the target hvc_struct so it should be released when finished.
  */
-struct hvc_struct *hvc_get_by_index(int index)
+static struct hvc_struct *hvc_get_by_index(int index)
 {
 	struct hvc_struct *hp;
 	unsigned long flags;
@@ -150,7 +150,8 @@ static uint32_t vtermnos[MAX_NR_HVC_CONS
  * hvc_console_setup() finds adapters.
  */
 
-void hvc_console_print(struct console *co, const char *b, unsigned count)
+static void hvc_console_print(struct console *co, const char *b,
+			      unsigned count)
 {
 	char c[N_OUTBUF] __ALIGNED__;
 	unsigned i = 0, n = 0;
@@ -208,7 +209,7 @@ static int __init hvc_console_setup(stru
 	return 0;
 }
 
-struct console hvc_con_driver = {
+static struct console hvc_con_driver = {
 	.name		= "hvc",
 	.write		= hvc_console_print,
 	.device		= hvc_console_device,
@@ -278,7 +279,6 @@ int hvc_instantiate(uint32_t vtermno, in
 
 	return 0;
 }
-EXPORT_SYMBOL(hvc_instantiate);
 
 /* Wake the sleeping khvcd */
 static void hvc_kick(void)
@@ -792,7 +792,6 @@ struct hvc_struct __devinit *hvc_alloc(u
 
 	return hp;
 }
-EXPORT_SYMBOL(hvc_alloc);
 
 int __devexit hvc_remove(struct hvc_struct *hp)
 {
@@ -828,11 +827,10 @@ int __devexit hvc_remove(struct hvc_stru
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

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
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
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
