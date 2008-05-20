From: akpm@linux-foundation.org
Subject: + pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch added to -mm tree
Date: Mon, 19 May 2008 23:09:44 -0700
Message-ID: <200805200609.m4K69iY8008113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbYETGKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cooloney@kernel.org, michael.hennerich@analog.com


The patch titled
     pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch

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
Subject: pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#86: FILE: drivers/pcmcia/bfin_cf_pcmcia.c:41:
+#include <asm/io.h>

WARNING: Use #include <linux/gpio.h> instead of <asm/gpio.h>
#87: FILE: drivers/pcmcia/bfin_cf_pcmcia.c:42:
+#include <asm/gpio.h>

ERROR: "foo * bar" should be "foo *bar"
#150: FILE: drivers/pcmcia/bfin_cf_pcmcia.c:105:
+static int bfin_cf_get_status(struct pcmcia_socket *s, u_int * sp)

WARNING: __func__ should be used instead of gcc specific __FUNCTION__
#200: FILE: drivers/pcmcia/bfin_cf_pcmcia.c:155:
+	pr_debug("%s: %s\n", driver_name, __FUNCTION__);

total: 1 errors, 3 warnings, 369 lines checked

./patches/pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bryan Wu <cooloney@kernel.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/bfin_cf_pcmcia.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pcmcia/bfin_cf_pcmcia.c~pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes drivers/pcmcia/bfin_cf_pcmcia.c
--- a/drivers/pcmcia/bfin_cf_pcmcia.c~pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes
+++ a/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -35,10 +35,10 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/io.h>
 
 #include <pcmcia/ss.h>
 #include <pcmcia/cisreg.h>
-#include <asm/io.h>
 #include <asm/gpio.h>
 
 #define	SZ_1K	0x00000400
@@ -102,7 +102,7 @@ static void bfin_cf_timer(unsigned long 
 		mod_timer(&cf->timer, jiffies + POLL_INTERVAL);
 }
 
-static int bfin_cf_get_status(struct pcmcia_socket *s, u_int * sp)
+static int bfin_cf_get_status(struct pcmcia_socket *s, u_int *sp)
 {
 	struct bfin_cf_socket *cf;
 
@@ -152,7 +152,7 @@ bfin_cf_set_socket(struct pcmcia_socket 
 
 static int bfin_cf_ss_suspend(struct pcmcia_socket *s)
 {
-	pr_debug("%s: %s\n", driver_name, __FUNCTION__);
+	pr_debug("%s: %s\n", driver_name, __func__);
 	return bfin_cf_set_socket(s, &dead_socket);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
audit_send_reply-fix-error-path-memory-leak.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
sfc-correct-and-expand-some-comments.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-vfs-cleanups-reject.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
git-xtensa.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
spufs-use-the-new-vm_ops-access-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
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

