From: akpm@linux-foundation.org
Subject: [to-be-updated] hpet-factor-timer-allocate-from-open.patch removed from -mm tree
Date: Sun, 28 Mar 2010 13:34:19 -0400
Message-ID: <201003282035.o2SKZNwO003478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140Ab0C1Ufj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Mar 2010 16:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maglyx@gmail.com, clemens@ladisch.de, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hpet: factor timer allocate from open
has been removed from the -mm tree.  Its filename was
     hpet-factor-timer-allocate-from-open.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>

The current implementation of the /dev/hpet driver couples opening the
device with allocating one of the (scarce) timers (aka comparators).  This
is a limitation in that the main counter may be valuable to applications
seeking a high-resolution timer who have no use for the interrupt
generating functionality of the comparators.

This patch alters the open semantics so that when the device is opened, no
timer is allocated.  Operations that depend on a timer being in context
implicitly attempt allocating a timer, to maintain backward compatibility.
 There is also an IOCTL (HPET_ALLOC_TIMER _IO) added so that the
allocation may be done explicitly.  (I prefer the explicit open then
allocate pattern but don't know how practical it would be to require all
existing code to be changed.)

Signed-off-by: Magnus Lynch <maglyx@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c  |   59 ++++++++++++++++++++++++++++++++++++-----
 include/linux/hpet.h |    1 
 2 files changed, 53 insertions(+), 7 deletions(-)

diff -puN drivers/char/hpet.c~hpet-factor-timer-allocate-from-open drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-factor-timer-allocate-from-open
+++ a/drivers/char/hpet.c
@@ -242,16 +242,40 @@ static void hpet_timer_set_irq(struct hp
 
 static int hpet_open(struct inode *inode, struct file *file)
 {
-	struct hpet_dev *devp;
 	struct hpets *hpetp;
-	int i;
 
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
+	hpetp = hpets;
+	/* starting with timer-neutral instance */
+	file->private_data = &hpetp->hp_dev[hpetp->hp_ntimer];
+
+	return 0;
+}
+
+static int hpet_alloc_timer(struct file *file)
+{
+	struct hpet_dev *devp;
+	struct hpets *hpetp;
+	int i;
+
+	/* once acquired, will remain */
+	devp = file->private_data;
+	if (devp->hd_timer)
+		return 0;
+
 	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
+	/* check for race acquiring */
+	devp = file->private_data;
+	if (devp->hd_timer) {
+		spin_unlock_irq(&hpet_lock);
+		unlock_kernel();
+		return 0;
+	}
+
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
 			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
@@ -382,6 +406,10 @@ static int hpet_fasync(int fd, struct fi
 {
 	struct hpet_dev *devp;
 
+	int r = hpet_alloc_timer(file);
+	if (r < 0)
+		return r;
+
 	devp = file->private_data;
 
 	if (fasync_helper(fd, file, on, &devp->hd_async_queue) >= 0)
@@ -399,6 +427,9 @@ static int hpet_release(struct inode *in
 	devp = file->private_data;
 	timer = devp->hd_timer;
 
+	if (!timer)
+		goto out;
+
 	spin_lock_irq(&hpet_lock);
 
 	writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
@@ -423,7 +454,7 @@ static int hpet_release(struct inode *in
 
 	if (irq)
 		free_irq(irq, devp);
-
+out:
 	file->private_data = NULL;
 	return 0;
 }
@@ -436,6 +467,10 @@ hpet_ioctl(struct inode *inode, struct f
 {
 	struct hpet_dev *devp;
 
+	int r = hpet_alloc_timer(file);
+	if (r < 0)
+		return r;
+
 	devp = file->private_data;
 	return hpet_ioctl_common(devp, cmd, arg, 0);
 }
@@ -568,6 +603,9 @@ hpet_ioctl_common(struct hpet_dev *devp,
 		break;
 	case HPET_IE_ON:
 		return hpet_ioctl_ieon(devp);
+	case HPET_ALLOC_TIMER:
+		/* nothing to do */
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -792,7 +830,11 @@ int hpet_alloc(struct hpet_data *hdp)
 		return 0;
 	}
 
-	siz = sizeof(struct hpets) + ((hdp->hd_nirqs - 1) *
+	/*
+	 * last hpet_dev will have null timer pointer, gives timer-neutral
+	 * representation of block
+	 */
+	siz = sizeof(struct hpets) + ((hdp->hd_nirqs) *
 				      sizeof(struct hpet_dev));
 
 	hpetp = kzalloc(siz, GFP_KERNEL);
@@ -858,13 +900,16 @@ int hpet_alloc(struct hpet_data *hdp)
 		writeq(mcfg, &hpet->hpet_config);
 	}
 
-	for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer; i++, devp++) {
+	for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer + 1;
+	     i++, devp++) {
 		struct hpet_timer __iomem *timer;
 
-		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
-
 		devp->hd_hpets = hpetp;
 		devp->hd_hpet = hpet;
+		if (i == hpetp->hp_ntimer)
+			continue;
+
+		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
 		devp->hd_timer = timer;
 
 		/*
diff -puN include/linux/hpet.h~hpet-factor-timer-allocate-from-open include/linux/hpet.h
--- a/include/linux/hpet.h~hpet-factor-timer-allocate-from-open
+++ a/include/linux/hpet.h
@@ -125,6 +125,7 @@ struct hpet_info {
 #define	HPET_EPI	_IO('h', 0x04)	/* enable periodic */
 #define	HPET_DPI	_IO('h', 0x05)	/* disable periodic */
 #define	HPET_IRQFREQ	_IOW('h', 0x6, unsigned long)	/* IRQFREQ usec */
+#define	HPET_ALLOC_TIMER _IO('h', 0x7)
 
 #define MAX_HPET_TBS	8		/* maximum hpet timer blocks */
 
_

Patches currently in -mm which might be from maglyx@gmail.com are

hpet-factor-timer-allocate-from-open.patch
hpet-factor-timer-allocate-from-open-fix.patch

