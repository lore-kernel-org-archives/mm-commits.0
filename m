From: akpm@linux-foundation.org
Subject: + epcac-reformat-comments-and-coding-style-improvements.patch added to -mm tree
Date: Mon, 30 Jul 2007 13:37:30 -0700
Message-ID: <200707302037.l6UKbVt5029378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968108AbXG3Uhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 16:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, jirislaby@gmail.com


The patch titled
     epca.c: reformat comments and coding style improvements
has been added to the -mm tree.  Its filename is
     epcac-reformat-comments-and-coding-style-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: epca.c: reformat comments and coding style improvements
From: Alexey Dobriyan <adobriyan@gmail.com>

* Remove stupid comments, like, at the beginning of every function that
  function begins (twice per function) and at the end (once)
* Remove trailing or otherwise broken whitespace as per let c_space_errors=1
* Reformat comments to fit it into 80 columns and remove stupid ------------'s.
* Indent case labels on the same column where switch begins
* other minor CS tweaks not worth mentioning

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.c | 2609 +++++++++++++++++++-----------------------
 1 files changed, 1201 insertions(+), 1408 deletions(-)

diff -puN drivers/char/epca.c~epcac-reformat-comments-and-coding-style-improvements drivers/char/epca.c
--- a/drivers/char/epca.c~epcac-reformat-comments-and-coding-style-improvements
+++ a/drivers/char/epca.c
@@ -1,35 +1,31 @@
 /*
-
- 
 	Copyright (C) 1996  Digi International.
- 
+
 	For technical support please email digiLinux@dgii.com or
 	call Digi tech support at (612) 912-3456
 
 	** This driver is no longer supported by Digi **
 
-	Much of this design and code came from epca.c which was 
-	copyright (C) 1994, 1995 Troy De Jongh, and subsquently 
-	modified by David Nugent, Christoph Lameter, Mike McLagan. 
- 
- 	This program is free software; you can redistribute it and/or modify
- 	it under the terms of the GNU General Public License as published by
- 	the Free Software Foundation; either version 2 of the License, or
- 	(at your option) any later version.
-
- 	This program is distributed in the hope that it will be useful,
- 	but WITHOUT ANY WARRANTY; without even the implied warranty of
- 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- 	GNU General Public License for more details.
-
- 	You should have received a copy of the GNU General Public License
- 	along with this program; if not, write to the Free Software
- 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
---------------------------------------------------------------------------- */
+	Much of this design and code came from epca.c which was
+	copyright (C) 1994, 1995 Troy De Jongh, and subsquently
+	modified by David Nugent, Christoph Lameter, Mike McLagan.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
 /* See README.epca for change history --DAT*/
 
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -54,13 +50,10 @@
 #include "epca.h"
 #include "epcaconfig.h"
 
-/* ---------------------- Begin defines ------------------------ */
-
 #define VERSION            "1.3.0.1-LK2.6"
 
 /* This major needs to be submitted to Linux to join the majors list */
-
-#define DIGIINFOMAJOR       35  /* For Digi specific ioctl */ 
+#define DIGIINFOMAJOR       35  /* For Digi specific ioctl */
 
 
 #define MAXCARDS 7
@@ -68,60 +61,48 @@
 
 #define PFX "epca: "
 
-/* ----------------- Begin global definitions ------------------- */
-
 static int nbdevs, num_cards, liloconfig;
 static int digi_poller_inhibited = 1 ;
 
 static int setup_error_code;
 static int invalid_lilo_config;
 
-/* The ISA boards do window flipping into the same spaces so its only sane
-   with a single lock. It's still pretty efficient */
-
+/*
+ * The ISA boards do window flipping into the same spaces so its only sane with
+ * a single lock. It's still pretty efficient.
+ */
 static DEFINE_SPINLOCK(epca_lock);
 
-/* -----------------------------------------------------------------------
-	MAXBOARDS is typically 12, but ISA and EISA cards are restricted to 
-	7 below.
---------------------------------------------------------------------------*/
+/* MAXBOARDS is typically 12, but ISA and EISA cards are restricted to 7 below. */
 static struct board_info boards[MAXBOARDS];
 
-
-/* ------------- Begin structures used for driver registeration ---------- */
-
 static struct tty_driver *pc_driver;
 static struct tty_driver *pc_info;
 
 /* ------------------ Begin Digi specific structures -------------------- */
 
-/* ------------------------------------------------------------------------
-	digi_channels represents an array of structures that keep track of
-	each channel of the Digi product.  Information such as transmit and
-	receive pointers, termio data, and signal definitions (DTR, CTS, etc ...)
-	are stored here.  This structure is NOT used to overlay the cards 
-	physical channel structure.
--------------------------------------------------------------------------- */
-  
+/*
+ * digi_channels represents an array of structures that keep track of each
+ * channel of the Digi product. Information such as transmit and receive
+ * pointers, termio data, and signal definitions (DTR, CTS, etc ...) are stored
+ * here. This structure is NOT used to overlay the cards physical channel
+ * structure.
+ */
 static struct channel digi_channels[MAX_ALLOC];
 
-/* ------------------------------------------------------------------------
-	card_ptr is an array used to hold the address of the
-	first channel structure of each card.  This array will hold
-	the addresses of various channels located in digi_channels.
--------------------------------------------------------------------------- */
+/*
+ * card_ptr is an array used to hold the address of the first channel structure
+ * of each card. This array will hold the addresses of various channels located
+ * in digi_channels.
+ */
 static struct channel *card_ptr[MAXCARDS];
 
 static struct timer_list epca_timer;
 
-/* ---------------------- Begin function prototypes --------------------- */
-
-/* ----------------------------------------------------------------------
-	Begin generic memory functions.  These functions will be alias
-	(point at) more specific functions dependent on the board being
-	configured.
------------------------------------------------------------------------ */
-	
+/*
+ * Begin generic memory functions. These functions will be alias (point at)
+ * more specific functions dependent on the board being configured.
+ */
 static void memwinon(struct board_info *b, unsigned int win);
 static void memwinoff(struct board_info *b, unsigned int win);
 static void globalwinon(struct channel *ch);
@@ -170,8 +151,6 @@ static void dummy_memoff(struct channel 
 static void dummy_assertgwinon(struct channel *ch);
 static void dummy_assertmemoff(struct channel *ch);
 
-/* ------------------- Begin declare functions ----------------------- */
-
 static struct channel *verifyChannel(struct tty_struct *);
 static void pc_sched_event(struct channel *, int);
 static void epca_error(int, char *);
@@ -213,62 +192,55 @@ static int pc_write(struct tty_struct *,
 static int pc_init(void);
 static int init_PCI(void);
 
-
-/* ------------------------------------------------------------------
-	Table of functions for each board to handle memory.  Mantaining 
-	parallelism is a *very* good idea here.  The idea is for the 
-	runtime code to blindly call these functions, not knowing/caring    
-	about the underlying hardware.  This stuff should contain no
-	conditionals; if more functionality is needed a different entry
-	should be established.  These calls are the interface calls and 
-	are the only functions that should be accessed.  Anyone caught
-	making direct calls deserves what they get.
--------------------------------------------------------------------- */
-
+/*
+ * Table of functions for each board to handle memory. Mantaining parallelism
+ * is a *very* good idea here. The idea is for the runtime code to blindly call
+ * these functions, not knowing/caring about the underlying hardware. This
+ * stuff should contain no conditionals; if more functionality is needed a
+ * different entry should be established. These calls are the interface calls
+ * and are the only functions that should be accessed. Anyone caught making
+ * direct calls deserves what they get.
+ */
 static void memwinon(struct board_info *b, unsigned int win)
 {
-	(b->memwinon)(b, win);
+	b->memwinon(b, win);
 }
 
 static void memwinoff(struct board_info *b, unsigned int win)
 {
-	(b->memwinoff)(b, win);
+	b->memwinoff(b, win);
 }
 
 static void globalwinon(struct channel *ch)
 {
-	(ch->board->globalwinon)(ch);
+	ch->board->globalwinon(ch);
 }
 
 static void rxwinon(struct channel *ch)
 {
-	(ch->board->rxwinon)(ch);
+	ch->board->rxwinon(ch);
 }
 
 static void txwinon(struct channel *ch)
 {
-	(ch->board->txwinon)(ch);
+	ch->board->txwinon(ch);
 }
 
 static void memoff(struct channel *ch)
 {
-	(ch->board->memoff)(ch);
+	ch->board->memoff(ch);
 }
 static void assertgwinon(struct channel *ch)
 {
-	(ch->board->assertgwinon)(ch);
+	ch->board->assertgwinon(ch);
 }
 
 static void assertmemoff(struct channel *ch)
 {
-	(ch->board->assertmemoff)(ch);
+	ch->board->assertmemoff(ch);
 }
 
-/* ---------------------------------------------------------
-	PCXEM windowing is the same as that used in the PCXR 
-	and CX series cards.
------------------------------------------------------------- */
-
+/* PCXEM windowing is the same as that used in the PCXR and CX series cards. */
 static void pcxem_memwinon(struct board_info *b, unsigned int win)
 {
         outb_p(FEPWIN|win, b->port + 1);
@@ -300,32 +272,30 @@ static void pcxem_memoff(struct channel 
 }
 
 /* ----------------- Begin pcxe memory window stuff ------------------ */
-
 static void pcxe_memwinon(struct board_info *b, unsigned int win)
 {
-               outb_p(FEPWIN | win, b->port + 1);
+	outb_p(FEPWIN | win, b->port + 1);
 }
 
 static void pcxe_memwinoff(struct board_info *b, unsigned int win)
 {
-	outb_p(inb(b->port) & ~FEPMEM,
-	           b->port + 1);
+	outb_p(inb(b->port) & ~FEPMEM, b->port + 1);
 	outb_p(0, b->port + 1);
 }
 
 static void pcxe_globalwinon(struct channel *ch)
 {
-	outb_p( FEPWIN, (int)ch->board->port + 1);
+	outb_p(FEPWIN, (int)ch->board->port + 1);
 }
 
 static void pcxe_rxwinon(struct channel *ch)
 {
-		outb_p(ch->rxwin, (int)ch->board->port + 1);
+	outb_p(ch->rxwin, (int)ch->board->port + 1);
 }
 
 static void pcxe_txwinon(struct channel *ch)
 {
-		outb_p(ch->txwin, (int)ch->board->port + 1);
+	outb_p(ch->txwin, (int)ch->board->port + 1);
 }
 
 static void pcxe_memoff(struct channel *ch)
@@ -335,10 +305,9 @@ static void pcxe_memoff(struct channel *
 }
 
 /* ------------- Begin pc64xe and pcxi memory window stuff -------------- */
-
 static void pcxi_memwinon(struct board_info *b, unsigned int win)
 {
-               outb_p(inb(b->port) | FEPMEM, b->port);
+	outb_p(inb(b->port) | FEPMEM, b->port);
 }
 
 static void pcxi_memwinoff(struct board_info *b, unsigned int win)
@@ -353,12 +322,12 @@ static void pcxi_globalwinon(struct chan
 
 static void pcxi_rxwinon(struct channel *ch)
 {
-		outb_p(FEPMEM, ch->board->port);
+	outb_p(FEPMEM, ch->board->port);
 }
 
 static void pcxi_txwinon(struct channel *ch)
 {
-		outb_p(FEPMEM, ch->board->port);
+	outb_p(FEPMEM, ch->board->port);
 }
 
 static void pcxi_memoff(struct channel *ch)
@@ -376,16 +345,13 @@ static void pcxi_assertmemoff(struct cha
 	epcaassert(!(inb(ch->board->port) & FEPMEM), "Memory on");
 }
 
-
-/* ----------------------------------------------------------------------
-	Not all of the cards need specific memory windowing routines.  Some
-	cards (Such as PCI) needs no windowing routines at all.  We provide
-	these do nothing routines so that the same code base can be used.
-	The driver will ALWAYS call a windowing routine if it thinks it needs
-	to; regardless of the card.  However, dependent on the card the routine
-	may or may not do anything.
----------------------------------------------------------------------------*/
-
+/*
+ * Not all of the cards need specific memory windowing routines. Some cards
+ * (Such as PCI) needs no windowing routines at all. We provide these do
+ * nothing routines so that the same code base can be used. The driver will
+ * ALWAYS call a windowing routine if it thinks it needs to; regardless of the
+ * card. However, dependent on the card the routine may or may not do anything.
+ */
 static void dummy_memwinon(struct board_info *b, unsigned int win)
 {
 }
@@ -418,15 +384,14 @@ static void dummy_assertmemoff(struct ch
 {
 }
 
-/* ----------------- Begin verifyChannel function ----------------------- */
 static struct channel *verifyChannel(struct tty_struct *tty)
-{ /* Begin verifyChannel */
-	/* --------------------------------------------------------------------
-		This routine basically provides a sanity check.  It insures that
-		the channel returned is within the proper range of addresses as
-		well as properly initialized.  If some bogus info gets passed in
-		through tty->driver_data this should catch it.
-		--------------------------------------------------------------------- */
+{
+	/*
+	 * This routine basically provides a sanity check. It insures that the
+	 * channel returned is within the proper range of addresses as well as
+	 * properly initialized. If some bogus info gets passed in
+	 * through tty->driver_data this should catch it.
+	 */
 	if (tty) {
 		struct channel *ch = (struct channel *)tty->driver_data;
 		if ((ch >= &digi_channels[0]) && (ch < &digi_channels[nbdevs])) {
@@ -435,62 +400,55 @@ static struct channel *verifyChannel(str
 		}
 	}
 	return NULL;
-
-} /* End verifyChannel */
-
-/* ------------------ Begin pc_sched_event ------------------------- */
+}
 
 static void pc_sched_event(struct channel *ch, int event)
 {
-	/* ----------------------------------------------------------------------
-		We call this to schedule interrupt processing on some event.  The 
-		kernel sees our request and calls the related routine in OUR driver.
-	-------------------------------------------------------------------------*/
+	/*
+	 * We call this to schedule interrupt processing on some event. The
+	 * kernel sees our request and calls the related routine in OUR driver.
+	 */
 	ch->event |= 1 << event;
 	schedule_work(&ch->tqueue);
-} /* End pc_sched_event */
-
-/* ------------------ Begin epca_error ------------------------- */
+}
 
 static void epca_error(int line, char *msg)
 {
 	printk(KERN_ERR "epca_error (Digi): line = %d %s\n",line,msg);
 }
 
-/* ------------------ Begin pc_close ------------------------- */
-static void pc_close(struct tty_struct * tty, struct file * filp)
+static void pc_close(struct tty_struct *tty, struct file *filp)
 {
 	struct channel *ch;
 	unsigned long flags;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
-	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if ch != NULL */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
+	if ((ch = verifyChannel(tty)) != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		if (tty_hung_up_p(filp)) {
 			spin_unlock_irqrestore(&epca_lock, flags);
 			return;
 		}
-		/* Check to see if the channel is open more than once */
 		if (ch->count-- > 1)  {
 			/* Begin channel is open more than once */
-			/* -------------------------------------------------------------
-				Return without doing anything.  Someone might still be using
-				the channel.
-			---------------------------------------------------------------- */
+			/*
+			 * Return without doing anything. Someone might still
+			 * be using the channel.
+			 */
 			spin_unlock_irqrestore(&epca_lock, flags);
 			return;
-		} /* End channel is open more than once */
+		}
 
 		/* Port open only once go ahead with shutdown & reset */
 		BUG_ON(ch->count < 0);
 
-		/* ---------------------------------------------------------------
-			Let the rest of the driver know the channel is being closed.
-			This becomes important if an open is attempted before close 
-			is finished.
-		------------------------------------------------------------------ */
+		/*
+		 * Let the rest of the driver know the channel is being closed.
+		 * This becomes important if an open is attempted before close
+		 * is finished.
+		 */
 		ch->asyncflags |= ASYNC_CLOSING;
 		tty->closing = 1;
 
@@ -498,7 +456,7 @@ static void pc_close(struct tty_struct *
 
 		if (ch->asyncflags & ASYNC_INITIALIZED)  {
 			/* Setup an event to indicate when the transmit buffer empties */
-			setup_empty_event(tty, ch);		
+			setup_empty_event(tty, ch);
 			tty_wait_until_sent(tty, 3000); /* 30 seconds timeout */
 		}
 		if (tty->driver->flush_buffer)
@@ -513,27 +471,24 @@ static void pc_close(struct tty_struct *
 		ch->tty = NULL;
 		spin_unlock_irqrestore(&epca_lock, flags);
 
-		if (ch->blocked_open)  { /* Begin if blocked_open */
-			if (ch->close_delay) 
+		if (ch->blocked_open) {
+			if (ch->close_delay)
 				msleep_interruptible(jiffies_to_msecs(ch->close_delay));
 			wake_up_interruptible(&ch->open_wait);
-		} /* End if blocked_open */
-		ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_INITIALIZED | 
+		}
+		ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_INITIALIZED |
 		                      ASYNC_CLOSING);
 		wake_up_interruptible(&ch->close_wait);
-	} /* End if ch != NULL */
-} /* End pc_close */ 
-
-/* ------------------ Begin shutdown  ------------------------- */
+	}
+}
 
 static void shutdown(struct channel *ch)
-{ /* Begin shutdown */
-
+{
 	unsigned long flags;
 	struct tty_struct *tty;
 	struct board_chan __iomem *bc;
 
-	if (!(ch->asyncflags & ASYNC_INITIALIZED)) 
+	if (!(ch->asyncflags & ASYNC_INITIALIZED))
 		return;
 
 	spin_lock_irqsave(&epca_lock, flags);
@@ -541,50 +496,40 @@ static void shutdown(struct channel *ch)
 	globalwinon(ch);
 	bc = ch->brdchan;
 
-	/* ------------------------------------------------------------------
-		In order for an event to be generated on the receipt of data the
-		idata flag must be set. Since we are shutting down, this is not 
-		necessary clear this flag.
-	--------------------------------------------------------------------- */ 
-
+	/*
+	 * In order for an event to be generated on the receipt of data the
+	 * idata flag must be set. Since we are shutting down, this is not
+	 * necessary clear this flag.
+	 */
 	if (bc)
 		writeb(0, &bc->idata);
 	tty = ch->tty;
 
-	/* ----------------------------------------------------------------
-	   If we're a modem control device and HUPCL is on, drop RTS & DTR.
- 	------------------------------------------------------------------ */
-
+	/* If we're a modem control device and HUPCL is on, drop RTS & DTR. */
 	if (tty->termios->c_cflag & HUPCL)  {
 		ch->omodem &= ~(ch->m_rts | ch->m_dtr);
 		fepcmd(ch, SETMODEM, 0, ch->m_dtr | ch->m_rts, 10, 1);
 	}
 	memoff(ch);
 
-	/* ------------------------------------------------------------------
-		The channel has officialy been closed.  The next time it is opened
-		it will have to reinitialized.  Set a flag to indicate this.
-	---------------------------------------------------------------------- */
-
+	/*
+	 * The channel has officialy been closed. The next time it is opened it
+	 * will have to reinitialized. Set a flag to indicate this.
+	 */
 	/* Prevent future Digi programmed interrupts from coming active */
-
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&epca_lock, flags);
-
-} /* End shutdown */
-
-/* ------------------ Begin pc_hangup  ------------------------- */
+}
 
 static void pc_hangup(struct tty_struct *tty)
-{ /* Begin pc_hangup */
+{
 	struct channel *ch;
-	
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
 
-	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if ch != NULL */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
+	if ((ch = verifyChannel(tty)) != NULL) {
 		unsigned long flags;
 
 		if (tty->driver->flush_buffer)
@@ -599,15 +544,12 @@ static void pc_hangup(struct tty_struct 
 		ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_INITIALIZED);
 		spin_unlock_irqrestore(&epca_lock, flags);
 		wake_up_interruptible(&ch->open_wait);
-	} /* End if ch != NULL */
-
-} /* End pc_hangup */
-
-/* ------------------ Begin pc_write  ------------------------- */
+	}
+}
 
-static int pc_write(struct tty_struct * tty,
+static int pc_write(struct tty_struct *tty,
                     const unsigned char *buf, int bytesAvailable)
-{ /* Begin pc_write */
+{
 	unsigned int head, tail;
 	int dataLen;
 	int size;
@@ -617,25 +559,23 @@ static int pc_write(struct tty_struct * 
 	int remain;
 	struct board_chan __iomem *bc;
 
-	/* ----------------------------------------------------------------
-		pc_write is primarily called directly by the kernel routine
-		tty_write (Though it can also be called by put_char) found in
-		tty_io.c.  pc_write is passed a line discipline buffer where 
-		the data to be written out is stored.  The line discipline 
-		implementation itself is done at the kernel level and is not 
-		brought into the driver.  
-	------------------------------------------------------------------- */
-
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
+	/*
+	 * pc_write is primarily called directly by the kernel routine
+	 * tty_write (Though it can also be called by put_char) found in
+	 * tty_io.c. pc_write is passed a line discipline buffer where the data
+	 * to be written out is stored. The line discipline implementation
+	 * itself is done at the kernel level and is not brought into the
+	 * driver.
+	 */
 
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
 	if ((ch = verifyChannel(tty)) == NULL)
 		return 0;
 
 	/* Make a pointer to the channel data structure found on the board. */
-
 	bc   = ch->brdchan;
 	size = ch->txbufsize;
 	amountCopied = 0;
@@ -650,37 +590,36 @@ static int pc_write(struct tty_struct * 
 		tail = readw(&bc->tout);
 	tail &= (size - 1);
 
-	/*	If head >= tail, head has not wrapped around. */ 
-	if (head >= tail)  { /* Begin head has not wrapped */
-		/* ---------------------------------------------------------------
-			remain (much like dataLen above) represents the total amount of
-			space available on the card for data.  Here dataLen represents
-			the space existing between the head pointer and the end of 
-			buffer.  This is important because a memcpy cannot be told to
-			automatically wrap around when it hits the buffer end.
-		------------------------------------------------------------------ */ 
+	if (head >= tail) {
+		/* head has not wrapped */
+		/*
+		 * remain (much like dataLen above) represents the total amount
+		 * of space available on the card for data. Here dataLen
+		 * represents the space existing between the head pointer and
+		 * the end of buffer. This is important because a memcpy cannot
+		 * be told to automatically wrap around when it hits the buffer
+		 * end.
+		 */
 		dataLen = size - head;
 		remain = size - (head - tail) - 1;
-	} else { /* Begin head has wrapped around */
-
+	} else {
+		/* head has wrapped around */
 		remain = tail - head - 1;
 		dataLen = remain;
-
-	} /* End head has wrapped around */
-	/* -------------------------------------------------------------------
-			Check the space on the card.  If we have more data than 
-			space; reduce the amount of data to fit the space.
-	---------------------------------------------------------------------- */
+	}
+	/*
+	 * Check the space on the card. If we have more data than space; reduce
+	 * the amount of data to fit the space.
+	 */
 	bytesAvailable = min(remain, bytesAvailable);
 	txwinon(ch);
-	while (bytesAvailable > 0) 
-	{ /* Begin while there is data to copy onto card */
-
-		/* -----------------------------------------------------------------
-			If head is not wrapped, the below will make sure the first 
-			data copy fills to the end of card buffer.
-		------------------------------------------------------------------- */
+	while (bytesAvailable > 0) {
+		/* there is data to copy onto card */
 
+		/*
+		 * If head is not wrapped, the below will make sure the first
+		 * data copy fills to the end of card buffer.
+		 */
 		dataLen = min(bytesAvailable, dataLen);
 		memcpy_toio(ch->txptr + head, buf, dataLen);
 		buf += dataLen;
@@ -692,7 +631,7 @@ static int pc_write(struct tty_struct * 
 			head = 0;
 			dataLen = tail;
 		}
-	} /* End while there is data to copy onto card */
+	}
 	ch->statusflags |= TXBUSY;
 	globalwinon(ch);
 	writew(head, &bc->tin);
@@ -703,22 +642,16 @@ static int pc_write(struct tty_struct * 
 	}
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
-	return(amountCopied);
-
-} /* End pc_write */
-
-/* ------------------ Begin pc_put_char  ------------------------- */
+	return amountCopied;
+}
 
 static void pc_put_char(struct tty_struct *tty, unsigned char c)
-{ /* Begin pc_put_char */
+{
 	pc_write(tty, &c, 1);
-} /* End pc_put_char */
-
-/* ------------------ Begin pc_write_room  ------------------------- */
+}
 
 static int pc_write_room(struct tty_struct *tty)
-{ /* Begin pc_write_room */
-
+{
 	int remain;
 	struct channel *ch;
 	unsigned long flags;
@@ -727,11 +660,10 @@ static int pc_write_room(struct tty_stru
 
 	remain = 0;
 
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
-
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
 	if ((ch = verifyChannel(tty)) != NULL)  {
 		spin_lock_irqsave(&epca_lock, flags);
 		globalwinon(ch);
@@ -757,14 +689,10 @@ static int pc_write_room(struct tty_stru
 	}
 	/* Return how much room is left on card */
 	return remain;
-
-} /* End pc_write_room */
-
-/* ------------------ Begin pc_chars_in_buffer  ---------------------- */
+}
 
 static int pc_chars_in_buffer(struct tty_struct *tty)
-{ /* Begin pc_chars_in_buffer */
-
+{
 	int chars;
 	unsigned int ctail, head, tail;
 	int remain;
@@ -772,13 +700,12 @@ static int pc_chars_in_buffer(struct tty
 	struct channel *ch;
 	struct board_chan __iomem *bc;
 
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
-
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
 	if ((ch = verifyChannel(tty)) == NULL)
-		return(0);
+		return 0;
 
 	spin_lock_irqsave(&epca_lock, flags);
 	globalwinon(ch);
@@ -793,45 +720,40 @@ static int pc_chars_in_buffer(struct tty
 	else  { /* Begin if some space on the card has been used */
 		head = readw(&bc->tin) & (ch->txbufsize - 1);
 		tail &= (ch->txbufsize - 1);
-		/*  --------------------------------------------------------------
-			The logic here is basically opposite of the above pc_write_room
-			here we are finding the amount of bytes in the buffer filled.
-			Not the amount of bytes empty.
-		------------------------------------------------------------------- */
+		/*
+		 * The logic here is basically opposite of the above
+		 * pc_write_room here we are finding the amount of bytes in the
+		 * buffer filled. Not the amount of bytes empty.
+		 */
 		if ((remain = tail - head - 1) < 0 )
 			remain += ch->txbufsize;
 		chars = (int)(ch->txbufsize - remain);
-		/* -------------------------------------------------------------  
-			Make it possible to wakeup anything waiting for output
-			in tty_ioctl.c, etc.
-
-			If not already set.  Setup an event to indicate when the
-			transmit buffer empties 
-		----------------------------------------------------------------- */
+		/*
+		 * Make it possible to wakeup anything waiting for output in
+		 * tty_ioctl.c, etc.
+		 *
+		 * If not already set. Setup an event to indicate when the
+		 * transmit buffer empties.
+		 */
 		if (!(ch->statusflags & EMPTYWAIT))
 			setup_empty_event(tty,ch);
-
 	} /* End if some space on the card has been used */
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
 	/* Return number of characters residing on card. */
-	return(chars);
-
-} /* End pc_chars_in_buffer */
-
-/* ------------------ Begin pc_flush_buffer  ---------------------- */
+	return chars;
+}
 
 static void pc_flush_buffer(struct tty_struct *tty)
-{ /* Begin pc_flush_buffer */
-
+{
 	unsigned int tail;
 	unsigned long flags;
 	struct channel *ch;
 	struct board_chan __iomem *bc;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
 	if ((ch = verifyChannel(tty)) == NULL)
 		return;
 
@@ -844,51 +766,47 @@ static void pc_flush_buffer(struct tty_s
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
 	tty_wakeup(tty);
-} /* End pc_flush_buffer */
-
-/* ------------------ Begin pc_flush_chars  ---------------------- */
+}
 
 static void pc_flush_chars(struct tty_struct *tty)
-{ /* Begin pc_flush_chars */
-	struct channel * ch;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
+{
+	struct channel *ch;
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
 	if ((ch = verifyChannel(tty)) != NULL) {
 		unsigned long flags;
 		spin_lock_irqsave(&epca_lock, flags);
-		/* ----------------------------------------------------------------
-			If not already set and the transmitter is busy setup an event
-			to indicate when the transmit empties.
-		------------------------------------------------------------------- */
+		/*
+		 * If not already set and the transmitter is busy setup an
+		 * event to indicate when the transmit empties.
+		 */
 		if ((ch->statusflags & TXBUSY) && !(ch->statusflags & EMPTYWAIT))
 			setup_empty_event(tty,ch);
 		spin_unlock_irqrestore(&epca_lock, flags);
 	}
-} /* End pc_flush_chars */
-
-/* ------------------ Begin block_til_ready  ---------------------- */
+}
 
-static int block_til_ready(struct tty_struct *tty, 
+static int block_til_ready(struct tty_struct *tty,
                            struct file *filp, struct channel *ch)
-{ /* Begin block_til_ready */
+{
 	DECLARE_WAITQUEUE(wait,current);
-	int	retval, do_clocal = 0;
+	int retval, do_clocal = 0;
 	unsigned long flags;
 
 	if (tty_hung_up_p(filp)) {
 		if (ch->asyncflags & ASYNC_HUP_NOTIFY)
 			retval = -EAGAIN;
 		else
-			retval = -ERESTARTSYS;	
-		return(retval);
+			retval = -ERESTARTSYS;
+		return retval;
 	}
 
-	/* ----------------------------------------------------------------- 
-		If the device is in the middle of being closed, then block
-		until it's done, and then try again.
-	-------------------------------------------------------------------- */
+	/*
+	 * If the device is in the middle of being closed, then block until
+	 * it's done, and then try again.
+	 */
 	if (ch->asyncflags & ASYNC_CLOSING) {
 		interruptible_sleep_on(&ch->close_wait);
 
@@ -899,17 +817,17 @@ static int block_til_ready(struct tty_st
 	}
 
 	if (filp->f_flags & O_NONBLOCK)  {
-		/* ----------------------------------------------------------------- 
-	  	 If non-blocking mode is set, then make the check up front
-	  	 and then exit.
-		-------------------------------------------------------------------- */
+		/*
+		 * If non-blocking mode is set, then make the check up front
+		 * and then exit.
+		 */
 		ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 	if (tty->termios->c_cflag & CLOCAL)
 		do_clocal = 1;
 	/* Block waiting for the carrier detect and the line to become free */
-	
+
 	retval = 0;
 	add_wait_queue(&ch->open_wait, &wait);
 
@@ -918,19 +836,18 @@ static int block_til_ready(struct tty_st
 	if (!tty_hung_up_p(filp))
 		ch->count--;
 	ch->blocked_open++;
-	while(1) 
-	{ /* Begin forever while  */
+	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(ch->asyncflags & ASYNC_INITIALIZED)) 
+		    !(ch->asyncflags & ASYNC_INITIALIZED))
 		{
 			if (ch->asyncflags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
-				retval = -ERESTARTSYS;	
+				retval = -ERESTARTSYS;
 			break;
 		}
-		if (!(ch->asyncflags & ASYNC_CLOSING) && 
+		if (!(ch->asyncflags & ASYNC_CLOSING) &&
 			  (do_clocal || (ch->imodem & ch->dcd)))
 			break;
 		if (signal_pending(current)) {
@@ -938,16 +855,15 @@ static int block_til_ready(struct tty_st
 			break;
 		}
 		spin_unlock_irqrestore(&epca_lock, flags);
-		/* ---------------------------------------------------------------
-			Allow someone else to be scheduled.  We will occasionally go
-			through this loop until one of the above conditions change.
-			The below schedule call will allow other processes to enter and
-			prevent this loop from hogging the cpu.
-		------------------------------------------------------------------ */
+		/*
+		 * Allow someone else to be scheduled. We will occasionally go
+		 * through this loop until one of the above conditions change.
+		 * The below schedule call will allow other processes to enter
+		 * and prevent this loop from hogging the cpu.
+		 */
 		schedule();
 		spin_lock_irqsave(&epca_lock, flags);
-
-	} /* End forever while  */
+	}
 
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&ch->open_wait, &wait);
@@ -962,13 +878,10 @@ static int block_til_ready(struct tty_st
 
 	ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
-} /* End block_til_ready */	
-
-/* ------------------ Begin pc_open  ---------------------- */
+}
 
 static int pc_open(struct tty_struct *tty, struct file * filp)
-{ /* Begin pc_open */
-
+{
 	struct channel *ch;
 	unsigned long flags;
 	int line, retval, boardnum;
@@ -984,12 +897,11 @@ static int pc_open(struct tty_struct *tt
 
 	/* Check status of board configured in system.  */
 
-	/* -----------------------------------------------------------------
-		I check to see if the epca_setup routine detected an user error.  
-		It might be better to put this in pc_init, but for the moment it
-		goes here.
-	---------------------------------------------------------------------- */
-
+	/*
+	 * I check to see if the epca_setup routine detected an user error. It
+	 * might be better to put this in pc_init, but for the moment it goes
+	 * here.
+	 */
 	if (invalid_lilo_config) {
 		if (setup_error_code & INVALID_BOARD_TYPE)
 			printk(KERN_ERR "epca: pc_open: Invalid board type specified in kernel options.\n");
@@ -1010,49 +922,48 @@ static int pc_open(struct tty_struct *tt
 		tty->driver_data = NULL;   /* Mark this device as 'down' */
 		return(-ENODEV);
 	}
-	
+
 	if ((bc = ch->brdchan) == 0) {
 		tty->driver_data = NULL;
 		return -ENODEV;
 	}
 
 	spin_lock_irqsave(&epca_lock, flags);
-	/* ------------------------------------------------------------------
-		Every time a channel is opened, increment a counter.  This is 
-		necessary because we do not wish to flush and shutdown the channel
-		until the last app holding the channel open, closes it.	 	
-	--------------------------------------------------------------------- */
+	/*
+	 * Every time a channel is opened, increment a counter. This is
+	 * necessary because we do not wish to flush and shutdown the channel
+	 * until the last app holding the channel open, closes it.
+	 */
 	ch->count++;
-	/* ----------------------------------------------------------------
-		Set a kernel structures pointer to our local channel 
-		structure.  This way we can get to it when passed only
-		a tty struct.
-	------------------------------------------------------------------ */
+	/*
+	 * Set a kernel structures pointer to our local channel structure. This
+	 * way we can get to it when passed only a tty struct.
+	 */
 	tty->driver_data = ch;
-	/* ----------------------------------------------------------------
-		If this is the first time the channel has been opened, initialize
-		the tty->termios struct otherwise let pc_close handle it.
-	-------------------------------------------------------------------- */
+	/*
+	 * If this is the first time the channel has been opened, initialize
+	 * the tty->termios struct otherwise let pc_close handle it.
+	 */
 	globalwinon(ch);
 	ch->statusflags = 0;
 
 	/* Save boards current modem status */
 	ch->imodem = readb(&bc->mstat);
 
-	/* ----------------------------------------------------------------
-	   Set receive head and tail ptrs to each other.  This indicates
-	   no data available to read.
-	----------------------------------------------------------------- */
+	/*
+	 * Set receive head and tail ptrs to each other. This indicates no data
+	 * available to read.
+	 */
 	head = readw(&bc->rin);
 	writew(head, &bc->rout);
 
 	/* Set the channels associated tty structure */
 	ch->tty = tty;
 
-	/* -----------------------------------------------------------------
-		The below routine generally sets up parity, baud, flow control 
-		issues, etc.... It effect both control flags and input flags.
-	-------------------------------------------------------------------- */
+	/*
+	 * The below routine generally sets up parity, baud, flow control
+	 * issues, etc.... It effect both control flags and input flags.
+	 */
 	epcaparam(tty,ch);
 	ch->asyncflags |= ASYNC_INITIALIZED;
 	memoff(ch);
@@ -1061,10 +972,10 @@ static int pc_open(struct tty_struct *tt
 	retval = block_til_ready(tty, filp, ch);
 	if (retval)
 		return retval;
-	/* -------------------------------------------------------------
-		Set this again in case a hangup set it to zero while this 
-		open() was waiting for the line...
-	--------------------------------------------------------------- */
+	/*
+	 * Set this again in case a hangup set it to zero while this open() was
+	 * waiting for the line...
+	 */
 	spin_lock_irqsave(&epca_lock, flags);
 	ch->tty = tty;
 	globalwinon(ch);
@@ -1073,13 +984,12 @@ static int pc_open(struct tty_struct *tt
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
 	return 0;
-} /* End pc_open */
+}
 
 static int __init epca_module_init(void)
-{ /* Begin init_module */
+{
 	return pc_init();
 }
-
 module_init(epca_module_init);
 
 static struct pci_driver epca_driver;
@@ -1092,8 +1002,7 @@ static void __exit epca_module_exit(void
 
 	del_timer_sync(&epca_timer);
 
-	if ((tty_unregister_driver(pc_driver)) ||  
-	    (tty_unregister_driver(pc_info)))
+	if (tty_unregister_driver(pc_driver) || tty_unregister_driver(pc_info))
 	{
 		printk(KERN_WARNING "epca: cleanup_module failed to un-register tty driver\n");
 		return;
@@ -1101,23 +1010,20 @@ static void __exit epca_module_exit(void
 	put_tty_driver(pc_driver);
 	put_tty_driver(pc_info);
 
-	for (crd = 0; crd < num_cards; crd++)  { /* Begin for each card */
+	for (crd = 0; crd < num_cards; crd++) {
 		bd = &boards[crd];
-		if (!bd)
-		{ /* Begin sanity check */
+		if (!bd) { /* sanity check */
 			printk(KERN_ERR "<Error> - Digi : cleanup_module failed\n");
 			return;
-		} /* End sanity check */
+		}
 		ch = card_ptr[crd];
-		for (count = 0; count < bd->numports; count++, ch++) 
-		{ /* Begin for each port */
+		for (count = 0; count < bd->numports; count++, ch++) {
 			if (ch && ch->tty)
 				tty_hangup(ch->tty);
-		} /* End for each port */
-	} /* End for each card */
-	pci_unregister_driver (&epca_driver);
+		}
+	}
+	pci_unregister_driver(&epca_driver);
 }
-
 module_exit(epca_module_exit);
 
 static const struct tty_operations pc_ops = {
@@ -1148,10 +1054,8 @@ static struct tty_operations info_ops = 
 	.ioctl = info_ioctl,
 };
 
-/* ------------------ Begin pc_init  ---------------------- */
-
 static int __init pc_init(void)
-{ /* Begin pc_init */
+{
 	int crd;
 	struct board_info *bd;
 	unsigned char board_id = 0;
@@ -1169,63 +1073,57 @@ static int __init pc_init(void)
 	if (!pc_info)
 		goto out2;
 
-	/* -----------------------------------------------------------------------
-		If epca_setup has not been ran by LILO set num_cards to defaults; copy
-		board structure defined by digiConfig into drivers board structure.
-		Note : If LILO has ran epca_setup then epca_setup will handle defining
-		num_cards as well as copying the data into the board structure.
-	-------------------------------------------------------------------------- */
-	if (!liloconfig) { /* Begin driver has been configured via. epcaconfig */
-
+	/*
+	 * If epca_setup has not been ran by LILO set num_cards to defaults;
+	 * copy board structure defined by digiConfig into drivers board
+	 * structure. Note : If LILO has ran epca_setup then epca_setup will
+	 * handle defining num_cards as well as copying the data into the board
+	 * structure.
+	 */
+	if (!liloconfig) {
+		/* driver has been configured via. epcaconfig */
 		nbdevs = NBDEVS;
 		num_cards = NUMCARDS;
-		memcpy((void *)&boards, (void *)&static_boards,
-		       (sizeof(struct board_info) * NUMCARDS));
-	} /* End driver has been configured via. epcaconfig */
-
-	/* -----------------------------------------------------------------
-		Note : If lilo was used to configure the driver and the 
-		ignore epcaconfig option was choosen (digiepca=2) then 
-		nbdevs and num_cards will equal 0 at this point.  This is
-		okay; PCI cards will still be picked up if detected.
-	--------------------------------------------------------------------- */
-
-	/*  -----------------------------------------------------------
-		Set up interrupt, we will worry about memory allocation in
-		post_fep_init. 
-	--------------------------------------------------------------- */
+		memcpy(&boards, &static_boards,
+		       sizeof(struct board_info) * NUMCARDS);
+	}
 
+	/*
+	 * Note : If lilo was used to configure the driver and the ignore
+	 * epcaconfig option was choosen (digiepca=2) then nbdevs and num_cards
+	 * will equal 0 at this point. This is okay; PCI cards will still be
+	 * picked up if detected.
+	 */
 
+	/*
+	 * Set up interrupt, we will worry about memory allocation in
+	 * post_fep_init.
+	 */
 	printk(KERN_INFO "DIGI epca driver version %s loaded.\n",VERSION);
 
-	/* ------------------------------------------------------------------
-		NOTE : This code assumes that the number of ports found in 
-		       the boards array is correct.  This could be wrong if
-		       the card in question is PCI (And therefore has no ports 
-		       entry in the boards structure.)  The rest of the 
-		       information will be valid for PCI because the beginning
-		       of pc_init scans for PCI and determines i/o and base
-		       memory addresses.  I am not sure if it is possible to 
-		       read the number of ports supported by the card prior to
-		       it being booted (Since that is the state it is in when 
-		       pc_init is run).  Because it is not possible to query the
-		       number of supported ports until after the card has booted;
-		       we are required to calculate the card_ptrs as the card is	 
-		       is initialized (Inside post_fep_init).  The negative thing
-		       about this approach is that digiDload's call to GET_INFO
-		       will have a bad port value.  (Since this is called prior
-		       to post_fep_init.)
-
-	--------------------------------------------------------------------- */
-  
+	/*
+	 * NOTE : This code assumes that the number of ports found in the
+	 * boards array is correct. This could be wrong if the card in question
+	 * is PCI (And therefore has no ports entry in the boards structure.)
+	 * The rest of the information will be valid for PCI because the
+	 * beginning of pc_init scans for PCI and determines i/o and base
+	 * memory addresses. I am not sure if it is possible to read the number
+	 * of ports supported by the card prior to it being booted (Since that
+	 * is the state it is in when pc_init is run). Because it is not
+	 * possible to query the number of supported ports until after the card
+	 * has booted; we are required to calculate the card_ptrs as the card
+	 * is initialized (Inside post_fep_init). The negative thing about this
+	 * approach is that digiDload's call to GET_INFO will have a bad port
+	 * value. (Since this is called prior to post_fep_init.)
+	 */
 	pci_boards_found = 0;
-	if(num_cards < MAXBOARDS)
+	if (num_cards < MAXBOARDS)
 		pci_boards_found += init_PCI();
 	num_cards += pci_boards_found;
 
 	pc_driver->owner = THIS_MODULE;
-	pc_driver->name = "ttyD"; 
-	pc_driver->major = DIGI_MAJOR; 
+	pc_driver->name = "ttyD";
+	pc_driver->major = DIGI_MAJOR;
 	pc_driver->minor_start = 0;
 	pc_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	pc_driver->subtype = SERIAL_TYPE_NORMAL;
@@ -1256,120 +1154,108 @@ static int __init pc_init(void)
 	tty_set_operations(pc_info, &info_ops);
 
 
-	for (crd = 0; crd < num_cards; crd++) 
-	{ /* Begin for each card */
-
-		/*  ------------------------------------------------------------------
-			This is where the appropriate memory handlers for the hardware is
-			set.  Everything at runtime blindly jumps through these vectors.
-		---------------------------------------------------------------------- */
+	for (crd = 0; crd < num_cards; crd++) {
+		/*
+		 * This is where the appropriate memory handlers for the
+		 * hardware is set. Everything at runtime blindly jumps through
+		 * these vectors.
+		 */
 
 		/* defined in epcaconfig.h */
 		bd = &boards[crd];
 
-		switch (bd->type)
-		{ /* Begin switch on bd->type {board type} */
-			case PCXEM:
-			case EISAXEM:
-				bd->memwinon     = pcxem_memwinon ;
-				bd->memwinoff    = pcxem_memwinoff ;
-				bd->globalwinon  = pcxem_globalwinon ;
-				bd->txwinon      = pcxem_txwinon ;
-				bd->rxwinon      = pcxem_rxwinon ;
-				bd->memoff       = pcxem_memoff ;
-				bd->assertgwinon = dummy_assertgwinon;
-				bd->assertmemoff = dummy_assertmemoff;
-				break;
-
-			case PCIXEM:
-			case PCIXRJ:
-			case PCIXR:
-				bd->memwinon     = dummy_memwinon;
-				bd->memwinoff    = dummy_memwinoff;
-				bd->globalwinon  = dummy_globalwinon;
-				bd->txwinon      = dummy_txwinon;
-				bd->rxwinon      = dummy_rxwinon;
-				bd->memoff       = dummy_memoff;
-				bd->assertgwinon = dummy_assertgwinon;
-				bd->assertmemoff = dummy_assertmemoff;
-				break;
-
-			case PCXE:
-			case PCXEVE:
-
-				bd->memwinon     = pcxe_memwinon;
-				bd->memwinoff    = pcxe_memwinoff;
-				bd->globalwinon  = pcxe_globalwinon;
-				bd->txwinon      = pcxe_txwinon;
-				bd->rxwinon      = pcxe_rxwinon;
-				bd->memoff       = pcxe_memoff;
-				bd->assertgwinon = dummy_assertgwinon;
-				bd->assertmemoff = dummy_assertmemoff;
-				break;
-
-			case PCXI:
-			case PC64XE:
-
-				bd->memwinon     = pcxi_memwinon;
-				bd->memwinoff    = pcxi_memwinoff;
-				bd->globalwinon  = pcxi_globalwinon;
-				bd->txwinon      = pcxi_txwinon;
-				bd->rxwinon      = pcxi_rxwinon;
-				bd->memoff       = pcxi_memoff;
-				bd->assertgwinon = pcxi_assertgwinon;
-				bd->assertmemoff = pcxi_assertmemoff;
-				break;
-
-			default:
-				break;
-
-		} /* End switch on bd->type */
-
-		/* ---------------------------------------------------------------
-			Some cards need a memory segment to be defined for use in 
-			transmit and receive windowing operations.  These boards
-			are listed in the below switch.  In the case of the XI the
-			amount of memory on the board is variable so the memory_seg
-			is also variable.  This code determines what they segment 
-			should be.
-		----------------------------------------------------------------- */
-
-		switch (bd->type)
-		{ /* Begin switch on bd->type {board type} */
-
-			case PCXE:
-			case PCXEVE:
-			case PC64XE:
-				bd->memory_seg = 0xf000;
-			break;
-
-			case PCXI:
-				board_id = inb((int)bd->port);
-				if ((board_id & 0x1) == 0x1) 
-				{ /* Begin it's an XI card */ 
-
-					/* Is it a 64K board */
-					if ((board_id & 0x30) == 0) 
-						bd->memory_seg = 0xf000;
-
-					/* Is it a 128K board */
-					if ((board_id & 0x30) == 0x10) 
-						bd->memory_seg = 0xe000;
-
-					/* Is is a 256K board */	
-					if ((board_id & 0x30) == 0x20) 
-						bd->memory_seg = 0xc000;
-
-					/* Is it a 512K board */
-					if ((board_id & 0x30) == 0x30) 
-						bd->memory_seg = 0x8000;
+		switch (bd->type) {
+		case PCXEM:
+		case EISAXEM:
+			bd->memwinon     = pcxem_memwinon;
+			bd->memwinoff    = pcxem_memwinoff;
+			bd->globalwinon  = pcxem_globalwinon;
+			bd->txwinon      = pcxem_txwinon;
+			bd->rxwinon      = pcxem_rxwinon;
+			bd->memoff       = pcxem_memoff;
+			bd->assertgwinon = dummy_assertgwinon;
+			bd->assertmemoff = dummy_assertmemoff;
+			break;
+
+		case PCIXEM:
+		case PCIXRJ:
+		case PCIXR:
+			bd->memwinon     = dummy_memwinon;
+			bd->memwinoff    = dummy_memwinoff;
+			bd->globalwinon  = dummy_globalwinon;
+			bd->txwinon      = dummy_txwinon;
+			bd->rxwinon      = dummy_rxwinon;
+			bd->memoff       = dummy_memoff;
+			bd->assertgwinon = dummy_assertgwinon;
+			bd->assertmemoff = dummy_assertmemoff;
+			break;
 
-				} else printk(KERN_ERR "epca: Board at 0x%x doesn't appear to be an XI\n",(int)bd->port);
+		case PCXE:
+		case PCXEVE:
+			bd->memwinon     = pcxe_memwinon;
+			bd->memwinoff    = pcxe_memwinoff;
+			bd->globalwinon  = pcxe_globalwinon;
+			bd->txwinon      = pcxe_txwinon;
+			bd->rxwinon      = pcxe_rxwinon;
+			bd->memoff       = pcxe_memoff;
+			bd->assertgwinon = dummy_assertgwinon;
+			bd->assertmemoff = dummy_assertmemoff;
 			break;
 
-		} /* End switch on bd->type */
+		case PCXI:
+		case PC64XE:
+			bd->memwinon     = pcxi_memwinon;
+			bd->memwinoff    = pcxi_memwinoff;
+			bd->globalwinon  = pcxi_globalwinon;
+			bd->txwinon      = pcxi_txwinon;
+			bd->rxwinon      = pcxi_rxwinon;
+			bd->memoff       = pcxi_memoff;
+			bd->assertgwinon = pcxi_assertgwinon;
+			bd->assertmemoff = pcxi_assertmemoff;
+			break;
 
-	} /* End for each card */
+		default:
+			break;
+		}
+
+		/*
+		 * Some cards need a memory segment to be defined for use in
+		 * transmit and receive windowing operations. These boards are
+		 * listed in the below switch. In the case of the XI the amount
+		 * of memory on the board is variable so the memory_seg is also
+		 * variable. This code determines what they segment should be.
+		 */
+		switch (bd->type) {
+		case PCXE:
+		case PCXEVE:
+		case PC64XE:
+			bd->memory_seg = 0xf000;
+			break;
+
+		case PCXI:
+			board_id = inb((int)bd->port);
+			if ((board_id & 0x1) == 0x1) {
+				/* it's an XI card */
+				/* Is it a 64K board */
+				if ((board_id & 0x30) == 0)
+					bd->memory_seg = 0xf000;
+
+				/* Is it a 128K board */
+				if ((board_id & 0x30) == 0x10)
+					bd->memory_seg = 0xe000;
+
+				/* Is is a 256K board */
+				if ((board_id & 0x30) == 0x20)
+					bd->memory_seg = 0xc000;
+
+				/* Is it a 512K board */
+				if ((board_id & 0x30) == 0x30)
+					bd->memory_seg = 0x8000;
+			} else
+				printk(KERN_ERR "epca: Board at 0x%x doesn't appear to be an XI\n",(int)bd->port);
+			break;
+		}
+	}
 
 	err = tty_register_driver(pc_driver);
 	if (err) {
@@ -1383,10 +1269,7 @@ static int __init pc_init(void)
 		goto out4;
 	}
 
-	/* -------------------------------------------------------------------
-	   Start up the poller to check for events on all enabled boards
-	---------------------------------------------------------------------- */
-
+	/* Start up the poller to check for events on all enabled boards */
 	init_timer(&epca_timer);
 	epca_timer.function = epcapoll;
 	mod_timer(&epca_timer, jiffies + HZ/25);
@@ -1400,51 +1283,47 @@ out2:
 	put_tty_driver(pc_driver);
 out1:
 	return err;
-
-} /* End pc_init */
-
-/* ------------------ Begin post_fep_init  ---------------------- */
+}
 
 static void post_fep_init(unsigned int crd)
-{ /* Begin post_fep_init */
-
+{
 	int i;
 	void __iomem *memaddr;
 	struct global_data __iomem *gd;
 	struct board_info *bd;
 	struct board_chan __iomem *bc;
-	struct channel *ch; 
-	int shrinkmem = 0, lowwater ; 
- 
-	/*  -------------------------------------------------------------
-		This call is made by the user via. the ioctl call DIGI_INIT.
-		It is responsible for setting up all the card specific stuff.
-	---------------------------------------------------------------- */
-	bd = &boards[crd];
+	struct channel *ch;
+	int shrinkmem = 0, lowwater;
 
-	/* -----------------------------------------------------------------
-		If this is a PCI board, get the port info.  Remember PCI cards
-		do not have entries into the epcaconfig.h file, so we can't get 
-		the number of ports from it.  Unfortunetly, this means that anyone
-		doing a DIGI_GETINFO before the board has booted will get an invalid
-		number of ports returned (It should return 0).  Calls to DIGI_GETINFO
-		after DIGI_INIT has been called will return the proper values. 
-	------------------------------------------------------------------- */
+	/*
+	 * This call is made by the user via. the ioctl call DIGI_INIT. It is
+	 * responsible for setting up all the card specific stuff.
+	 */
+	bd = &boards[crd];
 
+	/*
+	 * If this is a PCI board, get the port info. Remember PCI cards do not
+	 * have entries into the epcaconfig.h file, so we can't get the number
+	 * of ports from it. Unfortunetly, this means that anyone doing a
+	 * DIGI_GETINFO before the board has booted will get an invalid number
+	 * of ports returned (It should return 0). Calls to DIGI_GETINFO after
+	 * DIGI_INIT has been called will return the proper values.
+	 */
 	if (bd->type >= PCIXEM) { /* Begin get PCI number of ports */
-		/* --------------------------------------------------------------------
-			Below we use XEMPORTS as a memory offset regardless of which PCI
-			card it is.  This is because all of the supported PCI cards have
-			the same memory offset for the channel data.  This will have to be
-			changed if we ever develop a PCI/XE card.  NOTE : The FEP manual
-			states that the port offset is 0xC22 as opposed to 0xC02.  This is
-			only true for PC/XE, and PC/XI cards; not for the XEM, or CX series.
-			On the PCI cards the number of ports is determined by reading a 
-			ID PROM located in the box attached to the card.  The card can then
-			determine the index the id to determine the number of ports available.
-			(FYI - The id should be located at 0x1ac (And may use up to 4 bytes
-			if the box in question is a XEM or CX)).  
-		------------------------------------------------------------------------ */ 
+		/*
+		 * Below we use XEMPORTS as a memory offset regardless of which
+		 * PCI card it is. This is because all of the supported PCI
+		 * cards have the same memory offset for the channel data. This
+		 * will have to be changed if we ever develop a PCI/XE card.
+		 * NOTE : The FEP manual states that the port offset is 0xC22
+		 * as opposed to 0xC02. This is only true for PC/XE, and PC/XI
+		 * cards; not for the XEM, or CX series. On the PCI cards the
+		 * number of ports is determined by reading a ID PROM located
+		 * in the box attached to the card. The card can then determine
+		 * the index the id to determine the number of ports available.
+		 * (FYI - The id should be located at 0x1ac (And may use up to
+		 * 4 bytes if the box in question is a XEM or CX)).
+		 */
 		/* PCI cards are already remapped at this point ISA are not */
 		bd->numports = readw(bd->re_map_membase + XEMPORTS);
 		epcaassert(bd->numports <= 64,"PCI returned a invalid number of ports");
@@ -1465,95 +1344,87 @@ static void post_fep_init(unsigned int c
 
 	memaddr = bd->re_map_membase;
 
-	/* -----------------------------------------------------------------
-		The below assignment will set bc to point at the BEGINING of
-		the cards channel structures.  For 1 card there will be between
-		8 and 64 of these structures.
-	-------------------------------------------------------------------- */
-
+	/*
+	 * The below assignment will set bc to point at the BEGINING of the
+	 * cards channel structures. For 1 card there will be between 8 and 64
+	 * of these structures.
+	 */
 	bc = memaddr + CHANSTRUCT;
 
-	/* -------------------------------------------------------------------
-		The below assignment will set gd to point at the BEGINING of
-		global memory address 0xc00.  The first data in that global
-		memory actually starts at address 0xc1a.  The command in 
-		pointer begins at 0xd10.
-	---------------------------------------------------------------------- */
-
+	/*
+	 * The below assignment will set gd to point at the BEGINING of global
+	 * memory address 0xc00. The first data in that global memory actually
+	 * starts at address 0xc1a. The command in pointer begins at 0xd10.
+	 */
 	gd = memaddr + GLOBAL;
 
-	/* --------------------------------------------------------------------
-		XEPORTS (address 0xc22) points at the number of channels the
-		card supports. (For 64XE, XI, XEM, and XR use 0xc02)
-	----------------------------------------------------------------------- */
-
+	/*
+	 * XEPORTS (address 0xc22) points at the number of channels the card
+	 * supports. (For 64XE, XI, XEM, and XR use 0xc02)
+	 */
 	if ((bd->type == PCXEVE || bd->type == PCXE) && (readw(memaddr + XEPORTS) < 3))
 		shrinkmem = 1;
 	if (bd->type < PCIXEM)
 		if (!request_region((int)bd->port, 4, board_desc[bd->type]))
-			return;		
+			return;
 	memwinon(bd, 0);
 
-	/*  --------------------------------------------------------------------
-		Remember ch is the main drivers channels structure, while bc is 
-	   the cards channel structure.
-	------------------------------------------------------------------------ */
-
-	/* For every port on the card do ..... */
-
-	for (i = 0; i < bd->numports; i++, ch++, bc++)  { /* Begin for each port */
+	/*
+	 * Remember ch is the main drivers channels structure, while bc is the
+	 * cards channel structure.
+	 */
+	for (i = 0; i < bd->numports; i++, ch++, bc++) {
 		unsigned long flags;
 		u16 tseg, rseg;
 
-		ch->brdchan        = bc;
-		ch->mailbox        = gd; 
+		ch->brdchan = bc;
+		ch->mailbox = gd;
 		INIT_WORK(&ch->tqueue, do_softint);
-		ch->board          = &boards[crd];
+		ch->board = &boards[crd];
 
 		spin_lock_irqsave(&epca_lock, flags);
 		switch (bd->type) {
-			/* ----------------------------------------------------------------
-				Since some of the boards use different bitmaps for their
-				control signals we cannot hard code these values and retain
-				portability.  We virtualize this data here.
-			------------------------------------------------------------------- */
-			case EISAXEM:
-			case PCXEM:
-			case PCIXEM:
-			case PCIXRJ:
-			case PCIXR:
-				ch->m_rts = 0x02 ;
-				ch->m_dcd = 0x80 ; 
-				ch->m_dsr = 0x20 ;
-				ch->m_cts = 0x10 ;
-				ch->m_ri  = 0x40 ;
-				ch->m_dtr = 0x01 ;
-				break;
-
-			case PCXE:
-			case PCXEVE:
-			case PCXI:
-			case PC64XE:
-				ch->m_rts = 0x02 ;
-				ch->m_dcd = 0x08 ; 
-				ch->m_dsr = 0x10 ;
-				ch->m_cts = 0x20 ;
-				ch->m_ri  = 0x40 ;
-				ch->m_dtr = 0x80 ;
-				break;
-	
-		} /* End switch bd->type */
+		/*
+		 * Since some of the boards use different bitmaps for
+		 * their control signals we cannot hard code these
+		 * values and retain portability. We virtualize this
+		 * data here.
+		 */
+		case EISAXEM:
+		case PCXEM:
+		case PCIXEM:
+		case PCIXRJ:
+		case PCIXR:
+			ch->m_rts = 0x02;
+			ch->m_dcd = 0x80;
+			ch->m_dsr = 0x20;
+			ch->m_cts = 0x10;
+			ch->m_ri  = 0x40;
+			ch->m_dtr = 0x01;
+			break;
+
+		case PCXE:
+		case PCXEVE:
+		case PCXI:
+		case PC64XE:
+			ch->m_rts = 0x02;
+			ch->m_dcd = 0x08;
+			ch->m_dsr = 0x10;
+			ch->m_cts = 0x20;
+			ch->m_ri  = 0x40;
+			ch->m_dtr = 0x80;
+			break;
+		}
 
 		if (boards[crd].altpin) {
 			ch->dsr = ch->m_dcd;
 			ch->dcd = ch->m_dsr;
 			ch->digiext.digi_flags |= DIGI_ALTPIN;
-		}
-		else {
+		} else {
 			ch->dcd = ch->m_dcd;
 			ch->dsr = ch->m_dsr;
 		}
-	
+
 		ch->boardnum   = crd;
 		ch->channelnum = i;
 		ch->magic      = EPCA_MAGIC;
@@ -1568,71 +1439,67 @@ static void post_fep_init(unsigned int c
 		rseg = readw(&bc->rseg);
 
 		switch (bd->type) {
+		case PCIXEM:
+		case PCIXRJ:
+		case PCIXR:
+			/* Cover all the 2MEG cards */
+			ch->txptr = memaddr + ((tseg << 4) & 0x1fffff);
+			ch->rxptr = memaddr + ((rseg << 4) & 0x1fffff);
+			ch->txwin = FEPWIN | (tseg >> 11);
+			ch->rxwin = FEPWIN | (rseg >> 11);
+			break;
+
+		case PCXEM:
+		case EISAXEM:
+			/* Cover all the 32K windowed cards */
+			/* Mask equal to window size - 1 */
+			ch->txptr = memaddr + ((tseg << 4) & 0x7fff);
+			ch->rxptr = memaddr + ((rseg << 4) & 0x7fff);
+			ch->txwin = FEPWIN | (tseg >> 11);
+			ch->rxwin = FEPWIN | (rseg >> 11);
+			break;
 
-			case PCIXEM:
-			case PCIXRJ:
-			case PCIXR:
-				/* Cover all the 2MEG cards */
-				ch->txptr = memaddr + ((tseg << 4) & 0x1fffff);
-				ch->rxptr = memaddr + ((rseg << 4) & 0x1fffff);
-				ch->txwin = FEPWIN | (tseg >> 11);
-				ch->rxwin = FEPWIN | (rseg >> 11);
-				break;
-
-			case PCXEM:
-			case EISAXEM:
-				/* Cover all the 32K windowed cards */
-				/* Mask equal to window size - 1 */
-				ch->txptr = memaddr + ((tseg << 4) & 0x7fff);
-				ch->rxptr = memaddr + ((rseg << 4) & 0x7fff);
-				ch->txwin = FEPWIN | (tseg >> 11);
-				ch->rxwin = FEPWIN | (rseg >> 11);
-				break;
-
-			case PCXEVE:
-			case PCXE:
-				ch->txptr = memaddr + (((tseg - bd->memory_seg) << 4) & 0x1fff);
-				ch->txwin = FEPWIN | ((tseg - bd->memory_seg) >> 9);
-				ch->rxptr = memaddr + (((rseg - bd->memory_seg) << 4) & 0x1fff);
-				ch->rxwin = FEPWIN | ((rseg - bd->memory_seg) >>9 );
-				break;
-
-			case PCXI:
-			case PC64XE:
-				ch->txptr = memaddr + ((tseg - bd->memory_seg) << 4);
-				ch->rxptr = memaddr + ((rseg - bd->memory_seg) << 4);
-				ch->txwin = ch->rxwin = 0;
-				break;
+		case PCXEVE:
+		case PCXE:
+			ch->txptr = memaddr + (((tseg - bd->memory_seg) << 4) & 0x1fff);
+			ch->txwin = FEPWIN | ((tseg - bd->memory_seg) >> 9);
+			ch->rxptr = memaddr + (((rseg - bd->memory_seg) << 4) & 0x1fff);
+			ch->rxwin = FEPWIN | ((rseg - bd->memory_seg) >>9 );
+			break;
 
-		} /* End switch bd->type */
+		case PCXI:
+		case PC64XE:
+			ch->txptr = memaddr + ((tseg - bd->memory_seg) << 4);
+			ch->rxptr = memaddr + ((rseg - bd->memory_seg) << 4);
+			ch->txwin = ch->rxwin = 0;
+			break;
+		}
 
 		ch->txbufhead = 0;
 		ch->txbufsize = readw(&bc->tmax) + 1;
-	
+
 		ch->rxbufhead = 0;
 		ch->rxbufsize = readw(&bc->rmax) + 1;
-	
+
 		lowwater = ch->txbufsize >= 2000 ? 1024 : (ch->txbufsize / 2);
 
 		/* Set transmitter low water mark */
 		fepcmd(ch, STXLWATER, lowwater, 0, 10, 0);
 
 		/* Set receiver low water mark */
-
 		fepcmd(ch, SRXLWATER, (ch->rxbufsize / 4), 0, 10, 0);
 
 		/* Set receiver high water mark */
-
 		fepcmd(ch, SRXHWATER, (3 * ch->rxbufsize / 4), 0, 10, 0);
 
 		writew(100, &bc->edelay);
 		writeb(1, &bc->idata);
-	
+
 		ch->startc  = readb(&bc->startc);
 		ch->stopc   = readb(&bc->stopc);
 		ch->startca = readb(&bc->startca);
 		ch->stopca  = readb(&bc->stopca);
-	
+
 		ch->fepcflag = 0;
 		ch->fepiflag = 0;
 		ch->fepoflag = 0;
@@ -1640,7 +1507,7 @@ static void post_fep_init(unsigned int c
 		ch->fepstopc = 0;
 		ch->fepstartca = 0;
 		ch->fepstopca = 0;
-	
+
 		ch->close_delay = 50;
 		ch->count = 0;
 		ch->blocked_open = 0;
@@ -1648,80 +1515,66 @@ static void post_fep_init(unsigned int c
 		init_waitqueue_head(&ch->close_wait);
 
 		spin_unlock_irqrestore(&epca_lock, flags);
-	} /* End for each port */
+	}
 
-	printk(KERN_INFO 
-	        "Digi PC/Xx Driver V%s:  %s I/O = 0x%lx Mem = 0x%lx Ports = %d\n", 
+	printk(KERN_INFO
+	        "Digi PC/Xx Driver V%s:  %s I/O = 0x%lx Mem = 0x%lx Ports = %d\n",
 	        VERSION, board_desc[bd->type], (long)bd->port, (long)bd->membase, bd->numports);
 	memwinoff(bd, 0);
-
-} /* End post_fep_init */
-
-/* --------------------- Begin epcapoll  ------------------------ */
+}
 
 static void epcapoll(unsigned long ignored)
-{ /* Begin epcapoll */
-
+{
 	unsigned long flags;
 	int crd;
 	volatile unsigned int head, tail;
 	struct channel *ch;
 	struct board_info *bd;
 
-	/* -------------------------------------------------------------------
-		This routine is called upon every timer interrupt.  Even though
-		the Digi series cards are capable of generating interrupts this 
-		method of non-looping polling is more efficient.  This routine
-		checks for card generated events (Such as receive data, are transmit
-		buffer empty) and acts on those events.
-	----------------------------------------------------------------------- */
-	
-	for (crd = 0; crd < num_cards; crd++) 
-	{ /* Begin for each card */
-
+	/*
+	 * This routine is called upon every timer interrupt. Even though the
+	 * Digi series cards are capable of generating interrupts this method
+	 * of non-looping polling is more efficient. This routine checks for
+	 * card generated events (Such as receive data, are transmit buffer
+	 * empty) and acts on those events.
+	 */
+	for (crd = 0; crd < num_cards; crd++) {
 		bd = &boards[crd];
 		ch = card_ptr[crd];
 
 		if ((bd->status == DISABLED) || digi_poller_inhibited)
-			continue; /* Begin loop next interation */
-
-		/* -----------------------------------------------------------
-			assertmemoff is not needed here; indeed it is an empty subroutine.
-			It is being kept because future boards may need this as well as
-			some legacy boards.
-		---------------------------------------------------------------- */
+			continue;
 
+		/*
+		 * assertmemoff is not needed here; indeed it is an empty
+		 * subroutine. It is being kept because future boards may need
+		 * this as well as some legacy boards.
+		 */
 		spin_lock_irqsave(&epca_lock, flags);
 
 		assertmemoff(ch);
 
 		globalwinon(ch);
 
-		/* ---------------------------------------------------------------
-			In this case head and tail actually refer to the event queue not
-			the transmit or receive queue.
-		------------------------------------------------------------------- */
-
+		/*
+		 * In this case head and tail actually refer to the event queue
+		 * not the transmit or receive queue.
+		 */
 		head = readw(&ch->mailbox->ein);
 		tail = readw(&ch->mailbox->eout);
-		
-		/* If head isn't equal to tail we have an event */
 
+		/* If head isn't equal to tail we have an event */
 		if (head != tail)
 			doevent(crd);
 		memoff(ch);
 
 		spin_unlock_irqrestore(&epca_lock, flags);
-
 	} /* End for each card */
 	mod_timer(&epca_timer, jiffies + (HZ / 25));
-} /* End epcapoll */
-
-/* --------------------- Begin doevent  ------------------------ */
+}
 
 static void doevent(int crd)
-{ /* Begin doevent */
-
+{
 	void __iomem *eventbuf;
 	struct channel *ch, *chan0;
 	static struct tty_struct *tty;
@@ -1731,28 +1584,28 @@ static void doevent(int crd)
 	int event, channel;
 	int mstat, lstat;
 
-	/* -------------------------------------------------------------------
-		This subroutine is called by epcapoll when an event is detected 
-		in the event queue.  This routine responds to those events.
-	--------------------------------------------------------------------- */
+	/*
+	 * This subroutine is called by epcapoll when an event is detected
+	 * in the event queue. This routine responds to those events.
+	 */
 	bd = &boards[crd];
 
 	chan0 = card_ptr[crd];
 	epcaassert(chan0 <= &digi_channels[nbdevs - 1], "ch out of range");
 	assertgwinon(chan0);
-	while ((tail = readw(&chan0->mailbox->eout)) != (head = readw(&chan0->mailbox->ein)))
-	{ /* Begin while something in event queue */
+	while ((tail = readw(&chan0->mailbox->eout)) != (head = readw(&chan0->mailbox->ein))) { /* Begin while something in event queue */
 		assertgwinon(chan0);
 		eventbuf = bd->re_map_membase + tail + ISTART;
 		/* Get the channel the event occurred on */
 		channel = readb(eventbuf);
 		/* Get the actual event code that occurred */
 		event = readb(eventbuf + 1);
-		/*  ----------------------------------------------------------------
-			The two assignments below get the current modem status (mstat)
-			and the previous modem status (lstat).  These are useful becuase
-			an event could signal a change in modem signals itself.
-		------------------------------------------------------------------- */
+		/*
+		 * The two assignments below get the current modem status
+		 * (mstat) and the previous modem status (lstat). These are
+		 * useful becuase an event could signal a change in modem
+		 * signals itself.
+		 */
 		mstat = readb(eventbuf + 2);
 		lstat = readb(eventbuf + 3);
 
@@ -1772,37 +1625,36 @@ static void doevent(int crd)
 			assertgwinon(ch);
 		} /* End DATA_IND */
 		/* else *//* Fix for DCD transition missed bug */
-		if (event & MODEMCHG_IND)  { /* Begin MODEMCHG_IND */
+		if (event & MODEMCHG_IND) {
 			/* A modem signal change has been indicated */
 			ch->imodem = mstat;
-			if (ch->asyncflags & ASYNC_CHECK_CD)  {
+			if (ch->asyncflags & ASYNC_CHECK_CD) {
 				if (mstat & ch->dcd)  /* We are now receiving dcd */
 					wake_up_interruptible(&ch->open_wait);
 				else
 					pc_sched_event(ch, EPCA_EVENT_HANGUP); /* No dcd; hangup */
 			}
-		} /* End MODEMCHG_IND */
+		}
 		tty = ch->tty;
-		if (tty)  { /* Begin if valid tty */
-			if (event & BREAK_IND)  { /* Begin if BREAK_IND */
+		if (tty) {
+			if (event & BREAK_IND) {
 				/* A break has been indicated */
 				tty_insert_flip_char(tty, 0, TTY_BREAK);
-				tty_schedule_flip(tty); 
-			} else if (event & LOWTX_IND)  { /* Begin LOWTX_IND */
-				if (ch->statusflags & LOWWAIT) 
-				{ /* Begin if LOWWAIT */
+				tty_schedule_flip(tty);
+			} else if (event & LOWTX_IND)  {
+				if (ch->statusflags & LOWWAIT) {
 					ch->statusflags &= ~LOWWAIT;
 					tty_wakeup(tty);
-				} /* End if LOWWAIT */
-			} else if (event & EMPTYTX_IND)  { /* Begin EMPTYTX_IND */
+				}
+			} else if (event & EMPTYTX_IND) {
 				/* This event is generated by setup_empty_event */
 				ch->statusflags &= ~TXBUSY;
-				if (ch->statusflags & EMPTYWAIT)  { /* Begin if EMPTYWAIT */
+				if (ch->statusflags & EMPTYWAIT) {
 					ch->statusflags &= ~EMPTYWAIT;
 					tty_wakeup(tty);
-				} /* End if EMPTYWAIT */
-			} /* End EMPTYTX_IND */
-		} /* End if valid tty */
+				}
+			}
+		}
 	next:
 		globalwinon(ch);
 		BUG_ON(!bc);
@@ -1810,13 +1662,11 @@ static void doevent(int crd)
 		writew((tail + 4) & (IMAX - ISTART - 4), &chan0->mailbox->eout);
 		globalwinon(chan0);
 	} /* End while something in event queue */
-} /* End doevent */
-
-/* --------------------- Begin fepcmd  ------------------------ */
+}
 
 static void fepcmd(struct channel *ch, int cmd, int word_or_byte,
                    int byte2, int ncmds, int bytecmd)
-{ /* Begin fepcmd */
+{
 	unchar __iomem *memaddr;
 	unsigned int head, cmdTail, cmdStart, cmdMax;
 	long count;
@@ -1831,11 +1681,11 @@ static void fepcmd(struct channel *ch, i
 	head = readw(&ch->mailbox->cin);
 	/* cmdStart is a base address */
 	cmdStart = readw(&ch->mailbox->cstart);
-	/* ------------------------------------------------------------------
-		We do the addition below because we do not want a max pointer 
-		relative to cmdStart.  We want a max pointer that points at the 
-		physical end of the command queue.
-	-------------------------------------------------------------------- */
+	/*
+	 * We do the addition below because we do not want a max pointer
+	 * relative to cmdStart. We want a max pointer that points at the
+	 * physical end of the command queue.
+	 */
 	cmdMax = (cmdStart + 4 + readw(&ch->mailbox->cmax));
 	memaddr = ch->board->re_map_membase;
 
@@ -1860,7 +1710,7 @@ static void fepcmd(struct channel *ch, i
 	writew(head, &ch->mailbox->cin);
 	count = FEPTIMEOUT;
 
-	for (;;)  { /* Begin forever loop */
+	for (;;) {
 		count--;
 		if (count == 0)  {
 			printk(KERN_ERR "<Error> - Fep not responding in fepcmd()\n");
@@ -1869,26 +1719,23 @@ static void fepcmd(struct channel *ch, i
 		head = readw(&ch->mailbox->cin);
 		cmdTail = readw(&ch->mailbox->cout);
 		n = (head - cmdTail) & (cmdMax - cmdStart - 4);
-		/* ----------------------------------------------------------
-			Basically this will break when the FEP acknowledges the 
-			command by incrementing cmdTail (Making it equal to head).
-		------------------------------------------------------------- */
+		/*
+		 * Basically this will break when the FEP acknowledges the
+		 * command by incrementing cmdTail (Making it equal to head).
+		 */
 		if (n <= ncmds * (sizeof(short) * 4))
-			break; /* Well nearly forever :-) */
-	} /* End forever loop */
-} /* End fepcmd */
-
-/* ---------------------------------------------------------------------
-	Digi products use fields in their channels structures that are very
-	similar to the c_cflag and c_iflag fields typically found in UNIX
-	termios structures.  The below three routines allow mappings 
-	between these hardware "flags" and their respective Linux flags.
-------------------------------------------------------------------------- */
- 
-/* --------------------- Begin termios2digi_h -------------------- */
+			break;
+	}
+}
 
+/*
+ * Digi products use fields in their channels structures that are very similar
+ * to the c_cflag and c_iflag fields typically found in UNIX termios
+ * structures. The below three routines allow mappings between these hardware
+ * "flags" and their respective Linux flags.
+ */
 static unsigned termios2digi_h(struct channel *ch, unsigned cflag)
-{ /* Begin termios2digi_h */
+{
 	unsigned res = 0;
 
 	if (cflag & CRTSCTS) {
@@ -1918,86 +1765,73 @@ static unsigned termios2digi_h(struct ch
 		ch->digiext.digi_flags |= CTSPACE;
 
 	return res;
+}
 
-} /* End termios2digi_h */
-
-/* --------------------- Begin termios2digi_i -------------------- */
 static unsigned termios2digi_i(struct channel *ch, unsigned iflag)
-{ /* Begin termios2digi_i */
-
-	unsigned res = iflag & (IGNBRK | BRKINT | IGNPAR | PARMRK | 
+{
+	unsigned res = iflag & (IGNBRK | BRKINT | IGNPAR | PARMRK |
 	                        INPCK | ISTRIP|IXON|IXANY|IXOFF);
 	if (ch->digiext.digi_flags & DIGI_AIXON)
 		res |= IAIXON;
 	return res;
-
-} /* End termios2digi_i */
-
-/* --------------------- Begin termios2digi_c -------------------- */
+}
 
 static unsigned termios2digi_c(struct channel *ch, unsigned cflag)
-{ /* Begin termios2digi_c */
-
+{
 	unsigned res = 0;
-	if (cflag & CBAUDEX) { /* Begin detected CBAUDEX */
+	if (cflag & CBAUDEX) {
 		ch->digiext.digi_flags |= DIGI_FAST;
-		/* -------------------------------------------------------------
-		   HUPCL bit is used by FEP to indicate fast baud
-		   table is to be used.
-		----------------------------------------------------------------- */
+		/*
+		 * HUPCL bit is used by FEP to indicate fast baud table is to
+		 * be used.
+		 */
 		res |= FEP_HUPCL;
-	} /* End detected CBAUDEX */
-	else ch->digiext.digi_flags &= ~DIGI_FAST; 
-	/* -------------------------------------------------------------------
-		CBAUD has bit position 0x1000 set these days to indicate Linux
-		baud rate remap.  Digi hardware can't handle the bit assignment.
-		(We use a different bit assignment for high speed.).  Clear this
-		bit out.
-	---------------------------------------------------------------------- */
+	} else
+		ch->digiext.digi_flags &= ~DIGI_FAST;
+	/*
+	 * CBAUD has bit position 0x1000 set these days to indicate Linux
+	 * baud rate remap. Digi hardware can't handle the bit assignment.
+	 * (We use a different bit assignment for high speed.). Clear this
+	 * bit out.
+	 */
 	res |= cflag & ((CBAUD ^ CBAUDEX) | PARODD | PARENB | CSTOPB | CSIZE);
-	/* -------------------------------------------------------------
-		This gets a little confusing.  The Digi cards have their own
-		representation of c_cflags controling baud rate.  For the most
-		part this is identical to the Linux implementation.  However;
-		Digi supports one rate (76800) that Linux doesn't.  This means 
-		that the c_cflag entry that would normally mean 76800 for Digi
-		actually means 115200 under Linux.  Without the below mapping,
-		a stty 115200 would only drive the board at 76800.  Since 
-		the rate 230400 is also found after 76800, the same problem afflicts	
-		us when we choose a rate of 230400.  Without the below modificiation
-		stty 230400 would actually give us 115200.
-
-		There are two additional differences.  The Linux value for CLOCAL
-		(0x800; 0004000) has no meaning to the Digi hardware.  Also in 
-		later releases of Linux; the CBAUD define has CBAUDEX (0x1000;
-		0010000) ored into it (CBAUD = 0x100f as opposed to 0xf). CBAUDEX
-		should be checked for a screened out prior to termios2digi_c 
-		returning.  Since CLOCAL isn't used by the board this can be
-		ignored as long as the returned value is used only by Digi hardware. 
-		----------------------------------------------------------------- */
+	/*
+	 * This gets a little confusing. The Digi cards have their own
+	 * representation of c_cflags controling baud rate. For the most part
+	 * this is identical to the Linux implementation. However; Digi
+	 * supports one rate (76800) that Linux doesn't. This means that the
+	 * c_cflag entry that would normally mean 76800 for Digi actually means
+	 * 115200 under Linux. Without the below mapping, a stty 115200 would
+	 * only drive the board at 76800. Since the rate 230400 is also found
+	 * after 76800, the same problem afflicts us when we choose a rate of
+	 * 230400. Without the below modificiation stty 230400 would actually
+	 * give us 115200.
+	 *
+	 * There are two additional differences. The Linux value for CLOCAL
+	 * (0x800; 0004000) has no meaning to the Digi hardware. Also in later
+	 * releases of Linux; the CBAUD define has CBAUDEX (0x1000; 0010000)
+	 * ored into it (CBAUD = 0x100f as opposed to 0xf). CBAUDEX should be
+	 * checked for a screened out prior to termios2digi_c returning. Since
+	 * CLOCAL isn't used by the board this can be ignored as long as the
+	 * returned value is used only by Digi hardware.
+	 */
 	if (cflag & CBAUDEX) {
-		/* -------------------------------------------------------------
-			The below code is trying to guarantee that only baud rates
-			115200 and 230400 are remapped.  We use exclusive or because
-			the various baud rates share common bit positions and therefore
-			can't be tested for easily.
-		----------------------------------------------------------------- */
-
-				
-		if ((!((cflag & 0x7) ^ (B115200 & ~CBAUDEX))) || 
+		/*
+		 * The below code is trying to guarantee that only baud rates
+		 * 115200 and 230400 are remapped. We use exclusive or because
+		 * the various baud rates share common bit positions and
+		 * therefore can't be tested for easily.
+		 */
+		if ((!((cflag & 0x7) ^ (B115200 & ~CBAUDEX))) ||
 		    (!((cflag & 0x7) ^ (B230400 & ~CBAUDEX))))
 			res += 1;
 	}
 	return res;
-
-} /* End termios2digi_c */
-
-/* --------------------- Begin epcaparam  ----------------------- */
+}
 
 /* Caller must hold the locks */
 static void epcaparam(struct tty_struct *tty, struct channel *ch)
-{ /* Begin epcaparam */
-
+{
 	unsigned int cmdHead;
 	struct ktermios *ts;
 	struct board_chan __iomem *bc;
@@ -2013,28 +1847,29 @@ static void epcaparam(struct tty_struct 
 		writew(cmdHead, &bc->rout);
 		cmdHead = readw(&bc->tin);
 		/* Changing baud in mid-stream transmission can be wonderful */
-		/* ---------------------------------------------------------------
-			Flush current transmit buffer by setting cmdTail pointer (tout)
-			to cmdHead pointer (tin).  Hopefully the transmit buffer is empty.
-		----------------------------------------------------------------- */
+		/*
+		 * Flush current transmit buffer by setting cmdTail pointer
+		 * (tout) to cmdHead pointer (tin). Hopefully the transmit
+		 * buffer is empty.
+		 */
 		fepcmd(ch, STOUT, (unsigned) cmdHead, 0, 0, 0);
 		mval = 0;
-	} else  { /* Begin CBAUD not detected */
-		/* -------------------------------------------------------------------
-			c_cflags have changed but that change had nothing to do with BAUD.
-			Propagate the change to the card.
-		---------------------------------------------------------------------- */ 
+	} else { /* Begin CBAUD not detected */
+		/*
+		 * c_cflags have changed but that change had nothing to do with
+		 * BAUD. Propagate the change to the card.
+		 */
 		cflag = termios2digi_c(ch, ts->c_cflag);
 		if (cflag != ch->fepcflag)  {
 			ch->fepcflag = cflag;
 			/* Set baud rate, char size, stop bits, parity */
 			fepcmd(ch, SETCTRLFLAGS, (unsigned) cflag, 0, 0, 0);
 		}
-		/* ----------------------------------------------------------------
-			If the user has not forced CLOCAL and if the device is not a 
-			CALLOUT device (Which is always CLOCAL) we set flags such that
-			the driver will wait on carrier detect.
-		------------------------------------------------------------------- */
+		/*
+		 * If the user has not forced CLOCAL and if the device is not a
+		 * CALLOUT device (Which is always CLOCAL) we set flags such
+		 * that the driver will wait on carrier detect.
+		 */
 		if (ts->c_cflag & CLOCAL)
 			ch->asyncflags &= ~ASYNC_CHECK_CD;
 		else
@@ -2045,19 +1880,19 @@ static void epcaparam(struct tty_struct 
 	/* Check input mode flags */
 	if (iflag != ch->fepiflag)  {
 		ch->fepiflag = iflag;
-		/* ---------------------------------------------------------------
-			Command sets channels iflag structure on the board. Such things 
-			as input soft flow control, handling of parity errors, and
-			break handling are all set here.
-		------------------------------------------------------------------- */
+		/*
+		 * Command sets channels iflag structure on the board. Such
+		 * things as input soft flow control, handling of parity
+		 * errors, and break handling are all set here.
+		 */
 		/* break handling, parity handling, input stripping, flow control chars */
 		fepcmd(ch, SETIFLAGS, (unsigned int) ch->fepiflag, 0, 0, 0);
 	}
-	/* ---------------------------------------------------------------
-		Set the board mint value for this channel.  This will cause hardware
-		events to be generated each time the DCD signal (Described in mint) 
-		changes.	
-	------------------------------------------------------------------- */
+	/*
+	 * Set the board mint value for this channel. This will cause hardware
+	 * events to be generated each time the DCD signal (Described in mint)
+	 * changes.
+	 */
 	writeb(ch->dcd, &bc->mint);
 	if ((ts->c_cflag & CLOCAL) || (ch->digiext.digi_flags & DIGI_FORCEDCD))
 		if (ch->digiext.digi_flags & DIGI_FORCEDCD)
@@ -2066,23 +1901,23 @@ static void epcaparam(struct tty_struct 
 	hflow = termios2digi_h(ch, ts->c_cflag);
 	if (hflow != ch->hflow)  {
 		ch->hflow = hflow;
-		/* --------------------------------------------------------------
-			Hard flow control has been selected but the board is not
-			using it.  Activate hard flow control now.
-		----------------------------------------------------------------- */
+		/*
+		 * Hard flow control has been selected but the board is not
+		 * using it. Activate hard flow control now.
+		 */
 		fepcmd(ch, SETHFLOW, hflow, 0xff, 0, 1);
 	}
 	mval ^= ch->modemfake & (mval ^ ch->modem);
 
 	if (ch->omodem ^ mval)  {
 		ch->omodem = mval;
-		/* --------------------------------------------------------------
-			The below command sets the DTR and RTS mstat structure.  If
-			hard flow control is NOT active these changes will drive the
-			output of the actual DTR and RTS lines.  If hard flow control 
-			is active, the changes will be saved in the mstat structure and
-			only asserted when hard flow control is turned off. 
-		----------------------------------------------------------------- */
+		/*
+		 * The below command sets the DTR and RTS mstat structure. If
+		 * hard flow control is NOT active these changes will drive the
+		 * output of the actual DTR and RTS lines. If hard flow control
+		 * is active, the changes will be saved in the mstat structure
+		 * and only asserted when hard flow control is turned off.
+		 */
 
 		/* First reset DTR & RTS; then set them */
 		fepcmd(ch, SETMODEM, 0, ((ch->m_dtr)|(ch->m_rts)), 0, 1);
@@ -2091,28 +1926,26 @@ static void epcaparam(struct tty_struct 
 	if (ch->startc != ch->fepstartc || ch->stopc != ch->fepstopc)  {
 		ch->fepstartc = ch->startc;
 		ch->fepstopc = ch->stopc;
-		/* ------------------------------------------------------------
-			The XON / XOFF characters have changed; propagate these
-			changes to the card.	
-		--------------------------------------------------------------- */
+		/*
+		 * The XON / XOFF characters have changed; propagate these
+		 * changes to the card.
+		 */
 		fepcmd(ch, SONOFFC, ch->fepstartc, ch->fepstopc, 0, 1);
 	}
 	if (ch->startca != ch->fepstartca || ch->stopca != ch->fepstopca)  {
 		ch->fepstartca = ch->startca;
 		ch->fepstopca = ch->stopca;
-		/* ---------------------------------------------------------------
-			Similar to the above, this time the auxilarly XON / XOFF 
-			characters have changed; propagate these changes to the card.
-		------------------------------------------------------------------ */
+		/*
+		 * Similar to the above, this time the auxilarly XON / XOFF
+		 * characters have changed; propagate these changes to the card.
+		 */
 		fepcmd(ch, SAUXONOFFC, ch->fepstartca, ch->fepstopca, 0, 1);
 	}
-} /* End epcaparam */
+}
 
-/* --------------------- Begin receive_data  ----------------------- */
 /* Caller holds lock */
 static void receive_data(struct channel *ch)
-{ /* Begin receive_data */
-
+{
 	unchar *rptr;
 	struct ktermios *ts = NULL;
 	struct tty_struct *tty;
@@ -2121,11 +1954,10 @@ static void receive_data(struct channel 
 	unsigned int tail, head;
 	unsigned int wrapmask;
 
-	/* ---------------------------------------------------------------
-		This routine is called by doint when a receive data event 
-		has taken place.
-	------------------------------------------------------------------- */
-
+	/*
+	 * This routine is called by doint when a receive data event has taken
+	 * place.
+	 */
 	globalwinon(ch);
 	if (ch->statusflags & RXSTOPPED)
 		return;
@@ -2136,10 +1968,10 @@ static void receive_data(struct channel 
 	BUG_ON(!bc);
 	wrapmask = ch->rxbufsize - 1;
 
-	/* --------------------------------------------------------------------- 
-		Get the head and tail pointers to the receiver queue.  Wrap the 
-		head pointer if it has reached the end of the buffer.
-	------------------------------------------------------------------------ */
+	/*
+	 * Get the head and tail pointers to the receiver queue. Wrap the head
+	 * pointer if it has reached the end of the buffer.
+	 */
 	head = readw(&bc->rin);
 	head &= wrapmask;
 	tail = readw(&bc->rout) & wrapmask;
@@ -2148,10 +1980,7 @@ static void receive_data(struct channel 
 	if (bytesAvailable == 0)
 		return;
 
-	/* ------------------------------------------------------------------
-	   If CREAD bit is off or device not open, set TX tail to head
-	--------------------------------------------------------------------- */
-
+	/* If CREAD bit is off or device not open, set TX tail to head */
 	if (!tty || !ts || !(ts->c_cflag & CREAD))  {
 		writew(head, &bc->rout);
 		return;
@@ -2168,22 +1997,20 @@ static void receive_data(struct channel 
 	rxwinon(ch);
 	while (bytesAvailable > 0)  { /* Begin while there is data on the card */
 		wrapgap = (head >= tail) ? head - tail : ch->rxbufsize - tail;
-		/* ---------------------------------------------------------------
-			Even if head has wrapped around only report the amount of
-			data to be equal to the size - tail.  Remember memcpy can't
-			automaticly wrap around the receive buffer.
-		----------------------------------------------------------------- */
+		/*
+		 * Even if head has wrapped around only report the amount of
+		 * data to be equal to the size - tail. Remember memcpy can't
+		 * automaticly wrap around the receive buffer.
+		 */
 		dataToRead = (wrapgap < bytesAvailable) ? wrapgap : bytesAvailable;
-		/* --------------------------------------------------------------
-		   Make sure we don't overflow the buffer
-		----------------------------------------------------------------- */
+		/* Make sure we don't overflow the buffer */
 		dataToRead = tty_prepare_flip_string(tty, &rptr, dataToRead);
 		if (dataToRead == 0)
 			break;
-		/* ---------------------------------------------------------------
-			Move data read from our card into the line disciplines buffer
-			for translation if necessary.
-		------------------------------------------------------------------ */
+		/*
+		 * Move data read from our card into the line disciplines
+		 * buffer for translation if necessary.
+		 */
 		memcpy_fromio(rptr, ch->rxptr + tail, dataToRead);
 		tail = (tail + dataToRead) & wrapmask;
 		bytesAvailable -= dataToRead;
@@ -2191,28 +2018,26 @@ static void receive_data(struct channel 
 	globalwinon(ch);
 	writew(tail, &bc->rout);
 	/* Must be called with global data */
-	tty_schedule_flip(ch->tty); 
-	return;
-} /* End receive_data */
+	tty_schedule_flip(ch->tty);
+}
 
-static int info_ioctl(struct tty_struct *tty, struct file * file,
+static int info_ioctl(struct tty_struct *tty, struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
-	switch (cmd) 
-	{ /* Begin switch cmd */
-		case DIGI_GETINFO:
-		{ /* Begin case DIGI_GETINFO */
-			struct digi_info di ;
+	switch (cmd) {
+	case DIGI_GETINFO:
+		{
+			struct digi_info di;
 			int brd;
 
-			if(get_user(brd, (unsigned int __user *)arg))
+			if (get_user(brd, (unsigned int __user *)arg))
 				return -EFAULT;
 			if (brd < 0 || brd >= num_cards || num_cards == 0)
 				return -ENODEV;
 
 			memset(&di, 0, sizeof(di));
 
-			di.board = brd ; 
+			di.board = brd;
 			di.status = boards[brd].status;
 			di.type = boards[brd].type ;
 			di.numports = boards[brd].numports ;
@@ -2220,45 +2045,44 @@ static int info_ioctl(struct tty_struct 
 			di.port = (unsigned char *)boards[brd].port ;
 			di.membase = (unsigned char *)boards[brd].membase ;
 
-			if (copy_to_user((void __user *)arg, &di, sizeof (di)))
+			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
 				return -EFAULT;
 			break;
 
-		} /* End case DIGI_GETINFO */
-
-		case DIGI_POLLER:
-		{ /* Begin case DIGI_POLLER */
+		}
 
-			int brd = arg & 0xff000000 >> 16 ; 
-			unsigned char state = arg & 0xff ; 
+	case DIGI_POLLER:
+		{
+			int brd = arg & 0xff000000 >> 16;
+			unsigned char state = arg & 0xff;
 
 			if (brd < 0 || brd >= num_cards) {
 				printk(KERN_ERR "epca: DIGI POLLER : brd not valid!\n");
-				return (-ENODEV);
+				return -ENODEV;
 			}
-			digi_poller_inhibited = state ;
-			break ; 
-		} /* End case DIGI_POLLER */
-
-		case DIGI_INIT:
-		{ /* Begin case DIGI_INIT */
-			/* ------------------------------------------------------------
-				This call is made by the apps to complete the initilization
-				of the board(s).  This routine is responsible for setting
-				the card to its initial state and setting the drivers control
-				fields to the sutianle settings for the card in question.
-			---------------------------------------------------------------- */
-			int crd ; 
-			for (crd = 0; crd < num_cards; crd++) 
-				post_fep_init (crd);
-			break ; 
-		} /* End case DIGI_INIT */
-		default:
-			return -ENOTTY;
-	} /* End switch cmd */
-	return (0) ;
+			digi_poller_inhibited = state;
+			break;
+		}
+
+	case DIGI_INIT:
+		{
+			/*
+			 * This call is made by the apps to complete the
+			 * initilization of the board(s). This routine is
+			 * responsible for setting the card to its initial
+			 * state and setting the drivers control fields to the
+			 * sutianle settings for the card in question.
+			 */
+			int crd;
+			for (crd = 0; crd < num_cards; crd++)
+				post_fep_init(crd);
+			break;
+		}
+	default:
+		return -ENOTTY;
+	}
+	return 0;
 }
-/* --------------------- Begin pc_ioctl  ----------------------- */
 
 static int pc_tiocmget(struct tty_struct *tty, struct file *file)
 {
@@ -2304,9 +2128,9 @@ static int pc_tiocmset(struct tty_struct
 
 	spin_lock_irqsave(&epca_lock, flags);
 	/*
-	 * I think this modemfake stuff is broken.  It doesn't
-	 * correctly reflect the behaviour desired by the TIOCM*
-	 * ioctls.  Therefore this is probably broken.
+	 * I think this modemfake stuff is broken. It doesn't correctly reflect
+	 * the behaviour desired by the TIOCM* ioctls. Therefore this is
+	 * probably broken.
 	 */
 	if (set & TIOCM_RTS) {
 		ch->modemfake |= ch->m_rts;
@@ -2325,10 +2149,10 @@ static int pc_tiocmset(struct tty_struct
 		ch->modem &= ~ch->m_dtr;
 	}
 	globalwinon(ch);
-	/*  --------------------------------------------------------------
-		The below routine generally sets up parity, baud, flow control
-		issues, etc.... It effect both control flags and input flags.
-	------------------------------------------------------------------ */
+	/*
+	 * The below routine generally sets up parity, baud, flow control
+	 * issues, etc.... It effect both control flags and input flags.
+	 */
 	epcaparam(tty,ch);
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
@@ -2337,8 +2161,7 @@ static int pc_tiocmset(struct tty_struct
 
 static int pc_ioctl(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg)
-{ /* Begin pc_ioctl */
-
+{
 	digiflow_t dflow;
 	int retval;
 	unsigned long flags;
@@ -2347,49 +2170,47 @@ static int pc_ioctl(struct tty_struct *t
 	struct board_chan __iomem *bc;
 	struct channel *ch = (struct channel *) tty->driver_data;
 	void __user *argp = (void __user *)arg;
-	
+
 	if (ch)
 		bc = ch->brdchan;
-	else 
+	else
 		return -EINVAL;
 
-	/* -------------------------------------------------------------------
-		For POSIX compliance we need to add more ioctls.  See tty_ioctl.c
-		in /usr/src/linux/drivers/char for a good example.  In particular 
-		think about adding TCSETAF, TCSETAW, TCSETA, TCSETSF, TCSETSW, TCSETS.
-	---------------------------------------------------------------------- */
-
-	switch (cmd) 
-	{ /* Begin switch cmd */
-		case TCSBRK:	/* SVID version: non-zero arg --> no break */
-			retval = tty_check_change(tty);
-			if (retval)
-				return retval;
-			/* Setup an event to indicate when the transmit buffer empties */
-			spin_lock_irqsave(&epca_lock, flags);
-			setup_empty_event(tty,ch);		
-			spin_unlock_irqrestore(&epca_lock, flags);
-			tty_wait_until_sent(tty, 0);
-			if (!arg)
-				digi_send_break(ch, HZ/4);    /* 1/4 second */
-			return 0;
-		case TCSBRKP:	/* support for POSIX tcsendbreak() */
-			retval = tty_check_change(tty);
-			if (retval)
-				return retval;
+	/*
+	 * For POSIX compliance we need to add more ioctls. See tty_ioctl.c in
+	 * /usr/src/linux/drivers/char for a good example. In particular think
+	 * about adding TCSETAF, TCSETAW, TCSETA, TCSETSF, TCSETSW, TCSETS.
+	 */
+	switch (cmd) {
+	case TCSBRK:	/* SVID version: non-zero arg --> no break */
+		retval = tty_check_change(tty);
+		if (retval)
+			return retval;
+		/* Setup an event to indicate when the transmit buffer empties */
+		spin_lock_irqsave(&epca_lock, flags);
+		setup_empty_event(tty,ch);
+		spin_unlock_irqrestore(&epca_lock, flags);
+		tty_wait_until_sent(tty, 0);
+		if (!arg)
+			digi_send_break(ch, HZ / 4);    /* 1/4 second */
+		return 0;
+	case TCSBRKP:	/* support for POSIX tcsendbreak() */
+		retval = tty_check_change(tty);
+		if (retval)
+			return retval;
 
-			/* Setup an event to indicate when the transmit buffer empties */
-			spin_lock_irqsave(&epca_lock, flags);
-			setup_empty_event(tty,ch);		
-			spin_unlock_irqrestore(&epca_lock, flags);
-			tty_wait_until_sent(tty, 0);
-			digi_send_break(ch, arg ? arg*(HZ/10) : HZ/4);
-			return 0;
-		case TIOCGSOFTCAR:
-			if (put_user(C_CLOCAL(tty)?1:0, (unsigned long __user *)arg))
-				return -EFAULT;
-			return 0;
-		case TIOCSSOFTCAR:
+		/* Setup an event to indicate when the transmit buffer empties */
+		spin_lock_irqsave(&epca_lock, flags);
+		setup_empty_event(tty,ch);
+		spin_unlock_irqrestore(&epca_lock, flags);
+		tty_wait_until_sent(tty, 0);
+		digi_send_break(ch, arg ? arg*(HZ/10) : HZ/4);
+		return 0;
+	case TIOCGSOFTCAR:
+		if (put_user(C_CLOCAL(tty)?1:0, (unsigned long __user *)arg))
+			return -EFAULT;
+		return 0;
+	case TIOCSSOFTCAR:
 		{
 			unsigned int value;
 
@@ -2400,144 +2221,141 @@ static int pc_ioctl(struct tty_struct *t
 				 (value ? CLOCAL : 0));
 			return 0;
 		}
-		case TIOCMODG:
-			mflag = pc_tiocmget(tty, file);
-			if (put_user(mflag, (unsigned long __user *)argp))
-				return -EFAULT;
-			break;
-		case TIOCMODS:
-			if (get_user(mstat, (unsigned __user *)argp))
-				return -EFAULT;
-			return pc_tiocmset(tty, file, mstat, ~mstat);
-		case TIOCSDTR:
-			spin_lock_irqsave(&epca_lock, flags);
-			ch->omodem |= ch->m_dtr;
-			globalwinon(ch);
-			fepcmd(ch, SETMODEM, ch->m_dtr, 0, 10, 1);
-			memoff(ch);
-			spin_unlock_irqrestore(&epca_lock, flags);
-			break;
+	case TIOCMODG:
+		mflag = pc_tiocmget(tty, file);
+		if (put_user(mflag, (unsigned long __user *)argp))
+			return -EFAULT;
+		break;
+	case TIOCMODS:
+		if (get_user(mstat, (unsigned __user *)argp))
+			return -EFAULT;
+		return pc_tiocmset(tty, file, mstat, ~mstat);
+	case TIOCSDTR:
+		spin_lock_irqsave(&epca_lock, flags);
+		ch->omodem |= ch->m_dtr;
+		globalwinon(ch);
+		fepcmd(ch, SETMODEM, ch->m_dtr, 0, 10, 1);
+		memoff(ch);
+		spin_unlock_irqrestore(&epca_lock, flags);
+		break;
 
-		case TIOCCDTR:
+	case TIOCCDTR:
+		spin_lock_irqsave(&epca_lock, flags);
+		ch->omodem &= ~ch->m_dtr;
+		globalwinon(ch);
+		fepcmd(ch, SETMODEM, 0, ch->m_dtr, 10, 1);
+		memoff(ch);
+		spin_unlock_irqrestore(&epca_lock, flags);
+		break;
+	case DIGI_GETA:
+		if (copy_to_user(argp, &ch->digiext, sizeof(digi_t)))
+			return -EFAULT;
+		break;
+	case DIGI_SETAW:
+	case DIGI_SETAF:
+		if (cmd == DIGI_SETAW) {
+			/* Setup an event to indicate when the transmit buffer empties */
 			spin_lock_irqsave(&epca_lock, flags);
-			ch->omodem &= ~ch->m_dtr;
-			globalwinon(ch);
-			fepcmd(ch, SETMODEM, 0, ch->m_dtr, 10, 1);
-			memoff(ch);
+			setup_empty_event(tty,ch);
 			spin_unlock_irqrestore(&epca_lock, flags);
-			break;
-		case DIGI_GETA:
-			if (copy_to_user(argp, &ch->digiext, sizeof(digi_t)))
-				return -EFAULT;
-			break;
-		case DIGI_SETAW:
-		case DIGI_SETAF:
-			if (cmd == DIGI_SETAW) {
-				/* Setup an event to indicate when the transmit buffer empties */
-				spin_lock_irqsave(&epca_lock, flags);
-				setup_empty_event(tty,ch);		
-				spin_unlock_irqrestore(&epca_lock, flags);
-				tty_wait_until_sent(tty, 0);
-			} else 	{
-				/* ldisc lock already held in ioctl */
-				if (tty->ldisc.flush_buffer)
-					tty->ldisc.flush_buffer(tty);
-			}
-			/* Fall Thru */
-		case DIGI_SETA:
-			if (copy_from_user(&ch->digiext, argp, sizeof(digi_t)))
-				return -EFAULT;
-			
-			if (ch->digiext.digi_flags & DIGI_ALTPIN)  {
-				ch->dcd = ch->m_dsr;
-				ch->dsr = ch->m_dcd;
-			} else {
-				ch->dcd = ch->m_dcd;
-				ch->dsr = ch->m_dsr;
+			tty_wait_until_sent(tty, 0);
+		} else {
+			/* ldisc lock already held in ioctl */
+			if (tty->ldisc.flush_buffer)
+				tty->ldisc.flush_buffer(tty);
+		}
+		/* Fall Thru */
+	case DIGI_SETA:
+		if (copy_from_user(&ch->digiext, argp, sizeof(digi_t)))
+			return -EFAULT;
+
+		if (ch->digiext.digi_flags & DIGI_ALTPIN)  {
+			ch->dcd = ch->m_dsr;
+			ch->dsr = ch->m_dcd;
+		} else {
+			ch->dcd = ch->m_dcd;
+			ch->dsr = ch->m_dsr;
 			}
-		
-			spin_lock_irqsave(&epca_lock, flags);
-			globalwinon(ch);
 
-			/* -----------------------------------------------------------------
-				The below routine generally sets up parity, baud, flow control 
-				issues, etc.... It effect both control flags and input flags.
-			------------------------------------------------------------------- */
+		spin_lock_irqsave(&epca_lock, flags);
+		globalwinon(ch);
 
-			epcaparam(tty,ch);
-			memoff(ch);
-			spin_unlock_irqrestore(&epca_lock, flags);
-			break;
+		/*
+		 * The below routine generally sets up parity, baud, flow
+		 * control issues, etc.... It effect both control flags and
+		 * input flags.
+		 */
+		epcaparam(tty,ch);
+		memoff(ch);
+		spin_unlock_irqrestore(&epca_lock, flags);
+		break;
+
+	case DIGI_GETFLOW:
+	case DIGI_GETAFLOW:
+		spin_lock_irqsave(&epca_lock, flags);
+		globalwinon(ch);
+		if (cmd == DIGI_GETFLOW) {
+			dflow.startc = readb(&bc->startc);
+			dflow.stopc = readb(&bc->stopc);
+		} else {
+			dflow.startc = readb(&bc->startca);
+			dflow.stopc = readb(&bc->stopca);
+		}
+		memoff(ch);
+		spin_unlock_irqrestore(&epca_lock, flags);
+
+		if (copy_to_user(argp, &dflow, sizeof(dflow)))
+			return -EFAULT;
+		break;
+
+	case DIGI_SETAFLOW:
+	case DIGI_SETFLOW:
+		if (cmd == DIGI_SETFLOW) {
+			startc = ch->startc;
+			stopc = ch->stopc;
+		} else {
+			startc = ch->startca;
+			stopc = ch->stopca;
+		}
 
-		case DIGI_GETFLOW:
-		case DIGI_GETAFLOW:
+		if (copy_from_user(&dflow, argp, sizeof(dflow)))
+			return -EFAULT;
+
+		if (dflow.startc != startc || dflow.stopc != stopc) { /* Begin  if setflow toggled */
 			spin_lock_irqsave(&epca_lock, flags);
 			globalwinon(ch);
-			if (cmd == DIGI_GETFLOW) {
-				dflow.startc = readb(&bc->startc);
-				dflow.stopc = readb(&bc->stopc);
-			} else {
-				dflow.startc = readb(&bc->startca);
-				dflow.stopc = readb(&bc->stopca);
-			}
-			memoff(ch);
-			spin_unlock_irqrestore(&epca_lock, flags);
-
-			if (copy_to_user(argp, &dflow, sizeof(dflow)))
-				return -EFAULT;
-			break;
 
-		case DIGI_SETAFLOW:
-		case DIGI_SETFLOW:
 			if (cmd == DIGI_SETFLOW) {
-				startc = ch->startc;
-				stopc = ch->stopc;
+				ch->fepstartc = ch->startc = dflow.startc;
+				ch->fepstopc = ch->stopc = dflow.stopc;
+				fepcmd(ch, SONOFFC, ch->fepstartc, ch->fepstopc, 0, 1);
 			} else {
-				startc = ch->startca;
-				stopc = ch->stopca;
+				ch->fepstartca = ch->startca = dflow.startc;
+				ch->fepstopca  = ch->stopca = dflow.stopc;
+				fepcmd(ch, SAUXONOFFC, ch->fepstartca, ch->fepstopca, 0, 1);
 			}
 
-			if (copy_from_user(&dflow, argp, sizeof(dflow)))
-				return -EFAULT;
-
-			if (dflow.startc != startc || dflow.stopc != stopc) { /* Begin  if setflow toggled */
-				spin_lock_irqsave(&epca_lock, flags);
-				globalwinon(ch);
-
-				if (cmd == DIGI_SETFLOW) {
-					ch->fepstartc = ch->startc = dflow.startc;
-					ch->fepstopc = ch->stopc = dflow.stopc;
-					fepcmd(ch, SONOFFC, ch->fepstartc, ch->fepstopc, 0, 1);
-				} else {
-					ch->fepstartca = ch->startca = dflow.startc;
-					ch->fepstopca  = ch->stopca = dflow.stopc;
-					fepcmd(ch, SAUXONOFFC, ch->fepstartca, ch->fepstopca, 0, 1);
-				}
+			if (ch->statusflags & TXSTOPPED)
+				pc_start(tty);
 
-				if (ch->statusflags & TXSTOPPED)
-					pc_start(tty);
-
-				memoff(ch);
-				spin_unlock_irqrestore(&epca_lock, flags);
-			} /* End if setflow toggled */
-			break;
-		default:
-			return -ENOIOCTLCMD;
-	} /* End switch cmd */
+			memoff(ch);
+			spin_unlock_irqrestore(&epca_lock, flags);
+		} /* End if setflow toggled */
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
 	return 0;
-} /* End pc_ioctl */
-
-/* --------------------- Begin pc_set_termios  ----------------------- */
+}
 
 static void pc_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
-{ /* Begin pc_set_termios */
-
+{
 	struct channel *ch;
 	unsigned long flags;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
 	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if channel valid */
 		spin_lock_irqsave(&epca_lock, flags);
 		globalwinon(ch);
@@ -2554,47 +2372,40 @@ static void pc_set_termios(struct tty_st
 			wake_up_interruptible(&ch->open_wait);
 
 	} /* End if channel valid */
-
-} /* End pc_set_termios */
-
-/* --------------------- Begin do_softint  ----------------------- */
+}
 
 static void do_softint(struct work_struct *work)
-{ /* Begin do_softint */
+{
 	struct channel *ch = container_of(work, struct channel, tqueue);
 	/* Called in response to a modem change event */
-	if (ch && ch->magic == EPCA_MAGIC)  { /* Begin EPCA_MAGIC */
+	if (ch && ch->magic == EPCA_MAGIC) {
 		struct tty_struct *tty = ch->tty;
 
 		if (tty && tty->driver_data) {
-			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) { /* Begin if clear_bit */
+			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
 				tty_hangup(tty);	/* FIXME: module removal race here - AKPM */
 				wake_up_interruptible(&ch->open_wait);
 				ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-			} /* End if clear_bit */
+			}
 		}
-	} /* End EPCA_MAGIC */
-} /* End do_softint */
-
-/* ------------------------------------------------------------
-	pc_stop and pc_start provide software flow control to the 
-	routine and the pc_ioctl routine.
----------------------------------------------------------------- */
-
-/* --------------------- Begin pc_stop  ----------------------- */
+	}
+}
 
+/*
+ * pc_stop and pc_start provide software flow control to the routine and the
+ * pc_ioctl routine.
+ */
 static void pc_stop(struct tty_struct *tty)
-{ /* Begin pc_stop */
-
+{
 	struct channel *ch;
 	unsigned long flags;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
-	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if valid channel */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
+	if ((ch = verifyChannel(tty)) != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
-		if ((ch->statusflags & TXSTOPPED) == 0)  { /* Begin if transmit stop requested */
+		if ((ch->statusflags & TXSTOPPED) == 0) { /* Begin if transmit stop requested */
 			globalwinon(ch);
 			/* STOP transmitting now !! */
 			fepcmd(ch, PAUSETX, 0, 0, 0, 0);
@@ -2602,19 +2413,17 @@ static void pc_stop(struct tty_struct *t
 			memoff(ch);
 		} /* End if transmit stop requested */
 		spin_unlock_irqrestore(&epca_lock, flags);
-	} /* End if valid channel */
-} /* End pc_stop */
-
-/* --------------------- Begin pc_start  ----------------------- */
+	}
+}
 
 static void pc_start(struct tty_struct *tty)
-{ /* Begin pc_start */
+{
 	struct channel *ch;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
-	if ((ch = verifyChannel(tty)) != NULL) { /* Begin if channel valid */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
+	if ((ch = verifyChannel(tty)) != NULL) {
 		unsigned long flags;
 		spin_lock_irqsave(&epca_lock, flags);
 		/* Just in case output was resumed because of a change in Digi-flow */
@@ -2630,28 +2439,25 @@ static void pc_start(struct tty_struct *
 			memoff(ch);
 		} /* End transmit resume requested */
 		spin_unlock_irqrestore(&epca_lock, flags);
-	} /* End if channel valid */
-} /* End pc_start */
-
-/* ------------------------------------------------------------------
-	The below routines pc_throttle and pc_unthrottle are used 
-	to slow (And resume) the receipt of data into the kernels
-	receive buffers.  The exact occurrence of this depends on the
-	size of the kernels receive buffer and what the 'watermarks'
-	are set to for that buffer.  See the n_ttys.c file for more
-	details. 
-______________________________________________________________________ */
-/* --------------------- Begin throttle  ----------------------- */
+	}
+}
 
-static void pc_throttle(struct tty_struct * tty)
-{ /* Begin pc_throttle */
+/*
+ * The below routines pc_throttle and pc_unthrottle are used to slow (And
+ * resume) the receipt of data into the kernels receive buffers. The exact
+ * occurrence of this depends on the size of the kernels receive buffer and
+ * what the 'watermarks' are set to for that buffer. See the n_ttys.c file for
+ * more details.
+ */
+static void pc_throttle(struct tty_struct *tty)
+{
 	struct channel *ch;
 	unsigned long flags;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
-	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if channel valid */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
+	if ((ch = verifyChannel(tty)) != NULL) {
 		spin_lock_irqsave(&epca_lock, flags);
 		if ((ch->statusflags & RXSTOPPED) == 0) {
 			globalwinon(ch);
@@ -2660,20 +2466,18 @@ static void pc_throttle(struct tty_struc
 			memoff(ch);
 		}
 		spin_unlock_irqrestore(&epca_lock, flags);
-	} /* End if channel valid */
-} /* End pc_throttle */
-
-/* --------------------- Begin unthrottle  ----------------------- */
+	}
+}
 
 static void pc_unthrottle(struct tty_struct *tty)
-{ /* Begin pc_unthrottle */
+{
 	struct channel *ch;
 	unsigned long flags;
-	/* ---------------------------------------------------------
-		verifyChannel returns the channel from the tty struct
-		if it is valid.  This serves as a sanity check.
-	------------------------------------------------------------- */
-	if ((ch = verifyChannel(tty)) != NULL)  { /* Begin if channel valid */
+	/*
+	 * verifyChannel returns the channel from the tty struct if it is
+	 * valid. This serves as a sanity check.
+	 */
+	if ((ch = verifyChannel(tty)) != NULL) {
 		/* Just in case output was resumed because of a change in Digi-flow */
 		spin_lock_irqsave(&epca_lock, flags);
 		if (ch->statusflags & RXSTOPPED) {
@@ -2683,151 +2487,143 @@ static void pc_unthrottle(struct tty_str
 			memoff(ch);
 		}
 		spin_unlock_irqrestore(&epca_lock, flags);
-	} /* End if channel valid */
-} /* End pc_unthrottle */
-
-/* --------------------- Begin digi_send_break  ----------------------- */
+	}
+}
 
 void digi_send_break(struct channel *ch, int msec)
-{ /* Begin digi_send_break */
+{
 	unsigned long flags;
 
 	spin_lock_irqsave(&epca_lock, flags);
 	globalwinon(ch);
-	/* -------------------------------------------------------------------- 
-	   Maybe I should send an infinite break here, schedule() for
-	   msec amount of time, and then stop the break.  This way,
-	   the user can't screw up the FEP by causing digi_send_break()
-	   to be called (i.e. via an ioctl()) more than once in msec amount 
-	   of time.  Try this for now...
-	------------------------------------------------------------------------ */
+	/*
+	 * Maybe I should send an infinite break here, schedule() for msec
+	 * amount of time, and then stop the break. This way, the user can't
+	 * screw up the FEP by causing digi_send_break() to be called (i.e. via
+	 * an ioctl()) more than once in msec amount of time.
+	 * Try this for now...
+	 */
 	fepcmd(ch, SENDBREAK, msec, 0, 10, 0);
 	memoff(ch);
 	spin_unlock_irqrestore(&epca_lock, flags);
-} /* End digi_send_break */
-
-/* --------------------- Begin setup_empty_event  ----------------------- */
+}
 
 /* Caller MUST hold the lock */
-
 static void setup_empty_event(struct tty_struct *tty, struct channel *ch)
-{ /* Begin setup_empty_event */
-
+{
 	struct board_chan __iomem *bc = ch->brdchan;
 
 	globalwinon(ch);
 	ch->statusflags |= EMPTYWAIT;
-	/* ------------------------------------------------------------------
-		When set the iempty flag request a event to be generated when the 
-		transmit buffer is empty (If there is no BREAK in progress).
-	--------------------------------------------------------------------- */
+	/*
+	 * When set the iempty flag request a event to be generated when the
+	 * transmit buffer is empty (If there is no BREAK in progress).
+	 */
 	writeb(1, &bc->iempty);
 	memoff(ch);
-} /* End setup_empty_event */
+}
 
-/* ---------------------- Begin epca_setup  -------------------------- */
 void epca_setup(char *str, int *ints)
-{ /* Begin epca_setup */
+{
 	struct board_info board;
 	int               index, loop, last;
 	char              *temp, *t2;
 	unsigned          len;
 
-	/* ----------------------------------------------------------------------
-		If this routine looks a little strange it is because it is only called
-		if a LILO append command is given to boot the kernel with parameters.  
-		In this way, we can provide the user a method of changing his board
-		configuration without rebuilding the kernel.
-	----------------------------------------------------------------------- */
-	if (!liloconfig) 
-		liloconfig = 1; 
+	/*
+	 * If this routine looks a little strange it is because it is only
+	 * called if a LILO append command is given to boot the kernel with
+	 * parameters. In this way, we can provide the user a method of
+	 * changing his board configuration without rebuilding the kernel.
+	 */
+	if (!liloconfig)
+		liloconfig = 1;
 
 	memset(&board, 0, sizeof(board));
 
 	/* Assume the data is int first, later we can change it */
 	/* I think that array position 0 of ints holds the number of args */
 	for (last = 0, index = 1; index <= ints[0]; index++)
-		switch(index)
-		{ /* Begin parse switch */
-			case 1:
-				board.status = ints[index];
-				/* ---------------------------------------------------------
-					We check for 2 (As opposed to 1; because 2 is a flag
-					instructing the driver to ignore epcaconfig.)  For this
-					reason we check for 2.
-				------------------------------------------------------------ */ 
-				if (board.status == 2) { /* Begin ignore epcaconfig as well as lilo cmd line */
-					nbdevs = 0;
-					num_cards = 0;
-					return;
-				} /* End ignore epcaconfig as well as lilo cmd line */
-	
-				if (board.status > 2) {
-					printk(KERN_ERR "epca_setup: Invalid board status 0x%x\n", board.status);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_BOARD_STATUS;
-					return;
-				}
-				last = index;
-				break;
-			case 2:
-				board.type = ints[index];
-				if (board.type >= PCIXEM)  {
-					printk(KERN_ERR "epca_setup: Invalid board type 0x%x\n", board.type);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_BOARD_TYPE;
-					return;
-				}
-				last = index;
-				break;
-			case 3:
-				board.altpin = ints[index];
-				if (board.altpin > 1) {
-					printk(KERN_ERR "epca_setup: Invalid board altpin 0x%x\n", board.altpin);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_ALTPIN;
-					return;
-				}
-				last = index;
-				break;
+		switch (index) { /* Begin parse switch */
+		case 1:
+			board.status = ints[index];
+			/*
+			 * We check for 2 (As opposed to 1; because 2 is a flag
+			 * instructing the driver to ignore epcaconfig.) For
+			 * this reason we check for 2.
+			 */
+			if (board.status == 2) { /* Begin ignore epcaconfig as well as lilo cmd line */
+				nbdevs = 0;
+				num_cards = 0;
+				return;
+			} /* End ignore epcaconfig as well as lilo cmd line */
 
-			case 4:
-				board.numports = ints[index];
-				if (board.numports < 2 || board.numports > 256) {
-					printk(KERN_ERR "epca_setup: Invalid board numports 0x%x\n", board.numports);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_NUM_PORTS;
-					return;
-				}
-				nbdevs += board.numports;
-				last = index;
-				break;
-
-			case 5:
-				board.port = ints[index];
-				if (ints[index] <= 0) {
-					printk(KERN_ERR "epca_setup: Invalid io port 0x%x\n", (unsigned int)board.port);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_PORT_BASE;
-					return;
-				}
-				last = index;
-				break;
+			if (board.status > 2) {
+				printk(KERN_ERR "epca_setup: Invalid board status 0x%x\n", board.status);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_BOARD_STATUS;
+				return;
+			}
+			last = index;
+			break;
+		case 2:
+			board.type = ints[index];
+			if (board.type >= PCIXEM)  {
+				printk(KERN_ERR "epca_setup: Invalid board type 0x%x\n", board.type);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_BOARD_TYPE;
+				return;
+			}
+			last = index;
+			break;
+		case 3:
+			board.altpin = ints[index];
+			if (board.altpin > 1) {
+				printk(KERN_ERR "epca_setup: Invalid board altpin 0x%x\n", board.altpin);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_ALTPIN;
+				return;
+			}
+			last = index;
+			break;
 
-			case 6:
-				board.membase = ints[index];
-				if (ints[index] <= 0) {
-					printk(KERN_ERR "epca_setup: Invalid memory base 0x%x\n",(unsigned int)board.membase);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_MEM_BASE;
-					return;
-				}
-				last = index;
-				break;
+		case 4:
+			board.numports = ints[index];
+			if (board.numports < 2 || board.numports > 256) {
+				printk(KERN_ERR "epca_setup: Invalid board numports 0x%x\n", board.numports);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_NUM_PORTS;
+				return;
+			}
+			nbdevs += board.numports;
+			last = index;
+			break;
 
-			default:
-				printk(KERN_ERR "<Error> - epca_setup: Too many integer parms\n");
+		case 5:
+			board.port = ints[index];
+			if (ints[index] <= 0) {
+				printk(KERN_ERR "epca_setup: Invalid io port 0x%x\n", (unsigned int)board.port);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_PORT_BASE;
 				return;
+			}
+			last = index;
+			break;
+
+		case 6:
+			board.membase = ints[index];
+			if (ints[index] <= 0) {
+				printk(KERN_ERR "epca_setup: Invalid memory base 0x%x\n",(unsigned int)board.membase);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_MEM_BASE;
+				return;
+			}
+			last = index;
+			break;
+
+		default:
+			printk(KERN_ERR "<Error> - epca_setup: Too many integer parms\n");
+			return;
 
 		} /* End parse switch */
 
@@ -2844,120 +2640,121 @@ void epca_setup(char *str, int *ints)
 		/* Set index to the number of args + 1 */
 		index = last + 1;
 
-		switch(index)
-		{
-			case 1:
-				len = strlen(str);
-				if (strncmp("Disable", str, len) == 0) 
-					board.status = 0;
-				else if (strncmp("Enable", str, len) == 0)
-					board.status = 1;
-				else {
-					printk(KERN_ERR "epca_setup: Invalid status %s\n", str);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_BOARD_STATUS;
-					return;
-				}
-				last = index;
-				break;
+		switch (index) {
+		case 1:
+			len = strlen(str);
+			if (strncmp("Disable", str, len) == 0)
+				board.status = 0;
+			else if (strncmp("Enable", str, len) == 0)
+				board.status = 1;
+			else {
+				printk(KERN_ERR "epca_setup: Invalid status %s\n", str);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_BOARD_STATUS;
+				return;
+			}
+			last = index;
+			break;
 
-			case 2:
-				for(loop = 0; loop < EPCA_NUM_TYPES; loop++)
-					if (strcmp(board_desc[loop], str) == 0)
-						break;
-				/* ---------------------------------------------------------------
-					If the index incremented above refers to a legitamate board 
-					type set it here. 
-				------------------------------------------------------------------*/
-				if (index < EPCA_NUM_TYPES) 
-					board.type = loop;
-				else {
-					printk(KERN_ERR "epca_setup: Invalid board type: %s\n", str);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_BOARD_TYPE;
-					return;
-				}
-				last = index;
-				break;
+		case 2:
+			for (loop = 0; loop < EPCA_NUM_TYPES; loop++)
+				if (strcmp(board_desc[loop], str) == 0)
+					break;
+			/*
+			 * If the index incremented above refers to a
+			 * legitamate board type set it here.
+			 */
+			if (index < EPCA_NUM_TYPES)
+				board.type = loop;
+			else {
+				printk(KERN_ERR "epca_setup: Invalid board type: %s\n", str);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_BOARD_TYPE;
+				return;
+			}
+			last = index;
+			break;
 
-			case 3:
-				len = strlen(str);
-				if (strncmp("Disable", str, len) == 0) 
-					board.altpin = 0;
-				else if (strncmp("Enable", str, len) == 0)
-					board.altpin = 1;
-				else {
-					printk(KERN_ERR "epca_setup: Invalid altpin %s\n", str);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_ALTPIN;
-					return;
-				}
-				last = index;
-				break;
+		case 3:
+			len = strlen(str);
+			if (strncmp("Disable", str, len) == 0)
+				board.altpin = 0;
+			else if (strncmp("Enable", str, len) == 0)
+				board.altpin = 1;
+			else {
+				printk(KERN_ERR "epca_setup: Invalid altpin %s\n", str);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_ALTPIN;
+				return;
+			}
+			last = index;
+			break;
 
-			case 4:
-				t2 = str;
-				while (isdigit(*t2))
-					t2++;
-
-				if (*t2) {
-					printk(KERN_ERR "epca_setup: Invalid port count %s\n", str);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_NUM_PORTS;
-					return;
-				}
+		case 4:
+			t2 = str;
+			while (isdigit(*t2))
+				t2++;
+
+			if (*t2) {
+				printk(KERN_ERR "epca_setup: Invalid port count %s\n", str);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_NUM_PORTS;
+				return;
+			}
 
-				/* ------------------------------------------------------------
-					There is not a man page for simple_strtoul but the code can be 
-					found in vsprintf.c.  The first argument is the string to 
-					translate (To an unsigned long obviously),  the second argument
-					can be the address of any character variable or a NULL.  If a
-					variable is given, the end pointer of the string will be stored 
-					in that variable; if a NULL is given the end pointer will 
-					not be returned.  The last argument is the base to use.  If 
-					a 0 is indicated, the routine will attempt to determine the 
-					proper base by looking at the values prefix (A '0' for octal,
-					a 'x' for hex, etc ...  If a value is given it will use that 
-					value as the base. 
-				---------------------------------------------------------------- */ 
-				board.numports = simple_strtoul(str, NULL, 0);
-				nbdevs += board.numports;
-				last = index;
-				break;
-
-			case 5:
-				t2 = str;
-				while (isxdigit(*t2))
-					t2++;
-
-				if (*t2) {
-					printk(KERN_ERR "epca_setup: Invalid i/o address %s\n", str);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_PORT_BASE;
-					return;
-				}
+			/*
+			 * There is not a man page for simple_strtoul but the
+			 * code can be found in vsprintf.c. The first argument
+			 * is the string to translate (To an unsigned long
+			 * obviously), the second argument can be the address
+			 * of any character variable or a NULL. If a variable
+			 * is given, the end pointer of the string will be
+			 * stored in that variable; if a NULL is given the end
+			 * pointer will not be returned. The last argument is
+			 * the base to use. If a 0 is indicated, the routine
+			 * will attempt to determine the proper base by looking
+			 * at the values prefix (A '0' for octal, a 'x' for
+			 * hex, etc ... If a value is given it will use that
+			 * value as the base.
+			 */
+			board.numports = simple_strtoul(str, NULL, 0);
+			nbdevs += board.numports;
+			last = index;
+			break;
 
-				board.port = simple_strtoul(str, NULL, 16);
-				last = index;
-				break;
-
-			case 6:
-				t2 = str;
-				while (isxdigit(*t2))
-					t2++;
-
-				if (*t2) {
-					printk(KERN_ERR "epca_setup: Invalid memory base %s\n",str);
-					invalid_lilo_config = 1;
-					setup_error_code |= INVALID_MEM_BASE;
-					return;
-				}
-				board.membase = simple_strtoul(str, NULL, 16);
-				last = index;
-				break;
-			default:
-				printk(KERN_ERR "epca: Too many string parms\n");
+		case 5:
+			t2 = str;
+			while (isxdigit(*t2))
+				t2++;
+
+			if (*t2) {
+				printk(KERN_ERR "epca_setup: Invalid i/o address %s\n", str);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_PORT_BASE;
 				return;
+			}
+
+			board.port = simple_strtoul(str, NULL, 16);
+			last = index;
+			break;
+
+		case 6:
+			t2 = str;
+			while (isxdigit(*t2))
+				t2++;
+
+			if (*t2) {
+				printk(KERN_ERR "epca_setup: Invalid memory base %s\n",str);
+				invalid_lilo_config = 1;
+				setup_error_code |= INVALID_MEM_BASE;
+				return;
+			}
+			board.membase = simple_strtoul(str, NULL, 16);
+			last = index;
+			break;
+		default:
+			printk(KERN_ERR "epca: Too many string parms\n");
+			return;
 		}
 		str = temp;
 	} /* End while there is a string arg */
@@ -2966,19 +2763,16 @@ void epca_setup(char *str, int *ints)
 		printk(KERN_ERR "epca: Insufficient parms specified\n");
 		return;
 	}
- 
+
 	/* I should REALLY validate the stuff here */
 	/* Copies our local copy of board into boards */
 	memcpy((void *)&boards[num_cards],(void *)&board, sizeof(board));
 	/* Does this get called once per lilo arg are what ? */
-	printk(KERN_INFO "PC/Xx: Added board %i, %s %i ports at 0x%4.4X base 0x%6.6X\n", 
-		num_cards, board_desc[board.type], 
+	printk(KERN_INFO "PC/Xx: Added board %i, %s %i ports at 0x%4.4X base 0x%6.6X\n",
+		num_cards, board_desc[board.type],
 		board.numports, (int)board.port, (unsigned int) board.membase);
 	num_cards++;
-} /* End epca_setup */
-
-
-/* ------------------------ Begin init_PCI  --------------------------- */
+}
 
 enum epic_board_types {
 	brd_xr = 0,
@@ -2987,7 +2781,6 @@ enum epic_board_types {
 	brd_xrj,
 };
 
-
 /* indexed directly by epic_board_types enum */
 static struct {
 	unsigned char board_type;
@@ -2999,7 +2792,7 @@ static struct {
 	{ PCIXRJ, 2, },
 };
 
-static int __devinit epca_init_one (struct pci_dev *pdev,
+static int __devinit epca_init_one(struct pci_dev *pdev,
 				 const struct pci_device_id *ent)
 {
 	static int board_num = -1;
@@ -3013,7 +2806,7 @@ static int __devinit epca_init_one (stru
 	board_idx = board_num + num_cards;
 	if (board_idx >= MAXBOARDS)
 		goto err_out;
-	
+
 	addr = pci_resource_start (pdev, epca_info_tbl[info_idx].bar_idx);
 	if (!addr) {
 		printk (KERN_ERR PFX "PCI region #%d not available (size 0)\n",
@@ -3053,15 +2846,15 @@ static int __devinit epca_init_one (stru
 		goto err_out_free_memregion;
 	}
 
-	/* --------------------------------------------------------------
-		I don't know what the below does, but the hardware guys say
-		its required on everything except PLX (In this case XRJ).
-	---------------------------------------------------------------- */
+	/*
+	 * I don't know what the below does, but the hardware guys say its
+	 * required on everything except PLX (In this case XRJ).
+	 */
 	if (info_idx != brd_xrj) {
-		pci_write_config_byte(pdev, 0x40, 0);  
+		pci_write_config_byte(pdev, 0x40, 0);
 		pci_write_config_byte(pdev, 0x46, 0);
 	}
-	
+
 	return 0;
 
 err_out_free_memregion:
@@ -3086,7 +2879,7 @@ static struct pci_device_id epca_pci_tbl
 MODULE_DEVICE_TABLE(pci, epca_pci_tbl);
 
 int __init init_PCI (void)
-{	/* Begin init_PCI */
+{
 	memset (&epca_driver, 0, sizeof (epca_driver));
 	epca_driver.name = "epca";
 	epca_driver.id_table = epca_pci_tbl;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
revert-faster-ext2_clear_inode.patch
