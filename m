From: akpm@linux-foundation.org
Subject: + hpet-remove-the-bkl.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:37:20 -0700
Message-ID: <200810161937.m9GJbKq7008422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbYJPTht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidjon@xenontk.org, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hpet: remove the BKL
has been added to the -mm tree.  Its filename is
     hpet-remove-the-bkl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: remove the BKL
From: David John <davidjon@xenontk.org>

Concurrent access is protected by the spin lock hpet_lock. The BKL
is not required.

Signed-off-by: David John <davidjon@xenontk.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/char/hpet.c~hpet-remove-the-bkl drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-remove-the-bkl
+++ a/drivers/char/hpet.c
@@ -252,7 +252,6 @@ static int hpet_open(struct inode *inode
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
-	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
@@ -266,7 +265,6 @@ static int hpet_open(struct inode *inode
 
 	if (!devp) {
 		spin_unlock_irq(&hpet_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -274,7 +272,6 @@ static int hpet_open(struct inode *inode
 	devp->hd_irqdata = 0;
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
-	unlock_kernel();
 
 	hpet_timer_set_irq(devp);
 
@@ -434,15 +431,12 @@ static int hpet_release(struct inode *in
 	return 0;
 }
 
-static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
+static long hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
 
-static int
-hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	   unsigned long arg)
+static long
+hpet_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct hpet_dev *devp;
-
-	devp = file->private_data;
+	struct hpet_dev *devp = file->private_data;
 	return hpet_ioctl_common(devp, cmd, arg, 0);
 }
 
@@ -549,13 +543,13 @@ static inline unsigned long hpet_time_di
 	return (unsigned long)m;
 }
 
-static int
+static long
 hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 {
 	struct hpet_timer __iomem *timer;
 	struct hpet __iomem *hpet;
 	struct hpets *hpetp;
-	int err;
+	long err;
 	unsigned long v;
 
 	switch (cmd) {
@@ -587,7 +581,9 @@ hpet_ioctl_common(struct hpet_dev *devp,
 			free_irq(devp->hd_irq, devp);
 			devp->hd_irq = 0;
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags ^= HPET_IE;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_INFO:
 		{
@@ -616,7 +612,9 @@ hpet_ioctl_common(struct hpet_dev *devp,
 			err = -ENXIO;
 			break;
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags |= HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_DPI:
 		v = readq(&timer->hpet_config);
@@ -630,7 +628,9 @@ hpet_ioctl_common(struct hpet_dev *devp,
 			v ^= Tn_TYPE_CNF_MASK;
 			writeq(v, &timer->hpet_config);
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags &= ~HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_IRQFREQ:
 		if (!kernel && (arg > hpet_max_freq) &&
@@ -655,7 +655,7 @@ static const struct file_operations hpet
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
_

Patches currently in -mm which might be from davidjon@xenontk.org are

origin.patch
hpet-remove-the-bkl.patch

