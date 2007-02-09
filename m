From: akpm@linux-foundation.org
Subject: + char-timers-cleanup.patch added to -mm tree
Date: Fri, 09 Feb 2007 02:05:37 -0800
Message-ID: <200702091005.l19A5bFe010281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41045 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946296AbXBIKKU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 05:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, a.zummo@towertech.it, airlied@linux.ie, dtor@mail.ru, dwmw2@infradead.org, kjhall@us.ibm.com, linux@dominikbrodowski.net, paulkf@microgate.com, wim@iguana.be


The patch titled
     Char: timers cleanup
has been added to the -mm tree.  Its filename is
     char-timers-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: timers cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- Use timer macros to set function and data members and to modify
  expiration time.
- Use DEFINE_TIMER for global timers and do not init them at run-time in
  these cases.
- del_timer_sync is common in most cases -- we want to wait for timer
  function if it's still running.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/via_dmablit.c               |   14 ++-----
 drivers/char/dtlk.c                          |    8 +---
 drivers/char/ip2/i2lib.c                     |   30 +++++++++--------
 drivers/char/n_r3964.c                       |    4 --
 drivers/char/nwbutton.c                      |   13 ++-----
 drivers/char/pcmcia/cm4000_cs.c              |   10 +----
 drivers/char/pcmcia/cm4040_cs.c              |    3 -
 drivers/char/pcmcia/ipwireless_cs_hardware.c |    9 +----
 drivers/char/pcmcia/synclink_cs.c            |   10 ++---
 drivers/char/rio/rio_linux.c                 |   12 ++----
 drivers/char/rocket.c                        |   10 +----
 drivers/char/rtc.c                           |   12 ++----
 drivers/char/scan_keyb.c                     |   14 +------
 drivers/char/specialix.c                     |   12 ++----
 drivers/char/synclink.c                      |   10 ++---
 drivers/char/synclink_gt.c                   |   19 +++-------
 drivers/char/synclinkmp.c                    |   22 +++---------
 drivers/char/tpm/tpm.c                       |    5 +-
 drivers/char/vt.c                            |    4 --
 drivers/char/watchdog/alim7101_wdt.c         |   13 +------
 drivers/char/watchdog/cpu5wdt.c              |   13 ++-----
 drivers/char/watchdog/machzwd.c              |   16 ++-------
 drivers/char/watchdog/mixcomwd.c             |   14 +++----
 drivers/char/watchdog/pcwd.c                 |    4 --
 drivers/char/watchdog/sbc60xxwdt.c           |   12 +-----
 drivers/char/watchdog/sc520_wdt.c            |   12 +-----
 drivers/char/watchdog/shwdt.c                |    8 +---
 drivers/char/watchdog/w83877f_wdt.c          |   12 +-----
 28 files changed, 112 insertions(+), 213 deletions(-)

diff -puN drivers/char/drm/via_dmablit.c~char-timers-cleanup drivers/char/drm/via_dmablit.c
--- a/drivers/char/drm/via_dmablit.c~char-timers-cleanup
+++ a/drivers/char/drm/via_dmablit.c
@@ -376,10 +376,8 @@ via_dmablit_handler(drm_device_t *dev, i
 			blitq->cur = cur;
 			blitq->num_outstanding--;
 			blitq->end = jiffies + DRM_HZ;
-			if (!timer_pending(&blitq->poll_timer)) {
-				blitq->poll_timer.expires = jiffies+1;
-				add_timer(&blitq->poll_timer);
-			}
+			if (!timer_pending(&blitq->poll_timer))
+				mod_timer(&blitq->poll_timer, jiffies + 1);
 		} else {
 			if (timer_pending(&blitq->poll_timer)) {
 				del_timer(&blitq->poll_timer);
@@ -478,8 +476,7 @@ via_dmablit_timer(unsigned long data)
 	via_dmablit_handler(dev, engine, 0);
 	
 	if (!timer_pending(&blitq->poll_timer)) {
-		blitq->poll_timer.expires = jiffies+1;
-		add_timer(&blitq->poll_timer);
+		mod_timer(&blitq->poll_timer, jiffies + 1);
 
 	       /*
 		* Rerun handler to delete timer if engines are off, and
@@ -574,9 +571,8 @@ via_init_dmablit(drm_device_t *dev)
 		}
 		DRM_INIT_WAITQUEUE(&blitq->busy_queue);
 		INIT_WORK(&blitq->wq, via_dmablit_workqueue);
-		init_timer(&blitq->poll_timer);
-		blitq->poll_timer.function = &via_dmablit_timer;
-		blitq->poll_timer.data = (unsigned long) blitq;
+		setup_timer(&blitq->poll_timer, via_dmablit_timer,
+				(unsigned long)blitq);
 	}	
 }
 
diff -puN drivers/char/dtlk.c~char-timers-cleanup drivers/char/dtlk.c
--- a/drivers/char/dtlk.c~char-timers-cleanup
+++ a/drivers/char/dtlk.c
@@ -72,6 +72,7 @@
 #define TRACE_RET ((void) 0)
 #endif				/* TRACING */
 
+static void dtlk_timer_tick(unsigned long data);
 
 static int dtlk_major;
 static int dtlk_port_lpc;
@@ -81,7 +82,7 @@ static int dtlk_has_indexing;
 static unsigned int dtlk_portlist[] =
 {0x25e, 0x29e, 0x2de, 0x31e, 0x35e, 0x39e, 0};
 static wait_queue_head_t dtlk_process_list;
-static struct timer_list dtlk_timer;
+static DEFINE_TIMER(dtlk_timer, dtlk_timer_tick, 0, 0);
 
 /* prototypes for file_operations struct */
 static ssize_t dtlk_read(struct file *, char __user *,
@@ -117,7 +118,6 @@ static char dtlk_write_tts(char);
 /*
    static void dtlk_handle_error(char, char, unsigned int);
  */
-static void dtlk_timer_tick(unsigned long data);
 
 static ssize_t dtlk_read(struct file *file, char __user *buf,
 			 size_t count, loff_t * ppos)
@@ -318,7 +318,7 @@ static int dtlk_release(struct inode *in
 	}
 	TRACE_RET;
 	
-	del_timer(&dtlk_timer);
+	del_timer_sync(&dtlk_timer);
 
 	return 0;
 }
@@ -336,8 +336,6 @@ static int __init dtlk_init(void)
 	if (dtlk_dev_probe() == 0)
 		printk(", MAJOR %d\n", dtlk_major);
 
-	init_timer(&dtlk_timer);
-	dtlk_timer.function = dtlk_timer_tick;
 	init_waitqueue_head(&dtlk_process_list);
 
 	return 0;
diff -puN drivers/char/ip2/i2lib.c~char-timers-cleanup drivers/char/ip2/i2lib.c
--- a/drivers/char/ip2/i2lib.c~char-timers-cleanup
+++ a/drivers/char/ip2/i2lib.c
@@ -80,7 +80,7 @@ static int i2RetryFlushOutput(i2ChanStrP
 // Not a documented part of the library routines (careful...) but the Diagnostic
 // i2diag.c finds them useful to help the throughput in certain limited
 // single-threaded operations.
-static void iiSendPendingMail(i2eBordStrPtr);
+static inline void iiSendPendingMail(i2eBordStrPtr);
 static void serviceOutgoingFifo(i2eBordStrPtr);
 
 // Functions defined in ip2.c as part of interrupt handling
@@ -150,6 +150,13 @@ i2Validate ( i2ChanStrPtr pCh )
 			  == (CHANNEL_MAGIC | CHANNEL_SUPPORT));
 }
 
+static void iiSendPendingMail_t(unsigned long data)
+{
+	i2eBordStrPtr pB = (i2eBordStrPtr)data;
+
+	iiSendPendingMail(pB);
+}
+
 //******************************************************************************
 // Function:   iiSendPendingMail(pB)
 // Parameters: Pointer to a board structure
@@ -184,12 +191,9 @@ iiSendPendingMail(i2eBordStrPtr pB)
 			/\/\|=mhw=|\/\/				*/
 
 			if( ++pB->SendPendingRetry < 16 ) {
-
-				init_timer( &(pB->SendPendingTimer) );
-				pB->SendPendingTimer.expires  = jiffies + 1;
-				pB->SendPendingTimer.function = (void*)(unsigned long)iiSendPendingMail;
-				pB->SendPendingTimer.data     = (unsigned long)pB;
-				add_timer( &(pB->SendPendingTimer) );
+				setup_timer(&pB->SendPendingTimer,
+					iiSendPendingMail_t, (unsigned long)pB);
+				mod_timer(&pB->SendPendingTimer, jiffies + 1);
 			} else {
 				printk( KERN_ERR "IP2: iiSendPendingMail unable to queue outbound mail\n" );
 			}
@@ -1265,8 +1269,10 @@ i2RetryFlushOutput(i2ChanStrPtr pCh)
 // soon as all the data is completely sent.
 //******************************************************************************
 static void
-i2DrainWakeup(i2ChanStrPtr pCh)
+i2DrainWakeup(unsigned long d)
 {
+	i2ChanStrPtr pCh = (i2ChanStrPtr)d;
+
 	ip2trace (CHANN, ITRC_DRAIN, 10, 1, pCh->BookmarkTimer.expires );
 
 	pCh->BookmarkTimer.expires = 0;
@@ -1292,14 +1298,12 @@ i2DrainOutput(i2ChanStrPtr pCh, int time
 	}
 	if ((timeout > 0) && (pCh->BookmarkTimer.expires == 0 )) {
 		// One per customer (channel)
-		init_timer( &(pCh->BookmarkTimer) );
-		pCh->BookmarkTimer.expires  = jiffies + timeout;
-		pCh->BookmarkTimer.function = (void*)(unsigned long)i2DrainWakeup;
-		pCh->BookmarkTimer.data     = (unsigned long)pCh;
+		setup_timer(&pCh->BookmarkTimer, i2DrainWakeup,
+				(unsigned long)pCh);
 
 		ip2trace (CHANN, ITRC_DRAIN, 1, 1, pCh->BookmarkTimer.expires );
 
-		add_timer( &(pCh->BookmarkTimer) );
+		mod_timer(&pCh->BookmarkTimer, jiffies + timeout);
 	}
 	
 	i2QueueCommands( PTYPE_INLINE, pCh, -1, 1, CMD_BMARK_REQ );
diff -puN drivers/char/n_r3964.c~char-timers-cleanup drivers/char/n_r3964.c
--- a/drivers/char/n_r3964.c~char-timers-cleanup
+++ a/drivers/char/n_r3964.c
@@ -1005,9 +1005,7 @@ static int r3964_open(struct tty_struct 
 	tty->disc_data = pInfo;
 	tty->receive_room = 65536;
 
-	init_timer(&pInfo->tmr);
-	pInfo->tmr.data = (unsigned long)pInfo;
-	pInfo->tmr.function = on_timeout;
+	setup_timer(&pInfo->tmr, on_timeout, (unsigned long)pInfo);
 
 	return 0;
 }
diff -puN drivers/char/nwbutton.c~char-timers-cleanup drivers/char/nwbutton.c
--- a/drivers/char/nwbutton.c~char-timers-cleanup
+++ a/drivers/char/nwbutton.c
@@ -23,8 +23,11 @@
 #define __NWBUTTON_C		/* Tell the header file who we are */
 #include "nwbutton.h"
 
+static void button_sequence_finished (unsigned long parameters);
+
 static int button_press_count;		/* The count of button presses */
-static struct timer_list button_timer;	/* Times for the end of a sequence */ 
+/* Times for the end of a sequence */
+static DEFINE_TIMER(button_timer, button_sequence_finished, 0, 0);
 static DECLARE_WAIT_QUEUE_HEAD(button_wait_queue); /* Used for blocking read */
 static char button_output_buffer[32];	/* Stores data to write out of device */
 static int bcount;			/* The number of bytes in the buffer */
@@ -146,14 +149,8 @@ static void button_sequence_finished (un
 
 static irqreturn_t button_handler (int irq, void *dev_id)
 {
-	if (button_press_count) {
-		del_timer (&button_timer);
-	}
 	button_press_count++;
-	init_timer (&button_timer);
-	button_timer.function = button_sequence_finished;
-	button_timer.expires = (jiffies + bdelay);
-	add_timer (&button_timer);
+	mod_timer(&button_timer, jiffies + bdelay);
 
 	return IRQ_HANDLED;
 }
diff -puN drivers/char/pcmcia/cm4000_cs.c~char-timers-cleanup drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~char-timers-cleanup
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -946,8 +946,7 @@ release_io:
 
 return_with_timer:
 	DEBUGP(7, dev, "<- monitor_card (returns with timer)\n");
-	dev->timer.expires = jiffies + dev->mdelay;
-	add_timer(&dev->timer);
+	mod_timer(&dev->timer, jiffies + dev->mdelay);
 	clear_bit(LOCK_MONITOR, &dev->flags);
 }
 
@@ -1406,12 +1405,9 @@ static void start_monitor(struct cm4000_
 	DEBUGP(3, dev, "-> start_monitor\n");
 	if (!dev->monitor_running) {
 		DEBUGP(5, dev, "create, init and add timer\n");
-		init_timer(&dev->timer);
+		setup_timer(&dev->timer, monitor_card, (unsigned long)dev);
 		dev->monitor_running = 1;
-		dev->timer.expires = jiffies;
-		dev->timer.data = (unsigned long) dev;
-		dev->timer.function = monitor_card;
-		add_timer(&dev->timer);
+		mod_timer(&dev->timer, jiffies);
 	} else
 		DEBUGP(5, dev, "monitor already running\n");
 	DEBUGP(3, dev, "<- start_monitor\n");
diff -puN drivers/char/pcmcia/cm4040_cs.c~char-timers-cleanup drivers/char/pcmcia/cm4040_cs.c
--- a/drivers/char/pcmcia/cm4040_cs.c~char-timers-cleanup
+++ a/drivers/char/pcmcia/cm4040_cs.c
@@ -632,8 +632,7 @@ static int reader_probe(struct pcmcia_de
 	init_waitqueue_head(&dev->poll_wait);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
-	init_timer(&dev->poll_timer);
-	dev->poll_timer.function = &cm4040_do_poll;
+	setup_timer(&dev->poll_timer, cm4040_do_poll, 0);
 
 	ret = reader_config(link, i);
 	if (ret)
diff -puN drivers/char/pcmcia/ipwireless_cs_hardware.c~char-timers-cleanup drivers/char/pcmcia/ipwireless_cs_hardware.c
--- a/drivers/char/pcmcia/ipwireless_cs_hardware.c~char-timers-cleanup
+++ a/drivers/char/pcmcia/ipwireless_cs_hardware.c
@@ -1418,9 +1418,7 @@ ipw_hardware_t *ipwireless_hardware_crea
 	tasklet_init(&hw->tasklet, ipwireless_do_tasklet,
 		     (unsigned long) hw);
 
-	init_timer(&hw->setup_timer);
-	hw->setup_timer.function = ipwireless_setup_timer;
-	hw->setup_timer.data = (unsigned long) hw;
+	setup_timer(&hw->setup_timer, ipwireless_setup_timer,(unsigned long)hw);
 
 	INIT_WORK(&hw->work_rx, do_receive_data_work);
 
@@ -1489,9 +1487,8 @@ static void ipwireless_setup_timer(unsig
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 		}
 
-		hw->setup_timer.expires =
-		    jiffies + (unsigned long) TL_SETUP_VERSION_QRY_TMO *HZ / 1000UL;
-		add_timer(&hw->setup_timer);
+		mod_timer(&hw->setup_timer, jiffies +
+				msecs_to_jiffies(TL_SETUP_VERSION_QRY_TMO));
 	}
 }
 
diff -puN drivers/char/pcmcia/synclink_cs.c~char-timers-cleanup drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~char-timers-cleanup
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -1361,9 +1361,7 @@ static int startup(MGSLPC_INFO * info)
 	
 	memset(&info->icount, 0, sizeof(info->icount));
 
-	init_timer(&info->tx_timer);
-	info->tx_timer.data = (unsigned long)info;
-	info->tx_timer.function = tx_timeout;
+	setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
 
 	/* Allocate and claim adapter resources */
 	retval = claim_resources(info);
@@ -1408,7 +1406,7 @@ static void shutdown(MGSLPC_INFO * info)
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 
-	del_timer(&info->tx_timer);	
+	del_timer_sync(&info->tx_timer);
 
 	if (info->tx_buf) {
 		free_page((unsigned long) info->tx_buf);
@@ -3549,8 +3547,8 @@ static void tx_start(MGSLPC_INFO *info)
 		} else {
 			info->tx_active = 1;
 			tx_ready(info);
-			info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-			add_timer(&info->tx_timer);	
+			mod_timer(&info->tx_timer, jiffies +
+					msecs_to_jiffies(5000));
 		}
 	}
 
diff -puN drivers/char/rio/rio_linux.c~char-timers-cleanup drivers/char/rio/rio_linux.c
--- a/drivers/char/rio/rio_linux.c~char-timers-cleanup
+++ a/drivers/char/rio/rio_linux.c
@@ -418,8 +418,7 @@ static void rio_pollfunc(unsigned long d
 	func_enter();
 
 	rio_interrupt(0, &p->RIOHosts[data]);
-	p->RIOHosts[data].timer.expires = jiffies + rio_poll;
-	add_timer(&p->RIOHosts[data].timer);
+	mod_timer(&p->RIOHosts[data].timer, jiffies + rio_poll);
 
 	func_exit();
 }
@@ -1154,13 +1153,10 @@ static int __init rio_init(void)
 		/* Init the timer "always" to make sure that it can safely be
 		   deleted when we unload... */
 
-		init_timer(&hp->timer);
+		setup_timer(&hp->timer, rio_pollfunc, i);
 		if (!hp->Ivec) {
 			rio_dprintk(RIO_DEBUG_INIT, "Starting polling at %dj intervals.\n", rio_poll);
-			hp->timer.data = i;
-			hp->timer.function = rio_pollfunc;
-			hp->timer.expires = jiffies + rio_poll;
-			add_timer(&hp->timer);
+			mod_timer(&hp->timer, jiffies + rio_poll);
 		}
 	}
 
@@ -1191,7 +1187,7 @@ static void __exit rio_exit(void)
 			rio_dprintk(RIO_DEBUG_INIT, "freed irq %d.\n", hp->Ivec);
 		}
 		/* It is safe/allowed to del_timer a non-active timer */
-		del_timer(&hp->timer);
+		del_timer_sync(&hp->timer);
 		if (hp->Caddr)
 			iounmap(hp->Caddr);
 		if (hp->Type == RIO_PCI)
diff -puN drivers/char/rocket.c~char-timers-cleanup drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-timers-cleanup
+++ a/drivers/char/rocket.c
@@ -106,6 +106,8 @@
 
 /****** RocketPort Local Variables ******/
 
+static void rp_do_poll(unsigned long dummy);
+
 static struct tty_driver *rocket_driver;
 
 static struct rocket_version driver_version = {	
@@ -116,7 +118,7 @@ static struct r_port *rp_table[MAX_RP_PO
 static unsigned int xmit_flags[NUM_BOARDS];	       /*  Bit significant, indicates port had data to transmit. */
 						       /*  eg.  Bit 0 indicates port 0 has xmit data, ...        */
 static atomic_t rp_num_ports_open;	               /*  Number of serial ports open                           */
-static struct timer_list rocket_timer;
+static DEFINE_TIMER(rocket_timer, rp_do_poll, 0, 0);
 
 static unsigned long board1;	                       /* ISA addresses, retrieved from rocketport.conf          */
 static unsigned long board2;
@@ -2368,12 +2370,6 @@ static int __init rp_init(void)
 		return -ENOMEM;
 
 	/*
-	 * Set up the timer channel.
-	 */
-	init_timer(&rocket_timer);
-	rocket_timer.function = rp_do_poll;
-
-	/*
 	 * Initialize the array of pointers to our own internal state
 	 * structures.
 	 */
diff -puN drivers/char/rtc.c~char-timers-cleanup drivers/char/rtc.c
--- a/drivers/char/rtc.c~char-timers-cleanup
+++ a/drivers/char/rtc.c
@@ -135,7 +135,9 @@ static struct fasync_struct *rtc_async_q
 static DECLARE_WAIT_QUEUE_HEAD(rtc_wait);
 
 #ifdef RTC_IRQ
-static struct timer_list rtc_irq_timer;
+static void rtc_dropped_irq(unsigned long data);
+
+static DEFINE_TIMER(rtc_irq_timer, rtc_dropped_irq, 0, 0);
 #endif
 
 static ssize_t rtc_read(struct file *file, char __user *buf,
@@ -150,8 +152,6 @@ static unsigned int rtc_poll(struct file
 
 static void get_rtc_alm_time (struct rtc_time *alm_tm);
 #ifdef RTC_IRQ
-static void rtc_dropped_irq(unsigned long data);
-
 static void set_rtc_irq_bit_locked(unsigned char bit);
 static void mask_rtc_irq_bit_locked(unsigned char bit);
 
@@ -454,8 +454,8 @@ static int rtc_do_ioctl(unsigned int cmd
 
 		spin_lock_irqsave (&rtc_lock, flags);
 		if (!(rtc_status & RTC_TIMER_ON)) {
-			rtc_irq_timer.expires = jiffies + HZ/rtc_freq + 2*HZ/100;
-			add_timer(&rtc_irq_timer);
+			mod_timer(&rtc_irq_timer, jiffies + HZ/rtc_freq +
+					2*HZ/100);
 			rtc_status |= RTC_TIMER_ON;
 		}
 		set_rtc_irq_bit_locked(RTC_PIE);
@@ -1084,8 +1084,6 @@ no_irq:
 	if (rtc_has_irq == 0)
 		goto no_irq2;
 
-	init_timer(&rtc_irq_timer);
-	rtc_irq_timer.function = rtc_dropped_irq;
 	spin_lock_irq(&rtc_lock);
 	rtc_freq = 1024;
 	if (!hpet_set_periodic_freq(rtc_freq)) {
diff -puN drivers/char/scan_keyb.c~char-timers-cleanup drivers/char/scan_keyb.c
--- a/drivers/char/scan_keyb.c~char-timers-cleanup
+++ a/drivers/char/scan_keyb.c
@@ -32,7 +32,7 @@ struct scan_keyboard {
 
 static int scan_jiffies=0;
 static struct scan_keyboard *keyboards=NULL;
-struct timer_list scan_timer;
+static DEFINE_TIMER(scan_timer, scan_kbd, 0, 0);
 
 static void check_kbd(const unsigned char *table,
 		      unsigned char *new, unsigned char *old, int length)
@@ -88,11 +88,7 @@ static void scan_kbd(unsigned long dummy
 		
 	}
 
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
+	mod_timer(&scan_timer, jiffies + SCANHZ);
 }
 
 
@@ -139,11 +135,7 @@ int register_scan_keyboard(int (*scan)(u
 			      
 void __init scan_kbd_init(void)
 {
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
+	mod_timer(&scan_timer, jiffies + SCANHZ);
 
 	printk(KERN_INFO "Generic scan keyboard driver initialized\n");
 }
diff -puN drivers/char/specialix.c~char-timers-cleanup drivers/char/specialix.c
--- a/drivers/char/specialix.c~char-timers-cleanup
+++ a/drivers/char/specialix.c
@@ -461,8 +461,7 @@ void missed_irq (unsigned long data)
 		sx_interrupt (((struct specialix_board *)data)->irq,
 				(void*)data);
 	}
-	missed_irq_timer.expires = jiffies + sx_poll;
-	add_timer (&missed_irq_timer);
+	mod_timer(&missed_irq_timer, jiffies + sx_poll);
 }
 #endif
 
@@ -597,11 +596,8 @@ static int sx_probe(struct specialix_boa
 	dprintk (SX_DEBUG_INIT, " GFCR = 0x%02x\n", sx_in_off(bp, CD186x_GFRCR) );
 
 #ifdef SPECIALIX_TIMER
-	init_timer (&missed_irq_timer);
-	missed_irq_timer.function = missed_irq;
-	missed_irq_timer.data = (unsigned long) bp;
-	missed_irq_timer.expires = jiffies + sx_poll;
-	add_timer (&missed_irq_timer);
+	setup_timer(&missed_irq_timer, missed_irq, (unsigned long)bp);
+	mod_timer(&missed_irq_timer, jiffies + sx_poll);
 #endif
 
 	printk(KERN_INFO"sx%d: specialix IO8+ board detected at 0x%03x, IRQ %d, CD%d Rev. %c.\n",
@@ -2559,7 +2555,7 @@ static void __exit specialix_exit_module
 		if (sx_board[i].flags & SX_BOARD_PRESENT)
 			sx_release_io_range(&sx_board[i]);
 #ifdef SPECIALIX_TIMER
-	del_timer (&missed_irq_timer);
+	del_timer_sync(&missed_irq_timer);
 #endif
 
 	func_exit();
diff -puN drivers/char/synclink.c~char-timers-cleanup drivers/char/synclink.c
--- a/drivers/char/synclink.c~char-timers-cleanup
+++ a/drivers/char/synclink.c
@@ -1798,9 +1798,7 @@ static int startup(struct mgsl_struct * 
 	
 	memset(&info->icount, 0, sizeof(info->icount));
 
-	init_timer(&info->tx_timer);
-	info->tx_timer.data = (unsigned long)info;
-	info->tx_timer.function = mgsl_tx_timeout;
+	setup_timer(&info->tx_timer, mgsl_tx_timeout, (unsigned long)info);
 	
 	/* Allocate and claim adapter resources */
 	retval = mgsl_claim_resources(info);
@@ -1851,7 +1849,7 @@ static void shutdown(struct mgsl_struct 
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 
-	del_timer(&info->tx_timer);	
+	del_timer_sync(&info->tx_timer);
 
 	if (info->xmit_buf) {
 		free_page((unsigned long) info->xmit_buf);
@@ -5710,8 +5708,8 @@ static void usc_start_transmitter( struc
 			
 			usc_TCmd( info, TCmd_SendFrame );
 			
-			info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-			add_timer(&info->tx_timer);	
+			mod_timer(&info->tx_timer, jiffies +
+					msecs_to_jiffies(5000));
 		}
 		info->tx_active = 1;
 	}
diff -puN drivers/char/synclink_gt.c~char-timers-cleanup drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~char-timers-cleanup
+++ a/drivers/char/synclink_gt.c
@@ -1825,8 +1825,7 @@ static void rx_async(struct slgt_info *i
 		if (i < count) {
 			/* receive buffer not completed */
 			info->rbuf_index += i;
-			info->rx_timer.expires = jiffies + 1;
-			add_timer(&info->rx_timer);
+			mod_timer(&info->rx_timer, jiffies + 1);
 			break;
 		}
 
@@ -3340,13 +3339,8 @@ static struct slgt_info *alloc_dev(int a
 		info->adapter_num = adapter_num;
 		info->port_num = port_num;
 
-		init_timer(&info->tx_timer);
-		info->tx_timer.data = (unsigned long)info;
-		info->tx_timer.function = tx_timeout;
-
-		init_timer(&info->rx_timer);
-		info->rx_timer.data = (unsigned long)info;
-		info->rx_timer.function = rx_timeout;
+		setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
+		setup_timer(&info->rx_timer, rx_timeout, (unsigned long)info);
 
 		/* Copy configuration info to device instance data */
 		info->pdev = pdev;
@@ -3794,10 +3788,9 @@ static void tx_start(struct slgt_info *i
 				}
 			}
 
-			if (info->params.mode == MGSL_MODE_HDLC) {
-				info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-				add_timer(&info->tx_timer);
-			}
+			if (info->params.mode == MGSL_MODE_HDLC)
+				mod_timer(&info->tx_timer, jiffies +
+						msecs_to_jiffies(5000));
 		} else {
 			tdma_reset(info);
 			/* set 1st descriptor address */
diff -puN drivers/char/synclinkmp.c~char-timers-cleanup drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~char-timers-cleanup
+++ a/drivers/char/synclinkmp.c
@@ -2744,8 +2744,7 @@ static int startup(SLMP_INFO * info)
 
 	change_params(info);
 
-	info->status_timer.expires = jiffies + msecs_to_jiffies(10);
-	add_timer(&info->status_timer);
+	mod_timer(&info->status_timer, jiffies + msecs_to_jiffies(10));
 
 	if (info->tty)
 		clear_bit(TTY_IO_ERROR, &info->tty->flags);
@@ -3841,13 +3840,9 @@ static SLMP_INFO *alloc_dev(int adapter_
 		info->bus_type = MGSL_BUS_TYPE_PCI;
 		info->irq_flags = IRQF_SHARED;
 
-		init_timer(&info->tx_timer);
-		info->tx_timer.data = (unsigned long)info;
-		info->tx_timer.function = tx_timeout;
-
-		init_timer(&info->status_timer);
-		info->status_timer.data = (unsigned long)info;
-		info->status_timer.function = status_timeout;
+		setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
+		setup_timer(&info->status_timer, status_timeout,
+				(unsigned long)info);
 
 		/* Store the PCI9050 misc control register value because a flaw
 		 * in the PCI9050 prevents LCR registers from being read if
@@ -4291,8 +4286,8 @@ void tx_start(SLMP_INFO *info)
 			write_reg(info, TXDMA + DIR, 0x40);		/* enable Tx DMA interrupts (EOM) */
 			write_reg(info, TXDMA + DSR, 0xf2);		/* clear Tx DMA IRQs, enable Tx DMA */
 	
-			info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-			add_timer(&info->tx_timer);
+			mod_timer(&info->tx_timer, jiffies +
+					msecs_to_jiffies(5000));
 		}
 		else {
 			tx_load_fifo(info);
@@ -5574,10 +5569,7 @@ void status_timeout(unsigned long contex
 	if (status)
 		isr_io_pin(info,status);
 
-	info->status_timer.data = (unsigned long)info;
-	info->status_timer.function = status_timeout;
-	info->status_timer.expires = jiffies + msecs_to_jiffies(10);
-	add_timer(&info->status_timer);
+	mod_timer(&info->status_timer, jiffies + msecs_to_jiffies(10));
 }
 
 
diff -puN drivers/char/tpm/tpm.c~char-timers-cleanup drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~char-timers-cleanup
+++ a/drivers/char/tpm/tpm.c
@@ -1107,9 +1107,8 @@ struct tpm_chip *tpm_register_hardware(s
 
 	INIT_WORK(&chip->work, timeout_work);
 
-	init_timer(&chip->user_read_timer);
-	chip->user_read_timer.function = user_reader_timeout;
-	chip->user_read_timer.data = (unsigned long) chip;
+	setup_timer(&chip->user_read_timer, user_reader_timeout,
+			(unsigned long)chip);
 
 	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
 
diff -puN drivers/char/vt.c~char-timers-cleanup drivers/char/vt.c
--- a/drivers/char/vt.c~char-timers-cleanup
+++ a/drivers/char/vt.c
@@ -210,7 +210,7 @@ static int scrollback_delta;
  */
 int (*console_blank_hook)(int);
 
-static struct timer_list console_timer;
+static DEFINE_TIMER(console_timer, blank_screen_t, 0, 0);
 static int blank_state;
 static int blank_timer_expired;
 enum {
@@ -2625,8 +2625,6 @@ static int __init con_init(void)
 	for (i = 0; i < MAX_NR_CONSOLES; i++)
 		con_driver_map[i] = conswitchp;
 
-	init_timer(&console_timer);
-	console_timer.function = blank_screen_t;
 	if (blankinterval) {
 		blank_state = blank_normal_wait;
 		mod_timer(&console_timer, jiffies + blankinterval);
diff -puN drivers/char/watchdog/alim7101_wdt.c~char-timers-cleanup drivers/char/watchdog/alim7101_wdt.c
--- a/drivers/char/watchdog/alim7101_wdt.c~char-timers-cleanup
+++ a/drivers/char/watchdog/alim7101_wdt.c
@@ -69,7 +69,7 @@ module_param(use_gpio, int, 0);
 MODULE_PARM_DESC(use_gpio, "Use the gpio watchdog.  (required by old cobalt boards)");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 1);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -108,8 +108,7 @@ static void wdt_timer_ping(unsigned long
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 }
 
 /*
@@ -147,9 +146,7 @@ static void wdt_startup(void)
 	wdt_change(WDT_ENABLE);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
-
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
 }
@@ -380,10 +377,6 @@ static int __init alim7101_wdt_init(void
 			timeout);
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 1;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
 		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
diff -puN drivers/char/watchdog/cpu5wdt.c~char-timers-cleanup drivers/char/watchdog/cpu5wdt.c
--- a/drivers/char/watchdog/cpu5wdt.c~char-timers-cleanup
+++ a/drivers/char/watchdog/cpu5wdt.c
@@ -80,10 +80,8 @@ static void cpu5wdt_trigger(unsigned lon
 	outb(1, port + CPU5WDT_TRIGGER_REG);
 
 	/* requeue?? */
-	if( cpu5wdt_device.queue && ticks ) {
-		cpu5wdt_device.timer.expires = jiffies + CPU5WDT_INTERVAL;
-		add_timer(&cpu5wdt_device.timer);
-	}
+	if (cpu5wdt_device.queue && ticks)
+		mod_timer(&cpu5wdt_device.timer, jiffies + CPU5WDT_INTERVAL);
 	else {
 		/* ticks doesn't matter anyway */
 		complete(&cpu5wdt_device.stop);
@@ -109,8 +107,7 @@ static void cpu5wdt_start(void)
 		outb(1, port + CPU5WDT_MODE_REG);
 		outb(0, port + CPU5WDT_RESET_REG);
 		outb(0, port + CPU5WDT_ENABLE_REG);
-		cpu5wdt_device.timer.expires = jiffies + CPU5WDT_INTERVAL;
-		add_timer(&cpu5wdt_device.timer);
+		mod_timer(&cpu5wdt_device.timer, jiffies + CPU5WDT_INTERVAL);
 	}
 	/* if process dies, counter is not decremented */
 	cpu5wdt_device.running++;
@@ -245,9 +242,7 @@ static int __devinit cpu5wdt_init(void)
 
 	clear_bit(0, &cpu5wdt_device.inuse);
 
-	init_timer(&cpu5wdt_device.timer);
-	cpu5wdt_device.timer.function = cpu5wdt_trigger;
-	cpu5wdt_device.timer.data = 0;
+	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
 
 	cpu5wdt_device.default_ticks = ticks;
 
diff -puN drivers/char/watchdog/machzwd.c~char-timers-cleanup drivers/char/watchdog/machzwd.c
--- a/drivers/char/watchdog/machzwd.c~char-timers-cleanup
+++ a/drivers/char/watchdog/machzwd.c
@@ -118,12 +118,14 @@ static int action = 0;
 module_param(action, int, 0);
 MODULE_PARM_DESC(action, "after watchdog resets, generate: 0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI");
 
+static void zf_ping(unsigned long data);
+
 static int zf_action = GEN_RESET;
 static unsigned long zf_is_open;
 static char zf_expect_close;
 static spinlock_t zf_lock;
 static spinlock_t zf_port_lock;
-static struct timer_list zf_timer;
+static DEFINE_TIMER(zf_timer, zf_ping, 0, 0);
 static unsigned long next_heartbeat = 0;
 
 
@@ -220,9 +222,7 @@ static void zf_timer_on(void)
 	next_heartbeat = jiffies + ZF_USER_TIMEO;
 
 	/* start the timer for internal ping */
-	zf_timer.expires = jiffies + ZF_HW_TIMEO;
-
-	add_timer(&zf_timer);
+	mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 
 	/* start watchdog timer */
 	ctrl_reg = zf_get_control();
@@ -260,8 +260,7 @@ static void zf_ping(unsigned long data)
 		zf_set_control(ctrl_reg);
 		spin_unlock_irqrestore(&zf_port_lock, flags);
 
-		zf_timer.expires = jiffies + ZF_HW_TIMEO;
-		add_timer(&zf_timer);
+		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 	}else{
 		printk(KERN_CRIT PFX ": I will reset your machine\n");
 	}
@@ -465,11 +464,6 @@ static int __init zf_init(void)
 	zf_set_status(0);
 	zf_set_control(0);
 
-	/* this is the timer that will do the hard work */
-	init_timer(&zf_timer);
-	zf_timer.function = zf_ping;
-	zf_timer.data = 0;
-
 	return 0;
 
 no_reboot:
diff -puN drivers/char/watchdog/mixcomwd.c~char-timers-cleanup drivers/char/watchdog/mixcomwd.c
--- a/drivers/char/watchdog/mixcomwd.c~char-timers-cleanup
+++ a/drivers/char/watchdog/mixcomwd.c
@@ -56,11 +56,13 @@ static int mixcomwd_ioports[] = { 0x180,
 #define FLASHCOM_WATCHDOG_OFFSET 0x4
 #define FLASHCOM_ID 0x18
 
+static void mixcomwd_timerfun(unsigned long d);
+
 static unsigned long mixcomwd_opened; /* long req'd for setbit --RR */
 
 static int watchdog_port;
 static int mixcomwd_timer_alive;
-static DEFINE_TIMER(mixcomwd_timer, NULL, 0, 0);
+static DEFINE_TIMER(mixcomwd_timer, mixcomwd_timerfun, 0, 0);
 static char expect_close;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
@@ -77,7 +79,7 @@ static void mixcomwd_timerfun(unsigned l
 {
 	mixcomwd_ping();
 
-	mod_timer(&mixcomwd_timer,jiffies+ 5*HZ);
+	mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 }
 
 /*
@@ -114,12 +116,8 @@ static int mixcomwd_release(struct inode
 			printk(KERN_ERR "mixcomwd: release called while internal timer alive");
 			return -EBUSY;
 		}
-		init_timer(&mixcomwd_timer);
-		mixcomwd_timer.expires=jiffies + 5 * HZ;
-		mixcomwd_timer.function=mixcomwd_timerfun;
-		mixcomwd_timer.data=0;
 		mixcomwd_timer_alive=1;
-		add_timer(&mixcomwd_timer);
+		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 	} else {
 		printk(KERN_CRIT "mixcomwd: WDT device closed unexpectedly.  WDT will not stop!\n");
 	}
@@ -285,7 +283,7 @@ static void __exit mixcomwd_exit(void)
 		if(mixcomwd_timer_alive) {
 			printk(KERN_WARNING "mixcomwd: I quit now, hardware will"
 			       " probably reboot!\n");
-			del_timer(&mixcomwd_timer);
+			del_timer_sync(&mixcomwd_timer);
 			mixcomwd_timer_alive=0;
 		}
 	}
diff -puN drivers/char/watchdog/pcwd.c~char-timers-cleanup drivers/char/watchdog/pcwd.c
--- a/drivers/char/watchdog/pcwd.c~char-timers-cleanup
+++ a/drivers/char/watchdog/pcwd.c
@@ -843,9 +843,7 @@ static int __devinit pcwatchdog_init(int
 	/* clear the "card caused reboot" flag */
 	pcwd_clear_status();
 
-	init_timer(&pcwd_private.timer);
-	pcwd_private.timer.function = pcwd_timer_ping;
-	pcwd_private.timer.data = 0;
+	setup_timer(&pcwd_private.timer, pcwd_timer_ping, 0);
 
 	/*  Disable the board  */
 	pcwd_stop();
diff -puN drivers/char/watchdog/sbc60xxwdt.c~char-timers-cleanup drivers/char/watchdog/sbc60xxwdt.c
--- a/drivers/char/watchdog/sbc60xxwdt.c~char-timers-cleanup
+++ a/drivers/char/watchdog/sbc60xxwdt.c
@@ -103,7 +103,7 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -122,8 +122,7 @@ static void wdt_timer_ping(unsigned long
 		/* Ping the WDT by reading from wdt_start */
 		inb_p(wdt_start);
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else {
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
@@ -138,8 +137,7 @@ static void wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
 }
 
@@ -363,10 +361,6 @@ static int __init sbc60xxwdt_init(void)
 		}
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
diff -puN drivers/char/watchdog/sc520_wdt.c~char-timers-cleanup drivers/char/watchdog/sc520_wdt.c
--- a/drivers/char/watchdog/sc520_wdt.c~char-timers-cleanup
+++ a/drivers/char/watchdog/sc520_wdt.c
@@ -121,7 +121,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 static __u16 __iomem *wdtmrctl;
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -145,8 +145,7 @@ static void wdt_timer_ping(unsigned long
 		spin_unlock(&wdt_spinlock);
 
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else {
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
@@ -179,8 +178,7 @@ static int wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	/* Start the watchdog */
 	wdt_config(WDT_ENB | WDT_WRST_ENB | WDT_EXP_SEL_04);
@@ -389,10 +387,6 @@ static int __init sc520_wdt_init(void)
 
 	spin_lock_init(&wdt_spinlock);
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	/* Check that the timeout value is within it's range ; if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
diff -puN drivers/char/watchdog/shwdt.c~char-timers-cleanup drivers/char/watchdog/shwdt.c
--- a/drivers/char/watchdog/shwdt.c~char-timers-cleanup
+++ a/drivers/char/watchdog/shwdt.c
@@ -65,10 +65,12 @@ static int clock_division_ratio = WTCSR_
 
 #define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
 
+static void sh_wdt_ping(unsigned long data);
+
 static unsigned long shwdt_is_open;
 static struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
-static struct timer_list timer;
+static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
 
 #define WATCHDOG_HEARTBEAT 30			/* 30 sec default heartbeat */
@@ -433,10 +435,6 @@ static int __init sh_wdt_init(void)
 		       "be 1<=x<=3600, using %d\n", heartbeat);
 	}
 
-	init_timer(&timer);
-	timer.function = sh_wdt_ping;
-	timer.data = 0;
-
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
 		printk(KERN_ERR PFX "Can't register reboot notifier (err=%d)\n",
diff -puN drivers/char/watchdog/w83877f_wdt.c~char-timers-cleanup drivers/char/watchdog/w83877f_wdt.c
--- a/drivers/char/watchdog/w83877f_wdt.c~char-timers-cleanup
+++ a/drivers/char/watchdog/w83877f_wdt.c
@@ -90,7 +90,7 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -114,8 +114,7 @@ static void wdt_timer_ping(unsigned long
 		inb_p(WDT_PING);
 
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 		spin_unlock(&wdt_spinlock);
 
@@ -155,8 +154,7 @@ static void wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	wdt_change(WDT_ENABLE);
 
@@ -377,10 +375,6 @@ static int __init w83877f_wdt_init(void)
 		goto err_out_region1;
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
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
char-timers-cleanup-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
