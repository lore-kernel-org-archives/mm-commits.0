From: akpm@linux-foundation.org
Subject: [merged] fs-dont-compile-in-drop_cachesc-when-config_sysctl=n.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:09 -0700
Message-ID: <20130430184709.74B6C5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:38096 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3D3SrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:10 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so84884qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: don't compile in drop_caches.c when CONFIG_SYSCTL=n
has been removed from the -mm tree.  Its filename was
     fs-dont-compile-in-drop_cachesc-when-config_sysctl=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: fs: don't compile in drop_caches.c when CONFIG_SYSCTL=n

drop_caches.c provides code only invokable via sysctl, so don't compile it
in when CONFIG_SYSCTL=n.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile        |    3 ++-
 include/linux/mm.h |    4 ++++
 kernel/sysctl.c    |    1 -
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/Makefile~fs-dont-compile-in-drop_cachesc-when-config_sysctl=n fs/Makefile
--- a/fs/Makefile~fs-dont-compile-in-drop_cachesc-when-config_sysctl=n
+++ a/fs/Makefile
@@ -10,7 +10,7 @@ obj-y :=	open.o read_write.o file_table.
 		ioctl.o readdir.o select.o fifo.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
-		pnode.o drop_caches.o splice.o sync.o utimes.o \
+		pnode.o splice.o sync.o utimes.o \
 		stack.o fs_struct.o statfs.o
 
 ifeq ($(CONFIG_BLOCK),y)
@@ -49,6 +49,7 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 obj-$(CONFIG_COREDUMP)		+= coredump.o
+obj-$(CONFIG_SYSCTL)		+= drop_caches.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 
diff -puN include/linux/mm.h~fs-dont-compile-in-drop_cachesc-when-config_sysctl=n include/linux/mm.h
--- a/include/linux/mm.h~fs-dont-compile-in-drop_cachesc-when-config_sysctl=n
+++ a/include/linux/mm.h
@@ -1731,8 +1731,12 @@ int in_gate_area_no_mm(unsigned long add
 #define in_gate_area(mm, addr) ({(void)mm; in_gate_area_no_mm(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+#ifdef CONFIG_SYSCTL
+extern int sysctl_drop_caches;
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+#endif
+
 unsigned long shrink_slab(struct shrink_control *shrink,
 			  unsigned long nr_pages_scanned,
 			  unsigned long lru_pages);
diff -puN kernel/sysctl.c~fs-dont-compile-in-drop_cachesc-when-config_sysctl=n kernel/sysctl.c
--- a/kernel/sysctl.c~fs-dont-compile-in-drop_cachesc-when-config_sysctl=n
+++ a/kernel/sysctl.c
@@ -106,7 +106,6 @@ extern unsigned int core_pipe_limit;
 #endif
 extern int pid_max;
 extern int pid_max_min, pid_max_max;
-extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
linux-next.patch
fs-make-binfmt-support-for-scripts-modular-and-removable.patch

