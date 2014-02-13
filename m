From: akpm@linux-foundation.org
Subject: + sys_sysfs-add-config_sysfs_syscall.patch added to -mm tree
Date: Thu, 13 Feb 2014 14:22:12 -0800
Message-ID: <52fd4594.q9cYVxtsK9eQTrXb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMWWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 17:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: + sys_sysfs-add-config_sysfs_syscall.patch added to -mm tree
To: fabf@skynet.be,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 14:22:12 -0800


The patch titled
     Subject: sys_sysfs: Add CONFIG_SYSFS_SYSCALL
has been added to the -mm tree.  Its filename is
     sys_sysfs-add-config_sysfs_syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sys_sysfs-add-config_sysfs_syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sys_sysfs-add-config_sysfs_syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: sys_sysfs: Add CONFIG_SYSFS_SYSCALL

sys_sysfs is an obsolete system call no longer supported by libc.

- This patch adds a default CONFIG_SYSFS_SYSCALL=y

- Option can be turned off in expert mode.

- cond_syscall added to kernel/sys_ni.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/filesystems.c |    2 ++
 init/Kconfig     |   10 ++++++++++
 kernel/sys_ni.c  |    1 +
 3 files changed, 13 insertions(+)

diff -puN fs/filesystems.c~sys_sysfs-add-config_sysfs_syscall fs/filesystems.c
--- a/fs/filesystems.c~sys_sysfs-add-config_sysfs_syscall
+++ a/fs/filesystems.c
@@ -121,6 +121,7 @@ int unregister_filesystem(struct file_sy
 
 EXPORT_SYMBOL(unregister_filesystem);
 
+#ifdef CONFIG_SYSFS_SYSCALL
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
@@ -199,6 +200,7 @@ SYSCALL_DEFINE3(sysfs, int, option, unsi
 	}
 	return retval;
 }
+#endif
 
 int __init get_filesystem_list(char *buf)
 {
diff -puN init/Kconfig~sys_sysfs-add-config_sysfs_syscall init/Kconfig
--- a/init/Kconfig~sys_sysfs-add-config_sysfs_syscall
+++ a/init/Kconfig
@@ -1290,6 +1290,16 @@ config UID16
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
+config SYSFS_SYSCALL
+	bool "Sysfs syscall support" if EXPERT
+	default y
+	---help---
+	  sys_sysfs is an obsolete system call no longer supported in
+	  libc.Note that disabling this option while being more secure breaks
+	  compatibility with other systems.
+
+	  If unsure say Y here.
+
 config SYSCTL_SYSCALL
 	bool "Sysctl syscall support" if EXPERT
 	depends on PROC_SYSCTL
diff -puN kernel/sys_ni.c~sys_sysfs-add-config_sysfs_syscall kernel/sys_ni.c
--- a/kernel/sys_ni.c~sys_sysfs-add-config_sysfs_syscall
+++ a/kernel/sys_ni.c
@@ -146,6 +146,7 @@ cond_syscall(sys_io_destroy);
 cond_syscall(sys_io_submit);
 cond_syscall(sys_io_cancel);
 cond_syscall(sys_io_getevents);
+cond_syscall(sys_sysfs);
 cond_syscall(sys_syslog);
 cond_syscall(sys_process_vm_readv);
 cond_syscall(sys_process_vm_writev);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

