From: akpm@osdl.org
Subject: + rtc-driver-init-adjustment.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:06:47 -0800
Message-ID: <200612102006.kBAK6lSe001791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57079 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762457AbWLJUGv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:06:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     RTC driver init adjustment
has been added to the -mm tree.  Its filename is
     rtc-driver-init-adjustment.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC driver init adjustment
From: "Jan Beulich" <jbeulich@novell.com>

- conditionalizes procfs code upon CONFIG_PROC_FS (to reduce code size when
  that option is not enabled)

- make initialization no longer fail when the procfs entry can't be
  allocated (namely would initialization always have failed when
  CONFIG_PROC_FS was not set)

- move the formerly file-scope static variable rtc_int_handler_ptr into
  the only function using it, and makes it automatic.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/rtc.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN drivers/char/rtc.c~rtc-driver-init-adjustment drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-driver-init-adjustment
+++ a/drivers/char/rtc.c
@@ -113,7 +113,7 @@ static int rtc_has_irq = 1;
 #define hpet_set_rtc_irq_bit(arg) 		0
 #define hpet_rtc_timer_init() 			do { } while (0)
 #define hpet_rtc_dropped_irq() 			0
-static inline irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id) {return 0;}
+static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id) {return 0;}
 #else
 extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
@@ -165,7 +165,9 @@ static void mask_rtc_irq_bit(unsigned ch
 }
 #endif
 
+#ifdef CONFIG_PROC_FS
 static int rtc_proc_open(struct inode *inode, struct file *file);
+#endif
 
 /*
  *	Bits in rtc_status. (6 bits of room for future expansion)
@@ -906,6 +908,7 @@ static struct miscdevice rtc_dev = {
 	.fops		= &rtc_fops,
 };
 
+#ifdef CONFIG_PROC_FS
 static const struct file_operations rtc_proc_fops = {
 	.owner = THIS_MODULE,
 	.open = rtc_proc_open,
@@ -913,14 +916,13 @@ static const struct file_operations rtc_
 	.llseek = seq_lseek,
 	.release = single_release,
 };
-
-#if defined(RTC_IRQ) && !defined(__sparc__)
-static irq_handler_t rtc_int_handler_ptr;
 #endif
 
 static int __init rtc_init(void)
 {
+#ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *ent;
+#endif
 #if defined(__alpha__) || defined(__mips__)
 	unsigned int year, ctrl;
 	char *guess = NULL;
@@ -932,9 +934,11 @@ static int __init rtc_init(void)
 	struct sparc_isa_bridge *isa_br;
 	struct sparc_isa_device *isa_dev;
 #endif
-#endif
-#ifndef __sparc__
+#else
 	void *r;
+#ifdef RTC_IRQ
+	irq_handler_t rtc_int_handler_ptr;
+#endif
 #endif
 
 #ifdef __sparc__
@@ -1024,17 +1028,13 @@ no_irq:
 		return -ENODEV;
 	}
 
+#ifdef CONFIG_PROC_FS
 	ent = create_proc_entry("driver/rtc", 0, NULL);
-	if (!ent) {
-#ifdef RTC_IRQ
-		free_irq(RTC_IRQ, NULL);
-		rtc_has_irq = 0;
+	if (ent)
+		ent->proc_fops = &rtc_proc_fops;
+	else
+		printk(KERN_WARNING "rtc: Failed to register with procfs.\n");
 #endif
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
-		misc_deregister(&rtc_dev);
-		return -ENOMEM;
-	}
-	ent->proc_fops = &rtc_proc_fops;
 
 #if defined(__alpha__) || defined(__mips__)
 	rtc_freq = HZ;
@@ -1167,6 +1167,7 @@ static void rtc_dropped_irq(unsigned lon
 }
 #endif
 
+#ifdef CONFIG_PROC_FS
 /*
  *	Info exported via "/proc/driver/rtc".
  */
@@ -1251,6 +1252,7 @@ static int rtc_proc_open(struct inode *i
 {
 	return single_open(file, rtc_proc_show, NULL);
 }
+#endif
 
 void rtc_get_rtc_time(struct rtc_time *rtc_tm)
 {
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
some-kbuild-fix.patch
rtc-fix-error-case.patch
rtc-driver-init-adjustment.patch

