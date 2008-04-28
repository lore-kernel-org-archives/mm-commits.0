From: akpm@linux-foundation.org
Subject: - make-ext3_xattr_list-static.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:33 -0700
Message-ID: <200804282200.m3SM0XHR018711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965630AbYD1WAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make ext3_xattr_list() static
has been removed from the -mm tree.  Its filename was
     make-ext3_xattr_list-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make ext3_xattr_list() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global ext3_xattr_list() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/xattr.c |    4 +++-
 fs/ext3/xattr.h |    7 -------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN fs/ext3/xattr.c~make-ext3_xattr_list-static fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~make-ext3_xattr_list-static
+++ a/fs/ext3/xattr.c
@@ -99,6 +99,8 @@ static struct buffer_head *ext3_xattr_ca
 						 struct mb_cache_entry **);
 static void ext3_xattr_rehash(struct ext3_xattr_header *,
 			      struct ext3_xattr_entry *);
+static int ext3_xattr_list(struct inode *inode, char *buffer,
+			   size_t buffer_size);
 
 static struct mb_cache *ext3_xattr_cache;
 
@@ -427,7 +429,7 @@ cleanup:
  * Returns a negative error number on failure, or the number of bytes
  * used / required on success.
  */
-int
+static int
 ext3_xattr_list(struct inode *inode, char *buffer, size_t buffer_size)
 {
 	int i_error, b_error;
diff -puN fs/ext3/xattr.h~make-ext3_xattr_list-static fs/ext3/xattr.h
--- a/fs/ext3/xattr.h~make-ext3_xattr_list-static
+++ a/fs/ext3/xattr.h
@@ -67,7 +67,6 @@ extern struct xattr_handler ext3_xattr_s
 extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
 
 extern int ext3_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ext3_xattr_list(struct inode *, char *, size_t);
 extern int ext3_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext3_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
 
@@ -89,12 +88,6 @@ ext3_xattr_get(struct inode *inode, int 
 }
 
 static inline int
-ext3_xattr_list(struct inode *inode, void *buffer, size_t size)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int
 ext3_xattr_set(struct inode *inode, int name_index, const char *name,
 	       const void *value, size_t size, int flags)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
arch-x86-video-fbdevc-add-module_license.patch
git-m32r.patch
git-nfsd.patch
git-ocfs2.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-pci.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
reiser4.patch

