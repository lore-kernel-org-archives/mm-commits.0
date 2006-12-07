From: akpm@osdl.org
Subject: - ide_scsi-allow-it-to-be-used-for-non-cd-only.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:01 -0800
Message-ID: <200612072315.kB7NF1lU030678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163932AbWLGXSs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:18:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, B.Zolnierkiewicz@elka.pw.edu.pl, alan@redhat.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ide_scsi: allow it to be used for non CD only
has been removed from the -mm tree.  Its filename was
     ide_scsi-allow-it-to-be-used-for-non-cd-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide_scsi: allow it to be used for non CD only
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Some people want to use ide_cd for CD-ROM but still dynamically load
ide-scsi for things like tape drives.  If you compile in the CD driver this
works out but if you want them modular you need an option to ensure that
whoever loads first the right things happen.

This replaces the original draft patch which leaked a scsi host reference

[akpm@osdl.org: add MODULE_PARM_DESC]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ide-scsi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/scsi/ide-scsi.c~ide_scsi-allow-it-to-be-used-for-non-cd-only drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c~ide_scsi-allow-it-to-be-used-for-non-cd-only
+++ a/drivers/scsi/ide-scsi.c
@@ -110,6 +110,7 @@ typedef struct ide_scsi_obj {
 } idescsi_scsi_t;
 
 static DEFINE_MUTEX(idescsi_ref_mutex);
+static int idescsi_nocd;			/* Set by module param to skip cd */
 
 #define ide_scsi_g(disk) \
 	container_of((disk)->private_data, struct ide_scsi_obj, driver)
@@ -1127,6 +1128,9 @@ static int ide_scsi_probe(ide_drive_t *d
 		warned = 1;
 	}
 
+	if (idescsi_nocd && drive->media == ide_cdrom)
+		return -ENODEV;
+
 	if (!strstr("ide-scsi", drive->driver_req) ||
 	    !drive->present ||
 	    drive->media == ide_disk ||
@@ -1187,6 +1191,8 @@ static void __exit exit_idescsi_module(v
 	driver_unregister(&idescsi_driver.gen_driver);
 }
 
+module_param(idescsi_nocd, int, 0600);
+MODULE_PARM_DESC(idescsi_nocd, "Disable handling of CD-ROMs so they may be driven by ide-cd");
 module_init(init_idescsi_module);
 module_exit(exit_idescsi_module);
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
ata-fix-platform_device_register_simple-error-check.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
ide-complete-switch-to-pci_get.patch
do_task_stat-dont-take-tty_mutex.patch
mxser-correct-tty-driver-name.patch
pci-mxser-pci-refcounts.patch
mxser-make-an-experimental-clone.patch
char-mxser_new-correct-include-file.patch
char-mxser_new-upgrade-to-191.patch
char-mxser_new-rework-to-allow-dynamic-structs.patch
char-mxser_new-eliminate-tty-ldisc-deref.patch
char-mxser_new-testbit-for-bit-testing.patch
char-mxser_new-correct-fail-paths.patch
char-mxser_new-dont-check-tty_unregister-retval.patch
char-mxser_new-compress-isa-finding.patch
char-mxser_new-register-tty-devices-on-the-fly.patch
char-mxser_new-compact-structures-round2.patch
char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
mxser_new-correct-tty-driver-name.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
tty-preparatory-structures-for-termios-revamp.patch
tty-preparatory-structures-for-termios-revamp-strip-fix.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty-switch-to-ktermios-nozomi-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty-switch-to-ktermios-3270-fix.patch
tty-switch-to-ktermios-uml-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-update.patch
termios-enable-new-style-termios-ioctls-on-x86-64.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
ide-more-conversion-to-pci_get-apis.patch
pdc202xx_new-fix-pio-mode-setup.patch
ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
igafb-switch-to-pci_get-api.patch

