From: akpm@osdl.org
Subject: - tty-switch-to-ktermios.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:23 -0800
Message-ID: <200612082008.kB8K8N94002603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946295AbWLHUJo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, blaisorblade@yahoo.it, cornelia.huck@de.ibm.com, hugh@veritas.com, jdike@addtoit.com, mp3@de.ibm.com, oberpar@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tty: switch to ktermios
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: switch to ktermios
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is the grungy swap all the occurrences in the right places patch that
goes with the updates.  At this point we have the same functionality as
before (except that sgttyb() returns speeds not zero) and are ready to
begin turning new stuff on providing nobody reports lots of bugs

If you are a tty driver author converting an out of tree driver the only
impact should be termios->ktermios name changes for the speed/property
setting functions from your upper layers.

If you are implementing your own TCGETS function before then your driver
was broken already and its about to get a whole lot more painful for you so
please fix it 8)

Also fill in c_ispeed/ospeed on init for most devices, although the current
code will do this for you anyway but I'd like eventually to lose that extra
paranoia

[akpm@osdl.org: bluetooth fix]
[mp3@de.ibm.com: sclp fix]
[mp3@de.ibm.com: warning fix for tty3270]
[hugh@veritas.com: fix tty_ioctl powerpc build]
[jdike@addtoit.com: uml: fix ->set_termios declaration]
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Acked-by: Peter Oberparleiter <oberpar@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/line.c                |    2 +-
 arch/um/include/line.h                |    2 +-
 drivers/char/amiserial.c              |    6 +++---
 drivers/char/cyclades.c               |    2 +-
 drivers/char/epca.c                   |   16 +++++++++++-----
 drivers/char/esp.c                    |    2 +-
 drivers/char/generic_serial.c         |    4 ++--
 drivers/char/hvcs.c                   |    6 ++++--
 drivers/char/hvsi.c                   |    2 ++
 drivers/char/ip2/ip2main.c            |   10 +++++-----
 drivers/char/isicom.c                 |    2 +-
 drivers/char/istallion.c              |   14 ++++++++------
 drivers/char/moxa.c                   |   18 ++++++++++--------
 drivers/char/mxser.c                  |   18 ++++++++++--------
 drivers/char/mxser_new.c              |    8 ++++----
 drivers/char/n_r3964.c                |    4 ++--
 drivers/char/n_tty.c                  |    2 +-
 drivers/char/pcmcia/synclink_cs.c     |    2 +-
 drivers/char/pty.c                    |   10 +++++++++-
 drivers/char/riscom8.c                |    4 +++-
 drivers/char/rocket.c                 |    8 +++++---
 drivers/char/ser_a2232.c              |    2 ++
 drivers/char/serial167.c              |    2 +-
 drivers/char/specialix.c              |    9 +++++++--
 drivers/char/stallion.c               |   20 +++++++++++---------
 drivers/char/sx.c                     |    2 ++
 drivers/char/synclink.c               |    4 +++-
 drivers/char/synclink_gt.c            |    6 ++++--
 drivers/char/synclinkmp.c             |    6 ++++--
 drivers/char/tty_ioctl.c              |    4 ++--
 drivers/char/vme_scc.c                |    2 ++
 drivers/isdn/capi/capi.c              |    2 +-
 drivers/isdn/gigaset/interface.c      |    4 ++--
 drivers/isdn/i4l/isdn_tty.c           |    2 +-
 drivers/net/irda/irtty-sir.c          |    4 ++--
 drivers/s390/char/sclp_tty.c          |    2 --
 drivers/s390/char/tty3270.c           |    2 +-
 drivers/serial/21285.c                |    4 ++--
 drivers/serial/68328serial.c          |    2 +-
 drivers/serial/68360serial.c          |    2 +-
 drivers/serial/8250.c                 |    4 ++--
 drivers/serial/amba-pl010.c           |    4 ++--
 drivers/serial/amba-pl011.c           |    4 ++--
 drivers/serial/atmel_serial.c         |    2 +-
 drivers/serial/clps711x.c             |    4 ++--
 drivers/serial/crisv10.c              |    8 +++++---
 drivers/serial/crisv10.h              |    4 ++--
 drivers/serial/dz.c                   |    4 ++--
 drivers/serial/icom.c                 |    4 ++--
 drivers/serial/imx.c                  |    4 ++--
 drivers/serial/ioc3_serial.c          |    4 ++--
 drivers/serial/ioc4_serial.c          |    6 +++---
 drivers/serial/ip22zilog.c            |    4 ++--
 drivers/serial/jsm/jsm_tty.c          |   10 +++++-----
 drivers/serial/m32r_sio.c             |    2 +-
 drivers/serial/mcfserial.c            |    2 +-
 drivers/serial/mpc52xx_uart.c         |    4 ++--
 drivers/serial/mpsc.c                 |    4 ++--
 drivers/serial/mux.c                  |    4 ++--
 drivers/serial/netx-serial.c          |    4 ++--
 drivers/serial/pmac_zilog.c           |   10 +++++-----
 drivers/serial/pmac_zilog.h           |    2 +-
 drivers/serial/pxa.c                  |    4 ++--
 drivers/serial/s3c2410.c              |    4 ++--
 drivers/serial/sa1100.c               |    4 ++--
 drivers/serial/serial_core.c          |   21 +++++++++++----------
 drivers/serial/serial_lh7a40x.c       |    4 ++--
 drivers/serial/serial_txx9.c          |    4 ++--
 drivers/serial/sh-sci.c               |    4 ++--
 drivers/serial/sn_console.c           |    4 ++--
 drivers/serial/sunhv.c                |    4 ++--
 drivers/serial/sunsab.c               |    4 ++--
 drivers/serial/sunsu.c                |    4 ++--
 drivers/serial/sunzilog.c             |    4 ++--
 drivers/serial/uartlite.c             |    4 ++--
 drivers/serial/v850e_uart.c           |    4 ++--
 drivers/serial/vr41xx_siu.c           |    4 ++--
 drivers/tc/zs.c                       |    2 +-
 drivers/usb/class/cdc-acm.c           |    4 ++--
 drivers/usb/gadget/serial.c           |    4 ++--
 drivers/usb/serial/ark3116.c          |    4 ++--
 drivers/usb/serial/belkin_sa.c        |    4 ++--
 drivers/usb/serial/console.c          |    2 +-
 drivers/usb/serial/cp2101.c           |    4 ++--
 drivers/usb/serial/cypress_m8.c       |   10 +++++-----
 drivers/usb/serial/digi_acceleport.c  |    6 +++---
 drivers/usb/serial/empeg.c            |    4 ++--
 drivers/usb/serial/ftdi_sio.c         |    4 ++--
 drivers/usb/serial/io_edgeport.c      |    8 ++++----
 drivers/usb/serial/io_ti.c            |    6 +++---
 drivers/usb/serial/ir-usb.c           |    4 ++--
 drivers/usb/serial/keyspan.c          |    2 +-
 drivers/usb/serial/keyspan.h          |    2 +-
 drivers/usb/serial/keyspan_pda.c      |    2 +-
 drivers/usb/serial/kl5kusb105.c       |    6 +++---
 drivers/usb/serial/kobil_sct.c        |   10 +++++-----
 drivers/usb/serial/mct_u232.c         |    4 ++--
 drivers/usb/serial/mos7720.c          |    4 ++--
 drivers/usb/serial/mos7840.c          |    4 ++--
 drivers/usb/serial/option.c           |    4 ++--
 drivers/usb/serial/pl2303.c           |    4 ++--
 drivers/usb/serial/sierra.c           |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c |    4 ++--
 drivers/usb/serial/usb-serial.c       |    2 +-
 drivers/usb/serial/visor.c            |    4 ++--
 drivers/usb/serial/whiteheat.c        |    6 +++---
 include/asm-generic/termios.h         |    4 ++--
 include/asm-powerpc/termbits.h        |    2 +-
 include/linux/generic_serial.h        |    2 +-
 include/linux/isdn.h                  |    8 ++++----
 include/linux/serial_core.h           |    8 ++++----
 include/linux/usb/serial.h            |    2 +-
 net/bluetooth/rfcomm/tty.c            |    4 ++--
 113 files changed, 301 insertions(+), 253 deletions(-)

diff -puN arch/um/drivers/line.c~tty-switch-to-ktermios arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~tty-switch-to-ktermios
+++ a/arch/um/drivers/line.c
@@ -246,7 +246,7 @@ out_up:
 	return ret;
 }
 
-void line_set_termios(struct tty_struct *tty, struct termios * old)
+void line_set_termios(struct tty_struct *tty, struct ktermios * old)
 {
 	/* nothing */
 }
diff -puN arch/um/include/line.h~tty-switch-to-ktermios arch/um/include/line.h
--- a/arch/um/include/line.h~tty-switch-to-ktermios
+++ a/arch/um/include/line.h
@@ -76,7 +76,7 @@ extern int line_setup(struct line *lines
 extern int line_write(struct tty_struct *tty, const unsigned char *buf,
 		      int len);
 extern void line_put_char(struct tty_struct *tty, unsigned char ch);
-extern void line_set_termios(struct tty_struct *tty, struct termios * old);
+extern void line_set_termios(struct tty_struct *tty, struct ktermios * old);
 extern int line_chars_in_buffer(struct tty_struct *tty);
 extern void line_flush_buffer(struct tty_struct *tty);
 extern void line_flush_chars(struct tty_struct *tty);
diff -puN drivers/char/amiserial.c~tty-switch-to-ktermios drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~tty-switch-to-ktermios
+++ a/drivers/char/amiserial.c
@@ -104,7 +104,7 @@ static struct async_struct *IRQ_ports;
 
 static unsigned char current_ctl_bits;
 
-static void change_speed(struct async_struct *info, struct termios *old);
+static void change_speed(struct async_struct *info, struct ktermios *old);
 static void rs_wait_until_sent(struct tty_struct *tty, int timeout);
 
 
@@ -694,7 +694,7 @@ static void shutdown(struct async_struct
  * the specified baud rate for a serial port.
  */
 static void change_speed(struct async_struct *info,
-			 struct termios *old_termios)
+			 struct ktermios *old_termios)
 {
 	int	quot = 0, baud_base, baud;
 	unsigned cflag, cval = 0;
@@ -1365,7 +1365,7 @@ static int rs_ioctl(struct tty_struct *t
 	return 0;
 }
 
-static void rs_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct async_struct *info = (struct async_struct *)tty->driver_data;
 	unsigned long flags;
diff -puN drivers/char/cyclades.c~tty-switch-to-ktermios drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~tty-switch-to-ktermios
+++ a/drivers/char/cyclades.c
@@ -4101,7 +4101,7 @@ cy_ioctl(struct tty_struct *tty, struct 
  * where old == NULL, and try to do something rational.
  */
 static void
-cy_set_termios(struct tty_struct *tty, struct termios * old_termios)
+cy_set_termios(struct tty_struct *tty, struct ktermios * old_termios)
 {
   struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
 
diff -puN drivers/char/epca.c~tty-switch-to-ktermios drivers/char/epca.c
--- a/drivers/char/epca.c~tty-switch-to-ktermios
+++ a/drivers/char/epca.c
@@ -199,7 +199,7 @@ static int pc_ioctl(struct tty_struct *,
                     unsigned int, unsigned long);
 static int info_ioctl(struct tty_struct *, struct file *,
                     unsigned int, unsigned long);
-static void pc_set_termios(struct tty_struct *, struct termios *);
+static void pc_set_termios(struct tty_struct *, struct ktermios *);
 static void do_softint(struct work_struct *work);
 static void pc_stop(struct tty_struct *);
 static void pc_start(struct tty_struct *);
@@ -1236,6 +1236,8 @@ static int __init pc_init(void)
 	pc_driver->init_termios.c_oflag = 0;
 	pc_driver->init_termios.c_cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 	pc_driver->init_termios.c_lflag = 0;
+	pc_driver->init_termios.c_ispeed = 9600;
+	pc_driver->init_termios.c_ospeed = 9600;
 	pc_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(pc_driver, &pc_ops);
 
@@ -1250,6 +1252,8 @@ static int __init pc_init(void)
 	pc_info->init_termios.c_oflag = 0;
 	pc_info->init_termios.c_lflag = 0;
 	pc_info->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL;
+	pc_info->init_termios.c_ispeed = 9600;
+	pc_info->init_termios.c_ospeed = 9600;
 	pc_info->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(pc_info, &info_ops);
 
@@ -1999,7 +2003,7 @@ static void epcaparam(struct tty_struct 
 { /* Begin epcaparam */
 
 	unsigned int cmdHead;
-	struct termios *ts;
+	struct ktermios *ts;
 	struct board_chan __iomem *bc;
 	unsigned mval, hflow, cflag, iflag;
 
@@ -2114,7 +2118,7 @@ static void receive_data(struct channel 
 { /* Begin receive_data */
 
 	unchar *rptr;
-	struct termios *ts = NULL;
+	struct ktermios *ts = NULL;
 	struct tty_struct *tty;
 	struct board_chan __iomem *bc;
 	int dataToRead, wrapgap, bytesAvailable;
@@ -2362,12 +2366,14 @@ static int pc_ioctl(struct tty_struct *t
 	switch (cmd) 
 	{ /* Begin switch cmd */
 
+#if 0	/* Handled by calling layer properly */
 		case TCGETS:
-			if (copy_to_user(argp, tty->termios, sizeof(struct termios)))
+			if (copy_to_user(argp, tty->termios, sizeof(struct ktermios)))
 				return -EFAULT;
 			return 0;
 		case TCGETA:
 			return get_termio(tty, argp);
+#endif
 		case TCSBRK:	/* SVID version: non-zero arg --> no break */
 			retval = tty_check_change(tty);
 			if (retval)
@@ -2536,7 +2542,7 @@ static int pc_ioctl(struct tty_struct *t
 
 /* --------------------- Begin pc_set_termios  ----------------------- */
 
-static void pc_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void pc_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 { /* Begin pc_set_termios */
 
 	struct channel *ch;
diff -puN drivers/char/esp.c~tty-switch-to-ktermios drivers/char/esp.c
--- a/drivers/char/esp.c~tty-switch-to-ktermios
+++ a/drivers/char/esp.c
@@ -1915,7 +1915,7 @@ static int rs_ioctl(struct tty_struct *t
 	return 0;
 }
 
-static void rs_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
 	unsigned long flags;
diff -puN drivers/char/generic_serial.c~tty-switch-to-ktermios drivers/char/generic_serial.c
--- a/drivers/char/generic_serial.c~tty-switch-to-ktermios
+++ a/drivers/char/generic_serial.c
@@ -718,11 +718,11 @@ static unsigned int     gs_baudrates[] =
 
 
 void gs_set_termios (struct tty_struct * tty, 
-                     struct termios * old_termios)
+                     struct ktermios * old_termios)
 {
 	struct gs_port *port;
 	int baudrate, tmp, rv;
-	struct termios *tiosp;
+	struct ktermios *tiosp;
 
 	func_enter();
 
diff -puN drivers/char/hvcs.c~tty-switch-to-ktermios drivers/char/hvcs.c
--- a/drivers/char/hvcs.c~tty-switch-to-ktermios
+++ a/drivers/char/hvcs.c
@@ -192,11 +192,13 @@ MODULE_VERSION(HVCS_DRIVER_VERSION);
  * that will cause echoing or we'll go into recursive loop echoing chars back
  * and forth with the console drivers.
  */
-static struct termios hvcs_tty_termios = {
+static struct ktermios hvcs_tty_termios = {
 	.c_iflag = IGNBRK | IGNPAR,
 	.c_oflag = OPOST,
 	.c_cflag = B38400 | CS8 | CREAD | HUPCL,
-	.c_cc = INIT_C_CC
+	.c_cc = INIT_C_CC,
+	.c_ispeed = 38400,
+	.c_ospeed = 38400
 };
 
 /*
diff -puN drivers/char/hvsi.c~tty-switch-to-ktermios drivers/char/hvsi.c
--- a/drivers/char/hvsi.c~tty-switch-to-ktermios
+++ a/drivers/char/hvsi.c
@@ -1161,6 +1161,8 @@ static int __init hvsi_init(void)
 	hvsi_driver->type = TTY_DRIVER_TYPE_SYSTEM;
 	hvsi_driver->init_termios = tty_std_termios;
 	hvsi_driver->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL;
+	hvsi_driver->init_termios.c_ispeed = 9600;
+	hvsi_driver->init_termios.c_ospeed = 9600;
 	hvsi_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(hvsi_driver, &hvsi_ops);
 
diff -puN drivers/char/ip2/ip2main.c~tty-switch-to-ktermios drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~tty-switch-to-ktermios
+++ a/drivers/char/ip2/ip2main.c
@@ -177,7 +177,7 @@ static int  ip2_write_room(PTTY);
 static int  ip2_chars_in_buf(PTTY);
 static void ip2_flush_buffer(PTTY);
 static int  ip2_ioctl(PTTY, struct file *, UINT, ULONG);
-static void ip2_set_termios(PTTY, struct termios *);
+static void ip2_set_termios(PTTY, struct ktermios *);
 static void ip2_set_line_discipline(PTTY);
 static void ip2_throttle(PTTY);
 static void ip2_unthrottle(PTTY);
@@ -198,7 +198,7 @@ static void do_status(struct work_struct
 
 static void ip2_wait_until_sent(PTTY,int);
 
-static void set_params (i2ChanStrPtr, struct termios *);
+static void set_params (i2ChanStrPtr, struct ktermios *);
 static int get_serial_info(i2ChanStrPtr, struct serial_struct __user *);
 static int set_serial_info(i2ChanStrPtr, struct serial_struct __user *);
 
@@ -2398,7 +2398,7 @@ set_serial_info( i2ChanStrPtr pCh, struc
 /*                                                                            */
 /******************************************************************************/
 static void
-ip2_set_termios( PTTY tty, struct termios *old_termios )
+ip2_set_termios( PTTY tty, struct ktermios *old_termios )
 {
 	i2ChanStrPtr pCh = (i2ChanStrPtr)tty->driver_data;
 
@@ -2440,11 +2440,11 @@ ip2_set_line_discipline ( PTTY tty )
 /* change.                                                                    */
 /******************************************************************************/
 static void
-set_params( i2ChanStrPtr pCh, struct termios *o_tios )
+set_params( i2ChanStrPtr pCh, struct ktermios *o_tios )
 {
 	tcflag_t cflag, iflag, lflag;
 	char stop_char, start_char;
-	struct termios dummy;
+	struct ktermios dummy;
 
 	lflag = pCh->pTTY->termios->c_lflag;
 	cflag = pCh->pTTY->termios->c_cflag;
diff -puN drivers/char/isicom.c~tty-switch-to-ktermios drivers/char/isicom.c
--- a/drivers/char/isicom.c~tty-switch-to-ktermios
+++ a/drivers/char/isicom.c
@@ -1399,7 +1399,7 @@ static int isicom_ioctl(struct tty_struc
 
 /* set_termios et all */
 static void isicom_set_termios(struct tty_struct *tty,
-	struct termios *old_termios)
+	struct ktermios *old_termios)
 {
 	struct isi_port *port = tty->driver_data;
 
diff -puN drivers/char/istallion.c~tty-switch-to-ktermios drivers/char/istallion.c
--- a/drivers/char/istallion.c~tty-switch-to-ktermios
+++ a/drivers/char/istallion.c
@@ -194,9 +194,11 @@ static struct tty_struct	*stli_txcooktty
  *	with this termios initially. Basically all it defines is a raw port
  *	at 9600 baud, 8 data bits, no parity, 1 stop bit.
  */
-static struct termios		stli_deftermios = {
+static struct ktermios		stli_deftermios = {
 	.c_cflag	= (B9600 | CS8 | CREAD | HUPCL | CLOCAL),
 	.c_cc		= INIT_C_CC,
+	.c_ispeed	= 9600,
+	.c_ospeed	= 9600,
 };
 
 /*
@@ -639,7 +641,7 @@ static void	stli_flushchars(struct tty_s
 static int	stli_writeroom(struct tty_struct *tty);
 static int	stli_charsinbuffer(struct tty_struct *tty);
 static int	stli_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
-static void	stli_settermios(struct tty_struct *tty, struct termios *old);
+static void	stli_settermios(struct tty_struct *tty, struct ktermios *old);
 static void	stli_throttle(struct tty_struct *tty);
 static void	stli_unthrottle(struct tty_struct *tty);
 static void	stli_stop(struct tty_struct *tty);
@@ -669,7 +671,7 @@ static int	stli_cmdwait(stlibrd_t *brdp,
 static void	stli_sendcmd(stlibrd_t *brdp, stliport_t *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	__stli_sendcmd(stlibrd_t *brdp, stliport_t *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	stli_dodelaycmd(stliport_t *portp, cdkctrl_t __iomem *cp);
-static void	stli_mkasyport(stliport_t *portp, asyport_t *pp, struct termios *tiosp);
+static void	stli_mkasyport(stliport_t *portp, asyport_t *pp, struct ktermios *tiosp);
 static void	stli_mkasysigs(asysigs_t *sp, int dtr, int rts);
 static long	stli_mktiocm(unsigned long sigvalue);
 static void	stli_read(stlibrd_t *brdp, stliport_t *portp);
@@ -1889,11 +1891,11 @@ static int stli_ioctl(struct tty_struct 
  *	Looks like it is true for the current ttys implementation..!!
  */
 
-static void stli_settermios(struct tty_struct *tty, struct termios *old)
+static void stli_settermios(struct tty_struct *tty, struct ktermios *old)
 {
 	stliport_t *portp;
 	stlibrd_t *brdp;
-	struct termios *tiosp;
+	struct ktermios *tiosp;
 	asyport_t aport;
 
 	if (tty == NULL)
@@ -2730,7 +2732,7 @@ static void stli_poll(unsigned long arg)
  *	the slave.
  */
 
-static void stli_mkasyport(stliport_t *portp, asyport_t *pp, struct termios *tiosp)
+static void stli_mkasyport(stliport_t *portp, asyport_t *pp, struct ktermios *tiosp)
 {
 	memset(pp, 0, sizeof(asyport_t));
 
diff -puN drivers/char/moxa.c~tty-switch-to-ktermios drivers/char/moxa.c
--- a/drivers/char/moxa.c~tty-switch-to-ktermios
+++ a/drivers/char/moxa.c
@@ -234,7 +234,7 @@ static void moxa_put_char(struct tty_str
 static int moxa_ioctl(struct tty_struct *, struct file *, unsigned int, unsigned long);
 static void moxa_throttle(struct tty_struct *);
 static void moxa_unthrottle(struct tty_struct *);
-static void moxa_set_termios(struct tty_struct *, struct termios *);
+static void moxa_set_termios(struct tty_struct *, struct ktermios *);
 static void moxa_stop(struct tty_struct *);
 static void moxa_start(struct tty_struct *);
 static void moxa_hangup(struct tty_struct *);
@@ -261,7 +261,7 @@ static void MoxaPortEnable(int);
 static void MoxaPortDisable(int);
 static long MoxaPortGetMaxBaud(int);
 static long MoxaPortSetBaud(int, long);
-static int MoxaPortSetTermio(int, struct termios *, speed_t);
+static int MoxaPortSetTermio(int, struct ktermios *, speed_t);
 static int MoxaPortGetLineOut(int, int *, int *);
 static void MoxaPortLineCtrl(int, int, int);
 static void MoxaPortFlowCtrl(int, int, int, int, int, int);
@@ -355,6 +355,8 @@ static int __init moxa_init(void)
 	moxaDriver->init_termios.c_oflag = 0;
 	moxaDriver->init_termios.c_cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 	moxaDriver->init_termios.c_lflag = 0;
+	moxaDriver->init_termios.c_ispeed = 9600;
+	moxaDriver->init_termios.c_ospeed = 9600;
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
 
@@ -864,7 +866,7 @@ static void moxa_unthrottle(struct tty_s
 }
 
 static void moxa_set_termios(struct tty_struct *tty,
-			     struct termios *old_termios)
+			     struct ktermios *old_termios)
 {
 	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
 
@@ -978,7 +980,7 @@ static void moxa_poll(unsigned long igno
 
 static void set_tty_param(struct tty_struct *tty)
 {
-	register struct termios *ts;
+	register struct ktermios *ts;
 	struct moxa_str *ch;
 	int rts, cts, txflow, rxflow, xany;
 
@@ -1149,7 +1151,7 @@ static void shut_down(struct moxa_str *c
 static void receive_data(struct moxa_str *ch)
 {
 	struct tty_struct *tp;
-	struct termios *ts;
+	struct ktermios *ts;
 	unsigned long flags;
 
 	ts = NULL;
@@ -1912,9 +1914,9 @@ int MoxaPortsOfCard(int cardno)
  *
  *      Function 12:    Configure the port.
  *      Syntax:
- *      int  MoxaPortSetTermio(int port, struct termios *termio, speed_t baud);
+ *      int  MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud);
  *           int port           : port number (0 - 127)
- *           struct termios * termio : termio structure pointer
+ *           struct ktermios * termio : termio structure pointer
  *	     speed_t baud	: baud rate
  *
  *           return:    -1      : this port is invalid or termio == NULL
@@ -2195,7 +2197,7 @@ long MoxaPortSetBaud(int port, long baud
 	return (baud);
 }
 
-int MoxaPortSetTermio(int port, struct termios *termio, speed_t baud)
+int MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud)
 {
 	void __iomem *ofsAddr;
 	tcflag_t cflag;
diff -puN drivers/char/mxser.c~tty-switch-to-ktermios drivers/char/mxser.c
--- a/drivers/char/mxser.c~tty-switch-to-ktermios
+++ a/drivers/char/mxser.c
@@ -328,8 +328,8 @@ struct mxser_struct {
 	int xmit_tail;
 	int xmit_cnt;
 	struct work_struct tqueue;
-	struct termios normal_termios;
-	struct termios callout_termios;
+	struct ktermios normal_termios;
+	struct ktermios callout_termios;
 	wait_queue_head_t open_wait;
 	wait_queue_head_t close_wait;
 	wait_queue_head_t delta_msr_wait;
@@ -364,8 +364,8 @@ static int mxserBoardCAP[MXSER_BOARDS] =
 static struct tty_driver *mxvar_sdriver;
 static struct mxser_struct mxvar_table[MXSER_PORTS];
 static struct tty_struct *mxvar_tty[MXSER_PORTS + 1];
-static struct termios *mxvar_termios[MXSER_PORTS + 1];
-static struct termios *mxvar_termios_locked[MXSER_PORTS + 1];
+static struct ktermios *mxvar_termios[MXSER_PORTS + 1];
+static struct ktermios *mxvar_termios_locked[MXSER_PORTS + 1];
 static struct mxser_log mxvar_log;
 static int mxvar_diagflag;
 static unsigned char mxser_msr[MXSER_PORTS + 1];
@@ -402,7 +402,7 @@ static int mxser_ioctl(struct tty_struct
 static int mxser_ioctl_special(unsigned int, void __user *);
 static void mxser_throttle(struct tty_struct *);
 static void mxser_unthrottle(struct tty_struct *);
-static void mxser_set_termios(struct tty_struct *, struct termios *);
+static void mxser_set_termios(struct tty_struct *, struct ktermios *);
 static void mxser_stop(struct tty_struct *);
 static void mxser_start(struct tty_struct *);
 static void mxser_hangup(struct tty_struct *);
@@ -414,7 +414,7 @@ static void mxser_check_modem_status(str
 static int mxser_block_til_ready(struct tty_struct *, struct file *, struct mxser_struct *);
 static int mxser_startup(struct mxser_struct *);
 static void mxser_shutdown(struct mxser_struct *);
-static int mxser_change_speed(struct mxser_struct *, struct termios *old_termios);
+static int mxser_change_speed(struct mxser_struct *, struct ktermios *old_termios);
 static int mxser_get_serial_info(struct mxser_struct *, struct serial_struct __user *);
 static int mxser_set_serial_info(struct mxser_struct *, struct serial_struct __user *);
 static int mxser_get_lsr_info(struct mxser_struct *, unsigned int __user *);
@@ -726,6 +726,8 @@ static int mxser_init(void)
 	mxvar_sdriver->subtype = SERIAL_TYPE_NORMAL;
 	mxvar_sdriver->init_termios = tty_std_termios;
 	mxvar_sdriver->init_termios.c_cflag = B9600|CS8|CREAD|HUPCL|CLOCAL;
+	mxvar_sdriver->init_termios.c_ispeed = 9600;
+	mxvar_sdriver->init_termios.c_ospeed = 9600;
 	mxvar_sdriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(mxvar_sdriver, &mxser_ops);
 	mxvar_sdriver->ttys = mxvar_tty;
@@ -1749,7 +1751,7 @@ static void mxser_unthrottle(struct tty_
 	/* MX_UNLOCK(&info->slock); */
 }
 
-static void mxser_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct mxser_struct *info = tty->driver_data;
 	unsigned long flags;
@@ -2541,7 +2543,7 @@ static void mxser_shutdown(struct mxser_
  * This routine is called to set the UART divisor registers to match
  * the specified baud rate for a serial port.
  */
-static int mxser_change_speed(struct mxser_struct *info, struct termios *old_termios)
+static int mxser_change_speed(struct mxser_struct *info, struct ktermios *old_termios)
 {
 	unsigned cflag, cval, fcr;
 	int ret = 0;
diff -puN drivers/char/mxser_new.c~tty-switch-to-ktermios drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~tty-switch-to-ktermios
+++ a/drivers/char/mxser_new.c
@@ -266,8 +266,8 @@ struct mxser_port {
 	int xmit_tail;
 	int xmit_cnt;
 
-	struct termios normal_termios;
-	struct termios callout_termios;
+	struct ktermios normal_termios;
+	struct ktermios callout_termios;
 
 	struct mxser_mon mon_data;
 
@@ -512,7 +512,7 @@ static int mxser_set_baud(struct mxser_p
  * the specified baud rate for a serial port.
  */
 static int mxser_change_speed(struct mxser_port *info,
-		struct termios *old_termios)
+		struct ktermios *old_termios)
 {
 	unsigned cflag, cval, fcr;
 	int ret = 0;
@@ -1966,7 +1966,7 @@ static void mxser_start(struct tty_struc
 	spin_unlock_irqrestore(&info->slock, flags);
 }
 
-static void mxser_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
diff -puN drivers/char/n_r3964.c~tty-switch-to-ktermios drivers/char/n_r3964.c
--- a/drivers/char/n_r3964.c~tty-switch-to-ktermios
+++ a/drivers/char/n_r3964.c
@@ -142,7 +142,7 @@ static ssize_t r3964_write(struct tty_st
                       const unsigned char * buf, size_t nr);
 static int r3964_ioctl(struct tty_struct * tty, struct file * file,
                        unsigned int cmd, unsigned long arg);
-static void r3964_set_termios(struct tty_struct *tty, struct termios * old);
+static void r3964_set_termios(struct tty_struct *tty, struct ktermios * old);
 static unsigned int r3964_poll(struct tty_struct * tty, struct file * file,
 		      struct poll_table_struct  *wait);
 static void r3964_receive_buf(struct tty_struct *tty, const unsigned char *cp,
@@ -1347,7 +1347,7 @@ static int r3964_ioctl(struct tty_struct
    }
 }
 
-static void r3964_set_termios(struct tty_struct *tty, struct termios * old)
+static void r3964_set_termios(struct tty_struct *tty, struct ktermios * old)
 {
    TRACE_L("set_termios");
 }
diff -puN drivers/char/n_tty.c~tty-switch-to-ktermios drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-switch-to-ktermios
+++ a/drivers/char/n_tty.c
@@ -994,7 +994,7 @@ int is_ignored(int sig)
  *	when the ldisc is closed.
  */
  
-static void n_tty_set_termios(struct tty_struct *tty, struct termios * old)
+static void n_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
 {
 	if (!tty)
 		return;
diff -puN drivers/char/pcmcia/synclink_cs.c~tty-switch-to-ktermios drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~tty-switch-to-ktermios
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -2375,7 +2375,7 @@ static int ioctl_common(MGSLPC_INFO *inf
  * 	tty		pointer to tty structure
  * 	termios		pointer to buffer to hold returned old termios
  */
-static void mgslpc_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
diff -puN drivers/char/pty.c~tty-switch-to-ktermios drivers/char/pty.c
--- a/drivers/char/pty.c~tty-switch-to-ktermios
+++ a/drivers/char/pty.c
@@ -218,7 +218,7 @@ out:
 	return retval;
 }
 
-static void pty_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void pty_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
         tty->termios->c_cflag &= ~(CSIZE | PARENB);
         tty->termios->c_cflag |= (CS8 | CREAD);
@@ -272,6 +272,8 @@ static void __init legacy_pty_init(void)
 	pty_driver->init_termios.c_oflag = 0;
 	pty_driver->init_termios.c_cflag = B38400 | CS8 | CREAD;
 	pty_driver->init_termios.c_lflag = 0;
+	pty_driver->init_termios.c_ispeed = 38400;
+	pty_driver->init_termios.c_ospeed = 38400;
 	pty_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW;
 	pty_driver->other = pty_slave_driver;
 	tty_set_operations(pty_driver, &pty_ops);
@@ -286,6 +288,8 @@ static void __init legacy_pty_init(void)
 	pty_slave_driver->subtype = PTY_TYPE_SLAVE;
 	pty_slave_driver->init_termios = tty_std_termios;
 	pty_slave_driver->init_termios.c_cflag = B38400 | CS8 | CREAD;
+	pty_slave_driver->init_termios.c_ispeed = 38400;
+	pty_slave_driver->init_termios.c_ospeed = 38400;
 	pty_slave_driver->flags = TTY_DRIVER_RESET_TERMIOS |
 					TTY_DRIVER_REAL_RAW;
 	pty_slave_driver->other = pty_driver;
@@ -366,6 +370,8 @@ static void __init unix98_pty_init(void)
 	ptm_driver->init_termios.c_oflag = 0;
 	ptm_driver->init_termios.c_cflag = B38400 | CS8 | CREAD;
 	ptm_driver->init_termios.c_lflag = 0;
+	ptm_driver->init_termios.c_ispeed = 38400;
+	ptm_driver->init_termios.c_ospeed = 38400;
 	ptm_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	ptm_driver->other = pts_driver;
@@ -381,6 +387,8 @@ static void __init unix98_pty_init(void)
 	pts_driver->subtype = PTY_TYPE_SLAVE;
 	pts_driver->init_termios = tty_std_termios;
 	pts_driver->init_termios.c_cflag = B38400 | CS8 | CREAD;
+	pts_driver->init_termios.c_ispeed = 38400;
+	pts_driver->init_termios.c_ospeed = 38400;
 	pts_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	pts_driver->other = ptm_driver;
diff -puN drivers/char/riscom8.c~tty-switch-to-ktermios drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~tty-switch-to-ktermios
+++ a/drivers/char/riscom8.c
@@ -1539,7 +1539,7 @@ static void rc_hangup(struct tty_struct 
 	wake_up_interruptible(&port->open_wait);
 }
 
-static void rc_set_termios(struct tty_struct * tty, struct termios * old_termios)
+static void rc_set_termios(struct tty_struct * tty, struct ktermios * old_termios)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	unsigned long flags;
@@ -1614,6 +1614,8 @@ static inline int rc_init_drivers(void)
 	riscom_driver->init_termios = tty_std_termios;
 	riscom_driver->init_termios.c_cflag =
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	riscom_driver->init_termios.c_ispeed = 9600;
+	riscom_driver->init_termios.c_ospeed = 9600;
 	riscom_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(riscom_driver, &riscom_ops);
 	if ((error = tty_register_driver(riscom_driver)))  {
diff -puN drivers/char/rocket.c~tty-switch-to-ktermios drivers/char/rocket.c
--- a/drivers/char/rocket.c~tty-switch-to-ktermios
+++ a/drivers/char/rocket.c
@@ -712,7 +712,7 @@ static void init_r_port(int board, int a
  *  user mode into the driver (exception handler).  *info CD manipulation is spinlock protected.
  */
 static void configure_r_port(struct r_port *info,
-			     struct termios *old_termios)
+			     struct ktermios *old_termios)
 {
 	unsigned cflag;
 	unsigned long flags;
@@ -1194,7 +1194,7 @@ static void rp_close(struct tty_struct *
 }
 
 static void rp_set_termios(struct tty_struct *tty,
-			   struct termios *old_termios)
+			   struct ktermios *old_termios)
 {
 	struct r_port *info = (struct r_port *) tty->driver_data;
 	CHANNEL_t *cp;
@@ -2214,7 +2214,7 @@ static int __init init_PCI(int boards_fo
 	int count = 0;
 
 	/*  Work through the PCI device list, pulling out ours */
-	while ((dev = pci_find_device(PCI_VENDOR_ID_RP, PCI_ANY_ID, dev))) {
+	while ((dev = pci_get_device(PCI_VENDOR_ID_RP, PCI_ANY_ID, dev))) {
 		if (register_PCI(count + boards_found, dev))
 			count++;
 	}
@@ -2436,6 +2436,8 @@ static int __init rp_init(void)
 	rocket_driver->init_termios = tty_std_termios;
 	rocket_driver->init_termios.c_cflag =
 	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	rocket_driver->init_termios.c_ispeed = 9600;
+	rocket_driver->init_termios.c_ospeed = 9600;
 #ifdef ROCKET_SOFT_FLOW
 	rocket_driver->flags |= TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 #endif
diff -puN drivers/char/ser_a2232.c~tty-switch-to-ktermios drivers/char/ser_a2232.c
--- a/drivers/char/ser_a2232.c~tty-switch-to-ktermios
+++ a/drivers/char/ser_a2232.c
@@ -695,6 +695,8 @@ static int a2232_init_drivers(void)
 	a2232_driver->init_termios = tty_std_termios;
 	a2232_driver->init_termios.c_cflag =
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	a2232_driver->init_termios.c_ispeed = 9600;
+	a2232_driver->init_termios.c_ospeed = 9600;
 	a2232_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(a2232_driver, &a2232_ops);
 	if ((error = tty_register_driver(a2232_driver))) {
diff -puN drivers/char/serial167.c~tty-switch-to-ktermios drivers/char/serial167.c
--- a/drivers/char/serial167.c~tty-switch-to-ktermios
+++ a/drivers/char/serial167.c
@@ -1695,7 +1695,7 @@ cy_ioctl(struct tty_struct *tty, struct 
 
 
 static void
-cy_set_termios(struct tty_struct *tty, struct termios * old_termios)
+cy_set_termios(struct tty_struct *tty, struct ktermios * old_termios)
 {
   struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
 
diff -puN drivers/char/specialix.c~tty-switch-to-ktermios drivers/char/specialix.c
--- a/drivers/char/specialix.c~tty-switch-to-ktermios
+++ a/drivers/char/specialix.c
@@ -2311,7 +2311,7 @@ static void sx_hangup(struct tty_struct 
 }
 
 
-static void sx_set_termios(struct tty_struct * tty, struct termios * old_termios)
+static void sx_set_termios(struct tty_struct * tty, struct ktermios * old_termios)
 {
 	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
 	unsigned long flags;
@@ -2400,6 +2400,8 @@ static int sx_init_drivers(void)
 	specialix_driver->init_termios = tty_std_termios;
 	specialix_driver->init_termios.c_cflag =
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	specialix_driver->init_termios.c_ispeed = 9600;
+	specialix_driver->init_termios.c_ospeed = 9600;
 	specialix_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(specialix_driver, &sx_ops);
 
@@ -2475,7 +2477,7 @@ static int __init specialix_init(void)
 				i++;
 				continue;
 			}
-			pdev = pci_find_device (PCI_VENDOR_ID_SPECIALIX,
+			pdev = pci_get_device (PCI_VENDOR_ID_SPECIALIX,
 			                        PCI_DEVICE_ID_SPECIALIX_IO8,
 			                        pdev);
 			if (!pdev) break;
@@ -2491,6 +2493,9 @@ static int __init specialix_init(void)
 			if (!sx_probe(&sx_board[i]))
 				found ++;
 		}
+		/* May exit pci_get sequence early with lots of boards */
+		if (pdev != NULL)
+			pci_dev_put(pdev);
 	}
 #endif
 
diff -puN drivers/char/stallion.c~tty-switch-to-ktermios drivers/char/stallion.c
--- a/drivers/char/stallion.c~tty-switch-to-ktermios
+++ a/drivers/char/stallion.c
@@ -141,9 +141,11 @@ static struct tty_driver	*stl_serial;
  *	with this termios initially. Basically all it defines is a raw port
  *	at 9600, 8 data bits, 1 stop bit.
  */
-static struct termios		stl_deftermios = {
+static struct ktermios		stl_deftermios = {
 	.c_cflag	= (B9600 | CS8 | CREAD | HUPCL | CLOCAL),
 	.c_cc		= INIT_C_CC,
+	.c_ispeed	= 9600,
+	.c_ospeed	= 9600,
 };
 
 /*
@@ -464,7 +466,7 @@ static int	stl_cd1400getreg(struct stlpo
 static int	stl_cd1400updatereg(struct stlport *portp, int regnr, int value);
 static int	stl_cd1400panelinit(struct stlbrd *brdp, struct stlpanel *panelp);
 static void	stl_cd1400portinit(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp);
-static void	stl_cd1400setport(struct stlport *portp, struct termios *tiosp);
+static void	stl_cd1400setport(struct stlport *portp, struct ktermios *tiosp);
 static int	stl_cd1400getsignals(struct stlport *portp);
 static void	stl_cd1400setsignals(struct stlport *portp, int dtr, int rts);
 static void	stl_cd1400ccrwait(struct stlport *portp);
@@ -493,7 +495,7 @@ static int	stl_sc26198updatereg(struct s
 static int	stl_sc26198getglobreg(struct stlport *portp, int regnr);
 static int	stl_sc26198panelinit(struct stlbrd *brdp, struct stlpanel *panelp);
 static void	stl_sc26198portinit(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp);
-static void	stl_sc26198setport(struct stlport *portp, struct termios *tiosp);
+static void	stl_sc26198setport(struct stlport *portp, struct ktermios *tiosp);
 static int	stl_sc26198getsignals(struct stlport *portp);
 static void	stl_sc26198setsignals(struct stlport *portp, int dtr, int rts);
 static void	stl_sc26198enablerxtx(struct stlport *portp, int rx, int tx);
@@ -521,7 +523,7 @@ static void	stl_sc26198otherisr(struct s
 typedef struct uart {
 	int	(*panelinit)(struct stlbrd *brdp, struct stlpanel *panelp);
 	void	(*portinit)(struct stlbrd *brdp, struct stlpanel *panelp, struct stlport *portp);
-	void	(*setport)(struct stlport *portp, struct termios *tiosp);
+	void	(*setport)(struct stlport *portp, struct ktermios *tiosp);
 	int	(*getsignals)(struct stlport *portp);
 	void	(*setsignals)(struct stlport *portp, int dtr, int rts);
 	void	(*enablerxtx)(struct stlport *portp, int rx, int tx);
@@ -1427,10 +1429,10 @@ static void stl_start(struct tty_struct 
 
 /*****************************************************************************/
 
-static void stl_settermios(struct tty_struct *tty, struct termios *old)
+static void stl_settermios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct stlport	*portp;
-	struct termios	*tiosp;
+	struct ktermios	*tiosp;
 
 	pr_debug("stl_settermios(tty=%p,old=%p)\n", tty, old);
 
@@ -2468,7 +2470,7 @@ static int __init stl_findpcibrds(void)
 	pr_debug("stl_findpcibrds()\n");
 
 	for (i = 0; (i < stl_nrpcibrds); i++)
-		while ((dev = pci_find_device(stl_pcibrds[i].vendid,
+		while ((dev = pci_get_device(stl_pcibrds[i].vendid,
 		    stl_pcibrds[i].devid, dev))) {
 
 /*
@@ -2947,7 +2949,7 @@ static void stl_cd1400ccrwait(struct stl
  *	settings.
  */
 
-static void stl_cd1400setport(struct stlport *portp, struct termios *tiosp)
+static void stl_cd1400setport(struct stlport *portp, struct ktermios *tiosp)
 {
 	struct stlbrd	*brdp;
 	unsigned long	flags;
@@ -3924,7 +3926,7 @@ static void stl_sc26198portinit(struct s
  *	settings.
  */
 
-static void stl_sc26198setport(struct stlport *portp, struct termios *tiosp)
+static void stl_sc26198setport(struct stlport *portp, struct ktermios *tiosp)
 {
 	struct stlbrd	*brdp;
 	unsigned long	flags;
diff -puN drivers/char/sx.c~tty-switch-to-ktermios drivers/char/sx.c
--- a/drivers/char/sx.c~tty-switch-to-ktermios
+++ a/drivers/char/sx.c
@@ -2263,6 +2263,8 @@ static int sx_init_drivers(void)
 	sx_driver->init_termios = tty_std_termios;
 	sx_driver->init_termios.c_cflag =
 	  B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	sx_driver->init_termios.c_ispeed = 9600;
+	sx_driver->init_termios.c_ospeed = 9600;
 	sx_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(sx_driver, &sx_ops);
 
diff -puN drivers/char/synclink.c~tty-switch-to-ktermios drivers/char/synclink.c
--- a/drivers/char/synclink.c~tty-switch-to-ktermios
+++ a/drivers/char/synclink.c
@@ -3060,7 +3060,7 @@ static int mgsl_ioctl_common(struct mgsl
  * 	
  * Return Value:		None
  */
-static void mgsl_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void mgsl_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct mgsl_struct *info = (struct mgsl_struct *)tty->driver_data;
 	unsigned long flags;
@@ -4405,6 +4405,8 @@ static int mgsl_init_tty(void)
 	serial_driver->init_termios = tty_std_termios;
 	serial_driver->init_termios.c_cflag =
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	serial_driver->init_termios.c_ispeed = 9600;
+	serial_driver->init_termios.c_ospeed = 9600;
 	serial_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(serial_driver, &mgsl_ops);
 	if ((rc = tty_register_driver(serial_driver)) < 0) {
diff -puN drivers/char/synclink_gt.c~tty-switch-to-ktermios drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~tty-switch-to-ktermios
+++ a/drivers/char/synclink_gt.c
@@ -151,7 +151,7 @@ static struct tty_driver *serial_driver;
 static int  open(struct tty_struct *tty, struct file * filp);
 static void close(struct tty_struct *tty, struct file * filp);
 static void hangup(struct tty_struct *tty);
-static void set_termios(struct tty_struct *tty, struct termios *old_termios);
+static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
 static void put_char(struct tty_struct *tty, unsigned char ch);
@@ -816,7 +816,7 @@ static void hangup(struct tty_struct *tt
 	wake_up_interruptible(&info->open_wait);
 }
 
-static void set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
@@ -3546,6 +3546,8 @@ static int __init slgt_init(void)
 	serial_driver->init_termios = tty_std_termios;
 	serial_driver->init_termios.c_cflag =
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	serial_driver->init_termios.c_ispeed = 9600;
+	serial_driver->init_termios.c_ospeed = 9600;
 	serial_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(serial_driver, &ops);
 	if ((rc = tty_register_driver(serial_driver)) < 0) {
diff -puN drivers/char/synclinkmp.c~tty-switch-to-ktermios drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~tty-switch-to-ktermios
+++ a/drivers/char/synclinkmp.c
@@ -519,7 +519,7 @@ static struct tty_driver *serial_driver;
 static int  open(struct tty_struct *tty, struct file * filp);
 static void close(struct tty_struct *tty, struct file * filp);
 static void hangup(struct tty_struct *tty);
-static void set_termios(struct tty_struct *tty, struct termios *old_termios);
+static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
 static void put_char(struct tty_struct *tty, unsigned char ch);
@@ -918,7 +918,7 @@ static void hangup(struct tty_struct *tt
 
 /* Set new termios settings
  */
-static void set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	SLMP_INFO *info = (SLMP_INFO *)tty->driver_data;
 	unsigned long flags;
@@ -4034,6 +4034,8 @@ static int __init synclinkmp_init(void)
 	serial_driver->init_termios = tty_std_termios;
 	serial_driver->init_termios.c_cflag =
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	serial_driver->init_termios.c_ispeed = 9600;
+	serial_driver->init_termios.c_ospeed = 9600;
 	serial_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(serial_driver, &ops);
 	if ((rc = tty_register_driver(serial_driver)) < 0) {
diff -puN drivers/char/tty_ioctl.c~tty-switch-to-ktermios drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-switch-to-ktermios
+++ a/drivers/char/tty_ioctl.c
@@ -495,8 +495,8 @@ static int get_sgttyb(struct tty_struct 
 	struct sgttyb tmp;
 
 	mutex_lock(&tty->termios_mutex);
-	tmp.sg_ispeed = tty->c_ispeed;
-	tmp.sg_ospeed = tty->c_ospeed;
+	tmp.sg_ispeed = tty->termios->c_ispeed;
+	tmp.sg_ospeed = tty->termios->c_ospeed;
 	tmp.sg_erase = tty->termios->c_cc[VERASE];
 	tmp.sg_kill = tty->termios->c_cc[VKILL];
 	tmp.sg_flags = get_sgflags(tty);
diff -puN drivers/char/vme_scc.c~tty-switch-to-ktermios drivers/char/vme_scc.c
--- a/drivers/char/vme_scc.c~tty-switch-to-ktermios
+++ a/drivers/char/vme_scc.c
@@ -153,6 +153,8 @@ static int scc_init_drivers(void)
 	scc_driver->init_termios = tty_std_termios;
 	scc_driver->init_termios.c_cflag =
 	  B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	scc_driver->init_termios.c_ispeed = 9600;
+	scc_driver->init_termios.c_ospeed = 9600;
 	scc_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(scc_driver, &scc_ops);
 
diff -puN drivers/isdn/capi/capi.c~tty-switch-to-ktermios drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~tty-switch-to-ktermios
+++ a/drivers/isdn/capi/capi.c
@@ -1203,7 +1203,7 @@ static int capinc_tty_ioctl(struct tty_s
 	return error;
 }
 
-static void capinc_tty_set_termios(struct tty_struct *tty, struct termios * old)
+static void capinc_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
 {
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_tty_set_termios\n");
diff -puN drivers/isdn/gigaset/interface.c~tty-switch-to-ktermios drivers/isdn/gigaset/interface.c
--- a/drivers/isdn/gigaset/interface.c~tty-switch-to-ktermios
+++ a/drivers/isdn/gigaset/interface.c
@@ -127,7 +127,7 @@ static int  if_write_room(struct tty_str
 static int  if_chars_in_buffer(struct tty_struct *tty);
 static void if_throttle(struct tty_struct *tty);
 static void if_unthrottle(struct tty_struct *tty);
-static void if_set_termios(struct tty_struct *tty, struct termios *old);
+static void if_set_termios(struct tty_struct *tty, struct ktermios *old);
 static int  if_tiocmget(struct tty_struct *tty, struct file *file);
 static int  if_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
@@ -490,7 +490,7 @@ static void if_unthrottle(struct tty_str
 	mutex_unlock(&cs->mutex);
 }
 
-static void if_set_termios(struct tty_struct *tty, struct termios *old)
+static void if_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct cardstate *cs;
 	unsigned int iflag;
diff -puN drivers/isdn/i4l/isdn_tty.c~tty-switch-to-ktermios drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~tty-switch-to-ktermios
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -1464,7 +1464,7 @@ isdn_tty_ioctl(struct tty_struct *tty, s
 }
 
 static void
-isdn_tty_set_termios(struct tty_struct *tty, struct termios *old_termios)
+isdn_tty_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	modem_info *info = (modem_info *) tty->driver_data;
 
diff -puN drivers/net/irda/irtty-sir.c~tty-switch-to-ktermios drivers/net/irda/irtty-sir.c
--- a/drivers/net/irda/irtty-sir.c~tty-switch-to-ktermios
+++ a/drivers/net/irda/irtty-sir.c
@@ -117,7 +117,7 @@ static int irtty_change_speed(struct sir
 {
 	struct sirtty_cb *priv = dev->priv;
 	struct tty_struct *tty;
-        struct termios old_termios;
+        struct ktermios old_termios;
 	int cflag;
 
 	IRDA_ASSERT(priv != NULL, return -1;);
@@ -318,7 +318,7 @@ static void irtty_write_wakeup(struct tt
 
 static inline void irtty_stop_receiver(struct tty_struct *tty, int stop)
 {
-	struct termios old_termios;
+	struct ktermios old_termios;
 	int cflag;
 
 	lock_kernel();
diff -puN drivers/s390/char/sclp_tty.c~tty-switch-to-ktermios drivers/s390/char/sclp_tty.c
--- a/drivers/s390/char/sclp_tty.c~tty-switch-to-ktermios
+++ a/drivers/s390/char/sclp_tty.c
@@ -60,8 +60,6 @@ static unsigned short int sclp_tty_chars
 
 struct tty_driver *sclp_tty_driver;
 
-extern struct termios  tty_std_termios;
-
 static struct sclp_ioctls sclp_ioctls;
 static struct sclp_ioctls sclp_ioctls_init =
 {
diff -puN drivers/s390/char/tty3270.c~tty-switch-to-ktermios drivers/s390/char/tty3270.c
--- a/drivers/s390/char/tty3270.c~tty-switch-to-ktermios
+++ a/drivers/s390/char/tty3270.c
@@ -1659,7 +1659,7 @@ tty3270_flush_buffer(struct tty_struct *
  * Check for visible/invisible input switches
  */
 static void
-tty3270_set_termios(struct tty_struct *tty, struct termios *old)
+tty3270_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct tty3270 *tp;
 	int new;
diff -puN drivers/serial/21285.c~tty-switch-to-ktermios drivers/serial/21285.c
--- a/drivers/serial/21285.c~tty-switch-to-ktermios
+++ a/drivers/serial/21285.c
@@ -214,8 +214,8 @@ static void serial21285_shutdown(struct 
 }
 
 static void
-serial21285_set_termios(struct uart_port *port, struct termios *termios,
-			struct termios *old)
+serial21285_set_termios(struct uart_port *port, struct ktermios *termios,
+			struct ktermios *old)
 {
 	unsigned long flags;
 	unsigned int baud, quot, h_lcr;
diff -puN drivers/serial/68328serial.c~tty-switch-to-ktermios drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~tty-switch-to-ktermios
+++ a/drivers/serial/68328serial.c
@@ -1061,7 +1061,7 @@ static int rs_ioctl(struct tty_struct *t
 	return 0;
 }
 
-static void rs_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct m68k_serial *info = (struct m68k_serial *)tty->driver_data;
 
diff -puN drivers/serial/68360serial.c~tty-switch-to-ktermios drivers/serial/68360serial.c
--- a/drivers/serial/68360serial.c~tty-switch-to-ktermios
+++ a/drivers/serial/68360serial.c
@@ -1523,7 +1523,7 @@ static int rs_360_ioctl(struct tty_struc
 
 /* FIX UP modem control here someday......
 */
-static void rs_360_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void rs_360_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	ser_info_t *info = (ser_info_t *)tty->driver_data;
 
diff -puN drivers/serial/8250.c~tty-switch-to-ktermios drivers/serial/8250.c
--- a/drivers/serial/8250.c~tty-switch-to-ktermios
+++ a/drivers/serial/8250.c
@@ -1763,8 +1763,8 @@ static unsigned int serial8250_get_divis
 }
 
 static void
-serial8250_set_termios(struct uart_port *port, struct termios *termios,
-		       struct termios *old)
+serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
+		       struct ktermios *old)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 	unsigned char cval, fcr = 0;
diff -puN drivers/serial/amba-pl010.c~tty-switch-to-ktermios drivers/serial/amba-pl010.c
--- a/drivers/serial/amba-pl010.c~tty-switch-to-ktermios
+++ a/drivers/serial/amba-pl010.c
@@ -345,8 +345,8 @@ static void pl010_shutdown(struct uart_p
 }
 
 static void
-pl010_set_termios(struct uart_port *port, struct termios *termios,
-		     struct termios *old)
+pl010_set_termios(struct uart_port *port, struct ktermios *termios,
+		     struct ktermios *old)
 {
 	unsigned int lcr_h, old_cr;
 	unsigned long flags;
diff -puN drivers/serial/amba-pl011.c~tty-switch-to-ktermios drivers/serial/amba-pl011.c
--- a/drivers/serial/amba-pl011.c~tty-switch-to-ktermios
+++ a/drivers/serial/amba-pl011.c
@@ -412,8 +412,8 @@ static void pl011_shutdown(struct uart_p
 }
 
 static void
-pl011_set_termios(struct uart_port *port, struct termios *termios,
-		     struct termios *old)
+pl011_set_termios(struct uart_port *port, struct ktermios *termios,
+		     struct ktermios *old)
 {
 	unsigned int lcr_h, old_cr;
 	unsigned long flags;
diff -puN drivers/serial/atmel_serial.c~tty-switch-to-ktermios drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~tty-switch-to-ktermios
+++ a/drivers/serial/atmel_serial.c
@@ -478,7 +478,7 @@ static void atmel_serial_pm(struct uart_
 /*
  * Change the port parameters
  */
-static void atmel_set_termios(struct uart_port *port, struct termios * termios, struct termios * old)
+static void atmel_set_termios(struct uart_port *port, struct ktermios * termios, struct ktermios * old)
 {
 	unsigned long flags;
 	unsigned int mode, imr, quot, baud;
diff -puN drivers/serial/clps711x.c~tty-switch-to-ktermios drivers/serial/clps711x.c
--- a/drivers/serial/clps711x.c~tty-switch-to-ktermios
+++ a/drivers/serial/clps711x.c
@@ -286,8 +286,8 @@ static void clps711xuart_shutdown(struct
 }
 
 static void
-clps711xuart_set_termios(struct uart_port *port, struct termios *termios,
-			 struct termios *old)
+clps711xuart_set_termios(struct uart_port *port, struct ktermios *termios,
+			 struct ktermios *old)
 {
 	unsigned int ubrlcr, baud, quot;
 	unsigned long flags;
diff -puN drivers/serial/crisv10.c~tty-switch-to-ktermios drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~tty-switch-to-ktermios
+++ a/drivers/serial/crisv10.c
@@ -804,8 +804,8 @@ static struct e100_serial rs_table[] = {
 
 #define NR_PORTS (sizeof(rs_table)/sizeof(struct e100_serial))
 
-static struct termios *serial_termios[NR_PORTS];
-static struct termios *serial_termios_locked[NR_PORTS];
+static struct ktermios *serial_termios[NR_PORTS];
+static struct ktermios *serial_termios_locked[NR_PORTS];
 #ifdef CONFIG_ETRAX_SERIAL_FAST_TIMER
 static struct fast_timer fast_timers[NR_PORTS];
 #endif
@@ -4223,7 +4223,7 @@ rs_ioctl(struct tty_struct *tty, struct 
 }
 
 static void
-rs_set_termios(struct tty_struct *tty, struct termios *old_termios)
+rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 
@@ -4877,6 +4877,8 @@ rs_init(void)
 	driver->init_termios = tty_std_termios;
 	driver->init_termios.c_cflag =
 		B115200 | CS8 | CREAD | HUPCL | CLOCAL; /* is normally B9600 default... */
+	driver->init_termios.c_ispeed = 115200;
+	driver->init_termios.c_ospeed = 115200;
 	driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	driver->termios = serial_termios;
 	driver->termios_locked = serial_termios_locked;
diff -puN drivers/serial/crisv10.h~tty-switch-to-ktermios drivers/serial/crisv10.h
--- a/drivers/serial/crisv10.h~tty-switch-to-ktermios
+++ a/drivers/serial/crisv10.h
@@ -93,8 +93,8 @@ struct e100_serial {
 
 	struct work_struct	work;
 	struct async_icount	icount;   /* error-statistics etc.*/
-	struct termios		normal_termios;
-	struct termios		callout_termios;
+	struct ktermios		normal_termios;
+	struct ktermios		callout_termios;
 #ifdef DECLARE_WAITQUEUE
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
diff -puN drivers/serial/dz.c~tty-switch-to-ktermios drivers/serial/dz.c
--- a/drivers/serial/dz.c~tty-switch-to-ktermios
+++ a/drivers/serial/dz.c
@@ -461,8 +461,8 @@ static void dz_break_ctl(struct uart_por
 	spin_unlock_irqrestore(&uport->lock, flags);
 }
 
-static void dz_set_termios(struct uart_port *uport, struct termios *termios,
-			   struct termios *old_termios)
+static void dz_set_termios(struct uart_port *uport, struct ktermios *termios,
+			   struct ktermios *old_termios)
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 	unsigned long flags;
diff -puN drivers/serial/icom.c~tty-switch-to-ktermios drivers/serial/icom.c
--- a/drivers/serial/icom.c~tty-switch-to-ktermios
+++ a/drivers/serial/icom.c
@@ -1087,8 +1087,8 @@ static void icom_close(struct uart_port 
 }
 
 static void icom_set_termios(struct uart_port *port,
-			     struct termios *termios,
-			     struct termios *old_termios)
+			     struct ktermios *termios,
+			     struct ktermios *old_termios)
 {
 	int baud;
 	unsigned cflag, iflag;
diff -puN drivers/serial/imx.c~tty-switch-to-ktermios drivers/serial/imx.c
--- a/drivers/serial/imx.c~tty-switch-to-ktermios
+++ a/drivers/serial/imx.c
@@ -459,8 +459,8 @@ static void imx_shutdown(struct uart_por
 }
 
 static void
-imx_set_termios(struct uart_port *port, struct termios *termios,
-		   struct termios *old)
+imx_set_termios(struct uart_port *port, struct ktermios *termios,
+		   struct ktermios *old)
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long flags;
diff -puN drivers/serial/ioc3_serial.c~tty-switch-to-ktermios drivers/serial/ioc3_serial.c
--- a/drivers/serial/ioc3_serial.c~tty-switch-to-ktermios
+++ a/drivers/serial/ioc3_serial.c
@@ -950,7 +950,7 @@ static void transmit_chars(struct uart_p
  */
 static void
 ioc3_change_speed(struct uart_port *the_port,
-		  struct termios *new_termios, struct termios *old_termios)
+		  struct ktermios *new_termios, struct ktermios *old_termios)
 {
 	struct ioc3_port *port = get_ioc3_port(the_port);
 	unsigned int cflag;
@@ -1853,7 +1853,7 @@ static int ic3_startup(struct uart_port 
  */
 static void
 ic3_set_termios(struct uart_port *the_port,
-		struct termios *termios, struct termios *old_termios)
+		struct ktermios *termios, struct ktermios *old_termios)
 {
 	unsigned long port_flags;
 
diff -puN drivers/serial/ioc4_serial.c~tty-switch-to-ktermios drivers/serial/ioc4_serial.c
--- a/drivers/serial/ioc4_serial.c~tty-switch-to-ktermios
+++ a/drivers/serial/ioc4_serial.c
@@ -1681,7 +1681,7 @@ static void transmit_chars(struct uart_p
  */
 static void
 ioc4_change_speed(struct uart_port *the_port,
-		  struct termios *new_termios, struct termios *old_termios)
+		  struct ktermios *new_termios, struct ktermios *old_termios)
 {
 	struct ioc4_port *port = get_ioc4_port(the_port, 0);
 	int baud, bits;
@@ -1802,7 +1802,7 @@ static inline int ic4_startup_local(stru
 	ioc4_set_proto(port, the_port->mapbase);
 
 	/* set the speed of the serial port */
-	ioc4_change_speed(the_port, info->tty->termios, (struct termios *)0);
+	ioc4_change_speed(the_port, info->tty->termios, (struct ktermios *)0);
 
 	return 0;
 }
@@ -2570,7 +2570,7 @@ static int ic4_startup(struct uart_port 
  */
 static void
 ic4_set_termios(struct uart_port *the_port,
-		struct termios *termios, struct termios *old_termios)
+		struct ktermios *termios, struct ktermios *old_termios)
 {
 	unsigned long port_flags;
 
diff -puN drivers/serial/ip22zilog.c~tty-switch-to-ktermios drivers/serial/ip22zilog.c
--- a/drivers/serial/ip22zilog.c~tty-switch-to-ktermios
+++ a/drivers/serial/ip22zilog.c
@@ -840,8 +840,8 @@ ip22zilog_convert_to_zs(struct uart_ip22
 
 /* The port lock is not held.  */
 static void
-ip22zilog_set_termios(struct uart_port *port, struct termios *termios,
-		      struct termios *old)
+ip22zilog_set_termios(struct uart_port *port, struct ktermios *termios,
+		      struct ktermios *old)
 {
 	struct uart_ip22zilog_port *up = (struct uart_ip22zilog_port *) port;
 	unsigned long flags;
diff -puN drivers/serial/jsm/jsm_tty.c~tty-switch-to-ktermios drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~tty-switch-to-ktermios
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -142,7 +142,7 @@ static void jsm_tty_send_xchar(struct ua
 {
 	unsigned long lock_flags;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
-	struct termios *termios;
+	struct ktermios *termios;
 
 	spin_lock_irqsave(&port->lock, lock_flags);
 	termios = port->info->tty->termios;
@@ -180,7 +180,7 @@ static int jsm_tty_open(struct uart_port
 	struct jsm_board *brd;
 	int rc = 0;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
-	struct termios *termios;
+	struct ktermios *termios;
 
 	/* Get board pointer from our array of majors we have allocated */
 	brd = channel->ch_bd;
@@ -269,7 +269,7 @@ static int jsm_tty_open(struct uart_port
 static void jsm_tty_close(struct uart_port *port)
 {
 	struct jsm_board *bd;
-	struct termios *ts;
+	struct ktermios *ts;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 
 	jsm_printk(CLOSE, INFO, &channel->ch_bd->pci_dev, "start\n");
@@ -302,8 +302,8 @@ static void jsm_tty_close(struct uart_po
 }
 
 static void jsm_tty_set_termios(struct uart_port *port,
-				 struct termios *termios,
-				 struct termios *old_termios)
+				 struct ktermios *termios,
+				 struct ktermios *old_termios)
 {
 	unsigned long lock_flags;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
diff -puN drivers/serial/m32r_sio.c~tty-switch-to-ktermios drivers/serial/m32r_sio.c
--- a/drivers/serial/m32r_sio.c~tty-switch-to-ktermios
+++ a/drivers/serial/m32r_sio.c
@@ -699,7 +699,7 @@ static unsigned int m32r_sio_get_divisor
 }
 
 static void m32r_sio_set_termios(struct uart_port *port,
-	struct termios *termios, struct termios *old)
+	struct ktermios *termios, struct ktermios *old)
 {
 	struct uart_sio_port *up = (struct uart_sio_port *)port;
 	unsigned char cval = 0;
diff -puN drivers/serial/mcfserial.c~tty-switch-to-ktermios drivers/serial/mcfserial.c
--- a/drivers/serial/mcfserial.c~tty-switch-to-ktermios
+++ a/drivers/serial/mcfserial.c
@@ -1132,7 +1132,7 @@ static int mcfrs_ioctl(struct tty_struct
 	return 0;
 }
 
-static void mcfrs_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void mcfrs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct mcf_serial *info = (struct mcf_serial *)tty->driver_data;
 
diff -puN drivers/serial/mpc52xx_uart.c~tty-switch-to-ktermios drivers/serial/mpc52xx_uart.c
--- a/drivers/serial/mpc52xx_uart.c~tty-switch-to-ktermios
+++ a/drivers/serial/mpc52xx_uart.c
@@ -270,8 +270,8 @@ mpc52xx_uart_shutdown(struct uart_port *
 }
 
 static void
-mpc52xx_uart_set_termios(struct uart_port *port, struct termios *new,
-                         struct termios *old)
+mpc52xx_uart_set_termios(struct uart_port *port, struct ktermios *new,
+                         struct ktermios *old)
 {
 	struct mpc52xx_psc __iomem *psc = PSC(port);
 	unsigned long flags;
diff -puN drivers/serial/mpsc.c~tty-switch-to-ktermios drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~tty-switch-to-ktermios
+++ a/drivers/serial/mpsc.c
@@ -1440,8 +1440,8 @@ mpsc_shutdown(struct uart_port *port)
 }
 
 static void
-mpsc_set_termios(struct uart_port *port, struct termios *termios,
-		 struct termios *old)
+mpsc_set_termios(struct uart_port *port, struct ktermios *termios,
+		 struct ktermios *old)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
 	u32 baud;
diff -puN drivers/serial/mux.c~tty-switch-to-ktermios drivers/serial/mux.c
--- a/drivers/serial/mux.c~tty-switch-to-ktermios
+++ a/drivers/serial/mux.c
@@ -273,8 +273,8 @@ static void mux_shutdown(struct uart_por
  * The Serial Mux does not support this function.
  */
 static void
-mux_set_termios(struct uart_port *port, struct termios *termios,
-	        struct termios *old)
+mux_set_termios(struct uart_port *port, struct ktermios *termios,
+	        struct ktermios *old)
 {
 }
 
diff -puN drivers/serial/netx-serial.c~tty-switch-to-ktermios drivers/serial/netx-serial.c
--- a/drivers/serial/netx-serial.c~tty-switch-to-ktermios
+++ a/drivers/serial/netx-serial.c
@@ -337,8 +337,8 @@ static void netx_shutdown(struct uart_po
 }
 
 static void
-netx_set_termios(struct uart_port *port, struct termios *termios,
-		   struct termios *old)
+netx_set_termios(struct uart_port *port, struct ktermios *termios,
+		   struct ktermios *old)
 {
 	unsigned int baud, quot;
 	unsigned char old_cr;
diff -puN drivers/serial/pmac_zilog.c~tty-switch-to-ktermios drivers/serial/pmac_zilog.c
--- a/drivers/serial/pmac_zilog.c~tty-switch-to-ktermios
+++ a/drivers/serial/pmac_zilog.c
@@ -1262,8 +1262,8 @@ static void pmz_irda_setup(struct uart_p
 }
 
 
-static void __pmz_set_termios(struct uart_port *port, struct termios *termios,
-			      struct termios *old)
+static void __pmz_set_termios(struct uart_port *port, struct ktermios *termios,
+			      struct ktermios *old)
 {
 	struct uart_pmac_port *uap = to_pmz(port);
 	unsigned long baud;
@@ -1273,7 +1273,7 @@ static void __pmz_set_termios(struct uar
 	if (ZS_IS_ASLEEP(uap))
 		return;
 
-	memcpy(&uap->termios_cache, termios, sizeof(struct termios));
+	memcpy(&uap->termios_cache, termios, sizeof(struct ktermios));
 
 	/* XXX Check which revs of machines actually allow 1 and 4Mb speeds
 	 * on the IR dongle. Note that the IRTTY driver currently doesn't know
@@ -1313,8 +1313,8 @@ static void __pmz_set_termios(struct uar
 }
 
 /* The port lock is not held.  */
-static void pmz_set_termios(struct uart_port *port, struct termios *termios,
-			    struct termios *old)
+static void pmz_set_termios(struct uart_port *port, struct ktermios *termios,
+			    struct ktermios *old)
 {
 	struct uart_pmac_port *uap = to_pmz(port);
 	unsigned long flags;
diff -puN drivers/serial/pmac_zilog.h~tty-switch-to-ktermios drivers/serial/pmac_zilog.h
--- a/drivers/serial/pmac_zilog.h~tty-switch-to-ktermios
+++ a/drivers/serial/pmac_zilog.h
@@ -60,7 +60,7 @@ struct uart_pmac_port {
 	volatile struct dbdma_regs	__iomem *tx_dma_regs;
 	volatile struct dbdma_regs	__iomem *rx_dma_regs;
 
-	struct termios			termios_cache;
+	struct ktermios			termios_cache;
 };
 
 #define to_pmz(p) ((struct uart_pmac_port *)(p))
diff -puN drivers/serial/pxa.c~tty-switch-to-ktermios drivers/serial/pxa.c
--- a/drivers/serial/pxa.c~tty-switch-to-ktermios
+++ a/drivers/serial/pxa.c
@@ -433,8 +433,8 @@ static void serial_pxa_shutdown(struct u
 }
 
 static void
-serial_pxa_set_termios(struct uart_port *port, struct termios *termios,
-		       struct termios *old)
+serial_pxa_set_termios(struct uart_port *port, struct ktermios *termios,
+		       struct ktermios *old)
 {
 	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
 	unsigned char cval, fcr = 0;
diff -puN drivers/serial/s3c2410.c~tty-switch-to-ktermios drivers/serial/s3c2410.c
--- a/drivers/serial/s3c2410.c~tty-switch-to-ktermios
+++ a/drivers/serial/s3c2410.c
@@ -738,8 +738,8 @@ static unsigned int s3c24xx_serial_getcl
 }
 
 static void s3c24xx_serial_set_termios(struct uart_port *port,
-				       struct termios *termios,
-				       struct termios *old)
+				       struct ktermios *termios,
+				       struct ktermios *old)
 {
 	struct s3c2410_uartcfg *cfg = s3c24xx_port_to_cfg(port);
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
diff -puN drivers/serial/sa1100.c~tty-switch-to-ktermios drivers/serial/sa1100.c
--- a/drivers/serial/sa1100.c~tty-switch-to-ktermios
+++ a/drivers/serial/sa1100.c
@@ -408,8 +408,8 @@ static void sa1100_shutdown(struct uart_
 }
 
 static void
-sa1100_set_termios(struct uart_port *port, struct termios *termios,
-		   struct termios *old)
+sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
+		   struct ktermios *old)
 {
 	struct sa1100_port *sport = (struct sa1100_port *)port;
 	unsigned long flags;
diff -puN drivers/serial/serial_core.c~tty-switch-to-ktermios drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~tty-switch-to-ktermios
+++ a/drivers/serial/serial_core.c
@@ -65,7 +65,7 @@ static struct lock_class_key port_lock_k
 #define uart_console(port)	(0)
 #endif
 
-static void uart_change_speed(struct uart_state *state, struct termios *old_termios);
+static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
@@ -338,8 +338,8 @@ EXPORT_SYMBOL(uart_update_timeout);
  *	we're actually going to be using.
  */
 unsigned int
-uart_get_baud_rate(struct uart_port *port, struct termios *termios,
-		   struct termios *old, unsigned int min, unsigned int max)
+uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
+		   struct ktermios *old, unsigned int min, unsigned int max)
 {
 	unsigned int try, baud, altbaud = 38400;
 	upf_t flags = port->flags & UPF_SPD_MASK;
@@ -421,11 +421,11 @@ uart_get_divisor(struct uart_port *port,
 EXPORT_SYMBOL(uart_get_divisor);
 
 static void
-uart_change_speed(struct uart_state *state, struct termios *old_termios)
+uart_change_speed(struct uart_state *state, struct ktermios *old_termios)
 {
 	struct tty_struct *tty = state->info->tty;
 	struct uart_port *port = state->port;
-	struct termios *termios;
+	struct ktermios *termios;
 
 	/*
 	 * If we have no tty, termios, or the port does not exist,
@@ -1139,7 +1139,7 @@ uart_ioctl(struct tty_struct *tty, struc
 	return ret;
 }
 
-static void uart_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void uart_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct uart_state *state = tty->driver_data;
 	unsigned long flags;
@@ -1866,7 +1866,7 @@ int __init
 uart_set_options(struct uart_port *port, struct console *co,
 		 int baud, int parity, int bits, int flow)
 {
-	struct termios termios;
+	struct ktermios termios;
 	int i;
 
 	/*
@@ -1876,7 +1876,7 @@ uart_set_options(struct uart_port *port,
 	spin_lock_init(&port->lock);
 	lockdep_set_class(&port->lock, &port_lock_key);
 
-	memset(&termios, 0, sizeof(struct termios));
+	memset(&termios, 0, sizeof(struct ktermios));
 
 	termios.c_cflag = CREAD | HUPCL | CLOCAL;
 
@@ -1991,12 +1991,12 @@ int uart_resume_port(struct uart_driver 
 	 * Re-enable the console device after suspending.
 	 */
 	if (uart_console(port)) {
-		struct termios termios;
+		struct ktermios termios;
 
 		/*
 		 * First try to use the console cflag setting.
 		 */
-		memset(&termios, 0, sizeof(struct termios));
+		memset(&termios, 0, sizeof(struct ktermios));
 		termios.c_cflag = port->cons->cflag;
 
 		/*
@@ -2189,6 +2189,7 @@ int uart_register_driver(struct uart_dri
 	normal->subtype		= SERIAL_TYPE_NORMAL;
 	normal->init_termios	= tty_std_termios;
 	normal->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	normal->init_termios.c_ispeed = normal->init_termios.c_ospeed = 9600;
 	normal->flags		= TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	normal->driver_state    = drv;
 	tty_set_operations(normal, &uart_ops);
diff -puN drivers/serial/serial_lh7a40x.c~tty-switch-to-ktermios drivers/serial/serial_lh7a40x.c
--- a/drivers/serial/serial_lh7a40x.c~tty-switch-to-ktermios
+++ a/drivers/serial/serial_lh7a40x.c
@@ -348,8 +348,8 @@ static void lh7a40xuart_shutdown (struct
 }
 
 static void lh7a40xuart_set_termios (struct uart_port* port,
-				     struct termios* termios,
-				     struct termios* old)
+				     struct ktermios* termios,
+				     struct ktermios* old)
 {
 	unsigned int con;
 	unsigned int inten;
diff -puN drivers/serial/serial_txx9.c~tty-switch-to-ktermios drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~tty-switch-to-ktermios
+++ a/drivers/serial/serial_txx9.c
@@ -556,8 +556,8 @@ static void serial_txx9_shutdown(struct 
 }
 
 static void
-serial_txx9_set_termios(struct uart_port *port, struct termios *termios,
-		       struct termios *old)
+serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
+		       struct ktermios *old)
 {
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
 	unsigned int cval, fcr = 0;
diff -puN drivers/serial/sh-sci.c~tty-switch-to-ktermios drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~tty-switch-to-ktermios
+++ a/drivers/serial/sh-sci.c
@@ -943,8 +943,8 @@ static void sci_shutdown(struct uart_por
 		s->disable(port);
 }
 
-static void sci_set_termios(struct uart_port *port, struct termios *termios,
-			    struct termios *old)
+static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
+			    struct ktermios *old)
 {
 	struct sci_port *s = &sci_ports[port->line];
 	unsigned int status, baud, smr_val;
diff -puN drivers/serial/sn_console.c~tty-switch-to-ktermios drivers/serial/sn_console.c
--- a/drivers/serial/sn_console.c~tty-switch-to-ktermios
+++ a/drivers/serial/sn_console.c
@@ -361,8 +361,8 @@ static int snp_startup(struct uart_port 
  *
  */
 static void
-snp_set_termios(struct uart_port *port, struct termios *termios,
-		struct termios *old)
+snp_set_termios(struct uart_port *port, struct ktermios *termios,
+		struct ktermios *old)
 {
 }
 
diff -puN drivers/serial/sunhv.c~tty-switch-to-ktermios drivers/serial/sunhv.c
--- a/drivers/serial/sunhv.c~tty-switch-to-ktermios
+++ a/drivers/serial/sunhv.c
@@ -281,8 +281,8 @@ static void sunhv_shutdown(struct uart_p
 }
 
 /* port->lock is not held.  */
-static void sunhv_set_termios(struct uart_port *port, struct termios *termios,
-			      struct termios *old)
+static void sunhv_set_termios(struct uart_port *port, struct ktermios *termios,
+			      struct ktermios *old)
 {
 	unsigned int baud = uart_get_baud_rate(port, termios, old, 0, 4000000);
 	unsigned int quot = uart_get_divisor(port, baud);
diff -puN drivers/serial/sunsab.c~tty-switch-to-ktermios drivers/serial/sunsab.c
--- a/drivers/serial/sunsab.c~tty-switch-to-ktermios
+++ a/drivers/serial/sunsab.c
@@ -786,8 +786,8 @@ static void sunsab_convert_to_sab(struct
 }
 
 /* port->lock is not held.  */
-static void sunsab_set_termios(struct uart_port *port, struct termios *termios,
-			       struct termios *old)
+static void sunsab_set_termios(struct uart_port *port, struct ktermios *termios,
+			       struct ktermios *old)
 {
 	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
 	unsigned long flags;
diff -puN drivers/serial/sunsu.c~tty-switch-to-ktermios drivers/serial/sunsu.c
--- a/drivers/serial/sunsu.c~tty-switch-to-ktermios
+++ a/drivers/serial/sunsu.c
@@ -893,8 +893,8 @@ sunsu_change_speed(struct uart_port *por
 }
 
 static void
-sunsu_set_termios(struct uart_port *port, struct termios *termios,
-		  struct termios *old)
+sunsu_set_termios(struct uart_port *port, struct ktermios *termios,
+		  struct ktermios *old)
 {
 	unsigned int baud, quot;
 
diff -puN drivers/serial/sunzilog.c~tty-switch-to-ktermios drivers/serial/sunzilog.c
--- a/drivers/serial/sunzilog.c~tty-switch-to-ktermios
+++ a/drivers/serial/sunzilog.c
@@ -922,8 +922,8 @@ sunzilog_convert_to_zs(struct uart_sunzi
 
 /* The port lock is not held.  */
 static void
-sunzilog_set_termios(struct uart_port *port, struct termios *termios,
-		     struct termios *old)
+sunzilog_set_termios(struct uart_port *port, struct ktermios *termios,
+		     struct ktermios *old)
 {
 	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
 	unsigned long flags;
diff -puN drivers/serial/uartlite.c~tty-switch-to-ktermios drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~tty-switch-to-ktermios
+++ a/drivers/serial/uartlite.c
@@ -214,8 +214,8 @@ static void ulite_shutdown(struct uart_p
 	free_irq(port->irq, port);
 }
 
-static void ulite_set_termios(struct uart_port *port, struct termios *termios,
-			      struct termios *old)
+static void ulite_set_termios(struct uart_port *port, struct ktermios *termios,
+			      struct ktermios *old)
 {
 	unsigned long flags;
 	unsigned int baud;
diff -puN drivers/serial/v850e_uart.c~tty-switch-to-ktermios drivers/serial/v850e_uart.c
--- a/drivers/serial/v850e_uart.c~tty-switch-to-ktermios
+++ a/drivers/serial/v850e_uart.c
@@ -404,8 +404,8 @@ static void v850e_uart_shutdown (struct 
 }
 
 static void
-v850e_uart_set_termios (struct uart_port *port, struct termios *termios,
-		        struct termios *old)
+v850e_uart_set_termios (struct uart_port *port, struct ktermios *termios,
+		        struct ktermios *old)
 {
 	unsigned cflags = termios->c_cflag;
 
diff -puN drivers/serial/vr41xx_siu.c~tty-switch-to-ktermios drivers/serial/vr41xx_siu.c
--- a/drivers/serial/vr41xx_siu.c~tty-switch-to-ktermios
+++ a/drivers/serial/vr41xx_siu.c
@@ -562,8 +562,8 @@ static void siu_shutdown(struct uart_por
 	free_irq(port->irq, port);
 }
 
-static void siu_set_termios(struct uart_port *port, struct termios *new,
-                            struct termios *old)
+static void siu_set_termios(struct uart_port *port, struct ktermios *new,
+                            struct ktermios *old)
 {
 	tcflag_t c_cflag, c_iflag;
 	uint8_t lcr, fcr, ier;
diff -puN drivers/tc/zs.c~tty-switch-to-ktermios drivers/tc/zs.c
--- a/drivers/tc/zs.c~tty-switch-to-ktermios
+++ a/drivers/tc/zs.c
@@ -1238,7 +1238,7 @@ static int rs_ioctl(struct tty_struct *t
 	return 0;
 }
 
-static void rs_set_termios(struct tty_struct *tty, struct termios *old_termios)
+static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct dec_serial *info = (struct dec_serial *)tty->driver_data;
 	int was_stopped;
diff -puN drivers/usb/class/cdc-acm.c~tty-switch-to-ktermios drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~tty-switch-to-ktermios
+++ a/drivers/usb/class/cdc-acm.c
@@ -677,10 +677,10 @@ static const __u8 acm_tty_size[] = {
 	5, 6, 7, 8
 };
 
-static void acm_tty_set_termios(struct tty_struct *tty, struct termios *termios_old)
+static void acm_tty_set_termios(struct tty_struct *tty, struct ktermios *termios_old)
 {
 	struct acm *acm = tty->driver_data;
-	struct termios *termios = tty->termios;
+	struct ktermios *termios = tty->termios;
 	struct usb_cdc_line_coding newline;
 	int newctrl = acm->ctrlout;
 
diff -puN drivers/usb/gadget/serial.c~tty-switch-to-ktermios drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c~tty-switch-to-ktermios
+++ a/drivers/usb/gadget/serial.c
@@ -200,7 +200,7 @@ static void gs_unthrottle(struct tty_str
 static void gs_break(struct tty_struct *tty, int break_state);
 static int  gs_ioctl(struct tty_struct *tty, struct file *file,
 	unsigned int cmd, unsigned long arg);
-static void gs_set_termios(struct tty_struct *tty, struct termios *old);
+static void gs_set_termios(struct tty_struct *tty, struct ktermios *old);
 
 static int gs_send(struct gs_dev *dev);
 static int gs_send_packet(struct gs_dev *dev, char *packet,
@@ -1077,7 +1077,7 @@ static int gs_ioctl(struct tty_struct *t
 /*
  * gs_set_termios
  */
-static void gs_set_termios(struct tty_struct *tty, struct termios *old)
+static void gs_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 }
 
diff -puN drivers/usb/serial/ark3116.c~tty-switch-to-ktermios drivers/usb/serial/ark3116.c
--- a/drivers/usb/serial/ark3116.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/ark3116.c
@@ -156,7 +156,7 @@ cleanup:
 }
 
 static void ark3116_set_termios(struct usb_serial_port *port,
-				struct termios *old_termios)
+				struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct ark3116_private *priv = usb_get_serial_port_data(port);
@@ -326,7 +326,7 @@ static void ark3116_set_termios(struct u
 
 static int ark3116_open(struct usb_serial_port *port, struct file *filp)
 {
-	struct termios tmp_termios;
+	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	char *buf;
 	int result = 0;
diff -puN drivers/usb/serial/belkin_sa.c~tty-switch-to-ktermios drivers/usb/serial/belkin_sa.c
--- a/drivers/usb/serial/belkin_sa.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/belkin_sa.c
@@ -92,7 +92,7 @@ static void belkin_sa_shutdown		(struct 
 static int  belkin_sa_open		(struct usb_serial_port *port, struct file *filp);
 static void belkin_sa_close		(struct usb_serial_port *port, struct file *filp);
 static void belkin_sa_read_int_callback (struct urb *urb);
-static void belkin_sa_set_termios	(struct usb_serial_port *port, struct termios * old);
+static void belkin_sa_set_termios	(struct usb_serial_port *port, struct ktermios * old);
 static int  belkin_sa_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
 static void belkin_sa_break_ctl		(struct usb_serial_port *port, int break_state );
 static int  belkin_sa_tiocmget		(struct usb_serial_port *port, struct file *file);
@@ -333,7 +333,7 @@ exit:
 		     __FUNCTION__, retval);
 }
 
-static void belkin_sa_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void belkin_sa_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
diff -puN drivers/usb/serial/console.c~tty-switch-to-ktermios drivers/usb/serial/console.c
--- a/drivers/usb/serial/console.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/console.c
@@ -65,7 +65,7 @@ static int usb_console_setup(struct cons
 	struct usb_serial_port *port;
 	int retval = 0;
 	struct tty_struct *tty;
-	struct termios *termios;
+	struct ktermios *termios;
 
 	dbg ("%s", __FUNCTION__);
 
diff -puN drivers/usb/serial/cp2101.c~tty-switch-to-ktermios drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/cp2101.c
@@ -41,7 +41,7 @@ static int cp2101_open(struct usb_serial
 static void cp2101_cleanup(struct usb_serial_port*);
 static void cp2101_close(struct usb_serial_port*, struct file*);
 static void cp2101_get_termios(struct usb_serial_port*);
-static void cp2101_set_termios(struct usb_serial_port*, struct termios*);
+static void cp2101_set_termios(struct usb_serial_port*, struct ktermios*);
 static int cp2101_tiocmget (struct usb_serial_port *, struct file *);
 static int cp2101_tiocmset (struct usb_serial_port *, struct file *,
 		unsigned int, unsigned int);
@@ -506,7 +506,7 @@ static void cp2101_get_termios (struct u
 }
 
 static void cp2101_set_termios (struct usb_serial_port *port,
-		struct termios *old_termios)
+		struct ktermios *old_termios)
 {
 	unsigned int cflag, old_cflag=0;
 	int baud=0, bits;
diff -puN drivers/usb/serial/cypress_m8.c~tty-switch-to-ktermios drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/cypress_m8.c
@@ -143,7 +143,7 @@ struct cypress_private {
 	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
 	/* we pass a pointer to this as the arguement sent to cypress_set_termios old_termios */
-	struct termios tmp_termios; 	   /* stores the old termios settings */
+	struct ktermios tmp_termios; 	   /* stores the old termios settings */
 };
 
 /* write buffer structure */
@@ -165,7 +165,7 @@ static int  cypress_write		(struct usb_s
 static void cypress_send		(struct usb_serial_port *port);
 static int  cypress_write_room		(struct usb_serial_port *port);
 static int  cypress_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void cypress_set_termios		(struct usb_serial_port *port, struct termios * old);
+static void cypress_set_termios		(struct usb_serial_port *port, struct ktermios * old);
 static int  cypress_tiocmget		(struct usb_serial_port *port, struct file *file);
 static int  cypress_tiocmset		(struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear);
 static int  cypress_chars_in_buffer	(struct usb_serial_port *port);
@@ -949,13 +949,13 @@ static int cypress_ioctl (struct usb_ser
 
 	switch (cmd) {
 		case TIOCGSERIAL:
-			if (copy_to_user((void __user *)arg, port->tty->termios, sizeof(struct termios))) {
+			if (copy_to_user((void __user *)arg, port->tty->termios, sizeof(struct ktermios))) {
 				return -EFAULT;
 			}
 			return (0);
 			break;
 		case TIOCSSERIAL:
-			if (copy_from_user(port->tty->termios, (void __user *)arg, sizeof(struct termios))) {
+			if (copy_from_user(port->tty->termios, (void __user *)arg, sizeof(struct ktermios))) {
 				return -EFAULT;
 			}
 			/* here we need to call cypress_set_termios to invoke the new settings */
@@ -1019,7 +1019,7 @@ static int cypress_ioctl (struct usb_ser
 
 
 static void cypress_set_termios (struct usb_serial_port *port,
-		struct termios *old_termios)
+		struct ktermios *old_termios)
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
diff -puN drivers/usb/serial/digi_acceleport.c~tty-switch-to-ktermios drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -449,7 +449,7 @@ static int digi_transmit_idle( struct us
 static void digi_rx_throttle (struct usb_serial_port *port);
 static void digi_rx_unthrottle (struct usb_serial_port *port);
 static void digi_set_termios( struct usb_serial_port *port, 
-	struct termios *old_termios );
+	struct ktermios *old_termios );
 static void digi_break_ctl( struct usb_serial_port *port, int break_state );
 static int digi_ioctl( struct usb_serial_port *port, struct file *file,
 	unsigned int cmd, unsigned long arg );
@@ -976,7 +976,7 @@ dbg( "digi_rx_unthrottle: TOP: port=%d",
 
 
 static void digi_set_termios( struct usb_serial_port *port, 
-	struct termios *old_termios )
+	struct ktermios *old_termios )
 {
 
 	struct digi_port *priv = usb_get_serial_port_data(port);
@@ -1463,7 +1463,7 @@ static int digi_open( struct usb_serial_
 	int ret;
 	unsigned char buf[32];
 	struct digi_port *priv = usb_get_serial_port_data(port);
-	struct termios not_termios;
+	struct ktermios not_termios;
 	unsigned long flags = 0;
 
 
diff -puN drivers/usb/serial/empeg.c~tty-switch-to-ktermios drivers/usb/serial/empeg.c
--- a/drivers/usb/serial/empeg.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/empeg.c
@@ -92,7 +92,7 @@ static int  empeg_ioctl			(struct usb_se
 					struct file * file,
 					unsigned int cmd,
 					unsigned long arg);
-static void empeg_set_termios		(struct usb_serial_port *port, struct termios *old_termios);
+static void empeg_set_termios		(struct usb_serial_port *port, struct ktermios *old_termios);
 static void empeg_write_bulk_callback	(struct urb *urb);
 static void empeg_read_bulk_callback	(struct urb *urb);
 
@@ -442,7 +442,7 @@ static int empeg_ioctl (struct usb_seria
 }
 
 
-static void empeg_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void empeg_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
diff -puN drivers/usb/serial/ftdi_sio.c~tty-switch-to-ktermios drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -595,7 +595,7 @@ static int  ftdi_chars_in_buffer	(struct
 static void ftdi_write_bulk_callback	(struct urb *urb);
 static void ftdi_read_bulk_callback	(struct urb *urb);
 static void ftdi_process_read		(struct work_struct *work);
-static void ftdi_set_termios		(struct usb_serial_port *port, struct termios * old);
+static void ftdi_set_termios		(struct usb_serial_port *port, struct ktermios * old);
 static int  ftdi_tiocmget               (struct usb_serial_port *port, struct file *file);
 static int  ftdi_tiocmset		(struct usb_serial_port *port, struct file * file, unsigned int set, unsigned int clear);
 static int  ftdi_ioctl			(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
@@ -1880,7 +1880,7 @@ static void ftdi_break_ctl( struct usb_s
  * WARNING: set_termios calls this with old_termios in kernel space
  */
 
-static void ftdi_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void ftdi_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 { /* ftdi_termios */
 	struct usb_device *dev = port->serial->dev;
 	unsigned int cflag = port->tty->termios->c_cflag;
diff -puN drivers/usb/serial/io_edgeport.c~tty-switch-to-ktermios drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/io_edgeport.c
@@ -229,7 +229,7 @@ static int  edge_write_room		(struct usb
 static int  edge_chars_in_buffer	(struct usb_serial_port *port);
 static void edge_throttle		(struct usb_serial_port *port);
 static void edge_unthrottle		(struct usb_serial_port *port);
-static void edge_set_termios		(struct usb_serial_port *port, struct termios *old_termios);
+static void edge_set_termios		(struct usb_serial_port *port, struct ktermios *old_termios);
 static int  edge_ioctl			(struct usb_serial_port *port, struct file *file, unsigned int cmd, unsigned long arg);
 static void edge_break			(struct usb_serial_port *port, int break_state);
 static int  edge_tiocmget		(struct usb_serial_port *port, struct file *file);
@@ -257,7 +257,7 @@ static void handle_new_lsr		(struct edge
 static int  send_iosp_ext_cmd		(struct edgeport_port *edge_port, __u8 command, __u8 param);
 static int  calc_baud_rate_divisor	(int baud_rate, int *divisor);
 static int  send_cmd_write_baud_rate	(struct edgeport_port *edge_port, int baudRate);
-static void change_port_settings	(struct edgeport_port *edge_port, struct termios *old_termios);
+static void change_port_settings	(struct edgeport_port *edge_port, struct ktermios *old_termios);
 static int  send_cmd_write_uart_register	(struct edgeport_port *edge_port, __u8 regNum, __u8 regValue);
 static int  write_cmd_usb		(struct edgeport_port *edge_port, unsigned char *buffer, int writeLength);
 static void send_more_port_data		(struct edgeport_serial *edge_serial, struct edgeport_port *edge_port);
@@ -1431,7 +1431,7 @@ static void edge_unthrottle (struct usb_
  * SerialSetTermios
  *	this function is called by the tty driver when it wants to change the termios structure
  *****************************************************************************/
-static void edge_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct tty_struct *tty = port->tty;
@@ -2412,7 +2412,7 @@ static int send_cmd_write_uart_register 
 #ifndef CMSPAR
 #define CMSPAR 0
 #endif
-static void change_port_settings (struct edgeport_port *edge_port, struct termios *old_termios)
+static void change_port_settings (struct edgeport_port *edge_port, struct ktermios *old_termios)
 {
 	struct tty_struct *tty;
 	int baud;
diff -puN drivers/usb/serial/io_ti.c~tty-switch-to-ktermios drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/io_ti.c
@@ -238,7 +238,7 @@ static void edge_tty_recv(struct device 
 static void stop_read(struct edgeport_port *edge_port);
 static int restart_read(struct edgeport_port *edge_port);
 
-static void edge_set_termios (struct usb_serial_port *port, struct termios *old_termios);
+static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old_termios);
 static void edge_send(struct usb_serial_port *port);
 
 /* circular buffer */
@@ -2361,7 +2361,7 @@ static int restart_read(struct edgeport_
 	return status;
 }
 
-static void change_port_settings (struct edgeport_port *edge_port, struct termios *old_termios)
+static void change_port_settings (struct edgeport_port *edge_port, struct ktermios *old_termios)
 {
 	struct ump_uart_config *config;
 	struct tty_struct *tty;
@@ -2512,7 +2512,7 @@ static void change_port_settings (struct
 	return;
 }
 
-static void edge_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct tty_struct *tty = port->tty;
diff -puN drivers/usb/serial/ir-usb.c~tty-switch-to-ktermios drivers/usb/serial/ir-usb.c
--- a/drivers/usb/serial/ir-usb.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/ir-usb.c
@@ -107,7 +107,7 @@ static void ir_close (struct usb_serial_
 static int  ir_write (struct usb_serial_port *port, const unsigned char *buf, int count);
 static void ir_write_bulk_callback (struct urb *urb);
 static void ir_read_bulk_callback (struct urb *urb);
-static void ir_set_termios (struct usb_serial_port *port, struct termios *old_termios);
+static void ir_set_termios (struct usb_serial_port *port, struct ktermios *old_termios);
 
 static u8 ir_baud = 0;
 static u8 ir_xbof = 0;
@@ -497,7 +497,7 @@ static void ir_read_bulk_callback (struc
 	return;
 }
 
-static void ir_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void ir_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	unsigned char *transfer_buffer;
 	unsigned int cflag;
diff -puN drivers/usb/serial/keyspan.c~tty-switch-to-ktermios drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/keyspan.c
@@ -264,7 +264,7 @@ static void keyspan_break_ctl (struct us
 
 
 static void keyspan_set_termios (struct usb_serial_port *port, 
-				     struct termios *old_termios)
+				     struct ktermios *old_termios)
 {
 	int				baud_rate, device_port;
 	struct keyspan_port_private 	*p_priv;
diff -puN drivers/usb/serial/keyspan.h~tty-switch-to-ktermios drivers/usb/serial/keyspan.h
--- a/drivers/usb/serial/keyspan.h~tty-switch-to-ktermios
+++ a/drivers/usb/serial/keyspan.h
@@ -59,7 +59,7 @@ static int  keyspan_ioctl		(struct usb_s
 					 unsigned int cmd,
 					 unsigned long arg);
 static void keyspan_set_termios		(struct usb_serial_port *port,
-					 struct termios *old);
+					 struct ktermios *old);
 static void keyspan_break_ctl		(struct usb_serial_port *port,
 					 int break_state);
 static int  keyspan_tiocmget		(struct usb_serial_port *port,
diff -puN drivers/usb/serial/keyspan_pda.c~tty-switch-to-ktermios drivers/usb/serial/keyspan_pda.c
--- a/drivers/usb/serial/keyspan_pda.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/keyspan_pda.c
@@ -365,7 +365,7 @@ static void keyspan_pda_break_ctl (struc
 
 
 static void keyspan_pda_set_termios (struct usb_serial_port *port, 
-				     struct termios *old_termios)
+				     struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	unsigned int cflag = port->tty->termios->c_cflag;
diff -puN drivers/usb/serial/kl5kusb105.c~tty-switch-to-ktermios drivers/usb/serial/kl5kusb105.c
--- a/drivers/usb/serial/kl5kusb105.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/kl5kusb105.c
@@ -86,7 +86,7 @@ static int  klsi_105_write_room         
 
 static void klsi_105_read_bulk_callback  (struct urb *urb);
 static void klsi_105_set_termios         (struct usb_serial_port *port,
-					  struct termios * old);
+					  struct ktermios *old);
 static int  klsi_105_ioctl	         (struct usb_serial_port *port,
 					  struct file * file,
 					  unsigned int cmd,
@@ -164,7 +164,7 @@ struct klsi_105_port_settings {
 #define URB_TRANSFER_BUFFER_SIZE	64
 struct klsi_105_private {
 	struct klsi_105_port_settings	cfg;
-	struct termios			termios;
+	struct ktermios			termios;
 	unsigned long			line_state; /* modem line settings */
 	/* write pool */
 	struct urb *			write_urb_pool[NUM_URBS];
@@ -688,7 +688,7 @@ static void klsi_105_read_bulk_callback 
 
 
 static void klsi_105_set_termios (struct usb_serial_port *port,
-				  struct termios *old_termios)
+				  struct ktermios *old_termios)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	unsigned int iflag = port->tty->termios->c_iflag;
diff -puN drivers/usb/serial/kobil_sct.c~tty-switch-to-ktermios drivers/usb/serial/kobil_sct.c
--- a/drivers/usb/serial/kobil_sct.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/kobil_sct.c
@@ -136,7 +136,7 @@ struct kobil_private {
 	int cur_pos; // index of the next char to send in buf
 	__u16 device_type;
 	int line_state;
-	struct termios internal_termios;
+	struct ktermios internal_termios;
 };
 
 
@@ -624,11 +624,11 @@ static int  kobil_ioctl(struct usb_seria
 
 	switch (cmd) {
 	case TCGETS:   // 0x5401
-		if (!access_ok(VERIFY_WRITE, user_arg, sizeof(struct termios))) {
+		if (!access_ok(VERIFY_WRITE, user_arg, sizeof(struct ktermios))) {
 			dbg("%s - port %d Error in access_ok", __FUNCTION__, port->number);
 			return -EFAULT;
 		}
-		if (kernel_termios_to_user_termios((struct termios __user *)arg,
+		if (kernel_termios_to_user_termios((struct ktermios __user *)arg,
 						   &priv->internal_termios))
 			return -EFAULT;
 		return 0;
@@ -638,12 +638,12 @@ static int  kobil_ioctl(struct usb_seria
 			dbg("%s - port %d Error: port->tty->termios is NULL", __FUNCTION__, port->number);
 			return -ENOTTY;
 		}
-		if (!access_ok(VERIFY_READ, user_arg, sizeof(struct termios))) {
+		if (!access_ok(VERIFY_READ, user_arg, sizeof(struct ktermios))) {
 			dbg("%s - port %d Error in access_ok", __FUNCTION__, port->number);
 			return -EFAULT;
 		}
 		if (user_termios_to_kernel_termios(&priv->internal_termios,
-						   (struct termios __user *)arg))
+						   (struct ktermios __user *)arg))
 			return -EFAULT;
 		
 		settings = kzalloc(50, GFP_KERNEL);
diff -puN drivers/usb/serial/mct_u232.c~tty-switch-to-ktermios drivers/usb/serial/mct_u232.c
--- a/drivers/usb/serial/mct_u232.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/mct_u232.c
@@ -98,7 +98,7 @@ static void mct_u232_close	         (str
 					  struct file *filp);
 static void mct_u232_read_int_callback   (struct urb *urb);
 static void mct_u232_set_termios         (struct usb_serial_port *port,
-					  struct termios * old);
+					  struct ktermios * old);
 static int  mct_u232_ioctl	         (struct usb_serial_port *port,
 					  struct file * file,
 					  unsigned int cmd,
@@ -556,7 +556,7 @@ exit:
 } /* mct_u232_read_int_callback */
 
 static void mct_u232_set_termios (struct usb_serial_port *port,
-				  struct termios *old_termios)
+				  struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
diff -puN drivers/usb/serial/mos7720.c~tty-switch-to-ktermios drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/mos7720.c
@@ -1014,7 +1014,7 @@ static int send_cmd_write_baud_rate(stru
  *      the specified new settings.
  */
 static void change_port_settings(struct moschip_port *mos7720_port,
-				 struct termios *old_termios)
+				 struct ktermios *old_termios)
 {
 	struct usb_serial_port *port;
 	struct usb_serial *serial;
@@ -1203,7 +1203,7 @@ static void change_port_settings(struct 
  *	termios structure.
  */
 static void mos7720_set_termios(struct usb_serial_port *port,
-				struct termios *old_termios)
+				struct ktermios *old_termios)
 {
 	int status;
 	unsigned int cflag;
diff -puN drivers/usb/serial/mos7840.c~tty-switch-to-ktermios drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/mos7840.c
@@ -1931,7 +1931,7 @@ static int mos7840_send_cmd_write_baud_r
  *****************************************************************************/
 
 static void mos7840_change_port_settings(struct moschip_port *mos7840_port,
-					 struct termios *old_termios)
+					 struct ktermios *old_termios)
 {
 	struct tty_struct *tty;
 	int baud;
@@ -2118,7 +2118,7 @@ static void mos7840_change_port_settings
  *****************************************************************************/
 
 static void mos7840_set_termios(struct usb_serial_port *port,
-				struct termios *old_termios)
+				struct ktermios *old_termios)
 {
 	int status;
 	unsigned int cflag;
diff -puN drivers/usb/serial/option.c~tty-switch-to-ktermios drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/option.c
@@ -59,7 +59,7 @@ static int  option_chars_in_buffer(struc
 static int  option_ioctl(struct usb_serial_port *port, struct file *file,
 			unsigned int cmd, unsigned long arg);
 static void option_set_termios(struct usb_serial_port *port,
-				struct termios *old);
+				struct ktermios *old);
 static void option_break_ctl(struct usb_serial_port *port, int break_state);
 static int  option_tiocmget(struct usb_serial_port *port, struct file *file);
 static int  option_tiocmset(struct usb_serial_port *port, struct file *file,
@@ -230,7 +230,7 @@ static void option_break_ctl(struct usb_
 }
 
 static void option_set_termios(struct usb_serial_port *port,
-			struct termios *old_termios)
+			struct ktermios *old_termios)
 {
 	dbg("%s", __FUNCTION__);
 
diff -puN drivers/usb/serial/pl2303.c~tty-switch-to-ktermios drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/pl2303.c
@@ -455,7 +455,7 @@ static int pl2303_chars_in_buffer(struct
 }
 
 static void pl2303_set_termios(struct usb_serial_port *port,
-			       struct termios *old_termios)
+			       struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
@@ -687,7 +687,7 @@ static void pl2303_close(struct usb_seri
 
 static int pl2303_open(struct usb_serial_port *port, struct file *filp)
 {
-	struct termios tmp_termios;
+	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned char *buf;
diff -puN drivers/usb/serial/sierra.c~tty-switch-to-ktermios drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/sierra.c
@@ -145,7 +145,7 @@ static void sierra_break_ctl(struct usb_
 }
 
 static void sierra_set_termios(struct usb_serial_port *port,
-			struct termios *old_termios)
+			struct ktermios *old_termios)
 {
 	dbg("%s", __FUNCTION__);
 
diff -puN drivers/usb/serial/ti_usb_3410_5052.c~tty-switch-to-ktermios drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -161,7 +161,7 @@ static void ti_throttle(struct usb_seria
 static void ti_unthrottle(struct usb_serial_port *port);
 static int ti_ioctl(struct usb_serial_port *port, struct file *file, unsigned int cmd, unsigned long arg);
 static void ti_set_termios(struct usb_serial_port *port,
-	struct termios *old_termios);
+	struct ktermios *old_termios);
 static int ti_tiocmget(struct usb_serial_port *port, struct file *file);
 static int ti_tiocmset(struct usb_serial_port *port, struct file *file,
 	unsigned int set, unsigned int clear);
@@ -881,7 +881,7 @@ static int ti_ioctl(struct usb_serial_po
 
 
 static void ti_set_termios(struct usb_serial_port *port,
-	struct termios *old_termios)
+	struct ktermios *old_termios)
 {
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	struct tty_struct *tty = port->tty;
diff -puN drivers/usb/serial/usb-serial.c~tty-switch-to-ktermios drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/usb-serial.c
@@ -397,7 +397,7 @@ exit:
 	return retval;
 }
 
-static void serial_set_termios (struct tty_struct *tty, struct termios * old)
+static void serial_set_termios (struct tty_struct *tty, struct ktermios * old)
 {
 	struct usb_serial_port *port = tty->driver_data;
 
diff -puN drivers/usb/serial/visor.c~tty-switch-to-ktermios drivers/usb/serial/visor.c
--- a/drivers/usb/serial/visor.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/visor.c
@@ -46,7 +46,7 @@ static int  visor_probe		(struct usb_ser
 static int  visor_calc_num_ports(struct usb_serial *serial);
 static void visor_shutdown	(struct usb_serial *serial);
 static int  visor_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void visor_set_termios	(struct usb_serial_port *port, struct termios *old_termios);
+static void visor_set_termios	(struct usb_serial_port *port, struct ktermios *old_termios);
 static void visor_write_bulk_callback	(struct urb *urb);
 static void visor_read_bulk_callback	(struct urb *urb);
 static void visor_read_int_callback	(struct urb *urb);
@@ -916,7 +916,7 @@ static int visor_ioctl (struct usb_seria
 
 
 /* This function is all nice and good, but we don't change anything based on it :) */
-static void visor_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void visor_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	unsigned int cflag;
 
diff -puN drivers/usb/serial/whiteheat.c~tty-switch-to-ktermios drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~tty-switch-to-ktermios
+++ a/drivers/usb/serial/whiteheat.c
@@ -145,7 +145,7 @@ static void whiteheat_close		(struct usb
 static int  whiteheat_write		(struct usb_serial_port *port, const unsigned char *buf, int count);
 static int  whiteheat_write_room	(struct usb_serial_port *port);
 static int  whiteheat_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void whiteheat_set_termios	(struct usb_serial_port *port, struct termios * old);
+static void whiteheat_set_termios	(struct usb_serial_port *port, struct ktermios * old);
 static int  whiteheat_tiocmget		(struct usb_serial_port *port, struct file *file);
 static int  whiteheat_tiocmset		(struct usb_serial_port *port, struct file *file, unsigned int set, unsigned int clear);
 static void whiteheat_break_ctl		(struct usb_serial_port *port, int break_state);
@@ -597,7 +597,7 @@ static void whiteheat_shutdown (struct u
 static int whiteheat_open (struct usb_serial_port *port, struct file *filp)
 {
 	int		retval = 0;
-	struct termios	old_term;
+	struct ktermios	old_term;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
@@ -870,7 +870,7 @@ static int whiteheat_ioctl (struct usb_s
 }
 
 
-static void whiteheat_set_termios (struct usb_serial_port *port, struct termios *old_termios)
+static void whiteheat_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	dbg("%s -port %d", __FUNCTION__, port->number);
 
diff -puN include/asm-generic/termios.h~tty-switch-to-ktermios include/asm-generic/termios.h
--- a/include/asm-generic/termios.h~tty-switch-to-ktermios
+++ a/include/asm-generic/termios.h
@@ -11,7 +11,7 @@
 /*
  * Translate a "termio" structure into a "termios". Ugh.
  */
-static inline int user_termio_to_kernel_termios(struct termios *termios,
+static inline int user_termio_to_kernel_termios(struct ktermios *termios,
 						struct termio __user *termio)
 {
 	unsigned short tmp;
@@ -48,7 +48,7 @@ static inline int user_termio_to_kernel_
  * Translate a "termios" structure into a "termio". Ugh.
  */
 static inline int kernel_termios_to_user_termio(struct termio __user *termio,
-						struct termios *termios)
+						struct ktermios *termios)
 {
 	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
 	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
diff -puN include/asm-powerpc/termbits.h~tty-switch-to-ktermios include/asm-powerpc/termbits.h
--- a/include/asm-powerpc/termbits.h~tty-switch-to-ktermios
+++ a/include/asm-powerpc/termbits.h
@@ -37,8 +37,8 @@ struct ktermios {
 	tcflag_t c_oflag;		/* output mode flags */
 	tcflag_t c_cflag;		/* control mode flags */
 	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
 	cc_t c_cc[NCCS];		/* control characters */
+	cc_t c_line;			/* line discipline (== c_cc[19]) */
 	speed_t c_ispeed;		/* input speed */
 	speed_t c_ospeed;		/* output speed */
 };
diff -puN include/linux/generic_serial.h~tty-switch-to-ktermios include/linux/generic_serial.h
--- a/include/linux/generic_serial.h~tty-switch-to-ktermios
+++ a/include/linux/generic_serial.h
@@ -91,7 +91,7 @@ void gs_hangup(struct tty_struct *tty);
 int  gs_block_til_ready(void *port, struct file *filp);
 void gs_close(struct tty_struct *tty, struct file *filp);
 void gs_set_termios (struct tty_struct * tty, 
-                     struct termios * old_termios);
+                     struct ktermios * old_termios);
 int  gs_init_port(struct gs_port *port);
 int  gs_setserial(struct gs_port *port, struct serial_struct __user *sp);
 int  gs_getserial(struct gs_port *port, struct serial_struct __user *sp);
diff -puN include/linux/isdn.h~tty-switch-to-ktermios include/linux/isdn.h
--- a/include/linux/isdn.h~tty-switch-to-ktermios
+++ a/include/linux/isdn.h
@@ -511,8 +511,8 @@ typedef struct modem_info {
 #endif
   struct tty_struct 	*tty;            /* Pointer to corresponding tty   */
   atemu                 emu;             /* AT-emulator data               */
-  struct termios	normal_termios;  /* For saving termios structs     */
-  struct termios	callout_termios;
+  struct ktermios	normal_termios;  /* For saving termios structs     */
+  struct ktermios	callout_termios;
   wait_queue_head_t	open_wait, close_wait;
   struct semaphore      write_sem;
   spinlock_t	        readlock;
@@ -525,8 +525,8 @@ typedef struct _isdn_modem {
   int                refcount;				/* Number of opens        */
   struct tty_driver  *tty_modem;			/* tty-device             */
   struct tty_struct  *modem_table[ISDN_MAX_CHANNELS];	/* ?? copied from Orig    */
-  struct termios     *modem_termios[ISDN_MAX_CHANNELS];
-  struct termios     *modem_termios_locked[ISDN_MAX_CHANNELS];
+  struct ktermios     *modem_termios[ISDN_MAX_CHANNELS];
+  struct ktermios     *modem_termios_locked[ISDN_MAX_CHANNELS];
   modem_info         info[ISDN_MAX_CHANNELS];	   /* Private data           */
 } isdn_modem_t;
 
diff -puN include/linux/serial_core.h~tty-switch-to-ktermios include/linux/serial_core.h
--- a/include/linux/serial_core.h~tty-switch-to-ktermios
+++ a/include/linux/serial_core.h
@@ -166,8 +166,8 @@ struct uart_ops {
 	void		(*break_ctl)(struct uart_port *, int ctl);
 	int		(*startup)(struct uart_port *);
 	void		(*shutdown)(struct uart_port *);
-	void		(*set_termios)(struct uart_port *, struct termios *new,
-				       struct termios *old);
+	void		(*set_termios)(struct uart_port *, struct ktermios *new,
+				       struct ktermios *old);
 	void		(*pm)(struct uart_port *, unsigned int state,
 			      unsigned int oldstate);
 	int		(*set_wake)(struct uart_port *, unsigned int state);
@@ -361,8 +361,8 @@ void uart_write_wakeup(struct uart_port 
  */
 void uart_update_timeout(struct uart_port *port, unsigned int cflag,
 			 unsigned int baud);
-unsigned int uart_get_baud_rate(struct uart_port *port, struct termios *termios,
-				struct termios *old, unsigned int min,
+unsigned int uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
+				struct ktermios *old, unsigned int min,
 				unsigned int max);
 unsigned int uart_get_divisor(struct uart_port *port, unsigned int baud);
 
diff -puN include/linux/usb/serial.h~tty-switch-to-ktermios include/linux/usb/serial.h
--- a/include/linux/usb/serial.h~tty-switch-to-ktermios
+++ a/include/linux/usb/serial.h
@@ -218,7 +218,7 @@ struct usb_serial_driver {
 	int  (*write)		(struct usb_serial_port *port, const unsigned char *buf, int count);
 	int  (*write_room)	(struct usb_serial_port *port);
 	int  (*ioctl)		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-	void (*set_termios)	(struct usb_serial_port *port, struct termios * old);
+	void (*set_termios)	(struct usb_serial_port *port, struct ktermios * old);
 	void (*break_ctl)	(struct usb_serial_port *port, int break_state);
 	int  (*chars_in_buffer)	(struct usb_serial_port *port);
 	void (*throttle)	(struct usb_serial_port *port);
diff -puN net/bluetooth/rfcomm/tty.c~tty-switch-to-ktermios net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~tty-switch-to-ktermios
+++ a/net/bluetooth/rfcomm/tty.c
@@ -752,9 +752,9 @@ static int rfcomm_tty_ioctl(struct tty_s
 	return -ENOIOCTLCMD;
 }
 
-static void rfcomm_tty_set_termios(struct tty_struct *tty, struct termios *old)
+static void rfcomm_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	struct termios *new = (struct termios *) tty->termios;
+	struct ktermios *new = tty->termios;
 	int old_baud_rate = tty_termios_baud_rate(old);
 	int new_baud_rate = tty_termios_baud_rate(new);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty-switch-to-ktermios.patch
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

