From: akpm@linux-foundation.org
Subject: - aio-is-unlikely.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:27 -0700
Message-ID: <200705092153.l49LrRmE003084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759286AbXEIVyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcrl@kvack.org, drepper@redhat.com, hch@lst.de, mingo@elte.hu, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio is unlikely
has been removed from the -mm tree.  Its filename was
     aio-is-unlikely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aio is unlikely
From: Andrew Morton <akpm@osdl.org>

Stick an unlikely() around is_aio(): I assert that most IO is synchronous.

Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/aio.h~aio-is-unlikely include/linux/aio.h
--- a/include/linux/aio.h~aio-is-unlikely
+++ a/include/linux/aio.h
@@ -226,7 +226,8 @@ int FASTCALL(io_submit_one(struct kioctx
 		__put_ioctx(kioctx);					\
 } while (0)
 
-#define in_aio() !is_sync_wait(current->io_wait)
+#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
+
 /* may be used for debugging */
 #define warn_if_async()							\
 do {									\
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
