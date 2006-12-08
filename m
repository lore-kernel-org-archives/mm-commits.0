From: akpm@osdl.org
Subject: - tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:27 -0800
Message-ID: <200612082008.kB8K8R55002606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58235 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946066AbWLHUIi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty_ioctl: use termios for the old structure and termios2 for the new
has been removed from the -mm tree.  Its filename was
     tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty_ioctl: use termios for the old structure and termios2 for the new
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Having split out the user and kernel structures it turns out that some non
glibc C libraries pull their termios struct from the kernel headers
directly or indirectly.  This means we must keep "struct termios" as the
library sees it correct for the old ioctls.  Not a big problem just shuffle
the names and ifdef around a bit

[akpm@osdl.org: build fix]
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_ioctl.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty_ioctl-use-termios-for-the-old-structure-and-termios2 drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty_ioctl-use-termios-for-the-old-structure-and-termios2
+++ a/drivers/char/tty_ioctl.c
@@ -399,23 +399,27 @@ static int set_termios(struct tty_struct
 	if (retval)
 		return retval;
 
+	memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
+
 	if (opt & TERMIOS_TERMIO) {
-		memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
 		if (user_termio_to_kernel_termios(&tmp_termios,
 						(struct termio __user *)arg))
 			return -EFAULT;
 #ifdef TCGETS2
 	} else if (opt & TERMIOS_OLD) {
-		memcpy(&tmp_termios, tty->termios, sizeof(struct termios));
 		if (user_termios_to_kernel_termios_1(&tmp_termios,
-						(struct termios_v1 __user *)arg))
+						(struct termios __user *)arg))
 			return -EFAULT;
-#endif
 	} else {
 		if (user_termios_to_kernel_termios(&tmp_termios,
-						(struct termios __user *)arg))
+						(struct termios2 __user *)arg))
 			return -EFAULT;
 	}
+#else
+	} else if (user_termios_to_kernel_termios(&tmp_termios,
+					(struct termios __user *)arg))
+		return -EFAULT;
+#endif
 
 	/* If old style Bfoo values are used then load c_ispeed/c_ospeed with the real speed
 	   so its unconditionally usable */
@@ -707,11 +711,11 @@ int n_tty_ioctl(struct tty_struct * tty,
 			return 0;
 #else
 		case TCGETS:
-			if (kernel_termios_to_user_termios_1((struct termios_v1 __user *)arg, real_tty->termios))
+			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios))
 				return -EFAULT;
 			return 0;
 		case TCGETS2:
-			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios))
+			if (kernel_termios_to_user_termios((struct termios2 __user *)arg, real_tty->termios))
 				return -EFAULT;
 			return 0;
 		case TCSETSF2:
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
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
ide-more-conversion-to-pci_get-apis.patch
pdc202xx_new-fix-pio-mode-setup.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
igafb-switch-to-pci_get-api.patch
tty-switch-to-ktermios-nozomi-fix.patch
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
ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch

