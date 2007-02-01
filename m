From: akpm@osdl.org
Subject: + workaround-capi-subsystem-locking-issue.patch added to -mm tree
Date: Thu, 01 Feb 2007 13:41:59 -0800
Message-ID: <200702012141.l11Lfx60023669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40801 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbXBAVmJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 16:42:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, kai.germaschewski@gmx.de, kkeil@suse.de


The patch titled
     Workaround CAPI subsystem locking issue
has been added to the -mm tree.  Its filename is
     workaround-capi-subsystem-locking-issue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Workaround CAPI subsystem locking issue
From: Michael Buesch <mb@bu3sch.de>

I think the following patch should go into the kernel, until the ISDN/CAPI
guys create the real fix for this issue.

The issue is a concurrency issue with some internal CAPI data structure
which can crash the kernel.

On my FritzCard DSL with the AVM driver it crashes about once a day without
this workaround patch.  With this workaround patch it's rock-stable (at
least on UP, but I don't see why this shouldn't work on SMP as well.  But
maybe I'm missing something.)

This workaround is kind of a sledgehammer which inserts a global lock to
wrap around all the critical sections.  Of course, this is a scalability
issue, if you have many ISDN/CAPI cards.  But it prevents a crash.  So I
vote for this fix to get merged, until people come up with a better
solution.  Better have a stable kernel that's less scalable, than a
crashing and useless kernel.

This bug is in the kernel since 2.6.15 (at least).

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Kai Germaschewski <kai.germaschewski@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/capi/capi.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+)

diff -puN drivers/isdn/capi/capi.c~workaround-capi-subsystem-locking-issue drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~workaround-capi-subsystem-locking-issue
+++ a/drivers/isdn/capi/capi.c
@@ -118,6 +118,15 @@ struct capiminor {
 };
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 
+/* FIXME: The following lock is a sledgehammer-workaround to a
+ * locking issue with the capiminor (and maybe other) data structure(s).
+ * Access to this data is done in a racy way and crashes the machine with
+ * a FritzCard DSL driver; sooner or later. This is a workaround
+ * which trades scalability vs stability, so it doesn't crash the kernel anymore.
+ * The correct (and scalable) fix for the issue seems to require
+ * an API change to the drivers... . */
+static DEFINE_SPINLOCK(workaround_lock);
+
 struct capincci {
 	struct capincci *next;
 	u32		 ncci;
@@ -589,6 +598,7 @@ static void capi_recv_message(struct cap
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 	struct capincci *np;
 	u32 ncci;
+	unsigned long flags;
 
 	if (CAPIMSG_CMD(skb->data) == CAPI_CONNECT_B3_CONF) {
 		u16 info = CAPIMSG_U16(skb->data, 12); // Info field
@@ -603,9 +613,11 @@ static void capi_recv_message(struct cap
 		capincci_alloc(cdev, CAPIMSG_NCCI(skb->data));
 		up(&cdev->ncci_list_sem);
 	}
+	spin_lock_irqsave(&workaround_lock, flags);
 	if (CAPIMSG_COMMAND(skb->data) != CAPI_DATA_B3) {
 		skb_queue_tail(&cdev->recvqueue, skb);
 		wake_up_interruptible(&cdev->recvwait);
+		spin_unlock_irqrestore(&workaround_lock, flags);
 		return;
 	}
 	ncci = CAPIMSG_CONTROL(skb->data);
@@ -615,6 +627,7 @@ static void capi_recv_message(struct cap
 		printk(KERN_ERR "BUG: capi_signal: ncci not found\n");
 		skb_queue_tail(&cdev->recvqueue, skb);
 		wake_up_interruptible(&cdev->recvwait);
+		spin_unlock_irqrestore(&workaround_lock, flags);
 		return;
 	}
 #ifndef CONFIG_ISDN_CAPI_MIDDLEWARE
@@ -625,6 +638,7 @@ static void capi_recv_message(struct cap
 	if (!mp) {
 		skb_queue_tail(&cdev->recvqueue, skb);
 		wake_up_interruptible(&cdev->recvwait);
+		spin_unlock_irqrestore(&workaround_lock, flags);
 		return;
 	}
 
@@ -660,6 +674,7 @@ static void capi_recv_message(struct cap
 		wake_up_interruptible(&cdev->recvwait);
 	}
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
+	spin_unlock_irqrestore(&workaround_lock, flags);
 }
 
 /* -------- file_operations for capidev ----------------------------- */
@@ -1006,6 +1021,7 @@ static struct file_operations capi_fops 
 static int capinc_tty_open(struct tty_struct * tty, struct file * file)
 {
 	struct capiminor *mp;
+	unsigned long flags;
 
 	if ((mp = capiminor_find(iminor(file->f_path.dentry->d_inode))) == 0)
 		return -ENXIO;
@@ -1014,6 +1030,7 @@ static int capinc_tty_open(struct tty_st
 
 	tty->driver_data = (void *)mp;
 
+	spin_lock_irqsave(&workaround_lock, flags);
 	if (atomic_read(&mp->ttyopencount) == 0)
 		mp->tty = tty;
 	atomic_inc(&mp->ttyopencount);
@@ -1021,6 +1038,7 @@ static int capinc_tty_open(struct tty_st
 	printk(KERN_DEBUG "capinc_tty_open ocount=%d\n", atomic_read(&mp->ttyopencount));
 #endif
 	handle_minor_recv(mp);
+	spin_unlock_irqrestore(&workaround_lock, flags);
 	return 0;
 }
 
@@ -1054,6 +1072,7 @@ static int capinc_tty_write(struct tty_s
 {
 	struct capiminor *mp = (struct capiminor *)tty->driver_data;
 	struct sk_buff *skb;
+	unsigned long flags;
 
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_tty_write(count=%d)\n", count);
@@ -1066,6 +1085,7 @@ static int capinc_tty_write(struct tty_s
 		return 0;
 	}
 
+	spin_lock_irqsave(&workaround_lock, flags);
 	skb = mp->ttyskb;
 	if (skb) {
 		mp->ttyskb = NULL;
@@ -1076,6 +1096,7 @@ static int capinc_tty_write(struct tty_s
 	skb = alloc_skb(CAPI_DATA_B3_REQ_LEN+count, GFP_ATOMIC);
 	if (!skb) {
 		printk(KERN_ERR "capinc_tty_write: alloc_skb failed\n");
+		spin_unlock_irqrestore(&workaround_lock, flags);
 		return -ENOMEM;
 	}
 
@@ -1086,6 +1107,7 @@ static int capinc_tty_write(struct tty_s
 	mp->outbytes += skb->len;
 	(void)handle_minor_send(mp);
 	(void)handle_minor_recv(mp);
+	spin_unlock_irqrestore(&workaround_lock, flags);
 	return count;
 }
 
@@ -1093,6 +1115,7 @@ static void capinc_tty_put_char(struct t
 {
 	struct capiminor *mp = (struct capiminor *)tty->driver_data;
 	struct sk_buff *skb;
+	unsigned long flags;
 
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_put_char(%u)\n", ch);
@@ -1105,10 +1128,12 @@ static void capinc_tty_put_char(struct t
 		return;
 	}
 
+	spin_lock_irqsave(&workaround_lock, flags);
 	skb = mp->ttyskb;
 	if (skb) {
 		if (skb_tailroom(skb) > 0) {
 			*(skb_put(skb, 1)) = ch;
+			spin_unlock_irqrestore(&workaround_lock, flags);
 			return;
 		}
 		mp->ttyskb = NULL;
@@ -1124,12 +1149,14 @@ static void capinc_tty_put_char(struct t
 	} else {
 		printk(KERN_ERR "capinc_put_char: char %u lost\n", ch);
 	}
+	spin_unlock_irqrestore(&workaround_lock, flags);
 }
 
 static void capinc_tty_flush_chars(struct tty_struct *tty)
 {
 	struct capiminor *mp = (struct capiminor *)tty->driver_data;
 	struct sk_buff *skb;
+	unsigned long flags;
 
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_tty_flush_chars\n");
@@ -1142,6 +1169,7 @@ static void capinc_tty_flush_chars(struc
 		return;
 	}
 
+	spin_lock_irqsave(&workaround_lock, flags);
 	skb = mp->ttyskb;
 	if (skb) {
 		mp->ttyskb = NULL;
@@ -1150,6 +1178,7 @@ static void capinc_tty_flush_chars(struc
 		(void)handle_minor_send(mp);
 	}
 	(void)handle_minor_recv(mp);
+	spin_unlock_irqrestore(&workaround_lock, flags);
 }
 
 static int capinc_tty_write_room(struct tty_struct *tty)
@@ -1220,12 +1249,15 @@ static void capinc_tty_throttle(struct t
 static void capinc_tty_unthrottle(struct tty_struct * tty)
 {
 	struct capiminor *mp = (struct capiminor *)tty->driver_data;
+	unsigned long flags;
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_tty_unthrottle\n");
 #endif
 	if (mp) {
+		spin_lock_irqsave(&workaround_lock, flags);
 		mp->ttyinstop = 0;
 		handle_minor_recv(mp);
+		spin_unlock_irqrestore(&workaround_lock, flags);
 	}
 }
 
@@ -1243,12 +1275,15 @@ static void capinc_tty_stop(struct tty_s
 static void capinc_tty_start(struct tty_struct *tty)
 {
 	struct capiminor *mp = (struct capiminor *)tty->driver_data;
+	unsigned long flags;
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_tty_start\n");
 #endif
 	if (mp) {
+		spin_lock_irqsave(&workaround_lock, flags);
 		mp->ttyoutstop = 0;
 		(void)handle_minor_send(mp);
+		spin_unlock_irqrestore(&workaround_lock, flags);
 	}
 }
 
_

Patches currently in -mm which might be from mb@bu3sch.de are

git-netdev-all.patch
workaround-capi-subsystem-locking-issue.patch
