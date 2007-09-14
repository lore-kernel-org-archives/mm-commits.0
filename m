From: akpm@linux-foundation.org
Subject: + i-oat-add-support-for-msi-and-msi-x-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 17:52:34 -0700
Message-ID: <200709140052.l8E0qYn4014103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbXINAwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 20:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, shannon.nelson@intel.com


The patch titled
     drivers/dma/ioat_dma.c: make 3 functions static
has been added to the -mm tree.  Its filename is
     i-oat-add-support-for-msi-and-msi-x-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/dma/ioat_dma.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-add-support-for-msi-and-msi-x-fix drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-add-support-for-msi-and-msi-x-fix
+++ a/drivers/dma/ioat_dma.c
@@ -47,8 +47,8 @@
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
 
-struct ioat_dma_chan *ioat_lookup_chan_by_index(struct ioatdma_device *device,
-						int index)
+static struct ioat_dma_chan *ioat_lookup_chan_by_index(struct ioatdma_device *device,
+						       int index)
 {
 	return device->idx[index];
 }
@@ -716,7 +716,7 @@ MODULE_PARM_DESC(ioat_interrupt_style,
  * ioat_dma_setup_interrupts - setup interrupt handler
  * @device: ioat device
  */
-int ioat_dma_setup_interrupts(struct ioatdma_device *device)
+static int ioat_dma_setup_interrupts(struct ioatdma_device *device)
 {
 	struct ioat_dma_chan *ioat_chan;
 	int err, i, j, msixcnt;
@@ -826,7 +826,7 @@ err_no_irq:
  * ioat_dma_remove_interrupts - remove whatever interrupts were set
  * @device: ioat device
  */
-void ioat_dma_remove_interrupts(struct ioatdma_device *device)
+static void ioat_dma_remove_interrupts(struct ioatdma_device *device)
 {
 	struct ioat_dma_chan *ioat_chan;
 	int i;
_

Patches currently in -mm which might be from bunk@kernel.org are

fix-serial_core_console-driver-dependencies.patch
git-alsa.patch
arm-extern-inline-static-inline.patch
omap1-leds-innovatorc-remove-dead-code.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
