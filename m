From: akpm@linux-foundation.org
Subject: - fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:44:10 -0800
Message-ID: <200802080843.m188hpiO016127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755852AbYBHIoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:44:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs-remove-fastcall-it-is-always-empty-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-remove-fastcall-it-is-always-empty.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-remove-fastcall-it-is-always-empty-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#188: FILE: fs/namei.c:827:
+static int __link_path_walk(const char * name, struct nameidata *nd)

ERROR: "foo * bar" should be "foo *bar"
#206: FILE: fs/namei.c:1043:
+static int path_walk(const char * name, struct nameidata *nd)

ERROR: "foo * bar" should be "foo *bar"
#263: FILE: fs/open.c:1017:
+void fd_install(unsigned int fd, struct file * file)

total: 3 errors, 0 warnings, 209 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    4 ++--
 fs/open.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/namei.c~fs-remove-fastcall-it-is-always-empty-checkpatch-fixes fs/namei.c
--- a/fs/namei.c~fs-remove-fastcall-it-is-always-empty-checkpatch-fixes
+++ a/fs/namei.c
@@ -833,7 +833,7 @@ fail:
  * Returns 0 and nd will have valid dentry and mnt on success.
  * Returns error and drops reference to input namei data on failure.
  */
-static int __link_path_walk(const char * name, struct nameidata *nd)
+static int __link_path_walk(const char *name, struct nameidata *nd)
 {
 	struct path next;
 	struct inode *inode;
@@ -1051,7 +1051,7 @@ static int link_path_walk(const char *na
 	return result;
 }
 
-static int path_walk(const char * name, struct nameidata *nd)
+static int path_walk(const char *name, struct nameidata *nd)
 {
 	current->total_link_count = 0;
 	return link_path_walk(name, nd);
diff -puN fs/open.c~fs-remove-fastcall-it-is-always-empty-checkpatch-fixes fs/open.c
--- a/fs/open.c~fs-remove-fastcall-it-is-always-empty-checkpatch-fixes
+++ a/fs/open.c
@@ -1050,7 +1050,7 @@ EXPORT_SYMBOL(put_unused_fd);
  * will follow.
  */
 
-void fd_install(unsigned int fd, struct file * file)
+void fd_install(unsigned int fd, struct file *file)
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
pid-sys_wait-fixes-v2.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
rewrite-rd.patch
fs-remove-fastcall-it-is-always-empty.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
