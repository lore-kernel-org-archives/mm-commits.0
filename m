From: akpm@linux-foundation.org
Subject: + hpilo-add-poll-f_op.patch added to -mm tree
Date: Tue, 18 Aug 2009 14:30:14 -0700
Message-ID: <200908182130.n7ILUEb9018279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbZHRVaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 17:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.altobelli@hp.com, greg@kroah.com


The patch titled
     hpilo: add poll f_op
has been added to the -mm tree.  Its filename is
     hpilo-add-poll-f_op.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpilo: add poll f_op
From: David Altobelli <david.altobelli@hp.com>

Add poll handler to hpilo, to allow applications a low overhead method
of waiting for data.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |   42 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff -puN drivers/misc/hpilo.c~hpilo-add-poll-f_op drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-add-poll-f_op
+++ a/drivers/misc/hpilo.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/wait.h>
+#include <linux/poll.h>
 #include "hpilo.h"
 
 static struct class *ilo_class;
@@ -102,6 +103,22 @@ static int fifo_dequeue(struct ilo_hwinf
 	return ret;
 }
 
+static int fifo_check_recv(struct ilo_hwinfo *hw, char *fifobar)
+{
+	struct fifo *fifo_q = FIFOBARTOHANDLE(fifobar);
+	unsigned long flags;
+	int ret = 0;
+	u64 c;
+
+	spin_lock_irqsave(&hw->fifo_lock, flags);
+	c = fifo_q->fifobar[fifo_q->head & fifo_q->imask];
+	if (c & ENTRY_MASK_C)
+		ret = 1;
+	spin_unlock_irqrestore(&hw->fifo_lock, flags);
+
+	return ret;
+}
+
 static int ilo_pkt_enqueue(struct ilo_hwinfo *hw, struct ccb *ccb,
 			   int dir, int id, int len)
 {
@@ -146,6 +163,13 @@ static int ilo_pkt_dequeue(struct ilo_hw
 	return ret;
 }
 
+static int ilo_pkt_recv(struct ilo_hwinfo *hw, struct ccb *ccb)
+{
+	char *fifobar = ccb->ccb_u3.recv_fifobar;
+
+	return fifo_check_recv(hw, fifobar);
+}
+
 static inline void doorbell_set(struct ccb *ccb)
 {
 	iowrite8(1, ccb->ccb_u5.db_base);
@@ -486,6 +510,21 @@ static ssize_t ilo_write(struct file *fp
 	return err ? -EFAULT : len;
 }
 
+static unsigned int ilo_poll(struct file *fp, poll_table *wait)
+{
+	struct ccb_data *data = fp->private_data;
+	struct ccb *driver_ccb = &data->driver_ccb;
+
+	poll_wait(fp, &data->ccb_waitq, wait);
+
+	if (is_channel_reset(driver_ccb))
+		return POLLERR;
+	else if (ilo_pkt_recv(data->ilo_hw, driver_ccb))
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
 static int ilo_close(struct inode *ip, struct file *fp)
 {
 	int slot;
@@ -595,6 +634,7 @@ static const struct file_operations ilo_
 	.owner		= THIS_MODULE,
 	.read		= ilo_read,
 	.write		= ilo_write,
+	.poll		= ilo_poll,
 	.open 		= ilo_open,
 	.release 	= ilo_close,
 };
@@ -835,7 +875,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("1.1");
+MODULE_VERSION("1.2");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
_

Patches currently in -mm which might be from david.altobelli@hp.com are

hpilo-staging-for-interrupt-handling.patch
hpilo-add-interrupt-handler.patch
hpilo-add-poll-f_op.patch

