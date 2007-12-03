From: akpm@linux-foundation.org
Subject: + clean-up-drivers-char-rtcc.patch added to -mm tree
Date: Mon, 03 Dec 2007 15:28:00 -0800
Message-ID: <200712032328.lB3NS0c4022960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbXLCX24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:28:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     clean up drivers/char/rtc.c
has been added to the -mm tree.  Its filename is
     clean-up-drivers-char-rtcc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clean up drivers/char/rtc.c
From: Ingo Molnar <mingo@elte.hu>

Tons of style cleanup in drivers/char/rtc.c - no code changed:

   text    data     bss     dec     hex filename
   6400     384      32    6816    1aa0 rtc.o.before
   6400     384      32    6816    1aa0 rtc.o.after

Since we seem to have a number of open breakages in this code we might as
well start with making the code more readable and maintainable.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |  238 +++++++++++++++++++++++--------------------
 1 file changed, 129 insertions(+), 109 deletions(-)

diff -puN drivers/char/rtc.c~clean-up-drivers-char-rtcc drivers/char/rtc.c
--- a/drivers/char/rtc.c~clean-up-drivers-char-rtcc
+++ a/drivers/char/rtc.c
@@ -1,5 +1,5 @@
 /*
- *	Real Time Clock interface for Linux	
+ *	Real Time Clock interface for Linux
  *
  *	Copyright (C) 1996 Paul Gortmaker
  *
@@ -17,7 +17,7 @@
  *	has been received. If a RTC interrupt has already happened,
  *	it will output an unsigned long and then block. The output value
  *	contains the interrupt status in the low byte and the number of
- *	interrupts since the last read in the remaining high bytes. The 
+ *	interrupts since the last read in the remaining high bytes. The
  *	/dev/rtc interface can also be used with the select(2) call.
  *
  *	This program is free software; you can redistribute it and/or
@@ -104,12 +104,12 @@ static int rtc_has_irq = 1;
 
 #ifndef CONFIG_HPET_EMULATE_RTC
 #define is_hpet_enabled()			0
-#define hpet_set_alarm_time(hrs, min, sec) 	0
-#define hpet_set_periodic_freq(arg) 		0
-#define hpet_mask_rtc_irq_bit(arg) 		0
-#define hpet_set_rtc_irq_bit(arg) 		0
-#define hpet_rtc_timer_init() 			do { } while (0)
-#define hpet_rtc_dropped_irq() 			0
+#define hpet_set_alarm_time(hrs, min, sec)	0
+#define hpet_set_periodic_freq(arg)		0
+#define hpet_mask_rtc_irq_bit(arg)		0
+#define hpet_set_rtc_irq_bit(arg)		0
+#define hpet_rtc_timer_init()			do { } while (0)
+#define hpet_rtc_dropped_irq()			0
 #ifdef RTC_IRQ
 static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {
@@ -147,7 +147,7 @@ static int rtc_ioctl(struct inode *inode
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
 #endif
 
-static void get_rtc_alm_time (struct rtc_time *alm_tm);
+static void get_rtc_alm_time(struct rtc_time *alm_tm);
 #ifdef RTC_IRQ
 static void set_rtc_irq_bit_locked(unsigned char bit);
 static void mask_rtc_irq_bit_locked(unsigned char bit);
@@ -185,9 +185,9 @@ static int rtc_proc_open(struct inode *i
  * rtc_status but before mod_timer is called, which would then reenable the
  * timer (but you would need to have an awful timing before you'd trip on it)
  */
-static unsigned long rtc_status = 0;	/* bitmapped status byte.	*/
-static unsigned long rtc_freq = 0;	/* Current periodic IRQ rate	*/
-static unsigned long rtc_irq_data = 0;	/* our output to the world	*/
+static unsigned long rtc_status;	/* bitmapped status byte.	*/
+static unsigned long rtc_freq;		/* Current periodic IRQ rate	*/
+static unsigned long rtc_irq_data;	/* our output to the world	*/
 static unsigned long rtc_max_user_freq = 64; /* > this, need CAP_SYS_RESOURCE */
 
 #ifdef RTC_IRQ
@@ -195,7 +195,7 @@ static unsigned long rtc_max_user_freq =
  * rtc_task_lock nests inside rtc_lock.
  */
 static DEFINE_SPINLOCK(rtc_task_lock);
-static rtc_task_t *rtc_callback = NULL;
+static rtc_task_t *rtc_callback;
 #endif
 
 /*
@@ -205,7 +205,7 @@ static rtc_task_t *rtc_callback = NULL;
 
 static unsigned long epoch = 1900;	/* year corresponding to 0x00	*/
 
-static const unsigned char days_in_mo[] = 
+static const unsigned char days_in_mo[] =
 {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
 
 /*
@@ -242,7 +242,7 @@ irqreturn_t rtc_interrupt(int irq, void 
 	 *	the last read in the remainder of rtc_irq_data.
 	 */
 
-	spin_lock (&rtc_lock);
+	spin_lock(&rtc_lock);
 	rtc_irq_data += 0x100;
 	rtc_irq_data &= ~0xff;
 	if (is_hpet_enabled()) {
@@ -259,16 +259,16 @@ irqreturn_t rtc_interrupt(int irq, void 
 	if (rtc_status & RTC_TIMER_ON)
 		mod_timer(&rtc_irq_timer, jiffies + HZ/rtc_freq + 2*HZ/100);
 
-	spin_unlock (&rtc_lock);
+	spin_unlock(&rtc_lock);
 
 	/* Now do the rest of the actions */
 	spin_lock(&rtc_task_lock);
 	if (rtc_callback)
 		rtc_callback->func(rtc_callback->private_data);
 	spin_unlock(&rtc_task_lock);
-	wake_up_interruptible(&rtc_wait);	
+	wake_up_interruptible(&rtc_wait);
 
-	kill_fasync (&rtc_async_queue, SIGIO, POLL_IN);
+	kill_fasync(&rtc_async_queue, SIGIO, POLL_IN);
 
 	return IRQ_HANDLED;
 }
@@ -335,7 +335,7 @@ static ssize_t rtc_read(struct file *fil
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long data;
 	ssize_t retval;
-	
+
 	if (rtc_has_irq == 0)
 		return -EIO;
 
@@ -358,11 +358,11 @@ static ssize_t rtc_read(struct file *fil
 		 * confusing. And no, xchg() is not the answer. */
 
 		__set_current_state(TASK_INTERRUPTIBLE);
-		
-		spin_lock_irq (&rtc_lock);
+
+		spin_lock_irq(&rtc_lock);
 		data = rtc_irq_data;
 		rtc_irq_data = 0;
-		spin_unlock_irq (&rtc_lock);
+		spin_unlock_irq(&rtc_lock);
 
 		if (data != 0)
 			break;
@@ -378,10 +378,13 @@ static ssize_t rtc_read(struct file *fil
 		schedule();
 	} while (1);
 
-	if (count == sizeof(unsigned int))
-		retval = put_user(data, (unsigned int __user *)buf) ?: sizeof(int);
-	else
-		retval = put_user(data, (unsigned long __user *)buf) ?: sizeof(long);
+	if (count == sizeof(unsigned int)) {
+		retval = put_user(data,
+				  (unsigned int __user *)buf) ?: sizeof(int);
+	} else {
+		retval = put_user(data,
+				  (unsigned long __user *)buf) ?: sizeof(long);
+	}
 	if (!retval)
 		retval = count;
  out:
@@ -394,7 +397,7 @@ static ssize_t rtc_read(struct file *fil
 
 static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 {
-	struct rtc_time wtime; 
+	struct rtc_time wtime;
 
 #ifdef RTC_IRQ
 	if (rtc_has_irq == 0) {
@@ -426,35 +429,41 @@ static int rtc_do_ioctl(unsigned int cmd
 	}
 	case RTC_PIE_OFF:	/* Mask periodic int. enab. bit	*/
 	{
-		unsigned long flags; /* can be called from isr via rtc_control() */
-		spin_lock_irqsave (&rtc_lock, flags);
+		/* can be called from isr via rtc_control() */
+		unsigned long flags;
+
+		spin_lock_irqsave(&rtc_lock, flags);
 		mask_rtc_irq_bit_locked(RTC_PIE);
 		if (rtc_status & RTC_TIMER_ON) {
 			rtc_status &= ~RTC_TIMER_ON;
 			del_timer(&rtc_irq_timer);
 		}
-		spin_unlock_irqrestore (&rtc_lock, flags);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+
 		return 0;
 	}
 	case RTC_PIE_ON:	/* Allow periodic ints		*/
 	{
-		unsigned long flags; /* can be called from isr via rtc_control() */
+		/* can be called from isr via rtc_control() */
+		unsigned long flags;
+
 		/*
 		 * We don't really want Joe User enabling more
 		 * than 64Hz of interrupts on a multi-user machine.
 		 */
 		if (!kernel && (rtc_freq > rtc_max_user_freq) &&
-			(!capable(CAP_SYS_RESOURCE)))
+						(!capable(CAP_SYS_RESOURCE)))
 			return -EACCES;
 
-		spin_lock_irqsave (&rtc_lock, flags);
+		spin_lock_irqsave(&rtc_lock, flags);
 		if (!(rtc_status & RTC_TIMER_ON)) {
 			mod_timer(&rtc_irq_timer, jiffies + HZ/rtc_freq +
 					2*HZ/100);
 			rtc_status |= RTC_TIMER_ON;
 		}
 		set_rtc_irq_bit_locked(RTC_PIE);
-		spin_unlock_irqrestore (&rtc_lock, flags);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+
 		return 0;
 	}
 	case RTC_UIE_OFF:	/* Mask ints from RTC updates.	*/
@@ -477,7 +486,7 @@ static int rtc_do_ioctl(unsigned int cmd
 		 */
 		memset(&wtime, 0, sizeof(struct rtc_time));
 		get_rtc_alm_time(&wtime);
-		break; 
+		break;
 	}
 	case RTC_ALM_SET:	/* Store a time into the alarm */
 	{
@@ -505,16 +514,21 @@ static int rtc_do_ioctl(unsigned int cmd
 			 */
 		}
 		if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) ||
-		    RTC_ALWAYS_BCD)
-		{
-			if (sec < 60) BIN_TO_BCD(sec);
-			else sec = 0xff;
-
-			if (min < 60) BIN_TO_BCD(min);
-			else min = 0xff;
-
-			if (hrs < 24) BIN_TO_BCD(hrs);
-			else hrs = 0xff;
+							RTC_ALWAYS_BCD) {
+			if (sec < 60)
+				BIN_TO_BCD(sec);
+			else
+				sec = 0xff;
+
+			if (min < 60)
+				BIN_TO_BCD(min);
+			else
+				min = 0xff;
+
+			if (hrs < 24)
+				BIN_TO_BCD(hrs);
+			else
+				hrs = 0xff;
 		}
 		CMOS_WRITE(hrs, RTC_HOURS_ALARM);
 		CMOS_WRITE(min, RTC_MINUTES_ALARM);
@@ -563,11 +577,12 @@ static int rtc_do_ioctl(unsigned int cmd
 
 		if (day > (days_in_mo[mon] + ((mon == 2) && leap_yr)))
 			return -EINVAL;
-			
+
 		if ((hrs >= 24) || (min >= 60) || (sec >= 60))
 			return -EINVAL;
 
-		if ((yrs -= epoch) > 255)    /* They are unsigned */
+		yrs -= epoch;
+		if (yrs > 255)		/* They are unsigned */
 			return -EINVAL;
 
 		spin_lock_irq(&rtc_lock);
@@ -635,9 +650,10 @@ static int rtc_do_ioctl(unsigned int cmd
 	{
 		int tmp = 0;
 		unsigned char val;
-		unsigned long flags; /* can be called from isr via rtc_control() */
+		/* can be called from isr via rtc_control() */
+		unsigned long flags;
 
-		/* 
+		/*
 		 * The max we can do is 8192Hz.
 		 */
 		if ((arg < 2) || (arg > 8192))
@@ -646,7 +662,8 @@ static int rtc_do_ioctl(unsigned int cmd
 		 * We don't really want Joe User generating more
 		 * than 64Hz of interrupts on a multi-user machine.
 		 */
-		if (!kernel && (arg > rtc_max_user_freq) && (!capable(CAP_SYS_RESOURCE)))
+		if (!kernel && (arg > rtc_max_user_freq) &&
+					!capable(CAP_SYS_RESOURCE))
 			return -EACCES;
 
 		while (arg > (1<<tmp))
@@ -674,11 +691,11 @@ static int rtc_do_ioctl(unsigned int cmd
 #endif
 	case RTC_EPOCH_READ:	/* Read the epoch.	*/
 	{
-		return put_user (epoch, (unsigned long __user *)arg);
+		return put_user(epoch, (unsigned long __user *)arg);
 	}
 	case RTC_EPOCH_SET:	/* Set the epoch.	*/
 	{
-		/* 
+		/*
 		 * There were no RTC clocks before 1900.
 		 */
 		if (arg < 1900)
@@ -693,7 +710,8 @@ static int rtc_do_ioctl(unsigned int cmd
 	default:
 		return -ENOTTY;
 	}
-	return copy_to_user((void __user *)arg, &wtime, sizeof wtime) ? -EFAULT : 0;
+	return copy_to_user((void __user *)arg,
+			    &wtime, sizeof wtime) ? -EFAULT : 0;
 }
 
 static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
@@ -712,26 +730,25 @@ static int rtc_ioctl(struct inode *inode
  * needed here. Or anywhere else in this driver. */
 static int rtc_open(struct inode *inode, struct file *file)
 {
-	spin_lock_irq (&rtc_lock);
+	spin_lock_irq(&rtc_lock);
 
-	if(rtc_status & RTC_IS_OPEN)
+	if (rtc_status & RTC_IS_OPEN)
 		goto out_busy;
 
 	rtc_status |= RTC_IS_OPEN;
 
 	rtc_irq_data = 0;
-	spin_unlock_irq (&rtc_lock);
+	spin_unlock_irq(&rtc_lock);
 	return 0;
 
 out_busy:
-	spin_unlock_irq (&rtc_lock);
+	spin_unlock_irq(&rtc_lock);
 	return -EBUSY;
 }
 
-static int rtc_fasync (int fd, struct file *filp, int on)
-
+static int rtc_fasync(int fd, struct file *filp, int on)
 {
-	return fasync_helper (fd, filp, on, &rtc_async_queue);
+	return fasync_helper(fd, filp, on, &rtc_async_queue);
 }
 
 static int rtc_release(struct inode *inode, struct file *file)
@@ -762,16 +779,16 @@ static int rtc_release(struct inode *ino
 	}
 	spin_unlock_irq(&rtc_lock);
 
-	if (file->f_flags & FASYNC) {
-		rtc_fasync (-1, file, 0);
-	}
+	if (file->f_flags & FASYNC)
+		rtc_fasync(-1, file, 0);
 no_irq:
 #endif
 
-	spin_lock_irq (&rtc_lock);
+	spin_lock_irq(&rtc_lock);
 	rtc_irq_data = 0;
 	rtc_status &= ~RTC_IS_OPEN;
-	spin_unlock_irq (&rtc_lock);
+	spin_unlock_irq(&rtc_lock);
+
 	return 0;
 }
 
@@ -786,9 +803,9 @@ static unsigned int rtc_poll(struct file
 
 	poll_wait(file, &rtc_wait, wait);
 
-	spin_lock_irq (&rtc_lock);
+	spin_lock_irq(&rtc_lock);
 	l = rtc_irq_data;
-	spin_unlock_irq (&rtc_lock);
+	spin_unlock_irq(&rtc_lock);
 
 	if (l != 0)
 		return POLLIN | POLLRDNORM;
@@ -796,14 +813,6 @@ static unsigned int rtc_poll(struct file
 }
 #endif
 
-/*
- * exported stuffs
- */
-
-EXPORT_SYMBOL(rtc_register);
-EXPORT_SYMBOL(rtc_unregister);
-EXPORT_SYMBOL(rtc_control);
-
 int rtc_register(rtc_task_t *task)
 {
 #ifndef RTC_IRQ
@@ -829,6 +838,7 @@ int rtc_register(rtc_task_t *task)
 	return 0;
 #endif
 }
+EXPORT_SYMBOL(rtc_register);
 
 int rtc_unregister(rtc_task_t *task)
 {
@@ -845,7 +855,7 @@ int rtc_unregister(rtc_task_t *task)
 		return -ENXIO;
 	}
 	rtc_callback = NULL;
-	
+
 	/* disable controls */
 	if (!hpet_mask_rtc_irq_bit(RTC_PIE | RTC_AIE | RTC_UIE)) {
 		tmp = CMOS_READ(RTC_CONTROL);
@@ -865,6 +875,7 @@ int rtc_unregister(rtc_task_t *task)
 	return 0;
 #endif
 }
+EXPORT_SYMBOL(rtc_unregister);
 
 int rtc_control(rtc_task_t *task, unsigned int cmd, unsigned long arg)
 {
@@ -883,7 +894,7 @@ int rtc_control(rtc_task_t *task, unsign
 	return rtc_do_ioctl(cmd, arg, 1);
 #endif
 }
-
+EXPORT_SYMBOL(rtc_control);
 
 /*
  *	The various file operations we support.
@@ -910,11 +921,11 @@ static struct miscdevice rtc_dev = {
 
 #ifdef CONFIG_PROC_FS
 static const struct file_operations rtc_proc_fops = {
-	.owner = THIS_MODULE,
-	.open = rtc_proc_open,
-	.read  = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+	.owner		= THIS_MODULE,
+	.open		= rtc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 };
 #endif
 
@@ -965,7 +976,7 @@ static int __init rtc_init(void)
 #ifdef CONFIG_SPARC32
 	for_each_ebus(ebus) {
 		for_each_ebusdev(edev, ebus) {
-			if(strcmp(edev->prom_node->name, "rtc") == 0) {
+			if (strcmp(edev->prom_node->name, "rtc") == 0) {
 				rtc_port = edev->resource[0].start;
 				rtc_irq = edev->irqs[0];
 				goto found;
@@ -986,7 +997,8 @@ found:
 	 * XXX Interrupt pin #7 in Espresso is shared between RTC and
 	 * PCI Slot 2 INTA# (and some INTx# in Slot 1).
 	 */
-	if (request_irq(rtc_irq, rtc_interrupt, IRQF_SHARED, "rtc", (void *)&rtc_port)) {
+	if (request_irq(rtc_irq, rtc_interrupt, IRQF_SHARED, "rtc",
+			(void *)&rtc_port)) {
 		rtc_has_irq = 0;
 		printk(KERN_ERR "rtc: cannot register IRQ %d\n", rtc_irq);
 		return -EIO;
@@ -1020,11 +1032,13 @@ no_irq:
 		rtc_int_handler_ptr = rtc_interrupt;
 	}
 
-	if(request_irq(RTC_IRQ, rtc_int_handler_ptr, IRQF_DISABLED, "rtc", NULL)) {
+	if (request_irq(RTC_IRQ, rtc_int_handler_ptr, IRQF_DISABLED,
+			"rtc", NULL)) {
 		/* Yeah right, seeing as irq 8 doesn't even hit the bus. */
 		rtc_has_irq = 0;
 		printk(KERN_ERR "rtc: IRQ %d is not free.\n", RTC_IRQ);
 		rtc_release_region();
+
 		return -EIO;
 	}
 	hpet_rtc_timer_init();
@@ -1052,21 +1066,21 @@ no_irq:
 
 #if defined(__alpha__) || defined(__mips__)
 	rtc_freq = HZ;
-	
+
 	/* Each operating system on an Alpha uses its own epoch.
 	   Let's try to guess which one we are using now. */
-	
+
 	if (rtc_is_updating() != 0)
 		msleep(20);
-	
+
 	spin_lock_irq(&rtc_lock);
 	year = CMOS_READ(RTC_YEAR);
 	ctrl = CMOS_READ(RTC_CONTROL);
 	spin_unlock_irq(&rtc_lock);
-	
+
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
 		BCD_TO_BIN(year);       /* This should never happen... */
-	
+
 	if (year < 20) {
 		epoch = 2000;
 		guess = "SRM (post-2000)";
@@ -1087,7 +1101,8 @@ no_irq:
 #endif
 	}
 	if (guess)
-		printk(KERN_INFO "rtc: %s epoch (%lu) detected\n", guess, epoch);
+		printk(KERN_INFO "rtc: %s epoch (%lu) detected\n",
+			guess, epoch);
 #endif
 #ifdef RTC_IRQ
 	if (rtc_has_irq == 0)
@@ -1096,8 +1111,12 @@ no_irq:
 	spin_lock_irq(&rtc_lock);
 	rtc_freq = 1024;
 	if (!hpet_set_periodic_freq(rtc_freq)) {
-		/* Initialize periodic freq. to CMOS reset default, which is 1024Hz */
-		CMOS_WRITE(((CMOS_READ(RTC_FREQ_SELECT) & 0xF0) | 0x06), RTC_FREQ_SELECT);
+		/*
+		 * Initialize periodic frequency to CMOS reset default,
+		 * which is 1024Hz
+		 */
+		CMOS_WRITE(((CMOS_READ(RTC_FREQ_SELECT) & 0xF0) | 0x06),
+			   RTC_FREQ_SELECT);
 	}
 	spin_unlock_irq(&rtc_lock);
 no_irq2:
@@ -1110,20 +1129,20 @@ no_irq2:
 	return 0;
 }
 
-static void __exit rtc_exit (void)
+static void __exit rtc_exit(void)
 {
 	cleanup_sysctl();
-	remove_proc_entry ("driver/rtc", NULL);
+	remove_proc_entry("driver/rtc", NULL);
 	misc_deregister(&rtc_dev);
 
 #ifdef CONFIG_SPARC32
 	if (rtc_has_irq)
-		free_irq (rtc_irq, &rtc_port);
+		free_irq(rtc_irq, &rtc_port);
 #else
 	rtc_release_region();
 #ifdef RTC_IRQ
 	if (rtc_has_irq)
-		free_irq (RTC_IRQ, NULL);
+		free_irq(RTC_IRQ, NULL);
 #endif
 #endif /* CONFIG_SPARC32 */
 }
@@ -1133,14 +1152,14 @@ module_exit(rtc_exit);
 
 #ifdef RTC_IRQ
 /*
- * 	At IRQ rates >= 4096Hz, an interrupt may get lost altogether.
+ *	At IRQ rates >= 4096Hz, an interrupt may get lost altogether.
  *	(usually during an IDE disk interrupt, with IRQ unmasking off)
  *	Since the interrupt handler doesn't get called, the IRQ status
  *	byte doesn't get read, and the RTC stops generating interrupts.
  *	A timer is set, and will call this function if/when that happens.
  *	To get it out of this stalled state, we just read the status.
  *	At least a jiffy of interrupts (rtc_freq/HZ) will have been lost.
- *	(You *really* shouldn't be trying to use a non-realtime system 
+ *	(You *really* shouldn't be trying to use a non-realtime system
  *	for something that requires a steady > 1KHz signal anyways.)
  */
 
@@ -1148,7 +1167,7 @@ static void rtc_dropped_irq(unsigned lon
 {
 	unsigned long freq;
 
-	spin_lock_irq (&rtc_lock);
+	spin_lock_irq(&rtc_lock);
 
 	if (hpet_rtc_dropped_irq()) {
 		spin_unlock_irq(&rtc_lock);
@@ -1167,13 +1186,15 @@ static void rtc_dropped_irq(unsigned lon
 
 	spin_unlock_irq(&rtc_lock);
 
-	if (printk_ratelimit())
-		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
+	if (printk_ratelimit()) {
+		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
+			freq);
+	}
 
 	/* Now we have new data */
 	wake_up_interruptible(&rtc_wait);
 
-	kill_fasync (&rtc_async_queue, SIGIO, POLL_IN);
+	kill_fasync(&rtc_async_queue, SIGIO, POLL_IN);
 }
 #endif
 
@@ -1277,7 +1298,7 @@ void rtc_get_rtc_time(struct rtc_time *r
 	 * can take just over 2ms. We wait 20ms. There is no need to
 	 * to poll-wait (up to 1s - eeccch) for the falling edge of RTC_UIP.
 	 * If you need to know *exactly* when a second has started, enable
-	 * periodic update complete interrupts, (via ioctl) and then 
+	 * periodic update complete interrupts, (via ioctl) and then
 	 * immediately read /dev/rtc which will block until you get the IRQ.
 	 * Once the read clears, read the RTC time (again via ioctl). Easy.
 	 */
@@ -1307,8 +1328,7 @@ void rtc_get_rtc_time(struct rtc_time *r
 	ctrl = CMOS_READ(RTC_CONTROL);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-	{
+	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		BCD_TO_BIN(rtc_tm->tm_sec);
 		BCD_TO_BIN(rtc_tm->tm_min);
 		BCD_TO_BIN(rtc_tm->tm_hour);
@@ -1326,7 +1346,8 @@ void rtc_get_rtc_time(struct rtc_time *r
 	 * Account for differences between how the RTC uses the values
 	 * and how they are defined in a struct rtc_time;
 	 */
-	if ((rtc_tm->tm_year += (epoch - 1900)) <= 69)
+	rtc_tm->tm_year += epoch - 1900;
+	if (rtc_tm->tm_year <= 69)
 		rtc_tm->tm_year += 100;
 
 	rtc_tm->tm_mon--;
@@ -1347,8 +1368,7 @@ static void get_rtc_alm_time(struct rtc_
 	ctrl = CMOS_READ(RTC_CONTROL);
 	spin_unlock_irq(&rtc_lock);
 
-	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-	{
+	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		BCD_TO_BIN(alm_tm->tm_sec);
 		BCD_TO_BIN(alm_tm->tm_min);
 		BCD_TO_BIN(alm_tm->tm_hour);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
git-acpi.patch
git-alsa.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
git-sched.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
merge-multiple-error-paths-in-alloc_uid-into-one.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
git-x86.patch
uml-add-asm-um-asmh.patch
x86_64-add-acpi-reboot-option.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
git-cryptodev-fixup.patch
fix-proc-net-breakage.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
fix-proc-dcache-deadlock-in-do_exit.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
avoid-overflows-in-kernel-timec.patch
clean-up-drivers-char-rtcc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
