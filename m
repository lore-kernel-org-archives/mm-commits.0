From: akpm@linux-foundation.org
Subject: + maps4-from-dave-hansen-haveblue-usibmcom.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:57:23 -0700
Message-ID: <200710292157.l9TLvN8P025325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbXJ2V6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, mpm@selenic.com, ralf@linux-mips.org, rientjes@google.com


The patch titled
     maps4: From: Dave Hansen <haveblue@us.ibm.com>
has been added to the -mm tree.  Its filename is
     maps4-from-dave-hansen-haveblue-usibmcom.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps4: From: Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>

The following replaces the earlier patches sent.  It should address
David Rientjes's comments, and has been compile tested on all the
architectures that it touches, save for parisc.

For the /proc/<pid>/pagemap code[1], we need to able to query how
much virtual address space a particular task has.  The trick is
that we do it through /proc and can't use TASK_SIZE since it
references "current" on some arches.  The process opening the
/proc file might be a 32-bit process opening a 64-bit process's
pagemap file.

x86_64 already has a TASK_SIZE_OF() macro:

#define TASK_SIZE_OF(child)     ((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)

I'd like to have that for other architectures.  So, add it
for all the architectures that actually use "current" in
their TASK_SIZE.  For the others, just add a quick #define
in sched.h to use plain old TASK_SIZE.

1. http://www.linuxworld.com/news/2007/042407-kernel.html

- MIPS portion from Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/processor.h    |    3 ++-
 include/asm-mips/processor.h    |    4 ++++
 include/asm-parisc/processor.h  |    3 ++-
 include/asm-powerpc/processor.h |    3 ++-
 include/asm-s390/processor.h    |    3 ++-
 include/linux/sched.h           |    4 ++++
 6 files changed, 16 insertions(+), 4 deletions(-)

diff -puN include/asm-ia64/processor.h~maps4-from-dave-hansen-haveblue-usibmcom include/asm-ia64/processor.h
--- a/include/asm-ia64/processor.h~maps4-from-dave-hansen-haveblue-usibmcom
+++ a/include/asm-ia64/processor.h
@@ -31,7 +31,8 @@
  * each (assuming 8KB page size), for a total of 8TB of user virtual
  * address space.
  */
-#define TASK_SIZE		(current->thread.task_size)
+#define TASK_SIZE_OF(tsk)	((tsk)->thread.task_size)
+#define TASK_SIZE       	TASK_SIZE_OF(current)
 
 /*
  * This decides where the kernel will search for a free chunk of vm
diff -puN include/asm-mips/processor.h~maps4-from-dave-hansen-haveblue-usibmcom include/asm-mips/processor.h
--- a/include/asm-mips/processor.h~maps4-from-dave-hansen-haveblue-usibmcom
+++ a/include/asm-mips/processor.h
@@ -45,6 +45,8 @@ extern unsigned int vced_count, vcei_cou
  * space during mmap's.
  */
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
+#define TASK_SIZE_OF(tsk)						\
+	(test_tsk_thread_flag(tsk, TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
 #ifdef CONFIG_64BIT
@@ -65,6 +67,8 @@ extern unsigned int vced_count, vcei_cou
 #define TASK_UNMAPPED_BASE						\
 	(test_thread_flag(TIF_32BIT_ADDR) ?				\
 		PAGE_ALIGN(TASK_SIZE32 / 3) : PAGE_ALIGN(TASK_SIZE / 3))
+#define TASK_SIZE_OF(tsk)						\
+	(test_tsk_thread_flag(tsk, TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
 #define NUM_FPU_REGS	32
diff -puN include/asm-parisc/processor.h~maps4-from-dave-hansen-haveblue-usibmcom include/asm-parisc/processor.h
--- a/include/asm-parisc/processor.h~maps4-from-dave-hansen-haveblue-usibmcom
+++ a/include/asm-parisc/processor.h
@@ -32,7 +32,8 @@
 #endif
 #define current_text_addr() ({ void *pc; current_ia(pc); pc; })
 
-#define TASK_SIZE               (current->thread.task_size)
+#define TASK_SIZE_OF(tsk)       ((tsk)->thread.task_size)
+#define TASK_SIZE	        TASK_SIZE_OF(current)
 #define TASK_UNMAPPED_BASE      (current->thread.map_base)
 
 #define DEFAULT_TASK_SIZE32	(0xFFF00000UL)
diff -puN include/asm-powerpc/processor.h~maps4-from-dave-hansen-haveblue-usibmcom include/asm-powerpc/processor.h
--- a/include/asm-powerpc/processor.h~maps4-from-dave-hansen-haveblue-usibmcom
+++ a/include/asm-powerpc/processor.h
@@ -99,8 +99,9 @@ extern struct task_struct *last_task_use
  */
 #define TASK_SIZE_USER32 (0x0000000100000000UL - (1*PAGE_SIZE))
 
-#define TASK_SIZE (test_thread_flag(TIF_32BIT) ? \
+#define TASK_SIZE_OF(tsk) (test_tsk_thread_flag(tsk, TIF_32BIT) ? \
 		TASK_SIZE_USER32 : TASK_SIZE_USER64)
+#define TASK_SIZE	  TASK_SIZE_OF(current)
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
diff -puN include/asm-s390/processor.h~maps4-from-dave-hansen-haveblue-usibmcom include/asm-s390/processor.h
--- a/include/asm-s390/processor.h~maps4-from-dave-hansen-haveblue-usibmcom
+++ a/include/asm-s390/processor.h
@@ -73,8 +73,9 @@ extern struct task_struct *last_task_use
 
 #else /* __s390x__ */
 
-# define TASK_SIZE		(test_thread_flag(TIF_31BIT) ? \
+# define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_31BIT) ? \
 					(0x80000000UL) : (0x40000000000UL))
+# define TASK_SIZE		TASK_SIZE_OF(current)
 # define TASK_UNMAPPED_BASE	(TASK_SIZE / 2)
 # define DEFAULT_TASK_SIZE	(0x40000000000UL)
 
diff -puN include/linux/sched.h~maps4-from-dave-hansen-haveblue-usibmcom include/linux/sched.h
--- a/include/linux/sched.h~maps4-from-dave-hansen-haveblue-usibmcom
+++ a/include/linux/sched.h
@@ -1986,6 +1986,10 @@ static inline void inc_syscw(struct task
 }
 #endif
 
+#ifndef TASK_SIZE_OF
+#define TASK_SIZE_OF(tsk)	TASK_SIZE
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-from-dave-hansen-haveblue-usibmcom.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
