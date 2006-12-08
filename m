From: akpm@osdl.org
Subject: - fsstack-introduce-fsstack_copy_attrinode_-tidy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:47:36 -0800
Message-ID: <200612080847.kB88lahe013851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36816 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425197AbWLHIsA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:48:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fsstack-introduce-fsstack_copy_attrinode_-tidy
has been removed from the -mm tree.  Its filename was
     fsstack-introduce-fsstack_copy_attrinode_-tidy.patch

This patch was dropped because it was folded into fsstack-introduce-fsstack_copy_attrinode_.patch

------------------------------------------------------
Subject: fsstack-introduce-fsstack_copy_attrinode_-tidy
From: Andrew Morton <akpm@osdl.org>

Remove unneeded wrapper.

Cc: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/stack.c               |   10 ++++------
 include/linux/fs_stack.h |   12 ++----------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff -puN fs/stack.c~fsstack-introduce-fsstack_copy_attrinode_-tidy fs/stack.c
--- a/fs/stack.c~fsstack-introduce-fsstack_copy_attrinode_-tidy
+++ a/fs/stack.c
@@ -11,13 +11,13 @@ void fsstack_copy_inode_size(struct inod
 	i_size_write(dst, i_size_read((struct inode *)src));
 	dst->i_blocks = src->i_blocks;
 }
+EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
 /* copy all attributes; get_nlinks is optional way to override the i_nlink
  * copying
  */
-void __fsstack_copy_attr_all(struct inode *dest,
-			     const struct inode *src,
-			     int (*get_nlinks)(struct inode *))
+void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
+				int (*get_nlinks)(struct inode *))
 {
 	if (!get_nlinks)
 		dest->i_nlink = src->i_nlink;
@@ -34,6 +34,4 @@ void __fsstack_copy_attr_all(struct inod
 	dest->i_blkbits = src->i_blkbits;
 	dest->i_flags = src->i_flags;
 }
-
-EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
-EXPORT_SYMBOL_GPL(__fsstack_copy_attr_all);
+EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
diff -puN include/linux/fs_stack.h~fsstack-introduce-fsstack_copy_attrinode_-tidy include/linux/fs_stack.h
--- a/include/linux/fs_stack.h~fsstack-introduce-fsstack_copy_attrinode_-tidy
+++ a/include/linux/fs_stack.h
@@ -8,9 +8,8 @@
 #include <linux/fs.h>
 
 /* externs for fs/stack.c */
-extern void __fsstack_copy_attr_all(struct inode *dest,
-				    const struct inode *src,
-				    int (*get_nlinks)(struct inode *));
+extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
+				int (*get_nlinks)(struct inode *));
 
 extern void fsstack_copy_inode_size(struct inode *dst, const struct inode *src);
 
@@ -29,11 +28,4 @@ static inline void fsstack_copy_attr_tim
 	dest->i_ctime = src->i_ctime;
 }
 
-static inline void fsstack_copy_attr_all(struct inode *dest,
-					 const struct inode *src)
-{
-	__fsstack_copy_attr_all(dest, src, NULL);
-}
-
 #endif /* _LINUX_FS_STACK_H */
-
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
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

