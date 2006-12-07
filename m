From: akpm@osdl.org
Subject: - hz-300hz-support.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:34 -0800
Message-ID: <200612072304.kB7N4YLT030067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163862AbWLGXEn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     HZ: 300Hz support
has been removed from the -mm tree.  Its filename was
     hz-300hz-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HZ: 300Hz support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Fix two things.  Firstly the unit is "Hz" not "HZ".  Secondly it is useful
to have 300Hz support when doing multimedia work.  250 is fine for us in
Europe but the US frame rate is 30fps (29.99 blah for pedants).  300 gives
us a tick divisible by both 25 and 30, and for interlace work 50 and 60. 
It's also giving similar performance to 250Hz.

I'd argue we should remove 250 and add 300, but that might be excess
disruption for now.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/Kconfig.hz |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN kernel/Kconfig.hz~hz-300hz-support kernel/Kconfig.hz
--- a/kernel/Kconfig.hz~hz-300hz-support
+++ a/kernel/Kconfig.hz
@@ -7,7 +7,7 @@ choice
 	default HZ_250
 	help
 	 Allows the configuration of the timer frequency. It is customary
-	 to have the timer interrupt run at 1000 HZ but 100 HZ may be more
+	 to have the timer interrupt run at 1000 Hz but 100 Hz may be more
 	 beneficial for servers and NUMA systems that do not need to have
 	 a fast response for user interaction and that may experience bus
 	 contention and cacheline bounces as a result of timer interrupts.
@@ -19,21 +19,30 @@ choice
 	config HZ_100
 		bool "100 HZ"
 	help
-	  100 HZ is a typical choice for servers, SMP and NUMA systems
+	  100 Hz is a typical choice for servers, SMP and NUMA systems
 	  with lots of processors that may show reduced performance if
 	  too many timer interrupts are occurring.
 
 	config HZ_250
 		bool "250 HZ"
 	help
-	 250 HZ is a good compromise choice allowing server performance
+	 250 Hz is a good compromise choice allowing server performance
 	 while also showing good interactive responsiveness even
-	 on SMP and NUMA systems.
+	 on SMP and NUMA systems. If you are going to be using NTSC video
+	 or multimedia, selected 300Hz instead.
+
+	config HZ_300
+		bool "300 HZ"
+	help
+	 300 Hz is a good compromise choice allowing server performance
+	 while also showing good interactive responsiveness even
+	 on SMP and NUMA systems and exactly dividing by both PAL and
+	 NTSC frame rates for video and multimedia work.
 
 	config HZ_1000
 		bool "1000 HZ"
 	help
-	 1000 HZ is the preferred choice for desktop systems and other
+	 1000 Hz is the preferred choice for desktop systems and other
 	 systems requiring fast interactive responses to events.
 
 endchoice
@@ -42,5 +51,6 @@ config HZ
 	int
 	default 100 if HZ_100
 	default 250 if HZ_250
+	default 300 if HZ_300
 	default 1000 if HZ_1000
 
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

