From: akpm@osdl.org
Subject: - tlclk-bug-fix-misc-fixes.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:37 -0800
Message-ID: <200701260751.l0Q7pb1u010744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50473 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030809AbXAZHvk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, mark.gross@intel.com, mm-commits@vger.kernel.org


The patch titled
     tlclk: bug fix + misc fixes
has been removed from the -mm tree.  Its filename was
     tlclk-bug-fix-misc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tlclk: bug fix + misc fixes
From: Mark Gross <mgross@linux.intel.com>

The following patch fixes a few problems with the tlclk driver.
* bug in the select_amcb1_transmit_clock
* racy read sys call
* racy open sys call
* use of add_timer where mod_timer would be better
* change to the timer data parameter use

Signed-off-by: Mark Gross <mark.gross@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tlclk.c |   43 ++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff -puN drivers/char/tlclk.c~tlclk-bug-fix-misc-fixes drivers/char/tlclk.c
--- a/drivers/char/tlclk.c~tlclk-bug-fix-misc-fixes
+++ a/drivers/char/tlclk.c
@@ -186,6 +186,7 @@ static int got_event;		/* if events proc
 static void switchover_timeout(unsigned long data);
 static struct timer_list switchover_timer =
 	TIMER_INITIALIZER(switchover_timeout , 0, 0);
+static unsigned long tlclk_timer_data;
 
 static struct tlclk_alarms *alarm_events;
 
@@ -197,10 +198,19 @@ static irqreturn_t tlclk_interrupt(int i
 
 static DECLARE_WAIT_QUEUE_HEAD(wq);
 
+static unsigned long useflags;
+static DEFINE_MUTEX(tlclk_mutex);
+
 static int tlclk_open(struct inode *inode, struct file *filp)
 {
 	int result;
 
+	if (test_and_set_bit(0, &useflags))
+		return -EBUSY;
+		/* this legacy device is always one per system and it doesn't
+		 * know how to handle multiple concurrent clients.
+		 */
+
 	/* Make sure there is no interrupt pending while
 	 * initialising interrupt handler */
 	inb(TLCLK_REG6);
@@ -221,6 +231,7 @@ static int tlclk_open(struct inode *inod
 static int tlclk_release(struct inode *inode, struct file *filp)
 {
 	free_irq(telclk_interrupt, tlclk_interrupt);
+	clear_bit(0, &useflags);
 
 	return 0;
 }
@@ -230,26 +241,25 @@ static ssize_t tlclk_read(struct file *f
 {
 	if (count < sizeof(struct tlclk_alarms))
 		return -EIO;
+	if (mutex_lock_interruptible(&tlclk_mutex))
+		return -EINTR;
+
 
 	wait_event_interruptible(wq, got_event);
-	if (copy_to_user(buf, alarm_events, sizeof(struct tlclk_alarms)))
+	if (copy_to_user(buf, alarm_events, sizeof(struct tlclk_alarms))) {
+		mutex_unlock(&tlclk_mutex);
 		return -EFAULT;
+	}
 
 	memset(alarm_events, 0, sizeof(struct tlclk_alarms));
 	got_event = 0;
 
+	mutex_unlock(&tlclk_mutex);
 	return  sizeof(struct tlclk_alarms);
 }
 
-static ssize_t tlclk_write(struct file *filp, const char __user *buf, size_t count,
-	    loff_t *f_pos)
-{
-	return 0;
-}
-
 static const struct file_operations tlclk_fops = {
 	.read = tlclk_read,
-	.write = tlclk_write,
 	.open = tlclk_open,
 	.release = tlclk_release,
 
@@ -540,7 +550,7 @@ static ssize_t store_select_amcb1_transm
 			SET_PORT_BITS(TLCLK_REG3, 0xf8, 0x7);
 			switch (val) {
 			case CLK_8_592MHz:
-				SET_PORT_BITS(TLCLK_REG0, 0xfc, 1);
+				SET_PORT_BITS(TLCLK_REG0, 0xfc, 2);
 				break;
 			case CLK_11_184MHz:
 				SET_PORT_BITS(TLCLK_REG0, 0xfc, 0);
@@ -549,7 +559,7 @@ static ssize_t store_select_amcb1_transm
 				SET_PORT_BITS(TLCLK_REG0, 0xfc, 3);
 				break;
 			case CLK_44_736MHz:
-				SET_PORT_BITS(TLCLK_REG0, 0xfc, 2);
+				SET_PORT_BITS(TLCLK_REG0, 0xfc, 1);
 				break;
 			}
 		} else
@@ -839,11 +849,13 @@ static void __exit tlclk_cleanup(void)
 
 static void switchover_timeout(unsigned long data)
 {
-	if ((data & 1)) {
-		if ((inb(TLCLK_REG1) & 0x08) != (data & 0x08))
+	unsigned long flags = *(unsigned long *) data;
+
+	if ((flags & 1)) {
+		if ((inb(TLCLK_REG1) & 0x08) != (flags & 0x08))
 			alarm_events->switchover_primary++;
 	} else {
-		if ((inb(TLCLK_REG1) & 0x08) != (data & 0x08))
+		if ((inb(TLCLK_REG1) & 0x08) != (flags & 0x08))
 			alarm_events->switchover_secondary++;
 	}
 
@@ -901,8 +913,9 @@ static irqreturn_t tlclk_interrupt(int i
 
 		/* TIMEOUT in ~10ms */
 		switchover_timer.expires = jiffies + msecs_to_jiffies(10);
-		switchover_timer.data = inb(TLCLK_REG1);
-		add_timer(&switchover_timer);
+		tlclk_timer_data = inb(TLCLK_REG1);
+		switchover_timer.data = (unsigned long) &tlclk_timer_data;
+		mod_timer(&switchover_timer, switchover_timer.expires);
 	} else {
 		got_event = 1;
 		wake_up(&wq);
_

Patches currently in -mm which might be from mgross@linux.intel.com are
