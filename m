From: akpm@linux-foundation.org
Subject: + aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:03:49 -0800
Message-ID: <200712220603.lBM63nAh020119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961AbXLVGDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:03:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: user can ask driver to forget previously detected devices
has been added to the -mm tree.  Its filename is
     aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: user can ask driver to forget previously detected devices
From: "Ed L. Cashin" <ecashin@coraid.com>

When an AoE device is detected, the kernel is informed, and a new block device
is created.  If the device is unused, the block device corresponding to remote
device that is no longer available may be removed from the system by telling
the aoe driver to "flush" its list of devices.

Without this patch, software like GPFS and LVM may attempt to read from AoE
devices that were discovered earlier but are no longer present, blocking until
the I/O attempt times out.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/aoe/mkdevs.sh |    2 
 Documentation/aoe/udev.txt  |    1 
 drivers/block/aoe/aoe.h     |    1 
 drivers/block/aoe/aoechr.c  |    5 +
 drivers/block/aoe/aoedev.c  |   87 ++++++++++++++++++++++++++--------
 5 files changed, 77 insertions(+), 19 deletions(-)

diff -puN Documentation/aoe/mkdevs.sh~aoe-user-can-ask-driver-to-forget-previously-detected-devices Documentation/aoe/mkdevs.sh
--- a/Documentation/aoe/mkdevs.sh~aoe-user-can-ask-driver-to-forget-previously-detected-devices
+++ a/Documentation/aoe/mkdevs.sh
@@ -29,6 +29,8 @@ rm -f $dir/interfaces
 mknod -m 0200 $dir/interfaces c $MAJOR 4
 rm -f $dir/revalidate
 mknod -m 0200 $dir/revalidate c $MAJOR 5
+rm -f $dir/flush
+mknod -m 0200 $dir/flush c $MAJOR 6
 
 export n_partitions
 mkshelf=`echo $0 | sed 's!mkdevs!mkshelf!'`
diff -puN Documentation/aoe/udev.txt~aoe-user-can-ask-driver-to-forget-previously-detected-devices Documentation/aoe/udev.txt
--- a/Documentation/aoe/udev.txt~aoe-user-can-ask-driver-to-forget-previously-detected-devices
+++ a/Documentation/aoe/udev.txt
@@ -20,6 +20,7 @@ SUBSYSTEM=="aoe", KERNEL=="discover",	NA
 SUBSYSTEM=="aoe", KERNEL=="err",	NAME="etherd/%k", GROUP="disk", MODE="0440"
 SUBSYSTEM=="aoe", KERNEL=="interfaces",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 SUBSYSTEM=="aoe", KERNEL=="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="flush",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 
 # aoe block devices     
 KERNEL=="etherd*",       NAME="%k", GROUP="disk"
diff -puN drivers/block/aoe/aoe.h~aoe-user-can-ask-driver-to-forget-previously-detected-devices drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-user-can-ask-driver-to-forget-previously-detected-devices
+++ a/drivers/block/aoe/aoe.h
@@ -191,6 +191,7 @@ struct aoedev *aoedev_by_aoeaddr(int maj
 struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
 int aoedev_isbusy(struct aoedev *d);
+int aoedev_flush(const char __user *str, size_t size);
 
 int aoenet_init(void);
 void aoenet_exit(void);
diff -puN drivers/block/aoe/aoechr.c~aoe-user-can-ask-driver-to-forget-previously-detected-devices drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-user-can-ask-driver-to-forget-previously-detected-devices
+++ a/drivers/block/aoe/aoechr.c
@@ -15,6 +15,7 @@ enum {
 	MINOR_DISCOVER,
 	MINOR_INTERFACES,
 	MINOR_REVALIDATE,
+	MINOR_FLUSH,
 	MSGSZ = 2048,
 	NMSG = 100,		/* message backlog to retain */
 };
@@ -43,6 +44,7 @@ static struct aoe_chardev chardevs[] = {
 	{ MINOR_DISCOVER, "discover" },
 	{ MINOR_INTERFACES, "interfaces" },
 	{ MINOR_REVALIDATE, "revalidate" },
+	{ MINOR_FLUSH, "flush" },
 };
 
 static int
@@ -158,6 +160,9 @@ aoechr_write(struct file *filp, const ch
 		break;
 	case MINOR_REVALIDATE:
 		ret = revalidate(buf, cnt);
+		break;
+	case MINOR_FLUSH:
+		ret = aoedev_flush(buf, cnt);
 	}
 	if (ret == 0)
 		ret = cnt;
diff -puN drivers/block/aoe/aoedev.c~aoe-user-can-ask-driver-to-forget-previously-detected-devices drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-user-can-ask-driver-to-forget-previously-detected-devices
+++ a/drivers/block/aoe/aoedev.c
@@ -9,6 +9,10 @@
 #include <linux/netdevice.h>
 #include "aoe.h"
 
+static void dummy_timer(ulong);
+static void aoedev_freedev(struct aoedev *);
+static void freetgt(struct aoetgt *t);
+
 static struct aoedev *devlist;
 static spinlock_t devlist_lock;
 
@@ -108,6 +112,70 @@ aoedev_downdev(struct aoedev *d)
 	d->flags &= ~DEVFL_UP;
 }
 
+static void
+aoedev_freedev(struct aoedev *d)
+{
+	struct aoetgt **t, **e;
+
+	if (d->gd) {
+		aoedisk_rm_sysfs(d);
+		del_gendisk(d->gd);
+		put_disk(d->gd);
+	}
+	t = d->targets;
+	e = t + NTARGETS;
+	for (; t < e && *t; t++)
+		freetgt(*t);
+	if (d->bufpool)
+		mempool_destroy(d->bufpool);
+	kfree(d);
+}
+
+int
+aoedev_flush(const char __user *str, size_t cnt)
+{
+	ulong flags;
+	struct aoedev *d, **dd;
+	struct aoedev *rmd = NULL;
+	char buf[16];
+	int all = 0;
+
+	if (cnt >= 3) {
+		if (cnt > sizeof buf)
+			cnt = sizeof buf;
+		if (copy_from_user(buf, str, cnt))
+			return -EFAULT;
+		all = !strncmp(buf, "all", 3);
+	}
+
+	flush_scheduled_work();
+	spin_lock_irqsave(&devlist_lock, flags);
+	dd = &devlist;
+	while ((d = *dd)) {
+		spin_lock(&d->lock);
+		if ((!all && (d->flags & DEVFL_UP))
+		|| (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
+		|| d->nopen) {
+			spin_unlock(&d->lock);
+			dd = &d->next;
+			continue;
+		}
+		*dd = d->next;
+		aoedev_downdev(d);
+		d->flags |= DEVFL_TKILL;
+		spin_unlock(&d->lock);
+		d->next = rmd;
+		rmd = d;
+	}
+	spin_unlock_irqrestore(&devlist_lock, flags);
+	while ((d = rmd)) {
+		rmd = d->next;
+		del_timer_sync(&d->timer);
+		aoedev_freedev(d);	/* must be able to sleep */
+	}
+	return 0;
+}
+
 /* find it or malloc it */
 struct aoedev *
 aoedev_by_sysminor_m(ulong sysminor)
@@ -161,25 +229,6 @@ freetgt(struct aoetgt *t)
 	kfree(t);
 }
 
-static void
-aoedev_freedev(struct aoedev *d)
-{
-	struct aoetgt **t, **e;
-
-	if (d->gd) {
-		aoedisk_rm_sysfs(d);
-		del_gendisk(d->gd);
-		put_disk(d->gd);
-	}
-	t = d->targets;
-	e = t + NTARGETS;
-	for (; t < e && *t; t++)
-		freetgt(*t);
-	if (d->bufpool)
-		mempool_destroy(d->bufpool);
-	kfree(d);
-}
-
 void
 aoedev_exit(void)
 {
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-bring-driver-version-number-to-47.patch
aoe-handle-multiple-network-paths-to-aoe-device.patch
aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
aoe-clean-up-udev-configuration-example.patch
aoe-eliminate-goto-and-improve-readability.patch
aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
aoe-only-install-new-aoe-device-once.patch
aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
aoe-the-aoeminor-doesnt-need-a-long-format.patch
aoe-make-error-messages-more-specific.patch
aoe-update-copyright-date.patch
aoe-statically-initialise-devlist_lock.patch
