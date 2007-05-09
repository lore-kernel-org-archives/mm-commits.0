From: akpm@linux-foundation.org
Subject: - e1000-use-flush_keventd_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:12 -0700
Message-ID: <200705092151.l49LpCTE002860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758572AbXEIVwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, auke-jan.h.kok@intel.com, davem@davemloft.net, dhowells@redhat.com, jeff@garzik.org, macro@linux-mips.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     e1000: use flush_work_keventd()
has been removed from the -mm tree.  Its filename was
     e1000-use-flush_keventd_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: e1000: use flush_work_keventd()
From: Andrew Morton <akpm@osdl.org>

Switch e1000 over to flush_work_keventd().  This probably fixes a netdev-close
versus linkwatch rtnl_lock() deadlock which nobody knew about.

(akpm: bypassed maintainers, sorry.  There are other patches which depend on
this)

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-use-flush_keventd_work drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-use-flush_keventd_work
+++ a/drivers/net/e1000/e1000_main.c
@@ -1214,7 +1214,7 @@ e1000_remove(struct pci_dev *pdev)
 	int i;
 #endif
 
-	flush_scheduled_work();
+	flush_work_keventd(&adapter->reset_task);
 
 	e1000_release_manageability(adapter);
 
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
