From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-nozomi-fix.patch removed from -mm tree
Date: Fri, 15 Dec 2006 14:16:54 -0800
Message-ID: <200612152216.kBFMGsWX002417@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50342 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030248AbWLOWaL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty-switch-to-ktermios nozomi fix
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-nozomi-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty-switch-to-ktermios nozomi fix
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Fix nozomi as well.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/nozomi.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/char/nozomi.c~tty-switch-to-ktermios-nozomi-fix drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~tty-switch-to-ktermios-nozomi-fix
+++ a/drivers/char/nozomi.c
@@ -456,8 +456,8 @@ typedef struct {
 	struct workqueue_struct *tty_flip_wq;
 	struct work_struct tty_flip_wq_struct;
 
-	struct termios *tty_termios[NTTY_TTY_MINORS];
-	struct termios *tty_termios_locked[NTTY_TTY_MINORS];
+	struct ktermios *tty_termios[NTTY_TTY_MINORS];
+	struct ktermios *tty_termios_locked[NTTY_TTY_MINORS];
 	spinlock_t spin_mutex;
 
 	u32 open_ttys;
@@ -1007,9 +1007,6 @@ static int receive_data(enum port_type i
 
 		i = 0;
 		while (i < 4 && size > 0) {
-			if (tty_buffer_request_room(tty, 1) < 1) {
-				tty_flip_buffer_push(tty);
-			}
 			tty_insert_flip_char(tty, buf[i], TTY_NORMAL);
 			port->rx_data++;
 			i++;
@@ -1871,7 +1868,7 @@ static int ntty_write_room(struct tty_st
 
 /* Sets termios flags, called by the tty layer. */
 static void ntty_set_termios(struct tty_struct *tty,
-			     struct termios *old_termios)
+			     struct ktermios *old_termios)
 {
 	unsigned int cflag;
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
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
edac-new-opteron-athlon64-memory-controller-driver.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch

