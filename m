From: akpm@osdl.org
Subject: - remove-the-syslog-interface-when-printk-is-disabled.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:59 -0800
Message-ID: <200612072304.kB7N4xKM030106@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52291 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163877AbWLGXFC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, mm-commits@vger.kernel.org


The patch titled
     remove the syslog interface when printk is disabled
has been removed from the -mm tree.  Its filename was
     remove-the-syslog-interface-when-printk-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove the syslog interface when printk is disabled
From: Mike Galbraith <efault@gmx.de>

Attempts to read() from the non-existent dmesg buffer will return zero and
userspace tends to get stuck in a busyloop.

So just remove /dev/kmsg altogether if CONFIG_PRINTK=n.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/Makefile    |    3 ++-
 fs/proc/proc_misc.c |    2 ++
 kernel/printk.c     |    7 +------
 3 files changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/proc/Makefile~remove-the-syslog-interface-when-printk-is-disabled fs/proc/Makefile
--- a/fs/proc/Makefile~remove-the-syslog-interface-when-printk-is-disabled
+++ a/fs/proc/Makefile
@@ -8,8 +8,9 @@ proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
-		kmsg.o proc_tty.o proc_misc.o
+		proc_tty.o proc_misc.o
 
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
+proc-$(CONFIG_PRINTK)	+= kmsg.o
diff -puN fs/proc/proc_misc.c~remove-the-syslog-interface-when-printk-is-disabled fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~remove-the-syslog-interface-when-printk-is-disabled
+++ a/fs/proc/proc_misc.c
@@ -696,9 +696,11 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
+#ifdef CONFIG_PRINTK
 	entry = create_proc_entry("kmsg", S_IRUSR, &proc_root);
 	if (entry)
 		entry->proc_fops = &proc_kmsg_operations;
+#endif
 	create_seq_entry("devices", 0, &proc_devinfo_operations);
 	create_seq_entry("cpuinfo", 0, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
diff -puN kernel/printk.c~remove-the-syslog-interface-when-printk-is-disabled kernel/printk.c
--- a/kernel/printk.c~remove-the-syslog-interface-when-printk-is-disabled
+++ a/kernel/printk.c
@@ -631,12 +631,7 @@ EXPORT_SYMBOL(vprintk);
 
 asmlinkage long sys_syslog(int type, char __user *buf, int len)
 {
-	return 0;
-}
-
-int do_syslog(int type, char __user *buf, int len)
-{
-	return 0;
+	return -ENOSYS;
 }
 
 static void call_console_drivers(unsigned long start, unsigned long end)
_

Patches currently in -mm which might be from efault@gmx.de are

origin.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-improve-migration-accuracy-fix.patch
readahead-call-scheme.patch

