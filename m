From: akpm@linux-foundation.org
Subject: - ntfs-use-zero_user_page-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 02:16:12 -0700
Message-ID: <200705090916.l499GCsk018922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353AbXEIJQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aia21@cantab.net, nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ntfs-use-zero_user_page-fix
has been removed from the -mm tree.  Its filename was
     ntfs-use-zero_user_page-fix.patch

This patch was dropped because it was folded into ntfs-use-zero_user_page.patch

------------------------------------------------------
Subject: ntfs-use-zero_user_page-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/aops.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ntfs/aops.c~ntfs-use-zero_user_page-fix fs/ntfs/aops.c
--- a/fs/ntfs/aops.c~ntfs-use-zero_user_page-fix
+++ a/fs/ntfs/aops.c
@@ -86,19 +86,15 @@ static void ntfs_end_buffer_async_read(s
 		}
 		/* Check for the current buffer head overflowing. */
 		if (unlikely(file_ofs + bh->b_size > init_size)) {
-			u8 *kaddr;
 			int ofs;
 
 			ofs = 0;
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
 			local_irq_save(flags);
-			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
-			memset(kaddr + bh_offset(bh) + ofs, 0,
-					bh->b_size - ofs);
-			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+			zero_user_page(page, bh_offset(bh) + ofs,
+					 bh->b_size - ofs, KM_BIO_SRC_IRQ);
 			local_irq_restore(flags);
-			flush_dcache_page(page);
 		}
 	} else {
 		clear_buffer_uptodate(bh);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
ntfs-use-zero_user_page.patch
ntfs-use-zero_user_page-fix.patch
rename-thread_info-to-stack.patch
