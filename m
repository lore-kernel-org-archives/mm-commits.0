From: akpm@linux-foundation.org
Subject: + revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:37 -0700
Message-ID: <200705292119.l4TLJbwe011693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbXE2VTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, npiggin@suse.de


The patch titled
     Revert 6527c2bdf1f833cc18e8f42bd97973d583e4aa83
has been added to the -mm tree.  Its filename is
     revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Revert 6527c2bdf1f833cc18e8f42bd97973d583e4aa83
From: Andrew Morton <akpm@osdl.org>

This patch fixed the following bug:

  When prefaulting in the pages in generic_file_buffered_write(), we only
  faulted in the pages for the firts segment of the iovec.  If the second of
  successive segment described a mmapping of the page into which we're
  write()ing, and that page is not up-to-date, the fault handler tries to lock
  the already-locked page (to bring it up to date) and deadlocks.

  An exploit for this bug is in writev-deadlock-demo.c, in
  http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz.

  (These demos assume blocksize < PAGE_CACHE_SIZE).

The problem with this fix is that it takes the kernel back to doing a single
prepare_write()/commit_write() per iovec segment.  So in the worst case we'll
run prepare_write+commit_write 1024 times where we previously would have run
it once. The other problem with the fix is that it fix all the locking problems.

<insert numbers obtained via ext3-tools's writev-speed.c here>

And apparently this change killed NFS overwrite performance, because, I
suppose, it talks to the server for each prepare_write+commit_write.

So just back that patch out - we'll be fixing the deadlock by other means.

Nick says: also it only ever actually papered over the bug, because after
faulting in the pages, they might be unmapped or reclaimed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff -puN mm/filemap.c~revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83 mm/filemap.c
--- a/mm/filemap.c~revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83
+++ a/mm/filemap.c
@@ -1919,21 +1919,14 @@ generic_file_buffered_write(struct kiocb
 	do {
 		unsigned long index;
 		unsigned long offset;
+		unsigned long maxlen;
 		size_t copied;
 
 		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
 		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = PAGE_CACHE_SIZE - offset;
-
-		/* Limit the size of the copy to the caller's write size */
-		bytes = min(bytes, count);
-
-		/*
-		 * Limit the size of the copy to that of the current segment,
-		 * because fault_in_pages_readable() doesn't know how to walk
-		 * segments.
-		 */
-		bytes = min(bytes, cur_iov->iov_len - iov_base);
+		if (bytes > count)
+			bytes = count;
 
 		/*
 		 * Bring in the user page that we will copy from _first_.
@@ -1941,7 +1934,10 @@ generic_file_buffered_write(struct kiocb
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		fault_in_pages_readable(buf, bytes);
+		maxlen = cur_iov->iov_len - iov_base;
+		if (maxlen > bytes)
+			maxlen = bytes;
+		fault_in_pages_readable(buf, maxlen);
 
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
 		if (!page) {
_

Patches currently in -mm which might be from akpm@osdl.org are

update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
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
