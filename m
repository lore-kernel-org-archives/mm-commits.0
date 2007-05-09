From: akpm@linux-foundation.org
Subject: - phy-use-flush_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:18 -0700
Message-ID: <200705092151.l49LpIJT002866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758850AbXEIWJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, jeff@garzik.org, macro@linux-mips.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     phy: use flush_work_keventd()
has been removed from the -mm tree.  Its filename was
     phy-use-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: phy: use flush_work_keventd()
From: Andrew Morton <akpm@osdl.org>

(akpm: bypassed maintainers, sorry.  There are other patches which depend on
this)

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/phy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/phy/phy.c~phy-use-flush_work drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~phy-use-flush_work
+++ a/drivers/net/phy/phy.c
@@ -662,10 +662,10 @@ int phy_stop_interrupts(struct phy_devic
 		phy_error(phydev);
 
 	/*
-	 * Finish any pending work; we might have been scheduled
-	 * to be called from keventd ourselves, though.
+	 * Finish any pending work; we might have been scheduled to be called
+	 * from keventd ourselves, but flush_work_keventd() handles that.
 	 */
-	run_scheduled_work(&phydev->phy_queue);
+	flush_work_keventd(&phydev->phy_queue);
 
 	free_irq(phydev->irq, phydev);
 
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
