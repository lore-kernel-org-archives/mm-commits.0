From: akpm@linux-foundation.org
Subject: + vfs-dont-hold-s_umount-over-close_bdev_exclusive-call.patch added to -mm tree
Date: Tue, 25 May 2010 16:06:44 -0700
Message-ID: <201005252306.o4PN6i8X020502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab0EYXHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 19:07:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, docan@eden.rutgers.edu, jens.axboe@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: don't hold s_umount over close_bdev_exclusive() call
has been added to the -mm tree.  Its filename is
     vfs-dont-hold-s_umount-over-close_bdev_exclusive-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: don't hold s_umount over close_bdev_exclusive() call
From: Tejun Heo <tj@kernel.org>

Fix an obscure AB-BA deadlock in get_sb_bdev().

When a superblock is mounted more than once get_sb_bdev() calls
close_bdev_exclusive() to drop the extra bdev reference while holding
s_umount.  However, sb->s_umount nests inside bd_mutex during
__invalidate_device() and close_bdev_exclusive() acquires bd_mutex during
blkdev_put(); thus creating an AB-BA deadlock.

This condition doesn't trigger frequently.  For this condition to be
visible to lockdep, the filesystem must occupy the whole device (as
__invalidate_device() only grabs bd_mutex for the whole device), the FS
must be mounted more than once and partition rescan should be issued while
the FS is still mounted.

Fix it by dropping s_umount over close_bdev_exclusive().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ciprian Docan <docan@eden.rutgers.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/super.c~vfs-dont-hold-s_umount-over-close_bdev_exclusive-call fs/super.c
--- a/fs/super.c~vfs-dont-hold-s_umount-over-close_bdev_exclusive-call
+++ a/fs/super.c
@@ -767,7 +767,16 @@ int get_sb_bdev(struct file_system_type 
 			goto error_bdev;
 		}
 
+		/*
+		 * s_umount nests inside bd_mutex during
+		 * __invalidate_device().  close_bdev_exclusive()
+		 * acquires bd_mutex and can't be called under
+		 * s_umount.  Drop s_umount temporarily.  This is safe
+		 * as we're holding an active reference.
+		 */
+		up_write(&s->s_umount);
 		close_bdev_exclusive(bdev, mode);
+		down_write(&s->s_umount);
 	} else {
 		char b[BDEVNAME_SIZE];
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
vfs-dont-hold-s_umount-over-close_bdev_exclusive-call.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch
idr-fix-backtrack-logic-in-idr_remove_all.patch
idr-fix-backtrack-logic-in-idr_remove_all-update.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch

