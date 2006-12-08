From: akpm@osdl.org
Subject: - char-stallion-variables-cleanup.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:57 -0800
Message-ID: <200612082009.kB8K9vkR002756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946446AbWLHUKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, variables cleanup
has been removed from the -mm tree.  Its filename was
     char-stallion-variables-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, variables cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- fix `gcc -W' un/signed warnings by converting some ints -> uints.
- move 3 global variables into functions, where are they used.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c  |   67 +++++++++++++++++--------------------
 include/linux/stallion.h |   28 +++++++--------
 2 files changed, 45 insertions(+), 50 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-variables-cleanup drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-variables-cleanup
+++ a/drivers/char/stallion.c
@@ -63,7 +63,7 @@
 #define	BRD_EASYIOPCI	28
 
 struct stlconf {
-	int		brdtype;
+	unsigned int	brdtype;
 	int		ioaddr1;
 	int		ioaddr2;
 	unsigned long	memaddr;
@@ -121,15 +121,6 @@ static struct ktermios		stl_deftermios =
 };
 
 /*
- *	Define global stats structures. Not used often, and can be
- *	re-used for each stats call.
- */
-static comstats_t	stl_comstats;
-static combrd_t		stl_brdstats;
-static struct stlbrd		stl_dummybrd;
-static struct stlport	stl_dummyport;
-
-/*
  *	Define global place to put buffer overflow characters.
  */
 static char		stl_unwanted[SC26198_RXFIFOSIZE];
@@ -200,7 +191,7 @@ static char	*stl_brdnames[] = {
  *	load line. These allow for easy board definitions, and easy
  *	modification of the io, memory and irq resoucres.
  */
-static int	stl_nargs = 0;
+static unsigned int stl_nargs;
 static char	*board0[4];
 static char	*board1[4];
 static char	*board2[4];
@@ -632,7 +623,7 @@ static struct class *stallion_class;
 static int __init stl_parsebrd(struct stlconf *confp, char **argp)
 {
 	char	*sp;
-	int	i;
+	unsigned int i;
 
 	pr_debug("stl_parsebrd(confp=%p,argp=%p)\n", confp, argp);
 
@@ -694,8 +685,8 @@ static int stl_open(struct tty_struct *t
 {
 	struct stlport	*portp;
 	struct stlbrd	*brdp;
-	unsigned int	minordev;
-	int		brdnr, panelnr, portnr, rc;
+	unsigned int	minordev, brdnr, panelnr;
+	int		portnr, rc;
 
 	pr_debug("stl_open(tty=%p,filp=%p): device=%s\n", tty, filp, tty->name);
 
@@ -1556,8 +1547,8 @@ static int stl_readproc(char *page, char
 	struct stlbrd	*brdp;
 	struct stlpanel	*panelp;
 	struct stlport	*portp;
-	int		brdnr, panelnr, portnr, totalport;
-	int		curoff, maxoff;
+	unsigned int	brdnr, panelnr, portnr;
+	int		totalport, curoff, maxoff;
 	char		*pos;
 
 	pr_debug("stl_readproc(page=%p,start=%p,off=%lx,count=%d,eof=%p,"
@@ -1675,8 +1666,7 @@ static int stl_eiointr(struct stlbrd *br
 static int stl_echatintr(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
-	unsigned int	ioaddr;
-	int		bnknr;
+	unsigned int	ioaddr, bnknr;
 	int		handled = 0;
 
 	outb((brdp->ioctrlval | ECH_BRDENABLE), brdp->ioctrl);
@@ -1706,8 +1696,7 @@ static int stl_echatintr(struct stlbrd *
 static int stl_echmcaintr(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
-	unsigned int	ioaddr;
-	int		bnknr;
+	unsigned int	ioaddr, bnknr;
 	int		handled = 0;
 
 	while (inb(brdp->iostatus) & ECH_INTRPEND) {
@@ -1732,8 +1721,7 @@ static int stl_echmcaintr(struct stlbrd 
 static int stl_echpciintr(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
-	unsigned int	ioaddr;
-	int		bnknr, recheck;
+	unsigned int	ioaddr, bnknr, recheck;
 	int		handled = 0;
 
 	while (1) {
@@ -1763,8 +1751,7 @@ static int stl_echpciintr(struct stlbrd 
 static int stl_echpci64intr(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
-	unsigned int	ioaddr;
-	int		bnknr;
+	unsigned int	ioaddr, bnknr;
 	int		handled = 0;
 
 	while (inb(brdp->ioctrl) & 0x1) {
@@ -1826,8 +1813,9 @@ static void stl_offintr(struct work_stru
 
 static int __devinit stl_initports(struct stlbrd *brdp, struct stlpanel *panelp)
 {
-	struct stlport	*portp;
-	int		chipmask, i;
+	struct stlport *portp;
+	unsigned int i;
+	int chipmask;
 
 	pr_debug("stl_initports(brdp=%p,panelp=%p)\n", brdp, panelp);
 
@@ -2052,8 +2040,8 @@ err:
 static int __devinit stl_initech(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
-	unsigned int	status, nxtid, ioaddr, conflict;
-	int		panelnr, banknr, i, retval;
+	unsigned int	status, nxtid, ioaddr, conflict, panelnr, banknr, i;
+	int		retval;
 	char		*name;
 
 	pr_debug("stl_initech(brdp=%p)\n", brdp);
@@ -2337,7 +2325,7 @@ err:
 
 static int __devinit stl_getbrdnr(void)
 {
-	int	i;
+	unsigned int i;
 
 	for (i = 0; i < STL_MAXBRDS; i++)
 		if (stl_brds[i] == NULL) {
@@ -2361,7 +2349,7 @@ static int __devinit stl_pciprobe(struct
 {
 	struct stlbrd *brdp;
 	unsigned int brdtype = ent->driver_data;
-	int retval = -ENODEV;
+	int brdnr, retval = -ENODEV;
 
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
 		goto err;
@@ -2378,13 +2366,14 @@ static int __devinit stl_pciprobe(struct
 		goto err;
 	}
 	mutex_lock(&stl_brdslock);
-	brdp->brdnr = stl_getbrdnr();
-	if (brdp->brdnr < 0) {
+	brdnr = stl_getbrdnr();
+	if (brdnr < 0) {
 		dev_err(&pdev->dev, "too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
 		mutex_unlock(&stl_brdslock);
 		goto err_fr;
 	}
+	brdp->brdnr = (unsigned int)brdnr;
 	stl_brds[brdp->brdnr] = brdp;
 	mutex_unlock(&stl_brdslock);
 
@@ -2460,9 +2449,10 @@ static struct pci_driver stl_pcidriver =
 
 static int stl_getbrdstats(combrd_t __user *bp)
 {
+	combrd_t	stl_brdstats;
 	struct stlbrd	*brdp;
 	struct stlpanel	*panelp;
-	int		i;
+	unsigned int i;
 
 	if (copy_from_user(&stl_brdstats, bp, sizeof(combrd_t)))
 		return -EFAULT;
@@ -2508,12 +2498,12 @@ static struct stlport *stl_getport(int b
 	brdp = stl_brds[brdnr];
 	if (brdp == NULL)
 		return NULL;
-	if (panelnr < 0 || panelnr >= brdp->nrpanels)
+	if (panelnr < 0 || (unsigned int)panelnr >= brdp->nrpanels)
 		return NULL;
 	panelp = brdp->panels[panelnr];
 	if (panelp == NULL)
 		return NULL;
-	if (portnr < 0 || portnr >= panelp->nrports)
+	if (portnr < 0 || (unsigned int)portnr >= panelp->nrports)
 		return NULL;
 	return panelp->ports[portnr];
 }
@@ -2528,6 +2518,7 @@ static struct stlport *stl_getport(int b
 
 static int stl_getportstats(struct stlport *portp, comstats_t __user *cp)
 {
+	comstats_t	stl_comstats;
 	unsigned char	*head, *tail;
 	unsigned long	flags;
 
@@ -2585,6 +2576,8 @@ static int stl_getportstats(struct stlpo
 
 static int stl_clrportstats(struct stlport *portp, comstats_t __user *cp)
 {
+	comstats_t	stl_comstats;
+
 	if (!portp) {
 		if (copy_from_user(&stl_comstats, cp, sizeof(comstats_t)))
 			return -EFAULT;
@@ -2610,6 +2603,7 @@ static int stl_clrportstats(struct stlpo
 
 static int stl_getportstruct(struct stlport __user *arg)
 {
+	struct stlport	stl_dummyport;
 	struct stlport	*portp;
 
 	if (copy_from_user(&stl_dummyport, arg, sizeof(struct stlport)))
@@ -2629,11 +2623,12 @@ static int stl_getportstruct(struct stlp
 
 static int stl_getbrdstruct(struct stlbrd __user *arg)
 {
+	struct stlbrd	stl_dummybrd;
 	struct stlbrd	*brdp;
 
 	if (copy_from_user(&stl_dummybrd, arg, sizeof(struct stlbrd)))
 		return -EFAULT;
-	if ((stl_dummybrd.brdnr < 0) || (stl_dummybrd.brdnr >= STL_MAXBRDS))
+	if (stl_dummybrd.brdnr >= STL_MAXBRDS)
 		return -ENODEV;
 	brdp = stl_brds[stl_dummybrd.brdnr];
 	if (!brdp)
diff -puN include/linux/stallion.h~char-stallion-variables-cleanup include/linux/stallion.h
--- a/include/linux/stallion.h~char-stallion-variables-cleanup
+++ a/include/linux/stallion.h
@@ -69,12 +69,12 @@ struct stlrq {
  */
 struct stlport {
 	unsigned long		magic;
-	int			portnr;
-	int			panelnr;
-	int			brdnr;
+	unsigned int		portnr;
+	unsigned int		panelnr;
+	unsigned int		brdnr;
 	int			ioaddr;
 	int			uartaddr;
-	int			pagenr;
+	unsigned int		pagenr;
 	long			istate;
 	int			flags;
 	int			baud_base;
@@ -102,10 +102,10 @@ struct stlport {
 
 struct stlpanel {
 	unsigned long	magic;
-	int		panelnr;
-	int		brdnr;
-	int		pagenr;
-	int		nrports;
+	unsigned int	panelnr;
+	unsigned int	brdnr;
+	unsigned int	pagenr;
+	unsigned int	nrports;
 	int		iobase;
 	void		*uartp;
 	void		(*isr)(struct stlpanel *panelp, unsigned int iobase);
@@ -116,12 +116,12 @@ struct stlpanel {
 
 struct stlbrd {
 	unsigned long	magic;
-	int		brdnr;
-	int		brdtype;
-	int		state;
-	int		nrpanels;
-	int		nrports;
-	int		nrbnks;
+	unsigned int	brdnr;
+	unsigned int	brdtype;
+	unsigned int	state;
+	unsigned int	nrpanels;
+	unsigned int	nrports;
+	unsigned int	nrbnks;
 	int		irq;
 	int		irqtype;
 	int		(*isr)(struct stlbrd *brdp);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

