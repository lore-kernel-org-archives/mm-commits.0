From: akpm@linux-foundation.org
Subject: + docbook-fix-filesystems-content.patch added to -mm tree
Date: Mon, 15 Oct 2007 17:43:36 -0700
Message-ID: <200710160043.l9G0haYd001122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756908AbXJPAn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 20:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, rob@landley.net


The patch titled
     docbook: fix filesystems content
has been added to the -mm tree.  Its filename is
     docbook-fix-filesystems-content.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: docbook: fix filesystems content
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix filesystems docbook warnings.

Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'name'
Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'mode'
Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'parent'
Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'value'
Warning(linux-2.6.23-git8//include/linux/jbd.h:404): No description found for parameter 'h_lockdep_map'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/debugfs/file.c   |   41 +++++++++++++++++++++++++++++++++++------
 include/linux/jbd.h |    1 +
 2 files changed, 36 insertions(+), 6 deletions(-)

diff -puN fs/debugfs/file.c~docbook-fix-filesystems-content fs/debugfs/file.c
--- a/fs/debugfs/file.c~docbook-fix-filesystems-content
+++ a/fs/debugfs/file.c
@@ -227,15 +227,24 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugf
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
 
-/**
- * debugfs_create_x8 - create a debugfs file that is used to read and write an unsigned 8-bit value
- * debugfs_create_x16 - create a debugfs file that is used to read and write an unsigned 16-bit value
- * debugfs_create_x32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+/*
+ * debugfs_create_x{8,16,32} - create a debugfs file that is used to read and write an unsigned {8,16,32}-bit value
  *
- * These functions are exactly the same as the above functions, (but use a hex
- * output for the decimal challenged) for details look at the above unsigned
+ * These functions are exactly the same as the above functions (but use a hex
+ * output for the decimal challenged). For details look at the above unsigned
  * decimal functions.
  */
+
+/**
+ * debugfs_create_x8 - create a debugfs file that is used to read and write an unsigned 8-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
 struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value)
 {
@@ -243,6 +252,16 @@ struct dentry *debugfs_create_x8(const c
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x8);
 
+/**
+ * debugfs_create_x16 - create a debugfs file that is used to read and write an unsigned 16-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
 struct dentry *debugfs_create_x16(const char *name, mode_t mode,
 				 struct dentry *parent, u16 *value)
 {
@@ -250,6 +269,16 @@ struct dentry *debugfs_create_x16(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x16);
 
+/**
+ * debugfs_create_x32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
 struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				 struct dentry *parent, u32 *value)
 {
diff -puN include/linux/jbd.h~docbook-fix-filesystems-content include/linux/jbd.h
--- a/include/linux/jbd.h~docbook-fix-filesystems-content
+++ a/include/linux/jbd.h
@@ -358,6 +358,7 @@ struct jbd_revoke_table_s;
  * @h_sync: flag for sync-on-close
  * @h_jdata: flag to force data journaling
  * @h_aborted: flag indicating fatal error on handle
+ * @h_lockdep_map: lockdep info for debugging lock problems
  **/
 
 /* Docbook can't yet cope with the bit fields, but will leave the documentation
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
git-nfsd.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
comment-typo-in-scripts-kconfig-makefile.patch
docbook-fix-kernel-api-content.patch
docbook-fix-libata-content.patch
docbook-fix-usb-content.patch
docbook-fix-filesystems-content.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
