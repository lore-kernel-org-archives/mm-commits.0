From: akpm@osdl.org
Subject: - ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:48:59 -0800
Message-ID: <200612080848.kB88mxc2013878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425183AbWLHItO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch

This patch was dropped because it was folded into ecryptfs-use-fsstacks-generic-copy-inode-attr.patch

------------------------------------------------------
Subject: ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix
From: Andrew Morton <akpm@osdl.org>

Cc: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 ecryptfs/main.c      |    0 
 fs/ecryptfs/dentry.c |    3 ++-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ecryptfs/dentry.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix
+++ a/fs/ecryptfs/dentry.c
@@ -25,6 +25,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/fs_stack.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -61,7 +62,7 @@ static int ecryptfs_d_revalidate(struct 
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
 
-		fsstack_copy_attr_all(dentry->d_inode, lower_inode);
+		fsstack_copy_attr_all(dentry->d_inode, lower_inode, NULL);
 	}
 out:
 	return rc;
diff -puN fs/ecryptfs/inode.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix fs/ecryptfs/inode.c
diff -puN fs/ecryptfs/main.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix fs/ecryptfs/main.c
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

