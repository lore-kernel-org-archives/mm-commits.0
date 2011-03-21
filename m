From: akpm@linux-foundation.org
Subject: [merged] introduce-sys_syncfs-to-sync-a-single-file-system.patch removed from -mm tree
Date: Mon, 21 Mar 2011 12:16:33 -0700
Message-ID: <201103211919.p2LJJmTX020225__29484.080678276$1300735245$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab1CUTUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sage@newdream.net, aneesh.kumar@linux.vnet.ibm.com, arnd@arndb.de, hch@lst.de, jrnieder@gmail.com, linux-arch@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, mm-comm


The patch titled
     introduce sys_syncfs() to sync a single file system
has been removed from the -mm tree.  Its filename was
     introduce-sys_syncfs-to-sync-a-single-file-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce sys_syncfs() to sync a single file system
From: Sage Weil <sage@newdream.net>

It is frequently useful to sync a single file system, instead of all
mounted file systems via sync(2):

 - On machines with many mounts, it is not at all uncommon for some of
   them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
   those and may never get to the one you do care about (e.g., /).
 - Some applications write lots of data to the file system and then
   want to make sure it is flushed to disk.  Calling fsync(2) on each
   file introduces unnecessary ordering constraints that result in a large
   amount of sub-optimal writeback/flush/commit behavior by the file
   system.

There are currently two ways (that I know of) to sync a single super_block:

 - BLKFLSBUF ioctl on the block device: That also invalidates the bdev
   mapping, which isn't usually desirable, and doesn't work for non-block
   file systems.
 - 'mount -o remount,rw' will call sync_filesystem as an artifact of the
   current implemention.  Relying on this little-known side effect for
   something like data safety sounds foolish.

Both of these approaches require root privileges, which some applications
do not have (nor should they need?) given that sync(2) is an unprivileged
operation.

This patch introduces a new system call syncfs(2) that takes an fd and
syncs only the file system it references.  Maybe someday we can

 $ sync /some/path

and not get

 sync: ignoring all arguments

The syscall is motivated by comments by Al and Christoph at the last LSF.
syncfs(2) seems like an appropriate name given statfs(2).

A similar ioctl was also proposed a while back, see
	http://marc.info/?l=linux-fsdevel&m=127970513829285&w=2

Signed-off-by: Sage Weil <sage@newdream.net>
Reviewed-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/sync.c                          |   24 ++++++++++++++++++++++++
 5 files changed, 30 insertions(+), 1 deletion(-)

diff -puN arch/x86/ia32/ia32entry.S~introduce-sys_syncfs-to-sync-a-single-file-system arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~introduce-sys_syncfs-to-sync-a-single-file-system
+++ a/arch/x86/ia32/ia32entry.S
@@ -847,4 +847,5 @@ ia32_sys_call_table:
 	.quad sys_name_to_handle_at
 	.quad compat_sys_open_by_handle_at
 	.quad compat_sys_clock_adjtime
+	.quad sys_syncfs
 ia32_syscall_end:
diff -puN arch/x86/include/asm/unistd_32.h~introduce-sys_syncfs-to-sync-a-single-file-system arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~introduce-sys_syncfs-to-sync-a-single-file-system
+++ a/arch/x86/include/asm/unistd_32.h
@@ -349,10 +349,11 @@
 #define __NR_name_to_handle_at	341
 #define __NR_open_by_handle_at  342
 #define __NR_clock_adjtime	343
+#define __NR_syncfs		344
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 344
+#define NR_syscalls 345
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN arch/x86/include/asm/unistd_64.h~introduce-sys_syncfs-to-sync-a-single-file-system arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~introduce-sys_syncfs-to-sync-a-single-file-system
+++ a/arch/x86/include/asm/unistd_64.h
@@ -675,6 +675,8 @@ __SYSCALL(__NR_name_to_handle_at, sys_na
 __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 #define __NR_clock_adjtime			305
 __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
+#define __NR_syncfs				306
+__SYSCALL(__NR_syncfs, sys_syncfs)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff -puN arch/x86/kernel/syscall_table_32.S~introduce-sys_syncfs-to-sync-a-single-file-system arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~introduce-sys_syncfs-to-sync-a-single-file-system
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -343,3 +343,4 @@ ENTRY(sys_call_table)
 	.long sys_name_to_handle_at
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
+	.long sys_syncfs
diff -puN fs/sync.c~introduce-sys_syncfs-to-sync-a-single-file-system fs/sync.c
--- a/fs/sync.c~introduce-sys_syncfs-to-sync-a-single-file-system
+++ a/fs/sync.c
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/syscalls.h>
@@ -128,6 +129,29 @@ void emergency_sync(void)
 	}
 }
 
+/*
+ * sync a single super
+ */
+SYSCALL_DEFINE1(syncfs, int, fd)
+{
+	struct file *file;
+	struct super_block *sb;
+	int ret;
+	int fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return -EBADF;
+	sb = file->f_dentry->d_sb;
+
+	down_read(&sb->s_umount);
+	ret = sync_filesystem(sb);
+	up_read(&sb->s_umount);
+
+	fput_light(file, fput_needed);
+	return ret;
+}
+
 /**
  * vfs_fsync_range - helper to sync a range of data & metadata to disk
  * @file:		file to sync
_

Patches currently in -mm which might be from sage@newdream.net are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch

