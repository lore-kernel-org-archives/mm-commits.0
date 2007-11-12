From: akpm@linux-foundation.org
Subject: + char-stallion-remove-bottomhalf.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:52:40 -0800
Message-ID: <200711122152.lACLqenC010714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbXKLVx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:53:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: stallion, remove bottomhalf
has been added to the -mm tree.  Its filename is
     char-stallion-remove-bottomhalf.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: stallion, remove bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>

- tty_hangup schedules a bottomhalf itself, tty_wakeup doesn't need it
- call the CD code (part of work handler previously) directly from the code
  (it wakes somebody up or calls tty_hangup at worse)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c  |   68 +++++++++++++------------------------
 include/linux/stallion.h |    1 
 2 files changed, 24 insertions(+), 45 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-remove-bottomhalf drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-remove-bottomhalf
+++ a/drivers/char/stallion.c
@@ -145,8 +145,7 @@ static struct stlbrd		*stl_brds[STL_MAXB
  */
 #define	ASYI_TXBUSY	1
 #define	ASYI_TXLOW	2
-#define	ASYI_DCDCHANGE	3
-#define	ASYI_TXFLOWED	4
+#define	ASYI_TXFLOWED	3
 
 /*
  *	Define an array of board names as printable strings. Handy for
@@ -610,6 +609,23 @@ static const struct file_operations	stl_
 
 static struct class *stallion_class;
 
+static void stl_cd_change(struct stlport *portp)
+{
+	unsigned int oldsigs = portp->sigs;
+
+	if (!portp->tty)
+		return;
+
+	portp->sigs = stl_getsignals(portp);
+
+	if ((portp->sigs & TIOCM_CD) && ((oldsigs & TIOCM_CD) == 0))
+		wake_up_interruptible(&portp->open_wait);
+
+	if ((oldsigs & TIOCM_CD) && ((portp->sigs & TIOCM_CD) == 0))
+		if (portp->flags & ASYNC_CHECK_CD)
+			tty_hangup(portp->tty);
+}
+
 /*
  *	Check for any arguments passed in on the module load command line.
  */
@@ -1771,41 +1787,6 @@ static int stl_echpci64intr(struct stlbr
 /*****************************************************************************/
 
 /*
- *	Service an off-level request for some channel.
- */
-static void stl_offintr(struct work_struct *work)
-{
-	struct stlport		*portp = container_of(work, struct stlport, tqueue);
-	struct tty_struct	*tty;
-	unsigned int		oldsigs;
-
-	pr_debug("stl_offintr(portp=%p)\n", portp);
-
-	if (portp == NULL)
-		return;
-
-	tty = portp->tty;
-	if (tty == NULL)
-		return;
-
-	if (test_bit(ASYI_TXLOW, &portp->istate))
-		tty_wakeup(tty);
-
-	if (test_bit(ASYI_DCDCHANGE, &portp->istate)) {
-		clear_bit(ASYI_DCDCHANGE, &portp->istate);
-		oldsigs = portp->sigs;
-		portp->sigs = stl_getsignals(portp);
-		if ((portp->sigs & TIOCM_CD) && ((oldsigs & TIOCM_CD) == 0))
-			wake_up_interruptible(&portp->open_wait);
-		if ((oldsigs & TIOCM_CD) && ((portp->sigs & TIOCM_CD) == 0))
-			if (portp->flags & ASYNC_CHECK_CD)
-				tty_hangup(tty);	/* FIXME: module removal race here - AKPM */
-	}
-}
-
-/*****************************************************************************/
-
-/*
  *	Initialize all the ports on a panel.
  */
 
@@ -1840,7 +1821,6 @@ static int __devinit stl_initports(struc
 		portp->baud_base = STL_BAUDBASE;
 		portp->close_delay = STL_CLOSEDELAY;
 		portp->closing_wait = 30 * HZ;
-		INIT_WORK(&portp->tqueue, stl_offintr);
 		init_waitqueue_head(&portp->open_wait);
 		init_waitqueue_head(&portp->close_wait);
 		portp->stats.brd = portp->brdnr;
@@ -3530,7 +3510,8 @@ static void stl_cd1400txisr(struct stlpa
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		schedule_work(&portp->tqueue);
+		if (portp->tty)
+			tty_wakeup(portp->tty);
 	}
 
 	if (len == 0) {
@@ -3693,8 +3674,7 @@ static void stl_cd1400mdmisr(struct stlp
 	outb((MISR + portp->uartaddr), ioaddr);
 	misr = inb(ioaddr + EREG_DATA);
 	if (misr & MISR_DCD) {
-		set_bit(ASYI_DCDCHANGE, &portp->istate);
-		schedule_work(&portp->tqueue);
+		stl_cd_change(portp);
 		portp->stats.modem++;
 	}
 
@@ -4448,7 +4428,8 @@ static void stl_sc26198txisr(struct stlp
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		schedule_work(&portp->tqueue); 
+		if (portp->tty)
+			tty_wakeup(portp->tty);
 	}
 
 	if (len == 0) {
@@ -4649,8 +4630,7 @@ static void stl_sc26198otherisr(struct s
 	case CIR_SUBCOS:
 		ipr = stl_sc26198getreg(portp, IPR);
 		if (ipr & IPR_DCDCHANGE) {
-			set_bit(ASYI_DCDCHANGE, &portp->istate);
-			schedule_work(&portp->tqueue); 
+			stl_cd_change(portp);
 			portp->stats.modem++;
 		}
 		break;
diff -puN include/linux/stallion.h~char-stallion-remove-bottomhalf include/linux/stallion.h
--- a/include/linux/stallion.h~char-stallion-remove-bottomhalf
+++ a/include/linux/stallion.h
@@ -95,7 +95,6 @@ struct stlport {
 	struct tty_struct	*tty;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
-	struct work_struct	tqueue;
 	comstats_t		stats;
 	struct stlrq		tx;
 };
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
