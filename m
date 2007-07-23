From: akpm@linux-foundation.org
Subject: + clean-up-duplicate-includes-in-kernel.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:16:17 -0700
Message-ID: <200707232316.l6NNGHYr017121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758627AbXGWX0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, paulmck@linux.vnet.ibm.com, ssatyam@cse.iitk.ac.in


The patch titled
     Clean up duplicate includes in kernel/
has been added to the -mm tree.  Its filename is
     clean-up-duplicate-includes-in-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Clean up duplicate includes in kernel/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	kernel/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c    |    1 -
 kernel/exit.c       |    1 -
 kernel/kexec.c      |    1 -
 kernel/rcupdate.c   |    1 -
 kernel/rcutorture.c |    1 -
 kernel/sysctl.c     |    1 -
 kernel/taskstats.c  |    1 -
 kernel/time.c       |    1 -
 8 files changed, 8 deletions(-)

diff -puN kernel/auditsc.c~clean-up-duplicate-includes-in-kernel kernel/auditsc.c
--- a/kernel/auditsc.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/auditsc.c
@@ -45,7 +45,6 @@
 #include <linux/init.h>
 #include <asm/types.h>
 #include <asm/atomic.h>
-#include <asm/types.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/mm.h>
diff -puN kernel/exit.c~clean-up-duplicate-includes-in-kernel kernel/exit.c
--- a/kernel/exit.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/exit.c
@@ -45,7 +45,6 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff -puN kernel/kexec.c~clean-up-duplicate-includes-in-kernel kernel/kexec.c
--- a/kernel/kexec.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/kexec.c
@@ -17,7 +17,6 @@
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
-#include <linux/syscalls.h>
 #include <linux/ioport.h>
 #include <linux/hardirq.h>
 #include <linux/elf.h>
diff -puN kernel/rcupdate.c~clean-up-duplicate-includes-in-kernel kernel/rcupdate.c
--- a/kernel/rcupdate.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/rcupdate.c
@@ -45,7 +45,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 
diff -puN kernel/rcutorture.c~clean-up-duplicate-includes-in-kernel kernel/rcutorture.c
--- a/kernel/rcutorture.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/rcutorture.c
@@ -35,7 +35,6 @@
 #include <linux/sched.h>
 #include <asm/atomic.h>
 #include <linux/bitops.h>
-#include <linux/module.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
diff -puN kernel/sysctl.c~clean-up-duplicate-includes-in-kernel kernel/sysctl.c
--- a/kernel/sysctl.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/sysctl.c
@@ -28,7 +28,6 @@
 #include <linux/capability.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
-#include <linux/capability.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/init.h>
diff -puN kernel/taskstats.c~clean-up-duplicate-includes-in-kernel kernel/taskstats.c
--- a/kernel/taskstats.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/taskstats.c
@@ -20,7 +20,6 @@
 #include <linux/taskstats_kern.h>
 #include <linux/tsacct_kern.h>
 #include <linux/delayacct.h>
-#include <linux/tsacct_kern.h>
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <linux/containerstats.h>
diff -puN kernel/time.c~clean-up-duplicate-includes-in-kernel kernel/time.c
--- a/kernel/time.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/time.c
@@ -34,7 +34,6 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/fs.h>
-#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
git-kbuild.patch
git-mtd.patch
git-selinux.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-hwmon.patch
clean-up-duplicate-includes-in-drivers-input.patch
clean-up-duplicate-includes-in-drivers-media.patch
clean-up-duplicate-includes-in-drivers-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-spi.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-fs-gfs2.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
clean-up-duplicate-includes-in-include-media.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-bridge.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-netfilter.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
clean-up-duplicate-includes-in-sound-core.patch
clean-up-duplicate-includes-in-sound-ppc.patch
clean-up-duplicate-includes-in-sound-soc.patch
