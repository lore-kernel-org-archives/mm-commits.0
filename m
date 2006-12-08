From: akpm@osdl.org
Subject: - char-stallion-kill-typedefs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:01 -0800
Message-ID: <200612082008.kB8K81Dc002566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946096AbWLHUIP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, kill typedefs
has been removed from the -mm tree.  Its filename was
     char-stallion-kill-typedefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, kill typedefs
From: Jiri Slaby <jirislaby@gmail.com>

Typedefs are considered ugly in the kernel. Eliminate them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c  |  456 ++++++++++++++++++-------------------
 include/linux/stallion.h |   24 -
 2 files changed, 238 insertions(+), 242 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-kill-typedefs drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-kill-typedefs
+++ a/drivers/char/stallion.c
@@ -88,16 +88,14 @@
  *	PCI BIOS32 support is compiled into the kernel.
  */
 
-typedef struct {
+static struct stlconf {
 	int		brdtype;
 	int		ioaddr1;
 	int		ioaddr2;
 	unsigned long	memaddr;
 	int		irq;
 	int		irqtype;
-} stlconf_t;
-
-static stlconf_t	stl_brdconf[] = {
+} stl_brdconf[] = {
 	/*{ BRD_EASYIO, 0x2a0, 0, 0, 10, 0 },*/
 };
 
@@ -154,8 +152,8 @@ static struct termios		stl_deftermios = 
  */
 static comstats_t	stl_comstats;
 static combrd_t		stl_brdstats;
-static stlbrd_t		stl_dummybrd;
-static stlport_t	stl_dummyport;
+static struct stlbrd		stl_dummybrd;
+static struct stlport	stl_dummyport;
 
 /*
  *	Define global place to put buffer overflow characters.
@@ -164,7 +162,7 @@ static char		stl_unwanted[SC26198_RXFIFO
 
 /*****************************************************************************/
 
-static stlbrd_t		*stl_brds[STL_MAXBRDS];
+static struct stlbrd		*stl_brds[STL_MAXBRDS];
 
 /*
  *	Per board state flags. Used with the state field of the board struct.
@@ -243,12 +241,10 @@ static char	**stl_brdsp[] = {
  *	parse any module arguments.
  */
 
-typedef struct stlbrdtype {
+static struct {
 	char	*name;
 	int	type;
-} stlbrdtype_t;
-
-static stlbrdtype_t	stl_brdstr[] = {
+} stl_brdstr[] = {
 	{ "easyio", BRD_EASYIO },
 	{ "eio", BRD_EASYIO },
 	{ "20", BRD_EASYIO },
@@ -458,7 +454,7 @@ static unsigned int	stl_baudrates[] = {
  */
 
 static void	stl_argbrds(void);
-static int	stl_parsebrd(stlconf_t *confp, char **argp);
+static int	stl_parsebrd(struct stlconf *confp, char **argp);
 
 static unsigned long stl_atol(char *str);
 
@@ -482,31 +478,31 @@ static void	stl_waituntilsent(struct tty
 static void	stl_sendxchar(struct tty_struct *tty, char ch);
 static void	stl_hangup(struct tty_struct *tty);
 static int	stl_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, unsigned long arg);
-static int	stl_portinfo(stlport_t *portp, int portnr, char *pos);
+static int	stl_portinfo(struct stlport *portp, int portnr, char *pos);
 static int	stl_readproc(char *page, char **start, off_t off, int count, int *eof, void *data);
 
-static int	stl_brdinit(stlbrd_t *brdp);
-static int	stl_initports(stlbrd_t *brdp, stlpanel_t *panelp);
-static int	stl_getserial(stlport_t *portp, struct serial_struct __user *sp);
-static int	stl_setserial(stlport_t *portp, struct serial_struct __user *sp);
+static int	stl_brdinit(struct stlbrd *brdp);
+static int	stl_initports(struct stlbrd *brdp, struct stlpanel *panelp);
+static int	stl_getserial(struct stlport *portp, struct serial_struct __user *sp);
+static int	stl_setserial(struct stlport *portp, struct serial_struct __user *sp);
 static int	stl_getbrdstats(combrd_t __user *bp);
-static int	stl_getportstats(stlport_t *portp, comstats_t __user *cp);
-static int	stl_clrportstats(stlport_t *portp, comstats_t __user *cp);
-static int	stl_getportstruct(stlport_t __user *arg);
-static int	stl_getbrdstruct(stlbrd_t __user *arg);
-static int	stl_waitcarrier(stlport_t *portp, struct file *filp);
-static int	stl_eiointr(stlbrd_t *brdp);
-static int	stl_echatintr(stlbrd_t *brdp);
-static int	stl_echmcaintr(stlbrd_t *brdp);
-static int	stl_echpciintr(stlbrd_t *brdp);
-static int	stl_echpci64intr(stlbrd_t *brdp);
+static int	stl_getportstats(struct stlport *portp, comstats_t __user *cp);
+static int	stl_clrportstats(struct stlport *portp, comstats_t __user *cp);
+static int	stl_getportstruct(struct stlport __user *arg);
+static int	stl_getbrdstruct(struct stlbrd __user *arg);
+static int	stl_waitcarrier(struct stlport *portp, struct file *filp);
+static int	stl_eiointr(struct stlbrd *brdp);
+static int	stl_echatintr(struct stlbrd *brdp);
+static int	stl_echmcaintr(struct stlbrd *brdp);
+static int	stl_echpciintr(struct stlbrd *brdp);
+static int	stl_echpci64intr(struct stlbrd *brdp);
 static void	stl_offintr(struct work_struct *);
-static stlbrd_t *stl_allocbrd(void);
-static stlport_t *stl_getport(int brdnr, int panelnr, int portnr);
+static struct stlbrd *stl_allocbrd(void);
+static struct stlport *stl_getport(int brdnr, int panelnr, int portnr);
 
 static inline int	stl_initbrds(void);
-static inline int	stl_initeio(stlbrd_t *brdp);
-static inline int	stl_initech(stlbrd_t *brdp);
+static inline int	stl_initeio(struct stlbrd *brdp);
+static inline int	stl_initech(struct stlbrd *brdp);
 static inline int	stl_getbrdnr(void);
 
 #ifdef	CONFIG_PCI
@@ -517,59 +513,59 @@ static inline int	stl_initpcibrd(int brd
 /*
  *	CD1400 uart specific handling functions.
  */
-static void	stl_cd1400setreg(stlport_t *portp, int regnr, int value);
-static int	stl_cd1400getreg(stlport_t *portp, int regnr);
-static int	stl_cd1400updatereg(stlport_t *portp, int regnr, int value);
-static int	stl_cd1400panelinit(stlbrd_t *brdp, stlpanel_t *panelp);
-static void	stl_cd1400portinit(stlbrd_t *brdp, stlpanel_t *panelp, stlport_t *portp);
-static void	stl_cd1400setport(stlport_t *portp, struct termios *tiosp);
-static int	stl_cd1400getsignals(stlport_t *portp);
-static void	stl_cd1400setsignals(stlport_t *portp, int dtr, int rts);
-static void	stl_cd1400ccrwait(stlport_t *portp);
-static void	stl_cd1400enablerxtx(stlport_t *portp, int rx, int tx);
-static void	stl_cd1400startrxtx(stlport_t *portp, int rx, int tx);
-static void	stl_cd1400disableintrs(stlport_t *portp);
-static void	stl_cd1400sendbreak(stlport_t *portp, int len);
-static void	stl_cd1400flowctrl(stlport_t *portp, int state);
-static void	stl_cd1400sendflow(stlport_t *portp, int state);
-static void	stl_cd1400flush(stlport_t *portp);
-static int	stl_cd1400datastate(stlport_t *portp);
-static void	stl_cd1400eiointr(stlpanel_t *panelp, unsigned int iobase);
-static void	stl_cd1400echintr(stlpanel_t *panelp, unsigned int iobase);
-static void	stl_cd1400txisr(stlpanel_t *panelp, int ioaddr);
-static void	stl_cd1400rxisr(stlpanel_t *panelp, int ioaddr);
-static void	stl_cd1400mdmisr(stlpanel_t *panelp, int ioaddr);
+static void	stl_cd1400setreg(struct stlport *portp, int regnr, int value);
+static int	stl_cd1400getreg(struct stlport *portp, int regnr);
+static int	stl_cd1400updatereg(struct stlport *portp, int regnr, int value);
+static int	stl_cd1400panelinit(struct stlbrd *brdp, struct stlpanel *panelp);
+static void	stl_cd1400portinit(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp);
+static void	stl_cd1400setport(struct stlport *portp, struct termios *tiosp);
+static int	stl_cd1400getsignals(struct stlport *portp);
+static void	stl_cd1400setsignals(struct stlport *portp, int dtr, int rts);
+static void	stl_cd1400ccrwait(struct stlport *portp);
+static void	stl_cd1400enablerxtx(struct stlport *portp, int rx, int tx);
+static void	stl_cd1400startrxtx(struct stlport *portp, int rx, int tx);
+static void	stl_cd1400disableintrs(struct stlport *portp);
+static void	stl_cd1400sendbreak(struct stlport *portp, int len);
+static void	stl_cd1400flowctrl(struct stlport *portp, int state);
+static void	stl_cd1400sendflow(struct stlport *portp, int state);
+static void	stl_cd1400flush(struct stlport *portp);
+static int	stl_cd1400datastate(struct stlport *portp);
+static void	stl_cd1400eiointr(struct stlpanel *panelp, unsigned int iobase);
+static void	stl_cd1400echintr(struct stlpanel *panelp, unsigned int iobase);
+static void	stl_cd1400txisr(struct stlpanel *panelp, int ioaddr);
+static void	stl_cd1400rxisr(struct stlpanel *panelp, int ioaddr);
+static void	stl_cd1400mdmisr(struct stlpanel *panelp, int ioaddr);
 
-static inline int	stl_cd1400breakisr(stlport_t *portp, int ioaddr);
+static inline int	stl_cd1400breakisr(struct stlport *portp, int ioaddr);
 
 /*
  *	SC26198 uart specific handling functions.
  */
-static void	stl_sc26198setreg(stlport_t *portp, int regnr, int value);
-static int	stl_sc26198getreg(stlport_t *portp, int regnr);
-static int	stl_sc26198updatereg(stlport_t *portp, int regnr, int value);
-static int	stl_sc26198getglobreg(stlport_t *portp, int regnr);
-static int	stl_sc26198panelinit(stlbrd_t *brdp, stlpanel_t *panelp);
-static void	stl_sc26198portinit(stlbrd_t *brdp, stlpanel_t *panelp, stlport_t *portp);
-static void	stl_sc26198setport(stlport_t *portp, struct termios *tiosp);
-static int	stl_sc26198getsignals(stlport_t *portp);
-static void	stl_sc26198setsignals(stlport_t *portp, int dtr, int rts);
-static void	stl_sc26198enablerxtx(stlport_t *portp, int rx, int tx);
-static void	stl_sc26198startrxtx(stlport_t *portp, int rx, int tx);
-static void	stl_sc26198disableintrs(stlport_t *portp);
-static void	stl_sc26198sendbreak(stlport_t *portp, int len);
-static void	stl_sc26198flowctrl(stlport_t *portp, int state);
-static void	stl_sc26198sendflow(stlport_t *portp, int state);
-static void	stl_sc26198flush(stlport_t *portp);
-static int	stl_sc26198datastate(stlport_t *portp);
-static void	stl_sc26198wait(stlport_t *portp);
-static void	stl_sc26198txunflow(stlport_t *portp, struct tty_struct *tty);
-static void	stl_sc26198intr(stlpanel_t *panelp, unsigned int iobase);
-static void	stl_sc26198txisr(stlport_t *port);
-static void	stl_sc26198rxisr(stlport_t *port, unsigned int iack);
-static void	stl_sc26198rxbadch(stlport_t *portp, unsigned char status, char ch);
-static void	stl_sc26198rxbadchars(stlport_t *portp);
-static void	stl_sc26198otherisr(stlport_t *port, unsigned int iack);
+static void	stl_sc26198setreg(struct stlport *portp, int regnr, int value);
+static int	stl_sc26198getreg(struct stlport *portp, int regnr);
+static int	stl_sc26198updatereg(struct stlport *portp, int regnr, int value);
+static int	stl_sc26198getglobreg(struct stlport *portp, int regnr);
+static int	stl_sc26198panelinit(struct stlbrd *brdp, struct stlpanel *panelp);
+static void	stl_sc26198portinit(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp);
+static void	stl_sc26198setport(struct stlport *portp, struct termios *tiosp);
+static int	stl_sc26198getsignals(struct stlport *portp);
+static void	stl_sc26198setsignals(struct stlport *portp, int dtr, int rts);
+static void	stl_sc26198enablerxtx(struct stlport *portp, int rx, int tx);
+static void	stl_sc26198startrxtx(struct stlport *portp, int rx, int tx);
+static void	stl_sc26198disableintrs(struct stlport *portp);
+static void	stl_sc26198sendbreak(struct stlport *portp, int len);
+static void	stl_sc26198flowctrl(struct stlport *portp, int state);
+static void	stl_sc26198sendflow(struct stlport *portp, int state);
+static void	stl_sc26198flush(struct stlport *portp);
+static int	stl_sc26198datastate(struct stlport *portp);
+static void	stl_sc26198wait(struct stlport *portp);
+static void	stl_sc26198txunflow(struct stlport *portp, struct tty_struct *tty);
+static void	stl_sc26198intr(struct stlpanel *panelp, unsigned int iobase);
+static void	stl_sc26198txisr(struct stlport *port);
+static void	stl_sc26198rxisr(struct stlport *port, unsigned int iack);
+static void	stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char ch);
+static void	stl_sc26198rxbadchars(struct stlport *portp);
+static void	stl_sc26198otherisr(struct stlport *port, unsigned int iack);
 
 /*****************************************************************************/
 
@@ -577,20 +573,20 @@ static void	stl_sc26198otherisr(stlport_
  *	Generic UART support structure.
  */
 typedef struct uart {
-	int	(*panelinit)(stlbrd_t *brdp, stlpanel_t *panelp);
-	void	(*portinit)(stlbrd_t *brdp, stlpanel_t *panelp, stlport_t *portp);
-	void	(*setport)(stlport_t *portp, struct termios *tiosp);
-	int	(*getsignals)(stlport_t *portp);
-	void	(*setsignals)(stlport_t *portp, int dtr, int rts);
-	void	(*enablerxtx)(stlport_t *portp, int rx, int tx);
-	void	(*startrxtx)(stlport_t *portp, int rx, int tx);
-	void	(*disableintrs)(stlport_t *portp);
-	void	(*sendbreak)(stlport_t *portp, int len);
-	void	(*flowctrl)(stlport_t *portp, int state);
-	void	(*sendflow)(stlport_t *portp, int state);
-	void	(*flush)(stlport_t *portp);
-	int	(*datastate)(stlport_t *portp);
-	void	(*intr)(stlpanel_t *panelp, unsigned int iobase);
+	int	(*panelinit)(struct stlbrd *brdp, struct stlpanel *panelp);
+	void	(*portinit)(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp);
+	void	(*setport)(struct stlport *portp, struct termios *tiosp);
+	int	(*getsignals)(struct stlport *portp);
+	void	(*setsignals)(struct stlport *portp, int dtr, int rts);
+	void	(*enablerxtx)(struct stlport *portp, int rx, int tx);
+	void	(*startrxtx)(struct stlport *portp, int rx, int tx);
+	void	(*disableintrs)(struct stlport *portp);
+	void	(*sendbreak)(struct stlport *portp, int len);
+	void	(*flowctrl)(struct stlport *portp, int state);
+	void	(*sendflow)(struct stlport *portp, int state);
+	void	(*flush)(struct stlport *portp);
+	int	(*datastate)(struct stlport *portp);
+	void	(*intr)(struct stlpanel *panelp, unsigned int iobase);
 } uart_t;
 
 /*
@@ -730,9 +726,9 @@ static int __init stallion_module_init(v
 
 static void __exit stallion_module_exit(void)
 {
-	stlbrd_t	*brdp;
-	stlpanel_t	*panelp;
-	stlport_t	*portp;
+	struct stlbrd	*brdp;
+	struct stlpanel	*panelp;
+	struct stlport	*portp;
 	int		i, j, k;
 
 	pr_debug("cleanup_module()\n");
@@ -802,8 +798,8 @@ module_exit(stallion_module_exit);
 
 static void stl_argbrds(void)
 {
-	stlconf_t	conf;
-	stlbrd_t	*brdp;
+	struct stlconf	conf;
+	struct stlbrd	*brdp;
 	int		i;
 
 	pr_debug("stl_argbrds()\n");
@@ -867,7 +863,7 @@ static unsigned long stl_atol(char *str)
  *	Parse the supplied argument string, into the board conf struct.
  */
 
-static int stl_parsebrd(stlconf_t *confp, char **argp)
+static int stl_parsebrd(struct stlconf *confp, char **argp)
 {
 	char	*sp;
 	int	i;
@@ -911,14 +907,14 @@ static int stl_parsebrd(stlconf_t *confp
  *	Allocate a new board structure. Fill out the basic info in it.
  */
 
-static stlbrd_t *stl_allocbrd(void)
+static struct stlbrd *stl_allocbrd(void)
 {
-	stlbrd_t	*brdp;
+	struct stlbrd	*brdp;
 
-	brdp = kzalloc(sizeof(stlbrd_t), GFP_KERNEL);
+	brdp = kzalloc(sizeof(struct stlbrd), GFP_KERNEL);
 	if (!brdp) {
 		printk("STALLION: failed to allocate memory (size=%Zd)\n",
-			sizeof(stlbrd_t));
+			sizeof(struct stlbrd));
 		return NULL;
 	}
 
@@ -930,8 +926,8 @@ static stlbrd_t *stl_allocbrd(void)
 
 static int stl_open(struct tty_struct *tty, struct file *filp)
 {
-	stlport_t	*portp;
-	stlbrd_t	*brdp;
+	struct stlport	*portp;
+	struct stlbrd	*brdp;
 	unsigned int	minordev;
 	int		brdnr, panelnr, portnr, rc;
 
@@ -1020,7 +1016,7 @@ static int stl_open(struct tty_struct *t
  *	maybe because if we are clocal then we don't need to wait...
  */
 
-static int stl_waitcarrier(stlport_t *portp, struct file *filp)
+static int stl_waitcarrier(struct stlport *portp, struct file *filp)
 {
 	unsigned long	flags;
 	int		rc, doclocal;
@@ -1074,7 +1070,7 @@ static int stl_waitcarrier(stlport_t *po
 
 static void stl_close(struct tty_struct *tty, struct file *filp)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned long	flags;
 
 	pr_debug("stl_close(tty=%p,filp=%p)\n", tty, filp);
@@ -1154,7 +1150,7 @@ static void stl_close(struct tty_struct 
 
 static int stl_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned int	len, stlen;
 	unsigned char	*chbuf;
 	char		*head, *tail;
@@ -1211,7 +1207,7 @@ static int stl_write(struct tty_struct *
 
 static void stl_putchar(struct tty_struct *tty, unsigned char ch)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned int	len;
 	char		*head, *tail;
 
@@ -1249,7 +1245,7 @@ static void stl_putchar(struct tty_struc
 
 static void stl_flushchars(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_flushchars(tty=%p)\n", tty);
 
@@ -1268,7 +1264,7 @@ static void stl_flushchars(struct tty_st
 
 static int stl_writeroom(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	char		*head, *tail;
 
 	pr_debug("stl_writeroom(tty=%p)\n", tty);
@@ -1299,7 +1295,7 @@ static int stl_writeroom(struct tty_stru
 
 static int stl_charsinbuffer(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned int	size;
 	char		*head, *tail;
 
@@ -1327,10 +1323,10 @@ static int stl_charsinbuffer(struct tty_
  *	Generate the serial struct info.
  */
 
-static int stl_getserial(stlport_t *portp, struct serial_struct __user *sp)
+static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
 {
 	struct serial_struct	sio;
-	stlbrd_t		*brdp;
+	struct stlbrd		*brdp;
 
 	pr_debug("stl_getserial(portp=%p,sp=%p)\n", portp, sp);
 
@@ -1366,7 +1362,7 @@ static int stl_getserial(stlport_t *port
  *	just quietly ignore any requests to change irq, etc.
  */
 
-static int stl_setserial(stlport_t *portp, struct serial_struct __user *sp)
+static int stl_setserial(struct stlport *portp, struct serial_struct __user *sp)
 {
 	struct serial_struct	sio;
 
@@ -1396,7 +1392,7 @@ static int stl_setserial(stlport_t *port
 
 static int stl_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	if (tty == NULL)
 		return -ENODEV;
@@ -1412,7 +1408,7 @@ static int stl_tiocmget(struct tty_struc
 static int stl_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	int rts = -1, dtr = -1;
 
 	if (tty == NULL)
@@ -1438,7 +1434,7 @@ static int stl_tiocmset(struct tty_struc
 
 static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned int	ival;
 	int		rc;
 	void __user *argp = (void __user *)arg;
@@ -1503,7 +1499,7 @@ static int stl_ioctl(struct tty_struct *
 
 static void stl_settermios(struct tty_struct *tty, struct termios *old)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	struct termios	*tiosp;
 
 	pr_debug("stl_settermios(tty=%p,old=%p)\n", tty, old);
@@ -1539,7 +1535,7 @@ static void stl_settermios(struct tty_st
 
 static void stl_throttle(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_throttle(tty=%p)\n", tty);
 
@@ -1559,7 +1555,7 @@ static void stl_throttle(struct tty_stru
 
 static void stl_unthrottle(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_unthrottle(tty=%p)\n", tty);
 
@@ -1580,7 +1576,7 @@ static void stl_unthrottle(struct tty_st
 
 static void stl_stop(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_stop(tty=%p)\n", tty);
 
@@ -1600,7 +1596,7 @@ static void stl_stop(struct tty_struct *
 
 static void stl_start(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_start(tty=%p)\n", tty);
 
@@ -1622,7 +1618,7 @@ static void stl_start(struct tty_struct 
 
 static void stl_hangup(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_hangup(tty=%p)\n", tty);
 
@@ -1656,7 +1652,7 @@ static void stl_hangup(struct tty_struct
 
 static void stl_flushbuffer(struct tty_struct *tty)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_flushbuffer(tty=%p)\n", tty);
 
@@ -1674,7 +1670,7 @@ static void stl_flushbuffer(struct tty_s
 
 static void stl_breakctl(struct tty_struct *tty, int state)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_breakctl(tty=%p,state=%d)\n", tty, state);
 
@@ -1691,7 +1687,7 @@ static void stl_breakctl(struct tty_stru
 
 static void stl_waituntilsent(struct tty_struct *tty, int timeout)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned long	tend;
 
 	pr_debug("stl_waituntilsent(tty=%p,timeout=%d)\n", tty, timeout);
@@ -1719,7 +1715,7 @@ static void stl_waituntilsent(struct tty
 
 static void stl_sendxchar(struct tty_struct *tty, char ch)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
 	pr_debug("stl_sendxchar(tty=%p,ch=%x)\n", tty, ch);
 
@@ -1747,7 +1743,7 @@ static void stl_sendxchar(struct tty_str
  *	short then padded with spaces).
  */
 
-static int stl_portinfo(stlport_t *portp, int portnr, char *pos)
+static int stl_portinfo(struct stlport *portp, int portnr, char *pos)
 {
 	char	*sp;
 	int	sigs, cnt;
@@ -1793,9 +1789,9 @@ static int stl_portinfo(stlport_t *portp
 
 static int stl_readproc(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
-	stlbrd_t	*brdp;
-	stlpanel_t	*panelp;
-	stlport_t	*portp;
+	struct stlbrd	*brdp;
+	struct stlpanel	*panelp;
+	struct stlport	*portp;
 	int		brdnr, panelnr, portnr, totalport;
 	int		curoff, maxoff;
 	char		*pos;
@@ -1876,7 +1872,7 @@ stl_readdone:
 
 static irqreturn_t stl_intr(int irq, void *dev_id)
 {
-	stlbrd_t *brdp = dev_id;
+	struct stlbrd *brdp = dev_id;
 
 	pr_debug("stl_intr(brdp=%p,irq=%d)\n", brdp, irq);
 
@@ -1889,9 +1885,9 @@ static irqreturn_t stl_intr(int irq, voi
  *	Interrupt service routine for EasyIO board types.
  */
 
-static int stl_eiointr(stlbrd_t *brdp)
+static int stl_eiointr(struct stlbrd *brdp)
 {
-	stlpanel_t	*panelp;
+	struct stlpanel	*panelp;
 	unsigned int	iobase;
 	int		handled = 0;
 
@@ -1912,9 +1908,9 @@ static int stl_eiointr(stlbrd_t *brdp)
  *	Interrupt service routine for ECH-AT board types.
  */
 
-static int stl_echatintr(stlbrd_t *brdp)
+static int stl_echatintr(struct stlbrd *brdp)
 {
-	stlpanel_t	*panelp;
+	struct stlpanel	*panelp;
 	unsigned int	ioaddr;
 	int		bnknr;
 	int		handled = 0;
@@ -1943,9 +1939,9 @@ static int stl_echatintr(stlbrd_t *brdp)
  *	Interrupt service routine for ECH-MCA board types.
  */
 
-static int stl_echmcaintr(stlbrd_t *brdp)
+static int stl_echmcaintr(struct stlbrd *brdp)
 {
-	stlpanel_t	*panelp;
+	struct stlpanel	*panelp;
 	unsigned int	ioaddr;
 	int		bnknr;
 	int		handled = 0;
@@ -1969,9 +1965,9 @@ static int stl_echmcaintr(stlbrd_t *brdp
  *	Interrupt service routine for ECH-PCI board types.
  */
 
-static int stl_echpciintr(stlbrd_t *brdp)
+static int stl_echpciintr(struct stlbrd *brdp)
 {
-	stlpanel_t	*panelp;
+	struct stlpanel	*panelp;
 	unsigned int	ioaddr;
 	int		bnknr, recheck;
 	int		handled = 0;
@@ -2000,9 +1996,9 @@ static int stl_echpciintr(stlbrd_t *brdp
  *	Interrupt service routine for ECH-8/64-PCI board types.
  */
 
-static int stl_echpci64intr(stlbrd_t *brdp)
+static int stl_echpci64intr(struct stlbrd *brdp)
 {
-	stlpanel_t	*panelp;
+	struct stlpanel	*panelp;
 	unsigned int	ioaddr;
 	int		bnknr;
 	int		handled = 0;
@@ -2028,7 +2024,7 @@ static int stl_echpci64intr(stlbrd_t *br
  */
 static void stl_offintr(struct work_struct *work)
 {
-	stlport_t		*portp = container_of(work, stlport_t, tqueue);
+	struct stlport		*portp = container_of(work, struct stlport, tqueue);
 	struct tty_struct	*tty;
 	unsigned int		oldsigs;
 
@@ -2065,9 +2061,9 @@ static void stl_offintr(struct work_stru
  *	Initialize all the ports on a panel.
  */
 
-static int __init stl_initports(stlbrd_t *brdp, stlpanel_t *panelp)
+static int __init stl_initports(struct stlbrd *brdp, struct stlpanel *panelp)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	int		chipmask, i;
 
 	pr_debug("stl_initports(brdp=%p,panelp=%p)\n", brdp, panelp);
@@ -2079,10 +2075,10 @@ static int __init stl_initports(stlbrd_t
  *	each ports data structures.
  */
 	for (i = 0; (i < panelp->nrports); i++) {
-		portp = kzalloc(sizeof(stlport_t), GFP_KERNEL);
+		portp = kzalloc(sizeof(struct stlport), GFP_KERNEL);
 		if (!portp) {
 			printk("STALLION: failed to allocate memory "
-				"(size=%Zd)\n", sizeof(stlport_t));
+				"(size=%Zd)\n", sizeof(struct stlport));
 			break;
 		}
 
@@ -2114,9 +2110,9 @@ static int __init stl_initports(stlbrd_t
  *	Try to find and initialize an EasyIO board.
  */
 
-static inline int stl_initeio(stlbrd_t *brdp)
+static inline int stl_initeio(struct stlbrd *brdp)
 {
-	stlpanel_t	*panelp;
+	struct stlpanel	*panelp;
 	unsigned int	status;
 	char		*name;
 	int		rc;
@@ -2213,10 +2209,10 @@ static inline int stl_initeio(stlbrd_t *
  *	can complete the setup.
  */
 
-	panelp = kzalloc(sizeof(stlpanel_t), GFP_KERNEL);
+	panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
 	if (!panelp) {
 		printk(KERN_WARNING "STALLION: failed to allocate memory "
-			"(size=%Zd)\n", sizeof(stlpanel_t));
+			"(size=%Zd)\n", sizeof(struct stlpanel));
 		return -ENOMEM;
 	}
 
@@ -2255,9 +2251,9 @@ static inline int stl_initeio(stlbrd_t *
  *	dealing with all types of ECH board.
  */
 
-static inline int stl_initech(stlbrd_t *brdp)
+static inline int stl_initech(struct stlbrd *brdp)
 {
-	stlpanel_t	*panelp;
+	struct stlpanel	*panelp;
 	unsigned int	status, nxtid, ioaddr, conflict;
 	int		panelnr, banknr, i;
 	char		*name;
@@ -2385,10 +2381,10 @@ static inline int stl_initech(stlbrd_t *
 		status = inb(ioaddr + ECH_PNLSTATUS);
 		if ((status & ECH_PNLIDMASK) != nxtid)
 			break;
-		panelp = kzalloc(sizeof(stlpanel_t), GFP_KERNEL);
+		panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
 		if (!panelp) {
 			printk("STALLION: failed to allocate memory "
-				"(size=%Zd)\n", sizeof(stlpanel_t));
+				"(size=%Zd)\n", sizeof(struct stlpanel));
 			break;
 		}
 		panelp->magic = STL_PANELMAGIC;
@@ -2466,7 +2462,7 @@ static inline int stl_initech(stlbrd_t *
  *	since the initial search and setup is very different.
  */
 
-static int __init stl_brdinit(stlbrd_t *brdp)
+static int __init stl_brdinit(struct stlbrd *brdp)
 {
 	int	i;
 
@@ -2540,7 +2536,7 @@ static inline int stl_getbrdnr(void)
 
 static inline int stl_initpcibrd(int brdtype, struct pci_dev *devp)
 {
-	stlbrd_t	*brdp;
+	struct stlbrd	*brdp;
 
 	pr_debug("stl_initpcibrd(brdtype=%d,busnr=%x,devnr=%x)\n", brdtype,
 		devp->bus->number, devp->devfn);
@@ -2638,8 +2634,8 @@ static inline int stl_findpcibrds(void)
 
 static inline int stl_initbrds(void)
 {
-	stlbrd_t	*brdp;
-	stlconf_t	*confp;
+	struct stlbrd	*brdp;
+	struct stlconf	*confp;
 	int		i;
 
 	pr_debug("stl_initbrds()\n");
@@ -2688,8 +2684,8 @@ static inline int stl_initbrds(void)
 
 static int stl_getbrdstats(combrd_t __user *bp)
 {
-	stlbrd_t	*brdp;
-	stlpanel_t	*panelp;
+	struct stlbrd	*brdp;
+	struct stlpanel	*panelp;
 	int		i;
 
 	if (copy_from_user(&stl_brdstats, bp, sizeof(combrd_t)))
@@ -2726,10 +2722,10 @@ static int stl_getbrdstats(combrd_t __us
  *	Resolve the referenced port number into a port struct pointer.
  */
 
-static stlport_t *stl_getport(int brdnr, int panelnr, int portnr)
+static struct stlport *stl_getport(int brdnr, int panelnr, int portnr)
 {
-	stlbrd_t	*brdp;
-	stlpanel_t	*panelp;
+	struct stlbrd	*brdp;
+	struct stlpanel	*panelp;
 
 	if ((brdnr < 0) || (brdnr >= STL_MAXBRDS))
 		return(NULL);
@@ -2754,7 +2750,7 @@ static stlport_t *stl_getport(int brdnr,
  *	what port to get stats for (used through board control device).
  */
 
-static int stl_getportstats(stlport_t *portp, comstats_t __user *cp)
+static int stl_getportstats(struct stlport *portp, comstats_t __user *cp)
 {
 	unsigned char	*head, *tail;
 	unsigned long	flags;
@@ -2812,7 +2808,7 @@ static int stl_getportstats(stlport_t *p
  *	Clear the port stats structure. We also return it zeroed out...
  */
 
-static int stl_clrportstats(stlport_t *portp, comstats_t __user *cp)
+static int stl_clrportstats(struct stlport *portp, comstats_t __user *cp)
 {
 	if (!portp) {
 		if (copy_from_user(&stl_comstats, cp, sizeof(comstats_t)))
@@ -2837,17 +2833,17 @@ static int stl_clrportstats(stlport_t *p
  *	Return the entire driver ports structure to a user app.
  */
 
-static int stl_getportstruct(stlport_t __user *arg)
+static int stl_getportstruct(struct stlport __user *arg)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 
-	if (copy_from_user(&stl_dummyport, arg, sizeof(stlport_t)))
+	if (copy_from_user(&stl_dummyport, arg, sizeof(struct stlport)))
 		return -EFAULT;
 	portp = stl_getport(stl_dummyport.brdnr, stl_dummyport.panelnr,
 		 stl_dummyport.portnr);
 	if (!portp)
 		return -ENODEV;
-	return copy_to_user(arg, portp, sizeof(stlport_t)) ? -EFAULT : 0;
+	return copy_to_user(arg, portp, sizeof(struct stlport)) ? -EFAULT : 0;
 }
 
 /*****************************************************************************/
@@ -2856,18 +2852,18 @@ static int stl_getportstruct(stlport_t _
  *	Return the entire driver board structure to a user app.
  */
 
-static int stl_getbrdstruct(stlbrd_t __user *arg)
+static int stl_getbrdstruct(struct stlbrd __user *arg)
 {
-	stlbrd_t	*brdp;
+	struct stlbrd	*brdp;
 
-	if (copy_from_user(&stl_dummybrd, arg, sizeof(stlbrd_t)))
+	if (copy_from_user(&stl_dummybrd, arg, sizeof(struct stlbrd)))
 		return -EFAULT;
 	if ((stl_dummybrd.brdnr < 0) || (stl_dummybrd.brdnr >= STL_MAXBRDS))
 		return -ENODEV;
 	brdp = stl_brds[stl_dummybrd.brdnr];
 	if (!brdp)
 		return(-ENODEV);
-	return copy_to_user(arg, brdp, sizeof(stlbrd_t)) ? -EFAULT : 0;
+	return copy_to_user(arg, brdp, sizeof(struct stlbrd)) ? -EFAULT : 0;
 }
 
 /*****************************************************************************/
@@ -2997,19 +2993,19 @@ static int __init stl_init(void)
  *	(Maybe should make this inline...)
  */
 
-static int stl_cd1400getreg(stlport_t *portp, int regnr)
+static int stl_cd1400getreg(struct stlport *portp, int regnr)
 {
 	outb((regnr + portp->uartaddr), portp->ioaddr);
 	return inb(portp->ioaddr + EREG_DATA);
 }
 
-static void stl_cd1400setreg(stlport_t *portp, int regnr, int value)
+static void stl_cd1400setreg(struct stlport *portp, int regnr, int value)
 {
 	outb((regnr + portp->uartaddr), portp->ioaddr);
 	outb(value, portp->ioaddr + EREG_DATA);
 }
 
-static int stl_cd1400updatereg(stlport_t *portp, int regnr, int value)
+static int stl_cd1400updatereg(struct stlport *portp, int regnr, int value)
 {
 	outb((regnr + portp->uartaddr), portp->ioaddr);
 	if (inb(portp->ioaddr + EREG_DATA) != value) {
@@ -3027,7 +3023,7 @@ static int stl_cd1400updatereg(stlport_t
  *	identical when dealing with ports.
  */
 
-static int stl_cd1400panelinit(stlbrd_t *brdp, stlpanel_t *panelp)
+static int stl_cd1400panelinit(struct stlbrd *brdp, struct stlpanel *panelp)
 {
 	unsigned int	gfrcr;
 	int		chipmask, i, j;
@@ -3084,7 +3080,7 @@ static int stl_cd1400panelinit(stlbrd_t 
  *	Initialize hardware specific port registers.
  */
 
-static void stl_cd1400portinit(stlbrd_t *brdp, stlpanel_t *panelp, stlport_t *portp)
+static void stl_cd1400portinit(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp)
 {
 	unsigned long flags;
 	pr_debug("stl_cd1400portinit(brdp=%p,panelp=%p,portp=%p)\n", brdp,
@@ -3115,7 +3111,7 @@ static void stl_cd1400portinit(stlbrd_t 
  *	since it won't usually take too long to be ready.
  */
 
-static void stl_cd1400ccrwait(stlport_t *portp)
+static void stl_cd1400ccrwait(struct stlport *portp)
 {
 	int	i;
 
@@ -3136,9 +3132,9 @@ static void stl_cd1400ccrwait(stlport_t 
  *	settings.
  */
 
-static void stl_cd1400setport(stlport_t *portp, struct termios *tiosp)
+static void stl_cd1400setport(struct stlport *portp, struct termios *tiosp)
 {
-	stlbrd_t	*brdp;
+	struct stlbrd	*brdp;
 	unsigned long	flags;
 	unsigned int	clkdiv, baudrate;
 	unsigned char	cor1, cor2, cor3;
@@ -3359,7 +3355,7 @@ static void stl_cd1400setport(stlport_t 
  *	Set the state of the DTR and RTS signals.
  */
 
-static void stl_cd1400setsignals(stlport_t *portp, int dtr, int rts)
+static void stl_cd1400setsignals(struct stlport *portp, int dtr, int rts)
 {
 	unsigned char	msvr1, msvr2;
 	unsigned long	flags;
@@ -3391,7 +3387,7 @@ static void stl_cd1400setsignals(stlport
  *	Return the state of the signals.
  */
 
-static int stl_cd1400getsignals(stlport_t *portp)
+static int stl_cd1400getsignals(struct stlport *portp)
 {
 	unsigned char	msvr1, msvr2;
 	unsigned long	flags;
@@ -3427,7 +3423,7 @@ static int stl_cd1400getsignals(stlport_
  *	Enable/Disable the Transmitter and/or Receiver.
  */
 
-static void stl_cd1400enablerxtx(stlport_t *portp, int rx, int tx)
+static void stl_cd1400enablerxtx(struct stlport *portp, int rx, int tx)
 {
 	unsigned char	ccr;
 	unsigned long	flags;
@@ -3461,7 +3457,7 @@ static void stl_cd1400enablerxtx(stlport
  *	Start/stop the Transmitter and/or Receiver.
  */
 
-static void stl_cd1400startrxtx(stlport_t *portp, int rx, int tx)
+static void stl_cd1400startrxtx(struct stlport *portp, int rx, int tx)
 {
 	unsigned char	sreron, sreroff;
 	unsigned long	flags;
@@ -3498,7 +3494,7 @@ static void stl_cd1400startrxtx(stlport_
  *	Disable all interrupts from this port.
  */
 
-static void stl_cd1400disableintrs(stlport_t *portp)
+static void stl_cd1400disableintrs(struct stlport *portp)
 {
 	unsigned long	flags;
 
@@ -3514,7 +3510,7 @@ static void stl_cd1400disableintrs(stlpo
 
 /*****************************************************************************/
 
-static void stl_cd1400sendbreak(stlport_t *portp, int len)
+static void stl_cd1400sendbreak(struct stlport *portp, int len)
 {
 	unsigned long	flags;
 
@@ -3539,7 +3535,7 @@ static void stl_cd1400sendbreak(stlport_
  *	Take flow control actions...
  */
 
-static void stl_cd1400flowctrl(stlport_t *portp, int state)
+static void stl_cd1400flowctrl(struct stlport *portp, int state)
 {
 	struct tty_struct	*tty;
 	unsigned long		flags;
@@ -3601,7 +3597,7 @@ static void stl_cd1400flowctrl(stlport_t
  *	Send a flow control character...
  */
 
-static void stl_cd1400sendflow(stlport_t *portp, int state)
+static void stl_cd1400sendflow(struct stlport *portp, int state)
 {
 	struct tty_struct	*tty;
 	unsigned long		flags;
@@ -3634,7 +3630,7 @@ static void stl_cd1400sendflow(stlport_t
 
 /*****************************************************************************/
 
-static void stl_cd1400flush(stlport_t *portp)
+static void stl_cd1400flush(struct stlport *portp)
 {
 	unsigned long	flags;
 
@@ -3663,7 +3659,7 @@ static void stl_cd1400flush(stlport_t *p
  *	maintains the busy port flag.
  */
 
-static int stl_cd1400datastate(stlport_t *portp)
+static int stl_cd1400datastate(struct stlport *portp)
 {
 	pr_debug("stl_cd1400datastate(portp=%p)\n", portp);
 
@@ -3679,7 +3675,7 @@ static int stl_cd1400datastate(stlport_t
  *	Interrupt service routine for cd1400 EasyIO boards.
  */
 
-static void stl_cd1400eiointr(stlpanel_t *panelp, unsigned int iobase)
+static void stl_cd1400eiointr(struct stlpanel *panelp, unsigned int iobase)
 {
 	unsigned char	svrtype;
 
@@ -3709,7 +3705,7 @@ static void stl_cd1400eiointr(stlpanel_t
  *	Interrupt service routine for cd1400 panels.
  */
 
-static void stl_cd1400echintr(stlpanel_t *panelp, unsigned int iobase)
+static void stl_cd1400echintr(struct stlpanel *panelp, unsigned int iobase)
 {
 	unsigned char	svrtype;
 
@@ -3735,7 +3731,7 @@ static void stl_cd1400echintr(stlpanel_t
  *	this is the only way to generate them on the cd1400.
  */
 
-static inline int stl_cd1400breakisr(stlport_t *portp, int ioaddr)
+static inline int stl_cd1400breakisr(struct stlport *portp, int ioaddr)
 {
 	if (portp->brklen == 1) {
 		outb((COR2 + portp->uartaddr), ioaddr);
@@ -3777,9 +3773,9 @@ static inline int stl_cd1400breakisr(stl
  *	be NULL if the buffer has been freed.
  */
 
-static void stl_cd1400txisr(stlpanel_t *panelp, int ioaddr)
+static void stl_cd1400txisr(struct stlpanel *panelp, int ioaddr)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	int		len, stlen;
 	char		*head, *tail;
 	unsigned char	ioack, srer;
@@ -3856,9 +3852,9 @@ stl_txalldone:
  *	shutdown a port not in user context. Need to handle this case.
  */
 
-static void stl_cd1400rxisr(stlpanel_t *panelp, int ioaddr)
+static void stl_cd1400rxisr(struct stlpanel *panelp, int ioaddr)
 {
-	stlport_t		*portp;
+	struct stlport		*portp;
 	struct tty_struct	*tty;
 	unsigned int		ioack, len, buflen;
 	unsigned char		status;
@@ -3954,9 +3950,9 @@ stl_rxalldone:
  *	processing routine.
  */
 
-static void stl_cd1400mdmisr(stlpanel_t *panelp, int ioaddr)
+static void stl_cd1400mdmisr(struct stlpanel *panelp, int ioaddr)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned int	ioack;
 	unsigned char	misr;
 
@@ -3992,19 +3988,19 @@ static void stl_cd1400mdmisr(stlpanel_t 
  *	(Maybe should make this inline...)
  */
 
-static int stl_sc26198getreg(stlport_t *portp, int regnr)
+static int stl_sc26198getreg(struct stlport *portp, int regnr)
 {
 	outb((regnr | portp->uartaddr), (portp->ioaddr + XP_ADDR));
 	return inb(portp->ioaddr + XP_DATA);
 }
 
-static void stl_sc26198setreg(stlport_t *portp, int regnr, int value)
+static void stl_sc26198setreg(struct stlport *portp, int regnr, int value)
 {
 	outb((regnr | portp->uartaddr), (portp->ioaddr + XP_ADDR));
 	outb(value, (portp->ioaddr + XP_DATA));
 }
 
-static int stl_sc26198updatereg(stlport_t *portp, int regnr, int value)
+static int stl_sc26198updatereg(struct stlport *portp, int regnr, int value)
 {
 	outb((regnr | portp->uartaddr), (portp->ioaddr + XP_ADDR));
 	if (inb(portp->ioaddr + XP_DATA) != value) {
@@ -4020,14 +4016,14 @@ static int stl_sc26198updatereg(stlport_
  *	Functions to get and set the sc26198 global registers.
  */
 
-static int stl_sc26198getglobreg(stlport_t *portp, int regnr)
+static int stl_sc26198getglobreg(struct stlport *portp, int regnr)
 {
 	outb(regnr, (portp->ioaddr + XP_ADDR));
 	return inb(portp->ioaddr + XP_DATA);
 }
 
 #if 0
-static void stl_sc26198setglobreg(stlport_t *portp, int regnr, int value)
+static void stl_sc26198setglobreg(struct stlport *portp, int regnr, int value)
 {
 	outb(regnr, (portp->ioaddr + XP_ADDR));
 	outb(value, (portp->ioaddr + XP_DATA));
@@ -4042,7 +4038,7 @@ static void stl_sc26198setglobreg(stlpor
  *	identical when dealing with ports.
  */
 
-static int stl_sc26198panelinit(stlbrd_t *brdp, stlpanel_t *panelp)
+static int stl_sc26198panelinit(struct stlbrd *brdp, struct stlpanel *panelp)
 {
 	int	chipmask, i;
 	int	nrchips, ioaddr;
@@ -4087,7 +4083,7 @@ static int stl_sc26198panelinit(stlbrd_t
  *	Initialize hardware specific port registers.
  */
 
-static void stl_sc26198portinit(stlbrd_t *brdp, stlpanel_t *panelp, stlport_t *portp)
+static void stl_sc26198portinit(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp)
 {
 	pr_debug("stl_sc26198portinit(brdp=%p,panelp=%p,portp=%p)\n", brdp,
 			panelp, portp);
@@ -4113,9 +4109,9 @@ static void stl_sc26198portinit(stlbrd_t
  *	settings.
  */
 
-static void stl_sc26198setport(stlport_t *portp, struct termios *tiosp)
+static void stl_sc26198setport(struct stlport *portp, struct termios *tiosp)
 {
-	stlbrd_t	*brdp;
+	struct stlbrd	*brdp;
 	unsigned long	flags;
 	unsigned int	baudrate;
 	unsigned char	mr0, mr1, mr2, clk;
@@ -4308,7 +4304,7 @@ static void stl_sc26198setport(stlport_t
  *	Set the state of the DTR and RTS signals.
  */
 
-static void stl_sc26198setsignals(stlport_t *portp, int dtr, int rts)
+static void stl_sc26198setsignals(struct stlport *portp, int dtr, int rts)
 {
 	unsigned char	iopioron, iopioroff;
 	unsigned long	flags;
@@ -4341,7 +4337,7 @@ static void stl_sc26198setsignals(stlpor
  *	Return the state of the signals.
  */
 
-static int stl_sc26198getsignals(stlport_t *portp)
+static int stl_sc26198getsignals(struct stlport *portp)
 {
 	unsigned char	ipr;
 	unsigned long	flags;
@@ -4370,7 +4366,7 @@ static int stl_sc26198getsignals(stlport
  *	Enable/Disable the Transmitter and/or Receiver.
  */
 
-static void stl_sc26198enablerxtx(stlport_t *portp, int rx, int tx)
+static void stl_sc26198enablerxtx(struct stlport *portp, int rx, int tx)
 {
 	unsigned char	ccr;
 	unsigned long	flags;
@@ -4401,7 +4397,7 @@ static void stl_sc26198enablerxtx(stlpor
  *	Start/stop the Transmitter and/or Receiver.
  */
 
-static void stl_sc26198startrxtx(stlport_t *portp, int rx, int tx)
+static void stl_sc26198startrxtx(struct stlport *portp, int rx, int tx)
 {
 	unsigned char	imr;
 	unsigned long	flags;
@@ -4434,7 +4430,7 @@ static void stl_sc26198startrxtx(stlport
  *	Disable all interrupts from this port.
  */
 
-static void stl_sc26198disableintrs(stlport_t *portp)
+static void stl_sc26198disableintrs(struct stlport *portp)
 {
 	unsigned long	flags;
 
@@ -4450,7 +4446,7 @@ static void stl_sc26198disableintrs(stlp
 
 /*****************************************************************************/
 
-static void stl_sc26198sendbreak(stlport_t *portp, int len)
+static void stl_sc26198sendbreak(struct stlport *portp, int len)
 {
 	unsigned long	flags;
 
@@ -4474,7 +4470,7 @@ static void stl_sc26198sendbreak(stlport
  *	Take flow control actions...
  */
 
-static void stl_sc26198flowctrl(stlport_t *portp, int state)
+static void stl_sc26198flowctrl(struct stlport *portp, int state)
 {
 	struct tty_struct	*tty;
 	unsigned long		flags;
@@ -4543,7 +4539,7 @@ static void stl_sc26198flowctrl(stlport_
  *	Send a flow control character.
  */
 
-static void stl_sc26198sendflow(stlport_t *portp, int state)
+static void stl_sc26198sendflow(struct stlport *portp, int state)
 {
 	struct tty_struct	*tty;
 	unsigned long		flags;
@@ -4582,7 +4578,7 @@ static void stl_sc26198sendflow(stlport_
 
 /*****************************************************************************/
 
-static void stl_sc26198flush(stlport_t *portp)
+static void stl_sc26198flush(struct stlport *portp)
 {
 	unsigned long	flags;
 
@@ -4610,7 +4606,7 @@ static void stl_sc26198flush(stlport_t *
  *	check the port statusy register to be sure.
  */
 
-static int stl_sc26198datastate(stlport_t *portp)
+static int stl_sc26198datastate(struct stlport *portp)
 {
 	unsigned long	flags;
 	unsigned char	sr;
@@ -4638,7 +4634,7 @@ static int stl_sc26198datastate(stlport_
  *	to process a command...
  */
 
-static void stl_sc26198wait(stlport_t *portp)
+static void stl_sc26198wait(struct stlport *portp)
 {
 	int	i;
 
@@ -4659,7 +4655,7 @@ static void stl_sc26198wait(stlport_t *p
  *	automatic flow control modes of the sc26198.
  */
 
-static inline void stl_sc26198txunflow(stlport_t *portp, struct tty_struct *tty)
+static inline void stl_sc26198txunflow(struct stlport *portp, struct tty_struct *tty)
 {
 	unsigned char	mr0;
 
@@ -4677,9 +4673,9 @@ static inline void stl_sc26198txunflow(s
  *	Interrupt service routine for sc26198 panels.
  */
 
-static void stl_sc26198intr(stlpanel_t *panelp, unsigned int iobase)
+static void stl_sc26198intr(struct stlpanel *panelp, unsigned int iobase)
 {
-	stlport_t	*portp;
+	struct stlport	*portp;
 	unsigned int	iack;
 
 	spin_lock(&brd_lock);
@@ -4715,7 +4711,7 @@ static void stl_sc26198intr(stlpanel_t *
  *	be NULL if the buffer has been freed.
  */
 
-static void stl_sc26198txisr(stlport_t *portp)
+static void stl_sc26198txisr(struct stlport *portp)
 {
 	unsigned int	ioaddr;
 	unsigned char	mr0;
@@ -4776,7 +4772,7 @@ static void stl_sc26198txisr(stlport_t *
  *	shutdown a port not in user context. Need to handle this case.
  */
 
-static void stl_sc26198rxisr(stlport_t *portp, unsigned int iack)
+static void stl_sc26198rxisr(struct stlport *portp, unsigned int iack)
 {
 	struct tty_struct	*tty;
 	unsigned int		len, buflen, ioaddr;
@@ -4830,7 +4826,7 @@ static void stl_sc26198rxisr(stlport_t *
  *	Process an RX bad character.
  */
 
-static inline void stl_sc26198rxbadch(stlport_t *portp, unsigned char status, char ch)
+static inline void stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char ch)
 {
 	struct tty_struct	*tty;
 	unsigned int		ioaddr;
@@ -4888,7 +4884,7 @@ static inline void stl_sc26198rxbadch(st
  *	the FIFO).
  */
 
-static void stl_sc26198rxbadchars(stlport_t *portp)
+static void stl_sc26198rxbadchars(struct stlport *portp)
 {
 	unsigned char	status, mr1;
 	char		ch;
@@ -4921,7 +4917,7 @@ static void stl_sc26198rxbadchars(stlpor
  *	processing time.
  */
 
-static void stl_sc26198otherisr(stlport_t *portp, unsigned int iack)
+static void stl_sc26198otherisr(struct stlport *portp, unsigned int iack)
 {
 	unsigned char	cir, ipr, xisr;
 
diff -puN include/linux/stallion.h~char-stallion-kill-typedefs include/linux/stallion.h
--- a/include/linux/stallion.h~char-stallion-kill-typedefs
+++ a/include/linux/stallion.h
@@ -52,11 +52,11 @@
  *	protection - since "write" code only needs to change the head, and
  *	interrupt code only needs to change the tail.
  */
-typedef struct {
+struct stlrq {
 	char	*buf;
 	char	*head;
 	char	*tail;
-} stlrq_t;
+};
 
 /*
  *	Port, panel and board structures to hold status info about each.
@@ -67,7 +67,7 @@ typedef struct {
  *	is associated with, this makes it (fairly) easy to get back to the
  *	board/panel info for a port.
  */
-typedef struct stlport {
+struct stlport {
 	unsigned long		magic;
 	int			portnr;
 	int			panelnr;
@@ -97,10 +97,10 @@ typedef struct stlport {
 	wait_queue_head_t	close_wait;
 	struct work_struct	tqueue;
 	comstats_t		stats;
-	stlrq_t			tx;
-} stlport_t;
+	struct stlrq		tx;
+};
 
-typedef struct stlpanel {
+struct stlpanel {
 	unsigned long	magic;
 	int		panelnr;
 	int		brdnr;
@@ -111,10 +111,10 @@ typedef struct stlpanel {
 	void		(*isr)(struct stlpanel *panelp, unsigned int iobase);
 	unsigned int	hwid;
 	unsigned int	ackmask;
-	stlport_t	*ports[STL_PORTSPERPANEL];
-} stlpanel_t;
+	struct stlport	*ports[STL_PORTSPERPANEL];
+};
 
-typedef struct stlbrd {
+struct stlbrd {
 	unsigned long	magic;
 	int		brdnr;
 	int		brdtype;
@@ -136,9 +136,9 @@ typedef struct stlbrd {
 	unsigned long	clk;
 	unsigned int	bnkpageaddr[STL_MAXBANKS];
 	unsigned int	bnkstataddr[STL_MAXBANKS];
-	stlpanel_t	*bnk2panel[STL_MAXBANKS];
-	stlpanel_t	*panels[STL_MAXPANELS];
-} stlbrd_t;
+	struct stlpanel	*bnk2panel[STL_MAXBANKS];
+	struct stlpanel	*panels[STL_MAXPANELS];
+};
 
 
 /*
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
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

