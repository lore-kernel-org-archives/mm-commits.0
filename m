From: akpm@linux-foundation.org
Subject: + epca-coding-style.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:21:13 -0700
Message-ID: <200804291921.m3TJLDIO005391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbYD2TWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     epca: coding style
has been added to the -mm tree.  Its filename is
     epca-coding-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epca: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Clean up the epca driver

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.c |  276 ++++++++++++++++++++++++------------------
 1 file changed, 158 insertions(+), 118 deletions(-)

diff -puN drivers/char/epca.c~epca-coding-style drivers/char/epca.c
--- a/drivers/char/epca.c~epca-coding-style
+++ a/drivers/char/epca.c
@@ -38,8 +38,8 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include "digiPCI.h"
@@ -73,7 +73,8 @@ static int invalid_lilo_config;
  */
 static DEFINE_SPINLOCK(epca_lock);
 
-/* MAXBOARDS is typically 12, but ISA and EISA cards are restricted to 7 below. */
+/* MAXBOARDS is typically 12, but ISA and EISA cards are restricted
+   to 7 below. */
 static struct board_info boards[MAXBOARDS];
 
 static struct tty_driver *pc_driver;
@@ -163,7 +164,7 @@ static int pc_chars_in_buffer(struct tty
 static void pc_flush_buffer(struct tty_struct *);
 static void pc_flush_chars(struct tty_struct *);
 static int block_til_ready(struct tty_struct *, struct file *,
-                           struct channel *);
+			struct channel *);
 static int pc_open(struct tty_struct *, struct file *);
 static void post_fep_init(unsigned int crd);
 static void epcapoll(unsigned long);
@@ -175,18 +176,18 @@ static unsigned termios2digi_c(struct ch
 static void epcaparam(struct tty_struct *, struct channel *);
 static void receive_data(struct channel *);
 static int pc_ioctl(struct tty_struct *, struct file *,
-                    unsigned int, unsigned long);
+			unsigned int, unsigned long);
 static int info_ioctl(struct tty_struct *, struct file *,
-                    unsigned int, unsigned long);
+			unsigned int, unsigned long);
 static void pc_set_termios(struct tty_struct *, struct ktermios *);
 static void do_softint(struct work_struct *work);
 static void pc_stop(struct tty_struct *);
 static void pc_start(struct tty_struct *);
-static void pc_throttle(struct tty_struct * tty);
+static void pc_throttle(struct tty_struct *tty);
 static void pc_unthrottle(struct tty_struct *tty);
 static void digi_send_break(struct channel *ch, int msec);
 static void setup_empty_event(struct tty_struct *tty, struct channel *ch);
-void epca_setup(char *, int *);
+static void epca_setup(char *, int *);
 
 static int pc_write(struct tty_struct *, const unsigned char *, int);
 static int pc_init(void);
@@ -243,7 +244,7 @@ static void assertmemoff(struct channel 
 /* PCXEM windowing is the same as that used in the PCXR and CX series cards. */
 static void pcxem_memwinon(struct board_info *b, unsigned int win)
 {
-        outb_p(FEPWIN|win, b->port + 1);
+	outb_p(FEPWIN | win, b->port + 1);
 }
 
 static void pcxem_memwinoff(struct board_info *b, unsigned int win)
@@ -253,7 +254,7 @@ static void pcxem_memwinoff(struct board
 
 static void pcxem_globalwinon(struct channel *ch)
 {
-	outb_p( FEPWIN, (int)ch->board->port + 1);
+	outb_p(FEPWIN, (int)ch->board->port + 1);
 }
 
 static void pcxem_rxwinon(struct channel *ch)
@@ -394,7 +395,7 @@ static struct channel *verifyChannel(str
 	 */
 	if (tty) {
 		struct channel *ch = (struct channel *)tty->driver_data;
-		if ((ch >= &digi_channels[0]) && (ch < &digi_channels[nbdevs])) {
+		if (ch >= &digi_channels[0] && ch < &digi_channels[nbdevs]) {
 			if (ch->magic == EPCA_MAGIC)
 				return ch;
 		}
@@ -414,7 +415,7 @@ static void pc_sched_event(struct channe
 
 static void epca_error(int line, char *msg)
 {
-	printk(KERN_ERR "epca_error (Digi): line = %d %s\n",line,msg);
+	printk(KERN_ERR "epca_error (Digi): line = %d %s\n", line, msg);
 }
 
 static void pc_close(struct tty_struct *tty, struct file *filp)
@@ -425,7 +426,8 @@ static void pc_close(struct tty_struct *
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		if (tty_hung_up_p(filp)) {
 			spin_unlock_irqrestore(&epca_lock, flags);
@@ -440,7 +442,6 @@ static void pc_close(struct tty_struct *
 			spin_unlock_irqrestore(&epca_lock, flags);
 			return;
 		}
-
 		/* Port open only once go ahead with shutdown & reset */
 		BUG_ON(ch->count < 0);
 
@@ -455,9 +456,11 @@ static void pc_close(struct tty_struct *
 		spin_unlock_irqrestore(&epca_lock, flags);
 
 		if (ch->asyncflags & ASYNC_INITIALIZED)  {
-			/* Setup an event to indicate when the transmit buffer empties */
+			/* Setup an event to indicate when the
+			   transmit buffer empties */
 			setup_empty_event(tty, ch);
-			tty_wait_until_sent(tty, 3000); /* 30 seconds timeout */
+			/* 30 seconds timeout */
+			tty_wait_until_sent(tty, 3000);
 		}
 		if (tty->driver->flush_buffer)
 			tty->driver->flush_buffer(tty);
@@ -477,7 +480,7 @@ static void pc_close(struct tty_struct *
 			wake_up_interruptible(&ch->open_wait);
 		}
 		ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_INITIALIZED |
-		                      ASYNC_CLOSING);
+					ASYNC_CLOSING);
 		wake_up_interruptible(&ch->close_wait);
 	}
 }
@@ -524,12 +527,12 @@ static void shutdown(struct channel *ch)
 static void pc_hangup(struct tty_struct *tty)
 {
 	struct channel *ch;
-
 	/*
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		unsigned long flags;
 
 		if (tty->driver->flush_buffer)
@@ -548,7 +551,7 @@ static void pc_hangup(struct tty_struct 
 }
 
 static int pc_write(struct tty_struct *tty,
-                    const unsigned char *buf, int bytesAvailable)
+			const unsigned char *buf, int bytesAvailable)
 {
 	unsigned int head, tail;
 	int dataLen;
@@ -572,7 +575,8 @@ static int pc_write(struct tty_struct *t
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) == NULL)
+	ch = verifyChannel(tty);
+	if (ch == NULL)
 		return 0;
 
 	/* Make a pointer to the channel data structure found on the board. */
@@ -652,19 +656,17 @@ static void pc_put_char(struct tty_struc
 
 static int pc_write_room(struct tty_struct *tty)
 {
-	int remain;
+	int remain = 0;
 	struct channel *ch;
 	unsigned long flags;
 	unsigned int head, tail;
 	struct board_chan __iomem *bc;
-
-	remain = 0;
-
 	/*
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL)  {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		globalwinon(ch);
 
@@ -676,8 +678,8 @@ static int pc_write_room(struct tty_stru
 			tail = readw(&bc->tout);
 		/* Wrap tail if necessary */
 		tail &= (ch->txbufsize - 1);
-
-		if ((remain = tail - head - 1) < 0 )
+		remain = tail - head - 1;
+		if (remain < 0)
 			remain += ch->txbufsize;
 
 		if (remain && (ch->statusflags & LOWWAIT) == 0) {
@@ -699,12 +701,12 @@ static int pc_chars_in_buffer(struct tty
 	unsigned long flags;
 	struct channel *ch;
 	struct board_chan __iomem *bc;
-
 	/*
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) == NULL)
+	ch = verifyChannel(tty);
+	if (ch == NULL)
 		return 0;
 
 	spin_lock_irqsave(&epca_lock, flags);
@@ -715,7 +717,8 @@ static int pc_chars_in_buffer(struct tty
 	head = readw(&bc->tin);
 	ctail = readw(&ch->mailbox->cout);
 
-	if (tail == head && readw(&ch->mailbox->cin) == ctail && readb(&bc->tbusy) == 0)
+	if (tail == head && readw(&ch->mailbox->cin) == ctail &&
+						readb(&bc->tbusy) == 0)
 		chars = 0;
 	else  { /* Begin if some space on the card has been used */
 		head = readw(&bc->tin) & (ch->txbufsize - 1);
@@ -725,7 +728,8 @@ static int pc_chars_in_buffer(struct tty
 		 * pc_write_room here we are finding the amount of bytes in the
 		 * buffer filled. Not the amount of bytes empty.
 		 */
-		if ((remain = tail - head - 1) < 0 )
+		remain = tail - head - 1;
+		if (remain < 0)
 			remain += ch->txbufsize;
 		chars = (int)(ch->txbufsize - remain);
 		/*
@@ -736,7 +740,7 @@ static int pc_chars_in_buffer(struct tty
 		 * transmit buffer empties.
 		 */
 		if (!(ch->statusflags & EMPTYWAIT))
-			setup_empty_event(tty,ch);
+			setup_empty_event(tty, ch);
 	} /* End if some space on the card has been used */
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
@@ -754,7 +758,8 @@ static void pc_flush_buffer(struct tty_s
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) == NULL)
+	ch = verifyChannel(tty);
+	if (ch == NULL)
 		return;
 
 	spin_lock_irqsave(&epca_lock, flags);
@@ -775,23 +780,25 @@ static void pc_flush_chars(struct tty_st
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		unsigned long flags;
 		spin_lock_irqsave(&epca_lock, flags);
 		/*
 		 * If not already set and the transmitter is busy setup an
 		 * event to indicate when the transmit empties.
 		 */
-		if ((ch->statusflags & TXBUSY) && !(ch->statusflags & EMPTYWAIT))
-			setup_empty_event(tty,ch);
+		if ((ch->statusflags & TXBUSY) &&
+				!(ch->statusflags & EMPTYWAIT))
+			setup_empty_event(tty, ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 	}
 }
 
 static int block_til_ready(struct tty_struct *tty,
-                           struct file *filp, struct channel *ch)
+				struct file *filp, struct channel *ch)
 {
-	DECLARE_WAITQUEUE(wait,current);
+	DECLARE_WAITQUEUE(wait, current);
 	int retval, do_clocal = 0;
 	unsigned long flags;
 
@@ -839,8 +846,7 @@ static int block_til_ready(struct tty_st
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(ch->asyncflags & ASYNC_INITIALIZED))
-		{
+				!(ch->asyncflags & ASYNC_INITIALIZED)) {
 			if (ch->asyncflags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
@@ -880,7 +886,7 @@ static int block_til_ready(struct tty_st
 	return 0;
 }
 
-static int pc_open(struct tty_struct *tty, struct file * filp)
+static int pc_open(struct tty_struct *tty, struct file *filp)
 {
 	struct channel *ch;
 	unsigned long flags;
@@ -965,7 +971,7 @@ static int pc_open(struct tty_struct *tt
 	 * The below routine generally sets up parity, baud, flow control
 	 * issues, etc.... It effect both control flags and input flags.
 	 */
-	epcaparam(tty,ch);
+	epcaparam(tty, ch);
 	ch->asyncflags |= ASYNC_INITIALIZED;
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
@@ -1003,8 +1009,8 @@ static void __exit epca_module_exit(void
 
 	del_timer_sync(&epca_timer);
 
-	if (tty_unregister_driver(pc_driver) || tty_unregister_driver(pc_info))
-	{
+	if (tty_unregister_driver(pc_driver) ||
+				tty_unregister_driver(pc_info)) {
 		printk(KERN_WARNING "epca: cleanup_module failed to un-register tty driver\n");
 		return;
 	}
@@ -1045,7 +1051,7 @@ static const struct tty_operations pc_op
 	.hangup = pc_hangup,
 };
 
-static int info_open(struct tty_struct *tty, struct file * filp)
+static int info_open(struct tty_struct *tty, struct file *filp)
 {
 	return 0;
 }
@@ -1100,7 +1106,7 @@ static int __init pc_init(void)
 	 * Set up interrupt, we will worry about memory allocation in
 	 * post_fep_init.
 	 */
-	printk(KERN_INFO "DIGI epca driver version %s loaded.\n",VERSION);
+	printk(KERN_INFO "DIGI epca driver version %s loaded.\n", VERSION);
 
 	/*
 	 * NOTE : This code assumes that the number of ports found in the
@@ -1253,7 +1259,7 @@ static int __init pc_init(void)
 				if ((board_id & 0x30) == 0x30)
 					bd->memory_seg = 0x8000;
 			} else
-				printk(KERN_ERR "epca: Board at 0x%x doesn't appear to be an XI\n",(int)bd->port);
+				printk(KERN_ERR "epca: Board at 0x%x doesn't appear to be an XI\n", (int)bd->port);
 			break;
 		}
 	}
@@ -1327,12 +1333,12 @@ static void post_fep_init(unsigned int c
 		 */
 		/* PCI cards are already remapped at this point ISA are not */
 		bd->numports = readw(bd->re_map_membase + XEMPORTS);
-		epcaassert(bd->numports <= 64,"PCI returned a invalid number of ports");
+		epcaassert(bd->numports <= 64, "PCI returned a invalid number of ports");
 		nbdevs += (bd->numports);
 	} else {
 		/* Fix up the mappings for ISA/EISA etc */
 		/* FIXME: 64K - can we be smarter ? */
-		bd->re_map_membase = ioremap(bd->membase, 0x10000);
+		bd->re_map_membase = ioremap_nocache(bd->membase, 0x10000);
 	}
 
 	if (crd != 0)
@@ -1363,7 +1369,8 @@ static void post_fep_init(unsigned int c
 	 * XEPORTS (address 0xc22) points at the number of channels the card
 	 * supports. (For 64XE, XI, XEM, and XR use 0xc02)
 	 */
-	if ((bd->type == PCXEVE || bd->type == PCXE) && (readw(memaddr + XEPORTS) < 3))
+	if ((bd->type == PCXEVE || bd->type == PCXE) &&
+					(readw(memaddr + XEPORTS) < 3))
 		shrinkmem = 1;
 	if (bd->type < PCIXEM)
 		if (!request_region((int)bd->port, 4, board_desc[bd->type]))
@@ -1462,10 +1469,12 @@ static void post_fep_init(unsigned int c
 
 		case PCXEVE:
 		case PCXE:
-			ch->txptr = memaddr + (((tseg - bd->memory_seg) << 4) & 0x1fff);
+			ch->txptr = memaddr + (((tseg - bd->memory_seg) << 4)
+								& 0x1fff);
 			ch->txwin = FEPWIN | ((tseg - bd->memory_seg) >> 9);
-			ch->rxptr = memaddr + (((rseg - bd->memory_seg) << 4) & 0x1fff);
-			ch->rxwin = FEPWIN | ((rseg - bd->memory_seg) >>9 );
+			ch->rxptr = memaddr + (((rseg - bd->memory_seg) << 4)
+								& 0x1fff);
+			ch->rxwin = FEPWIN | ((rseg - bd->memory_seg) >> 9);
 			break;
 
 		case PCXI:
@@ -1519,8 +1528,9 @@ static void post_fep_init(unsigned int c
 	}
 
 	printk(KERN_INFO
-	        "Digi PC/Xx Driver V%s:  %s I/O = 0x%lx Mem = 0x%lx Ports = %d\n",
-	        VERSION, board_desc[bd->type], (long)bd->port, (long)bd->membase, bd->numports);
+	"Digi PC/Xx Driver V%s:  %s I/O = 0x%lx Mem = 0x%lx Ports = %d\n",
+				VERSION, board_desc[bd->type], (long)bd->port,
+					(long)bd->membase, bd->numports);
 	memwinoff(bd, 0);
 }
 
@@ -1528,7 +1538,7 @@ static void epcapoll(unsigned long ignor
 {
 	unsigned long flags;
 	int crd;
-	volatile unsigned int head, tail;
+	unsigned int head, tail;
 	struct channel *ch;
 	struct board_info *bd;
 
@@ -1594,7 +1604,9 @@ static void doevent(int crd)
 	chan0 = card_ptr[crd];
 	epcaassert(chan0 <= &digi_channels[nbdevs - 1], "ch out of range");
 	assertgwinon(chan0);
-	while ((tail = readw(&chan0->mailbox->eout)) != (head = readw(&chan0->mailbox->ein))) { /* Begin while something in event queue */
+	while ((tail = readw(&chan0->mailbox->eout)) !=
+			(head = readw(&chan0->mailbox->ein))) {
+		/* Begin while something in event queue */
 		assertgwinon(chan0);
 		eventbuf = bd->re_map_membase + tail + ISTART;
 		/* Get the channel the event occurred on */
@@ -1618,7 +1630,8 @@ static void doevent(int crd)
 			goto next;
 		}
 
-		if ((bc = ch->brdchan) == NULL)
+		bc = ch->brdchan;
+		if (bc == NULL)
 			goto next;
 
 		if (event & DATA_IND)  { /* Begin DATA_IND */
@@ -1630,10 +1643,11 @@ static void doevent(int crd)
 			/* A modem signal change has been indicated */
 			ch->imodem = mstat;
 			if (ch->asyncflags & ASYNC_CHECK_CD) {
-				if (mstat & ch->dcd)  /* We are now receiving dcd */
+				/* We are now receiving dcd */
+				if (mstat & ch->dcd)
 					wake_up_interruptible(&ch->open_wait);
-				else
-					pc_sched_event(ch, EPCA_EVENT_HANGUP); /* No dcd; hangup */
+				else	/* No dcd; hangup */
+					pc_sched_event(ch, EPCA_EVENT_HANGUP);
 			}
 		}
 		tty = ch->tty;
@@ -1648,7 +1662,8 @@ static void doevent(int crd)
 					tty_wakeup(tty);
 				}
 			} else if (event & EMPTYTX_IND) {
-				/* This event is generated by setup_empty_event */
+				/* This event is generated by
+				   setup_empty_event */
 				ch->statusflags &= ~TXBUSY;
 				if (ch->statusflags & EMPTYWAIT) {
 					ch->statusflags &= ~EMPTYWAIT;
@@ -1656,7 +1671,7 @@ static void doevent(int crd)
 				}
 			}
 		}
-	next:
+next:
 		globalwinon(ch);
 		BUG_ON(!bc);
 		writew(1, &bc->idata);
@@ -1666,7 +1681,7 @@ static void doevent(int crd)
 }
 
 static void fepcmd(struct channel *ch, int cmd, int word_or_byte,
-                   int byte2, int ncmds, int bytecmd)
+					int byte2, int ncmds, int bytecmd)
 {
 	unchar __iomem *memaddr;
 	unsigned int head, cmdTail, cmdStart, cmdMax;
@@ -1691,8 +1706,10 @@ static void fepcmd(struct channel *ch, i
 	memaddr = ch->board->re_map_membase;
 
 	if (head >= (cmdMax - cmdStart) || (head & 03))  {
-		printk(KERN_ERR "line %d: Out of range, cmd = %x, head = %x\n", __LINE__,  cmd, head);
-		printk(KERN_ERR "line %d: Out of range, cmdMax = %x, cmdStart = %x\n", __LINE__,  cmdMax, cmdStart);
+		printk(KERN_ERR "line %d: Out of range, cmd = %x, head = %x\n",
+						__LINE__,  cmd, head);
+		printk(KERN_ERR "line %d: Out of range, cmdMax = %x, cmdStart = %x\n",
+						__LINE__,  cmdMax, cmdStart);
 		return;
 	}
 	if (bytecmd)  {
@@ -1771,7 +1788,7 @@ static unsigned termios2digi_h(struct ch
 static unsigned termios2digi_i(struct channel *ch, unsigned iflag)
 {
 	unsigned res = iflag & (IGNBRK | BRKINT | IGNPAR | PARMRK |
-	                        INPCK | ISTRIP|IXON|IXANY|IXOFF);
+					INPCK | ISTRIP | IXON | IXANY | IXOFF);
 	if (ch->digiext.digi_flags & DIGI_AIXON)
 		res |= IAIXON;
 	return res;
@@ -1885,8 +1902,10 @@ static void epcaparam(struct tty_struct 
 		 * Command sets channels iflag structure on the board. Such
 		 * things as input soft flow control, handling of parity
 		 * errors, and break handling are all set here.
+		 *
+		 * break handling, parity handling, input stripping,
+		 * flow control chars
 		 */
-		/* break handling, parity handling, input stripping, flow control chars */
 		fepcmd(ch, SETIFLAGS, (unsigned int) ch->fepiflag, 0, 0, 0);
 	}
 	/*
@@ -1982,7 +2001,7 @@ static void receive_data(struct channel 
 		return;
 
 	/* If CREAD bit is off or device not open, set TX tail to head */
-	if (!tty || !ts || !(ts->c_cflag & CREAD))  {
+	if (!tty || !ts || !(ts->c_cflag & CREAD)) {
 		writew(head, &bc->rout);
 		return;
 	}
@@ -1992,18 +2011,21 @@ static void receive_data(struct channel 
 
 	if (readb(&bc->orun)) {
 		writeb(0, &bc->orun);
-		printk(KERN_WARNING "epca; overrun! DigiBoard device %s\n",tty->name);
+		printk(KERN_WARNING "epca; overrun! DigiBoard device %s\n",
+								tty->name);
 		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 	}
 	rxwinon(ch);
-	while (bytesAvailable > 0)  { /* Begin while there is data on the card */
+	while (bytesAvailable > 0) {
+		/* Begin while there is data on the card */
 		wrapgap = (head >= tail) ? head - tail : ch->rxbufsize - tail;
 		/*
 		 * Even if head has wrapped around only report the amount of
 		 * data to be equal to the size - tail. Remember memcpy can't
 		 * automaticly wrap around the receive buffer.
 		 */
-		dataToRead = (wrapgap < bytesAvailable) ? wrapgap : bytesAvailable;
+		dataToRead = (wrapgap < bytesAvailable) ? wrapgap
+							: bytesAvailable;
 		/* Make sure we don't overflow the buffer */
 		dataToRead = tty_prepare_flip_string(tty, &rptr, dataToRead);
 		if (dataToRead == 0)
@@ -2154,14 +2176,14 @@ static int pc_tiocmset(struct tty_struct
 	 * The below routine generally sets up parity, baud, flow control
 	 * issues, etc.... It effect both control flags and input flags.
 	 */
-	epcaparam(tty,ch);
+	epcaparam(tty, ch);
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
 	return 0;
 }
 
-static int pc_ioctl(struct tty_struct *tty, struct file * file,
-		    unsigned int cmd, unsigned long arg)
+static int pc_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	digiflow_t dflow;
 	int retval;
@@ -2176,7 +2198,6 @@ static int pc_ioctl(struct tty_struct *t
 		bc = ch->brdchan;
 	else
 		return -EINVAL;
-
 	/*
 	 * For POSIX compliance we need to add more ioctls. See tty_ioctl.c in
 	 * /usr/src/linux/drivers/char for a good example. In particular think
@@ -2187,9 +2208,10 @@ static int pc_ioctl(struct tty_struct *t
 		retval = tty_check_change(tty);
 		if (retval)
 			return retval;
-		/* Setup an event to indicate when the transmit buffer empties */
+		/* Setup an event to indicate when the transmit
+		   buffer empties */
 		spin_lock_irqsave(&epca_lock, flags);
-		setup_empty_event(tty,ch);
+		setup_empty_event(tty, ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 		tty_wait_until_sent(tty, 0);
 		if (!arg)
@@ -2199,10 +2221,10 @@ static int pc_ioctl(struct tty_struct *t
 		retval = tty_check_change(tty);
 		if (retval)
 			return retval;
-
-		/* Setup an event to indicate when the transmit buffer empties */
+		/* Setup an event to indicate when the transmit buffer
+		   empties */
 		spin_lock_irqsave(&epca_lock, flags);
-		setup_empty_event(tty,ch);
+		setup_empty_event(tty, ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 		tty_wait_until_sent(tty, 0);
 		digi_send_break(ch, arg ? arg*(HZ/10) : HZ/4);
@@ -2241,9 +2263,10 @@ static int pc_ioctl(struct tty_struct *t
 	case DIGI_SETAF:
 		lock_kernel();
 		if (cmd == DIGI_SETAW) {
-			/* Setup an event to indicate when the transmit buffer empties */
+			/* Setup an event to indicate when the transmit
+			   buffer empties */
 			spin_lock_irqsave(&epca_lock, flags);
-			setup_empty_event(tty,ch);
+			setup_empty_event(tty, ch);
 			spin_unlock_irqrestore(&epca_lock, flags);
 			tty_wait_until_sent(tty, 0);
 		} else {
@@ -2273,7 +2296,7 @@ static int pc_ioctl(struct tty_struct *t
 		 * control issues, etc.... It effect both control flags and
 		 * input flags.
 		 */
-		epcaparam(tty,ch);
+		epcaparam(tty, ch);
 		memoff(ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 		break;
@@ -2309,18 +2332,21 @@ static int pc_ioctl(struct tty_struct *t
 		if (copy_from_user(&dflow, argp, sizeof(dflow)))
 			return -EFAULT;
 
-		if (dflow.startc != startc || dflow.stopc != stopc) { /* Begin  if setflow toggled */
+		if (dflow.startc != startc || dflow.stopc != stopc) {
+			/* Begin  if setflow toggled */
 			spin_lock_irqsave(&epca_lock, flags);
 			globalwinon(ch);
 
 			if (cmd == DIGI_SETFLOW) {
 				ch->fepstartc = ch->startc = dflow.startc;
 				ch->fepstopc = ch->stopc = dflow.stopc;
-				fepcmd(ch, SONOFFC, ch->fepstartc, ch->fepstopc, 0, 1);
+				fepcmd(ch, SONOFFC, ch->fepstartc,
+						ch->fepstopc, 0, 1);
 			} else {
 				ch->fepstartca = ch->startca = dflow.startc;
 				ch->fepstopca  = ch->stopca = dflow.stopc;
-				fepcmd(ch, SAUXONOFFC, ch->fepstartca, ch->fepstopca, 0, 1);
+				fepcmd(ch, SAUXONOFFC, ch->fepstartca,
+						ch->fepstopca, 0, 1);
 			}
 
 			if (ch->statusflags & TXSTOPPED)
@@ -2344,7 +2370,9 @@ static void pc_set_termios(struct tty_st
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if channel valid */
+	ch = verifyChannel(tty);
+
+	if (ch != NULL)  { /* Begin if channel valid */
 		spin_lock_irqsave(&epca_lock, flags);
 		globalwinon(ch);
 		epcaparam(tty, ch);
@@ -2371,7 +2399,7 @@ static void do_softint(struct work_struc
 
 		if (tty && tty->driver_data) {
 			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
-				tty_hangup(tty);	/* FIXME: module removal race here - AKPM */
+				tty_hangup(tty);
 				wake_up_interruptible(&ch->open_wait);
 				ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
 			}
@@ -2391,9 +2419,11 @@ static void pc_stop(struct tty_struct *t
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
-		if ((ch->statusflags & TXSTOPPED) == 0) { /* Begin if transmit stop requested */
+		if ((ch->statusflags & TXSTOPPED) == 0) {
+			/* Begin if transmit stop requested */
 			globalwinon(ch);
 			/* STOP transmitting now !! */
 			fepcmd(ch, PAUSETX, 0, 0, 0, 0);
@@ -2411,11 +2441,14 @@ static void pc_start(struct tty_struct *
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		unsigned long flags;
 		spin_lock_irqsave(&epca_lock, flags);
-		/* Just in case output was resumed because of a change in Digi-flow */
-		if (ch->statusflags & TXSTOPPED)  { /* Begin transmit resume requested */
+		/* Just in case output was resumed because of a change
+		   in Digi-flow */
+		if (ch->statusflags & TXSTOPPED)  {
+			/* Begin transmit resume requested */
 			struct board_chan __iomem *bc;
 			globalwinon(ch);
 			bc = ch->brdchan;
@@ -2445,7 +2478,8 @@ static void pc_throttle(struct tty_struc
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		if ((ch->statusflags & RXSTOPPED) == 0) {
 			globalwinon(ch);
@@ -2465,8 +2499,10 @@ static void pc_unthrottle(struct tty_str
 	 * verifyChannel returns the channel from the tty struct if it is
 	 * valid. This serves as a sanity check.
 	 */
-	if ((ch = verifyChannel(tty)) != NULL) {
-		/* Just in case output was resumed because of a change in Digi-flow */
+	ch = verifyChannel(tty);
+	if (ch != NULL) {
+		/* Just in case output was resumed because of a change
+		   in Digi-flow */
 		spin_lock_irqsave(&epca_lock, flags);
 		if (ch->statusflags & RXSTOPPED) {
 			globalwinon(ch);
@@ -2511,7 +2547,7 @@ static void setup_empty_event(struct tty
 	memoff(ch);
 }
 
-void epca_setup(char *str, int *ints)
+static void epca_setup(char *str, int *ints)
 {
 	struct board_info board;
 	int               index, loop, last;
@@ -2540,14 +2576,16 @@ void epca_setup(char *str, int *ints)
 			 * instructing the driver to ignore epcaconfig.) For
 			 * this reason we check for 2.
 			 */
-			if (board.status == 2) { /* Begin ignore epcaconfig as well as lilo cmd line */
+			if (board.status == 2) {
+			/* Begin ignore epcaconfig as well as lilo cmd line */
 				nbdevs = 0;
 				num_cards = 0;
 				return;
 			} /* End ignore epcaconfig as well as lilo cmd line */
 
 			if (board.status > 2) {
-				printk(KERN_ERR "epca_setup: Invalid board status 0x%x\n", board.status);
+				printk(KERN_ERR "epca_setup: Invalid board status 0x%x\n",
+						board.status);
 				invalid_lilo_config = 1;
 				setup_error_code |= INVALID_BOARD_STATUS;
 				return;
@@ -2601,7 +2639,8 @@ void epca_setup(char *str, int *ints)
 		case 6:
 			board.membase = ints[index];
 			if (ints[index] <= 0) {
-				printk(KERN_ERR "epca_setup: Invalid memory base 0x%x\n",(unsigned int)board.membase);
+				printk(KERN_ERR "epca_setup: Invalid memory base 0x%x\n",
+					(unsigned int)board.membase);
 				invalid_lilo_config = 1;
 				setup_error_code |= INVALID_MEM_BASE;
 				return;
@@ -2732,7 +2771,7 @@ void epca_setup(char *str, int *ints)
 				t2++;
 
 			if (*t2) {
-				printk(KERN_ERR "epca_setup: Invalid memory base %s\n",str);
+				printk(KERN_ERR "epca_setup: Invalid memory base %s\n", str);
 				invalid_lilo_config = 1;
 				setup_error_code |= INVALID_MEM_BASE;
 				return;
@@ -2754,7 +2793,7 @@ void epca_setup(char *str, int *ints)
 
 	/* I should REALLY validate the stuff here */
 	/* Copies our local copy of board into boards */
-	memcpy((void *)&boards[num_cards],(void *)&board, sizeof(board));
+	memcpy((void *)&boards[num_cards], (void *)&board, sizeof(board));
 	/* Does this get called once per lilo arg are what ? */
 	printk(KERN_INFO "PC/Xx: Added board %i, %s %i ports at 0x%4.4X base 0x%6.6X\n",
 		num_cards, board_desc[board.type],
@@ -2795,9 +2834,9 @@ static int __devinit epca_init_one(struc
 	if (board_idx >= MAXBOARDS)
 		goto err_out;
 
-	addr = pci_resource_start (pdev, epca_info_tbl[info_idx].bar_idx);
+	addr = pci_resource_start(pdev, epca_info_tbl[info_idx].bar_idx);
 	if (!addr) {
-		printk (KERN_ERR PFX "PCI region #%d not available (size 0)\n",
+		printk(KERN_ERR PFX "PCI region #%d not available (size 0)\n",
 			epca_info_tbl[info_idx].bar_idx);
 		goto err_out;
 	}
@@ -2808,28 +2847,29 @@ static int __devinit epca_init_one(struc
 	boards[board_idx].port = addr + PCI_IO_OFFSET;
 	boards[board_idx].membase = addr;
 
-	if (!request_mem_region (addr + PCI_IO_OFFSET, 0x200000, "epca")) {
-		printk (KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
+	if (!request_mem_region(addr + PCI_IO_OFFSET, 0x200000, "epca")) {
+		printk(KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
 			0x200000, addr + PCI_IO_OFFSET);
 		goto err_out;
 	}
 
-	boards[board_idx].re_map_port = ioremap(addr + PCI_IO_OFFSET, 0x200000);
+	boards[board_idx].re_map_port = ioremap_nocache(addr + PCI_IO_OFFSET,
+								0x200000);
 	if (!boards[board_idx].re_map_port) {
-		printk (KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
+		printk(KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
 			0x200000, addr + PCI_IO_OFFSET);
 		goto err_out_free_pciio;
 	}
 
-	if (!request_mem_region (addr, 0x200000, "epca")) {
-		printk (KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
+	if (!request_mem_region(addr, 0x200000, "epca")) {
+		printk(KERN_ERR PFX "resource 0x%x @ 0x%lx unavailable\n",
 			0x200000, addr);
 		goto err_out_free_iounmap;
 	}
 
-	boards[board_idx].re_map_membase = ioremap(addr, 0x200000);
+	boards[board_idx].re_map_membase = ioremap_nocache(addr, 0x200000);
 	if (!boards[board_idx].re_map_membase) {
-		printk (KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
+		printk(KERN_ERR PFX "cannot map 0x%x @ 0x%lx\n",
 			0x200000, addr + PCI_IO_OFFSET);
 		goto err_out_free_memregion;
 	}
@@ -2846,11 +2886,11 @@ static int __devinit epca_init_one(struc
 	return 0;
 
 err_out_free_memregion:
-	release_mem_region (addr, 0x200000);
+	release_mem_region(addr, 0x200000);
 err_out_free_iounmap:
-	iounmap (boards[board_idx].re_map_port);
+	iounmap(boards[board_idx].re_map_port);
 err_out_free_pciio:
-	release_mem_region (addr + PCI_IO_OFFSET, 0x200000);
+	release_mem_region(addr + PCI_IO_OFFSET, 0x200000);
 err_out:
 	return -ENODEV;
 }
@@ -2868,7 +2908,7 @@ MODULE_DEVICE_TABLE(pci, epca_pci_tbl);
 
 static int __init init_PCI(void)
 {
-	memset (&epca_driver, 0, sizeof (epca_driver));
+	memset(&epca_driver, 0, sizeof(epca_driver));
 	epca_driver.name = "epca";
 	epca_driver.id_table = epca_pci_tbl;
 	epca_driver.probe = epca_init_one;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
vt-fix-background-color-on-line-feed.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-more-tsstcorp-pain-keep-in-sync-with-legacy-ide.patch
pata_atiixp-simplex-clear.patch
pata_via-fix-6410-misdetect.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
isicom-fix-buffer-allocation.patch
riscom8-coding-style.patch
toshiba-use-ioremap_cached.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
s390-tty-prepare-for-put_char-to-return-success-fail.patch
serial-m68k-put_char-returns.patch
usb-gadget-switch-to-put_char-returning-int.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isdn-switch-to-int-put_char-method.patch
pty-prepare-for-tty-ops-changes.patch
pc300-update-to-tty_set_operations.patch
serial-switch-the-serial-core-to-int-put_char-methods.patch
isicom-bring-into-coding-style.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework.patch
tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
strip-fix-up-strip-for-the-new-order.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
x25_asy-code-cleanup.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
maintainers-sort-ordering.patch
char-serial-switch-drivers-to-ioremap_nocache.patch

