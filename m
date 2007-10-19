From: akpm@linux-foundation.org
Subject: - videopix-frame-grabber-convert-device_lock_sem-to-mutex.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:14 -0700
Message-ID: <200710190340.l9J3eELD012691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965577AbXJSDkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Videopix Frame Grabber: convert device_lock_sem to mutex
has been removed from the -mm tree.  Its filename was
     videopix-frame-grabber-convert-device_lock_sem-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Videopix Frame Grabber: convert device_lock_sem to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Videopix Frame Grabber: Convert the semaphore device_lock_sem to the mutex
API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/vfc.h     |    2 +-
 drivers/sbus/char/vfc_dev.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/sbus/char/vfc.h~videopix-frame-grabber-convert-device_lock_sem-to-mutex drivers/sbus/char/vfc.h
--- a/drivers/sbus/char/vfc.h~videopix-frame-grabber-convert-device_lock_sem-to-mutex
+++ a/drivers/sbus/char/vfc.h
@@ -126,7 +126,7 @@ struct vfc_dev {
 	volatile struct vfc_regs __iomem *regs;
 	struct vfc_regs *phys_regs;
 	unsigned int control_reg;
-	struct semaphore device_lock_sem;
+	struct mutex device_lock_mtx;
 	int instance;
 	int busy;
 	unsigned long which_io;
diff -puN drivers/sbus/char/vfc_dev.c~videopix-frame-grabber-convert-device_lock_sem-to-mutex drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~videopix-frame-grabber-convert-device_lock_sem-to-mutex
+++ a/drivers/sbus/char/vfc_dev.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/mm.h>
 
 #include <asm/openprom.h>
@@ -54,12 +55,12 @@ static unsigned char saa9051_init_array[
 
 void vfc_lock_device(struct vfc_dev *dev)
 {
-	down(&dev->device_lock_sem);
+	mutex_lock(&dev->device_lock_mtx);
 }
 
 void vfc_unlock_device(struct vfc_dev *dev)
 {
-	up(&dev->device_lock_sem);
+	mutex_unlock(&dev->device_lock_mtx);
 }
 
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ftdi-elan-driver-convert-ftdi-u132_lock-to-mutex.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
