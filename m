From: akpm@linux-foundation.org
Subject: - aio-use-flush_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:03 -0700
Message-ID: <200705092151.l49Lp3s1002850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbXEIVwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcrl@kvack.org, dhowells@redhat.com, macro@linux-mips.org, oleg@tv-sign.ru, torvalds@linux-foundation.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: use flush_work()
has been removed from the -mm tree.  Its filename was
     aio-use-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aio: use flush_work()
From: Andrew Morton <akpm@osdl.org>

Migrate AIO over to use flush_work().

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Linus Torvalds <torvalds@osdl.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/aio.c~aio-use-flush_work fs/aio.c
--- a/fs/aio.c~aio-use-flush_work
+++ a/fs/aio.c
@@ -346,10 +346,9 @@ void fastcall exit_aio(struct mm_struct 
 
 		wait_for_all_aios(ctx);
 		/*
-		 * this is an overkill, but ensures we don't leave
-		 * the ctx on the aio_wq
+		 * Ensure we don't leave the ctx on the aio_wq
 		 */
-		flush_workqueue(aio_wq);
+		flush_work(aio_wq, &ctx->wq.work);
 
 		if (1 != atomic_read(&ctx->users))
 			printk(KERN_DEBUG
@@ -372,7 +371,7 @@ void fastcall __put_ioctx(struct kioctx 
 	BUG_ON(ctx->reqs_active);
 
 	cancel_delayed_work(&ctx->wq);
-	flush_workqueue(aio_wq);
+	flush_work(aio_wq, &ctx->wq.work);
 	aio_free_ring(ctx);
 	mmdrop(ctx->mm);
 	ctx->mm = NULL;
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
