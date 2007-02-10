From: akpm@linux-foundation.org
Subject: - char-mxser_new-upgrade-to-1915-fix.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:15:16 -0800
Message-ID: <200702100815.l1A8FGJK007043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39394 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbXBJIPS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:15:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, fix sparc compile error
has been removed from the -mm tree.  Its filename was
     char-mxser_new-upgrade-to-1915-fix.patch

This patch was dropped because it was folded into char-mxser_new-upgrade-to-1915.patch

------------------------------------------------------
Subject: Char: mxser_new, fix sparc compile error
From: Jiri Slaby <jirislaby@gmail.com>

mxser_new, fix sparc compile error

On sparc B4000000 is not defined. Use B2000000 for special baudrate, which
is defined on all platforms.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-upgrade-to-1915-fix drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-upgrade-to-1915-fix
+++ a/drivers/char/mxser_new.c
@@ -189,6 +189,8 @@ static unsigned int mxvar_baud_table1[] 
 };
 #define BAUD_TABLE_NO ARRAY_SIZE(mxvar_baud_table)
 
+#define B_SPEC	B2000000
+
 static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
 static int ttymajor = MXSERMAJOR;
 static int calloutmajor = MXSERCUMAJOR;
@@ -544,7 +546,7 @@ static int mxser_change_speed(struct mxs
 		return ret;
 
 	if (mxser_set_baud_method[info->tty->index] == 0) {
-		if ((cflag & (CBAUD | CBAUDEX)) == B4000000)
+		if ((cflag & CBAUD) == B_SPEC)
 			baud = info->speed;
 		else
 			baud = tty_get_baud_rate(info->tty);
@@ -1700,7 +1702,7 @@ static int mxser_ioctl(struct tty_struct
 			if (speed == mxvar_baud_table[i])
 				break;
 		if (i == BAUD_TABLE_NO) {
-			info->tty->termios->c_cflag |= B4000000;
+			info->tty->termios->c_cflag |= B_SPEC;
 		} else if (speed != 0)
 			info->tty->termios->c_cflag |= mxvar_baud_table1[i];
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-mxser_new-upgrade-to-1915-fix.patch
char-mxser_new-do-not-null-driver_data.patch
char-mxser_new-lock-count-and-flags.patch
char-mxser_new-fix-sparse-warning.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
mxser-remove-useless-fields.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
