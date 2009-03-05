From: akpm@linux-foundation.org
Subject: + devpts-remove-graffiti.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:29:11 -0800
Message-ID: <200903052229.n25MTBFx008714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbZCEW30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com


The patch titled
     devpts: remove graffiti
has been added to the -mm tree.  Its filename is
     devpts-remove-graffiti.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

xtensa-fix-compilation-somewhat.patch
devpts-remove-graffiti.patch
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

