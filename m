From: akpm@osdl.org
Subject: + tty-improve-encode_baud_rate-logic.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:07:05 -0800
Message-ID: <200701082307.l08N75ct022056@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161093AbXAHXHP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:07:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty: improve encode_baud_rate logic
has been added to the -mm tree.  Its filename is
     tty-improve-encode_baud_rate-logic.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: improve encode_baud_rate logic
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Mostly so people can see the work in progress.  This enhances the encode
function which isn't currently used in the base tree but is when using some of
the testing tty patches.

This resolves a problem with some hardware where applications got confusing
information from the tty ioctls.  Correct but confusing.

In some situations asking for, say, 9600 baud actually gets you 9595 baud or
similar near-miss values.  With the old code this meant that a request for
B9600 got a return of BOTHER, 9595 which programs interpreted as a failure.

The new code now works on the following basis

- If you ask for specific rate via BOTHER, you get a precise return

- If you ask for a standard Bfoo rate and the result is close you get a Bfoo
  return

- If you ask for a standard Bfoo rate and get something way off you get a
  BOTHER/rate return

This seems to fix up the cases I've found where this broke compatibility.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_ioctl.c |   45 ++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty-improve-encode_baud_rate-logic drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-improve-encode_baud_rate-logic
+++ a/drivers/char/tty_ioctl.c
@@ -225,7 +225,7 @@ EXPORT_SYMBOL(tty_termios_input_baud_rat
 
 /**
  *	tty_termios_encode_baud_rate
- *	@termios: termios structure
+ *	@termios: ktermios structure holding user requested state
  *	@ispeed: input speed
  *	@ospeed: output speed
  *
@@ -233,7 +233,10 @@ EXPORT_SYMBOL(tty_termios_input_baud_rat
  *	used as a library helper for drivers os that they can report back
  *	the actual speed selected when it differs from the speed requested
  *
- *	For now input and output speed must agree.
+ *	For maximal back compatibility with legacy SYS5/POSIX *nix behaviour
+ *	we need to carefully set the bits when the user does not get the
+ *	desired speed. We allow small margins and preserve as much of possible
+ *	of the input intent to keep compatiblity.
  *
  *	Locking: Caller should hold termios lock. This is already held
  *	when calling this function from the driver termios handler.
@@ -242,32 +245,44 @@ EXPORT_SYMBOL(tty_termios_input_baud_rat
 void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud)
 {
 	int i = 0;
-	int ifound = 0, ofound = 0;
+	int ifound = -1, ofound = -1;
+	int iclose = ibaud/50, oclose = obaud/50;
+	int ibinput = 0;
 
 	termios->c_ispeed = ibaud;
 	termios->c_ospeed = obaud;
 
+	/* If the user asked for a precise weird speed give a precise weird
+	   answer. If they asked for a Bfoo speed they many have problems
+	   digesting non-exact replies so fuzz a bit */
+
+	if ((termios->c_cflag & CBAUD) == BOTHER)
+		oclose = 0;
+	if (((termios->c_cflag >> IBSHIFT) & CBAUD) == BOTHER)
+		iclose = 0;
+	if ((termios->c_cflag >> IBSHIFT) & CBAUD)
+		ibinput = 1;	/* An input speed was specified */
+
 	termios->c_cflag &= ~CBAUD;
-	/* Identical speed means no input encoding (ie B0 << IBSHIFT)*/
-	if (termios->c_ispeed == termios->c_ospeed)
-		ifound = 1;
 
 	do {
-		if (obaud == baud_table[i]) {
+		if (obaud - oclose >= baud_table[i] && obaud + oclose <= baud_table[i]) {
 			termios->c_cflag |= baud_bits[i];
-			ofound = 1;
-			/* So that if ibaud == obaud we don't set it */
-			continue;
+			ofound = i;
 		}
-		if (ibaud == baud_table[i]) {
-			termios->c_cflag |= (baud_bits[i] << IBSHIFT);
-			ifound = 1;
+		if (ibaud - iclose >= baud_table[i] && ibaud + iclose <= baud_table[i]) {
+			/* For the case input == output don't set IBAUD bits if the user didn't do so */
+			if (ofound != i || ibinput)
+				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
+			ifound = i;
 		}
 	}
 	while(++i < n_baud_table);
-	if (!ofound)
+	if (ofound == -1)
 		termios->c_cflag |= BOTHER;
-	if (!ifound)
+	/* Set exact input bits only if the input and output differ or the
+	   user already did */
+	if (ifound == -1 && (ibaud != obaud  || ibinput))
 		termios->c_cflag |= (BOTHER << IBSHIFT);
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
add-suport-for-marvell-88se6121-in-pata_marvell.patch
ahci-remove-jmicron-fixup.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
piix-tuneproc-fixes-cleanups.patch
slc90e66-carry-over-fixes-from-piix-driver.patch
hpt36x-pci-clock-detection-fix.patch
atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
