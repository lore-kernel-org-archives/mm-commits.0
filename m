From: akpm@linux-foundation.org
Subject: [folded] linuxpps-core-support-v2.patch removed from -mm tree
Date: Thu, 09 Apr 2009 09:37:09 -0700
Message-ID: <200904091637.n39Gb9I8007894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936426AbZDIQn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 12:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, hch@infradead.org, kay.sievers@vrfy.org, mtk.manpages@googlemail.com, randy.dunlap@oracle.com, zippel


The patch titled
     LinuxPPS core support (v2)
has been removed from the -mm tree.  Its filename was
     linuxpps-core-support-v2.patch

This patch was dropped because it was folded into linuxpps-core-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: LinuxPPS core support (v2)
From: Rodolfo Giometti <giometti@linux.it>

* fix race during PPS source registration.

* PPS_CHECK removed.

* not needed check in pps_exit() removed.

* Printing stuff on exit removed.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/ioctl-number.txt |    2 -
 drivers/pps/kapi.c                   |   32 +++++++++++++++++--------
 drivers/pps/pps.c                    |   12 ---------
 include/linux/pps.h                  |    3 --
 4 files changed, 25 insertions(+), 24 deletions(-)

diff -puN Documentation/ioctl/ioctl-number.txt~linuxpps-core-support-v2 Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~linuxpps-core-support-v2
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -151,7 +151,7 @@ Code	Seq#	Include File		Comments
 'p'	40-7F	linux/nvram.h
 'p'	80-9F				user-space parport
 					<mailto:tim@cyberelk.net>
-'p'	a0-a4	linux/pps.h		LinuxPPS
+'p'	a1-a4	linux/pps.h		LinuxPPS
 					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
 'q'	80-FF				Internet PhoneJACK, Internet LineJACK
diff -puN drivers/pps/kapi.c~linuxpps-core-support-v2 drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~linuxpps-core-support-v2
+++ a/drivers/pps/kapi.c
@@ -158,6 +158,17 @@ int pps_register_source(struct pps_sourc
 		goto pps_register_source_exit;
 	}
 
+	/* These initializations must be done before calling idr_get_new()
+	 * in order to avoid reces into pps_event().
+	 */
+	pps->params.api_version = PPS_API_VERS;
+	pps->params.mode = default_params;
+	pps->info = *info;
+
+	init_waitqueue_head(&pps->queue);
+	spin_lock_init(&pps->lock);
+	atomic_set(&pps->usage, 1);
+
 	/* Get new ID for the new PPS source */
 	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
 		err = -ENOMEM;
@@ -165,28 +176,29 @@ int pps_register_source(struct pps_sourc
 	}
 
 	spin_lock_irq(&pps_idr_lock);
-	err = idr_get_new(&pps_idr, pps, &id);
-	spin_unlock_irq(&pps_idr_lock);
 
-	if (err < 0)
+	/* Now really allocate the PPS source.
+	 * After idr_get_new() calling the new source will be freely available
+	 * into the kernel.
+	 */
+	err = idr_get_new(&pps_idr, pps, &id);
+	if (err < 0) {
+		spin_unlock_irq(&pps_idr_lock);
 		goto kfree_pps;
+	}
 
 	id = id & MAX_ID_MASK;
 	if (id >= PPS_MAX_SOURCES) {
+		spin_unlock_irq(&pps_idr_lock);
+
 		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
 					info->name);
 		err = -EBUSY;
 		goto free_idr;
 	}
-
 	pps->id = id;
-	pps->params.api_version = PPS_API_VERS;
-	pps->params.mode = default_params;
-	pps->info = *info;
 
-	init_waitqueue_head(&pps->queue);
-	spin_lock_init(&pps->lock);
-	atomic_set(&pps->usage, 1);
+	spin_unlock_irq(&pps_idr_lock);
 
 	/* Create the char device */
 	err = pps_register_cdev(pps);
diff -puN drivers/pps/pps.c~linuxpps-core-support-v2 drivers/pps/pps.c
--- a/drivers/pps/pps.c~linuxpps-core-support-v2
+++ a/drivers/pps/pps.c
@@ -68,12 +68,6 @@ static long pps_cdev_ioctl(struct file *
 	int err;
 
 	switch (cmd) {
-	case PPS_CHECK:
-
-		/* This does nothing but signal we are a PPS source... */
-
-		return 0;
-
 	case PPS_GETPARAMS:
 		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
 
@@ -278,11 +272,7 @@ void pps_unregister_cdev(struct pps_devi
 static void __exit pps_exit(void)
 {
 	class_destroy(pps_class);
-
-	if (pps_devt)
-		unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
-
-	pr_info("LinuxPPS API ver. %d removed\n", PPS_API_VERS);
+	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
 }
 
 static int __init pps_init(void)
diff -puN include/linux/pps.h~linuxpps-core-support-v2 include/linux/pps.h
--- a/include/linux/pps.h~linuxpps-core-support-v2
+++ a/include/linux/pps.h
@@ -23,7 +23,7 @@
 #ifndef _PPS_H_
 #define _PPS_H_
 
-#define PPS_VERSION		"5.3.4"
+#define PPS_VERSION		"5.3.5"
 #define PPS_MAX_SOURCES		16		/* should be enough... */
 
 /* Implementation note: the logical states ``assert'' and ``clear''
@@ -115,7 +115,6 @@ struct pps_fdata {
 
 #include <linux/ioctl.h>
 
-#define PPS_CHECK		_IO('p', 0xa0)
 #define PPS_GETPARAMS		_IOR('p', 0xa1, struct pps_kparams *)
 #define PPS_SETPARAMS		_IOW('p', 0xa2, struct pps_kparams *)
 #define PPS_GETCAP		_IOR('p', 0xa3, int *)
_

Patches currently in -mm which might be from giometti@linux.it are

linuxpps-core-support.patch
linuxpps-core-support-v2.patch

