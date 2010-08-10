From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 10 Aug 2010 12:44:15 -0700
Message-ID: <201008101942.o7AJgYCd012402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab0HJTmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Aug 2010 15:42:36 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o7AJgYPE015816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 10 Aug 2010 12:42:35 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |    4 +---
 arch/x86/kernel/syscall_table_32.S |    5 +----
 fs/exofs/inode.c                   |    4 ----
 fs/xfs/linux-2.6/xfs_aops.c        |   17 -----------------
 include/asm-generic/unistd.h       |    4 ----
 5 files changed, 2 insertions(+), 32 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -5284,21 +5284,19 @@ M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
 F:	drivers/net/smc91x.*
 
-<<<<<<< HEAD
 SMM665 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/smm665
 F:	drivers/hwmon/smm665.c
-=======
+
 SMSC EMC2103 HARDWARE MONITOR DRIVER
 M:	Steve Glendinning <steve.glendinning@smsc.com>
 L:	lm-sensors@lm-sensors.org
 S:	Supported
 F:	Documentation/hwmon/emc2103
 F:	drivers/hwmon/emc2103.c
->>>>>>> FETCH_HEAD
 
 SMSC47B397 HARDWARE MONITOR DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
diff -puN arch/x86/kernel/syscall_table_32.S~linux-next-git-rejects arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~linux-next-git-rejects
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -339,8 +339,5 @@ ENTRY(sys_call_table)
 	.long sys_recvmmsg
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
-<<<<<<< HEAD
-	.long sys_prlimit64
-=======
 	.long sys_prlimit64		/* 340 */
->>>>>>> FETCH_HEAD
+
diff -puN fs/exofs/inode.c~linux-next-git-rejects fs/exofs/inode.c
--- a/fs/exofs/inode.c~linux-next-git-rejects
+++ a/fs/exofs/inode.c
@@ -713,11 +713,7 @@ int exofs_write_begin(struct file *file,
 		ret = simple_write_begin(file, mapping, pos, len, flags, pagep,
 					 fsdata);
 		if (ret) {
-<<<<<<< HEAD
-			EXOFS_DBGMSG("simple_write_begin faild\n");
-=======
 			EXOFS_DBGMSG("simple_write_begin failed\n");
->>>>>>> FETCH_HEAD
 			goto out;
 		}
 
diff -puN fs/xfs/linux-2.6/xfs_aops.c~linux-next-git-rejects fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~linux-next-git-rejects
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -1479,28 +1479,16 @@ xfs_vm_direct_IO(
 		iocb->private = xfs_alloc_ioend(inode, IO_NEW);
 
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-<<<<<<< HEAD
-					    offset, nr_segs,
-					    xfs_get_blocks_direct,
-					    xfs_end_io_direct_write, NULL, 0);
-=======
 					   offset, nr_segs,
 					   xfs_get_blocks_direct,
 					   xfs_end_io_direct_write, NULL, 0);
->>>>>>> FETCH_HEAD
 		if (ret != -EIOCBQUEUED && iocb->private)
 			xfs_destroy_ioend(iocb->private);
 	} else {
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-<<<<<<< HEAD
-					    offset, nr_segs,
-					    xfs_get_blocks_direct,
-					    NULL, NULL, 0);
-=======
 					   offset, nr_segs,
 					   xfs_get_blocks_direct,
 					   NULL, NULL, 0);
->>>>>>> FETCH_HEAD
 	}
 
 	return ret;
@@ -1534,13 +1522,8 @@ xfs_vm_write_begin(
 {
 	int			ret;
 
-<<<<<<< HEAD
-	ret = block_write_begin(mapping, pos, len, flags | AOP_FLAG_NOFS,
-				pagep, xfs_get_blocks);
-=======
 	ret = block_write_begin(mapping, pos, len, flags | AOP_FLAG_NOFS, pagep,
 				xfs_get_blocks);
->>>>>>> FETCH_HEAD
 	if (unlikely(ret))
 		xfs_vm_write_failed(mapping, pos + len);
 	return ret;
diff -puN include/asm-generic/unistd.h~linux-next-git-rejects include/asm-generic/unistd.h
--- a/include/asm-generic/unistd.h~linux-next-git-rejects
+++ a/include/asm-generic/unistd.h
@@ -644,11 +644,7 @@ __SYSCALL(__NR_wait4, sys_wait4)
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
 
 #undef __NR_syscalls
-<<<<<<< HEAD
 #define __NR_syscalls 262
-=======
-#define __NR_syscalls 261
->>>>>>> FETCH_HEAD
 
 /*
  * All syscalls below here should go away really,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-igafbc-make-igafb_setup-and-igafb_init-static.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

