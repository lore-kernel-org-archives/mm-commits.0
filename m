From: akpm@osdl.org
Subject: - char-stallion-remove-many-prototypes.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:13 -0800
Message-ID: <200612082008.kB8K8DPm002588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946078AbWLHUIT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, remove many prototypes
has been removed from the -mm tree.  Its filename was
     char-stallion-remove-many-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, remove many prototypes
From: Jiri Slaby <jirislaby@gmail.com>

Many prototypes are useless, since functions are declared before they are
called.  Also some code was easy to move to resolve this dependency and delete
prototypes.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |  222 +++++++++++++++-----------------------
 1 file changed, 91 insertions(+), 131 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-remove-many-prototypes drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-remove-many-prototypes
+++ a/drivers/char/stallion.c
@@ -450,51 +450,11 @@ static unsigned int	stl_baudrates[] = {
  *	Declare all those functions in this driver!
  */
 
-static void	stl_argbrds(void);
-static int	stl_parsebrd(struct stlconf *confp, char **argp);
-
-static unsigned long stl_atol(char *str);
-
-static int	stl_open(struct tty_struct *tty, struct file *filp);
-static void	stl_close(struct tty_struct *tty, struct file *filp);
-static int	stl_write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void	stl_putchar(struct tty_struct *tty, unsigned char ch);
-static void	stl_flushchars(struct tty_struct *tty);
-static int	stl_writeroom(struct tty_struct *tty);
-static int	stl_charsinbuffer(struct tty_struct *tty);
-static int	stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
-static void	stl_settermios(struct tty_struct *tty, struct termios *old);
-static void	stl_throttle(struct tty_struct *tty);
-static void	stl_unthrottle(struct tty_struct *tty);
-static void	stl_stop(struct tty_struct *tty);
-static void	stl_start(struct tty_struct *tty);
-static void	stl_flushbuffer(struct tty_struct *tty);
-static void	stl_breakctl(struct tty_struct *tty, int state);
-static void	stl_waituntilsent(struct tty_struct *tty, int timeout);
-static void	stl_sendxchar(struct tty_struct *tty, char ch);
-static void	stl_hangup(struct tty_struct *tty);
 static int	stl_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, unsigned long arg);
-static int	stl_portinfo(struct stlport *portp, int portnr, char *pos);
-static int	stl_readproc(char *page, char **start, off_t off, int count, int *eof, void *data);
-
 static int	stl_brdinit(struct stlbrd *brdp);
-static int	stl_initports(struct stlbrd *brdp, struct stlpanel *panelp);
-static int	stl_getserial(struct stlport *portp, struct serial_struct __user *sp);
-static int	stl_setserial(struct stlport *portp, struct serial_struct __user *sp);
-static int	stl_getbrdstats(combrd_t __user *bp);
 static int	stl_getportstats(struct stlport *portp, comstats_t __user *cp);
 static int	stl_clrportstats(struct stlport *portp, comstats_t __user *cp);
-static int	stl_getportstruct(struct stlport __user *arg);
-static int	stl_getbrdstruct(struct stlbrd __user *arg);
 static int	stl_waitcarrier(struct stlport *portp, struct file *filp);
-static int	stl_eiointr(struct stlbrd *brdp);
-static int	stl_echatintr(struct stlbrd *brdp);
-static int	stl_echmcaintr(struct stlbrd *brdp);
-static int	stl_echpciintr(struct stlbrd *brdp);
-static int	stl_echpci64intr(struct stlbrd *brdp);
-static void	stl_offintr(struct work_struct *);
-static struct stlbrd *stl_allocbrd(void);
-static struct stlport *stl_getport(int brdnr, int panelnr, int portnr);
 
 /*
  *	CD1400 uart specific handling functions.
@@ -700,31 +660,6 @@ static struct class *stallion_class;
  *	Check for any arguments passed in on the module load command line.
  */
 
-static void __init stl_argbrds(void)
-{
-	struct stlconf	conf;
-	struct stlbrd	*brdp;
-	int		i;
-
-	pr_debug("stl_argbrds()\n");
-
-	for (i = stl_nrbrds; (i < stl_nargs); i++) {
-		memset(&conf, 0, sizeof(conf));
-		if (stl_parsebrd(&conf, stl_brdsp[i]) == 0)
-			continue;
-		if ((brdp = stl_allocbrd()) == NULL)
-			continue;
-		stl_nrbrds = i + 1;
-		brdp->brdnr = i;
-		brdp->brdtype = conf.brdtype;
-		brdp->ioaddr1 = conf.ioaddr1;
-		brdp->ioaddr2 = conf.ioaddr2;
-		brdp->irq = conf.irq;
-		brdp->irqtype = conf.irqtype;
-		stl_brdinit(brdp);
-	}
-}
-
 /*****************************************************************************/
 
 /*
@@ -826,6 +761,31 @@ static struct stlbrd *stl_allocbrd(void)
 	return brdp;
 }
 
+static void __init stl_argbrds(void)
+{
+	struct stlconf	conf;
+	struct stlbrd	*brdp;
+	int		i;
+
+	pr_debug("stl_argbrds()\n");
+
+	for (i = stl_nrbrds; (i < stl_nargs); i++) {
+		memset(&conf, 0, sizeof(conf));
+		if (stl_parsebrd(&conf, stl_brdsp[i]) == 0)
+			continue;
+		if ((brdp = stl_allocbrd()) == NULL)
+			continue;
+		stl_nrbrds = i + 1;
+		brdp->brdnr = i;
+		brdp->brdtype = conf.brdtype;
+		brdp->ioaddr1 = conf.ioaddr1;
+		brdp->ioaddr2 = conf.ioaddr2;
+		brdp->irq = conf.irq;
+		brdp->irqtype = conf.irqtype;
+		stl_brdinit(brdp);
+	}
+}
+
 /*****************************************************************************/
 
 static int stl_open(struct tty_struct *tty, struct file *filp)
@@ -972,6 +932,52 @@ static int stl_waitcarrier(struct stlpor
 
 /*****************************************************************************/
 
+static void stl_flushbuffer(struct tty_struct *tty)
+{
+	struct stlport	*portp;
+
+	pr_debug("stl_flushbuffer(tty=%p)\n", tty);
+
+	if (tty == NULL)
+		return;
+	portp = tty->driver_data;
+	if (portp == NULL)
+		return;
+
+	stl_flush(portp);
+	tty_wakeup(tty);
+}
+
+/*****************************************************************************/
+
+static void stl_waituntilsent(struct tty_struct *tty, int timeout)
+{
+	struct stlport	*portp;
+	unsigned long	tend;
+
+	pr_debug("stl_waituntilsent(tty=%p,timeout=%d)\n", tty, timeout);
+
+	if (tty == NULL)
+		return;
+	portp = tty->driver_data;
+	if (portp == NULL)
+		return;
+
+	if (timeout == 0)
+		timeout = HZ;
+	tend = jiffies + timeout;
+
+	while (stl_datastate(portp)) {
+		if (signal_pending(current))
+			break;
+		msleep_interruptible(20);
+		if (time_after_eq(jiffies, tend))
+			break;
+	}
+}
+
+/*****************************************************************************/
+
 static void stl_close(struct tty_struct *tty, struct file *filp)
 {
 	struct stlport	*portp;
@@ -1401,6 +1407,26 @@ static int stl_ioctl(struct tty_struct *
 
 /*****************************************************************************/
 
+/*
+ *	Start the transmitter again. Just turn TX interrupts back on.
+ */
+
+static void stl_start(struct tty_struct *tty)
+{
+	struct stlport	*portp;
+
+	pr_debug("stl_start(tty=%p)\n", tty);
+
+	if (tty == NULL)
+		return;
+	portp = tty->driver_data;
+	if (portp == NULL)
+		return;
+	stl_startrxtx(portp, -1, 1);
+}
+
+/*****************************************************************************/
+
 static void stl_settermios(struct tty_struct *tty, struct termios *old)
 {
 	struct stlport	*portp;
@@ -1495,26 +1521,6 @@ static void stl_stop(struct tty_struct *
 /*****************************************************************************/
 
 /*
- *	Start the transmitter again. Just turn TX interrupts back on.
- */
-
-static void stl_start(struct tty_struct *tty)
-{
-	struct stlport	*portp;
-
-	pr_debug("stl_start(tty=%p)\n", tty);
-
-	if (tty == NULL)
-		return;
-	portp = tty->driver_data;
-	if (portp == NULL)
-		return;
-	stl_startrxtx(portp, -1, 1);
-}
-
-/*****************************************************************************/
-
-/*
  *	Hangup this port. This is pretty much like closing the port, only
  *	a little more brutal. No waiting for data to drain. Shutdown the
  *	port and maybe drop signals.
@@ -1554,24 +1560,6 @@ static void stl_hangup(struct tty_struct
 
 /*****************************************************************************/
 
-static void stl_flushbuffer(struct tty_struct *tty)
-{
-	struct stlport	*portp;
-
-	pr_debug("stl_flushbuffer(tty=%p)\n", tty);
-
-	if (tty == NULL)
-		return;
-	portp = tty->driver_data;
-	if (portp == NULL)
-		return;
-
-	stl_flush(portp);
-	tty_wakeup(tty);
-}
-
-/*****************************************************************************/
-
 static void stl_breakctl(struct tty_struct *tty, int state)
 {
 	struct stlport	*portp;
@@ -1589,34 +1577,6 @@ static void stl_breakctl(struct tty_stru
 
 /*****************************************************************************/
 
-static void stl_waituntilsent(struct tty_struct *tty, int timeout)
-{
-	struct stlport	*portp;
-	unsigned long	tend;
-
-	pr_debug("stl_waituntilsent(tty=%p,timeout=%d)\n", tty, timeout);
-
-	if (tty == NULL)
-		return;
-	portp = tty->driver_data;
-	if (portp == NULL)
-		return;
-
-	if (timeout == 0)
-		timeout = HZ;
-	tend = jiffies + timeout;
-
-	while (stl_datastate(portp)) {
-		if (signal_pending(current))
-			break;
-		msleep_interruptible(20);
-		if (time_after_eq(jiffies, tend))
-			break;
-	}
-}
-
-/*****************************************************************************/
-
 static void stl_sendxchar(struct tty_struct *tty, char ch)
 {
 	struct stlport	*portp;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-stallion-remove-many-prototypes.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
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

