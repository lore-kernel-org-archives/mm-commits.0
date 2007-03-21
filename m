From: akpm@linux-foundation.org
Subject: - complain-about-missing-system-calls.patch removed from -mm tree
Date: Wed, 21 Mar 2007 15:55:34 -0700
Message-ID: <200703212255.l2LMtYK6006160@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57647 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbXCUW4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, ak@suse.de, anton@samba.org, davem@davemloft.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Complain about missing system calls.
has been removed from the -mm tree.  Its filename was
     complain-about-missing-system-calls.patch

This patch was dropped because dwmw2 has a git tree

------------------------------------------------------
Subject: Complain about missing system calls.
From: David Woodhouse <dwmw2@infradead.org>

Most system calls seem to get added to i386 first.  This patch
automatically generates a warning for any new system call which is
implemented on i386 but not the architecture currently being compiled.  On
PowerPC at the moment, for example, it results in these warnings:

init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented

[davem@davemloft.net: sparc64 updates]
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Makefile           |   15 ++++++-
 init/missing_syscalls.c |   73 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 2 deletions(-)

diff -puN init/Makefile~complain-about-missing-system-calls init/Makefile
--- a/init/Makefile~complain-about-missing-system-calls
+++ a/init/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y                          := main.o version.o mounts.o
+obj-y                          := main.o version.o mounts.o missing_syscalls.o
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
@@ -16,11 +16,12 @@ mounts-$(CONFIG_BLK_DEV_INITRD)	+= do_mo
 mounts-$(CONFIG_BLK_DEV_MD)	+= do_mounts_md.o
 
 # files to be removed upon make clean
-clean-files := ../include/linux/compile.h
+clean-files := ../include/linux/compile.h $(obj)/missing_syscalls.h
 
 # dependencies on generated files need to be listed explicitly
 
 $(obj)/version.o: include/linux/compile.h
+$(obj)/missing_syscalls.o: $(obj)/missing_syscalls.h include/linux/compile.h FORCE
 
 # compile.h changes depending on hostname, generation number, etc,
 # so we regenerate it always.
@@ -31,3 +32,13 @@ include/linux/compile.h: FORCE
 	@echo '  CHK     $@'
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkcompile_h $@ \
 	"$(UTS_MACHINE)" "$(CONFIG_SMP)" "$(CONFIG_PREEMPT)" "$(CC) $(CFLAGS)"
+
+
+quiet_cmd_missing_syscalls = GEN     $@
+      cmd_missing_syscalls = sed -n '/^\#define/s/[^_]*__NR_\([^[:space:]]*\).*/\
+	\#if !defined (__NR_\1) \&\& !defined (__IGNORE_\1)\n\
+	\#warning syscall \1 not implemented\n\
+	\#endif/p' $(srctree)/include/asm-i386/unistd.h >$@
+targets += missing_syscalls.h
+$(obj)/missing_syscalls.h: include/asm-i386/unistd.h
+	$(call if_changed,missing_syscalls)
diff -puN /dev/null init/missing_syscalls.c
--- /dev/null
+++ a/init/missing_syscalls.c
@@ -0,0 +1,73 @@
+#include <asm/types.h>
+#include <asm/unistd.h>
+
+/* Force recompilation (and thus warnings) every time we rebuild the kernel */
+#include <linux/compile.h>
+
+/* System calls for 32-bit kernels only */
+#if BITS_PER_LONG == 64
+#define __IGNORE_sendfile64
+#define __IGNORE_ftruncate64
+#define __IGNORE_truncate64
+#define __IGNORE_stat64
+#define __IGNORE_lstat64
+#define __IGNORE_fstat64
+#define __IGNORE_fcntl64
+#define __IGNORE_fadvise64_64
+#define __IGNORE_fstatat64
+#endif
+
+/* i386-specific or historical system calls */
+#define __IGNORE_break
+#define __IGNORE_stty
+#define __IGNORE_gtty
+#define __IGNORE_ftime
+#define __IGNORE_prof
+#define __IGNORE_lock
+#define __IGNORE_mpx
+#define __IGNORE_ulimit
+#define __IGNORE_profil
+#define __IGNORE_ioperm
+#define __IGNORE_iopl
+#define __IGNORE_idle
+#define __IGNORE_modify_ldt
+#define __IGNORE_getpmsg
+#define __IGNORE_putpmsg
+#define __IGNORE_ugetrlimit
+#define __IGNORE_mmap2
+#define __IGNORE_vm86
+#define __IGNORE_vm86old
+#define __IGNORE_set_thread_area
+#define __IGNORE_get_thread_area
+#define __IGNORE_madvise1
+#define __IGNORE_oldstat
+#define __IGNORE_oldfstat
+#define __IGNORE_oldlstat
+#define __IGNORE_oldolduname
+#define __IGNORE_olduname
+#define __IGNORE_umount2
+/* ... including the "new" 32-bit uid syscalls */
+#define __IGNORE_lchown32
+#define __IGNORE_getuid32
+#define __IGNORE_getgid32
+#define __IGNORE_geteuid32
+#define __IGNORE_getegid32
+#define __IGNORE_setreuid32
+#define __IGNORE_setregid32
+#define __IGNORE_getgroups32
+#define __IGNORE_setgroups32
+#define __IGNORE_fchown32
+#define __IGNORE_setresuid32
+#define __IGNORE_getresuid32
+#define __IGNORE_setresgid32
+#define __IGNORE_getresgid32
+#define __IGNORE_chown32
+#define __IGNORE_setuid32
+#define __IGNORE_setgid32
+#define __IGNORE_setfsuid32
+#define __IGNORE_setfsgid32
+
+/* Not yet upstream */
+#define __IGNORE_vserver
+
+#include "missing_syscalls.h"
_

Patches currently in -mm which might be from dwmw2@infradead.org are

git-mtd.patch
mtd-pmc-msp71xx-flash-rootfs-mappings.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
complain-about-missing-system-calls.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
