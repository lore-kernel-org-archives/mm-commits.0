From: akpm@linux-foundation.org
Subject: - tg3-use-flush_keventd_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:09 -0700
Message-ID: <200705092151.l49Lp9GU002857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758629AbXEIVvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, dhowells@redhat.com, jeff@garzik.org, macro@linux-mips.org, mchan@broadcom.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tg3: use flush_work_keventd()
has been removed from the -mm tree.  Its filename was
     tg3-use-flush_keventd_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tg3: use flush_work_keventd()
From: Andrew Morton <akpm@osdl.org>

Convert tg3 over to flush_work_keventd().  Remove nasty now-unneeded deadlock
avoidance logic.

(akpm: bypassed maintainers, sorry.  There are other patches which depend on
this)

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tg3.c |   11 +----------
 drivers/net/tg3.h |    2 +-
 2 files changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/net/tg3.c~tg3-use-flush_keventd_work drivers/net/tg3.c
--- a/drivers/net/tg3.c~tg3-use-flush_keventd_work
+++ a/drivers/net/tg3.c
@@ -3716,10 +3716,8 @@ static void tg3_reset_task(struct work_s
 	unsigned int restart_timer;
 
 	tg3_full_lock(tp, 0);
-	tp->tg3_flags |= TG3_FLAG_IN_RESET_TASK;
 
 	if (!netif_running(tp->dev)) {
-		tp->tg3_flags &= ~TG3_FLAG_IN_RESET_TASK;
 		tg3_full_unlock(tp);
 		return;
 	}
@@ -3750,8 +3748,6 @@ static void tg3_reset_task(struct work_s
 		mod_timer(&tp->timer, jiffies + 1);
 
 out:
-	tp->tg3_flags &= ~TG3_FLAG_IN_RESET_TASK;
-
 	tg3_full_unlock(tp);
 }
 
@@ -7390,12 +7386,7 @@ static int tg3_close(struct net_device *
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	/* Calling flush_scheduled_work() may deadlock because
-	 * linkwatch_event() may be on the workqueue and it will try to get
-	 * the rtnl_lock which we are holding.
-	 */
-	while (tp->tg3_flags & TG3_FLAG_IN_RESET_TASK)
-		msleep(1);
+	flush_work_keventd(&tp->reset_task);
 
 	netif_stop_queue(dev);
 
diff -puN drivers/net/tg3.h~tg3-use-flush_keventd_work drivers/net/tg3.h
--- a/drivers/net/tg3.h~tg3-use-flush_keventd_work
+++ a/drivers/net/tg3.h
@@ -2228,7 +2228,7 @@ struct tg3 {
 #define TG3_FLAG_JUMBO_RING_ENABLE	0x00800000
 #define TG3_FLAG_10_100_ONLY		0x01000000
 #define TG3_FLAG_PAUSE_AUTONEG		0x02000000
-#define TG3_FLAG_IN_RESET_TASK		0x04000000
+
 #define TG3_FLAG_40BIT_DMA_BUG		0x08000000
 #define TG3_FLAG_BROKEN_CHECKSUMS	0x10000000
 #define TG3_FLAG_SUPPORT_MSI		0x20000000
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
