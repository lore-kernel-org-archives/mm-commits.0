From: akpm@linux-foundation.org
Subject: [merged] devpts-remove-graffiti.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:33 -0700
Message-ID: <200903111809.n2BI9Xq1019953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbZCKSTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     devpts: remove graffiti
has been removed from the -mm tree.  Its filename was
     devpts-remove-graffiti.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: remove graffiti
From: Alexey Dobriyan <adobriyan@gmail.com>

Very annoying when working with containters.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/devpts/inode.c~devpts-remove-graffiti fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-remove-graffiti
+++ a/fs/devpts/inode.c
@@ -198,9 +198,6 @@ static int mknod_ptmx(struct super_block
 
 	fsi->ptmx_dentry = dentry;
 	rc = 0;
-
-	printk(KERN_DEBUG "Created ptmx node in devpts ino %lu\n",
-			inode->i_ino);
 out:
 	mutex_unlock(&root->d_inode->i_mutex);
 	return rc;
@@ -369,8 +366,6 @@ static int new_pts_mount(struct file_sys
 	struct pts_fs_info *fsi;
 	struct pts_mount_opts *opts;
 
-	printk(KERN_NOTICE "devpts: newinstance mount\n");
-
 	err = get_sb_nodev(fs_type, flags, data, devpts_fill_super, mnt);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch
linux-next.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
memdup_user-introduce.patch
memdup_user-introduce-fix.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

