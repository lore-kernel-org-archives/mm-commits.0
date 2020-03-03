From: akpm@linux-foundation.org
Subject: +
 vfs-partially-revert-dont-allow-writes-to-swap-files.patch added to -mm
 tree
Date: Tue, 03 Mar 2020 15:48:10 -0800
Message-ID: <20200303234810.GG6UOWaBb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgCCXsL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 18:48:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, domenico.andreoli@linux.com, hch@lst.de, len.brown@intel.com, mkleinsoft@gmail.com, mm-commits@vger.kernel.org, pavel@ucw.cz, rjw@rjwysocki.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs: partially revert "don't allow writes to swap files"
has been added to the -mm tree.  Its filename is
     vfs-partially-revert-dont-allow-writes-to-swap-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-partially-revert-dont-allow-writes-to-swap-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-partially-revert-dont-allow-writes-to-swap-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: vfs: partially revert "don't allow writes to swap files"

In commit dc617f29dbe5 ("vfs: don't allow writes to swap files") we tried
to prevent userspace programs from writing to active swap devices. 
However, it turns out that userspace hibernation requires the ability to
write the hibernation image to a swap device, so revert the write path
checks.

Link: http://lkml.kernel.org/r/20200303191023.GD8037@magnolia
Fixes: dc617f29dbe5 ("vfs: don't allow writes to swap files")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Domenico Andreoli <domenico.andreoli@linux.com>
Reported-by: Marian Klein <mkleinsoft@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    3 ---
 mm/filemap.c   |    3 ---
 mm/memory.c    |    4 ----
 mm/mmap.c      |    8 ++------
 4 files changed, 2 insertions(+), 16 deletions(-)

--- a/fs/block_dev.c~vfs-partially-revert-dont-allow-writes-to-swap-files
+++ a/fs/block_dev.c
@@ -2001,9 +2001,6 @@ ssize_t blkdev_write_iter(struct kiocb *
 	if (bdev_read_only(I_BDEV(bd_inode)))
 		return -EPERM;
 
-	if (IS_SWAPFILE(bd_inode))
-		return -ETXTBSY;
-
 	if (!iov_iter_count(from))
 		return 0;
 
--- a/mm/filemap.c~vfs-partially-revert-dont-allow-writes-to-swap-files
+++ a/mm/filemap.c
@@ -2920,9 +2920,6 @@ inline ssize_t generic_write_checks(stru
 	loff_t count;
 	int ret;
 
-	if (IS_SWAPFILE(inode))
-		return -ETXTBSY;
-
 	if (!iov_iter_count(from))
 		return 0;
 
--- a/mm/memory.c~vfs-partially-revert-dont-allow-writes-to-swap-files
+++ a/mm/memory.c
@@ -2376,10 +2376,6 @@ static vm_fault_t do_page_mkwrite(struct
 
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 
-	if (vmf->vma->vm_file &&
-	    IS_SWAPFILE(vmf->vma->vm_file->f_mapping->host))
-		return VM_FAULT_SIGBUS;
