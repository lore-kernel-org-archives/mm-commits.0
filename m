From: akpm@linux-foundation.org
Subject: - libata-use-flush_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:15 -0700
Message-ID: <200705092151.l49LpFDu002863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758712AbXEIVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, htejun@gmail.com, jeff@garzik.org, macro@linux-mips.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     libata: use flush_work()
has been removed from the -mm tree.  Its filename was
     libata-use-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: use flush_work()
From: Andrew Morton <akpm@osdl.org>

(akpm: bypassed maintainers, sorry.  There are other patches which depend on
this)

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-use-flush_work drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-use-flush_work
+++ a/drivers/ata/libata-core.c
@@ -1316,7 +1316,7 @@ void ata_port_flush_task(struct ata_port
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
-	flush_workqueue(ata_wq);
+	flush_work(ata_wq, &ap->port_task.work); /* akpm: seems unneeded */
 
 	/*
 	 * At this point, if a task is running, it's guaranteed to see
@@ -1327,7 +1327,7 @@ void ata_port_flush_task(struct ata_port
 		if (ata_msg_ctl(ap))
 			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
 					__FUNCTION__);
-		flush_workqueue(ata_wq);
+		flush_work(ata_wq, &ap->port_task.work);
 	}
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -6475,9 +6475,9 @@ void ata_port_detach(struct ata_port *ap
 	/* Flush hotplug task.  The sequence is similar to
 	 * ata_port_flush_task().
 	 */
-	flush_workqueue(ata_aux_wq);
+	flush_work(ata_aux_wq, &ap->hotplug_task.work); /* akpm: why? */
 	cancel_delayed_work(&ap->hotplug_task);
-	flush_workqueue(ata_aux_wq);
+	flush_work(ata_aux_wq, &ap->hotplug_task.work);
 
  skip_eh:
 	/* remove the associated SCSI host */
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-ieee1394.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
