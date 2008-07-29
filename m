From: akpm@linux-foundation.org
Subject: + configure-out-aio-support.patch added to -mm tree
Date: Tue, 29 Jul 2008 16:59:59 -0700
Message-ID: <200807300000.m6TNxxWr028907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbYG3AAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:00:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com, bcrl@kvack.org, mpm@selenic.com, zach.brown@oracle.com


The patch titled
     Configure out AIO support
has been added to the -mm tree.  Its filename is
     configure-out-aio-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Configure out AIO support
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

This patchs adds the CONFIG_AIO option which allows to remove support
for asynchronous I/O operations, that are not necessarly used by
applications, particularly on embedded devices. As this is a
size-reduction option, it depends on CONFIG_EMBEDDED. It allows to
save ~7 kilobytes of kernel code/data:

   text	   data	    bss	    dec	    hex	filename
1115067	 119180	 217088	1451335	 162547	vmlinux
1108025	 119048	 217088	1444161	 160941	vmlinux.new
  -7042    -132       0   -7174   -1C06 +/-

This patch has been originally written by Matt Mackall
<mpm@selenic.com>, and is part of the Linux Tiny project.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile         |    3 ++-
 include/linux/aio.h |    9 +++++++++
 init/Kconfig        |    8 ++++++++
 kernel/sys_ni.c     |    5 +++++
 kernel/sysctl.c     |    2 ++
 5 files changed, 26 insertions(+), 1 deletion(-)

diff -puN fs/Makefile~configure-out-aio-support fs/Makefile
--- a/fs/Makefile~configure-out-aio-support
+++ a/fs/Makefile
@@ -8,7 +8,7 @@
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o fifo.o locks.o dcache.o inode.o \
-		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
+		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o
@@ -27,6 +27,7 @@ obj-$(CONFIG_ANON_INODES)	+= anon_inodes
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
+obj-$(CONFIG_AIO)               += aio.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
diff -puN include/linux/aio.h~configure-out-aio-support include/linux/aio.h
--- a/include/linux/aio.h~configure-out-aio-support
+++ a/include/linux/aio.h
@@ -204,12 +204,21 @@ struct kioctx {
 /* prototypes */
 extern unsigned aio_max_size;
 
+#ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
 extern int aio_put_req(struct kiocb *iocb);
 extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
+#else
+static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
+static inline int aio_put_req(struct kiocb *iocb) { return 0; }
+static inline void kick_iocb(struct kiocb *iocb) { }
+static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
+struct mm_struct;
+static inline void exit_aio(struct mm_struct *mm) { }
+#endif /* CONFIG_AIO */
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
diff -puN init/Kconfig~configure-out-aio-support init/Kconfig
--- a/init/Kconfig~configure-out-aio-support
+++ a/init/Kconfig
@@ -734,6 +734,14 @@ config SHMEM
 	  option replaces shmem and tmpfs with the much simpler ramfs code,
 	  which may be appropriate on small systems without swap.
 
+config AIO
+	bool "Enable AIO support" if EMBEDDED
+	default y
+	help
+	  This option enables POSIX asynchronous I/O which may by used
+          by some high performance threaded applications. Disabling
+          this option saves about 7k.
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
diff -puN kernel/sys_ni.c~configure-out-aio-support kernel/sys_ni.c
--- a/kernel/sys_ni.c~configure-out-aio-support
+++ a/kernel/sys_ni.c
@@ -125,6 +125,11 @@ cond_syscall(sys_vm86old);
 cond_syscall(sys_vm86);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
+cond_syscall(sys_io_setup);
+cond_syscall(sys_io_destroy);
+cond_syscall(sys_io_submit);
+cond_syscall(sys_io_cancel);
+cond_syscall(sys_io_getevents);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
diff -puN kernel/sysctl.c~configure-out-aio-support kernel/sysctl.c
--- a/kernel/sysctl.c~configure-out-aio-support
+++ a/kernel/sysctl.c
@@ -1312,6 +1312,7 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
@@ -1326,6 +1327,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
+#endif /* CONFIG_AIO */
 #ifdef CONFIG_INOTIFY_USER
 	{
 		.ctl_name	= FS_INOTIFY,
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

configure-out-aio-support.patch
configure-out-file-locking-features.patch
configure-out-ethtool-support.patch
configure-out-igmp-support.patch

