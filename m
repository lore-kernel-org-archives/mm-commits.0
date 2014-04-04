From: akpm@linux-foundation.org
Subject: [merged] sys_sysfs-add-config_sysfs_syscall.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:32:20 -0700
Message-ID: <533f08c4.Ung7w5g5KGAaxd5i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaDDTcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: [merged] sys_sysfs-add-config_sysfs_syscall.patch removed from -mm tree
To: fabf@skynet.be,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:20 -0700


The patch titled
     Subject: sys_sysfs: Add CONFIG_SYSFS_SYSCALL
has been removed from the -mm tree.  Its filename was
     sys_sysfs-add-config_sysfs_syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: sys_sysfs: Add CONFIG_SYSFS_SYSCALL

sys_sysfs is an obsolete system call no longer supported by libc.

- This patch adds a default CONFIG_SYSFS_SYSCALL=y

- Option can be turned off in expert mode.

- cond_syscall added to kernel/sys_ni.c

[akpm@linux-foundation.org: tweak Kconfig help text]
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
+	  sys_sysfs is an obsolete system call no longer supported in libc.
+	  Note that disabling this option is more secure but might break
+	  compatibility with some systems.
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

origin.patch
ntfs-logging-clean-up.patch
mm-memblockc-use-pfn_phys.patch
mm-readaheadc-inline-ra_submit.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
affs-mount-option-to-avoid-filename-truncates.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

