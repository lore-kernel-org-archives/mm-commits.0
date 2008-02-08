From: akpm@linux-foundation.org
Subject: - proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:35:11 -0800
Message-ID: <200802080834.m188YqQZ015835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756942AbYBHIfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:35:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@sw.ru, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch

This patch was dropped because it was folded into proc-fix-openless-usage-due-to-proc_fops-flip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need space after that ',' (ctx:VxV)
#87: FILE: fs/proc/generic.c:608:
+	ent = __proc_create(&parent,name,
 	                           ^

ERROR: need space after that ',' (ctx:VxV)
#105: FILE: fs/proc/generic.c:667:
+	ent = __proc_create(&parent,name,mode,nlink);
 	                           ^

ERROR: need space after that ',' (ctx:VxV)
#105: FILE: fs/proc/generic.c:667:
+	ent = __proc_create(&parent,name,mode,nlink);
 	                                ^

ERROR: need space after that ',' (ctx:VxV)
#105: FILE: fs/proc/generic.c:667:
+	ent = __proc_create(&parent,name,mode,nlink);
 	                                     ^

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#172: FILE: fs/proc/root.c:235:
+EXPORT_SYMBOL(proc_create);

WARNING: line over 80 characters
#183: FILE: include/linux/proc_fs.h:129:
+struct proc_dir_entry *proc_create(const char *name, mode_t mode, struct proc_dir_entry *parent, const struct file_operations *proc_fops);

WARNING: line over 80 characters
#192: FILE: include/linux/proc_fs.h:222:
+static inline struct proc_dir_entry *proc_create(const char *name, mode_t mode, struct proc_dir_entry *parent, const struct file_operations *proc_fops)

total: 4 errors, 3 warnings, 108 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    4 ++--
 include/linux/proc_fs.h |    8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/proc/generic.c~proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes fs/proc/generic.c
--- a/fs/proc/generic.c~proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes
+++ a/fs/proc/generic.c
@@ -605,7 +605,7 @@ struct proc_dir_entry *proc_symlink(cons
 {
 	struct proc_dir_entry *ent;
 
-	ent = __proc_create(&parent,name,
+	ent = __proc_create(&parent, name,
 			  (S_IFLNK | S_IRUGO | S_IWUGO | S_IXUGO),1);
 
 	if (ent) {
@@ -664,7 +664,7 @@ struct proc_dir_entry *create_proc_entry
 		nlink = 1;
 	}
 
-	ent = __proc_create(&parent,name,mode,nlink);
+	ent = __proc_create(&parent, name, mode, nlink);
 	if (ent) {
 		if (proc_register(parent, ent) < 0) {
 			kfree(ent);
diff -puN include/linux/proc_fs.h~proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes
+++ a/include/linux/proc_fs.h
@@ -126,7 +126,9 @@ void de_put(struct proc_dir_entry *de);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
-struct proc_dir_entry *proc_create(const char *name, mode_t mode, struct proc_dir_entry *parent, const struct file_operations *proc_fops);
+struct proc_dir_entry *proc_create(const char *name, mode_t mode,
+				struct proc_dir_entry *parent,
+				const struct file_operations *proc_fops);
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
 
 extern struct vfsmount *proc_mnt;
@@ -221,7 +223,9 @@ static inline void proc_flush_task(struc
 
 static inline struct proc_dir_entry *create_proc_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *parent) { return NULL; }
-static inline struct proc_dir_entry *proc_create(const char *name, mode_t mode, struct proc_dir_entry *parent, const struct file_operations *proc_fops)
+static inline struct proc_dir_entry *proc_create(const char *name,
+	mode_t mode, struct proc_dir_entry *parent,
+	const struct file_operations *proc_fops)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
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
