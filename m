From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:08:49 -0700
Message-ID: <55354ec1.omhX8oUhDrE9GvIf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbbDTTIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/Kbuild |    1 +
 fs/affs/amigaffs.c             |    2 +-
 fs/befs/linuxvfs.c             |    4 ++--
 fs/hfsplus/xattr.c             |    8 ++++----
 4 files changed, 8 insertions(+), 7 deletions(-)

diff -puN arch/parisc/include/asm/Kbuild~linux-next-rejects arch/parisc/include/asm/Kbuild
--- a/arch/parisc/include/asm/Kbuild~linux-next-rejects
+++ a/arch/parisc/include/asm/Kbuild
@@ -20,6 +20,7 @@ generic-y += param.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += preempt.h
+generic-y += scatterlist.h
 generic-y += seccomp.h
 generic-y += segment.h
 generic-y += topology.h
diff -puN fs/affs/amigaffs.c~linux-next-rejects fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~linux-next-rejects
+++ a/fs/affs/amigaffs.c
@@ -471,7 +471,7 @@ affs_warning(struct super_block *sb, con
 bool
 affs_nofilenametruncate(const struct dentry *dentry)
 {
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = d_inode(dentry);
 
 	return affs_test_opt(AFFS_SB(inode->i_sb)->s_flags, SF_NO_TRUNCATE);
 
diff -puN fs/befs/linuxvfs.c~linux-next-rejects fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~linux-next-rejects
+++ a/fs/befs/linuxvfs.c
@@ -471,7 +471,7 @@ static void *
 befs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct super_block *sb = dentry->d_sb;
-	struct befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
+	struct befs_inode_info *befs_ino = BEFS_I(d_inode(dentry));
 	befs_data_stream *data = &befs_ino->i_data.ds;
 	befs_off_t len = data->size;
 	char *link;
@@ -501,7 +501,7 @@ befs_follow_link(struct dentry *dentry,
 static void *
 befs_fast_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	struct befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
+	struct befs_inode_info *befs_ino = BEFS_I(d_inode(dentry));
 
 	nd_set_link(nd, befs_ino->i_data.symlink);
 	return NULL;
diff -puN fs/hfsplus/xattr.c~linux-next-rejects fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~linux-next-rejects
+++ a/fs/hfsplus/xattr.c
@@ -440,7 +440,7 @@ int hfsplus_setxattr(struct dentry *dent
 		return -ENOMEM;
 	strcpy(xattr_name, prefix);
 	strcpy(xattr_name + prefixlen, name);
-	res = __hfsplus_setxattr(dentry->d_inode, xattr_name, value, size,
+	res = __hfsplus_setxattr(d_inode(dentry), xattr_name, value, size,
 				 flags);
 	kfree(xattr_name);
 	return res;
@@ -600,7 +600,7 @@ ssize_t hfsplus_getxattr(struct dentry *
 	strcpy(xattr_name, prefix);
 	strcpy(xattr_name + prefixlen, name);
 
-	res = __hfsplus_getxattr(dentry->d_inode, xattr_name, value, size);
+	res = __hfsplus_getxattr(d_inode(dentry), xattr_name, value, size);
 	kfree(xattr_name);
 	return res;
 
@@ -868,7 +868,7 @@ static int hfsplus_osx_getxattr(struct d
 	 * creates), so we pass the name through unmodified (after
 	 * ensuring it doesn't conflict with another namespace).
 	 */
-	return __hfsplus_getxattr(dentry->d_inode, name, buffer, size);
+	return __hfsplus_getxattr(d_inode(dentry), name, buffer, size);
 }
 
 static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
@@ -890,7 +890,7 @@ static int hfsplus_osx_setxattr(struct d
 	 * creates), so we pass the name through unmodified (after
 	 * ensuring it doesn't conflict with another namespace).
 	 */
-	return __hfsplus_setxattr(dentry->d_inode, name, buffer, size, flags);
+	return __hfsplus_setxattr(d_inode(dentry), name, buffer, size, flags);
 }
 
 static size_t hfsplus_osx_listxattr(struct dentry *dentry, char *list,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

