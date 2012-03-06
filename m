From: akpm@linux-foundation.org
Subject: [to-be-updated] hpet-factor-timer-allocate-from-open.patch removed from -mm tree
Date: Tue, 06 Mar 2012 10:39:24 -0800
Message-ID: <20120306183926.09D3CA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35619 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947Ab2CFSj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 13:39:29 -0500
Received: by vcbfk26 with SMTP id fk26so669148vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 10:39:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maglyx@gmail.com, arnd@arndb.de, clemens@ladisch.de, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hpet: factor timer allocate from open
has been removed from the -mm tree.  Its filename was
     hpet-factor-timer-allocate-from-open.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Magnus Lynch <maglyx@gmail.com>
Subject: hpet: factor timer allocate from open

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

/dev/hpet is accessed via mmap().  This is the only interface of /dev/hpet
that is actually used in practice.

[akpm@linux-foundation.org: coding-style tweaks]
[arnd@arndb.de: fix build]
Signed-off-by: Magnus Lynch <maglyx@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c  |   56 +++++++++++++++++++++++++++++++++++------
 include/linux/hpet.h |    1 
 2 files changed, 50 insertions(+), 7 deletions(-)

diff -puN drivers/char/hpet.c~hpet-factor-timer-allocate-from-open drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-factor-timer-allocate-from-open
+++ a/drivers/char/hpet.c
@@ -263,16 +263,40 @@ static void hpet_timer_set_irq(struct hp
 
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
 	mutex_lock(&hpet_mutex);
 	spin_lock_irq(&hpet_lock);
 
+	/* check for race acquiring */
+	devp = file->private_data;
+	if (devp->hd_timer) {
+		spin_unlock_irq(&hpet_lock);
+		mutex_unlock(&hpet_mutex);
+		return 0;
+	}
+
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
 			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
@@ -402,6 +426,11 @@ static int hpet_mmap(struct file *file, 
 static int hpet_fasync(int fd, struct file *file, int on)
 {
 	struct hpet_dev *devp;
+	int r;
+
+	r = hpet_alloc_timer(file);
+	if (r < 0)
+		return r;
 
 	devp = file->private_data;
 
@@ -420,6 +449,9 @@ static int hpet_release(struct inode *in
 	devp = file->private_data;
 	timer = devp->hd_timer;
 
+	if (!timer)
+		goto out;
+
 	spin_lock_irq(&hpet_lock);
 
 	writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
@@ -444,7 +476,7 @@ static int hpet_release(struct inode *in
 
 	if (irq)
 		free_irq(irq, devp);
-
+out:
 	file->private_data = NULL;
 	return 0;
 }
@@ -593,6 +625,9 @@ hpet_ioctl_common(struct hpet_dev *devp,
 		break;
 	case HPET_IE_ON:
 		return hpet_ioctl_ieon(devp);
+	case HPET_ALLOC_TIMER:
+		/* nothing to do */
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -859,7 +894,11 @@ int hpet_alloc(struct hpet_data *hdp)
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
@@ -925,13 +964,16 @@ int hpet_alloc(struct hpet_data *hdp)
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


