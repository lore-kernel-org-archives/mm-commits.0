From: akpm@linux-foundation.org
Subject: - block_write_full_page-handle-enospc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:53 -0700
Message-ID: <200705090243.l492hrKw008521@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970037AbXEICnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guichaz@yahoo.fr, mm-commits@vger.kernel.org


The patch titled
     block_write_full_page(): report ENOSPC
has been removed from the -mm tree.  Its filename was
     block_write_full_page-handle-enospc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: block_write_full_page(): report ENOSPC
From: Andrew Morton <akpm@osdl.org>

block_write_full_page() forgot to propagate ENPSOC into the address_space.

Cc: Guillaume Chazarain <guichaz@yahoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/buffer.c~block_write_full_page-handle-enospc fs/buffer.c
--- a/fs/buffer.c~block_write_full_page-handle-enospc
+++ a/fs/buffer.c
@@ -1727,6 +1727,7 @@ recover:
 	} while ((bh = bh->b_this_page) != head);
 	SetPageError(page);
 	BUG_ON(PageWriteback(page));
+	mapping_set_error(page->mapping, err);
 	set_page_writeback(page);
 	do {
 		struct buffer_head *next = bh->b_this_page;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-ia64.patch
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
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
aio-is-unlikely.patch
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
