From: akpm@linux-foundation.org
Subject: - restore-rogue-readahead-printk.patch removed from -mm tree
Date: Fri, 06 Jul 2007 15:46:13 -0700
Message-ID: <200707062246.l66MkD6U024932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbXGFWr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 18:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@muc.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     restore rogue readahead printk
has been removed from the -mm tree.  Its filename was
     restore-rogue-readahead-printk.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: restore rogue readahead printk
From: Andrew Morton <akpm@osdl.org>

We're getting unexplained EIOs out of NFS - restore this warning so it doesn't
get forgotten about.

Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/filemap.c~restore-rogue-readahead-printk mm/filemap.c
--- a/mm/filemap.c~restore-rogue-readahead-printk
+++ a/mm/filemap.c
@@ -831,10 +831,17 @@ EXPORT_SYMBOL(grab_cache_page_nowait);
 static void shrink_readahead_size_eio(struct file *filp,
 					struct file_ra_state *ra)
 {
+	static int count;
+
 	if (!ra->ra_pages)
 		return;
 
 	ra->ra_pages /= 4;
+	if (count > 5)
+		return;
+	count++;
+	printk(KERN_WARNING "Reducing readahead size to %luK\n",
+		ra->ra_pages << (PAGE_CACHE_SHIFT - 10));
 }
 
 /**
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-md-accel.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
ioat-warning-fix.patch
git-ipwireless_cs.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
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
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
