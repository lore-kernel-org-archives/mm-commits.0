From: akpm@linux-foundation.org
Subject: + char-istallion-remove-hangup-bottomhalf.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:52:38 -0800
Message-ID: <200711122152.lACLqcSZ010708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbXKLVxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:53:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: istallion, remove hangup bottomhalf
has been added to the -mm tree.  Its filename is
     char-istallion-remove-hangup-bottomhalf.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: istallion, remove hangup bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>

tty_hangup schedules a work for hangup itself, no need to do it in the driver.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c  |   23 +----------------------
 include/linux/istallion.h |    1 -
 2 files changed, 1 insertion(+), 23 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-remove-hangup-bottomhalf drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-remove-hangup-bottomhalf
+++ a/drivers/char/istallion.c
@@ -627,7 +627,6 @@ static int	stli_initopen(struct stlibrd 
 static int	stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
 static int	stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
 static int	stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct file *filp);
-static void	stli_dohangup(struct work_struct *);
 static int	stli_setport(struct stliport *portp);
 static int	stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
@@ -1824,25 +1823,6 @@ static void stli_start(struct tty_struct
 /*****************************************************************************/
 
 /*
- *	Scheduler called hang up routine. This is called from the scheduler,
- *	not direct from the driver "poll" routine. We can't call it there
- *	since the real local hangup code will enable/disable the board and
- *	other things that we can't do while handling the poll. Much easier
- *	to deal with it some time later (don't really care when, hangups
- *	aren't that time critical).
- */
-
-static void stli_dohangup(struct work_struct *ugly_api)
-{
-	struct stliport *portp = container_of(ugly_api, struct stliport, tqhangup);
-	if (portp->tty != NULL) {
-		tty_hangup(portp->tty);
-	}
-}
-
-/*****************************************************************************/
-
-/*
  *	Hangup this port. This is pretty much like closing the port, only
  *	a little more brutal. No waiting for data to drain. Shutdown the
  *	port and maybe drop signals. This is rather tricky really. We want
@@ -2405,7 +2385,7 @@ static int stli_hostcmd(struct stlibrd *
 			    ((portp->sigs & TIOCM_CD) == 0)) {
 				if (portp->flags & ASYNC_CHECK_CD) {
 					if (tty)
-						schedule_work(&portp->tqhangup);
+						tty_hangup(tty);
 				}
 			}
 		}
@@ -2733,7 +2713,6 @@ static int stli_initports(struct stlibrd
 		portp->baud_base = STL_BAUDBASE;
 		portp->close_delay = STL_CLOSEDELAY;
 		portp->closing_wait = 30 * HZ;
-		INIT_WORK(&portp->tqhangup, stli_dohangup);
 		init_waitqueue_head(&portp->open_wait);
 		init_waitqueue_head(&portp->close_wait);
 		init_waitqueue_head(&portp->raw_wait);
diff -puN include/linux/istallion.h~char-istallion-remove-hangup-bottomhalf include/linux/istallion.h
--- a/include/linux/istallion.h~char-istallion-remove-hangup-bottomhalf
+++ a/include/linux/istallion.h
@@ -71,7 +71,6 @@ struct stliport {
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	raw_wait;
-	struct work_struct	tqhangup;
 	struct asysigs		asig;
 	unsigned long		addr;
 	unsigned long		rxoffset;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
