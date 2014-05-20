From: akpm@linux-foundation.org
Subject: + sync-only-the-requested-range-in-msync.patch added to -mm tree
Date: Tue, 20 May 2014 16:01:24 -0700
Message-ID: <537bdec4.sLC4puLA/MoWEuki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaETXBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 May 2014 19:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmoyer@redhat.com, hch@lst.de, clm@fb.com, matthew.r.wilcox@intel.com

Subject: + sync-only-the-requested-range-in-msync.patch added to -mm tree
To: matthew.r.wilcox@intel.com,clm@fb.com,hch@lst.de,jmoyer@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 20 May 2014 16:01:24 -0700


The patch titled
     Subject: mm/msync.c: sync only the requested range in msync()
has been added to the -mm tree.  Its filename is
     sync-only-the-requested-range-in-msync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sync-only-the-requested-range-in-msync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sync-only-the-requested-range-in-msync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: mm/msync.c: sync only the requested range in msync()

msync() currently syncs more than POSIX requires or BSD or Solaris
implement.  It is supposed to be equivalent to fdatasync(), not fsync(),
and it is only supposed to sync the portion of the file that overlaps the
range passed to msync.

If the VMA is non-linear, fall back to syncing the entire file, but we
still optimise to only fdatasync() the entire file, not the full fsync().

akpm: there are obvious concerns with bck-compatibility: is anyone relying
on the undocumented side-effect for their data integrity?  And how would
they ever know if this change broke their data integrity?

We think the risk is reasonably low, and this patch brings the kernel into
line with other OS's and with what the manpage has always said...

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/msync.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/msync.c~sync-only-the-requested-range-in-msync mm/msync.c
--- a/mm/msync.c~sync-only-the-requested-range-in-msync
+++ a/mm/msync.c
@@ -58,6 +58,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 	vma = find_vma(mm, start);
 	for (;;) {
 		struct file *file;
+		loff_t fstart, fend;
 
 		/* Still start < end. */
 		error = -ENOMEM;
@@ -77,12 +78,17 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 			goto out_unlock;
 		}
 		file = vma->vm_file;
+		fstart = start + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+		fend = fstart + (min(end, vma->vm_end) - start) - 1;
 		start = vma->vm_end;
 		if ((flags & MS_SYNC) && file &&
 				(vma->vm_flags & VM_SHARED)) {
 			get_file(file);
 			up_read(&mm->mmap_sem);
-			error = vfs_fsync(file, 0);
+			if (vma->vm_flags & VM_NONLINEAR)
+				error = vfs_fsync(file, 1);
+			else
+				error = vfs_fsync_range(file, fstart, fend, 1);
 			fput(file);
 			if (error || start >= end)
 				goto out;
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
fs-bufferc-remove-block_write_full_page_endio.patch
fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch
fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch
fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
brd-add-support-for-rw_page.patch
brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
sync-only-the-requested-range-in-msync.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

