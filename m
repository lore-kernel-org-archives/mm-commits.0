From: akpm@linux-foundation.org
Subject: [folded] rwsem-fix-rwsem_is_locked-bugs-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:07:49 -0800
Message-ID: <200912150107.nBF17nZA013333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162AbZLOBIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:08:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amwang@redhat.com, behlendorf1@llnl.gov, bwoodard@llnl.gov, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rwsem-fix-rwsem_is_locked-bugs-fix
has been removed from the -mm tree.  Its filename was
     rwsem-fix-rwsem_is_locked-bugs-fix.patch

This patch was dropped because it was folded into rwsem-fix-rwsem_is_locked-bugs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rwsem-fix-rwsem_is_locked-bugs-fix
From: Andrew Morton <akpm@linux-foundation.org>

simplify

Cc: Amerigo Wang <amwang@redhat.com>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs-fix include/linux/rwsem-spinlock.h
--- a/include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs-fix
+++ a/include/linux/rwsem-spinlock.h
@@ -68,9 +68,7 @@ extern int __down_write_trylock(struct r
 extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
-extern int __rwsem_is_locked(struct rw_semaphore *sem);
-
-#define rwsem_is_locked(sem) __rwsem_is_locked(sem)
+extern int rwsem_is_locked(struct rw_semaphore *sem);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff -puN lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs-fix lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs-fix
+++ a/lib/rwsem-spinlock.c
@@ -17,7 +17,7 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
-int __rwsem_is_locked(struct rw_semaphore *sem)
+int rwsem_is_locked(struct rw_semaphore *sem)
 {
 	int ret = 1;
 	unsigned long flags;
@@ -28,7 +28,7 @@ int __rwsem_is_locked(struct rw_semaphor
 	}
 	return ret;
 }
-EXPORT_SYMBOL(__rwsem_is_locked);
+EXPORT_SYMBOL(rwsem_is_locked);
 
 /*
  * initialise the semaphore
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
cs5535-add-a-generic-mfgpt-driver-fix.patch
cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

